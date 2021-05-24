--------------------------------------------- OKNA OBLICZENIOWE----------------------------------------------------------------------

--Zlicza ilość wizyt przeprowadzonych w danym roku,recept wypisanych oraz zabiegów od 15 dni przed do 15 dni po aktualnej dacie wizyty
SELECT DISTINCT
EXTRACT (YEAR FROM w.data_wizyty) AS Rok ,
EXTRACT (MONTH FROM w.data_wizyty) AS Miesiac ,
w.data_wizyty AS Data,
COUNT(w.wizyta_id) OVER (PARTITION BY EXTRACT (YEAR FROM w.data_wizyty) ORDER BY w.data_wizyty DESC RANGE BETWEEN INTERVAL '15' DAY PRECEDING AND INTERVAL '15' DAY FOLLOWING) AS Ilosc_wizyt,
COUNT(z.zabieg_id) OVER (PARTITION BY EXTRACT (YEAR FROM w.data_wizyty) ORDER BY w.data_wizyty DESC RANGE BETWEEN INTERVAL '15' DAY PRECEDING AND INTERVAL '15' DAY FOLLOWING) AS Ilosc_zabiegow,
COUNT(r.recepta_id) OVER (PARTITION BY EXTRACT (YEAR FROM w.data_wizyty) ORDER BY w.data_wizyty DESC RANGE BETWEEN INTERVAL '15' DAY PRECEDING AND INTERVAL '15' DAY FOLLOWING) AS Ilosc_recept 
FROM wizyty w
LEFT JOIN recepty r ON r.wizyta_id = w.wizyta_id
LEFT JOIN zabiegi z ON z.wizyta_id = w.wizyta_id
ORDER BY Rok DESC , Miesiac ASC;

--Wypisuje nazwę choroby, jej ID , Rok przeszukiwań danych,Ilość znalezionych rekordów od początku tabeli do aktualnego rekordu z uwzględnieniem nazwy oraz roku,Itd oraz dane Pacjenta
SELECT DISTINCT
c.nazwa AS Nazwa_Choroby,
c.choroby_id,
EXTRACT(YEAR FROM c.poczatek) Rok,
w.wizyta_id,
COUNT(*) OVER (PARTITION BY c.nazwa,EXTRACT(YEAR FROM c.poczatek) ORDER BY c.choroby_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "Ilość zapadnięć na tę chorobę w tym roku do aktualnego rekordu wizyty",
ROUND(100 * COUNT(*) OVER (PARTITION BY c.nazwa,EXTRACT(YEAR FROM c.poczatek) ORDER BY c.choroby_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / COUNT(*) OVER (PARTITION BY c.nazwa,EXTRACT(YEAR FROM c.poczatek) ) , 3) "Udzial % w tym roku",
COUNT(*) OVER (PARTITION BY c.nazwa,EXTRACT(YEAR FROM c.poczatek) ) "�?aczna wartość zapadnięć na tę chorobę w tym roku",
ROUND(100 * COUNT(*) OVER (PARTITION BY c.nazwa,EXTRACT(YEAR FROM c.poczatek) ) / COUNT(*) OVER (PARTITION BY c.nazwa) , 3) "Udzial % na tle lat",
COUNT(*) OVER (PARTITION BY c.nazwa) "�?aczna wartość zapadnięć na tę chorobę na przestrzeni lat",
k.grupa_krwi "Grupa Krwi Pacjenta",
p.imie,
p.nazwisko
FROM choroby c
JOIN recepty r ON r.recepta_choroba_id = c.choroby_id
JOIN wizyty  w ON w.wizyta_id = r.wizyta_id
JOIN pacjenci p ON p.pacjent_id = w.pacjent_id
JOIN karty k ON k.pesel_id = p.pesel_id
ORDER BY Rok DESC,COUNT(*) OVER (PARTITION BY c.nazwa,EXTRACT(YEAR FROM c.poczatek) ORDER BY c.choroby_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) DESC;

--Opłaty,ceny leków i zabiegów każdej wizyty oraz sumaryczna wartość dotychczasowych wizyt
SELECT DISTINCT
w.wizyta_id,
p.pesel_id,
p.imie,
p.nazwisko,
w.oplata "Oplata za wizytę pacjenta",
SUM(pz.odplatnosc) OVER (PARTITION  BY w.wizyta_id) "Cena leków",
(u.procent_ulgi / 100 * (SUM(pz.odplatnosc) OVER (PARTITION  BY w.wizyta_id))) "Cena leków Po Uldze",
SUM(w.oplata) OVER ( ORDER BY w.wizyta_id RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) "Suma wszystkich dotychczasowych oplat za wizyty pacjentów",
z.cena_netto "Oplata za zabieg pacjenta",
SUM(z.cena_netto ) OVER (ORDER BY w.wizyta_id RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) "Suma wszystkich dotychczasowych oplat za zabiegi"
FROM wizyty w
LEFT JOIN zabiegi z ON w.wizyta_id = z.wizyta_id
JOIN pacjenci p ON p.pacjent_id = w.pacjent_id
LEFT JOIN recepty r ON r.wizyta_id = w.wizyta_id
LEFT JOIN pozycje_recept pz ON pz.recepta_id = r.recepta_id
LEFT JOIN ulgi u ON u.ulgi_id = r.ulga_id
ORDER BY w.wizyta_id ASC;