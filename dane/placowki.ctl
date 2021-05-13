LOAD DATA
INFILE 'placówki.csv'
BADFILE 'placówki.bad'
DISCARDFILE 'placówki.dsc'
REPLACE INTO TABLE placowki
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(placowka_id,nazwa,adres_id,kontakt_id)