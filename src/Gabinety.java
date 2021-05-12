import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Random;

public class Gabinety extends GlobalElements {
    private int id;
    private String oznaczenie;
    private int kontakt, pracownik, placówka;
    public int[] wylosowaneId;
    public int[] uzyteKontakty;

    public Gabinety(int liczbaRekordow, Kontakty kontakty, Placówki placówki, Pracownicy pracownicy, Pacjenci pacjenci)
            throws IOException {
        id = 1;
        generator = new Random();
        file = new File("gabinety.csv");
        wylosowaneId = new int[liczbaRekordow];
        uzyteKontakty = new int[liczbaRekordow];

        if (file.exists())
            file.delete();
        file.createNewFile();

        FileWriter writer = new FileWriter(file, StandardCharsets.UTF_8, true);

        for (int i = 0; i < liczbaRekordow; i++) {
            wylosowaneId[i] = id;
            int indeks;

            // losowanie kontaktu uwzględniając już użyte w placówkach , pracownikach i
            // pacjentach
            indeks = generator.nextInt(kontakty.wylosowaneId.length);
            for (int j = 0; j < i; j++) {
                if (uzyteKontakty[j] == indeks || placówki.uzyteKontakty[j] == indeks
                        || pracownicy.uzyteKontakty[j] == indeks || pacjenci.uzyteKontakty[j] == indeks) {
                    indeks = generator.nextInt(kontakty.wylosowaneId.length);
                    j = 0;
                }
            }
            uzyteKontakty[i] = indeks;
            kontakt = uzyteKontakty[i];

            writer.write(id + "," + '\n');

            id++;

        }
        writer.close();
    }
}
