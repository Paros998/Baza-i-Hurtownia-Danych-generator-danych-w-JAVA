---------------------------------------------- PARTYCJE OBLICZENIOWE ----------------------------------------------------------------

--Łączna wartość roczna za każdy zabieg przeprowadzany na pacjentach z grupą krwi A-
SELECT DISTINCT z.nazwa,
d.rok AS Rok,
p.grupa_krwi,
SUM(w.cena_netto_za_zabieg) OVER (PARTITION BY d.rok,p.grupa_krwi,z.nazwa) AS "Wartosc_Roczna" 
FROM h_wizyty w 
JOIN h_daty_wizyt d ON d.data_id = w.data_wizyty_id
RIGHT JOIN h_zabiegi z ON w.zabieg_id = z.zabieg_id 
JOIN h_pacjenci p ON w.pacjent_id = p.pacjent_id
WHERE p.grupa_krwi = 'A-'
ORDER BY z.nazwa,Rok DESC;

--Id pacjenta,jego imie ,nazwisko , pesel oraz jego Wydatki na leki wciągu jednego roku z ulgą/bez ulgi
SELECT DISTINCT
p.pacjent_id,
p.imie,
p.nazwisko,
p.pesel,
d.rok AS Rok,
SUM(pr.odplatnosc) OVER (PARTITION BY p.pacjent_id,d.rok) AS "Wydatki Pacjenta Na Leki Bez Ulgi",
(SUM(pr.odplatnosc) OVER (PARTITION BY p.pacjent_id,d.rok) * (pr.procent_ulgi / 100) ) AS "Wydatki Pacjenta Na Leki Z Wliczona Ulga"
FROM h_wizyty w
JOIN h_daty_wizyt d ON d.data_id = w.data_wizyty_id
JOIN h_recepty r ON w.recepta_id = r.recepta_id
JOIN h_pozycje_recept pr ON pr.recepta_id = r.recepta_id
JOIN h_pacjenci p ON p.pacjent_id = w.pacjent_id
ORDER BY p.pacjent_id ASC,Rok DESC;

-- Procentowy udzial oplat za wizyte, w danym roku, w okreslonej placowce, znajdujacej sie w okreslonym miescie, na przestrzeni wszystkich lat
SELECT p.placowka_id, p.nazwa AS nazwa_placowki, p.miasto, d.rok, 
SUM (w.oplata) OVER (PARTITION BY d.rok, p.placowka_id, p.miasto) suma_w_danym_roku,
SUM (w.oplata) OVER (PARTITION BY p.placowka_id, p.miasto) suma_na_przestrzeni_lat,
ROUND (100 * (SUM (w.oplata) OVER (PARTITION BY d.rok, p.placowka_id, p.miasto)) / SUM (w.oplata) OVER (PARTITION BY p.placowka_id, p.miasto))
"UDZIAL %" FROM h_wizyty w
JOIN h_gabinety g ON g.gabinet_id = w.gabinet_id
JOIN h_placowki p ON p.placowka_id = g.placowka_id
JOIN h_daty_wizyt d ON d.data_id = w.data_wizyty_id
ORDER BY p.placowka_id ASC, d.rok DESC;