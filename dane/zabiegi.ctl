LOAD DATA
INFILE 'zabiegi.csv'
BADFILE 'zabiegi.bad'
DISCARDFILE 'zabiegi.dsc'
REPLACE INTO TABLE zabiegi
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(zabieg_id,nazwa,cena_netto,pracownik_id,wizyta_id)