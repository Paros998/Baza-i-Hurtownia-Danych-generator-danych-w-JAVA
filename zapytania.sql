--------------------------------------------- ROLLUP ---------------------------------------------

-- Liczba pacjentow pochodzacych z okreslonego oddzialu NFZ, chorujacych na dana chorobe, 
-- ktorzy posiadaja ulge niepelnosprawnosciowa
SELECT c.nazwa AS nazwa_choroby, o.nazwa AS nazwa_oddzialu_nfz, u.typ_ulgi, COUNT (c.pesel_id) AS liczba_pacjentow FROM recepty r
JOIN choroby c ON c.choroby_id = r.recepta_choroba_id
JOIN ulgi u ON u.ulgi_id = r.ulga_id
JOIN oddzialy_nfz o ON o.oddzial_nfz_id = r.oddzial_nfz_id
WHERE u.typ_ulgi LIKE 'Niepelnosprawnosciowa'
GROUP BY ROLLUP (c.nazwa, o.nazwa, u.typ_ulgi);

-- Liczba pracownikow pracujacych na danym stanowisku, posiadajacych okreslone uprawnienia,
-- mieszkajacych w Kielcach
SELECT s.nazwa AS nazwa_stanowiska, u.opis AS typ_uprawnienia, a.miasto, COUNT (*) AS liczba_pracownikow FROM pracownicy p
JOIN stanowiska s ON s.stanowisko_id = p.stanowisko_id
JOIN uprawnienia u ON u.uprawnienie_id = s.uprawnienie_id
JOIN adresy a ON a.adres_id = p.adres_id
WHERE a.miasto LIKE 'Kielce'
GROUP BY ROLLUP (s.nazwa, u.opis, a.miasto);

-- Liczba wizyt pacjentow ze schorzeniem osteoporozy, w danej placowce oraz w danym miescie
SELECT c.nazwa AS nazwa_choroby, p.nazwa AS nazwa_placowki, a.miasto, COUNT (w.wizyta_id) AS liczba_wizyt FROM recepty r
JOIN choroby c ON c.choroby_id = r.recepta_choroba_id
JOIN wizyty w ON w.wizyta_id = r.wizyta_id
JOIN gabinety g ON g.gabinet_id = w.gabinet_id
JOIN placowki p ON p.placowka_id = g.placowka_id
JOIN adresy a ON a.adres_id = p.adres_id
WHERE g.oznaczenie LIKE 'Wizyty%'
GROUP BY ROLLUP (c.nazwa, p.nazwa, a.miasto);

--------------------------------------------- CUBE ---------------------------------------------------

-- Srednia oplata wizyt danego pacjenta, w placowce, w danym miescie
SELECT pac.nazwisko AS nazwisko_pacjenta, p.nazwa AS nazwa_placowki, a.miasto, AVG (w.oplata) AS srednia_oplata FROM wizyty w
JOIN pacjenci pac ON pac.pacjent_id = w.pacjent_id
JOIN gabinety g ON g.gabinet_id = w.gabinet_id
JOIN placowki p ON p.placowka_id = g.placowka_id
JOIN adresy a ON a.adres_id = p.adres_id
WHERE g.oznaczenie LIKE 'Wizyty%'
GROUP BY CUBE (pac.nazwisko, p.nazwa, a.miasto);

-- Srednia oplata zabiegow danego pacjenta, w placowce, w danym miescie
SELECT pac.nazwisko AS nazwisko_pacjenta, p.nazwa AS nazwa_placowki, a.miasto, AVG (z.cena_netto) AS srednia_oplata FROM zabiegi z
JOIN wizyty w ON w.wizyta_id = z.wizyta_id
JOIN pacjenci pac ON pac.pacjent_id = w.pacjent_id
JOIN gabinety g ON g.gabinet_id = w.gabinet_id
JOIN placowki p ON p.placowka_id = g.placowka_id
JOIN adresy a ON a.adres_id = p.adres_id
WHERE g.oznaczenie LIKE 'Zabiegi'
GROUP BY CUBE (pac.nazwisko, p.nazwa, a.miasto);

-- Srednia oplata za leki danego pacjenta, w danym miescie, chorujacego na okreslona chorobe, powiazanego z danego oddzialu
SELECT pac.nazwisko AS nazwisko_pacjenta, a.miasto, c.nazwa AS nazwa_choroby, AVG (pr.odplatnosc) AS srednia_oplata_za_leki FROM pozycje_recept pr
JOIN recepty r ON pr.recepta_id = r.recepta_id
JOIN wizyty w ON w.wizyta_id = r.wizyta_id
JOIN pacjenci pac ON pac.pacjent_id = w.pacjent_id
JOIN adresy a ON a.adres_id = pac.adres_id
JOIN choroby c ON c.choroby_id = r.recepta_choroba_id
GROUP BY CUBE (pac.nazwisko, a.miasto, c.nazwa);

