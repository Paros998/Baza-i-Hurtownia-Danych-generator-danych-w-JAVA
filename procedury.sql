CREATE OR REPLACE PROCEDURE transformacja_placowki IS
P_ID placowki.placowka_id%type := 1;
ID_A placowki.adres_id%type;
ID_K placowki.kontakt_id%type;

nazwa placowki.nazwa%type;

telefon kontakty.telefon%type;
email kontakty.email%type;

kod_poczt adresy.kod_poczt%type;
miasto adresy.miasto%type;
wojewodztwo adresy.wojewodztwo%type;
ulica adresy.ulica%type;
nrdomu adresy.nr_domu%type;
nrmieszkania adresy.nr_mieszkania%type;

CURSOR pobierz_nazwe(IDP IN NUMBER) IS SELECT
p.nazwa FROM placowki p WHERE p.placowka_id = IDP;
CURSOR pobierz_ida(IDP IN NUMBER) IS SELECT
p.adres_id FROM placowki p WHERE p.placowka_id = IDP;
CURSOR pobierz_idk(IDP IN NUMBER) IS SELECT
p.kontakt_id FROM placowki p WHERE p.placowka_id = IDP;

CURSOR pobierz_tel(IDK IN NUMBER) IS SELECT 
k.telefon FROM kontakty k WHERE k.kontakt_id = IDK;
CURSOR pobierz_email(IDK IN NUMBER) IS SELECT 
k.email FROM kontakty k WHERE k.kontakt_id = IDK;

CURSOR pobierz_kod(IDA IN NUMBER) IS SELECT 
a.kod_poczt FROM adresy a WHERE a.adres_id = IDA;
CURSOR pobierz_miasto(IDA IN NUMBER) IS SELECT 
a.miasto FROM adresy a WHERE a.adres_id = IDA;
CURSOR pobierz_woj(IDA IN NUMBER) IS SELECT 
a.wojewodztwo FROM adresy a WHERE a.adres_id = IDA;
CURSOR pobierz_ul(IDA IN NUMBER) IS SELECT 
a.ulica FROM adresy a WHERE a.adres_id = IDA;
CURSOR pobierz_dom(IDA IN NUMBER) IS SELECT 
a.nr_domu FROM adresy a WHERE a.adres_id = IDA;
CURSOR pobierz_mieszk(IDA IN NUMBER) IS SELECT 
a.nr_mieszkania FROM adresy a WHERE a.adres_id = IDA;
BEGIN

LOOP
    OPEN pobierz_nazwe(P_ID);
        FETCH pobierz_nazwe INTO nazwa;
    CLOSE pobierz_nazwe;
    OPEN pobierz_ida(P_ID);
        FETCH pobierz_ida INTO ID_A;
    CLOSE pobierz_ida;
    OPEN pobierz_idk(P_ID);
        FETCH pobierz_idk INTO ID_K;
    CLOSE pobierz_idk;
    OPEN pobierz_tel(ID_K);
        FETCH pobierz_tel INTO telefon;
    CLOSE pobierz_tel;
    OPEN pobierz_email(ID_K);
        FETCH pobierz_email INTO email;
    CLOSE pobierz_email;
    OPEN pobierz_kod(ID_A);
        FETCH pobierz_kod INTO kod_poczt;
    CLOSE pobierz_kod;
    OPEN pobierz_miasto(ID_A);
        FETCH pobierz_miasto INTO miasto;
    CLOSE pobierz_miasto;
    OPEN pobierz_woj(ID_A);
        FETCH pobierz_woj INTO wojewodztwo;
    CLOSE pobierz_woj;
    OPEN pobierz_ul(ID_A);
        FETCH pobierz_ul INTO ulica;
    CLOSE pobierz_ul;
    OPEN pobierz_dom(ID_A);
        FETCH pobierz_dom INTO nrdomu;
    CLOSE pobierz_dom;
    OPEN pobierz_mieszk(ID_A);
        FETCH pobierz_mieszk INTO nrmieszkania;
    CLOSE pobierz_mieszk;

    INSERT INTO h_placowki VALUES(P_ID,nazwa,telefon,email,kod_poczt,miasto,wojewodztwo,ulica,nrdomu,nrmieszkania);
    
    P_ID := P_ID + 1;
    EXIT WHEN P_ID = 10001;
