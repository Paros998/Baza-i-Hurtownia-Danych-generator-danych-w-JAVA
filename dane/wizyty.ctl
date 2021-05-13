LOAD DATA
INFILE 'wizyty.csv'
BADFILE 'wizyty.bad'
DISCARDFILE 'wizyty.dsc'
REPLACE INTO TABLE wizyty
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(wizyta_id,oplata,data_wizyty DATE "YYYY-MM-DD",godzina_poczatek,godzina_koniec,pacjent_id,prac_spec,prac_uma,recepta_id,gabinet_id)