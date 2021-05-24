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