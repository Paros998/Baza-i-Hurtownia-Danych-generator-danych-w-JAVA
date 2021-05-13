public class App {
    public static void main(String[] args) throws Exception {
        Ulgi ulgi = new Ulgi(100);
        OddzialyNfz oddzialyNfz = new OddzialyNfz(100);
        Adresy adresy = new Adresy(30000);
        Kontakty kontakty = new Kontakty(40000);
        Specjalnosci specjalnosci = new Specjalnosci(100);
        Uprawnienia uprawnienia = new Uprawnienia(100);
        Stanowiska stanowiska = new Stanowiska(10000, uprawnienia);
        Karty karty = new Karty(10000);
        Choroby choroby = new Choroby(10000, karty);
        Placówki placówki = new Placówki(10000, adresy, kontakty);
        Pracownicy pracownicy = new Pracownicy(10000, placówki, adresy, kontakty, stanowiska, specjalnosci,
                uprawnienia);
        Pacjenci pacjenci = new Pacjenci(10000, adresy, kontakty, karty, placówki, pracownicy);
        Gabinety gabinety = new Gabinety(10000, kontakty, placówki, pracownicy, pacjenci);
        Wizyty wizyty = new Wizyty(100000, karty, gabinety, pracownicy);
        Recepty recepty = new Recepty(100000, wizyty, oddzialyNfz, choroby, karty, ulgi);
        PozycjeRecept pozycjeRecept = new PozycjeRecept(500000);
        StatusyWizyt statusy = new StatusyWizyt(100000, wizyty);
        Zabiegi zabiegi = new Zabiegi(100000, wizyty, gabinety);
    }
}
