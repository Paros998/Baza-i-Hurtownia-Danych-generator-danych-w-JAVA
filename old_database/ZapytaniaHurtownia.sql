--------------------------------------------- ROLLUP ---------------------------------------------

-- Ilosc wizyt ze statusem 'zakonczona' w kazdym gabinecie
SELECT DISTINCT
NVL (TO_CHAR ((SELECT oznaczenie FROM h_gabinety WHERE gabinet_id = g_id)), 'Laczna ilosc wizyt') oznaczenie_gabinetu,
NVL (TO_CHAR ((SELECT status FROM h_statusy_wizyt WHERE statusy_wizyt_id = sw_id AND status LIKE 'Zakonczona')), 'Ilosc wizyt w gabinecie') status_wizyty,
ilosc_wizyt
FROM (
    SELECT gabinet_id g_id, status_wizyty_id sw_id, COUNT (wizyta_id) ilosc_wizyt FROM h_wizyty
    GROUP BY ROLLUP (gabinet_id, status_wizyty_id)
);

-- Liczba pracownikow pracujacych na danym stanowisku, posiadajacych okreslone specjalnosci, mieszkajacych w danym miescie
SELECT DISTINCT
NVL (TO_CHAR ((SELECT nazwa FROM h_stanowiska WHERE stanowisko_id = s_id)), 'Laczna ilosc pracownikow') nazwa_stanowiska,
NVL (TO_CHAR ((SELECT nazwa FROM h_specjalnosci WHERE specjalnosc_id = sp_id)), 'Ilosc pracownikow na danym stanowisku') nazwa_specjalnosci,
NVL (adres, 'Ilosc pracownikow na danym stanowisku z okreslna spec.') miasto,
liczba_pracownikow
FROM (
    SELECT p.stanowisko_id s_id, p.specjalnosc_id sp_id, p.miasto adres, COUNT (p.pracownik_id) liczba_pracownikow FROM h_pracownicy p
    GROUP BY ROLLUP (p.stanowisko_id, p.specjalnosc_id, p.miasto)
);

-- Liczba pacjentow umowionych na wizyte, wymagajaca zabiegu
SELECT DISTINCT
NVL (TO_CHAR ((SELECT nazwa FROM h_zabiegi WHERE zabieg_id = z_id)), 'Laczna ilosc pacjentow') nazwa_zabiegu,
NVL (TO_CHAR ((SELECT status FROM h_statusy_wizyt WHERE statusy_wizyt_id = sw_id AND status LIKE 'Oczekujaca')), 'Ilosc wizyt wymagajacych zabiegu') status_wizyty,
liczba_pacjentow
FROM (
    SELECT zabieg_id z_id, status_wizyty_id sw_id, COUNT (pacjent_id) liczba_pacjentow FROM h_wizyty
    GROUP BY ROLLUP (zabieg_id, status_wizyty_id)
);

--------------------------------------------- CUBE ---------------------------------------------------

-- Srednia oplata wizyt danego pacjenta, w kazdym gabinecie
SELECT DISTINCT
TO_CHAR ((SELECT nazwisko FROM h_pacjenci WHERE pacjent_id = p_id)) nazwisko_pacjenta,
TO_CHAR ((SELECT oznaczenie FROM h_gabinety WHERE gabinet_id = g_id)) oznaczenie_gabinetu,
srednia_oplata
FROM (
    SELECT pacjent_id p_id, gabinet_id g_id, AVG (oplata) srednia_oplata FROM h_wizyty
    GROUP BY CUBE (pacjent_id, gabinet_id)
);

-- Srednia oplata zabiegow danego pacjenta z okreslonego oddzialu, w kazdym gabinecie
SELECT DISTINCT
TO_CHAR ((SELECT nazwisko FROM h_pacjenci WHERE pacjent_id = p_id)) nazwisko_pacjenta,
TO_CHAR ((SELECT oznaczenie FROM h_gabinety WHERE gabinet_id = g_id)) oznaczenie_gabinetu,
TO_CHAR ((SELECT nazwa_oddzialu FROM h_recepty WHERE recepta_id = r_id)) nazwa_oddzialu,
srednia_oplata
FROM (
    SELECT pacjent_id p_id, gabinet_id g_id, recepta_id r_id, AVG (cena_netto_za_zabieg) srednia_oplata FROM h_wizyty
    GROUP BY CUBE (pacjent_id, gabinet_id, recepta_id)
);

-- Laczna odplatnosc lekow na kazdej recepcie z dana ulga
SELECT DISTINCT
r_id numer_recepty,
TO_CHAR ((SELECT typ_ulgi FROM h_ulgi WHERE ulgi_id = u_id)) typ_ulgi,
laczna_odplatnosc
FROM (
    SELECT recepta_id r_id, ulga_id u_id, SUM (odplatnosc) laczna_odplatnosc FROM h_pozycje_recept
    GROUP BY CUBE (recepta_id, ulga_id)
);

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

-- Ranking pacjentow, ktorzy wniesli najwiecej oplat za wizyte w danym gabinecie
SELECT DISTINCT
TO_CHAR ((SELECT nazwisko FROM h_pacjenci WHERE pacjent_id = p_id)) nazwisko_pacjenta,
g_id identyfikator_gabinetu,
oplata_za_wizyte,
ranking
FROM (
    SELECT pacjent_id p_id, gabinet_id g_id, oplata oplata_za_wizyte,
    RANK () OVER (PARTITION BY gabinet_id ORDER BY oplata DESC) ranking
    FROM h_wizyty
)
ORDER BY ranking;

-- Ranking najlepszej sumy sprzedanych lekow na recepte, z dana ulga
SELECT DISTINCT
r_id numer_recepty,
TO_CHAR ((SELECT typ_ulgi FROM h_ulgi WHERE ulgi_id = u_id)) typ_ulgi,
odplatnosc_suma,
ranking
FROM (
    SELECT r_id, u_id, odplatnosc_suma,
    RANK () OVER (ORDER BY odplatnosc_suma DESC) ranking
    FROM (
        SELECT recepta_id r_id, ulga_id u_id, SUM (odplatnosc) odplatnosc_suma FROM h_pozycje_recept
        GROUP BY recepta_id, ulga_id
    )
)
ORDER BY ranking;

-- Ranking najdrozej wykonanych zabiegow przez pracownika pracujacego w okreslonym gabinecie
SELECT DISTINCT
TO_CHAR ((SELECT nazwa FROM h_zabiegi WHERE zabieg_id = z_id)) nazwa_zabiegu,
TO_CHAR ((SELECT nazwisko FROM h_pracownicy WHERE pracownik_id = p_id)) nazwisko_pracownika,
identyfikator_gabinetu,
cena_netto_za_zabieg,
ranking
FROM (
    SELECT zabieg_id z_id, prac_spec p_id, gabinet_id identyfikator_gabinetu, cena_netto_za_zabieg,
    RANK () OVER (PARTITION BY gabinet_id ORDER BY cena_netto_za_zabieg DESC) ranking
    FROM h_wizyty
)
ORDER BY nazwa_zabiegu, ranking;








