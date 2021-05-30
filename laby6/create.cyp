MATCH(n) DETACH DELETE n;
CREATE
(pac1:Pacjenci{name:"P_1" , pacjent_id:1 , imie:"Emil" ,nazwisko:"Brzezinski" ,login:"50985051100527250119105568051514956120551155354",haslo:"48771005311849665310351688348499750119108885456"
,pesel_id:"13088027337",kontakt_id:7212,adres_id:26782}),

(pac2:Pacjenci{name:"P_2" , pacjent_id:2 , imie:"Kewin" ,nazwisko:"Marciniak" ,login:null,haslo:null
,pesel_id:"61124651421",kontakt_id:4498,adres_id:24485}),

(pac3:Pacjenci{name:"P_3" , pacjent_id:3 , imie:"Jozef" ,nazwisko:"Szewczyk" ,login:null,haslo:null
,pesel_id:"57747460188",kontakt_id:6874,adres_id:22533}),

(pac4:Pacjenci{name:"P_4" , pacjent_id:4 , imie:"Grzegorz" ,nazwisko:"Krupski" ,login:null,haslo:null
,pesel_id:"16780166056",kontakt_id:35844,adres_id:13847}),

(pac5:Pacjenci{name:"P_5" , pacjent_id:5 , imie:"Oskar" ,nazwisko:"Marciniak" ,login:"106775671104100765010255651041175452",haslo:"4879121536810888678649566650102106"
,pesel_id:"68637325387",kontakt_id:134,adres_id:28766}),

(p1:Pracownicy{name:"PR_1",pracownik_id:1,imie:"Maja",nazwisko:"Wojcik",login:"V4950oscgKOoQIi5048OFLjjwtUq5348OrdoJa54ItPQ",
haslo:"4856k5148k49C56IY50W53DKC55hn50c48ukTyKfIlMg5449uy",pensja:5600,adres_id:15219,kontakt_id:16904,stanowisko_id:7526,specjalnosc_id:33}),

(p2:Pracownicy{name:"PR_2",pracownik_id:2,imie:"Jan",nazwisko:"Walczak",login:null,
haslo:null,pensja:5800,adres_id:12221,kontakt_id:35313,stanowisko_id:5376,specjalnosc_id:47}),

(p3:Pracownicy{name:"PR_3",pracownik_id:3,imie:"Monika",nazwisko:"Zakrzewska",login:"5055J52X54MCoNYhj48Mk51LJQ54DNF",
haslo:"5555dlp53shtSeIK48LXh515153teok",pensja:6600,adres_id:14023,kontakt_id:29481,stanowisko_id:1318,specjalnosc_id:46}),

(p4:Pracownicy{name:"PR_4",pracownik_id:4,imie:"Marcin",nazwisko:"Kozlowski",login:"49wG49rgk515452sX56535253VX54TT52r54",
haslo:"TfiM49K54e5248i53HVkWnRoS51pVb",pensja:6700,adres_id:26641,kontakt_id:13295,stanowisko_id:8520,specjalnosc_id:93}),

(p5:Pracownicy{name:"PR_5",pracownik_id:5,imie:"Grzegorz",nazwisko:"Brzezinski",login:null,
haslo:null,pensja:5500,adres_id:5160,kontakt_id:7492,stanowisko_id:2978,specjalnosc_id:96}),

(g1:Gabinety{name:"G_1",gabinet_id:1,oznaczenie:"Zabiegi",pracownik_id:1,kontakt_id:27589,placowka_id:1347}),
(g2:Gabinety{name:"G_2",gabinet_id:2,oznaczenie:"Zabiegi",pracownik_id:2,kontakt_id:4990,placowka_id:4452}),
(g3:Gabinety{name:"G_3",gabinet_id:3,oznaczenie:"Wizyty",pracownik_id:3,kontakt_id:24034,placowka_id:5135}),
(g4:Gabinety{name:"G_4",gabinet_id:4,oznaczenie:"Zabiegi",pracownik_id:4,kontakt_id:10406,placowka_id:6315}),
(g5:Gabinety{name:"G_5",gabinet_id:5,oznaczenie:"Badania",pracownik_id:5,kontakt_id:1133,placowka_id:4882}),

