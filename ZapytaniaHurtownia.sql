--------------------------------------------- ROLLUP ---------------------------------------------

-- Liczba pacjentow pochodzacych z okreslonego oddzialu NFZ, chorujacych na dana chorobe, 
-- ktorzy naleza do placowki Prodimed
SELECT c.nazwa AS nazwa_choroby, r.nazwa_oddzialu AS nazwa_oddzialu_nfz, p.nazwa, COUNT (w.pacjent_id) AS liczba_pacjentow FROM h_wizyty w
JOIN h_recepty r ON r.recepta_id = w.recepta_id
JOIN h_choroby c ON c.choroby_id = r.choroba_id
JOIN h_gabinety g ON g.gabinet_id = w.gabinet_id
JOIN h_placowki p ON p.placowka_id = g.placowka_id
WHERE p.nazwa LIKE 'Prodimed'
GROUP BY ROLLUP (c.nazwa, r.nazwa_oddzialu, p.nazwa);

-- Liczba pracownikow pracujacych na danym stanowisku, posiadajacych okreslone uprawnienia,
-- mieszkajacych w Kielcach
SELECT s.nazwa AS nazwa_stanowiska, s.opis_uprawnienia AS typ_uprawnienia, p.miasto, COUNT (*) AS liczba_pracownikow FROM h_pracownicy p
JOIN h_stanowiska s ON s.stanowisko_id = p.stanowisko_id
WHERE p.miasto LIKE 'Kielce'
GROUP BY ROLLUP (s.nazwa, s.opis_uprawnienia, p.miasto);

-- Liczba wizyt pacjentow ze schorzeniem osteoporozy, w danej placowce oraz w danym miescie
SELECT c.nazwa AS nazwa_choroby, p.nazwa AS nazwa_placowki, p.miasto, COUNT (w.wizyta_id) AS liczba_wizyt FROM h_wizyty w
JOIN h_recepty r ON w.recepta_id = r.recepta_id
JOIN h_choroby c ON c.choroby_id = r.choroba_id
JOIN h_gabinety g ON g.gabinet_id = w.gabinet_id
JOIN h_placowki p ON p.placowka_id = g.placowka_id
WHERE g.oznaczenie LIKE 'Wizyty%'
GROUP BY ROLLUP (c.nazwa, p.nazwa, p.miasto);

--------------------------------------------- CUBE ---------------------------------------------------

-- Srednia oplata wizyt danego pacjenta, w placowce, w danym miescie
SELECT pac.nazwisko AS nazwisko_pacjenta, p.nazwa AS nazwa_placowki, p.miasto, AVG (w.oplata) AS srednia_oplata FROM h_wizyty w
JOIN h_pacjenci pac ON pac.pacjent_id = w.pacjent_id
JOIN h_gabinety g ON g.gabinet_id = w.gabinet_id
JOIN h_placowki p ON p.placowka_id = g.placowka_id
WHERE g.oznaczenie LIKE 'Wizyty%'
GROUP BY CUBE (pac.nazwisko, p.nazwa, p.miasto);

-- Srednia oplata zabiegow danego pacjenta, w placowce, w danym miescie
SELECT pac.nazwisko AS nazwisko_pacjenta, p.nazwa AS nazwa_placowki, p.miasto, AVG (w.cena_netto_za_zabieg) AS srednia_oplata FROM h_wizyty w
JOIN h_pacjenci pac ON pac.pacjent_id = w.pacjent_id
JOIN h_gabinety g ON g.gabinet_id = w.gabinet_id
JOIN h_placowki p ON p.placowka_id = g.placowka_id
WHERE g.oznaczenie LIKE 'Zabiegi'
GROUP BY CUBE (pac.nazwisko, p.nazwa, p.miasto);

