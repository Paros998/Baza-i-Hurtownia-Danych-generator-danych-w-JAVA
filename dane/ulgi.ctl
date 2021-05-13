LOAD DATA
INFILE 'ulgi.csv'
BADFILE 'ulgi.bad'
DISCARDFILE 'ulgi.dsc'
REPLACE INTO TABLE ulgi
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(ulgi_id,typ_ulgi,procent_ulgi)