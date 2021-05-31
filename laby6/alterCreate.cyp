MATCH(n:Adresy) DETACH DELETE n;
MATCH(n:Choroby) DETACH DELETE n;
MATCH(n:Gabinety) DETACH DELETE n;
MATCH(n:Karty) DETACH DELETE n;
MATCH(n:Kontakty) DETACH DELETE n;
MATCH(n:Oddzialy_nfz) DETACH DELETE n;
MATCH(n:Pacjenci) DETACH DELETE n;
MATCH(n:Placowki) DETACH DELETE n;
MATCH(n:Pozycje_recept)-[r]-() DETACH DELETE r;
MATCH(n:Pozycje_recept) DETACH DELETE n;
MATCH(n:Recepty) DETACH DELETE n;
MATCH(n:Pracownicy) DETACH DELETE n;
MATCH(n:Specjalnosci) DETACH DELETE n;
MATCH(n:Stanowiska) DETACH DELETE n;
MATCH(n:Statusy_wizyt) DETACH DELETE n;
MATCH(n:Ulgi) DETACH DELETE n;
MATCH(n:Uprawnienia) DETACH DELETE n;
MATCH(n:Wizyty) DETACH DELETE n;
MATCH(n:Zabiegi) DETACH DELETE n;
//Rekordy w tabelach
LOAD CSV WITH HEADERS FROM 'file:///ulgi.csv'  AS row
CREATE (:Ulgi{ulgi_id:row.ulgi_id,typ_ulgi:row.typ_ulgi,procent_ulgi:row.procent_ulgi});

LOAD CSV WITH HEADERS FROM 'file:///oddzialy_nfz.csv' AS row
CREATE (:Oddzialy_nfz{oddzial_nfz_id:row.oddzial_nfz_id,nazwa:row.nazwa,kod_funduszu:row.kod_funduszu});

LOAD CSV WITH HEADERS FROM 'file:///adresy.csv' AS row
CREATE (:Adresy {adres_id:row.adres_id,kod_poczt:row.kod_poczt,miasto:row.miasto,wojewodztwo:row.wojewodztwo,ulica:row.ulica,
nr_domu:row.nr_domu,nr_mieszkania:row.nr_mieszkania});

LOAD CSV WITH HEADERS FROM 'file:///kontakty.csv' AS row
CREATE (:Kontakty{kontakt_id:row.kontakt_id,telefon:row.telefon,email:row.email});

LOAD CSV WITH HEADERS FROM 'file:///specjalnosci.csv' AS row
CREATE (:Specjalnosci{specjalnosc_id:row.specjalnosc_id,nazwa:row.nazwa,stopien:row.stopien,dodatek_pensja:row.dodatek_pensja});

LOAD CSV WITH HEADERS FROM 'file:///uprawnienia.csv' AS row
CREATE (:Uprawnienia{uprawnienie_id:row.uprawnienie_id,oznaczenie:row.oznaczenie,opis:row.opis});

LOAD CSV WITH HEADERS FROM 'file:///stanowiska.csv' AS row
CREATE (:Stanowiska{stanowisko_id:row.stanowisko_id,nazwa:row.nazwa,pensja:row.pensja,uprawnienie_id:row.uprawnienie_id});

LOAD CSV WITH HEADERS FROM 'file:///karty.csv' AS row
CREATE (:Karty{pesel_id:row.pesel_id,data_ur:row.data_ur,grupa_krwi:row.grupa_krwi});

LOAD CSV WITH HEADERS FROM 'file:///choroby.csv' AS row FIELDTERMINATOR '*'
CREATE (:Choroby{choroby_id:row.choroby_id,nazwa:row.nazwa,opis:row.opis,poczatek:row.poczatek,koniec:row.koniec,pesel_id:row.pesel_id});

