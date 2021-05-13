LOAD DATA
INFILE 'placowki.csv'
BADFILE 'bad/placowki.bad'
DISCARDFILE 'dsc/placowki.dsc'
REPLACE INTO TABLE placowki
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(placowka_id,nazwa,adres_id,kontakt_id)