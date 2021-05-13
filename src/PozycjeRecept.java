import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Random;

public class PozycjeRecept extends GlobalElements {

    private int id;
    private int receptaId;
    private String nazwa;
    private int ilosc;
    private double odplatnosc;

    public PozycjeRecept(int liczbaRekordow) throws IOException {
        id = 1;
        generator = new Random();
        file = new File("dane/pozycje_recept.csv");

        if (file.exists())
            file.delete();
        file.createNewFile();

        FileWriter writer = new FileWriter(file, StandardCharsets.UTF_8, true);

        for (int i = 0; i < liczbaRekordow; i++) {
            receptaId = i + 1;
            int indeks = generator.nextInt(5) + 1;
            int z = indeks;
            for (int j = 1; j <= z; j++) {
                indeks = generator.nextInt(lekNazwa.length);
                nazwa = lekNazwa[indeks];
                ilosc = 1 + generator.nextInt(5);
                odplatnosc = ilosc * cenyLeków[indeks];

                writer.write(id + "," + receptaId + "," + nazwa + "," + ilosc + ","
                        + Float.parseFloat(String.valueOf(odplatnosc).toString()) + '\n');

                id++;
            }
        }

        writer.close();
    }
}