END LOOP;
END;

/

create or replace NONEDITIONABLE PROCEDURE transformacja_gabinety IS
G_ID gabinety.gabinet_id%type := 1;
oznaczenie gabinety.oznaczenie%type;

P_ID placowki.placowka_id%type ;
ID_K placowki.kontakt_id%type;


telefon kontakty.telefon%type;
email kontakty.email%type;

CURSOR pobierz_oznaczenie(IDG IN NUMBER)IS SELECT
g.oznaczenie FROM gabinety g WHERE g.gabinet_id = IDG;
CURSOR pobierz_idp(IDG IN NUMBER)IS SELECT
g.placowka_id FROM gabinety g WHERE g.gabinet_id = IDG;
CURSOR pobierz_idk(IDG IN NUMBER) IS SELECT
g.kontakt_id FROM gabinety g WHERE g.gabinet_id = IDG;

CURSOR pobierz_tel(IDK IN NUMBER) IS SELECT 
k.telefon FROM kontakty k WHERE k.kontakt_id = IDK;
CURSOR pobierz_email(IDK IN NUMBER) IS SELECT 
k.email FROM kontakty k WHERE k.kontakt_id = IDK;


BEGIN

LOOP
    OPEN pobierz_oznaczenie(G_ID);
        FETCH pobierz_oznaczenie INTO oznaczenie;
    CLOSE pobierz_oznaczenie;
    OPEN pobierz_idp(G_ID);
        FETCH pobierz_idp INTO P_ID;
    CLOSE pobierz_idp;
    OPEN pobierz_idk(P_ID);
        FETCH pobierz_idk INTO ID_K;
    CLOSE pobierz_idk;
    OPEN pobierz_tel(ID_K);
        FETCH pobierz_tel INTO telefon;
    CLOSE pobierz_tel;
    OPEN pobierz_email(ID_K);
        FETCH pobierz_email INTO email;
    CLOSE pobierz_email;
    
    INSERT INTO h_gabinety VALUES(G_ID,oznaczenie,P_ID,telefon,email);

    G_ID := G_ID + 1;
    EXIT WHEN G_ID = 10001;
END LOOP;
END;

/

CREATE OR REPLACE PROCEDURE transformacja_pacjenci IS
P_ID pacjenci.pacjent_id%type := 1;
ID_A pacjenci.adres_id%type;
ID_K pacjenci.kontakt_id%type;
ID_MAX pacjenci.pacjent_id%TYPE;

imie pacjenci.imie%TYPE;
nazwisko pacjenci.nazwisko%TYPE;
login pacjenci.login%TYPE;
haslo pacjenci.haslo%TYPE;
pesel pacjenci.pesel_id%TYPE;

data_ur karty.data_ur%TYPE;
grupa_krwi karty.grupa_krwi%TYPE;

telefon kontakty.telefon%type;
email kontakty.email%type;

kod_poczt adresy.kod_poczt%type;
miasto adresy.miasto%type;
wojewodztwo adresy.wojewodztwo%type;
ulica adresy.ulica%type;
nrdomu adresy.nr_domu%type;
nrmieszkania adresy.nr_mieszkania%type;

CURSOR pobierz_max_id IS
SELECT MAX(pacjent_id) FROM pacjenci;

-- KARTY
CURSOR pobierz_date_ur(pesel_pac karty.pesel_id%TYPE) IS
SELECT data_ur FROM karty WHERE pesel_id = pesel_pac;

CURSOR pobierz_grupe_krwi(pesel_pac karty.pesel_id%TYPE) IS
SELECT grupa_krwi FROM karty WHERE pesel_id = pesel_pac;

-- PACJENCI
CURSOR pobierz_pesel(IDP IN NUMBER) IS
SELECT pesel_id FROM pacjenci WHERE pacjent_id = IDP;

CURSOR pobierz_ida(IDP IN NUMBER) IS SELECT
p.adres_id FROM pacjenci p WHERE p.pacjent_id = IDP;

