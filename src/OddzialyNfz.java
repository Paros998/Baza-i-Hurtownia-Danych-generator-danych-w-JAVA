import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Random;

public class OddzialyNfz extends GlobalElements {

    private int id;
    private String nazwa;
    private int kodFunduszu;
    public int[] oddzialyId;

    public OddzialyNfz(int liczbaRekordow) throws IOException {
        id = 1;
        generator = new Random();
        file = new File("dane/oddzialy_nfz.csv");
        oddzialyId = new int[liczbaRekordow];

        if (file.exists())
            file.delete();
        file.createNewFile();

        FileWriter writer = new FileWriter(file, StandardCharsets.UTF_8, true);

        for (int i = 0; i < liczbaRekordow; i++) {
            int indeks = generator.nextInt(oddzialy_nfz_nazwa.length);

            nazwa = oddzialy_nfz_nazwa[indeks];
            kodFunduszu = oddzialy_nfz_kod[indeks];

            writer.write(id + "," + nazwa + "," + kodFunduszu + '\n');

            oddzialyId[i] = id;

            id++;
        }

        writer.close();
    }
}
