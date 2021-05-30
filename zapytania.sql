--------------------------------------------- ROLLUP ---------------------------------------------

-- Ilosc wizyt ze statusem 'zakonczona' w kazdym gabinecie
SELECT DISTINCT
NVL (TO_CHAR ((SELECT oznaczenie FROM gabinety WHERE gabinet_id = g_id)), 'Laczna ilosc wizyt') oznaczenie_gabinetu,
NVL (TO_CHAR ((SELECT status FROM statusy_wizyt WHERE statusy_wizyt_id = sw_id AND status LIKE 'Zakonczona')), 'Ilosc wizyt w gabinecie') status_wizyty,
ilosc_wizyt
FROM (
    SELECT w.gabinet_id g_id, sw.statusy_wizyt_id sw_id, COUNT (w.wizyta_id) ilosc_wizyt FROM statusy_wizyt sw
    JOIN wizyty w ON w.wizyta_id = sw.statusy_wizyt_id
    GROUP BY ROLLUP (w.gabinet_id, sw.statusy_wizyt_id)
);

-- Liczba pracownikow pracujacych na danym stanowisku, posiadajacych okreslone specjalnosci, mieszkajacych w danym miescie
SELECT DISTINCT
NVL (TO_CHAR ((SELECT nazwa FROM stanowiska WHERE stanowisko_id = s_id)), 'Laczna ilosc pracownikow') nazwa_stanowiska,
NVL (TO_CHAR ((SELECT nazwa FROM specjalnosci WHERE specjalnosc_id = sp_id)), 'Ilosc pracownikow na danym stanowisku') nazwa_specjalnosci,
NVL (adres, 'Ilosc pracownikow na danym stanowisku z okreslna spec.') miasto,
liczba_pracownikow
FROM (
    SELECT p.stanowisko_id s_id, p.specjalnosc_id sp_id, a.miasto adres, COUNT (p.pracownik_id) liczba_pracownikow FROM pracownicy p
    JOIN adresy a ON a.adres_id = p.adres_id
    GROUP BY ROLLUP (p.stanowisko_id, p.specjalnosc_id, a.miasto)
);

-- Liczba pacjentow umowionych na wizyte, wymagajaca zabiegu
SELECT DISTINCT
NVL (TO_CHAR ((SELECT nazwa FROM zabiegi WHERE zabieg_id = z_id)), 'Laczna ilosc pacjentow') nazwa_zabiegu,
NVL (TO_CHAR ((SELECT status FROM statusy_wizyt WHERE statusy_wizyt_id = sw_id AND status LIKE 'Oczekujaca')), 'Ilosc wizyt wymagajacych zabiegu') status_wizyty,
liczba_pacjentow
FROM (
    SELECT z.zabieg_id z_id, sw.statusy_wizyt_id sw_id, COUNT(w.pacjent_id) liczba_pacjentow FROM zabiegi z
    RIGHT JOIN wizyty w ON w.wizyta_id = z.wizyta_id
    JOIN statusy_wizyt sw ON sw.statusy_wizyt_id = w.wizyta_id
    GROUP BY ROLLUP (z.zabieg_id, sw.statusy_wizyt_id)
);

--------------------------------------------- CUBE ---------------------------------------------------

-- Srednia oplata wizyt danego pacjenta, w kazdym gabinecie
SELECT DISTINCT
TO_CHAR ((SELECT nazwisko FROM pacjenci WHERE pacjent_id = p_id)) nazwisko_pacjenta,
TO_CHAR ((SELECT oznaczenie FROM gabinety WHERE gabinet_id = g_id)) oznaczenie_gabinetu,
srednia_oplata
FROM (
    SELECT pacjent_id p_id, gabinet_id g_id, AVG (oplata) srednia_oplata FROM wizyty
    GROUP BY CUBE (pacjent_id, gabinet_id)
);

