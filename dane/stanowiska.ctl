LOAD DATA
INFILE 'stanowiska.csv'
BADFILE 'bad/stanowiska.bad'
DISCARDFILE 'dsc/stanowiska.dsc'
REPLACE INTO TABLE stanowiska
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(stanowisko_id,nazwa,pensja,uprawnienie_id)