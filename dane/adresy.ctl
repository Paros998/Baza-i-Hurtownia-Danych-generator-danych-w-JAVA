LOAD DATA
INFILE 'adresy.csv'
BADFILE 'adresy.bad'
DISCARDFILE 'adresy.dsc'
REPLACE INTO TABLE adresy
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(adres_id,kod_poczt,miasto,wojewodztwo,ulica,nr_domu,nr_mieszkania)