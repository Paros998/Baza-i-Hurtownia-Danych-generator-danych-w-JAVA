LOAD DATA
INFILE 'kontakty.csv'
BADFILE 'kontakty.bad'
DISCARDFILE 'kontakty.dsc'
REPLACE INTO TABLE kontakty
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(kontakt_id,telefon,email)