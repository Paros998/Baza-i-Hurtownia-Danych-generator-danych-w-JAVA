import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Random;

public class Pacjenci extends GlobalElements {
    private int id;
    private String imie, nazwisko, login, haslo, pesel;
    private int adres, kontakt;
    public int[] wylosowaneId;
    public int[] uzyteKontakty;
    public int[] uzyteAdresy;
    public String[] uzytePesele;

    public Pacjenci(int liczbaRekordow, Adresy adresy, Kontakty kontakty, Karty karty, Placówki placówki,
            Pracownicy pracownicy) throws IOException {
        id = 1;
        generator = new Random();
        file = new File("pacjenci.csv");
        wylosowaneId = new int[liczbaRekordow];
        uzyteKontakty = new int[liczbaRekordow];
        uzyteAdresy = new int[liczbaRekordow];
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
            // losowanie adresu uwzględniając już użyte w placówkach i pracownikach
            indeks = generator.nextInt(adresy.wylosowaneId.length);
            for (int j = 0; j < i; j++) {
                if (uzyteAdresy[j] == indeks || placówki.uzyteAdresy[j] == indeks
                        || pracownicy.uzyteAdresy[j] == indeks) {
                    indeks = generator.nextInt(adresy.wylosowaneId.length);
                    j = 0;
                }
            }
            uzyteAdresy[i] = indeks;
            adres = uzyteAdresy[i];
            // losowanie kontaktu uwzględniając już użyte w placówkach i pracownikach
            indeks = generator.nextInt(kontakty.wylosowaneId.length);

            for (int j = 0; j < i; j++) {
                if (uzyteKontakty[j] == indeks || placówki.uzyteKontakty[j] == indeks
                        || pracownicy.uzyteKontakty[j] == indeks) {
                    indeks = generator.nextInt(kontakty.wylosowaneId.length);
                    j = 0;
                }
            }
            uzyteKontakty[i] = indeks;
            kontakt = uzyteKontakty[i];
            // losowanie peseluID
            indeks = generator.nextInt(karty.pesele.length);
            if (i == 0) {
                pesel = karty.pesele[indeks];
            } else {
                for (int j = 0; j < i; j++) {
                    if (uzytePesele[j] == karty.pesele[indeks]) {
                        indeks = generator.nextInt(karty.pesele.length);
                        j = 0;
                    }
                }
                pesel = karty.pesele[indeks];
            }
            writer.write(id + "," + imie + "," + nazwisko + "," + login + "," + haslo + "," + pesel + "," + adres + ","
                    + kontakt + '\n');

            id++;
            login = haslo = "";
        }
        writer.close();
    }
}
