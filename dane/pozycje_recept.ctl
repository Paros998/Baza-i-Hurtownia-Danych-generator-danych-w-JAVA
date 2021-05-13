LOAD DATA
INFILE 'pozycje_recept.csv'
BADFILE 'bad/pozycje_recept.bad'
DISCARDFILE 'dsc/pozycje_recept.dsc'
REPLACE INTO TABLE pozycje_recept
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(pozycje_recept_id,recepta_id,nazwa,ilosc,odplatnosc)