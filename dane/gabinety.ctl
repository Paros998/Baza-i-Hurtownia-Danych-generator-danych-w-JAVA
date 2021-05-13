LOAD DATA
INFILE 'gabinety.csv'
BADFILE 'gabinety.bad'
DISCARDFILE 'gabinety.dsc'
REPLACE INTO TABLE gabinety
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(gabinet_id,oznaczenie,pracownik_id,kontakt_id,placowka_id)