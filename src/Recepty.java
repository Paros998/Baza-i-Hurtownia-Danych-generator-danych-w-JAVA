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

    public Recepty(int liczbaRekordow, Wizyty wizyty, OddzialyNfz oddzialyNfz, Choroby choroby, Karty karty, Ulgi ulgi)
            throws IOException {

        id = 1;
        generator = new Random();
        file = new File("recepty.csv");

        if (file.exists())
            file.delete();
        file.createNewFile();

        FileWriter writer = new FileWriter(file, StandardCharsets.UTF_8, true);

        for (int i = 0; i < liczbaRekordow; i++) {
            int szansa = 1 + generator.nextInt(10);

            if (szansa > 3) {
                wizytaId = i + 1;
                pracownikId = wizyty.specjalisci[wizytaId - 1];
                oddzialNfzId = oddzialyNfz.oddzialyId[generator.nextInt(oddzialyNfz.oddzialyId.length)];

                for (int j = 0; j < choroby.idPacjentow.length; j++) {
                    String pesel = karty.pesele[choroby.idPacjentow[j] - 1];

                    if (pesel.equals(wizyty.pacjenci[wizytaId - 1])) {
                        if (karty.wiekPacjentow[choroby.idPacjentow[j] - 1] >= 50) {
                            int ulga;
                            do {
                                ulga = generator.nextInt(ulgi.typyUlg.length);
                            } while (ulgi.typyUlg[ulga] != "Wiekowa50+");
                            ulgaId = ulgi.idUlg[ulga];
                        }

                        else if (karty.wiekPacjentow[choroby.idPacjentow[j] - 1] >= 70) {
                            int ulga;
                            do {
                                ulga = generator.nextInt(ulgi.typyUlg.length);
                            } while (ulgi.typyUlg[ulga] != "Wiekowa70+");
                            ulgaId = ulgi.idUlg[ulga];
                        } else if (karty.wiekPacjentow[choroby.idPacjentow[j] - 1] >= 80) {
                            int ulga;
                            do {
                                ulga = generator.nextInt(ulgi.typyUlg.length);
                            } while (ulgi.typyUlg[ulga] != "Wiekowa80+");
                            ulgaId = ulgi.idUlg[ulga];
                        } else {
                            int ulgaNiepln = 1 + generator.nextInt(100);
                            if (ulgaNiepln <= 3) {
                                int ulga;
                                do {
                                    ulga = generator.nextInt(ulgi.typyUlg.length);
                                } while (ulgi.typyUlg[ulga] != "Niepelnosprawnosciowa");
                                ulgaId = ulgi.idUlg[ulga];
                            } else
                                ulgaId = -1;
                        }
                    }
                }
                receptaChorobaId = choroby.idPacjentow[generator.nextInt(choroby.idPacjentow.length)];
                if (ulgaId == -1)
                    writer.write(id + "," + pracownikId + "," + oddzialNfzId + "," + receptaChorobaId + "," + '\n');
                else
                    writer.write(
                            id + "," + pracownikId + "," + oddzialNfzId + "," + receptaChorobaId + "," + ulgaId + '\n');
                id++;
            }
        }

        writer.close();
    }
}