CURSOR pobierz_idk(IDP IN NUMBER) IS SELECT
p.kontakt_id FROM pacjenci p WHERE p.pacjent_id = IDP;

CURSOR pobierz_imie(IDP IN NUMBER) IS
SELECT imie FROM pacjenci WHERE pacjent_id = IDP;

CURSOR pobierz_nazwisko(IDP IN NUMBER) IS
SELECT nazwisko FROM pacjenci WHERE pacjent_id = IDP;

CURSOR pobierz_login(IDP IN NUMBER) IS
SELECT login FROM pacjenci WHERE pacjent_id = IDP;

CURSOR pobierz_haslo(IDP IN NUMBER) IS
SELECT haslo FROM pacjenci WHERE pacjent_id = IDP;

-- KONTAKTY
CURSOR pobierz_tel(IDK IN NUMBER) IS SELECT 
k.telefon FROM kontakty k WHERE k.kontakt_id = IDK;

CURSOR pobierz_email(IDK IN NUMBER) IS SELECT 
k.email FROM kontakty k WHERE k.kontakt_id = IDK;

-- ADRESY
CURSOR pobierz_kod(IDA IN NUMBER) IS SELECT 
a.kod_poczt FROM adresy a WHERE a.adres_id = IDA;
CURSOR pobierz_miasto(IDA IN NUMBER) IS SELECT 
a.miasto FROM adresy a WHERE a.adres_id = IDA;
CURSOR pobierz_woj(IDA IN NUMBER) IS SELECT 
a.wojewodztwo FROM adresy a WHERE a.adres_id = IDA;
CURSOR pobierz_ul(IDA IN NUMBER) IS SELECT 
a.ulica FROM adresy a WHERE a.adres_id = IDA;
CURSOR pobierz_dom(IDA IN NUMBER) IS SELECT 
a.nr_domu FROM adresy a WHERE a.adres_id = IDA;
CURSOR pobierz_mieszk(IDA IN NUMBER) IS SELECT 
a.nr_mieszkania FROM adresy a WHERE a.adres_id = IDA;

BEGIN
    OPEN pobierz_max_id;
        FETCH pobierz_max_id INTO ID_MAX;
    CLOSE pobierz_max_id;

LOOP
    OPEN pobierz_imie(P_ID);
        FETCH pobierz_imie INTO imie;
    CLOSE pobierz_imie;
    
    OPEN pobierz_nazwisko(P_ID);
        FETCH pobierz_nazwisko INTO nazwisko;
    CLOSE pobierz_nazwisko;
    
    OPEN pobierz_login(P_ID);
        FETCH pobierz_login INTO login;
    CLOSE pobierz_login;
    
    OPEN pobierz_haslo(P_ID);
        FETCH pobierz_haslo INTO haslo;
    CLOSE pobierz_haslo;
    
    OPEN pobierz_pesel(P_ID);
        FETCH pobierz_pesel INTO pesel;
    CLOSE pobierz_pesel;
    
    OPEN pobierz_date_ur(pesel);
        FETCH pobierz_date_ur INTO data_ur;
    CLOSE pobierz_date_ur;
    
    OPEN pobierz_grupe_krwi(pesel);
        FETCH pobierz_grupe_krwi INTO grupa_krwi;
    CLOSE pobierz_grupe_krwi;
    
    OPEN pobierz_ida(P_ID);
        FETCH pobierz_ida INTO ID_A;
    CLOSE pobierz_ida;
    OPEN pobierz_idk(P_ID);
        FETCH pobierz_idk INTO ID_K;
    CLOSE pobierz_idk;
    OPEN pobierz_tel(ID_K);
        FETCH pobierz_tel INTO telefon;
    CLOSE pobierz_tel;
    OPEN pobierz_email(ID_K);
        FETCH pobierz_email INTO email;
    CLOSE pobierz_email;
    OPEN pobierz_kod(ID_A);
        FETCH pobierz_kod INTO kod_poczt;
    CLOSE pobierz_kod;
    OPEN pobierz_miasto(ID_A);
        FETCH pobierz_miasto INTO miasto;
    CLOSE pobierz_miasto;
    OPEN pobierz_woj(ID_A);
        FETCH pobierz_woj INTO wojewodztwo;
    CLOSE pobierz_woj;
    OPEN pobierz_ul(ID_A);
        FETCH pobierz_ul INTO ulica;
    CLOSE pobierz_ul;
    OPEN pobierz_dom(ID_A);
        FETCH pobierz_dom INTO nrdomu;
    CLOSE pobierz_dom;
    OPEN pobierz_mieszk(ID_A);
        FETCH pobierz_mieszk INTO nrmieszkania;
    CLOSE pobierz_mieszk;

    INSERT INTO h_pacjenci VALUES(P_ID,imie,nazwisko,login,haslo,telefon,email,kod_poczt,miasto,wojewodztwo,ulica,nrdomu,nrmieszkania,pesel,data_ur,grupa_krwi);
    
    P_ID := P_ID + 1;
    EXIT WHEN P_ID = ID_MAX;
