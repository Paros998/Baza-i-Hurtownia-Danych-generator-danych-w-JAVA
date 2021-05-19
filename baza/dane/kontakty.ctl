LOAD DATA
INFILE 'kontakty.csv'
BADFILE 'bad/kontakty.bad'
DISCARDFILE 'dsc/kontakty.dsc'
REPLACE INTO TABLE kontakty
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(kontakt_id,telefon,email)