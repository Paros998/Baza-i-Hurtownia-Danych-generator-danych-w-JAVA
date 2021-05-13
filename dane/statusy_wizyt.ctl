LOAD DATA
INFILE 'statusy_wizyt.csv'
BADFILE 'statusy_wizyt.bad'
DISCARDFILE 'statusy_wizyt.dsc'
REPLACE INTO TABLE statusy_wizyt
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(statusy_wizyt_id,status,opis)