LOAD CSV WITH HEADERS FROM 'file:///placowki.csv' AS row
CREATE (:Placowki{placowka_id:row.placowka_id,nazwa:row.nazwa,adres_id:row.adres_id,kontakt_id:row.kontakt_id});

LOAD CSV WITH HEADERS FROM 'file:///pracownicy.csv' AS row
CREATE (:Pracownicy{pracownik_id:row.pracownik_id,imie:row.imie,nazwisko:row.nazwisko,login:row.login,haslo:row.haslo,pensja:row.pensja,adres_id:row.adres_id,kontakt_id:row.kontakt_id,stanowisko_id:row.stanowisko_id,specjalnosc_id:row.specjalnosc_id});

LOAD CSV WITH HEADERS FROM 'file:///pacjenci.csv' AS row
CREATE (:Pacjenci{pacjent_id:row.pacjent_id,imie:row.imie,nazwisko:row.nazwisko,login:row.login,haslo:row.haslo,pesel_id:row.pesel_id,kontakt_id:row.kontakt_id,adres_id:row.adres_id});

LOAD CSV WITH HEADERS FROM 'file:///gabinety.csv' AS row
CREATE (:Gabinety{gabinet_id:row.gabinet_id,oznaczenie:row.oznaczenie,pracownik_id:row.pracownik_id,kontakt_id:row.kontakt_id,placowka_id:row.placowka_id});

LOAD CSV WITH HEADERS FROM 'file:///wizyty.csv' AS row
CREATE (:Wizyty{wizyta_id:row.wizyta_id,oplata:row.oplata,data_wizyty:row.data_wizyty,godzina_poczatek:row.godzina_poczatek,godzina_koniec:row.godzina_koniec,pacjent_id:row.pacjent_id,prac_spec:row.prac_spec,prac_uma:row.prac_uma,gabinet_id:row.gabinet_id});

LOAD CSV WITH HEADERS FROM 'file:///recepty.csv' AS row
CREATE (:Recepty{recepta_id:row.recepta_id,pracownik_id:row.pracownik_id,wizyta_id:row.wizyta_id,oddzial_nfz_id:row.oddzial_nfz_id,recepta_choroba_id:row.recepta_choroba_id,ulga_id:row.ulga_id});

LOAD CSV WITH HEADERS FROM 'file:///pozycje_recept.csv' AS row
CREATE (:Pozycje_recept{pozycje_recept_id:row.pozycje_recept_id,recepta_id:row.recepta_id,nazwa:row.nazwa,ilosc:row.ilosc,odplatnosc:row.odplatnosc});

LOAD CSV WITH HEADERS FROM 'file:///statusy_wizyt.csv' AS row
CREATE (:Statusy_wizyt{statusy_wizyt_id:row.statusy_wizyt_id,status:row.status,opis:row.opis});

LOAD CSV WITH HEADERS FROM 'file:///zabiegi.csv' AS row
CREATE (:Zabiegi{zabieg_id:row.zabieg_id,nazwa:row.nazwa,cena_netto:row.cena_netto,pracownik_id:row.pracownik_id,wizyta_id:row.wizyta_id});

//Relacje
MATCH(s:Stanowiska) MATCH(u:Uprawnienia) 
WHERE u.uprawnienie_id = s.uprawnienie_id 
CREATE (s)-[:fk_Stanowiska_Uprawnienia]->(u);

MATCH(c:Choroby) MATCH(k:Karty) 
WHERE c.pesel_id = k.pesel_id
CREATE (c)-[:fk_Choroby_Karty]->(k);

MATCH(p:Placowki)MATCH(a:Adresy)MATCH(k:Kontakty)
WHERE p.adres_id = a.adres_id AND p.kontakt_id = k.kontakt_id
CREATE (p)-[:fk_Placowki_Adresy]->(a),(p)-[:fk_Placowki_Kontakty]->(k);

