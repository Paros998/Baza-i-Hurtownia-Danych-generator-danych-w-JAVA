LOAD DATA
INFILE 'recepty.csv'
BADFILE 'recepty.bad'
DISCARDFILE 'recepty.dsc'
REPLACE INTO TABLE recepty
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(recepta_id,pracownik_id,oddzial_nfz_id,recepta_choroba_id,ulga_id)