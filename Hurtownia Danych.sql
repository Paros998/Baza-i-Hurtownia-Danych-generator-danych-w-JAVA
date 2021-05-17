DROP TABLE h_specjalnosci CASCADE CONSTRAINTS;
DROP TABLE h_stanowiska CASCADE CONSTRAINTS;
DROP TABLE h_pracownicy CASCADE CONSTRAINTS;
DROP TABLE h_daty_wizyt CASCADE CONSTRAINTS;
DROP TABLE h_statusy_wizyt CASCADE CONSTRAINTS;
DROP TABLE h_zabiegi CASCADE CONSTRAINTS;
DROP TABLE h_pacjenci CASCADE CONSTRAINTS;
DROP TABLE h_placowki CASCADE CONSTRAINTS;
DROP TABLE h_gabinety CASCADE CONSTRAINTS;
DROP TABLE h_leki CASCADE CONSTRAINTS;
DROP TABLE h_ulgi CASCADE CONSTRAINTS;
DROP TABLE h_choroby CASCADE CONSTRAINTS;
DROP TABLE h_recepty CASCADE CONSTRAINTS;
DROP TABLE h_pozycje_recept CASCADE CONSTRAINTS;
DROP TABLE h_wizyty CASCADE CONSTRAINTS;

--------------------------------- WYMIAR CHOROBY ----------------------------------------------------------
CREATE TABLE h_choroby (
    choroby_id NUMBER PRIMARY KEY,
    nazwa VARCHAR2(60) NOT NULL,
    opis VARCHAR2(200),
    poczatek DATE NOT NULL,
    koniec DATE
);

--------------------------------- WYMIAR RECEPTY -------------------------------------------------------------
CREATE TABLE h_recepty (
    recepta_id NUMBER PRIMARY KEY,
    choroba_id NUMBER NOT NULL,
    nazwa_oddzialu VARCHAR2(100) NOT NULL,
    kod_funduszu VARCHAR2(3) NOT NULL,
    CONSTRAINT fk_recepty_choroba FOREIGN KEY (choroba_id) REFERENCES h_choroby(choroby_id)
);

--------------------------------- WYMIAR PRACOWNIKA ----------------------------------------------------------

CREATE TABLE h_specjalnosci (
    specjalnosc_id NUMBER PRIMARY KEY,
    nazwa VARCHAR2(100)NOT NULL,
    stopien NUMBER(1) CONSTRAINT chk_stopien_2 CHECK(0 <= stopien AND stopien <= 2) NOT NULL ,
    dodatek_pensja NUMBER(5)
);

CREATE TABLE h_stanowiska (
    stanowisko_id NUMBER PRIMARY KEY,
    nazwa VARCHAR2(150)NOT NULL,
    pensja NUMBER(6,2)NOT NULL,
    oznaczenie_uprawnienia VARCHAR2(4)NOT NULL,
    opis_uprawnienia VARCHAR2(50)
);

CREATE TABLE h_pracownicy (
    pracownik_id NUMBER PRIMARY KEY,
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
    stanowisko_id NUMBER NOT NULL,
    specjalnosc_id NUMBER,
    CONSTRAINT fk_pracownicy_stanowisko FOREIGN KEY (stanowisko_id) REFERENCES h_stanowiska(stanowisko_id),
    CONSTRAINT fk_pracownicy_specjalnosc FOREIGN KEY (specjalnosc_id) REFERENCES h_specjalnosci(specjalnosc_id)
);

--------------------------------- WYMIAR CZAS_WIZYTY ----------------------------------------------------------
CREATE TABLE h_daty_wizyt (
    data_id NUMBER PRIMARY KEY,
    data_wizyty DATE NOT NULL,
    godzina_poczatek VARCHAR2(5) NOT NULL,
    godzina_koniec VARCHAR2(5)
);


