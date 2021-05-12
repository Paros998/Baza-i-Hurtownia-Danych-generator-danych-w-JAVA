import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Random;

public class Kontakty extends GlobalElements {
    private int id;
    private String telefon;
    private String email;

    public Kontakty(int liczbaRekordow) throws IOException {
        id = 1;
        generator = new Random();
        file = new File("kontakty.csv");

        if (file.exists())
            file.delete();
        file.createNewFile();

        FileWriter writer = new FileWriter(file, StandardCharsets.UTF_8, true);

        for (int i = 0; i < liczbaRekordow; i++) {
            for (int j = 1; j <= 9; j++)
                telefon += generator.nextInt(10);
            int k = generator.nextInt(10) + 5;

            for (int z = 1; z <= k; z++) {
                int x = generator.nextInt(3);
                if (x == 0) {
                    email += (char) generator.nextInt(9) + 48;
                } else if (x == 1) {
                    email += (char) generator.nextInt(25) + 65;
                } else {
                    email += (char) generator.nextInt(25) + 97;
                }
            }
            email += "@" + emaile[generator.nextInt(5)];

            writer.write(id + "," + telefon + "," + email + '\n');
            id++;
        }
        writer.close();
    }
}