-- Srednia oplata zabiegow danego pacjenta z okreslonego oddzialu, w kazdym gabinecie
SELECT DISTINCT
TO_CHAR ((SELECT nazwisko FROM pacjenci WHERE pacjent_id = p_id)) nazwisko_pacjenta,
TO_CHAR ((SELECT oznaczenie FROM gabinety WHERE gabinet_id = g_id)) oznaczenie_gabinetu,
TO_CHAR ((SELECT nazwa FROM oddzialy_nfz o JOIN recepty r ON r.oddzial_nfz_id = o.oddzial_nfz_id WHERE r.recepta_id = r_id)) nazwa_oddzialu,
srednia_oplata
FROM (
    SELECT w.pacjent_id p_id, w.gabinet_id g_id, r.recepta_id r_id, AVG (z.cena_netto) srednia_oplata FROM zabiegi z
    RIGHT JOIN wizyty w ON w.wizyta_id = z.wizyta_id
    LEFT JOIN recepty r ON r.wizyta_id = w.wizyta_id
    GROUP BY CUBE (w.pacjent_id, w.gabinet_id, r.recepta_id)
);

-- Laczna odplatnosc lekow na kazdej recepcie z dana ulga
SELECT DISTINCT
r_id numer_recepty,
TO_CHAR ((SELECT typ_ulgi FROM ulgi WHERE ulgi_id = u_id)) typ_ulgi,
laczna_odplatnosc
FROM (
    SELECT r.recepta_id r_id, r.ulga_id u_id, SUM (pr.odplatnosc) laczna_odplatnosc FROM pozycje_recept pr
    JOIN recepty r ON r.recepta_id = pr.recepta_id
    GROUP BY CUBE (r.recepta_id, r.ulga_id)
);

---------------------------------------------- PARTYCJE OBLICZENIOWE ----------------------------------------------------------------

--łączna wartość roczna za każdy zabieg przeprowadzany na pacjentach z grupą krwi A-
SELECT DISTINCT z.nazwa,
EXTRACT(YEAR FROM w.data_wizyty) AS Rok,
k.grupa_krwi,
SUM(z.cena_netto) OVER (PARTITION BY EXTRACT(YEAR FROM w.data_wizyty),k.grupa_krwi,z.nazwa) AS "Wartosc_Roczna" 
FROM zabiegi z 
JOIN wizyty w ON w.wizyta_id = z.wizyta_id 
JOIN pacjenci p ON w.pacjent_id = p.pacjent_id
JOIN karty k ON p.pesel_id = k.pesel_id
WHERE k.grupa_krwi = 'A-'
ORDER BY z.nazwa,Rok DESC;

--Id pacjenta,jego imie ,nazwisko , pesel oraz jego Wydatki na leki wciągu jednego roku z ulgą/bez ulgi
SELECT DISTINCT
p.pacjent_id,
p.imie,
p.nazwisko,
p.pesel_id,
EXTRACT(YEAR FROM w.data_wizyty) AS Rok,
SUM(pr.odplatnosc) OVER (PARTITION BY p.pacjent_id,EXTRACT(YEAR FROM w.data_wizyty)) AS "Wydatki Pacjenta Na Leki Bez Ulgi",
(SUM(pr.odplatnosc) OVER (PARTITION BY p.pacjent_id,EXTRACT(YEAR FROM w.data_wizyty)) * (u.procent_ulgi / 100) ) AS "Wydatki Pacjenta Na Leki Z Wliczona Ulga"
FROM recepty r
JOIN pozycje_recept pr ON pr.recepta_id = r.recepta_id
JOIN wizyty w ON w.wizyta_id = r.wizyta_id 
JOIN pacjenci p ON p.pacjent_id = w.pacjent_id
LEFT JOIN ulgi u ON u.ulgi_id = r.ulga_id
ORDER BY p.pacjent_id ASC,Rok DESC;

-- Procentowy udzial oplat za wizyte, w danym roku, w okreslonej placowce, znajdujacej sie w okreslonym miescie, na przestrzeni wszystkich lat
SELECT DISTINCT p.placowka_id, p.nazwa AS nazwa_placowki, a.miasto, EXTRACT (YEAR FROM w.data_wizyty) AS rok, 
SUM (w.oplata) OVER (PARTITION BY EXTRACT (YEAR FROM w.data_wizyty), p.placowka_id, a.miasto) suma_w_danym_roku,
SUM (w.oplata) OVER (PARTITION BY p.placowka_id, a.miasto) suma_na_przestrzeni_lat,
ROUND (100 * (SUM (w.oplata) OVER (PARTITION BY EXTRACT (YEAR FROM w.data_wizyty), p.placowka_id, a.miasto)) / SUM (w.oplata) OVER (PARTITION BY p.placowka_id, a.miasto))
"UDZIAL % danego roku" FROM wizyty w
JOIN gabinety g ON g.gabinet_id = w.gabinet_id
JOIN placowki p ON p.placowka_id = g.placowka_id
JOIN adresy a ON a.adres_id = p.adres_id
ORDER BY p.placowka_id ASC, rok DESC;

