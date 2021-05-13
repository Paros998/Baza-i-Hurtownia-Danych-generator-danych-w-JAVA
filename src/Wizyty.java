import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Random;

public class Wizyty extends GlobalElements {
    private int id;
    private int opłata;
    private String data;
    private String h_początek;
    private String h_koniec;
    private int pacjent;
    private int pracownik_specjalista;
    private int pracownik_umawiajacy;
    private int gabinet;
    public String[] pacjenci;
    public String[] daty;
    // public int[] lata;
    // public int[] miesiace;
    // public int[] dni;
    public int[] godziny;
    public int[] minuty;
    public int[] gabinety;
    int rok, miesiac, dzien, indeks;
    public int[] specjalisci;

    public Wizyty(int liczbaRekordow, Karty karty, Gabinety Gabinet, Pracownicy pracownicy) throws IOException {
        generator = new Random();
        file = new File("dane/wizyty.csv");
        pacjenci = new String[liczbaRekordow];
        daty = new String[liczbaRekordow];
        // lata = new int[liczbaRekordow];
        // miesiace = new int[liczbaRekordow];
        // dni = new int[liczbaRekordow];
        godziny = new int[liczbaRekordow];
        minuty = new int[liczbaRekordow];
        gabinety = new int[liczbaRekordow];
        specjalisci = new int[liczbaRekordow];
        data = h_koniec = h_początek = "";
        if (file.exists())
            file.delete();
        file.createNewFile();
        FileWriter writer = new FileWriter(file, StandardCharsets.UTF_8, true);

        for (int i = 0; i < liczbaRekordow; i++) {
            // losowanie pacjenta
            indeks = generator.nextInt(karty.pesele.length);
            pacjenci[i] = karty.pesele[indeks];
            // losowanie opłaty
            opłata = 100 * (generator.nextInt(15) + 1);
            // Losowanie gabinetu i pracownika do niego
            indeks = generator.nextInt(Gabinet.wylosowaneId.length);
            gabinet = Gabinet.wylosowaneId[indeks];
            gabinety[i] = gabinet;
            pracownik_specjalista = Gabinet.pracownicyUzyci[indeks];
            specjalisci[i] = pracownik_specjalista;
            // losowanie recepjonistki
            indeks = generator.nextInt(pracownicy.iloscRecepcji);
            pracownik_umawiajacy = pracownicy.recepcja[indeks];
            // Losowanie daty uwzględniając urodzenie
            rok = 2000 + generator.nextInt(24);
            miesiac = 1 + generator.nextInt(12);
            dzien = 1 + generator.nextInt(28);
            while (rok <= karty.lata[indeks] && miesiac <= karty.miesiace[indeks] && dzien < karty.dni[indeks]) {
                rok = 1970 + generator.nextInt(52);
                miesiac = 1 + generator.nextInt(12);
                dzien = 1 + generator.nextInt(28);
            }
            data = LocalDate.of(rok, miesiac, dzien).toString();
            daty[i] = data;
            // Losowanie godzin początkowych i końcowych
            int godzina1, godzina2, minuta1, minuta2;
            godzina1 = generator.nextInt(12) + 8;
            minuta1 = generator.nextInt(60);
            godzina2 = godzina1 + generator.nextInt(3) + 1;
            minuta2 = generator.nextInt(60);
            for (int j = 0; j < i; j++) {
                if (gabinety[j] == gabinet)
                    if (daty[j] == data)
                        if (godziny[j] >= godzina1 && godziny[j] <= godzina2)
                            if (minuty[j] >= minuta1 && minuty[j] <= minuta2) {
                                j = 0;
                                losujPonownie(karty, i);
                            }
            }
            godziny[i] = godzina2;
            minuty[i] = minuta2;
            h_początek = LocalTime.of(godzina1, minuta1, 0).toString();
            h_koniec = LocalTime.of(godzina2, minuta2, 0).toString();

            writer.write(id + "," + opłata + "," + data + "," + h_początek + "," + h_koniec + "," + pacjent + ","
                    + pracownik_specjalista + "," + pracownik_umawiajacy + "," + gabinet + '\n');
            data = h_koniec = h_początek = "";
            id++;
        }
        writer.close();
    }

    private void losujPonownie(Karty karty, int i) {
        // Losowanie daty uwzględniając urodzenie
        rok = 2000 + generator.nextInt(24);
        miesiac = 1 + generator.nextInt(12);
        dzien = 1 + generator.nextInt(28);
        while (rok <= karty.lata[indeks] && miesiac <= karty.miesiace[indeks] && dzien < karty.dni[indeks]) {
            rok = 1970 + generator.nextInt(52);
            miesiac = 1 + generator.nextInt(12);
            dzien = 1 + generator.nextInt(28);
        }
        data = LocalDate.of(rok, miesiac, dzien).toString();
        daty[i] = data;
        // Losowanie godzin początkowych i końcowych
        int godzina1, godzina2, minuta1, minuta2;
        godzina1 = generator.nextInt(12) + 8;
        minuta1 = generator.nextInt(60);
        godzina2 = godzina1 + generator.nextInt(3) + 1;
        minuta2 = generator.nextInt(60);
    }
}
