LOAD DATA
INFILE 'pracownicy.csv'
BADFILE 'pracownicy.bad'
DISCARDFILE 'pracownicy.dsc'
REPLACE INTO TABLE pracownicy
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(pracownik_id,imie,nazwisko,login,haslo,pensja,adres_id,kontakt_id,stanowisko_id,specjalnosc_id)