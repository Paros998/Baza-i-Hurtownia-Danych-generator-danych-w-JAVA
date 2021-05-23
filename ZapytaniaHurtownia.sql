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

-- Procentowy udzial oplat za wizyte, w danym roku, w okreslonej placowce, znajdujacej sie w okreslonym miescie, na przestrzeni wszystkich lat
SELECT p.placowka_id, p.nazwa AS nazwa_placowki, p.miasto, d.rok, 
SUM (w.oplata) OVER (PARTITION BY d.rok, p.placowka_id, p.miasto) suma_w_danym_roku,
SUM (w.oplata) OVER (PARTITION BY p.placowka_id, p.miasto) suma_na_przestrzeni_lat,
ROUND (100 * (SUM (w.oplata) OVER (PARTITION BY d.rok, p.placowka_id, p.miasto)) / SUM (w.oplata) OVER (PARTITION BY p.placowka_id, p.miasto))
"UDZIAL %" FROM h_wizyty w
JOIN h_gabinety g ON g.gabinet_id = w.gabinet_id
JOIN h_placowki p ON p.placowka_id = g.placowka_id
JOIN h_daty_wizyt d ON d.data_id = w.data_wizyty_id
ORDER BY p.placowka_id ASC, d.rok DESC;

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








