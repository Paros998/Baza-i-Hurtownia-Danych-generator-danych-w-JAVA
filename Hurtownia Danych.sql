DROP TABLE uprawnienia CASCADE CONSTRAINTS;
DROP TABLE specjalnosci CASCADE CONSTRAINTS;
DROP TABLE stanowiska CASCADE CONSTRAINTS;
DROP TABLE pracownicy CASCADE CONSTRAINTS;
DROP TABLE daty_wizyt CASCADE CONSTRAINTS;
DROP TABLE statusy_wizyt CASCADE CONSTRAINTS;
DROP TABLE zabiegi CASCADE CONSTRAINTS;
DROP TABLE karty CASCADE CONSTRAINTS;
DROP TABLE pacjenci CASCADE CONSTRAINTS;
DROP TABLE placowki CASCADE CONSTRAINTS;
DROP TABLE gabinety CASCADE CONSTRAINTS;
DROP TABLE leki CASCADE CONSTRAINTS;
DROP TABLE oddzialy_nfz CASCADE CONSTRAINTS;
DROP TABLE ulgi CASCADE CONSTRAINTS;
DROP TABLE choroby CASCADE CONSTRAINTS;
DROP TABLE recepty CASCADE CONSTRAINTS;
DROP TABLE wizyty CASCADE CONSTRAINTS;

--------------------------------- WYMIAR PRACOWNIKA ----------------------------------------------------------
CREATE TABLE uprawnienia (
    uprawnienie_id NUMBER(5) PRIMARY KEY,
    oznaczenie VARCHAR2(4)NOT NULL,
    opis VARCHAR2(50)
);

CREATE TABLE specjalnosci (
    specjalnosc_id NUMBER(5) PRIMARY KEY,
    nazwa VARCHAR2(100)NOT NULL,
    stopien NUMBER(1) CONSTRAINT chk_stopien CHECK(0 <= stopien AND stopien <= 2) NOT NULL ,
    dodatek_pensja NUMBER(5)
);

CREATE TABLE stanowiska (
    stanowisko_id NUMBER(5) PRIMARY KEY,
    nazwa VARCHAR2(150)NOT NULL,
    pensja NUMBER(6,2)NOT NULL,
    uprawnienie_id NUMBER(5)NOT NULL,
    CONSTRAINT fk_stanowiska_uprawnienie FOREIGN KEY (uprawnienie_id) REFERENCES uprawnienia(uprawnienie_id)
);

CREATE TABLE pracownicy (
    pracownik_id NUMBER(5) PRIMARY KEY,
    imie VARCHAR2(100) NOT NULL,
    nazwisko VARCHAR2(100) NOT NULL,
    login VARCHAR2(150),
    haslo VARCHAR2(150),
    pensja NUMBER(6,2) NOT NULL,
    telefon NUMBER(9) NOT NULL,
    email VARCHAR2(45),
    kod_poczt VARCHAR2(6) NOT NULL,
    miasto VARCHAR2(45) NOT NULL,
    wojewodztwo VARCHAR2(45) NOT NULL,
    ulica VARCHAR2(45) NOT NULL,
    nr_domu NUMBER(2) NOT NULL,
    nr_mieszkania NUMBER(3),
    stanowisko_id NUMBER(5) NOT NULL,
    specjalnosc_id NUMBER(5),
    CONSTRAINT fk_pracownicy_stanowisko FOREIGN KEY (stanowisko_id) REFERENCES stanowiska(stanowisko_id),
    CONSTRAINT fk_pracownicy_specjalnosc FOREIGN KEY (specjalnosc_id) REFERENCES specjalnosci(specjalnosc_id)
);

--------------------------------- WYMIAR CZAS_WIZYTY ----------------------------------------------------------
CREATE TABLE daty_wizyt (
    data_id NUMBER PRIMARY KEY,
    data_wizyty DATE NOT NULL,
    godzina_poczatek VARCHAR2(5) NOT NULL,
    godzina_koniec VARCHAR2(5)
);

--------------------------------- WYMIAR CHOROBY ----------------------------------------------------------
CREATE TABLE choroby (
    choroby_id NUMBER(10) PRIMARY KEY,
    nazwa VARCHAR2(60) NOT NULL,
    opis VARCHAR2(200),
    poczatek DATE NOT NULL,
    koniec DATE
);

--------------------------------- WYMIAR ULGI ----------------------------------------------------------
CREATE TABLE ulgi (
    ulgi_id NUMBER(5) PRIMARY KEY,
    typ_ulgi VARCHAR(45) NOT NULL
);

--------------------------------- WYMIAR ODDZIALOW ----------------------------------------------------------
CREATE TABLE oddzialy_nfz (
    oddzial_nfz_id NUMBER(5) PRIMARY KEY,
    nazwa VARCHAR2(100) NOT NULL,
    kod_funduszu VARCHAR2(3) NOT NULL
);

--------------------------------- WYMIAR LEKU ----------------------------------------------------------
CREATE TABLE leki (
    leki_id NUMBER PRIMARY KEY,
    nazwa VARCHAR2(100) NOT NULL
);

