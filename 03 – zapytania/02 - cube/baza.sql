--------------------------------------------- CUBE ---------------------------------------------------

-- Srednia oplata wizyt danego pacjenta, w kazdym gabinecie
SELECT DISTINCT
TO_CHAR ((SELECT nazwisko FROM pacjenci WHERE pacjent_id = p_id)) nazwisko_pacjenta,
TO_CHAR ((SELECT oznaczenie FROM gabinety WHERE gabinet_id = g_id)) oznaczenie_gabinetu,
srednia_oplata
FROM (
    SELECT pacjent_id p_id, gabinet_id g_id, AVG (oplata) srednia_oplata FROM wizyty
    GROUP BY CUBE (pacjent_id, gabinet_id)
);

-- Srednia oplata zabiegow danego pacjenta z okreslonego oddzialu, w kazdym gabinecie
SELECT DISTINCT
TO_CHAR ((SELECT nazwisko FROM pacjenci WHERE pacjent_id = p_id)) nazwisko_pacjenta,
TO_CHAR ((SELECT oznaczenie FROM gabinety WHERE gabinet_id = g_id)) oznaczenie_gabinetu,
TO_CHAR ((SELECT nazwa FROM oddzialy_nfz o JOIN recepty r ON r.oddzial_nfz_id = o.oddzial_nfz_id WHERE r.recepta_id = r_id)) nazwa_oddzialu,
srednia_oplata
FROM (
    SELECT w.pacjent_id p_id, w.gabinet_id g_id, r.recepta_id r_id, AVG (z.cena_netto) srednia_oplata FROM zabiegi z
    RIGHT JOIN wizyty w ON w.wizyta_id = z.wizyta_id
    LEFT JOIN recepty r ON r.wizyta_id = w.wizyta_id
    GROUP BY CUBE (w.pacjent_id, w.gabinet_id, r.recepta_id)
);

-- Laczna odplatnosc lekow na kazdej recepcie z dana ulga
SELECT DISTINCT
r_id numer_recepty,
TO_CHAR ((SELECT typ_ulgi FROM ulgi WHERE ulgi_id = u_id)) typ_ulgi,
laczna_odplatnosc
FROM (
    SELECT r.recepta_id r_id, r.ulga_id u_id, SUM (pr.odplatnosc) laczna_odplatnosc FROM pozycje_recept pr
    JOIN recepty r ON r.recepta_id = pr.recepta_id
    GROUP BY CUBE (r.recepta_id, r.ulga_id)
);