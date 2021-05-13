LOAD DATA
INFILE 'choroby.csv'
BADFILE 'choroby.bad'
DISCARDFILE 'choroby.dsc'
REPLACE INTO TABLE choroby
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(choroby_id,nazwa,opis,poczatek DATE "YYYY-MM-DD",koniec DATE "YYYY-MM-DD",pesel_id)