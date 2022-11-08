CREATE OR REPLACE PROCEDURE transformacja_placowki IS
P_ID placowki.placowka_id%type := 1;

CURSOR pobierz_placowka(IDP IN NUMBER) IS SELECT
p.nazwa,p.adres_id,p.kontakt_id FROM placowki p WHERE p.placowka_id = IDP;

CURSOR pobierz_kontakt(IDK IN NUMBER) IS SELECT 
k.telefon,k.email FROM kontakty k WHERE k.kontakt_id = IDK;

CURSOR pobierz_adres(IDA IN NUMBER) IS SELECT 
a.kod_poczt,a.miasto,a.wojewodztwo,a.ulica,a.nr_domu,a.nr_mieszkania FROM adresy a WHERE a.adres_id = IDA;

placowka pobierz_placowka%ROWTYPE;

kontakt pobierz_kontakt%ROWTYPE;

adres pobierz_adres%ROWTYPE;

BEGIN

LOOP
    OPEN pobierz_placowka(P_ID);
        FETCH pobierz_placowka INTO placowka;
    CLOSE pobierz_placowka;
    
    OPEN pobierz_kontakt(placowka.kontakt_id);
        FETCH pobierz_kontakt INTO kontakt;
    CLOSE pobierz_kontakt;
    
    OPEN pobierz_adres(placowka.adres_id);
        FETCH pobierz_adres INTO adres;
    CLOSE pobierz_adres;
    

    INSERT INTO h_placowki VALUES(P_ID,placowka.nazwa,kontakt.telefon,kontakt.email,adres.kod_poczt,adres.miasto,adres.wojewodztwo,adres.ulica,adres.nr_domu,adres.nr_mieszkania);
    
    kontakt := null;
    adres := null;
    
    P_ID := P_ID + 1;
    EXIT WHEN P_ID = 10001;
END LOOP;
END;
/

create or replace NONEDITIONABLE PROCEDURE transformacja_gabinety IS
G_ID gabinety.gabinet_id%type := 1;

CURSOR pobierz_kontakt(IDK IN NUMBER) IS SELECT 
k.telefon,k.email FROM kontakty k WHERE k.kontakt_id = IDK;

CURSOR pobierz_gabinet(IDG IN NUMBER) IS SELECT 
g.oznaczenie,g.placowka_id,g.kontakt_id FROM gabinety g WHERE g.gabinet_id = IDG;

gabinet pobierz_gabinet%ROWTYPE;
kontakt pobierz_kontakt%ROWTYPE;

BEGIN

LOOP
    OPEN pobierz_gabinet(G_ID);
        FETCH pobierz_gabinet INTO gabinet;
    CLOSE pobierz_gabinet;

    OPEN pobierz_kontakt(gabinet.kontakt_id);
        FETCH pobierz_kontakt INTO kontakt;
    CLOSE pobierz_kontakt;
   
    
    INSERT INTO h_gabinety VALUES(G_ID,gabinet.oznaczenie,gabinet.placowka_id,kontakt.telefon,kontakt.email);
    
    gabinet := null;
    
    G_ID := G_ID + 1;
    EXIT WHEN G_ID = 10001;
END LOOP;
END;

/

CREATE OR REPLACE PROCEDURE transformacja_pacjenci IS
P_ID pacjenci.pacjent_id%type := 1;
ID_MAX pacjenci.pacjent_id%TYPE;

CURSOR pobierz_max_id IS
SELECT MAX(pacjent_id) FROM pacjenci;

CURSOR pobierz_pacjenta(IDP IN NUMBER) IS
SELECT p.imie,p.nazwisko,p.pesel_id,p.adres_id,p.kontakt_id,p.login,p.haslo FROM pacjenci p WHERE p.pacjent_id = IDP;

CURSOR pobierz_kontakt(IDK IN NUMBER) IS SELECT 
k.telefon,k.email FROM kontakty k WHERE k.kontakt_id = IDK;

CURSOR pobierz_adres(IDA IN NUMBER) IS SELECT 
a.kod_poczt,a.miasto,a.wojewodztwo,a.ulica,a.nr_domu,a.nr_mieszkania FROM adresy a WHERE a.adres_id = IDA;

CURSOR pobierz_karte(PESEL IN pacjenci.pesel_id%TYPE) IS
SELECT k.data_ur,k.grupa_krwi FROM karty k WHERE k.pesel_id = PESEL;

karta pobierz_karte%ROWTYPE;
pacjent pobierz_pacjenta%ROWTYPE;
kontakt pobierz_kontakt%ROWTYPE;
adres pobierz_adres%ROWTYPE;

BEGIN
    OPEN pobierz_max_id;
        FETCH pobierz_max_id INTO ID_MAX;
    CLOSE pobierz_max_id;

