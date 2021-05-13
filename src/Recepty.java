import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Random;

public class Recepty extends GlobalElements {

    private int id;
    private int pracownikId;
    private int oddzialNfzId;
    private int receptaChorobaId;
    private int wizytaId;
    private int ulgaId;

    public Recepty(int liczbaRekordow, Wizyty wizyty, OddzialyNfz oddzialyNfz) throws IOException {
        id = 1;
        generator = new Random();
        file = new File("recepty.csv");

        if (file.exists())
            file.delete();
        file.createNewFile();

        FileWriter writer = new FileWriter(file, StandardCharsets.UTF_8, true);

        for (int i = 0; i < liczbaRekordow; i++) {
            int szansa = 1 + generator.nextInt(10);

            if(szansa > 3) {
                wizytaId = i + 1;
                pracownikId = wizyty.specjalisci[wizytaId];
                oddzialNfzId = oddzialyNfz.oddzialyId[generator.nextInt(oddzialyNfz.oddzialyId.length)];
                
                writer.write(id + "," + pracownikId + "," + oddzialNfzId +
                 "," + receptaChorobaId + "," + ulgaId + '\n');
    
                id++;
            }
        }

        writer.close();
    }
}