END LOOP;

END;
create or replace NONEDITIONABLE PROCEDURE transformacja_specjalnosci IS
S_ID specjalnosci.specjalnosc_id%type := 1;
nazwa specjalnosci.nazwa%type;
stopien specjalnosci.stopien%type;
dodatek specjalnosci.dodatek_pensja%type;

CURSOR pobierz_n(IDS IN NUMBER)IS SELECT
s.nazwa FROM specjalnosci s WHERE s.specjalnosc_id = IDS ;
CURSOR pobierz_s(IDS IN NUMBER)IS SELECT
s.stopien FROM specjalnosci s WHERE s.specjalnosc_id = IDS ;
CURSOR pobierz_d(IDS IN NUMBER)IS SELECT
s.dodatek_pensja FROM specjalnosci s WHERE s.specjalnosc_id = IDS ;

BEGIN
LOOP
    OPEN pobierz_n(S_ID);
        FETCH pobierz_n INTO nazwa;
    CLOSE pobierz_n;
    OPEN pobierz_s(S_ID);
        FETCH pobierz_s INTO stopien;
    CLOSE pobierz_s;
    OPEN pobierz_d(S_ID);
        FETCH pobierz_d INTO dodatek;
    CLOSE pobierz_d;
    
    INSERT INTO h_specjalnosci VALUES(S_ID,nazwa,stopien,dodatek);
    
    S_ID := S_ID + 1;
    EXIT WHEN S_ID = 101;
END LOOP;
END;

/
create or replace NONEDITIONABLE PROCEDURE transformacja_stanowiska IS
S_ID stanowiska.stanowisko_id%type := 1;
U_ID stanowiska.uprawnienie_id%type;
nazwa stanowiska.nazwa%type;
pensja stanowiska.pensja%type;
oznaczenie uprawnienia.oznaczenie%type;
opis uprawnienia.opis%type;

CURSOR p_u(IDS IN NUMBER) IS SELECT
s.uprawnienie_id FROM stanowiska s WHERE s.stanowisko_id = IDS ; 
CURSOR p_n(IDS IN NUMBER) IS SELECT
s.nazwa FROM stanowiska s WHERE s.stanowisko_id = IDS ; 
CURSOR p_p(IDS IN NUMBER) IS SELECT
s.pensja FROM stanowiska s WHERE s.stanowisko_id = IDS ; 

CURSOR p_oz(IDU IN NUMBER) IS SELECT
u.oznaczenie FROM uprawnienia u WHERE u.uprawnienie_id = IDU;
CURSOR p_op(IDU IN NUMBER) IS SELECT
u.opis FROM uprawnienia u WHERE u.uprawnienie_id = IDU;
BEGIN
LOOP
    OPEN p_u(S_ID);
        FETCH p_u INTO U_ID;
    CLOSE p_u;
    OPEN p_n(S_ID);
        FETCH p_n INTO nazwa;
    CLOSE p_n;
    OPEN p_p(S_ID);
        FETCH p_p INTO pensja;
    CLOSE p_p;
    OPEN p_oz(U_ID);
        FETCH p_oz INTO oznaczenie;
    CLOSE p_oz;
    OPEN p_op(U_ID);
        FETCH p_op INTO opis;
    CLOSE p_op;
    
    INSERT INTO h_stanowiska VALUES(S_ID,nazwa,pensja,oznaczenie,opis);

    S_ID := S_ID + 1;
    EXIT WHEN S_ID = 10001;