-- Srednia oplata za leki danego pacjenta, w danym miescie, chorujacego na okreslona chorobe
SELECT pac.nazwisko AS nazwisko_pacjenta, pac.miasto, c.nazwa AS nazwa_choroby, AVG (pr.odplatnosc) AS srednia_oplata_za_leki FROM h_pozycje_recept pr
JOIN h_recepty r ON pr.recepta_id = r.recepta_id
RIGHT JOIN h_wizyty w ON w.recepta_id = r.recepta_id
JOIN h_pacjenci pac ON pac.pacjent_id = w.pacjent_id
JOIN h_choroby c ON c.choroby_id = r.choroba_id
GROUP BY CUBE (pac.nazwisko, pac.miasto, c.nazwa);

---------------------------------------------- PARTYCJE OBLICZENIOWE ----------------------------------------------------------------

--Łączna wartość roczna za każdy zabieg przeprowadzany na pacjentach z grupą krwi A-
SELECT DISTINCT z.nazwa Nazwa,d.rok Rok,p.grupa_krwi,SUM(CNZ)OVER(PARTITION BY d.rok,p.grupa_krwi,z.nazwa) CNZ FROM
(SELECT wizyta_id WID,pacjent_id PID,zabieg_id ZID,SUM(cena_netto_za_zabieg) CNZ,data_wizyty_id DID 
FROM h_wizyty WHERE zabieg_id IS NOT NULL AND pacjent_id IN (SELECT pacjent_id FROM h_pacjenci WHERE h_pacjenci.grupa_krwi = 'A-') 
GROUP BY wizyta_id,pacjent_id,zabieg_id,data_wizyty_id)
,h_zabiegi z,h_daty_wizyt d,h_pacjenci p 
WHERE z.zabieg_id = ZID AND d.data_id = DID AND p.pacjent_id  = PID
ORDER BY Nazwa,Rok DESC;

--Id pacjenta,jego imie ,nazwisko , pesel oraz jego Wydatki na leki wciągu jednego roku z ulgą/bez ulgi
SELECT DISTINCT PID AS Pacjent_ID,imie,nazwisko,pesel AS Pesel_id,rok AS Rok,
SUM(ODP) OVER (PARTITION BY PID,rok) AS "Wydatki Pacjenta Na Leki Bez Ulgi",
(SUM(ODP) OVER (PARTITION BY PID,rok) * (PUL / 100) ) AS "Wydatki Pacjenta Na Leki Z Wliczona Ulga" FROM
(SELECT p.pacjent_id PID,p.imie imie,p.nazwisko nazwisko,p.pesel pesel,d.rok rok,SUM(pr.odplatnosc) ODP,pr.procent_ulgi PUL FROM 
(SELECT pacjent_id PID,data_wizyty_id DID ,recepta_id RID  FROM h_wizyty w WHERE recepta_id IS NOT NULL),h_pacjenci p,h_daty_wizyt d,h_pozycje_recept pr 
WHERE p.pacjent_id = PID AND d.data_id = DID AND pr.recepta_id = RID
GROUP BY p.pacjent_id,p.imie,p.nazwisko,p.pesel,d.rok,pr.procent_ulgi)
ORDER BY PID ASC,Rok DESC;

-- Procentowy udzial oplat za wizyte, w danym roku, w okreslonej placowce, znajdujacej sie w okreslonym miescie, na przestrzeni wszystkich lat
SELECT DISTINCT PID AS Placowka_id, nazwa AS nazwa_placowki, miasto AS miasto, rok as rok, 
SUM (OPL) OVER (PARTITION BY rok, PID, miasto) suma_w_danym_roku,
SUM (OPL) OVER (PARTITION BY PID, miasto) suma_na_przestrzeni_lat,
ROUND (100 * (SUM (OPL) OVER (PARTITION BY rok, PID, miasto)) / SUM (OPL) OVER (PARTITION BY PID, miasto))
"UDZIAL % danego roku" FROM
(SELECT placowka_id PID, p.nazwa nazwa,p.miasto miasto,d.rok rok, SUM(OPL) OPL FROM
(SELECT gabinet_id GID,SUM(oplata) OPL,data_wizyty_id DID FROM h_wizyty GROUP BY gabinet_id,data_wizyty_id),
h_placowki p,h_daty_wizyt d WHERE p.placowka_id IN (SELECT placowka_id FROM h_gabinety WHERE gabinet_id = GID) AND d.data_id = DID
GROUP BY placowka_id,p.nazwa,p.miasto,d.rok)
ORDER BY PID ASC, rok DESC;

