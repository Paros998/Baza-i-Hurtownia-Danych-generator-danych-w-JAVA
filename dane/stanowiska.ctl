LOAD DATA
INFILE 'stanowiska.csv'
BADFILE 'stanowiska.bad'
DISCARDFILE 'stanowiska.dsc'
REPLACE INTO TABLE stanowiska
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(stanowisko_id,nazwa,pensja,uprawnienie_id)