END LOOP;
END;

/
create or replace NONEDITIONABLE PROCEDURE transformacja_pracownicy IS
P_ID pracownicy.pracownik_id%type := 1;
ID_K pracownicy.kontakt_id%type;
ID_A pracownicy.adres_id%type;
ID_SP pracownicy.specjalnosc_id%type;
ID_ST pracownicy.stanowisko_id%type;

imie pracownicy.imie%TYPE;
nazwisko pracownicy.nazwisko%TYPE;
login pracownicy.login%TYPE;
haslo pracownicy.haslo%TYPE;
pensja pracownicy.pensja%type;

telefon kontakty.telefon%type;
email kontakty.email%type;

kod_poczt adresy.kod_poczt%type;
miasto adresy.miasto%type;
wojewodztwo adresy.wojewodztwo%type;
ulica adresy.ulica%type;
nrdomu adresy.nr_domu%type;
nrmieszkania adresy.nr_mieszkania%type;
--Id
CURSOR p_k(IDP IN NUMBER) IS
SELECT p.kontakt_id FROM pracownicy p WHERE p.pracownik_id = IDP;

CURSOR p_a(IDP IN NUMBER) IS
SELECT p.adres_id FROM pracownicy p WHERE p.pracownik_id = IDP;

CURSOR p_st(IDP IN NUMBER) IS
SELECT p.stanowisko_id FROM pracownicy p WHERE p.pracownik_id = IDP;

CURSOR p_sp(IDP IN NUMBER) IS
SELECT p.specjalnosc_id FROM pracownicy p WHERE p.pracownik_id = IDP;
--Pracownicy
CURSOR pobierz_imie(IDP IN NUMBER) IS
SELECT imie FROM pracownicy p WHERE p.pracownik_id = IDP;

CURSOR pobierz_nazwisko(IDP IN NUMBER) IS
SELECT nazwisko FROM pracownicy p WHERE p.pracownik_id = IDP;

CURSOR pobierz_login(IDP IN NUMBER) IS
SELECT login FROM pracownicy p WHERE p.pracownik_id = IDP;

CURSOR pobierz_haslo(IDP IN NUMBER) IS
SELECT haslo FROM pracownicy p WHERE p.pracownik_id = IDP;

CURSOR pobierz_pensja(IDP IN NUMBER) IS 
SELECT pensja FROM pracownicy p WHERE p.pracownik_id = IDP;

--Kontakty
CURSOR pobierz_tel(IDK IN NUMBER) IS SELECT 
k.telefon FROM kontakty k WHERE k.kontakt_id = IDK;

CURSOR pobierz_email(IDK IN NUMBER) IS SELECT 
k.email FROM kontakty k WHERE k.kontakt_id = IDK;

--Adresy
CURSOR pobierz_kod(IDA IN NUMBER) IS SELECT 
a.kod_poczt FROM adresy a WHERE a.adres_id = IDA;

CURSOR pobierz_miasto(IDA IN NUMBER) IS SELECT 
a.miasto FROM adresy a WHERE a.adres_id = IDA;

CURSOR pobierz_woj(IDA IN NUMBER) IS SELECT 
a.wojewodztwo FROM adresy a WHERE a.adres_id = IDA;

CURSOR pobierz_ul(IDA IN NUMBER) IS SELECT 
a.ulica FROM adresy a WHERE a.adres_id = IDA;

CURSOR pobierz_dom(IDA IN NUMBER) IS SELECT 
a.nr_domu FROM adresy a WHERE a.adres_id = IDA;

CURSOR pobierz_mieszk(IDA IN NUMBER) IS SELECT 
a.nr_mieszkania FROM adresy a WHERE a.adres_id = IDA;

