LOAD DATA
INFILE 'karty.csv'
BADFILE 'bad/karty.bad'
DISCARDFILE 'dsc/karty.dsc'
REPLACE INTO TABLE karty
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(pesel_id,data_ur DATE "YYYY-MM-DD",grupa_krwi)