--------------------------------------------- ROLLUP ---------------------------------------------
-- Ilosc wizyt ze statusem 'zakonczona' w kazdym gabinecie
SELECT DISTINCT
NVL (TO_CHAR ((SELECT oznaczenie FROM h_gabinety WHERE gabinet_id = g_id)), 'Laczna ilosc wizyt') oznaczenie_gabinetu,
NVL (TO_CHAR ((SELECT status FROM h_statusy_wizyt WHERE statusy_wizyt_id = sw_id AND status LIKE 'Zakonczona')), 'Ilosc wizyt w gabinecie') status_wizyty,
ilosc_wizyt
FROM (
    SELECT gabinet_id g_id, status_wizyty_id sw_id, COUNT (wizyta_id) ilosc_wizyt FROM h_wizyty
    GROUP BY ROLLUP (gabinet_id, status_wizyty_id)
);

-- Liczba pracownikow pracujacych na danym stanowisku, posiadajacych okreslone specjalnosci, mieszkajacych w danym miescie
SELECT DISTINCT
NVL (TO_CHAR ((SELECT nazwa FROM h_stanowiska WHERE stanowisko_id = s_id)), 'Laczna ilosc pracownikow') nazwa_stanowiska,
NVL (TO_CHAR ((SELECT nazwa FROM h_specjalnosci WHERE specjalnosc_id = sp_id)), 'Ilosc pracownikow na danym stanowisku') nazwa_specjalnosci,
NVL (adres, 'Ilosc pracownikow na danym stanowisku z okreslna spec.') miasto,
liczba_pracownikow
FROM (
    SELECT p.stanowisko_id s_id, p.specjalnosc_id sp_id, p.miasto adres, COUNT (p.pracownik_id) liczba_pracownikow FROM h_pracownicy p
    GROUP BY ROLLUP (p.stanowisko_id, p.specjalnosc_id, p.miasto)
);

-- Liczba pacjentow umowionych na wizyte, wymagajaca zabiegu
SELECT DISTINCT
NVL (TO_CHAR ((SELECT nazwa FROM h_zabiegi WHERE zabieg_id = z_id)), 'Laczna ilosc pacjentow') nazwa_zabiegu,
NVL (TO_CHAR ((SELECT status FROM h_statusy_wizyt WHERE statusy_wizyt_id = sw_id AND status LIKE 'Oczekujaca')), 'Ilosc wizyt wymagajacych zabiegu') status_wizyty,
liczba_pacjentow
FROM (
    SELECT zabieg_id z_id, status_wizyty_id sw_id, COUNT (pacjent_id) liczba_pacjentow FROM h_wizyty
    GROUP BY ROLLUP (zabieg_id, status_wizyty_id)
);