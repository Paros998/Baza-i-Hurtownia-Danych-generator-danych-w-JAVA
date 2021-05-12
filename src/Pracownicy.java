import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Random;

public class Pracownicy extends GlobalElements {
    private int id;
    private String imie, nazwisko, login, haslo;
    private double pensja;
    private int adres, kontakt, stanowisko, specjalnosc;
    public int[] wylosowaneId;
    public int[] uzyteKontakty;
    public int[] uzyteAdresy;
    public int[] pracownicyZabiegowi;
    public int[] pracownicyBadawczy;
    public int[] lekarzeZwykli;
    public int iloscpracownicyZabiegowi, iloscpracownicyBadawczy, ilosclekarzeZwykli;

    public Pracownicy(int liczbaRekordow, Placówki placówki, Adresy adresy, Kontakty kontakty, Stanowiska stanowiska,
            Specjalnosci specjalnosci, Uprawnienia uprawnienia) throws IOException {
        id = 1;
        generator = new Random();
        file = new File("pracownicy.csv");
        wylosowaneId = new int[liczbaRekordow];
        uzyteKontakty = new int[liczbaRekordow];
        uzyteAdresy = new int[liczbaRekordow];
        iloscpracownicyZabiegowi = iloscpracownicyBadawczy = ilosclekarzeZwykli = 0;
        if (file.exists())
            file.delete();
        file.createNewFile();

        FileWriter writer = new FileWriter(file, StandardCharsets.UTF_8, true);

        for (int i = 0; i < liczbaRekordow; i++) {
            wylosowaneId[i] = id;
            // losowanie imienia i nazwiska
            int indeks = generator.nextInt(2);
            if (indeks == 0) {
                indeks = generator.nextInt(imionaMeskie.length);
                imie = imionaMeskie[indeks];
                indeks = generator.nextInt(nazwiskaMeskie.length);
                nazwisko = nazwiskaMeskie[indeks];
            } else {
                indeks = generator.nextInt(imonaZenskie.length);
                imie = imonaZenskie[indeks];
                indeks = generator.nextInt(nazwiskaZenskie.length);
                nazwisko = nazwiskaZenskie[indeks];
            }
            // losowanie loginu i haslo jesli wypadnie 0
            indeks = generator.nextInt(2);

            if (indeks == 0) {
                int chars = generator.nextInt(30) + 15;
                for (int z = 1; z <= chars; z++) {
                    int x = generator.nextInt(3);
                    if (x == 0) {
                        login += (char) generator.nextInt(9) + 48;
                    } else if (x == 1) {
                        login += (char) generator.nextInt(25) + 65;
                    } else {
                        login += (char) generator.nextInt(25) + 97;
                    }
                }
                for (int z = 1; z <= chars; z++) {
                    int x = generator.nextInt(3);
                    if (x == 0) {
                        haslo += (char) generator.nextInt(9) + 48;
                    } else if (x == 1) {
                        haslo += (char) generator.nextInt(25) + 65;
                    } else {
                        haslo += (char) generator.nextInt(25) + 97;
                    }
                }
            }
            // losowanie adresu uwzględniając już użyte w placówkach
            indeks = generator.nextInt(adresy.wylosowaneId.length);
            for (int j = 0; j < i; j++) {
                if (uzyteAdresy[j] == indeks || placówki.uzyteAdresy[j] == indeks) {
                    indeks = generator.nextInt(adresy.wylosowaneId.length);
                    j = 0;
                }
            }
            uzyteAdresy[i] = indeks;
            adres = uzyteAdresy[i];
            // losowanie kontaktu uwzględniając już użyte w placówkach
            indeks = generator.nextInt(kontakty.wylosowaneId.length);

            for (int j = 0; j < i; j++) {
                if (uzyteKontakty[j] == indeks || placówki.uzyteKontakty[j] == indeks) {
                    indeks = generator.nextInt(kontakty.wylosowaneId.length);
                    j = 0;
                }
            }
            uzyteKontakty[i] = indeks;
            kontakt = uzyteKontakty[i];
            // losowanie stanowiska
            stanowisko = generator.nextInt(stanowiska.wylosowaneStanowiska.length);
            if (stanowiska.wylosowaneStanowiska[stanowisko] > 4)
                specjalnosc = generator.nextInt(specjalnosci.wylosowaneSpecjalnosci.length);
            // Wpisywanie do tablic id lekarzy z odpowiednimi uprawnieniami
            if (stanowiska.uprawnieniaStanowisk[stanowisko] >= 2 && stanowiska.uprawnieniaStanowisk[stanowisko] <= 8) {
                lekarzeZwykli[ilosclekarzeZwykli] = id;
                ilosclekarzeZwykli++;
            } else if (stanowiska.uprawnieniaStanowisk[stanowisko] == 9) {
                pracownicyBadawczy[iloscpracownicyBadawczy] = id;
                iloscpracownicyBadawczy++;
            } else if (stanowiska.uprawnieniaStanowisk[stanowisko] == 10) {
                pracownicyZabiegowi[iloscpracownicyZabiegowi] = id;
                iloscpracownicyZabiegowi++;
            }

            // Ustawianie pensji
            pensja = stanowiskaPlace[stanowiska.wylosowaneStanowiska[stanowisko]];
            if (specjalnosc > 0) {
                pensja += specjalnosci.wylosowaneDodatki[specjalnosc];
                writer.write(id + "," + imie + "," + nazwisko + "," + login + "," + haslo + "," + pensja + "," + adres
                        + "," + kontakt + "," + stanowisko + "," + specjalnosc + '\n');
            } else
                writer.write(id + "," + imie + "," + nazwisko + "," + login + "," + haslo + "," + pensja + "," + adres
                        + "," + kontakt + "," + stanowisko + "," + '\n');

            id++;
            login = haslo = "";
            specjalnosc = -1;
        }
        writer.close();
    }
}
