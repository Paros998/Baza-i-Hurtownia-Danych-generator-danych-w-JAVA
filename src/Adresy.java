import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Random;

public class Adresy extends GlobalElements {

    private int id;
    private String kodPocztowy;
    private String miasto;
    private String wojewodztwo;
    private String ulica;
    private int numerDomu;
    private int nrMieszkania;
    public int[] wylosowaneId;

    public Adresy(int liczbaRekordow) throws IOException {
        id = 1;
        generator = new Random();
        file = new File("dane/adresy.csv");
        wylosowaneId = new int[liczbaRekordow];
        if (file.exists())
            file.delete();
        file.createNewFile();

        FileWriter writer = new FileWriter(file, StandardCharsets.UTF_8, true);

        for (int i = 0; i < liczbaRekordow; i++) {
            int indeks = generator.nextInt(adresyKodyPocztowe.length);
            wylosowaneId[i] = id;
            kodPocztowy = adresyKodyPocztowe[indeks];
            miasto = adresyMiasta[indeks];
            wojewodztwo = adresyWojewodztwa[indeks];

            indeks = generator.nextInt(adresyUlice.length);
            ulica = adresyUlice[indeks];
            numerDomu = 1 + generator.nextInt(100);
            nrMieszkania = 1 + generator.nextInt(50);

            writer.write(id + "," + kodPocztowy + "," + miasto + "," + wojewodztwo + "," + ulica + "," + numerDomu + ","
                    + nrMieszkania + '\n');

            id++;
        }

        writer.close();
    }
}