LOOP
    OPEN pobierz_pacjenta(P_ID);
        FETCH pobierz_pacjenta INTO pacjent;
    CLOSE pobierz_pacjenta;

    OPEN pobierz_kontakt(pacjent.kontakt_id);
        FETCH pobierz_kontakt INTO kontakt;
    CLOSE pobierz_kontakt;

    OPEN pobierz_adres(pacjent.adres_id);
        FETCH pobierz_adres INTO adres;
    CLOSE pobierz_adres;

    OPEN pobierz_karte(pacjent.pesel_id);
        FETCH pobierz_karte INTO karta;
    CLOSE pobierz_karte;

    INSERT INTO h_pacjenci VALUES(P_ID,pacjent.imie,pacjent.nazwisko,pacjent.login,pacjent.haslo,
    kontakt.telefon,kontakt.email,
    adres.kod_poczt,adres.miasto,adres.wojewodztwo,adres.ulica,adres.nr_domu,adres.nr_mieszkania,
    pacjent.pesel_id,karta.data_ur,karta.grupa_krwi);
    
    karta := null;
    pacjent := null;
    kontakt := null;
    adres := null;
    
    P_ID := P_ID + 1;
    EXIT WHEN P_ID = ID_MAX + 1 ;
END LOOP;

END;
/
create or replace NONEDITIONABLE PROCEDURE transformacja_specjalnosci IS
S_ID specjalnosci.specjalnosc_id%type := 1;

CURSOR pobierz_specjalnosc(IDS IN NUMBER)IS SELECT
s.nazwa,s.stopien,s.dodatek_pensja FROM specjalnosci s WHERE s.specjalnosc_id = IDS ;

specjalnosc pobierz_specjalnosc%ROWTYPE;

BEGIN
LOOP
    OPEN pobierz_specjalnosc(S_ID);
        FETCH pobierz_specjalnosc INTO specjalnosc;
    CLOSE pobierz_specjalnosc;
    
    INSERT INTO h_specjalnosci VALUES(S_ID,specjalnosc.nazwa,specjalnosc.stopien,specjalnosc.dodatek_pensja);
    
    S_ID := S_ID + 1;
    EXIT WHEN S_ID = 101;
END LOOP;
END;

/
create or replace NONEDITIONABLE PROCEDURE transformacja_stanowiska IS
S_ID stanowiska.stanowisko_id%type := 1;

CURSOR pobierz_stanowisko(IDS IN NUMBER) IS SELECT
s.uprawnienie_id,s.nazwa,s.pensja FROM stanowiska s WHERE s.stanowisko_id = IDS ; 

CURSOR pobierz_uprawnienie(IDU IN NUMBER) IS SELECT
u.oznaczenie,u.opis FROM uprawnienia u WHERE u.uprawnienie_id = IDU;

stanowisko pobierz_stanowisko%ROWTYPE;
uprawnienie pobierz_uprawnienie%ROWTYPE;

BEGIN
LOOP
    OPEN pobierz_stanowisko(S_ID);
        FETCH pobierz_stanowisko INTO stanowisko;
    CLOSE pobierz_stanowisko;

    OPEN pobierz_uprawnienie(stanowisko.uprawnienie_id);
        FETCH pobierz_uprawnienie INTO uprawnienie;
    CLOSE pobierz_uprawnienie;

    
    
    INSERT INTO h_stanowiska VALUES(S_ID,stanowisko.nazwa,stanowisko.pensja,uprawnienie.oznaczenie,uprawnienie.opis);
    
    uprawnienie := null;
    
    S_ID := S_ID + 1;
    EXIT WHEN S_ID = 10001;
END LOOP;
END;

/
create or replace NONEDITIONABLE PROCEDURE transformacja_pracownicy IS
P_ID pracownicy.pracownik_id%type := 1;

CURSOR pobierz_pracownika(IDP IN NUMBER) IS
SELECT p.kontakt_id,p.adres_id,p.stanowisko_id,p.specjalnosc_id,p.imie,p.nazwisko,p.login,p.haslo,p.pensja FROM pracownicy p WHERE  p.pracownik_id = IDP;

CURSOR pobierz_kontakt(IDK IN NUMBER) IS SELECT 
k.telefon,k.email FROM kontakty k WHERE k.kontakt_id = IDK;

CURSOR pobierz_adres(IDA IN NUMBER) IS SELECT 
a.kod_poczt,a.miasto,a.wojewodztwo,a.ulica,a.nr_domu,a.nr_mieszkania FROM adresy a WHERE a.adres_id = IDA;

pracownik pobierz_pracownika%ROWTYPE;
kontakt pobierz_kontakt%ROWTYPE;
adres pobierz_adres%ROWTYPE;

