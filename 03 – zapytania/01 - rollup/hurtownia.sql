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