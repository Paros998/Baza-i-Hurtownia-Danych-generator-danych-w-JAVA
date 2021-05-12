import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.Random;

public class Karty extends GlobalElements {
    
    private String pesel;
    private String data;
    private String grupaKrwi;

    private void dostosujPesel(int[] peselTab) {
        pesel = Arrays.toString(peselTab)
            .replace("[", "")
            .replace("]", "")
            .replace(",", "")
            .replace(" ", "");
    }

    public Karty(int liczbaRekordow) throws IOException {
        generator = new Random();
        file = new File("karty.csv");

        if (file.exists())
            file.delete();
        file.createNewFile();

        FileWriter writer = new FileWriter(file, StandardCharsets.UTF_8, true);

        int rok, miesiac, dzien;
        int[] peselTab = new int[11];

        for (int i = 0; i < liczbaRekordow; i++) {
            rok = 1970 + generator.nextInt(52);
            miesiac = 1 + generator.nextInt(12);
            dzien = 1 + generator.nextInt(28);
            data = LocalDate.of(rok, miesiac, dzien).toString();

            for(int j = 0; j < peselTab.length; j++)
                peselTab[j] = generator.nextInt(9);
            dostosujPesel(peselTab);

            grupaKrwi = kartyGrupyKrwi[generator.nextInt(kartyGrupyKrwi.length)];

            writer.write(pesel + "," + data + "," + grupaKrwi + '\n');
        }

        writer.close();
    }
}
