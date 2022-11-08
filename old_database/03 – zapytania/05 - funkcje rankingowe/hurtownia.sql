--------------------------------------------- FUNKCJE RANKINGOWE ---------------------------------------------------------------------

-- Ranking pacjentow, ktorzy wniesli najwiecej oplat za wizyte w danym gabinecie
SELECT DISTINCT
TO_CHAR ((SELECT nazwisko FROM h_pacjenci WHERE pacjent_id = p_id)) nazwisko_pacjenta,
g_id identyfikator_gabinetu,
oplata_za_wizyte,
ranking
FROM (
    SELECT pacjent_id p_id, gabinet_id g_id, oplata oplata_za_wizyte,
    RANK () OVER (PARTITION BY gabinet_id ORDER BY oplata DESC) ranking
    FROM h_wizyty
)
ORDER BY ranking;

-- Ranking najlepszej sumy sprzedanych lekow na recepte, z dana ulga
SELECT DISTINCT
r_id numer_recepty,
TO_CHAR ((SELECT typ_ulgi FROM h_ulgi WHERE ulgi_id = u_id)) typ_ulgi,
odplatnosc_suma,
ranking
FROM (
    SELECT r_id, u_id, odplatnosc_suma,
    RANK () OVER (ORDER BY odplatnosc_suma DESC) ranking
    FROM (
        SELECT recepta_id r_id, ulga_id u_id, SUM (odplatnosc) odplatnosc_suma FROM h_pozycje_recept
        GROUP BY recepta_id, ulga_id
    )
)
ORDER BY ranking;

-- Ranking najdrozej wykonanych zabiegow przez pracownika pracujacego w okreslonym gabinecie
SELECT DISTINCT
TO_CHAR ((SELECT nazwa FROM h_zabiegi WHERE zabieg_id = z_id)) nazwa_zabiegu,
TO_CHAR ((SELECT nazwisko FROM h_pracownicy WHERE pracownik_id = p_id)) nazwisko_pracownika,
identyfikator_gabinetu,
cena_netto_za_zabieg,
ranking
FROM (
    SELECT zabieg_id z_id, prac_spec p_id, gabinet_id identyfikator_gabinetu, cena_netto_za_zabieg,
    RANK () OVER (PARTITION BY gabinet_id ORDER BY cena_netto_za_zabieg DESC) ranking
    FROM h_wizyty
)
ORDER BY nazwa_zabiegu, ranking;