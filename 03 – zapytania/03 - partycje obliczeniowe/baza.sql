---------------------------------------------- PARTYCJE OBLICZENIOWE ----------------------------------------------------------------
--Łaczna wartość roczna za każdy zabieg przeprowadzany na pacjentach z grupą krwi A-
SELECT DISTINCT 
z.nazwa,EXTRACT(YEAR FROM w.data_wizyty) AS Rok,k.grupa_krwi,
SUM(z.cena_netto) OVER (PARTITION BY EXTRACT(YEAR FROM w.data_wizyty),k.grupa_krwi,z.nazwa) AS "Wartosc_Roczna" 
FROM zabiegi z 
JOIN wizyty w ON w.wizyta_id = z.wizyta_id 
JOIN pacjenci p ON w.pacjent_id = p.pacjent_id
JOIN karty k ON p.pesel_id = k.pesel_id
WHERE k.grupa_krwi = 'A-'
ORDER BY z.nazwa,Rok DESC;

--Id pacjenta,jego imie ,nazwisko , pesel oraz jego Wydatki na leki wciągu jednego roku z ulgą/bez ulgi
SELECT DISTINCT
p.pacjent_id,p.imie,p.nazwisko,p.pesel_id,
EXTRACT(YEAR FROM w.data_wizyty) AS Rok,
SUM(pr.odplatnosc) OVER (PARTITION BY p.pacjent_id,EXTRACT(YEAR FROM w.data_wizyty)) AS "Wydatki Pacjenta Na Leki Bez Ulgi",
(SUM(pr.odplatnosc) OVER (PARTITION BY p.pacjent_id,EXTRACT(YEAR FROM w.data_wizyty)) * (u.procent_ulgi / 100) ) AS "Wydatki Pacjenta Na Leki Z Wliczona Ulga"
FROM recepty r
JOIN pozycje_recept pr ON pr.recepta_id = r.recepta_id
JOIN wizyty w ON w.wizyta_id = r.wizyta_id 
JOIN pacjenci p ON p.pacjent_id = w.pacjent_id
LEFT JOIN ulgi u ON u.ulgi_id = r.ulga_id
ORDER BY p.pacjent_id ASC,Rok DESC;

-- Procentowy udzial oplat za wizyte, w danym roku, w okreslonej placowce, znajdujacej sie w okreslonym miescie, na przestrzeni wszystkich lat
SELECT DISTINCT p.placowka_id, p.nazwa AS nazwa_placowki, a.miasto, EXTRACT (YEAR FROM w.data_wizyty) AS rok, 
SUM (w.oplata) OVER (PARTITION BY EXTRACT (YEAR FROM w.data_wizyty), p.placowka_id, a.miasto) suma_w_danym_roku,
SUM (w.oplata) OVER (PARTITION BY p.placowka_id, a.miasto) suma_na_przestrzeni_lat,
ROUND (100 * (SUM (w.oplata) OVER (PARTITION BY EXTRACT (YEAR FROM w.data_wizyty), p.placowka_id, a.miasto)) / SUM (w.oplata) OVER (PARTITION BY p.placowka_id, a.miasto))
"UDZIAL % danego roku" FROM wizyty w
JOIN gabinety g ON g.gabinet_id = w.gabinet_id
JOIN placowki p ON p.placowka_id = g.placowka_id
JOIN adresy a ON a.adres_id = p.adres_id
ORDER BY p.placowka_id ASC, rok DESC;