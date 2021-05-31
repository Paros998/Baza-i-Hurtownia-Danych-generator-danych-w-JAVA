MATCH(r:Recepty)-[:fk_Recepty_Wizyty]->(w:Wizyty)-[:fk_Wizyty_Pacjenci]->(p:Pacjenci)
MATCH(pz:Pozycje_recept)-[:fk_Pozycje_Recepty]->(r)
OPTIONAL MATCH(r)-[:fk_Recepty_Ulgi]->(u:Ulgi)
RETURN p.pacjent_id ,p.imie ,p.nazwisko,p.pesel_id,date(w.data_wizyty).year AS rok,
 SUM(pz.odplatnosc) AS WydatkiNaLekiBezUlgi,(SUM(pz.odplatnosc) * u.procent_ulgi / 100) AS WydatkiNaLeki_z_Ulgą order by p.pacjent_id ASC;