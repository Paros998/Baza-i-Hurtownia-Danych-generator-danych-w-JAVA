--------------------------------------------- ROLLUP ---------------------------------------------

-- Ilosc wizyt ze statusem 'zakonczona' w kazdym gabinecie
SELECT DISTINCT
NVL (TO_CHAR ((SELECT oznaczenie FROM gabinety WHERE gabinet_id = g_id)), 'Laczna ilosc wizyt') oznaczenie_gabinetu,
NVL (TO_CHAR ((SELECT status FROM statusy_wizyt WHERE statusy_wizyt_id = sw_id AND status LIKE 'Zakonczona')), 'Ilosc wizyt w gabinecie') status_wizyty,
ilosc_wizyt
FROM (
    SELECT w.gabinet_id g_id, sw.statusy_wizyt_id sw_id, COUNT (w.wizyta_id) ilosc_wizyt FROM statusy_wizyt sw
    JOIN wizyty w ON w.wizyta_id = sw.statusy_wizyt_id
    GROUP BY ROLLUP (w.gabinet_id, sw.statusy_wizyt_id)
);

-- Liczba pracownikow pracujacych na danym stanowisku, posiadajacych okreslone specjalnosci, mieszkajacych w danym miescie
SELECT DISTINCT
NVL (TO_CHAR ((SELECT nazwa FROM stanowiska WHERE stanowisko_id = s_id)), 'Laczna ilosc pracownikow') nazwa_stanowiska,
NVL (TO_CHAR ((SELECT nazwa FROM specjalnosci WHERE specjalnosc_id = sp_id)), 'Ilosc pracownikow na danym stanowisku') nazwa_specjalnosci,
NVL (adres, 'Ilosc pracownikow na danym stanowisku z okreslna spec.') miasto,
liczba_pracownikow
FROM (
    SELECT p.stanowisko_id s_id, p.specjalnosc_id sp_id, a.miasto adres, COUNT (p.pracownik_id) liczba_pracownikow FROM pracownicy p
    JOIN adresy a ON a.adres_id = p.adres_id
    GROUP BY ROLLUP (p.stanowisko_id, p.specjalnosc_id, a.miasto)
);

-- Liczba pacjentow umowionych na wizyte, wymagajaca zabiegu
SELECT DISTINCT
NVL (TO_CHAR ((SELECT nazwa FROM zabiegi WHERE zabieg_id = z_id)), 'Laczna ilosc pacjentow') nazwa_zabiegu,
NVL (TO_CHAR ((SELECT status FROM statusy_wizyt WHERE statusy_wizyt_id = sw_id AND status LIKE 'Oczekujaca')), 'Ilosc wizyt wymagajacych zabiegu') status_wizyty,
liczba_pacjentow
FROM (
    SELECT z.zabieg_id z_id, sw.statusy_wizyt_id sw_id, COUNT(w.pacjent_id) liczba_pacjentow FROM zabiegi z
    RIGHT JOIN wizyty w ON w.wizyta_id = z.wizyta_id
    JOIN statusy_wizyt sw ON sw.statusy_wizyt_id = w.wizyta_id
    GROUP BY ROLLUP (z.zabieg_id, sw.statusy_wizyt_id)
);