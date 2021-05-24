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