--------------------------------------------- OKNA OBLICZENIOWE----------------------------------------------------------------------

--Zlicza ilość wizyt przeprowadzonych ,recept wypisanych oraz zabiegów w danym roku od 15 dni przed do 15 dni po aktualnej dacie wizyty
SELECT DISTINCT
EXTRACT (YEAR FROM w.data_wizyty) AS Rok ,EXTRACT (MONTH FROM w.data_wizyty) AS Miesiac ,w.data_wizyty AS Data,
COUNT(w.wizyta_id) OVER (PARTITION BY EXTRACT (YEAR FROM w.data_wizyty) ORDER BY w.data_wizyty DESC RANGE BETWEEN INTERVAL '15' DAY PRECEDING AND INTERVAL '15' DAY FOLLOWING) AS Ilosc_wizyt,
COUNT(z.zabieg_id) OVER (PARTITION BY EXTRACT (YEAR FROM w.data_wizyty) ORDER BY w.data_wizyty DESC RANGE BETWEEN INTERVAL '15' DAY PRECEDING AND INTERVAL '15' DAY FOLLOWING) AS Ilosc_zabiegow,
COUNT(r.recepta_id) OVER (PARTITION BY EXTRACT (YEAR FROM w.data_wizyty) ORDER BY w.data_wizyty DESC RANGE BETWEEN INTERVAL '15' DAY PRECEDING AND INTERVAL '15' DAY FOLLOWING) AS Ilosc_recept 
FROM wizyty w
LEFT JOIN recepty r ON r.wizyta_id = w.wizyta_id
LEFT JOIN zabiegi z ON z.wizyta_id = w.wizyta_id
ORDER BY Rok DESC , Miesiac ASC;

