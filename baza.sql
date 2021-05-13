--Drop Table--
DROP TABLE wizyty CASCADE CONSTRAINTS;

DROP TABLE pacjenci CASCADE CONSTRAINTS;
DROP TABLE zabiegi CASCADE CONSTRAINTS;
DROP TABLE recepty CASCADE CONSTRAINTS;
DROP TABLE statusy_wizyt CASCADE CONSTRAINTS;


DROP TABLE pozycje_recept CASCADE CONSTRAINTS;
DROP TABLE oddzialy_nfz CASCADE CONSTRAINTS;
DROP TABLE ulgi CASCADE CONSTRAINTS;

DROP TABLE choroby CASCADE CONSTRAINTS;
DROP TABLE placowki CASCADE CONSTRAINTS;
DROP TABLE gabinety CASCADE CONSTRAINTS;

DROP TABLE pracownicy CASCADE CONSTRAINTS;
DROP TABLE stanowiska CASCADE CONSTRAINTS;
DROP TABLE specjalnosci CASCADE CONSTRAINTS;
DROP TABLE uprawnienia CASCADE CONSTRAINTS;

DROP TABLE kontakty CASCADE CONSTRAINTS;
DROP TABLE adresy CASCADE CONSTRAINTS;
DROP TABLE karty CASCADE CONSTRAINTS;

--Create Table--
CREATE TABLE uprawnienia (
    uprawnienie_id NUMBER(5) PRIMARY KEY,
    oznaczenie VARCHAR2(4)NOT NULL,
    opis VARCHAR2(50)
);

CREATE TABLE specjalnosci (
    specjalnosc_id NUMBER(5) PRIMARY KEY,
    nazwa VARCHAR2(50)NOT NULL,
    stopien NUMBER(1) CONSTRAINT chk_stopien CHECK(0 <= stopien AND stopien <= 2) NOT NULL ,
    dodatek_pensja NUMBER(4,2)
);

CREATE TABLE stanowiska(
    stanowisko_id NUMBER(5) PRIMARY KEY,
    nazwa VARCHAR2(150)NOT NULL,
    pensja NUMBER(6,2)NOT NULL,
    uprawnienie_id NUMBER(5)NOT NULL,
    CONSTRAINT fk_sta_upr FOREIGN KEY (uprawnienie_id) REFERENCES uprawnienia(uprawnienie_id)
);

CREATE TABLE adresy(
    adres_id NUMBER(5) PRIMARY KEY,
    kod_poczt VARCHAR2(6) NOT NULL,
    miasto VARCHAR2(45)NOT NULL,
    wojewodztwo VARCHAR2(45) NOT NULL,
    ulica VARCHAR2(45)NOT NULL,
    nr_domu NUMBER(2)NOT NULL,
    nr_mieszkania NUMBER(3)
);

CREATE TABLE karty(
    pesel_id NUMBER(11) PRIMARY KEY,
    data_ur DATE NOT NULL,
    grupa_krwi VARCHAR2(4)NOT NULL
);

CREATE TABLE kontakty(
    kontakt_id NUMBER(5) PRIMARY KEY,
    telefon NUMBER(9) NOT NULL,
    email VARCHAR2(45)
);

CREATE TABLE choroby(
    choroby_id NUMBER(10) PRIMARY KEY,
    nazwa VARCHAR2(60) NOT NULL,
    opis VARCHAR2(200) ,
    poczatek DATE NOT NULL,
    koniec DATE,
    pesel_id NUMBER(11) NOT NULL,
    CONSTRAINT fk_ch_kart FOREIGN KEY (pesel_id) REFERENCES karty(pesel_id)
);

CREATE TABLE placowki(
    placowka_id NUMBER(5) PRIMARY KEY,
    nazwa VARCHAR2(45),
    adres_id NUMBER(5) NOT NULL,
    CONSTRAINT fk_plac_adr FOREIGN KEY (adres_id) REFERENCES adresy(adres_id),
    kontakt_id NUMBER(5) NOT NULL,
    CONSTRAINT fk_plac_kont FOREIGN KEY (kontakt_id) REFERENCES kontakty(kontakt_id)
);

CREATE TABLE pracownicy(
    pracownik_id NUMBER(5) PRIMARY KEY,
    imie VARCHAR2(45) NOT NULL,
    nazwisko VARCHAR2(45) NOT NULL,
    login VARCHAR2(45),
    haslo VARCHAR2(45),
    pensja NUMBER(6,2) NOT NULL,
    adres_id NUMBER(5) NOT NULL,
    kontakt_id NUMBER(5) NOT NULL,
    stanowisko_id NUMBER(5) NOT NULL,
    specjalnosc_id NUMBER(5),
    CONSTRAINT fk_prac_adr FOREIGN KEY (adres_id) REFERENCES adresy(adres_id),
    CONSTRAINT fk_prac_kont FOREIGN KEY (kontakt_id) REFERENCES kontakty(kontakt_id),
    CONSTRAINT fk_prac_stan FOREIGN KEY (stanowisko_id) REFERENCES stanowiska(stanowisko_id),
    CONSTRAINT fk_prac_spec FOREIGN KEY (specjalnosc_id) REFERENCES specjalnosci(specjalnosc_id)
);

