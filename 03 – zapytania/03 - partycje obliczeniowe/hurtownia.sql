---------------------------------------------- PARTYCJE OBLICZENIOWE ----------------------------------------------------------------
--Łaczna wartość roczna za każdy zabieg przeprowadzany na pacjentach z grupą krwi A-
SELECT DISTINCT z.nazwa Nazwa,
d.rok Rok,
p.grupa_krwi,
SUM(CNZ)OVER(PARTITION BY d.rok,p.grupa_krwi,z.nazwa) CNZ 
FROM
    (SELECT wizyta_id WID,pacjent_id PID,zabieg_id ZID,SUM(cena_netto_za_zabieg) CNZ,data_wizyty_id DID 
    FROM h_wizyty 
    WHERE zabieg_id IS NOT NULL 
    AND pacjent_id IN (SELECT pacjent_id 
                       FROM h_pacjenci 
                       WHERE h_pacjenci.grupa_krwi = 'A-'
                       ) 
    GROUP BY wizyta_id,pacjent_id,zabieg_id,data_wizyty_id
    ),
    h_zabiegi z,
    h_daty_wizyt d,
    h_pacjenci p 
    WHERE z.zabieg_id = ZID 
    AND d.data_id = DID 
    AND p.pacjent_id  = PID
ORDER BY Nazwa,Rok DESC;

--Id pacjenta,jego imie ,nazwisko , pesel oraz jego Wydatki na leki wciągu jednego roku z ulgą/bez ulgi
SELECT DISTINCT PID AS Pacjent_ID,
imie,
nazwisko,
pesel AS Pesel_id,
rok AS Rok,
SUM(ODP) OVER (PARTITION BY PID,rok) AS "Wydatki Pacjenta Na Leki Bez Ulgi",
(SUM(ODP) OVER (PARTITION BY PID,rok) * (PUL / 100) ) AS "Wydatki Pacjenta Na Leki Z Wliczona Ulga" 
FROM
    (SELECT p.pacjent_id PID,p.imie imie,p.nazwisko nazwisko,p.pesel pesel,d.rok rok,SUM(pr.odplatnosc) ODP,pr.procent_ulgi PUL 
    FROM 
        (SELECT pacjent_id PID,data_wizyty_id DID ,recepta_id RID  
        FROM h_wizyty w 
        WHERE recepta_id IS NOT NULL
        ),
        h_pacjenci p,
        h_daty_wizyt d,
        h_pozycje_recept pr 
        WHERE p.pacjent_id = PID 
        AND d.data_id = DID 
        AND pr.recepta_id = RID
        GROUP BY p.pacjent_id,p.imie,p.nazwisko,p.pesel,d.rok,pr.procent_ulgi
    )
ORDER BY PID ASC,Rok DESC;

-- Procentowy udzial oplat za wizyte, w danym roku, w okreslonej placowce, znajdujacej sie w okreslonym miescie, na przestrzeni wszystkich lat
SELECT DISTINCT 
PID AS Placowka_id,
nazwa AS nazwa_placowki,
miasto AS miasto,
rok as rok, 
SUM (OPL) OVER (PARTITION BY rok, PID, miasto) suma_w_danym_roku,
SUM (OPL) OVER (PARTITION BY PID, miasto) suma_na_przestrzeni_lat,
ROUND (100 * (SUM (OPL) OVER (PARTITION BY rok, PID, miasto)) / SUM (OPL) OVER (PARTITION BY PID, miasto))"UDZIAL % danego roku" 
FROM
    (SELECT placowka_id PID, p.nazwa nazwa,p.miasto miasto,d.rok rok, SUM(OPL) OPL 
    FROM
        (SELECT gabinet_id GID,SUM(oplata) OPL,data_wizyty_id DID 
        FROM h_wizyty 
        GROUP BY gabinet_id,data_wizyty_id
        ),
    h_placowki p,
    h_daty_wizyt d 
    WHERE p.placowka_id IN (SELECT placowka_id 
                            FROM h_gabinety 
                            WHERE gabinet_id = GID)
    AND d.data_id = DID
    GROUP BY placowka_id,p.nazwa,p.miasto,d.rok
    )
ORDER BY PID ASC, rok DESC;