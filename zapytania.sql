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
SELECT c.nazwa AS nazwa_choroby, p.nazwa AS nazwa_placowki, a.miasto, COUNT(w.wizyta_id) AS liczba_wizyt FROM recepty r
JOIN choroby c ON c.choroby_id = r.recepta_choroba_id
JOIN wizyty w ON w.wizyta_id = r.wizyta_id
JOIN gabinety g ON g.gabinet_id = w.gabinet_id
JOIN placowki p ON p.placowka_id = g.placowka_id
JOIN adresy a ON a.adres_id = p.adres_id
WHERE g.oznaczenie LIKE 'Wizyty%'
GROUP BY ROLLUP (c.nazwa, p.nazwa, a.miasto);

--------------------------------------------- CUBE ---------------------------------------------------

-- Srednia oplata wizyt danego pacjenta, w placowce, w danym miescie
SELECT pac.nazwisko AS nazwisko_pacjenta, p.nazwa AS nazwa_placowki, a.miasto, AVG(w.oplata) AS srednia_oplata FROM wizyty w
JOIN pacjenci pac ON pac.pacjent_id = w.pacjent_id
JOIN gabinety g ON g.gabinet_id = w.gabinet_id
JOIN placowki p ON p.placowka_id = g.placowka_id
JOIN adresy a ON a.adres_id = p.adres_id
WHERE g.oznaczenie LIKE 'Wizyty%'
GROUP BY CUBE (pac.nazwisko, p.nazwa, a.miasto);

-- Srednia oplata zabiegow danego pacjenta, w placowce, w danym miescie
SELECT pac.nazwisko AS nazwisko_pacjenta, p.nazwa AS nazwa_placowki, a.miasto, AVG(z.cena_netto) AS srednia_oplata FROM zabiegi z
JOIN wizyty w ON w.wizyta_id = z.wizyta_id
JOIN pacjenci pac ON pac.pacjent_id = w.pacjent_id
JOIN gabinety g ON g.gabinet_id = w.gabinet_id
JOIN placowki p ON p.placowka_id = g.placowka_id
JOIN adresy a ON a.adres_id = p.adres_id
WHERE g.oznaczenie LIKE 'Zabiegi'
GROUP BY CUBE (pac.nazwisko, p.nazwa, a.miasto);

-- Srednia oplata za leki danego pacjenta, w danym miescie, chorujacego na okreslona chorobe, powiazanego z danego oddzialu
SELECT pac.nazwisko AS nazwisko_pacjenta, a.miasto, c.nazwa AS nazwa_choroby, AVG(pr.odplatnosc) AS srednia_oplata_za_leki FROM pozycje_recept pr
JOIN recepty r ON pr.recepta_id = r.recepta_id
JOIN wizyty w ON w.wizyta_id = r.wizyta_id
JOIN pacjenci pac ON pac.pacjent_id = w.pacjent_id
JOIN adresy a ON a.adres_id = pac.adres_id
JOIN choroby c ON c.choroby_id = r.recepta_choroba_id
GROUP BY CUBE (pac.nazwisko, a.miasto, c.nazwa);


