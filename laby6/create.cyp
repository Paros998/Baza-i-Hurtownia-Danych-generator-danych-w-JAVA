CREATE
(pac1:Pacjenci{name:"P_1" , pacjent_id:1 , imie:"Emil" ,nazwisko:"Brzezinski" ,login:"50985051100527250119105568051514956120551155354",haslo:"48771005311849665310351688348499750119108885456"
,pesel_id:"13088027337",kontakt_id:7212,adres_id:26782}),

(pac2:Pacjenci{name:"P_2" , pacjent_id:2 , imie:"Kewin" ,nazwisko:"Marciniak" ,login:null,haslo:null
,pesel_id:"61124651421",kontakt_id:4498,adres_id:24485}),

(pac3:Pacjenci{name:"P_3" , pacjent_id:3 , imie:"Jozef" ,nazwisko:"Szewczyk" ,login:null,haslo:null
,pesel_id:"57747460188",kontakt_id:6874,adres_id:22533}),

(pac4:Pacjenci{name:"P_4" , pacjent_id:4 , imie:"Grzegorz" ,nazwisko:"Krupski" ,login:null,haslo:null
,pesel_id:"16780166056",kontakt_id:35844,adres_id:13847}),

(pac4:Pacjenci{name:"P_5" , pacjent_id:5 , imie:"Oskar" ,nazwisko:"Marciniak" ,login:"106775671104100765010255651041175452",haslo:"4879121536810888678649566650102106"
,pesel_id:"68637325387",kontakt_id:134,adres_id:28766}),

CREATE
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

(g1:Gabinety{name:"G_1",gabinet_id:1,oznaczenie:"Wizyty",pracownik_id:1,kontakt_id:27589,placowka_id:1347}),
(g2:Gabinety{name:"G_2",gabinet_id:2,oznaczenie:"Wizyty",pracownik_id:2,kontakt_id:4990,placowka_id:4452}),
(g3:Gabinety{name:"G_3",gabinet_id:3,oznaczenie:"Zabiegi",pracownik_id:3,kontakt_id:24034,placowka_id:5135}),
(g4:Gabinety{name:"G_4",gabinet_id:4,oznaczenie:"Wizyty kontrolne",pracownik_id:4,kontakt_id:10406,placowka_id:6315}),
(g5:Gabinety{name:"G_5",gabinet_id:5,oznaczenie:"Badania",pracownik_id:5,kontakt_id:1133,placowka_id:4882}),

(g1)-[:Przynależy]->(p1),
(g2)-[:Przynależy]->(p2),
(g3)-[:Przynależy]->(p3),
(g4)-[:Przynależy]->(p4),
(g5)-[:Przynależy]->(p5),