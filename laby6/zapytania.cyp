MATCH(r:Recepty)-[:fk_Recepty_Wizyty]->(w:Wizyty)-[:fk_Wizyty_Pacjenci]->(p:Pacjenci)
MATCH(pz:Pozycje_recept)-[:fk_Pozycje_Recepty]->(r)
OPTIONAL MATCH(r)-[:fk_Recepty_Ulgi]->(u:Ulgi)
RETURN p.pacjent_id ,p.imie ,p.nazwisko,p.pesel_id,date(w.data_wizyty).year AS rok,
 SUM(pz.odplatnosc) AS WydatkiNaLekiBezUlgi,(SUM(pz.odplatnosc) * u.procent_ulgi / 100) AS WydatkiNaLeki_z_Ulgą order by p.pacjent_id ASC;

------- Średnia opłat za wizyty w każdym roku, pacjentów pochodzących z danego miasta ----------
match (w:Wizyty)-[:fk_Wizyty_Pacjenci]->(p:Pacjenci)-[:fk_Pacjenci_Adresy]->(a:Adresy)
return date(w.data_wizyty).year as rok, a.miasto, avg(w.oplata) order by rok

------- Suma dochodów z zabiegów w każdym gabinecie ----------
match (z:Zabiegi)-[:fk_Zabiegi_Wizyty]->(w:Wizyty)-[:fk_Wizyty_Gabinety]->(g:Gabinety)
return w.gabinet_id as identyfikator_gabinetu, sum(z.cena_netto)

------- Suma opłat za leki z każdej recepty, w danym roku ----------
match (pr:Pozycje_recept)-[:fk_Pozycje_Recepty]->(r:Recepty)-[:fk_Recepty_Wizyty]->(w:Wizyty)
return pr.recepta_id as id_recepty, date(w.data_wizyty).year as rok, sum(pr.odplatnosc) as suma order by rok