MATCH(p:Pracownicy)MATCH(a:Adresy)MATCH(k:Kontakty)MATCH(st:Stanowiska)
WHERE p.adres_id = a.adres_id AND p.kontakt_id = k.kontakt_id AND p.stanowisko_id = st.stanowisko_id 
CREATE (p)-[:fk_Pracownicy_Adresy]->(a),(p)-[:fk_Pracownicy_Kontakty]->(k),(p)-[:fk_Pracownicy_Stanowiska]->(st);

MATCH(p:Pracownicy)MATCH(sp:Specjalnosci)
WHERE p.specjalnosc_id = sp.specjalnosc_id
CREATE (p)-[:fk_Pracownicy_Specjalnosci]->(sp);

MATCH(p:Pacjenci)MATCH(a:Adresy)MATCH(ko:Kontakty)MATCH(ka:Karty)
WHERE p.adres_id = a.adres_id AND p.kontakt_id = ko.kontakt_id AND p.pesel_id = ka.pesel_id
CREATE (p)-[:fk_Pacjenci_Adresy]->(a),(p)-[:fk_Pacjenci_Kontakty]->(ko),(p)-[:fk_Pacjenci_Karty]->(ka);

MATCH(g:Gabinety)MATCH(p:Pracownicy)MATCH(k:Kontakty)MATCH(pl:Placowki)
WHERE g.kontakt_id = k.kontakt_id AND g.pracownik_id = p.pracownik_id AND g.placowka_id = pl.placowka_id
CREATE (g)-[:fk_Gabinety_Kontakty]->(k),(g)-[:fk_Gabinety_Pracownicy]->(p),(g)-[:fk_Gabinety_Placowki]->(pl);

MATCH(w:Wizyty)MATCH(g:Gabinety)MATCH(ps:Pracownicy)MATCH(pu:Pracownicy)MATCH(pac:Pacjenci)
WHERE w.gabinet_id = g.gabinet_id AND w.prac_spec = ps.pracownik_id AND w.prac_uma = pu.pracownik_id AND w.pacjent_id = pac.pacjent_id
CREATE (w)-[:fk_Wizyty_Gabinety]->(g),(w)-[:fk_Wizyty_Pacjenci]->(pac),(w)-[:fk_Wizyty_Pracownicy_Spec]->(ps),
(w)-[:fk_Wizyty_Pracownicy_Uma]->(pu);

MATCH(r:Recepty)MATCH(p:Pracownicy)MATCH(w:Wizyty)MATCH(o:Oddzialy_nfz)MATCH(c:Choroby)
WHERE r.pracownik_id = p.pracownik_id AND r.wizyta_id = w.wizyta_id AND r.oddzial_nfz_id = o.oddzial_nfz_id AND
r.recepta_choroba_id = c.choroby_id 
CREATE (r)-[:fk_Recepty_Pracownicy]->(p),(r)-[:fk_Recepty_Wizyty]->(w),(r)-[:fk_Recepty_Oddzialy]->(o),(r)-[:fk_Recepty_Choroby]->(c);

MATCH(r:Recepty)MATCH(u:Ulgi)
WHERE r.ulga_id = u.ulgi_id
CREATE (r)-[:fk_Recepty_Ulgi]->(u);

MATCH(pr:Pozycje_recept)MATCH(r:Recepty)
WHERE pr.recepta_id = r.recepta_id
CREATE (pr)-[:fk_Pozycje_Recepty]->(r);

MATCH(w:Wizyty)MATCH(s:Statusy_wizyt)
WHERE w.wizyta_id = s.statusy_wizyt_id
CREATE (s)-[:fk_Statusy_Wizyty]->(w);

MATCH(z:Zabiegi)MATCH(w:Wizyty)MATCH(p:Pracownicy)
WHERE z.wizyta_id = w.wizyta_id AND z.pracownik_id = p.pracownik_id
CREATE (z)-[:fk_Zabiegi_Wizyty]->(w),(z)-[:fk_Zabiegi_Pracownicy]->(p);