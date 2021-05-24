LOAD DATA
INFILE 'adresy.csv'
BADFILE 'bad/adresy.bad'
DISCARDFILE 'dsc/adresy.dsc'
REPLACE INTO TABLE adresy
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(adres_id,kod_poczt,miasto,wojewodztwo,ulica,nr_domu,nr_mieszkania)