--------------------------------- FAKT -> RECEPTY -------------------------------------------------------------
CREATE TABLE recepty (
    recepta_id NUMBER(5) PRIMARY KEY,
    lek_id NUMBER NOT NULL,
    pracownik_id NUMBER(5) NOT NULL,
    oddzial_nfz_id NUMBER(5) NOT NULL,
    choroba_id NUMBER(5) NOT NULL,
    data_wizyty_id NUMBER,
    ulga_id NUMBER,
    ilosc NUMBER(6) NOT NULL,
    procent_ulgi NUMBER(3),
    odplatnosc NUMBER(4) NOT NULL, -- CENA ZA SZT
    CONSTRAINT fk_recepty_lek FOREIGN KEY (lek_id) REFERENCES leki(leki_id),
    CONSTRAINT fk_recepty_pracownik FOREIGN KEY (pracownik_id) REFERENCES pracownicy(pracownik_id),
    CONSTRAINT fk_recepty_oddzial_nfz FOREIGN KEY (oddzial_nfz_id) REFERENCES oddzialy_nfz(oddzial_nfz_id),
    CONSTRAINT fk_recepty_choroba FOREIGN KEY (choroba_id) REFERENCES choroby(choroby_id),
    CONSTRAINT fk_recepty_data FOREIGN KEY (data_wizyty_id) REFERENCES daty_wizyt(data_id),
    CONSTRAINT fk_recepty_ulga FOREIGN KEY (ulga_id) REFERENCES ulgi(ulgi_id)
);

--------------------------------- WYMIAR GABINETU ----------------------------------------------------------
CREATE TABLE placowki (
    placowka_id NUMBER(5) PRIMARY KEY,
    nazwa VARCHAR2(45),
    telefon NUMBER(9) NOT NULL,
    email VARCHAR2(45),
    kod_poczt VARCHAR2(6) NOT NULL,
    miasto VARCHAR2(45) NOT NULL,
    wojewodztwo VARCHAR2(45) NOT NULL,
    ulica VARCHAR2(45) NOT NULL,
    nr_domu NUMBER(2) NOT NULL,
    nr_mieszkania NUMBER(3)
);

CREATE TABLE gabinety (
    gabinet_id NUMBER(5) PRIMARY KEY,
    oznaczenie VARCHAR2(25) NOT NULL,
    placowka_id NUMBER(5) NOT NULL,
    telefon NUMBER(9) NOT NULL,
    email VARCHAR2(45),
    CONSTRAINT fk_gabinet_placowki FOREIGN KEY (placowka_id) REFERENCES placowki(placowka_id)
);

--------------------------------- WYMIAR PACJENTA ----------------------------------------------------------
CREATE TABLE karty (
    pesel_id VARCHAR2(11) PRIMARY KEY,
    data_ur DATE NOT NULL,
    grupa_krwi VARCHAR2(4) NOT NULL
);

CREATE TABLE pacjenci (
    pacjent_id NUMBER(5) PRIMARY KEY,
    imie VARCHAR2(100) NOT NULL,
    nazwisko VARCHAR2(100) NOT NULL,
    login VARCHAR2(150),
    haslo VARCHAR2(150),
    telefon NUMBER(9) NOT NULL,
    email VARCHAR2(45),
    kod_poczt VARCHAR2(6) NOT NULL,
    miasto VARCHAR2(45) NOT NULL,
    wojewodztwo VARCHAR2(45) NOT NULL,
    ulica VARCHAR2(45) NOT NULL,
    nr_domu NUMBER(2) NOT NULL,
    nr_mieszkania NUMBER(3),
    pesel_id VARCHAR2(11) NOT NULL,
    CONSTRAINT fk_pacj_karty FOREIGN KEY (pesel_id) REFERENCES karty(pesel_id)
);

--------------------------------- WYMIAR ZABIEGU -----------------------------------------------------------------
CREATE TABLE zabiegi (
    zabieg_id NUMBER(5) PRIMARY KEY,
    nazwa VARCHAR2(200) NOT NULL
);

--------------------------------- WYMIAR STATUSU_WIZYTY ----------------------------------------------------------
CREATE TABLE statusy_wizyt (
    statusy_wizyt_id NUMBER PRIMARY KEY,
    status VARCHAR2(10) NOT NULL,
    opis VARCHAR2(50)
);

--------------------------------- FAKT -> WIZYTA ----------------------------------------------------------
CREATE TABLE wizyty (
    wizyta_id NUMBER PRIMARY KEY,
    gabinet_id NUMBER NOT NULL,
    pacjent_id NUMBER NOT NULL,
    prac_spec NUMBER NOT NULL,
    prac_uma NUMBER NOT NULL,
    data_wizyty_id NUMBER NOT NULL,
    status_wizyty_id NUMBER NOT NULL,
    zabieg_id NUMBER,
    oplata NUMBER(5),
    cena_netto_za_zabieg NUMBER(5, 2),
    CONSTRAINT fk_wiz_pac FOREIGN KEY (pacjent_id) REFERENCES pacjenci(pacjent_id),
    CONSTRAINT fk_wiz_prac FOREIGN KEY (prac_spec) REFERENCES pracownicy(pracownik_id),
    CONSTRAINT fk_wiz_prac2 FOREIGN KEY (prac_uma) REFERENCES pracownicy(pracownik_id),
    CONSTRAINT fk_wiz_gab FOREIGN KEY (gabinet_id) REFERENCES gabinety(gabinet_id),
    CONSTRAINT fk_wiz_data FOREIGN KEY (data_wizyty_id) REFERENCES daty_wizyt(data_id),
    CONSTRAINT fk_wiz_status FOREIGN KEY (status_wizyty_id) REFERENCES statusy_wizyt(statusy_wizyt_id),
    CONSTRAINT fk_wiz_zabieg FOREIGN KEY (zabieg_id) REFERENCES zabiegi(zabieg_id)
);
