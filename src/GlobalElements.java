import java.io.File;
import java.io.FileWriter;
import java.util.Random;

public abstract class GlobalElements {
        // Ludzie
        protected String[] imionaMeskie = { "Norbert", "Kajetan", "Leszek", "Marcin", "Remigiusz", "Jaroslaw",
                        "Anastazy", "Jozef", "Eryk", "Emil", "Konrad", "Norbert", "Oktawian", "Kazimierz", "Emil",
                        "Marcin", "Eryk", "Pawel", "Czeslaw", "Grzegorz", "Bartosz", "Alan", "Julian", "Kewin", "Oskar",
                        "Igor", "Bartosz", "Leszek", "Eustachy", "Artur", "Alek", "Alex", "Lukasz", "Andrzej", "Cezary",
                        "Gustaw", "Konrad", "Jan", "Anatol", "Marcel" };
        protected String[] imonaZenskie = { "Franciszka", "Ewelina", "Alicja", "Andzelika", "Iza", "Luiza", "Zofia",
                        "Jowita", "Aleksandra", "Agata", "Monika", "Milena", "Oksana", "Olga", "Klaudia", "Otylia",
                        "Katarzyna", "Teresa", "Boguslawa", "Celina", "Helena", "Arleta", "Milena", "Maja", "Katarzyna",
                        "Elzbieta", "Adrianna", "Oktawia", "Agata", "Jola", "Barbara", "Nikola", "Joanna", "Jozefa",
                        "Antonina", "Magdalena", "Dagmara", "Otylia", "Marlena", "Honorata" };
        protected String[] nazwiskaMeskie = { "Zawadzki", "Walczak", "Jasinski", "Urbanski", "Sikora", "Jakubowski",
                        "Marciniak", "Kwiatkowski", "Kucharski", "Malinowski", "Mazur", "Kozlowski", "Krupski",
                        "Krawczyk", "Wisniewski", "Wozniak", "Kubiak", "Witkowski", "Kozlowski", "Lis", "Kowalski",
                        "Walczak", "Rutkowski", "Wisniewski", "Brzezinski", "Andrzejewski", "Zalewski", "Krawczyk",
                        "Wysocki", "Laskowski", "Kubiak", "Duda", "Szewczyk", "Malinowski", "Gorski", "Przybylski",
                        "Wlodarczyk", "Przyreba", "Gorkiewicz", "Kolodziej" };
        protected String[] nazwiskaZenskie = { "Gorska", "Piotrowska", "Nowak", "Pietrzak", "Marciniak", "Piotrowska",
                        "Maciejewska", "Gajewska", "Gajewska", "Urbanska", "Zawadzka", "Witkowska", "Kubiak", "Adamska",
                        "Blaszczyk", "Baranowska", "Sikorska", "Szczepanska", "Krawczyk", "Jaworska", "Baranowska",
                        "Ziolkowska", "Jankowska", "Zakrzewska", "Sawicka", "Przybylska", "Gajewska", "Kwiatkowska",
                        "Tomaszewska", "Szulc", "Chmielewska", "Zielinska", "Gorska", "Brzezinska", "Kucharska",
                        "Przybylska", "Sikora", "Glowacka", "Wojcik", "Pietrzak" };
        protected int iloscNazwiskIImion = 40;
        // Uprawnienia
        protected String[] UprawnieniaOznaczenia = { "UPS1", "UPS2", "UPS3", "UPS4", "UPS5", "UPS6", "UPS7", "UPS8",
                        "UPS9", "UPDB", "UPDZ" };
        protected String[] UprawnieniaOpisy = { "Uprawnienia stopnia 1", "Uprawnienia stopnia 2",
                        "Uprawnienia stopnia 3", "Uprawnienia stopnia 4", "Uprawnienia stopnia 5",
                        "Uprawnienia stopnia 6", "Uprawnienia stopnia 7", "Uprawnienia stopnia 8",
                        "Uprawnienia stopnia 9", "Uprawnienia do przeprowadzania badan",
                        "Uprawnienia do przeprowadzania zabiegow" };
        protected int iloscUprawnien = 11;
        // Specjalności
        protected String[] SpecjalnosciNazwy = { "Alergologia", "Anestezjologia i intensywna terapia", "Angiologia",
                        "Audiologia i foniatria", "Balneologia i medycyna fizykalna", "Chirurgia dziecięca",
                        "Chirurgia klatki piersiowej", "Chirurgia naczyniowa", "Chirurgia ogólna",
                        "Chirurgia onkologiczna", "Chirurgia plastyczna", "Chirurgia szczękowo-twarzowa",
                        "Choroby płuc", "Choroby płuc dzieci", "Choroby wewnętrzne", "Choroby zakaźne",
                        "Dermatologia i wenerologia", "Diabetologia", "Diagnostyka laboratoryjna", "Endokrynologia",
                        "Endokrynologia ginekologiczna i rozrodczość", "Endokrynologia i diabetologia dziecięca",
                        "Epidemiologia", "Farmakologia kliniczna", "Gastroenterologia", "Gastroenterologia dziecięca",
                        "Genetyka kliniczna", "Geriatria", "Ginekologia onkologiczna", "Hematologia",
                        "Hipertensjologia", "Immunologia kliniczna", "Intensywna terapia", "Kardiochirurgia",
                        "Kardiologia", "Kardiologia dziecięca", "Medycyna lotnicza", "Medycyna morska i tropikalna",
                        "Medycyna nuklearna", "Medycyna paliatywna", "Medycyna pracy", "Medycyna ratunkowa",
                        "Medycyna rodzinna", "Medycyna sądowa", "Medycyna sportowa", "Mikrobiologia lekarska",
                        "Nefrologia", "Nefrologia dziecięca", "Neonatologia", "Neurochirurgia", "Neurologia",
                        "Neurologia dziecięca", "Neuropatologia", "Okulistyka", "Onkologia i hematologia dziecięca",
                        "Onkologia kliniczna", "Ortopedia i traumatologia narządu ruchu", "Otorynolaryngologia",
                        "Otorynolaryngologia dziecięca", "Patomorfologia", "Pediatria", "Pediatria metaboliczna",
                        "Perinatologia", "Położnictwo i ginekologia", "Psychiatria", "Psychiatria dzieci i młodzieży",
                        "Radiologia i diagnostyka obrazowa", "Radioterapia onkologiczna", "Rehabilitacja medyczna",
                        "Reumatologia", "Seksuologia", "Toksykologia kliniczna", "Transfuzjologia kliniczna",
                        "Transplantologia kliniczna", "Urologia", "Urologia dziecięca", "Zdrowie publiczne",
                        "Chirurgia stomatologiczna", "Chirurgia szczękowo-twarzowa", "Ortodoncja", "Periodontologia",
                        "Protetyka stomatologiczna", "Stomatologia dziecięca", "Stomatologia zachowawcza z endodoncją",
                        "Epidemiologia", "Zdrowie publiczne" };
        protected int iloscSpecjalnosci = 85;
        // Placówki
        protected String[] placowkiNazwy = { "Centrum Medyczno-Diagnostyczne", "Unimed", "Medican", "Optimed",
                        "Prodimed", "Red-Med", "Voxel Centrum", "Podimed", "Klinika Kardiochirurgi", "Adamed",
                        "NZOZ Danea" };
        protected int iloscPlacowek = 11;
        // Adresy
        protected String[] adresyMiasta = { "Bialystok", "Bydgoszcz", "Gdansk", "Katowice", "Kielce", "Krakow",
                        "Lublin", "Lodz", "Olsztyn", "Opole", "Poznan", "Rzeszow", "Szczecin", "Warszawa", "Wroclaw",
                        "Zielona Gora" };
        protected String[] adresyWojewodztwa = { "Podlaskie", "Kujawsko-Pomorskie", "Pomorskie", "Slaskie",
                        "Swietokrzyskie", "Malopolskie", "Lubelskie", "Lodzkie", "Warminsko-Mazurskie", "Opolskie",
                        "Wielkopolskie", "Podkarpackie", "Zachodnio-Pomorskie", "Mazowieckie", "Dolnoslaskie",
                        "Lubuskie" };
        protected String[] adresyKodyPocztowe = { "15-102", "85-461", "80-761", "40-203", "25-900", "31-403", "20-218",
                        "90-001", "10-900", "45-309", "60-967", "35-085", "71-004", "01-464", "51-416", "65-751" };
        protected String[] adresyUlice = { "Polna", "Lesna", "Sloneczna", "Krotka", "Szkolna", "Ogrodowa", "Lipowa",
                        "Lakowa", "Brzozowa", "Kwiatowa", "Koscielna", "Sosnowa", "Zielona", "Parkowa", "Akacjowa",
                        "Kolejowa" };
        protected int iloscMiastWojUlic = 16;
        // Gabinety
        protected String[] gabinetyOznaczenia = { "Badania", "Wizyty", "Zabiegi", "Wizyty kontrolne" };
        protected int iloscGabinetówOznaczeń = 4;
        // Karty
        protected String[] kartyGrupyKrwi = { "A+", "A-", "B+", "B-", "0+", "0-", "AB+", "AB-" };
        protected int iloscGrupKrwi = 8;
        // Choroby
        protected String[] chorobyNazwy = { "Zapalenie miesnia sercowego", "Zapalenie osierdzia",
                        "Choroba niedkrwienna serca", "Dlawica piersiowa", "Astma", "Cukrzyca", "Nowotwor trzustki",
                        "Nowotwor tchawicy", "Grypa", "Kamica nerkowa", "Wrzody", "Osteoporoza", "Kamica zolciowa",
                        "Alergia" };
        protected String[] chorobyOpisy = {
                        "Oprocz bolu w klatce piersiowej pojawia się goraczka, zmeczenie i problemy z oddychaniem",
                        "Ostry, staly, czasami bardzo intensywny bol serca, ktory promieniuje do barkow i szyi",
                        "Powoduje zamostkowy bol serca, czesto promieniujacy do zuchwy i konczyn gornych",
                        "Objawia sie napadowymi bolami w okolicy serca lub mostka,czesto wystepuje po wysilku fizycznym",
                        "Objawy ataku astmy to głownie niepokoj, swiszczacy oddech, kaszel i dusznosci",
                        "Choroba polega na zaburzeniu gospodarki weglowodanowej spowodowanej niedoborem insuliny w organizmie",
                        "Bol brzucha, nudnosci, brak apetytu, utrata masy ciala i chudniecie",
                        "Zaburzenia glosu, poczatkowo o zmianie barwy, oslabienia, braku dzwiecznosci, meczliwosci i okresowej chrypki",
                        "Grypie towarzyszy na ogoł wysoka temperatura (nawet powyżej 39 stopni), bole miesni i kosci, natomiast nie zawsze wystepuje katar",
                        "Najczestszym objawem tej choroby jest kolka nerwowa – silny, ostry bol w okolicy ledzwiowej, promieniujacy ku dolowi w kierunku pecherza, cewki i zewnetrznej powierzchni uda",
                        "Silne dolegliwosci bolowe, wynikajace z draznienia owrzodzenia przez przyjmowane pokarmy oraz sok zoladkowy (zazwyczaj kwasny lub nadkwasny)",
                        "Osteoporoza jest nazywana cichym zlodziejem kosci, poniewaz objawia sie rozrzedzeniem tkanki kostnej",
                        "Tepy bol w prawym podzebrzu, wzdecia brzucha i rozne objawy dyspeptyczne",
                        "Katar, lzawienie oczu, podraznienie skory i gardla" };
        protected int iloscChorób = 14;
        // Stanowiska
        protected String[] stanowiskaNazwy = { "Recepcjonista", "Ksiegowy", "Konserwator", "Operator RTG/TMG",
                        "Pielegniarz", "Lekarz pediatra", "Chirurg urazowy", "Denstysta", "Dermatolog",
                        "Lekarz Pierwszego Kontaktu", "Onkolog", "Immunolog", "Ginekolog", "Okulista", "Laborant",
                        "Neurolog", "Urolog", "Alergolog", "Kardiolog" };
        protected int[] stanowiskaPlace = { 3600, 4900, 2500, 3400, 4300, 8500, 6000, 4500, 5400, 5000, 6050, 5700,
                        4500, 5500, 4040, 6300, 5000, 3900, 6100 };
        protected int iloscStanowisk = 19;
        // Zabiegi
        protected String[] zabiegiNazwy = { "abdominoplastyka", "adenotomia", "adenomektomia", "adrenalektomia",
                        "amputacja", "angioplastyka", "antromastoidektomia", "appendektomia", "artroskopia",
                        "astragalektomia", "bronchotomia", "cholecystektomia", "cystogastrostomia",
                        "dekortykacja pluca", "diwertikulotomia", "fundoplastyka", "gastrektomia", "hemikorporektomia",
                        "heminefrektomia", "hemisferektomia", "hepatektomia", "hipofizektomia", "histerektomia",
                        "irydektomia", "kalozotomia", "kolektomia", "kraniektomia", "laminektomia", "laryngektomia",
                        "laryngofisura", "ligacja jajowodu", "litotrypsja", "lobektomia", "lobotomia", "mastektomia",
                        "metastazektomia", "mukosektomia", "naciecie krocza", "nefrektomia", "nefrotomia", "obrzezanie",
                        "ooforektomia", "operacja Bassiniego", "operacja Billrotha", "operacja Brickera",
                        "operacja Drapanasa", "operacja Girarda", "operacja Halstedta", "operacja Hartmanna",
                        "operacja Jurasza", "operacja Lichtensteina", "operacja Milesa", "operacja Mogga",
                        "operacja Norwooda", "operacja Nussa", "operacja Puestowa", "operacja Rutkowa",
                        "operacja Rydygiera", "operacja Shouldice'a", "operacja Strassmana",
                        "operacja Traverso-Longmire'a", "operacja Warrena", "operacja Whipple’a",
                        "operacje korekty plci", "orbitotomia", "orchidektomia", "owarektomia", "owariektomia",
                        "papilotomia", "paracenteza", "pankreatoduodenektomia", "penektomia", "perikardiektomia",
                        "plastyka Heinekego-Mikulicza", "prostatektomia", "rynotomia", "segmentektomia",
                        "sfinkterotomia", "splenektomia", "trachelektomia", "tyreoidektomia", "ureterosigmoidostomia",
                        "uwuloplastyka", "uwulopalatofaryngoplastyka", "waginektomia", "wagotomia", "wazektomia",
                        "wulwektomia", "wyluszczenie konczyny", "zabieg Bentalla", "zabieg Crile’a", "zabieg Halsteda",
                        "zabieg Pateya", "zabieg Urbana" };
        protected File file;
        protected FileWriter writer;
        protected Random generator;
}