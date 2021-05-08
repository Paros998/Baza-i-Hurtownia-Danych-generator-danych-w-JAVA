import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Random;

public class Uprawnienia extends GlobalElements {

    public Uprawnienia(int liczbaRekordow) throws IOException {
        generator = new Random();
        int i, j, k;
        i = j = k = 1;
        file = new File("uprawnienia.csv");
        if (file.exists())
            file.delete();
        file.createNewFile();
        try {
            FileWriter writer = new FileWriter(file, StandardCharsets.UTF_8, true);
            while (i <= liczbaRekordow) {

                i++;
            }
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