CREATE TABLE gabinety(
    gabinet_id NUMBER(5) PRIMARY KEY,
    oznaczenie VARCHAR2(25) NOT NULL,
    pracownik_id NUMBER(5) NOT NULL,
    kontakt_id NUMBER(5) NOT NULL,
    placowka_id NUMBER(5) NOT NULL,
    CONSTRAINT fk_gab_prac FOREIGN KEY (pracownik_id) REFERENCES pracownicy(pracownik_id),
    CONSTRAINT fk_gab_kont FOREIGN KEY (kontakt_id) REFERENCES kontakty(kontakt_id),
    CONSTRAINT fk_gab_plac FOREIGN KEY (placowka_id) REFERENCES placowki(placowka_id)
);

CREATE TABLE pacjenci(
    pacjent_id NUMBER(5) PRIMARY KEY,
    imie VARCHAR2(45) NOT NULL,
    nazwisko VARCHAR2(45) NOT NULL,
    login VARCHAR2(45),
    haslo VARCHAR2(45),
    pesel_id NUMBER(11) NOT NULL,
    kontakt_id NUMBER(5) NOT NULL,
    adres_id NUMBER(5) NOT NULL,
    CONSTRAINT fk_pac_kart FOREIGN KEY (pesel_id) REFERENCES karty(pesel_id),
    CONSTRAINT fk_pac_kont FOREIGN KEY (kontakt_id) REFERENCES kontakty(kontakt_id),
    CONSTRAINT fk_pac_adr FOREIGN KEY (adres_id) REFERENCES adresy(adres_id)
);

CREATE TABLE ulgi (
    ulgi_id NUMBER(5) PRIMARY KEY,
    typ_ulgi VARCHAR(45) NOT NULL,
    procent_ulgi NUMBER(3)
);

CREATE TABLE oddzialy_nfz (
    oddzial_nfz_id NUMBER(5) PRIMARY KEY,
    nazwa VARCHAR2(100) NOT NULL,
    kod_funduszu VARCHAR2(3) NOT NULL
);

CREATE TABLE wizyty(
    wizyta_id NUMBER(5) NOT NULL PRIMARY KEY,
    oplata NUMBER(5,2) NOT NULL,
    data_wizyty DATE NOT NULL,
    godzina_poczatek VARCHAR2(5) NOT NULL,
    godzina_koniec VARCHAR2(5),
    pacjent_id NUMBER(11) NOT NULL,
    prac_spec NUMBER(5) NOT NULL,
    prac_uma NUMBER(5) NOT NULL,
    gabinet_id NUMBER(5) NOT NULL,
    CONSTRAINT fk_wiz_pac FOREIGN KEY (pacjent_id) REFERENCES pacjenci(pacjent_id),
    CONSTRAINT fk_wiz_prac FOREIGN KEY (prac_spec) REFERENCES pracownicy(pracownik_id),
    CONSTRAINT fk_wiz_prac2 FOREIGN KEY (prac_uma) REFERENCES pracownicy(pracownik_id),
    CONSTRAINT fk_wiz_gab FOREIGN KEY (gabinet_id) REFERENCES gabinety(gabinet_id)
);

CREATE TABLE recepty (
    recepta_id NUMBER(5) PRIMARY KEY,
    pracownik_id NUMBER(5) NOT NULL,
    CONSTRAINT fk_pracownik_recepty FOREIGN KEY(pracownik_id) REFERENCES pracownicy(pracownik_id),
    wizyta_id NUMBER(5) NOT NULL,
    CONSTRAINT fk_wiz_rec FOREIGN KEY (wizyta_id) REFERENCES wizyty(wizyta_id),
    oddzial_nfz_id NUMBER(5) NOT NULL,
    CONSTRAINT fk_oddzial_nfz_recepty FOREIGN KEY(oddzial_nfz_id) REFERENCES oddzialy_nfz(oddzial_nfz_id),
    recepta_choroba_id NUMBER(5) NOT NULL,
    CONSTRAINT fk_recepta_choroba_recepty FOREIGN KEY(recepta_choroba_id) REFERENCES choroby(choroby_id),
    ulga_id NUMBER(5) ,
    CONSTRAINT fk_ulga_recepty FOREIGN KEY(ulga_id) REFERENCES ulgi(ulgi_id)
);

CREATE TABLE pozycje_recept (
    pozycje_recept_id NUMBER(5) PRIMARY KEY,
    recepta_id NUMBER(5) NOT NULL,
    nazwa VARCHAR2(100) NOT NULL,
    ilosc NUMBER(6) NOT NULL,
    odplatnosc NUMBER(4) NOT NULL,
    CONSTRAINT fk_pozycje_recept FOREIGN KEY(recepta_id) REFERENCES recepty(recepta_id)
);

CREATE TABLE zabiegi (
    zabieg_id NUMBER(5) PRIMARY KEY,
    nazwa VARCHAR2(200) NOT NULL,
    cena_netto NUMBER(5, 2),
    pracownik_id NUMBER(5) NOT NULL,
    wizyta_id NUMBER(5) NOT NULL,
    CONSTRAINT fk_wiz_zab FOREIGN KEY (wizyta_id) REFERENCES wizyty(wizyta_id),
    CONSTRAINT fk_pracownik_zabiegi FOREIGN KEY(pracownik_id) REFERENCES pracownicy(pracownik_id)
);

CREATE TABLE statusy_wizyt (
    statusy_wizyt_id NUMBER(5) PRIMARY KEY,
    status VARCHAR2(10) NOT NULL,
    opis VARCHAR2(50),
    CONSTRAINT fk_wiz_sw FOREIGN KEY (statusy_wizyt_id) REFERENCES wizyty(wizyta_id)
);