BEGIN
LOOP
   --Pracownicy
    OPEN pobierz_imie(P_ID);
        FETCH pobierz_imie INTO imie;
    CLOSE pobierz_imie;
    
    OPEN pobierz_nazwisko(P_ID);
        FETCH pobierz_nazwisko INTO nazwisko;
    CLOSE pobierz_nazwisko;
    
    OPEN pobierz_login(P_ID);
        FETCH pobierz_login INTO login;
    CLOSE pobierz_login;
    
    OPEN pobierz_haslo(P_ID);
        FETCH pobierz_haslo INTO haslo;
    CLOSE pobierz_haslo;
    
    OPEN pobierz_pensja(P_ID);
        FETCH pobierz_pensja INTO pensja;
    CLOSE pobierz_pensja;
    
    OPEN p_st(P_ID);
        FETCH p_st INTO ID_ST;
    CLOSE p_st;
    
    OPEN p_sp(P_ID);
        FETCH p_sp INTO ID_SP;
    CLOSE p_sp;
    --Kontakty
    OPEN p_k(P_ID);
        FETCH p_k INTO ID_K;
    CLOSE p_k;
    
    OPEN pobierz_tel(ID_K);
        FETCH pobierz_tel INTO telefon;
    CLOSE pobierz_tel;
    
    OPEN pobierz_email(ID_K);
        FETCH pobierz_email INTO email;
    CLOSE pobierz_email;
    --Adresy
    
    OPEN p_a(P_ID);
        FETCH p_a INTO ID_A;
    CLOSE p_a;
    
    OPEN pobierz_kod(ID_A);
        FETCH pobierz_kod INTO kod_poczt;
    CLOSE pobierz_kod;
    
    OPEN pobierz_miasto(ID_A);
        FETCH pobierz_miasto INTO miasto;
    CLOSE pobierz_miasto;
    
    OPEN pobierz_woj(ID_A);
        FETCH pobierz_woj INTO wojewodztwo;
    CLOSE pobierz_woj;
    
    OPEN pobierz_ul(ID_A);
        FETCH pobierz_ul INTO ulica;
    CLOSE pobierz_ul;
    
    OPEN pobierz_dom(ID_A);
        FETCH pobierz_dom INTO nrdomu;
    CLOSE pobierz_dom;
    
    OPEN pobierz_mieszk(ID_A);
        FETCH pobierz_mieszk INTO nrmieszkania;
    CLOSE pobierz_mieszk;
    
    INSERT INTO h_pracownicy VALUES(P_ID,imie,nazwisko,login,haslo,pensja,telefon,email,kod_poczt,miasto,wojewodztwo,ulica,nrdomu,nrmieszkania,ID_ST,ID_SP);
    
    P_ID := P_ID + 1;
    EXIT WHEN P_ID = 10001;
END LOOP;
END;

/

create or replace NONEDITIONABLE PROCEDURE transformacja_choroby IS
C_ID choroby.choroby_id%type := 1;

CURSOR p_c(IDC IN NUMBER) IS
SELECT c.nazwa,c.opis,c.poczatek,c.koniec FROM choroby c WHERE c.choroby_id = IDC;

wiersz p_c%ROWTYPE;
BEGIN
LOOP
    OPEN p_c(C_ID);
        FETCH p_c INTO wiersz;
    CLOSE p_c;
    
    INSERT INTO h_choroby VALUES(c_ID,wiersz.nazwa,wiersz.opis,wiersz.poczatek,wiersz.koniec);

    C_ID := C_ID + 1;
    EXIT WHEN C_ID = 10001;
END LOOP;
END;

/
create or replace NONEDITIONABLE PROCEDURE transformacja_recepty IS
R_ID recepty.recepta_id%type := 1;
C_ID recepty.recepta_choroba_id%type;
O_ID oddzialy_nfz.oddzial_nfz_id%type;
MAX_ID recepty.recepta_id%type;

CURSOR p_r(IDR IN NUMBER) IS
SELECT r.recepta_choroba_id,r.oddzial_nfz_id FROM recepty r WHERE r.recepta_id = IDR;

CURSOR p_o(IDO IN NUMBER) IS
SELECT o.nazwa,o.kod_funduszu FROM oddzialy_nfz o WHERE o.oddzial_nfz_id= IDO;

wiersz1 p_r%ROWTYPE;
wiersz2 p_o%ROWTYPE;
BEGIN

SELECT MAX(recepta_id) INTO MAX_ID FROM recepty;