--Wypisuje nazwę choroby, jej ID , Rok przeszukiwań danych,Ilość znalezionych rekordów od początku tabeli do aktualnego rekordu z uwzględnieniem nazwy oraz roku, oraz dane Pacjenta
SELECT DISTINCT
c.nazwa AS Nazwa_Choroby,c.choroby_id,EXTRACT(YEAR FROM c.poczatek) Rok,w.wizyta_id,
COUNT(*) OVER (PARTITION BY c.nazwa,EXTRACT(YEAR FROM c.poczatek) ORDER BY c.choroby_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
AS "Ilość zapadnięć na tę chorobę w tym roku do aktualnego rekordu wizyty",
ROUND(100 * COUNT(*) OVER (PARTITION BY c.nazwa,EXTRACT(YEAR FROM c.poczatek) ORDER BY c.choroby_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
/ COUNT(*) OVER (PARTITION BY c.nazwa,EXTRACT(YEAR FROM c.poczatek) ) , 3) "Udzial % w tym roku",
COUNT(*) OVER (PARTITION BY c.nazwa,EXTRACT(YEAR FROM c.poczatek) ) "�?aczna wartość zapadnięć na tę chorobę w tym roku",
ROUND(100 * COUNT(*) OVER (PARTITION BY c.nazwa,EXTRACT(YEAR FROM c.poczatek) ) / COUNT(*) OVER (PARTITION BY c.nazwa) , 3) "Udzial % na tle lat",
COUNT(*) OVER (PARTITION BY c.nazwa) "�?aczna wartość zapadnięć na tę chorobę na przestrzeni lat",
k.grupa_krwi "Grupa Krwi Pacjenta",p.imie,p.nazwisko
FROM choroby c
JOIN recepty r ON r.recepta_choroba_id = c.choroby_id
JOIN wizyty  w ON w.wizyta_id = r.wizyta_id
JOIN pacjenci p ON p.pacjent_id = w.pacjent_id
JOIN karty k ON k.pesel_id = p.pesel_id
ORDER BY Rok DESC,COUNT(*) OVER (PARTITION BY c.nazwa,EXTRACT(YEAR FROM c.poczatek) ORDER BY c.choroby_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) DESC;

--Opłaty,ceny leków i zabiegów każdej wizyty oraz sumaryczna wartość dotychczasowych wizyt ,ktore zakonczyly sie recepta lub recepta i zabiegiem
SELECT DISTINCT
w.wizyta_id,
p.pesel_id,
p.imie,
p.nazwisko,
w.oplata "Oplata za wizytę pacjenta",
(SUM(pz.odplatnosc) OVER (PARTITION  BY w.wizyta_id)) "Cena leków",
(u.procent_ulgi / 100 * (SUM(pz.odplatnosc) OVER (PARTITION  BY w.wizyta_id))) "Cena leków Po Uldze",
SUM(w.oplata) OVER (ORDER BY w.wizyta_id RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) "Suma wszystkich dotychczasowych oplat za wizyty pacjentów",
z.cena_netto "Oplata za zabieg pacjenta",
SUM(z.cena_netto ) OVER (ORDER BY w.wizyta_id RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) "Suma wszystkich dotychczasowych oplat za zabiegi"
FROM wizyty w
JOIN pacjenci p ON p.pacjent_id = w.pacjent_id
LEFT JOIN zabiegi z ON w.wizyta_id = z.wizyta_id
JOIN recepty r ON r.wizyta_id = w.wizyta_id
LEFT JOIN pozycje_recept pz ON pz.recepta_id = r.recepta_id
LEFT JOIN ulgi u ON u.ulgi_id = r.ulga_id
ORDER BY w.wizyta_id ASC;

--------------------------------------------- FUNKCJE RANKINGOWE ---------------------------------------------------------------------

-- Ranking pacjentow, ktorzy wniesli najwiecej oplat za wizyte w danym gabinecie
SELECT DISTINCT
TO_CHAR ((SELECT nazwisko FROM pacjenci WHERE pacjent_id = p_id)) nazwisko_pacjenta,
g_id identyfikator_gabinetu,
oplata_za_wizyte,
ranking
FROM (
    SELECT pacjent_id p_id, gabinet_id g_id, oplata oplata_za_wizyte,
    RANK () OVER (PARTITION BY gabinet_id ORDER BY oplata DESC) ranking
    FROM wizyty
)
ORDER BY ranking;

-- Ranking najlepszej sumy sprzedanych lekow na recepte, z dana ulga
SELECT DISTINCT
r_id numer_recepty,
TO_CHAR ((SELECT typ_ulgi FROM ulgi WHERE ulgi_id = u_id)) typ_ulgi,
odplatnosc_suma,
ranking
FROM (
    SELECT r_id, u_id, odplatnosc_suma,
    RANK () OVER (ORDER BY odplatnosc_suma DESC) ranking
    FROM (
        SELECT r.recepta_id r_id, r.ulga_id u_id, SUM (odplatnosc) odplatnosc_suma FROM pozycje_recept pr
        JOIN recepty r ON pr.recepta_id = r.recepta_id
        GROUP BY r.recepta_id, r.ulga_id
    )
)
ORDER BY ranking;

-- Ranking najdrozej wykonanych zabiegow przez pracownika pracujacego w okreslonym gabinecie
SELECT DISTINCT
TO_CHAR ((SELECT nazwa FROM zabiegi WHERE zabieg_id = z_id)) nazwa_zabiegu,
TO_CHAR ((SELECT nazwisko FROM pracownicy WHERE pracownik_id = p_id)) nazwisko_pracownika,
identyfikator_gabinetu,
cena_netto_za_zabieg,
ranking
FROM (
    SELECT z.zabieg_id z_id, w.prac_spec p_id, w.gabinet_id identyfikator_gabinetu, z.cena_netto cena_netto_za_zabieg,
    RANK () OVER (PARTITION BY w.gabinet_id ORDER BY z.cena_netto DESC) ranking
    FROM zabiegi z
    RIGHT JOIN wizyty w ON w.wizyta_id = z.wizyta_id
)
ORDER BY nazwa_zabiegu, ranking;

