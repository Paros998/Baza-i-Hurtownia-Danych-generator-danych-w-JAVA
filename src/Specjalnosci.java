import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Random;

public class Specjalnosci extends GlobalElements {

    private int id;
    private String nazwa;
    private int stopien;
    private int dodatek;
    
    public Specjalnosci(int liczbaRekordow) throws IOException {
        id = 1;
        generator = new Random();
        file = new File("specjalnosci.csv");
        
        if(file.exists())
            file.delete();
        file.createNewFile();

        FileWriter writer = new FileWriter(file, StandardCharsets.UTF_8, true);

        for(int i = 0; i < liczbaRekordow; i++) {
            int indeks = generator.nextInt(SpecjalnosciNazwy.length);

            nazwa = SpecjalnosciNazwy[indeks];
            stopien = 1 + generator.nextInt(2);
            dodatek = stopien == 1 ? 300 : 600;

            writer.write(id + "," + nazwa + "," + stopien + "," + dodatek +'\n');

            id++;
        }

        writer.close();
    }
}
