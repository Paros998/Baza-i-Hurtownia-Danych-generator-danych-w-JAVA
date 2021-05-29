--------------------------------------------- CUBE ---------------------------------------------------

-- Srednia oplata wizyt danego pacjenta, w kazdym gabinecie
SELECT DISTINCT
TO_CHAR ((SELECT nazwisko FROM h_pacjenci WHERE pacjent_id = p_id)) nazwisko_pacjenta,
TO_CHAR ((SELECT oznaczenie FROM h_gabinety WHERE gabinet_id = g_id)) oznaczenie_gabinetu,
srednia_oplata
FROM (
    SELECT pacjent_id p_id, gabinet_id g_id, AVG (oplata) srednia_oplata FROM h_wizyty
    GROUP BY CUBE (pacjent_id, gabinet_id)
);

-- Srednia oplata zabiegow danego pacjenta z okreslonego oddzialu, w kazdym gabinecie
SELECT DISTINCT
TO_CHAR ((SELECT nazwisko FROM h_pacjenci WHERE pacjent_id = p_id)) nazwisko_pacjenta,
TO_CHAR ((SELECT oznaczenie FROM h_gabinety WHERE gabinet_id = g_id)) oznaczenie_gabinetu,
TO_CHAR ((SELECT nazwa_oddzialu FROM h_recepty WHERE recepta_id = r_id)) nazwa_oddzialu,
srednia_oplata
FROM (
    SELECT pacjent_id p_id, gabinet_id g_id, recepta_id r_id, AVG (cena_netto_za_zabieg) srednia_oplata FROM h_wizyty
    GROUP BY CUBE (pacjent_id, gabinet_id, recepta_id)
);

-- Laczna odplatnosc lekow na kazdej recepcie z dana ulga
SELECT DISTINCT
r_id numer_recepty,
TO_CHAR ((SELECT typ_ulgi FROM h_ulgi WHERE ulgi_id = u_id)) typ_ulgi,
laczna_odplatnosc
FROM (
    SELECT recepta_id r_id, ulga_id u_id, SUM (odplatnosc) laczna_odplatnosc FROM h_pozycje_recept
    GROUP BY CUBE (recepta_id, ulga_id)
);