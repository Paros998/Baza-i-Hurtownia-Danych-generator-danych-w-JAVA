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