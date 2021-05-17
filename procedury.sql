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
--EXEC--ZONE--
EXEC transformacja_placowki;
EXEC transformacja_gabinety;