LOOP
    OPEN p_r(R_ID);
        FETCH p_r INTO wiersz1;
    CLOSE p_r;

    O_ID := wiersz1.oddzial_nfz_id;
    C_ID := wiersz1.recepta_choroba_id;

    OPEN p_o(O_ID);
        FETCH p_o INTO wiersz2;
    CLOSE p_o;

    INSERT INTO h_recepty VALUES(R_ID,wiersz1.recepta_choroba_id,wiersz2.nazwa,wiersz2.kod_funduszu);

    R_ID := R_ID + 1;
    EXIT WHEN R_ID = MAX_ID + 1;
END LOOP;
END;

/


CREATE OR REPLACE PROCEDURE transformacja_zabiegi IS

Z_ID zabiegi.zabieg_id%TYPE := 1;
MAX_ID zabiegi.zabieg_id%TYPE;

CURSOR pobierz_max_id IS
SELECT MAX(zabieg_id) FROM zabiegi;

CURSOR pobierz_zabiegi(ZID IN NUMBER) IS
SELECT nazwa FROM zabiegi WHERE zabieg_id = ZID;

wiersz pobierz_zabiegi%ROWTYPE;

BEGIN
    OPEN pobierz_max_id;
        FETCH pobierz_max_id INTO MAX_ID;
    CLOSE pobierz_max_id;
    
    LOOP
        OPEN pobierz_zabiegi(Z_ID);
            FETCH pobierz_zabiegi INTO wiersz;
        CLOSE pobierz_zabiegi;
        INSERT INTO h_zabiegi VALUES(Z_ID, wiersz.nazwa);
        Z_ID := Z_ID + 1;
        EXIT WHEN Z_ID = MAX_ID;
    END LOOP;
    
END;
/

CREATE OR REPLACE PROCEDURE transformacja_daty_wizyt IS

D_ID wizyty.wizyta_id%TYPE := 1;
MAX_ID wizyty.wizyta_id%TYPE;

CURSOR pobierz_max_id IS
SELECT MAX(wizyta_id) FROM wizyty;

CURSOR pobierz_date(D_ID IN NUMBER) IS
SELECT data_wizyty, godzina_poczatek, godzina_koniec FROM wizyty
WHERE wizyta_id = D_ID;

wiersz pobierz_date%ROWTYPE;

BEGIN
    OPEN pobierz_max_id;
        FETCH pobierz_max_id INTO MAX_ID;
    CLOSE pobierz_max_id;
    
    LOOP
        OPEN pobierz_date(D_ID);
            FETCH pobierz_date INTO wiersz;
        CLOSE pobierz_date;
        
        INSERT INTO h_daty_wizyt VALUES(D_ID, wiersz.data_wizyty, wiersz.godzina_poczatek, wiersz.godzina_koniec);
        
        D_ID := D_ID + 1;
        
        EXIT WHEN D_ID = MAX_ID;
    END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE transformacja_statusow_wizyt IS

S_ID statusy_wizyt.statusy_wizyt_id%TYPE := 1;
MAX_ID statusy_wizyt.statusy_wizyt_id%TYPE;

CURSOR pobierz_max_id IS
SELECT MAX(statusy_wizyt_id) FROM statusy_wizyt;

CURSOR pobierz_status(S_ID IN NUMBER) IS
SELECT status FROM statusy_wizyt WHERE statusy_wizyt_id = S_ID;

wiersz pobierz_status%ROWTYPE;

BEGIN
    OPEN pobierz_max_id;
        FETCH pobierz_max_id INTO MAX_ID;
    CLOSE pobierz_max_id;
    
    LOOP
        OPEN pobierz_status(S_ID);
            FETCH pobierz_status INTO wiersz;
        CLOSE pobierz_status;
        
        INSERT INTO h_statusy_wizyt VALUES(S_ID, wiersz.status);
        
        S_ID := S_ID + 1;
        
        EXIT WHEN S_ID = MAX_ID;
    END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE transformacja_leki IS

l_id pozycje_recept.pozycje_recept_id%TYPE := 1;
max_id pozycje_recept.pozycje_recept_id%TYPE;

