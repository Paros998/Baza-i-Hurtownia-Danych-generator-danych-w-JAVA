import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Random;

public class Pracownicy extends GlobalElements {
    private int id;

    public int[] wylosowaneId;

    public Pracownicy(int liczbaRekordow, Placówki placówki, Adresy adresy, Kontakty kontakty, Stanowiska stanowiska,
            Specjalnosci specjalnosci, Uprawnienia uprawnienia) throws IOException {
        id = 1;
        generator = new Random();
        file = new File("adresy.csv");
        wylosowaneId = new int[liczbaRekordow];
        if (file.exists())
            file.delete();
        file.createNewFile();

        FileWriter writer = new FileWriter(file, StandardCharsets.UTF_8, true);

        for (int i = 0; i < liczbaRekordow; i++) {
            wylosowaneId[i] = id;

            writer.write(id + "," + '\n');

            id++;
        }
        writer.close();
    }
}
