LOAD DATA
INFILE 'uprawnienia.csv'
BADFILE 'uprawnienia.bad'
DISCARDFILE 'uprawnienia.dsc'
REPLACE INTO TABLE uprawnienia
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(uprawnienie_id,oznaczenie,opis)