(z1:Zabiegi { wezel: "Z_1", zabieg_id: 1, nazwa: "zabieg Urbana", cena_netto: 2000.0, pracownik_id: 2, wizyta_id: 2 }), 
(z2:Zabiegi { wezel: "Z_2", zabieg_id: 2, nazwa: "operacja Nussa", cena_netto: 4500.0, pracownik_id: 2, wizyta_id: 1 }), 
(z3:Zabiegi { wezel: "Z_3", zabieg_id: 3, nazwa: "penektomia", cena_netto: 3000.0, pracownik_id: 1, wizyta_id: 3 }),
(z4:Zabiegi { wezel: "Z_4", zabieg_id: 4, nazwa: "operacja Milesa", cena_netto: 5000.0, pracownik_id: 4, wizyta_id: 4 }),
(z5:Zabiegi { wezel: "Z_5", zabieg_id: 5, nazwa: "tyreoidektomia", cena_netto: 2500.0, pracownik_id: 5, wizyta_id: 5 }),

(sw1:Statusy_wizyt { wezel: "SW_1", statusy_wizyt_id: 1, status: "Zakonczona" }),
(sw2:Statusy_wizyt { wezel: "SW_2", statusy_wizyt_id: 2, status: "Odwolana" }),
(sw3:Statusy_wizyt { wezel: "SW_3", statusy_wizyt_id: 3, status: "Oczekujaca" }),
(sw4:Statusy_wizyt { wezel: "SW_4", statusy_wizyt_id: 4, status: "Zakonczona" }),
(sw5:Statusy_wizyt { wezel: "SW_5", statusy_wizyt_id: 5, status: "Zakonczona" }),

(r1:Recepty { wezel: "R_1", recepta_id: 1, pracownik_id: 2, wizyta_id: 2, oddzial_nfz_id: 85, recepta_choroba_id: 5788, ulga_id: null }),
(r2:Recepty { wezel: "R_2", recepta_id: 2, pracownik_id: 2, wizyta_id: 1, oddzial_nfz_id: 58, recepta_choroba_id: 5788, ulga_id: 50 }),
(r3:Recepty { wezel: "R_3", recepta_id: 3, pracownik_id: 1, wizyta_id: 3, oddzial_nfz_id: 17, recepta_choroba_id: 5683, ulga_id: null }),
(r4:Recepty { wezel: "R_4", recepta_id: 4, pracownik_id: 4, wizyta_id: 4, oddzial_nfz_id: 75, recepta_choroba_id: 4871, ulga_id: null }),
(r5:Recepty { wezel: "R_5", recepta_id: 5, pracownik_id: 5, wizyta_id: 5, oddzial_nfz_id: 66, recepta_choroba_id: 1881, ulga_id: null }),

(w1:Wizyty{name:"W_1",wizyta_id:1,oplata:200,data_wizyty:"02-10-04",godzina_poczatek:"18:38",godzina_koniec:"19:11",pacjent_id:1,prac_spec:2,prac_uma:2,gabinet_id:2}),
(w2:Wizyty{name:"W_2",wizyta_id:2,oplata:1500,data_wizyty:"21-05-29",godzina_poczatek:"19:03",godzina_koniec:"20:15",pacjent_id:2,prac_spec:2,prac_uma:2,gabinet_id:2}),
(w3:Wizyty{name:"W_3",wizyta_id:3,oplata:100,data_wizyty:"21-07-18",godzina_poczatek:"09:33",godzina_koniec:"12:02",pacjent_id:3,prac_spec:1,prac_uma:1,gabinet_id:1}),
(w4:Wizyty{name:"W_4",wizyta_id:4,oplata:1000,data_wizyty:"06-07-07",godzina_poczatek:"08:20",godzina_koniec:"08:45",pacjent_id:4,prac_spec:4,prac_uma:4,gabinet_id:4}),
(w5:Wizyty{name:"W_5",wizyta_id:5,oplata:900,data_wizyty:"02-12-14",godzina_poczatek:"12:31",godzina_koniec:"15:56",pacjent_id:5,prac_spec:5,prac_uma:5,gabinet_id:5}),

(g1)-[:Przynależy{gabinet_id:1,pracownik_id:1}]->(p1),
(g2)-[:Przynależy{gabinet_id:2,pracownik_id:2}]->(p2),
(g3)-[:Przynależy{gabinet_id:3,pracownik_id:3}]->(p3),
(g4)-[:Przynależy{gabinet_id:4,pracownik_id:4}]->(p4),
(g5)-[:Przynależy{gabinet_id:5,pracownik_id:5}]->(p5),