---------------------------------------------- PARTYCJE OBLICZENIOWE ----------------------------------------------------------------

-- Procentowy udzial oplat za wizyte, w danym roku, w okreslonej placowce, znajdujacej sie w okreslonym miescie, na przestrzeni wszystkich lat
SELECT p.placowka_id, p.nazwa AS nazwa_placowki, a.miasto, EXTRACT (YEAR FROM w.data_wizyty) AS rok, 
SUM (w.oplata) OVER (PARTITION BY EXTRACT (YEAR FROM w.data_wizyty), p.placowka_id, a.miasto) suma_w_danym_roku,
SUM (w.oplata) OVER (PARTITION BY p.placowka_id, a.miasto) suma_na_przestrzeni_lat,
ROUND (100 * (SUM (w.oplata) OVER (PARTITION BY EXTRACT (YEAR FROM w.data_wizyty), p.placowka_id, a.miasto)) / SUM (w.oplata) OVER (PARTITION BY p.placowka_id, a.miasto))
"UDZIAL %" FROM wizyty w
JOIN gabinety g ON g.gabinet_id = w.gabinet_id
JOIN placowki p ON p.placowka_id = g.placowka_id
JOIN adresy a ON a.adres_id = p.adres_id
ORDER BY p.placowka_id ASC, rok DESC;

--------------------------------------------- FUNKCJE RANKINGOWE ---------------------------------------------------------------------

-- Ranking pacjentow, ktorzy wniesli najwiecej oplat za wizyte w danej placowce, w danym miescie
SELECT pac.nazwisko AS nazwisko_pacjenta, p.nazwa AS nazwa_placowki, a.miasto, w.oplata AS oplata_za_wizyte,
RANK () OVER (PARTITION BY p.nazwa, a.miasto ORDER BY w.oplata DESC)
ranking FROM wizyty w
JOIN pacjenci pac ON pac.pacjent_id = w.pacjent_id
JOIN gabinety g ON g.gabinet_id = w.gabinet_id
JOIN placowki p ON p.placowka_id = g.placowka_id
JOIN adresy a ON a.adres_id = p.adres_id
ORDER BY pac.nazwisko, ranking;

-- Ranking lekow, ktore sie sprzedaly najwiecej w danej placowce, w danym miesice
SELECT pr.nazwa AS nazwa_leku, p.nazwa AS nazwa_placowki, a.miasto, pr.ilosc,
RANK () OVER (PARTITION BY p.nazwa, a.miasto ORDER BY pr.ilosc DESC)
ranking FROM pozycje_recept pr
JOIN recepty r ON r.recepta_id = pr.recepta_id
JOIN wizyty w ON w.wizyta_id = r.recepta_id
JOIN gabinety g ON g.gabinet_id = w.gabinet_id
JOIN placowki p ON p.placowka_id = g.placowka_id
JOIN adresy a ON a.adres_id = p.adres_id
ORDER BY pr.nazwa, ranking;

-- Ranking zabiegow, ktore zostaly wykonane przez neurologa, w danej placowce oraz w danym miescie
SELECT z.nazwa AS nazwa_zabiegu, pr.nazwisko, p.nazwa AS nazwa_placowki, a.miasto, z.cena_netto AS oplata_za_zabieg,
RANK () OVER (PARTITION BY p.nazwa, a.miasto ORDER BY z.cena_netto DESC)
ranking FROM zabiegi z
JOIN wizyty w ON z.wizyta_id = w.wizyta_id
JOIN pracownicy pr ON pr.pracownik_id = w.prac_spec
JOIN stanowiska s ON s.stanowisko_id = pr.stanowisko_id
JOIN gabinety g ON g.gabinet_id = w.gabinet_id
JOIN placowki p ON p.placowka_id = g.placowka_id
JOIN adresy a ON a.adres_id = p.adres_id
WHERE s.nazwa LIKE 'Neurolog'
ORDER BY z.nazwa, ranking;


------------------------------------Partycje------------------------------------------------------------

--Łączna wartość roczna za każdy zabieg przeprowadzany na pacjentach z grupą krwi A-
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


--Id pacjenta,jego imie ,nazwisko , pesel oraz jego Wydatki na leki wciągu jednego roku z/bez ulgą
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