CURSOR pobierz_max_id IS
SELECT MAX(pozycje_recept_id) FROM pozycje_recept;

CURSOR pobierz_lek(LID IN NUMBER) IS
SELECT nazwa FROM pozycje_recept WHERE pozycje_recept_id = LID;

wiersz pobierz_lek%ROWTYPE;

BEGIN
    OPEN pobierz_max_id;
        FETCH pobierz_max_id INTO max_id;
    CLOSE pobierz_max_id;
    
    LOOP
        OPEN pobierz_lek(l_id);
            FETCH pobierz_lek INTO wiersz;
        CLOSE pobierz_lek;
        
        INSERT INTO h_leki VALUES(l_id, wiersz.nazwa);
        
        l_id := l_id + 1;
        EXIT WHEN l_id = max_id + 1;
    END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE transformacja_ulgi IS

u_id ulgi.ulgi_id%TYPE := 1;
max_id ulgi.ulgi_id%TYPE;

CURSOR pobierz_max_id IS
SELECT MAX(ulgi_id) FROM ulgi;

CURSOR pobierz_ulge(UID IN NUMBER) IS
SELECT typ_ulgi FROM ulgi WHERE ulgi_id = UID;

wiersz pobierz_ulge%ROWTYPE;

BEGIN
    OPEN pobierz_max_id;
        FETCH pobierz_max_id INTO max_id;
    CLOSE pobierz_max_id;
    
    LOOP
        OPEN pobierz_ulge(u_id);
            FETCH pobierz_ulge INTO wiersz;
        CLOSE pobierz_ulge;
        
        INSERT INTO h_ulgi VALUES(u_id, wiersz.typ_ulgi);
        
        u_id := u_id + 1;
        EXIT WHEN u_id = max_id + 1;
    END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE transformacja_pozycje_recept IS

pr_id pozycje_recept.pozycje_recept_id%TYPE := 1;
u_id ulgi.ulgi_id%TYPE := 1;
max_id pozycje_recept.pozycje_recept_id%TYPE;

CURSOR pobierz_max_id IS
SELECT MAX(pozycje_recept_id) FROM pozycje_recept;

CURSOR pobierz_pozycje(PRID IN NUMBER) IS
SELECT recepta_id, ilosc, odplatnosc FROM pozycje_recept
WHERE pozycje_recept_id = PRID;

wiersz pobierz_pozycje%ROWTYPE;

CURSOR pobierz_procent_ulgi(RID IN NUMBER) IS
SELECT u.ulgi_id, u.procent_ulgi FROM recepty r
JOIN ulgi u ON r.ulga_id = u.ulgi_id
WHERE r.recepta_id = RID;

ulga pobierz_procent_ulgi%ROWTYPE;

BEGIN
    OPEN pobierz_max_id;
        FETCH pobierz_max_id INTO max_id;
    CLOSE pobierz_max_id;
    
    LOOP
        OPEN pobierz_pozycje(pr_id);
            FETCH pobierz_pozycje INTO wiersz;
        CLOSE pobierz_pozycje;
        
        OPEN pobierz_procent_ulgi(wiersz.recepta_id);
            FETCH pobierz_procent_ulgi INTO ulga;
        CLOSE pobierz_procent_ulgi;
        
        INSERT INTO h_pozycje_recept VALUES(pr_id, wiersz.recepta_id, pr_id, ulga.ulgi_id, wiersz.ilosc, ulga.procent_ulgi, wiersz.odplatnosc);
        
        pr_id := pr_id + 1;
        EXIT WHEN pr_id = max_id + 1;
    END LOOP;
END;
/

--EXEC--ZONE--
EXEC transformacja_placowki;
EXEC transformacja_gabinety;
EXEC transformacja_pacjenci;
EXEC transformacja_specjalnosci;
EXEC transformacja_zabiegi;
EXEC transformacja_daty_wizyt;
EXEC transformacja_statusow_wizyt;
EXEC transformacja_stanowiska;
EXEC transformacja_pracownicy;
EXEC transformacja_choroby;
EXEC transformacja_recepty;
EXEC transformacja_leki;
EXEC transformacja_ulgi;
EXEC transformacja_pozycje_recept;