--------------------------------------------- OKNA OBLICZENIOWE----------------------------------------------------------------------
--Zlicza ilość wizyt przeprowadzonych ,recept wypisanych oraz zabiegów w danym roku od 15 dni przed do 15 dni po aktualnej dacie wizyty
SELECT DISTINCT
d.rok AS Rok ,
d.miesiac AS Miesiac ,
d.data_wizyty AS Data,
COUNT(WID) OVER (PARTITION BY d.rok ORDER BY d.data_wizyty DESC RANGE BETWEEN INTERVAL '15' DAY PRECEDING AND INTERVAL '15' DAY FOLLOWING) AS Ilosc_wizyt,
COUNT(ZID) OVER (PARTITION BY d.rok ORDER BY d.data_wizyty DESC RANGE BETWEEN INTERVAL '15' DAY PRECEDING AND INTERVAL '15' DAY FOLLOWING) AS Ilosc_zabiegow,
COUNT(RID) OVER (PARTITION BY d.rok ORDER BY d.data_wizyty DESC RANGE BETWEEN INTERVAL '15' DAY PRECEDING AND INTERVAL '15' DAY FOLLOWING) AS Ilosc_recept 
FROM (SELECT wizyta_id WID,zabieg_id ZID,recepta_id RID,data_wizyty_id DID FROM h_wizyty GROUP BY wizyta_id,zabieg_id,recepta_id,data_wizyty_id),
h_daty_wizyt d WHERE d.data_id = DID 
ORDER BY Rok DESC , Miesiac ASC;

