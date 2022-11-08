import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Random;

public class Uprawnienia extends GlobalElements {

    private int id;
    private String oznaczenie;
    private String opis;
    public int[] wylosowaneId;

    public Uprawnienia(int liczbaRekordow) throws IOException {
        id = 1;
        generator = new Random();
        file = new File("dane/uprawnienia.csv");
        wylosowaneId = new int[liczbaRekordow];

        if (file.exists())
            file.delete();
        file.createNewFile();

        FileWriter writer = new FileWriter(file, StandardCharsets.UTF_8, true);

        for (int i = 0; i < liczbaRekordow; i++) {
            int nrUprawnienia = generator.nextInt(UprawnieniaOznaczenia.length);
            wylosowaneId[i] = nrUprawnienia;

            oznaczenie = UprawnieniaOznaczenia[nrUprawnienia];
            opis = UprawnieniaOpisy[nrUprawnienia];

            writer.write(id + "," + oznaczenie + "," + opis + '\n');

            id++;
        }

        writer.close();
    }
}
