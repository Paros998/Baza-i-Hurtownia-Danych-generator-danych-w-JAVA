LOAD DATA
INFILE 'statusy_wizyt.csv'
BADFILE 'bad/statusy_wizyt.bad'
DISCARDFILE 'dsc/statusy_wizyt.dsc'
REPLACE INTO TABLE statusy_wizyt
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(statusy_wizyt_id,status,opis)