--------------------------------- WYMIAR GABINETU ----------------------------------------------------------
CREATE TABLE h_placowki (
    placowka_id NUMBER PRIMARY KEY,
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

CREATE TABLE h_gabinety (
    gabinet_id NUMBER PRIMARY KEY,
    oznaczenie VARCHAR2(25) NOT NULL,
    placowka_id NUMBER NOT NULL,
    telefon NUMBER(9) NOT NULL,
    email VARCHAR2(45),
    CONSTRAINT fk_gabinet_placowki FOREIGN KEY (placowka_id) REFERENCES h_placowki(placowka_id)
);

--------------------------------- WYMIAR PACJENTA ----------------------------------------------------------

CREATE TABLE h_pacjenci (
    pacjent_id NUMBER PRIMARY KEY,
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
    pesel VARCHAR2(11) NOT NULL,
    data_ur DATE NOT NULL,
    grupa_krwi VARCHAR2(4) NOT NULL
);

--------------------------------- WYMIAR ZABIEGU -----------------------------------------------------------------
CREATE TABLE h_zabiegi (
    zabieg_id NUMBER PRIMARY KEY,
    nazwa VARCHAR2(200) NOT NULL
);

--------------------------------- WYMIAR STATUSU_WIZYTY ----------------------------------------------------------
CREATE TABLE h_statusy_wizyt (
    statusy_wizyt_id NUMBER PRIMARY KEY,
    status VARCHAR2(10) NOT NULL,
    opis VARCHAR2(50)
);

--------------------------------- FAKT -> WIZYTA ----------------------------------------------------------
CREATE TABLE h_wizyty (
    wizyta_id NUMBER PRIMARY KEY,
    gabinet_id NUMBER NOT NULL,
    pacjent_id NUMBER NOT NULL,
    prac_spec NUMBER NOT NULL,
    prac_uma NUMBER NOT NULL,
    data_wizyty_id NUMBER NOT NULL,
    status_wizyty_id NUMBER NOT NULL,
    zabieg_id NUMBER,
    recepta_id NUMBER,
    oplata NUMBER(6),
    cena_netto_za_zabieg NUMBER(6),
    CONSTRAINT fk_wiz_pac_2 FOREIGN KEY (pacjent_id) REFERENCES h_pacjenci(pacjent_id),
    CONSTRAINT fk_wiz_prac_2 FOREIGN KEY (prac_spec) REFERENCES h_pracownicy(pracownik_id),
    CONSTRAINT fk_wiz_prac2_2 FOREIGN KEY (prac_uma) REFERENCES h_pracownicy(pracownik_id),
    CONSTRAINT fk_wiz_gab_2 FOREIGN KEY (gabinet_id) REFERENCES h_gabinety(gabinet_id),
    CONSTRAINT fk_wiz_data_2 FOREIGN KEY (data_wizyty_id) REFERENCES h_daty_wizyt(data_id),
    CONSTRAINT fk_wiz_status_2 FOREIGN KEY (status_wizyty_id) REFERENCES h_statusy_wizyt(statusy_wizyt_id),
    CONSTRAINT fk_wiz_zabieg_2 FOREIGN KEY (zabieg_id) REFERENCES h_zabiegi(zabieg_id),
    CONSTRAINT fk_wiz_recepta_2 FOREIGN KEY (recepta_id) REFERENCES h_recepty(recepta_id)
);

--------------------------------- WYMIAR ULGI ----------------------------------------------------------
CREATE TABLE h_ulgi (
    ulgi_id NUMBER PRIMARY KEY,
    typ_ulgi VARCHAR(45) NOT NULL
);

--------------------------------- WYMIAR LEKU ----------------------------------------------------------
CREATE TABLE h_leki (
    leki_id NUMBER PRIMARY KEY,
    nazwa VARCHAR2(100) NOT NULL
);

--------------------------------- FAKT -> POZYCJA_RECEPTY -------------------------------------------------------------
CREATE TABLE h_pozycje_recept (
    pozycja_id NUMBER PRIMARY KEY,
    recepta_id NUMBER,
    lek_id NUMBER NOT NULL,
    ulga_id NUMBER,
    ilosc NUMBER(6) NOT NULL,
    procent_ulgi NUMBER(3),
    odplatnosc NUMBER(6, 3) NOT NULL,
    CONSTRAINT fk_pozycje_recept_lek FOREIGN KEY (lek_id) REFERENCES h_leki(leki_id),
    CONSTRAINT fk_pozycje_recept_ulga FOREIGN KEY (ulga_id) REFERENCES h_ulgi(ulgi_id),
    CONSTRAINT fk_pozycje_recept_recepta FOREIGN KEY (recepta_id) REFERENCES h_recepty(recepta_id)
);
