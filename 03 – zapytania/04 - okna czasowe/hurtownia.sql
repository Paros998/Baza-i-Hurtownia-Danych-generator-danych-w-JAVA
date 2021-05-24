--------------------------------------------- OKNA OBLICZENIOWE----------------------------------------------------------------------
--Zlicza ilość wizyt przeprowadzonych w danym roku,recept wypisanych oraz zabiegów od 15 dni przed do 15 dni po aktualnej dacie wizyty
SELECT DISTINCT
d.rok AS Rok ,
d.miesiac AS Miesiac ,
d.data_wizyty AS Data,
COUNT(w.wizyta_id) OVER (PARTITION BY d.rok ORDER BY d.data_wizyty DESC RANGE BETWEEN INTERVAL '15' DAY PRECEDING AND INTERVAL '15' DAY FOLLOWING) AS Ilosc_wizyt,
COUNT(w.zabieg_id) OVER (PARTITION BY d.rok ORDER BY d.data_wizyty DESC RANGE BETWEEN INTERVAL '15' DAY PRECEDING AND INTERVAL '15' DAY FOLLOWING) AS Ilosc_zabiegow,
COUNT(w.recepta_id) OVER (PARTITION BY d.rok ORDER BY d.data_wizyty DESC RANGE BETWEEN INTERVAL '15' DAY PRECEDING AND INTERVAL '15' DAY FOLLOWING) AS Ilosc_recept 
FROM h_wizyty w
JOIN h_daty_wizyt  d ON d.data_id = w.data_wizyty_id
ORDER BY Rok DESC , Miesiac ASC;

--Wypisuje nazwę choroby, jej ID , Rok przeszukiwań danych,Ilość znalezionych rekordów od początku tabeli do aktualnego rekordu z uwzględnieniem nazwy oraz roku,Itd oraz dane Pacjenta
SELECT DISTINCT
c.nazwa AS Nazwa_Choroby,
c.choroby_id,
EXTRACT(YEAR FROM c.poczatek) Rok,
w.wizyta_id,
COUNT(*) OVER (PARTITION BY c.nazwa,EXTRACT(YEAR FROM c.poczatek) ORDER BY c.choroby_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "Ilość zapadnięć na tę chorobę w tym roku do aktualnego rekordu  wizyty",
ROUND(100 * COUNT(*) OVER (PARTITION BY c.nazwa,EXTRACT(YEAR FROM c.poczatek) ORDER BY c.choroby_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / COUNT(*) OVER (PARTITION BY c.nazwa,EXTRACT(YEAR FROM c.poczatek) ) , 3) "Udzial % w tym roku",
COUNT(*) OVER (PARTITION BY c.nazwa,EXTRACT(YEAR FROM c.poczatek) ) "Łaczna wartość zapadnięć na tę chorobę w tym roku",
ROUND(100 * COUNT(*) OVER (PARTITION BY c.nazwa,EXTRACT(YEAR FROM c.poczatek) ) / COUNT(*) OVER (PARTITION BY c.nazwa) , 3) "Udzial % na tle lat",
COUNT(*) OVER (PARTITION BY c.nazwa) "Łaczna wartość zapadnięć na tę chorobę na przestrzeni lat",
p.grupa_krwi "Grupa Krwi Pacjenta",
p.imie,
p.nazwisko
FROM h_choroby c
JOIN h_recepty r ON r.choroba_id = c.choroby_id
JOIN h_wizyty w ON w.recepta_id = r.recepta_id
JOIN h_daty_wizyt d ON d.data_id = w.data_wizyty_id
JOIN h_pacjenci p ON p.pacjent_id = w.pacjent_id
ORDER BY Rok DESC,COUNT(*) OVER (PARTITION BY c.nazwa,EXTRACT(YEAR FROM c.poczatek) ORDER BY c.choroby_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) DESC;

--Opłaty,ceny leków i zabiegów każdej wizyty oraz sumaryczna wartość dotychczasowych wizyt
SELECT DISTINCT
w.wizyta_id,
p.pesel,
p.imie,
p.nazwisko,
w.oplata "Oplata za wizytę pacjenta",
SUM(pz.odplatnosc) OVER (PARTITION  BY w.wizyta_id) "Cena leków",
(pz.procent_ulgi / 100 * (SUM(pz.odplatnosc) OVER (PARTITION  BY w.wizyta_id))) "Cena leków Po Uldze",
SUM(w.oplata) OVER ( ORDER BY w.wizyta_id RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) "Suma wszystkich dotychczasowych oplat za wizyty pacjentów",
w.cena_netto_za_zabieg "Oplata za zabieg pacjenta",
SUM(w.cena_netto_za_zabieg ) OVER (ORDER BY w.wizyta_id RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) "Suma wszystkich dotychczasowych oplat za zabiegi"
FROM h_wizyty w
JOIN h_pacjenci p ON p.pacjent_id = w.pacjent_id
LEFT JOIN h_recepty r ON r.recepta_id = w.recepta_id
LEFT JOIN h_pozycje_recept pz ON pz.recepta_id = r.recepta_id
ORDER BY w.wizyta_id ASC;