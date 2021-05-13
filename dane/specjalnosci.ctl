LOAD DATA
INFILE 'specjalnosci.csv'
BADFILE 'specjalnosci.bad'
DISCARDFILE 'specjalnosci.dsc'
REPLACE INTO TABLE specjalnosci
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(specjalnosc_id,nazwa,stopien,dodatek_pensja)