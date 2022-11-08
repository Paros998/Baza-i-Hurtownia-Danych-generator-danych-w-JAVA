LOAD DATA
INFILE 'uprawnienia.csv'
BADFILE 'bad/uprawnienia.bad'
DISCARDFILE 'dsc/uprawnienia.dsc'
REPLACE INTO TABLE uprawnienia
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(uprawnienie_id,oznaczenie,opis)