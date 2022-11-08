--------------------------------------------- OKNA OBLICZENIOWE----------------------------------------------------------------------
--Zlicza ilość wizyt przeprowadzonych ,recept wypisanych oraz zabiegów w danym roku od 15 dni przed do 15 dni po aktualnej dacie wizyty
SELECT DISTINCT
d.rok AS Rok ,
d.miesiac AS Miesiac ,
d.data_wizyty AS Data,
COUNT(WID) OVER (PARTITION BY d.rok ORDER BY d.data_wizyty DESC RANGE BETWEEN INTERVAL '15' DAY PRECEDING AND INTERVAL '15' DAY FOLLOWING) AS Ilosc_wizyt,
COUNT(ZID) OVER (PARTITION BY d.rok ORDER BY d.data_wizyty DESC RANGE BETWEEN INTERVAL '15' DAY PRECEDING AND INTERVAL '15' DAY FOLLOWING) AS Ilosc_zabiegow,
COUNT(RID) OVER (PARTITION BY d.rok ORDER BY d.data_wizyty DESC RANGE BETWEEN INTERVAL '15' DAY PRECEDING AND INTERVAL '15' DAY FOLLOWING) AS Ilosc_recept 
FROM 
    (SELECT wizyta_id WID,zabieg_id ZID,recepta_id RID,data_wizyty_id DID 
    FROM h_wizyty 
    GROUP BY wizyta_id,zabieg_id,recepta_id,data_wizyty_id
    ),
h_daty_wizyt d 
WHERE d.data_id = DID 
ORDER BY Rok DESC , Miesiac ASC;

--Wypisuje nazwę choroby, jej ID , Rok przeszukiwań danych,Ilość znalezionych rekordów od początku tabeli do aktualnego rekordu z uwzględnieniem nazwy oraz roku, oraz dane Pacjenta
SELECT DISTINCT
Nazwa AS Nazwa_Choroby,
CID choroby_id,
EXTRACT(YEAR FROM CP) Rok,
WID AS wizyta_id,
COUNT(*) OVER (PARTITION BY Nazwa,EXTRACT(YEAR FROM CP) ORDER BY CID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "Ilość zapadnięć na tę chorobę w tym roku do aktualnego rekordu  wizyty",
ROUND(100 * COUNT(*) OVER (PARTITION BY Nazwa,EXTRACT(YEAR FROM CP) ORDER BY CID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / COUNT(*) OVER (PARTITION BY Nazwa,EXTRACT(YEAR FROM CP) ) , 3) "Udzial % w tym roku",
COUNT(*) OVER (PARTITION BY Nazwa,EXTRACT(YEAR FROM CP) ) "Łaczna wartość zapadnięć na tę chorobę w tym roku",
ROUND(100 * COUNT(*) OVER (PARTITION BY Nazwa,EXTRACT(YEAR FROM CP) ) / COUNT(*) OVER (PARTITION BY Nazwa) , 3) "Udzial % na tle lat",
COUNT(*) OVER (PARTITION BY Nazwa) "Łaczna wartość zapadnięć na tę chorobę na przestrzeni lat",
PGK AS "Grupa Krwi Pacjenta",
PIMIE AS Imie,
PNAZ AS Nazwisko
FROM
    (SELECT WID WID,CID CID,Nazwa Nazwa,CP CP,p.grupa_krwi PGK,p.imie PIMIE,p.nazwisko PNAZ 
    FROM
        (SELECT wizyta_id WID,pacjent_id PID,CID CID,Nazwa Nazwa,CP CP 
        FROM
            (SELECT CID CID,Nazwa Nazwa,CP CP,recepta_id RID 
            FROM
                (SELECT choroby_id CID,nazwa Nazwa,poczatek CP 
                FROM h_choroby 
                ),
                h_recepty 
                WHERE h_recepty.choroba_id = CID
            ),
            h_wizyty 
            WHERE h_wizyty.recepta_id = RID
        ),
        h_pacjenci p 
        WHERE p.pacjent_id = PID 
    )
ORDER BY Rok DESC,COUNT(*) OVER (PARTITION BY Nazwa,EXTRACT(YEAR FROM CP) ORDER BY CID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) DESC;

--Opłaty,ceny leków i zabiegów każdej wizyty oraz sumaryczna wartość dotychczasowych wizyt ,ktore zakonczyly sie recepta lub recepta i zabiegiem
SELECT DISTINCT
WID wizyta_id,
p.pesel,
p.imie,
p.nazwisko,
OPL "Oplata za wizytę pacjenta",
SUM(pr.odplatnosc) OVER (PARTITION  BY WID) "Cena leków",
(pr.procent_ulgi / 100 * (SUM(pr.odplatnosc) OVER (PARTITION  BY WID))) "Cena leków Po Uldze",
SUM(OPL) OVER ( ORDER BY WID RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) "Suma wszystkich dotychczasowych oplat za wizyty pacjentów",
CNZ "Oplata za zabieg pacjenta",
SUM(CNZ) OVER (ORDER BY WID RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) "Suma wszystkich dotychczasowych oplat za zabiegi"
FROM
    (SELECT wizyta_id WID,oplata OPL,cena_netto_za_zabieg CNZ,pacjent_id PID,recepta_id RID 
    FROM h_wizyty 
    WHERE recepta_id IS NOT NULL
    GROUP BY wizyta_id,pacjent_id,recepta_id,oplata,cena_netto_za_zabieg 
),
h_pozycje_recept pr,
h_pacjenci p 
WHERE pr.recepta_id = RID  AND p.pacjent_id = PID 
ORDER BY WID ASC;