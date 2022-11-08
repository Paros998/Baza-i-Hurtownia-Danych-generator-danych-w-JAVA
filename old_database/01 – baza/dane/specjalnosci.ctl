LOAD DATA
INFILE 'specjalnosci.csv'
BADFILE 'bad/specjalnosci.bad'
DISCARDFILE 'dsc/specjalnosci.dsc'
REPLACE INTO TABLE specjalnosci
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(specjalnosc_id,nazwa,stopien,dodatek_pensja)