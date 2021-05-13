LOAD DATA
INFILE 'choroby.csv'
BADFILE 'bad/choroby.bad'
DISCARDFILE 'dsc/choroby.dsc'
REPLACE INTO TABLE choroby
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(choroby_id,nazwa,opis,poczatek DATE "yyyy-mm-dd",koniec DATE "yyyy-mm-dd",pesel_id)