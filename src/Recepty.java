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
    public int iloscReceptUtworzonych;

    public Recepty(int liczbaRekordow, Wizyty wizyty, OddzialyNfz oddzialyNfz, Choroby choroby, Karty karty, Ulgi ulgi,
            Pacjenci pacjenci) throws IOException {

        id = 1;
        generator = new Random();
        file = new File("dane/recepty.csv");

        if (file.exists())
            file.delete();
        file.createNewFile();

        FileWriter writer = new FileWriter(file, StandardCharsets.UTF_8, true);
        iloscReceptUtworzonych = 0;
        for (int i = 0; i < liczbaRekordow; i++) {
            int szansa = 1 + generator.nextInt(10);

            if (szansa > 3) {
                iloscReceptUtworzonych++;
                wizytaId = i + 1;
                pracownikId = wizyty.specjalisci[wizytaId - 1];
                oddzialNfzId = oddzialyNfz.oddzialyId[generator.nextInt(oddzialyNfz.oddzialyId.length)];
                int pacjent = wizyty.pacjenci[wizytaId - 1];
                String pesel = "";
                for (int z = 0; z < pacjenci.wylosowaneId.length; z++) {
                    if (pacjent == pacjenci.wylosowaneId[z]) {
                        pesel = pacjenci.uzytePesele[z];
                        break;
                    }
                }
                for (int k = 0; k < karty.pesele.length; k++) {
                    if (karty.pesele[k] == pesel) {
                        if (karty.wiekPacjentow[k] >= 50) {
                            int ulga;
                            do {
                                ulga = generator.nextInt(ulgi.typyUlg.length);
                            } while (ulgi.typyUlg[ulga] != "Wiekowa50+");
                            ulgaId = ulgi.idUlg[ulga];
                        }

                        else if (karty.wiekPacjentow[k] >= 70) {
                            int ulga;
                            do {
                                ulga = generator.nextInt(ulgi.typyUlg.length);
                            } while (ulgi.typyUlg[ulga] != "Wiekowa70+");
                            ulgaId = ulgi.idUlg[ulga];
                        } else if (karty.wiekPacjentow[k] >= 80) {
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
                        break;
                    }

                }

                for (int c = 0; c < choroby.pesele.length; c++) {
                    if (pesel == choroby.pesele[c]) {
                        receptaChorobaId = choroby.idPacjentow[c];
                        break;
                    }
                }

                if (ulgaId == -1)
                    writer.write(id + "," + pracownikId + "," + wizytaId + "," + oddzialNfzId + "," + receptaChorobaId
                            + "," + '\n');
                else
                    writer.write(id + "," + pracownikId + "," + wizytaId + "," + oddzialNfzId + "," + receptaChorobaId
                            + "," + ulgaId + '\n');
                id++;
            }
        }

        writer.close();
    }
}
