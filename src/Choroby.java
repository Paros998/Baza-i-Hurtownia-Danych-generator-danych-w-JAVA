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
    private String peselId;
    public int[] idPacjentow;
    public String[] pesele;

    private int[] losujDatePoczatku() {
        int rok, miesiac, dzien;

        rok = 1992 + generator.nextInt(LocalDate.now().getYear() - 1992);
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
        int opcja = 1 + generator.nextInt(2);

        switch (opcja) {
            case 1:
                while (rok < data[0])
                    rok = 1992 + generator.nextInt(52);
                miesiac = 1 + generator.nextInt(12);
                dzien = 1 + generator.nextInt(28);
                break;

            case 2:
                while (miesiac < data[1])
                    miesiac = 1 + generator.nextInt(12);
                dzien = 1 + generator.nextInt(28);
                rok = data[0];
                break;
        }

        koniecData = LocalDate.of(rok, miesiac, dzien).toString();
    }

    public Choroby(int liczbaRekordow, Karty karty) throws IOException {
        id = 1;
        generator = new Random();
        file = new File("dane/choroby.csv");
        idPacjentow = new int[karty.pesele.length];
        pesele = new String[karty.pesele.length];
        if (file.exists())
            file.delete();
        file.createNewFile();

        FileWriter writer = new FileWriter(file, StandardCharsets.UTF_8, true);

        for (int i = 0; i < liczbaRekordow; i++) {
            int index = generator.nextInt(chorobyNazwy.length);
            nazwa = chorobyNazwy[index];
            opis = chorobyOpisy[index];

            losujDateKonca(losujDatePoczatku());

            idPacjentow[i] = 1 + generator.nextInt(karty.pesele.length);

            peselId = karty.pesele[idPacjentow[i] - 1];
            pesele[i] = peselId;

            writer.write(id + "*" + nazwa + "*" + opis + "*" + pocztekData + "*" + koniecData + "*" + peselId + '\n');

            id++;
        }

        writer.close();
    }
}
