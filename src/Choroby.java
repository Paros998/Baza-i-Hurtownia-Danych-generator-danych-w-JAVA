import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.Random;

public class Choroby extends GlobalElements {
    
    private int id;
    private String nazwa;
    private String opis;
    private String pocztekData;
    private String koniecData;
    private int peselId;
    
    private int[] losujDatePoczatku() {
        int rok, miesiac, dzien;

        rok = 1992 + generator.nextInt(52);
        miesiac = 1 + generator.nextInt(12);
        dzien = 1 + generator.nextInt(28);

        pocztekData = LocalDate.of(rok, miesiac, dzien).toString();

        int[] wynik = new int[3];
        wynik[0] = rok;
        wynik[1] = miesiac;
        wynik[2] = dzien;

        return wynik;
    }

    private void losujDateKonca(int[] data) {
        int rok = 0, miesiac = 0, dzien = 0;
        int opcja = 1 + generator.nextInt(3);

        switch (opcja) {
            case 1:
                while (rok < data[0])
                    rok = 1992 + generator.nextInt(52);
            break;

            case 2:
                while (miesiac < data[1])
                    miesiac = 1 + generator.nextInt(12);
            break;

            case 3:
                while (dzien < data[2])
                    dzien = 1 + generator.nextInt(28);
            break;
        }

        koniecData = LocalDate.of(rok, miesiac, dzien).toString();
    }

    public Choroby(int liczbaRekordow, Karty karty) throws IOException {
        id = 1;
        generator = new Random();
        file = new File("choroby.csv");

        if (file.exists())
            file.delete();
        file.createNewFile();

        FileWriter writer = new FileWriter(file, StandardCharsets.UTF_8, true);

        for (int i = 0; i < liczbaRekordow; i++) {
            int index = generator.nextInt(chorobyNazwy.length);
            nazwa = chorobyNazwy[index];
            opis = chorobyOpisy[index];

            losujDateKonca(losujDatePoczatku());

            peselId = generator.nextInt(karty.pesele.length);

            writer.write(id + "," + nazwa + "," + opis + "," + 
            pocztekData + "," + koniecData + "," + peselId + '\n');

            id++;
        }

        writer.close();
    }
}