--Wypisuje nazwę choroby, jej ID , Rok przeszukiwań danych,Ilość znalezionych rekordów od początku tabeli do aktualnego rekordu z uwzględnieniem nazwy oraz roku, oraz dane Pacjenta
SELECT DISTINCT
Nazwa AS Nazwa_Choroby,
CID choroby_id,
EXTRACT(YEAR FROM CP) Rok,
WID AS wizyta_id,
COUNT(*) OVER (PARTITION BY Nazwa,EXTRACT(YEAR FROM CP) ORDER BY CID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "Ilość zapadnięć na tę chorobę w tym roku do aktualnego rekordu  wizyty",
ROUND(100 * COUNT(*) OVER (PARTITION BY Nazwa,EXTRACT(YEAR FROM CP) ORDER BY CID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / COUNT(*) OVER (PARTITION BY Nazwa,EXTRACT(YEAR FROM CP) ) , 3) "Udzial % w tym roku",
COUNT(*) OVER (PARTITION BY Nazwa,EXTRACT(YEAR FROM CP) ) "Łaczna wartość zapadnięć na tę chorobę w tym roku",
ROUND(100 * COUNT(*) OVER (PARTITION BY Nazwa,EXTRACT(YEAR FROM CP) ) / COUNT(*) OVER (PARTITION BY Nazwa) , 3) "Udzial % na tle lat",
COUNT(*) OVER (PARTITION BY Nazwa) "Łaczna wartość zapadnięć na tę chorobę na przestrzeni lat",
PGK AS "Grupa Krwi Pacjenta",
PIMIE AS Imie,
PNAZ AS Nazwisko
FROM
(SELECT WID WID,CID CID,Nazwa Nazwa,CP CP,p.grupa_krwi PGK,p.imie PIMIE,p.nazwisko PNAZ FROM
(SELECT wizyta_id WID,pacjent_id PID,CID CID,Nazwa Nazwa,CP CP FROM
(SELECT CID CID,Nazwa Nazwa,CP CP,recepta_id RID FROM
(SELECT choroby_id CID,nazwa Nazwa,poczatek CP FROM h_choroby ),h_recepty WHERE h_recepty.choroba_id = CID),h_wizyty WHERE h_wizyty.recepta_id = RID),h_pacjenci p WHERE p.pacjent_id = PID )
ORDER BY Rok DESC,COUNT(*) OVER (PARTITION BY Nazwa,EXTRACT(YEAR FROM CP) ORDER BY CID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) DESC;

--Opłaty,ceny leków i zabiegów dla każdej wizyty oraz sumaryczna wartość dotychczasowych wizyt
SELECT DISTINCT
WID wizyta_id,
p.pesel,
p.imie,
p.nazwisko,
OPL "Oplata za wizytę pacjenta",
SUM(pr.odplatnosc) OVER (PARTITION  BY WID) "Cena leków",
(pr.procent_ulgi / 100 * (SUM(pr.odplatnosc) OVER (PARTITION  BY WID))) "Cena leków Po Uldze",
SUM(OPL) OVER ( ORDER BY WID RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) "Suma wszystkich dotychczasowych oplat za wizyty pacjentów",
CNZ "Oplata za zabieg pacjenta",
SUM(CNZ) OVER (ORDER BY WID RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) "Suma wszystkich dotychczasowych oplat za zabiegi"
FROM
(SELECT wizyta_id WID,oplata OPL,cena_netto_za_zabieg CNZ,pacjent_id PID,recepta_id RID FROM h_wizyty WHERE recepta_id IS NULL OR recepta_id IS NOT NULL
GROUP BY wizyta_id,pacjent_id,recepta_id,oplata,cena_netto_za_zabieg ),
h_pozycje_recept pr,h_pacjenci p WHERE pr.recepta_id = RID  AND p.pacjent_id = PID 
ORDER BY WID ASC;
--------------------------------------------- FUNKCJE RANKINGOWE ---------------------------------------------------------------------

-- Ranking pacjentow, ktorzy wniesli najwiecej oplat za wizyte w danej placowce, w danym miescie
SELECT pac.nazwisko AS nazwisko_pacjenta, p.nazwa AS nazwa_placowki, p.miasto, w.oplata AS oplata_za_wizyte,
RANK () OVER (PARTITION BY p.nazwa, p.miasto ORDER BY w.oplata DESC)
ranking FROM h_wizyty w
JOIN h_pacjenci pac ON pac.pacjent_id = w.pacjent_id
JOIN h_gabinety g ON g.gabinet_id = w.gabinet_id
JOIN h_placowki p ON p.placowka_id = g.placowka_id
ORDER BY pac.nazwisko, ranking;

-- Ranking najlepszej sredniej sprzedazy lekow na dana chorobe z dana ulga
SELECT l.nazwa AS nazwa_leku, c.nazwa AS nazwa_choroby, u.typ_ulgi, AVG (pr.ilosc),
RANK () OVER (PARTITION BY c.nazwa, u.typ_ulgi ORDER BY AVG (pr.ilosc) DESC)
ranking FROM h_pozycje_recept pr
JOIN h_leki l ON l.leki_id = pr.lek_id
JOIN h_ulgi u ON u.ulgi_id = pr.ulga_id
JOIN h_recepty r ON r.recepta_id = pr.recepta_id
JOIN h_choroby c ON c.choroby_id = r.choroba_id
GROUP BY ROLLUP (l.nazwa, c.nazwa, u.typ_ulgi)
ORDER BY c.nazwa, ranking;

-- Ranking zabiegow, ktore zostaly wykonane przez neurologa, w danej placowce oraz w danym miescie
SELECT z.nazwa AS nazwa_zabiegu, pr.nazwisko, p.nazwa AS nazwa_placowki, p.miasto, w.cena_netto_za_zabieg AS oplata_za_zabieg,
RANK () OVER (PARTITION BY p.nazwa, p.miasto ORDER BY w.cena_netto_za_zabieg DESC)
ranking FROM h_wizyty w
JOIN h_zabiegi z ON w.zabieg_id = z.zabieg_id
JOIN h_pracownicy pr ON pr.pracownik_id = w.prac_spec
JOIN h_stanowiska s ON s.stanowisko_id = pr.stanowisko_id
JOIN h_gabinety g ON g.gabinet_id = w.gabinet_id
JOIN h_placowki p ON p.placowka_id = g.placowka_id
WHERE s.nazwa LIKE 'Neurolog'
ORDER BY z.nazwa, ranking;