BEGIN
LOOP

    OPEN pobierz_pracownika(P_ID);
        FETCH pobierz_pracownika INTO pracownik;
    CLOSE pobierz_pracownika;

    OPEN pobierz_kontakt(pracownik.kontakt_id);
        FETCH pobierz_kontakt INTO kontakt;
    CLOSE pobierz_kontakt;

    OPEN pobierz_adres(pracownik.adres_id);
        FETCH pobierz_adres INTO adres;
    CLOSE pobierz_adres;

    INSERT INTO h_pracownicy VALUES(P_ID,pracownik.imie,pracownik.nazwisko,pracownik.login,pracownik.haslo,pracownik.pensja,
    kontakt.telefon,kontakt.email,
    adres.kod_poczt,adres.miasto,adres.wojewodztwo,adres.ulica,adres.nr_domu,adres.nr_mieszkania,
    pracownik.stanowisko_id,pracownik.specjalnosc_id);
    
    kontakt := null;
    adres := null;
    
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
    
    wiersz2 := null;
    
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
        EXIT WHEN Z_ID = MAX_ID  + 1 ;
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

dzien_tygodnia h_daty_wizyt.dzien_tygodnia%TYPE;
miesiac h_daty_wizyt.miesiac%TYPE;
rok h_daty_wizyt.rok%TYPE;

BEGIN
    OPEN pobierz_max_id;
        FETCH pobierz_max_id INTO MAX_ID;
    CLOSE pobierz_max_id;
    
    LOOP
        OPEN pobierz_date(D_ID);
            FETCH pobierz_date INTO wiersz;
        CLOSE pobierz_date;
        
        dzien_tygodnia := TO_CHAR (wiersz.data_wizyty, 'DAY');
        miesiac := EXTRACT (MONTH FROM wiersz.data_wizyty);
        rok := EXTRACT (YEAR FROM wiersz.data_wizyty);
        
        INSERT INTO h_daty_wizyt VALUES(D_ID, wiersz.data_wizyty, dzien_tygodnia, miesiac, rok, wiersz.godzina_poczatek, wiersz.godzina_koniec);
        
        D_ID := D_ID + 1;
        
        EXIT WHEN D_ID = MAX_ID  + 1 ;
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
        
        EXIT WHEN S_ID = MAX_ID  + 1 ;
    END LOOP;
END;
/
CREATE OR REPLACE PROCEDURE transformacja_wizyty IS
W_ID wizyty.wizyta_id%TYPE := 1;
MAX_ID wizyty.wizyta_id%TYPE;

D_ID h_daty_wizyt.data_id%type;
R_ID h_recepty.recepta_id%type;

CURSOR pobierz_max_id IS
SELECT MAX(wizyta_id) FROM wizyty;

CURSOR pobierz_recepte(WID IN NUMBER) IS 
SELECT r.recepta_id FROM recepty r WHERE r.wizyta_id = WID;

CURSOR pobierz_zabieg(WID IN NUMBER) IS
SELECT z.zabieg_id,z.cena_netto FROM zabiegi z WHERE z.wizyta_id = WID;

CURSOR pobierz_date(data_wiz IN wizyty.data_wizyty%type,h_poczatek IN wizyty.godzina_poczatek%type,h_koniec IN wizyty.godzina_koniec%type) IS
SELECT d.data_id FROM h_daty_wizyt d WHERE d.data_wizyty = data_wiz AND d.godzina_poczatek = h_poczatek AND d.godzina_koniec = h_koniec;

CURSOR pobierz_wizyte(WID IN NUMBER) IS
SELECT w.oplata,w.data_wizyty,w.godzina_poczatek,w.godzina_koniec,w.pacjent_id,w.prac_spec,w.prac_uma,w.gabinet_id FROM wizyty w WHERE w.wizyta_id = WID;

zabieg pobierz_zabieg%ROWTYPE;
wiersz pobierz_wizyte%ROWTYPE;

BEGIN
    OPEN pobierz_max_id;
        FETCH pobierz_max_id INTO MAX_ID;
    CLOSE pobierz_max_id;
    
    LOOP
        OPEN pobierz_recepte(W_ID);
            FETCH pobierz_recepte INTO R_ID;
        CLOSE pobierz_recepte;
        
        OPEN pobierz_zabieg(W_ID);
            FETCH pobierz_zabieg INTO zabieg;
        CLOSE pobierz_zabieg;
        
        OPEN pobierz_wizyte(W_ID);
            FETCH pobierz_wizyte INTO wiersz;
        CLOSE pobierz_wizyte;
        
        OPEN pobierz_date(wiersz.data_wizyty,wiersz.godzina_poczatek,wiersz.godzina_koniec);
            FETCH pobierz_date INTO D_ID;
        CLOSE pobierz_date;
        
        INSERT INTO h_wizyty VALUES(W_ID,wiersz.gabinet_id,wiersz.pacjent_id,wiersz.prac_spec,wiersz.prac_uma,D_ID,W_ID,zabieg.zabieg_id,R_ID,wiersz.oplata,zabieg.cena_netto);
        
        R_ID := null;
        W_ID := W_ID + 1;
        zabieg := null;
        EXIT WHEN W_ID = MAX_ID + 1;
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
LEFT  JOIN ulgi u ON r.ulga_id = u.ulgi_id
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
        
        ulga := null;
        
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
EXEC transformacja_wizyty;
EXEC transformacja_leki;
EXEC transformacja_ulgi;
EXEC transformacja_pozycje_recept;
