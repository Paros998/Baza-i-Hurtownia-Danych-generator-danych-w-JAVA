import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Random;

public class Zabiegi extends GlobalElements {
    private int zabieg_id;
    private String nazwa;
    private double cena;
    private int pracownik_id;
    private int wizyta_id;

    public Zabiegi(int liczbaRekordow, Wizyty wizyty, Gabinety gabinety) throws IOException {
        generator = new Random();
        file = new File("zabiegi.csv");
        zabieg_id = 1;
        if (file.exists())
            file.delete();
        file.createNewFile();

        FileWriter writer = new FileWriter(file, StandardCharsets.UTF_8, true);

        for (int i = 0; i < liczbaRekordow; i++) {
            wizyta_id = i + 1;
            int wg = wizyty.gabinety[i];
            if (gabinety.oznaczenia[wg - 1] == "Zabiegi") {
                int indeks = generator.nextInt(zabiegiNazwy.length);
                nazwa = zabiegiNazwy[indeks];

                cena = 500 * (generator.nextInt(10) + 1);

                pracownik_id = wizyty.specjalisci[i];

                writer.write(zabieg_id + "," + nazwa + "," + cena + "," + pracownik_id + "," + wizyta_id + '\n');
                zabieg_id++;
            }
        }
        writer.close();
    }
}
