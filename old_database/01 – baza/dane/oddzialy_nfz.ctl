LOAD DATA
INFILE 'oddzialy_nfz.csv'
BADFILE 'bad/oddzialy_nfz.bad'
DISCARDFILE 'dsc/oddzialy_nfz.dsc'
REPLACE INTO TABLE oddzialy_nfz
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(oddzial_nfz_id,nazwa,kod_funduszu)