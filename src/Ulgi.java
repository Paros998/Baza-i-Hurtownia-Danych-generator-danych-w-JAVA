import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Random;

public class Ulgi extends GlobalElements {

    private int id;
    private String typUlgi;
    private int procent;
    public int[] idUlg;
    public String[] typyUlg;

    public Ulgi(int liczbaRekordow) throws IOException {
        id = 1;
        generator = new Random();
        file = new File("dane/ulgi.csv");
        typyUlg = new String[liczbaRekordow];
        idUlg = new int[liczbaRekordow];
        if (file.exists())
            file.delete();
        file.createNewFile();

        FileWriter writer = new FileWriter(file, StandardCharsets.UTF_8, true);

        for (int i = 0; i < liczbaRekordow; i++) {
            idUlg[i] = id;
            int indeks = generator.nextInt(ulgiTyp.length);
            typyUlg[i] = typUlgi = ulgiTyp[indeks];
            procent = procentUlgi[indeks];

            writer.write(id + "," + typUlgi + "," + procent + '\n');

            id++;
        }

        writer.close();
    }
}
