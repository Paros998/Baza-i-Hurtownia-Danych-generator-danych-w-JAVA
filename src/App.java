public class App {
    public static void main(String[] args) throws Exception {
        Ulgi ulgi = new Ulgi(100);
        OddzialyNfz oddzialyNfz = new OddzialyNfz(100);
        Adresy adresy = new Adresy(300);
        Kontakty kontakty = new Kontakty(400);
        Specjalnosci specjalnosci = new Specjalnosci(100);
        Uprawnienia uprawnienia = new Uprawnienia(100);
        Stanowiska stanowiska = new Stanowiska(100, uprawnienia);
        Karty karty = new Karty(100);
        Choroby choroby = new Choroby(100, karty);
        Placówki placówki = new Placówki(100, adresy, kontakty);
        Pracownicy pracownicy = new Pracownicy(100, placówki, adresy, kontakty, stanowiska, specjalnosci, uprawnienia);
        Pacjenci pacjenci = new Pacjenci(100, adresy, kontakty, karty, placówki, pracownicy);
        Gabinety gabinety = new Gabinety(100, kontakty, placówki, pracownicy, pacjenci);
        Wizyty wizyty = new Wizyty(10000, karty, gabinety, pracownicy);
        Recepty recepty = new Recepty(10000, wizyty, oddzialyNfz, choroby, karty, ulgi);
        PozycjeRecept pozycjeRecept = new PozycjeRecept(10000);
        StatusyWizyt statusy = new StatusyWizyt(10000, wizyty);
        Zabiegi zabiegi = new Zabiegi(10000, wizyty, gabinety);
    }
}
