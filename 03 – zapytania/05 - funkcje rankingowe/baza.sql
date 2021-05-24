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

-- Ranking najlepszej sredniej sprzedazy lekow na dana chorobe z dana ulga
SELECT pr.nazwa AS nazwa_leku, c.nazwa AS nazwa_choroby, u.typ_ulgi, AVG (pr.ilosc),
RANK () OVER (PARTITION BY c.nazwa, u.typ_ulgi ORDER BY AVG (pr.ilosc) DESC)
ranking FROM pozycje_recept pr
JOIN recepty r ON r.recepta_id = pr.recepta_id
JOIN ulgi u ON u.ulgi_id = r.ulga_id
JOIN choroby c ON c.choroby_id = r.recepta_choroba_id
GROUP BY ROLLUP (pr.nazwa, c.nazwa, u.typ_ulgi)
ORDER BY c.nazwa, ranking;

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