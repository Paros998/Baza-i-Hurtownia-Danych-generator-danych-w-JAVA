import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Random;

public class Placówki extends GlobalElements {
    private int id;
    private String nazwa;
    private int adres;
    private int kontakt;
    public int[] uzyteKontakty;
    public int[] uzyteAdresy;
    public int[] wylosowaneId;

    public Placówki(int liczbaRekordow, Adresy adresy, Kontakty kontakty) throws IOException {
        id = 1;
        generator = new Random();
        file = new File("dane/placowki.csv");
        uzyteKontakty = new int[liczbaRekordow];
        uzyteAdresy = new int[liczbaRekordow];
        wylosowaneId = new int[liczbaRekordow];

        if (file.exists())
            file.delete();
        file.createNewFile();

        FileWriter writer = new FileWriter(file, StandardCharsets.UTF_8, true);

        for (int i = 0; i < liczbaRekordow; i++) {
            int indeks = generator.nextInt(placowkiNazwy.length);
            wylosowaneId[i] = id;
            nazwa = placowkiNazwy[indeks];
            // losowanie adresu
            indeks = generator.nextInt(adresy.wylosowaneId.length);
            if (i == 0)
                uzyteAdresy[i] = indeks;
            else {
                for (int j = 0; j < i; j++) {
                    if (uzyteAdresy[j] == indeks) {
                        indeks = generator.nextInt(adresy.wylosowaneId.length);
                        j = 0;
                    }
                }
                uzyteAdresy[i] = indeks;
            }
            adres = adresy.wylosowaneId[indeks];
            // losowanie kontaktu
            indeks = generator.nextInt(kontakty.wylosowaneId.length);
            if (i == 0)
                uzyteKontakty[i] = indeks;
            else {
                for (int j = 0; j < i; j++) {
                    if (uzyteKontakty[j] == indeks) {
                        indeks = generator.nextInt(kontakty.wylosowaneId.length);
                        j = 0;
                    }
                }
                uzyteKontakty[i] = indeks;
            }
            kontakt = kontakty.wylosowaneId[indeks];

            writer.write(id + "," + nazwa + "," + adres + "," + kontakt + '\n');
            id++;
        }

        writer.close();
    }
}
