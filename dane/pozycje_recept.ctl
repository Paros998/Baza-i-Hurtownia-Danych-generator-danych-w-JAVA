LOAD DATA
INFILE 'pozycje_recept.csv'
BADFILE 'pozycje_recept.bad'
DISCARDFILE 'pozycje_recept.dsc'
REPLACE INTO TABLE pozycje_recept
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(pozycje_recept_id,recepta_id,nazwa,ilosc,odplatnosc)