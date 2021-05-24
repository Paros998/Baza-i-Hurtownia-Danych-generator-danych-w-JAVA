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