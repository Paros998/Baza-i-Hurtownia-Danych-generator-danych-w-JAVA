import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.Random;

public class Recepty extends GlobalElements {

    private int id;
    private int pracownikId;
    private int oddzialNfzId;
    private int receptaChorobaId;
    private int wizytaId;
    private int ulgaId;

    private void losujUlge(Choroby choroby, Karty karty) {
        
    }

    public Recepty(int liczbaRekordow, Wizyty wizyty, OddzialyNfz oddzialyNfz,
    Choroby choroby, Karty karty, Ulgi ulgi) throws IOException {

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
                receptaChorobaId = choroby.idPacjentow[generator.nextInt(choroby.idPacjentow.length)];
                
                for(int j = 0; j < choroby.idPacjentow.length; j++) {
                    String pesel = karty.pesele[choroby.idPacjentow[j]];

                    if(pesel.equals(wizyty.pacjenci[wizytaId - 1])) {
                        if(karty.wiekPacjentow[choroby.idPacjentow[j]] >= 50) {
                            int ulga;
                            do{
                                ulga = generator.nextInt(ulgi.typyUlg.length);
                            }while(ulgi.typyUlg[ulga] != "Wiekowa50+");
                        }

                        else if(karty.wiekPacjentow[choroby.idPacjentow[j]] >= 70) {
                            int ulga;
                            do{
                                ulga = generator.nextInt(ulgi.typyUlg.length);
                            }while(ulgi.typyUlg[ulga] != "Wiekowa70+");
                        }
                        else if(karty.wiekPacjentow[choroby.idPacjentow[j]] >= 80) {
                            int ulga;
                            do{
                                ulga = generator.nextInt(ulgi.typyUlg.length);
                            }while(ulgi.typyUlg[ulga] != "Wiekowa80+");
                        }
                        else {
                            int ulgaNiepln = 1 + generator.nextInt(100);
                            if(ulgaNiepln <= 3) {
                                int ulga;
                                do{
                                    ulga = generator.nextInt(ulgi.typyUlg.length);
                                }while(ulgi.typyUlg[ulga] != "Niepelnosprawnosciowa");
                            }
                        }
                    }
                }

                writer.write(id + "," + pracownikId + "," + oddzialNfzId +
                 "," + receptaChorobaId + "," + ulgaId + '\n');
    
                id++;
            }
        }

        writer.close();
    }
}
