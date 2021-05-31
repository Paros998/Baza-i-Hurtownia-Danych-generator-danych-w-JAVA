//łączna wartość roczna za każdy zabieg przeprowadzany na pacjentach z grupą krwi A-
MATCH(z:Zabiegi)-[:fk_Zabiegi_Wizyty]->(w:Wizyty)-[:fk_Wizyty_Pacjenci]->(p:Pacjenci)-[:fk_Pacjenci_Karty]->(k:Karty)
WHERE k.grupa_krwi = "A-"
RETURN z.nazwa,date(w.data_wizyty).year as rok,k.grupa_krwi,
SUM(z.cena_netto) AS SumaZaZabiegi
ORDER BY z.nazwa,rok DESC;

//Id pacjenta,jego imie ,nazwisko , pesel oraz jego Wydatki na leki wciągu jednego roku z ulgą/bez ulgi
MATCH(r:Recepty)-[:fk_Recepty_Wizyty]->(w:Wizyty)-[:fk_Wizyty_Pacjenci]->(p:Pacjenci)
MATCH(pz:Pozycje_recept)-[:fk_Pozycje_Recepty]->(r)
OPTIONAL MATCH(r)-[:fk_Recepty_Ulgi]->(u:Ulgi)
RETURN p.pacjent_id ,p.imie ,p.nazwisko,p.pesel_id,date(w.data_wizyty).year AS rok,
SUM(pz.odplatnosc) AS WydatkiNaLekiBezUlgi,(SUM(pz.odplatnosc) * u.procent_ulgi / 100) AS WydatkiNaLeki_z_Ulgą ORDER BY p.pacjent_id ASC;

//Sumaryczna kwota za wizyty w danej placówce w danym roku
MATCH(w:Wizyty)-[:fk_Wizyty_Gabinety]->(g:Gabinety)-[:fk_Gabinety_Placowki]->(p:Placowki)-[:fk_Placowki_Adresy]->(a:Adresy)
call{
    WITH p,a,w
    RETURN p.placowka_id AS placowka_id, p.nazwa AS placowka,a.miasto AS miasto,date(w.data_wizyty).year AS rok,SUM(w.oplata) AS Suma_w_DanymRoku
}
RETURN placowka_id,placowka,miasto,rok,SUM(Suma_w_DanymRoku) AS Suma_w_DanymRoku
ORDER BY placowka_id ASC,rok DESC;


------- Średnia opłat za wizyty w każdym roku, pacjentów pochodzących z danego miasta ----------
match (w:Wizyty)-[:fk_Wizyty_Pacjenci]->(p:Pacjenci)-[:fk_Pacjenci_Adresy]->(a:Adresy)
return date(w.data_wizyty).year as rok, a.miasto, avg(w.oplata) order by rok

------- Suma dochodów z zabiegów w każdym gabinecie ----------
match (z:Zabiegi)-[:fk_Zabiegi_Wizyty]->(w:Wizyty)-[:fk_Wizyty_Gabinety]->(g:Gabinety)
return w.gabinet_id as identyfikator_gabinetu, sum(z.cena_netto)

------- Suma opłat za leki z każdej recepty, w danym roku ----------
match (pr:Pozycje_recept)-[:fk_Pozycje_Recepty]->(r:Recepty)-[:fk_Recepty_Wizyty]->(w:Wizyty)
return pr.recepta_id as id_recepty, date(w.data_wizyty).year as rok, sum(pr.odplatnosc) as suma order by rok
