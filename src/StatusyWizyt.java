import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.Random;

public class StatusyWizyt extends GlobalElements {
    private int id;
    private String status;

    public StatusyWizyt(int liczbaRekordow, Wizyty wizyty) throws IOException {
        generator = new Random();
        file = new File("statusy_wizyt.csv");
        id = 1;
        if (file.exists())
            file.delete();
        file.createNewFile();

        FileWriter writer = new FileWriter(file, StandardCharsets.UTF_8, true);

        String data;
        for (int i = 0; i < liczbaRekordow; i++) {
            data = wizyty.daty[i];

            LocalDate a = LocalDate.parse(data);
            LocalDate n = LocalDate.now();

            if (a.isBefore(n)) {
                status = statusyWizyt[1];
            } else {
                int indeks = generator.nextInt(2);
                if (indeks == 0) {
                    status = statusyWizyt[0];
                } else
                    status = statusyWizyt[2];
            }

            writer.write(id + "," + status + "," + '\n');
            id++;
        }

        writer.close();
    }
}