(z1)-[:Wykonywał{zabieg_id:1,pracownik_id:2}]->(p2),
(z2)-[:Wykonywał{zabieg_id:2,pracownik_id:2}]->(p2),
(z3)-[:Wykonywał{zabieg_id:3,pracownik_id:1}]->(p1),
(z4)-[:Wykonywał{zabieg_id:4,pracownik_id:4}]->(p4),
(z5)-[:Wykonywał{zabieg_id:5,pracownik_id:5}]->(p5),

(z1)-[:Przy{zabieg_id:1,wizyta_id:2}]->(w2),
(z2)-[:Przy{zabieg_id:2,wizyta_id:1}]->(w1),
(z3)-[:Przy{zabieg_id:3,wizyta_id:3}]->(w3),
(z4)-[:Przy{zabieg_id:4,wizyta_id:4}]->(w4),
(z5)-[:Przy{zabieg_id:5,wizyta_id:5}]->(w5),

(r1)-[:Wypisał{recepta_id:1,pracownik_id:2}]->(p2),
(r2)-[:Wypisał{recepta_id:2,pracownik_id:2}]->(p2),
(r3)-[:Wypisał{recepta_id:3,pracownik_id:1}]->(p1),
(r4)-[:Wypisał{recepta_id:4,pracownik_id:4}]->(p4),
(r5)-[:Wypisał{recepta_id:5,pracownik_id:5}]->(p5),

(r1)-[:Podczas{recepta_id:1,wizyta_id:2}]->(w2),
(r2)-[:Podczas{recepta_id:2,wizyta_id:1}]->(w1),
(r3)-[:Podczas{recepta_id:3,wizyta_id:3}]->(w3),
(r4)-[:Podczas{recepta_id:4,wizyta_id:4}]->(w4),
(r5)-[:Podczas{recepta_id:5,wizyta_id:5}]->(w5),

(w1)-[:Status{wizyta_id:1,statusy_wizyt_id:1}]->(sw1),
(w2)-[:Status{wizyta_id:2,statusy_wizyt_id:2}]->(sw2),
(w3)-[:Status{wizyta_id:3,statusy_wizyt_id:3}]->(sw3),
(w4)-[:Status{wizyta_id:4,statusy_wizyt_id:4}]->(sw4),
(w5)-[:Status{wizyta_id:5,statusy_wizyt_id:5}]->(sw5),

(w1)-[:Pacjent{wizyta_id:1,pacjent_id:1}]->(pac1),
(w2)-[:Pacjent{wizyta_id:2,pacjent_id:2}]->(pac2),
(w3)-[:Pacjent{wizyta_id:3,pacjent_id:3}]->(pac3),
(w4)-[:Pacjent{wizyta_id:4,pacjent_id:4}]->(pac4),
(w5)-[:Pacjent{wizyta_id:5,pacjent_id:5}]->(pac5),

(w1)-[:Umówił{wizyta_id:1,prac_uma:2}]->(p2),
(w2)-[:Umówił{wizyta_id:2,prac_uma:2}]->(p2),
(w3)-[:Umówił{wizyta_id:3,prac_uma:1}]->(p1),
(w4)-[:Umówił{wizyta_id:4,prac_uma:4}]->(p4),
(w5)-[:Umówił{wizyta_id:5,prac_uma:5}]->(p5),

(w1)-[:Przyjmował{wizyta_id:1,prac_uma:2}]->(p2),
(w2)-[:Przyjmował{wizyta_id:2,prac_uma:2}]->(p2),
(w3)-[:Przyjmował{wizyta_id:3,prac_uma:1}]->(p1),
(w4)-[:Przyjmował{wizyta_id:4,prac_uma:4}]->(p4),
(w5)-[:Przyjmował{wizyta_id:5,prac_uma:5}]->(p5),

(w1)-[:Gdzie{wizyta_id:1,gabinet_id:2}]->(g2),
(w2)-[:Gdzie{wizyta_id:2,gabinet_id:2}]->(g2),
(w3)-[:Gdzie{wizyta_id:3,gabinet_id:1}]->(g1),
(w4)-[:Gdzie{wizyta_id:4,gabinet_id:4}]->(g4),
(w5)-[:Gdzie{wizyta_id:5,gabinet_id:4}]->(g4);