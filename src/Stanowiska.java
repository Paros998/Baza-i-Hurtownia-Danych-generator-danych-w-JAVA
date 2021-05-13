import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Random;

public class Stanowiska extends GlobalElements {
    private int id;
    private int uprawnienie_id;
    private String nazwa;
    private float pensja;
    public int[] wylosowaneStanowiska;
    public int[] uprawnieniaStanowisk;

    public Stanowiska(int liczbaRekordow, Uprawnienia up) throws IOException {

        id = 1;
        generator = new Random();
        file = new File("stanowiska.csv");
        wylosowaneStanowiska = new int[liczbaRekordow];
        uprawnieniaStanowisk = new int[liczbaRekordow];
        if (file.exists())
            file.delete();
        file.createNewFile();

        FileWriter writer = new FileWriter(file, StandardCharsets.UTF_8, true);
        int j;
        for (int i = 0; i < liczbaRekordow; i++) {

            int indeks = generator.nextInt(stanowiskaNazwy.length);
            wylosowaneStanowiska[i] = indeks;

            nazwa = stanowiskaNazwy[indeks];

            pensja = stanowiskaPlace[indeks];
            // Losowanie odpowiedniego id uprawnienia odnośnie stanowiska
            if (indeks == 1) {
                j = generator.nextInt(up.wylosowaneId.length);
                while (up.wylosowaneId[j] != 0) {
                    j = generator.nextInt(up.wylosowaneId.length);
                }
                uprawnienie_id = j;
                uprawnieniaStanowisk[i] = up.wylosowaneId[j];
            } else if (indeks == 0) {
                j = generator.nextInt(up.wylosowaneId.length);
                while (up.wylosowaneId[j] != 1) {
                    j = generator.nextInt(up.wylosowaneId.length);
                }
                uprawnienie_id = j;
                uprawnieniaStanowisk[i] = up.wylosowaneId[j];
            } else if (indeks >= 2 && indeks <= 4) {
                j = generator.nextInt(up.wylosowaneId.length);
                while (up.wylosowaneId[j] != 2) {
                    j = generator.nextInt(up.wylosowaneId.length);
                }
                uprawnienie_id = j;
                uprawnieniaStanowisk[i] = up.wylosowaneId[j];
            } else {
                j = generator.nextInt(up.wylosowaneId.length);
                while (up.wylosowaneId[j] <= 2)
                    j = generator.nextInt(up.wylosowaneId.length);
                uprawnienie_id = j;
                uprawnieniaStanowisk[i] = up.wylosowaneId[j];
            }

            writer.write(id + "," + nazwa + "," + pensja + "," + uprawnienie_id + '\n');

            id++;
        }

        writer.close();

    }
}
