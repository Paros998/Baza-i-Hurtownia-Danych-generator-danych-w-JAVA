--------------------------------------------- ROLLUP ---------------------------------------------

-- Liczba pacjentow pochodzacych z okreslonego oddzialu NFZ, chorujacych na dana chorobe, 
-- ktorzy naleza do placowki Prodimed
SELECT c.nazwa AS nazwa_choroby, o.nazwa AS nazwa_oddzialu_nfz, p.nazwa AS nazwa_placowki, COUNT (w.pacjent_id) AS liczba_pacjentow FROM recepty r
JOIN oddzialy_nfz o ON o.oddzial_nfz_id = r.oddzial_nfz_id
JOIN choroby c ON c.choroby_id = r.recepta_choroba_id
JOIN wizyty w ON w.wizyta_id = r.wizyta_id
JOIN gabinety g ON g.gabinet_id = w.gabinet_id
JOIN placowki p ON p.placowka_id = g.placowka_id
WHERE p.nazwa LIKE 'Prodimed'
GROUP BY ROLLUP (c.nazwa, o.nazwa, p.nazwa);

-- Liczba pracownikow pracujacych na danym stanowisku, posiadajacych okreslone uprawnienia,
-- mieszkajacych w Kielcach
SELECT s.nazwa AS nazwa_stanowiska, u.opis AS typ_uprawnienia, a.miasto, COUNT (*) AS liczba_pracownikow FROM pracownicy p
JOIN stanowiska s ON s.stanowisko_id = p.stanowisko_id
JOIN uprawnienia u ON u.uprawnienie_id = s.uprawnienie_id
JOIN adresy a ON a.adres_id = p.adres_id
WHERE a.miasto LIKE 'Kielce'
GROUP BY ROLLUP (s.nazwa, u.opis, a.miasto);

-- Liczba wizyt pacjentow z danym schorzeniem , w danej placowce oraz w danym miescie
SELECT c.nazwa AS nazwa_choroby, p.nazwa AS nazwa_placowki, a.miasto, COUNT (w.wizyta_id) AS liczba_wizyt FROM wizyty w
JOIN recepty r ON w.wizyta_id = r.wizyta_id
JOIN choroby c ON c.choroby_id = r.recepta_choroba_id
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
SELECT pac.nazwisko AS nazwisko_pacjenta, p.nazwa AS nazwa_placowki, a.miasto, AVG (z.cena_netto) AS srednia_oplata FROM wizyty w
JOIN zabiegi z ON w.wizyta_id = z.wizyta_id
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

-- Ranking najlepszej sredniej sprzedazy lekow, w danej placowce, w danym miesice
SELECT pr.nazwa AS nazwa_leku, p.nazwa AS nazwa_placowki, a.miasto, AVG (pr.ilosc),
RANK () OVER (PARTITION BY p.nazwa, a.miasto ORDER BY AVG (pr.ilosc) DESC)
ranking FROM pozycje_recept pr
JOIN recepty r ON r.recepta_id = pr.recepta_id
JOIN wizyty w ON w.wizyta_id = r.recepta_id
JOIN gabinety g ON g.gabinet_id = w.gabinet_id
JOIN placowki p ON p.placowka_id = g.placowka_id
JOIN adresy a ON a.adres_id = p.adres_id
GROUP BY ROLLUP (pr.nazwa, p.nazwa, a.miasto)
ORDER BY pr.nazwa, ranking;

-- Ranking zabiegow, ktore zostaly wykonane przez neurologa, w danej placowce oraz w danym miescie
SELECT z.nazwa AS nazwa_zabiegu, pr.nazwisko, p.nazwa AS nazwa_placowki, a.miasto, z.cena_netto AS oplata_za_zabieg,
RANK () OVER (PARTITION BY p.nazwa, a.miasto ORDER BY z.cena_netto DESC)
ranking FROM wizyty w
JOIN zabiegi z ON z.wizyta_id = w.wizyta_id
JOIN pracownicy pr ON pr.pracownik_id = w.prac_spec
JOIN stanowiska s ON s.stanowisko_id = pr.stanowisko_id
JOIN gabinety g ON g.gabinet_id = w.gabinet_id
JOIN placowki p ON p.placowka_id = g.placowka_id
JOIN adresy a ON a.adres_id = p.adres_id
WHERE s.nazwa LIKE 'Neurolog'
ORDER BY z.nazwa, ranking;

