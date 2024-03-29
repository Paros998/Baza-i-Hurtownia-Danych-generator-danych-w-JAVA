USE [Job_Portal]
GO
/****** Object:  Table [dbo].[Aplikant]    Script Date: 09.11.2022 20:52:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Aplikant](
	[aplikant_id] [uniqueidentifier] NOT NULL,
	[imie] [varchar](50) NOT NULL,
	[nazwisko] [varchar](50) NOT NULL,
	[data_urodzenia] [date] NOT NULL,
	[pesel] [varchar](50) NOT NULL,
	[doswiadczenie] [int] NULL,
 CONSTRAINT [PK_Aplikant] PRIMARY KEY CLUSTERED 
(
	[aplikant_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bonusy]    Script Date: 09.11.2022 20:52:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bonusy](
	[bonus_id] [uniqueidentifier] NOT NULL,
	[stanowisko_id] [uniqueidentifier] NOT NULL,
	[opis] [varchar](500) NULL,
	[wartosc] [decimal](10, 2) NULL,
	[nazwa] [varchar](50) NULL,
 CONSTRAINT [PK_Bonusy] PRIMARY KEY CLUSTERED 
(
	[bonus_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CV]    Script Date: 09.11.2022 20:52:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CV](
	[cv_id] [uniqueidentifier] NOT NULL,
	[miasto] [varchar](50) NOT NULL,
	[wojewodztwo] [varchar](50) NOT NULL,
	[kod_pocztowy] [varchar](50) NOT NULL,
	[kraj] [varchar](50) NOT NULL,
	[ulica] [varchar](150) NOT NULL,
 CONSTRAINT [PK_CV] PRIMARY KEY CLUSTERED 
(
	[cv_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Doswiadczenie]    Script Date: 09.11.2022 20:52:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Doswiadczenie](
	[doswiadczenie_id] [uniqueidentifier] NOT NULL,
	[cv_id] [uniqueidentifier] NOT NULL,
	[od] [date] NOT NULL,
	[do] [date] NOT NULL,
	[obowiazki] [varchar](500) NOT NULL,
	[stanowisko] [varchar](50) NOT NULL,
	[firma] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Doswiadczenie] PRIMARY KEY CLUSTERED 
(
	[doswiadczenie_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Firma]    Script Date: 09.11.2022 20:52:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Firma](
	[firma_id] [uniqueidentifier] NOT NULL,
	[nazwa] [varchar](50) NOT NULL,
	[adres] [varchar](150) NOT NULL,
	[email] [varchar](50) NOT NULL,
	[nip] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Firma] PRIMARY KEY CLUSTERED 
(
	[firma_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Kursy]    Script Date: 09.11.2022 20:52:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Kursy](
	[kurs_id] [uniqueidentifier] NOT NULL,
	[cv_id] [uniqueidentifier] NOT NULL,
	[data] [date] NOT NULL,
	[wazne_do] [date] NOT NULL,
	[nazwa] [varchar](50) NOT NULL,
	[opis] [varchar](500) NULL,
 CONSTRAINT [PK_Kursy_szkolenia] PRIMARY KEY CLUSTERED 
(
	[kurs_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Rekruter]    Script Date: 09.11.2022 20:52:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rekruter](
	[rekruter_id] [uniqueidentifier] NOT NULL,
	[imie] [varchar](50) NOT NULL,
	[nazwisko] [varchar](50) NOT NULL,
	[email] [varchar](50) NOT NULL,
	[nr_telefonu] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Rekruter] PRIMARY KEY CLUSTERED 
(
	[rekruter_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reprezentant_firmy]    Script Date: 09.11.2022 20:52:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reprezentant_firmy](
	[reprezentant_id] [uniqueidentifier] NOT NULL,
	[nazwisko] [varchar](50) NOT NULL,
	[imie] [varchar](50) NOT NULL,
	[rola_w_firmie] [varchar](150) NOT NULL,
 CONSTRAINT [PK_Reprezentant_firmy] PRIMARY KEY CLUSTERED 
(
	[reprezentant_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Stanowisko]    Script Date: 09.11.2022 20:52:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stanowisko](
	[stanowisko_id] [uniqueidentifier] NOT NULL,
	[nazwa] [varchar](50) NOT NULL,
	[nazwa_sektora] [varchar](50) NOT NULL,
	[opis] [varchar](500) NULL,
	[widelki_od] [decimal](10, 2) NOT NULL,
	[widelki_do] [decimal](10, 2) NOT NULL,
	[stopień_zaawansowania] [int] NOT NULL,
 CONSTRAINT [PK_Stanowisko] PRIMARY KEY CLUSTERED 
(
	[stanowisko_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Test_Kwalifikacyjny]    Script Date: 09.11.2022 20:52:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Test_Kwalifikacyjny](
	[test_id] [uniqueidentifier] NOT NULL,
	[nazwa] [varchar](50) NOT NULL,
	[opis_czynnosci] [varchar](500) NULL,
	[stopien_trudnosci] [int] NOT NULL,
 CONSTRAINT [PK_Test_Kwalifikacyjny] PRIMARY KEY CLUSTERED 
(
	[test_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Umiejetnosci]    Script Date: 09.11.2022 20:52:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Umiejetnosci](
	[umiejetnosc_id] [uniqueidentifier] NOT NULL,
	[cv_id] [uniqueidentifier] NOT NULL,
	[nazwa] [varchar](50) NOT NULL,
	[stopien] [int] NOT NULL,
 CONSTRAINT [PK_Umiejetnosci] PRIMARY KEY CLUSTERED 
(
	[umiejetnosc_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Umowa]    Script Date: 09.11.2022 20:52:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Umowa](
	[umowa_id] [uniqueidentifier] NOT NULL,
	[obowiazki] [varchar](500) NOT NULL,
	[wymogi] [varchar](500) NOT NULL,
	[typ_umowy] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Umowa] PRIMARY KEY CLUSTERED 
(
	[umowa_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Wyksztalcenie]    Script Date: 09.11.2022 20:52:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Wyksztalcenie](
	[wyksztalcenie_id] [uniqueidentifier] NOT NULL,
	[cv_id] [uniqueidentifier] NOT NULL,
	[od] [date] NOT NULL,
	[do] [date] NOT NULL,
	[opis] [varchar](500) NULL,
	[nazwa] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Wyksztalcenie] PRIMARY KEY CLUSTERED 
(
	[wyksztalcenie_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Wymagania]    Script Date: 09.11.2022 20:52:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Wymagania](
	[wymaganie_id] [uniqueidentifier] NOT NULL,
	[stanowisko_id] [uniqueidentifier] NOT NULL,
	[nazwa] [varchar](50) NOT NULL,
	[opis] [varchar](500) NULL,
	[stopien_zaawansowania] [int] NOT NULL,
 CONSTRAINT [PK_Wymagania] PRIMARY KEY CLUSTERED 
(
	[wymaganie_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Zatrudnienie]    Script Date: 09.11.2022 20:52:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Zatrudnienie](
	[aplikant_id] [uniqueidentifier] NOT NULL,
	[cv_id] [uniqueidentifier] NOT NULL,
	[umowa_id] [uniqueidentifier] NOT NULL,
	[firma_id] [uniqueidentifier] NOT NULL,
	[stanowisko_id] [uniqueidentifier] NOT NULL,
	[rekruter_id] [uniqueidentifier] NOT NULL,
	[reprezentant_id] [uniqueidentifier] NOT NULL,
	[test_id] [uniqueidentifier] NOT NULL,
	[ilosc_aplikacji_na_stan] [int] NOT NULL,
	[data_zatrudnienia] [date] NOT NULL,
	[rozmowa_kwal_przeprowadzona] [bit] NOT NULL,
	[liczba_prac_firmy] [int] NOT NULL,
	[zdany_test_kwal] [bit] NOT NULL,
	[stawka_pocz] [decimal](10, 2) NOT NULL,
	[waznosc_umowy] [date] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Bonusy]  WITH CHECK ADD  CONSTRAINT [FK_Bonusy_Stanowisko] FOREIGN KEY([stanowisko_id])
REFERENCES [dbo].[Stanowisko] ([stanowisko_id])
GO
ALTER TABLE [dbo].[Bonusy] CHECK CONSTRAINT [FK_Bonusy_Stanowisko]
GO
ALTER TABLE [dbo].[Doswiadczenie]  WITH CHECK ADD  CONSTRAINT [FK_Doswiadczenie_CV] FOREIGN KEY([cv_id])
REFERENCES [dbo].[CV] ([cv_id])
GO
ALTER TABLE [dbo].[Doswiadczenie] CHECK CONSTRAINT [FK_Doswiadczenie_CV]
GO
ALTER TABLE [dbo].[Kursy]  WITH CHECK ADD  CONSTRAINT [FK_Kursy_CV] FOREIGN KEY([cv_id])
REFERENCES [dbo].[CV] ([cv_id])
GO
ALTER TABLE [dbo].[Kursy] CHECK CONSTRAINT [FK_Kursy_CV]
GO
ALTER TABLE [dbo].[Umiejetnosci]  WITH CHECK ADD  CONSTRAINT [FK_Umiejetnosci_CV] FOREIGN KEY([cv_id])
REFERENCES [dbo].[CV] ([cv_id])
GO
ALTER TABLE [dbo].[Umiejetnosci] CHECK CONSTRAINT [FK_Umiejetnosci_CV]
GO
ALTER TABLE [dbo].[Wyksztalcenie]  WITH CHECK ADD  CONSTRAINT [FK_Wyksztalcenie_CV] FOREIGN KEY([cv_id])
REFERENCES [dbo].[CV] ([cv_id])
GO
ALTER TABLE [dbo].[Wyksztalcenie] CHECK CONSTRAINT [FK_Wyksztalcenie_CV]
GO
ALTER TABLE [dbo].[Wymagania]  WITH CHECK ADD  CONSTRAINT [FK_Wymagania_Stanowisko] FOREIGN KEY([stanowisko_id])
REFERENCES [dbo].[Stanowisko] ([stanowisko_id])
GO
ALTER TABLE [dbo].[Wymagania] CHECK CONSTRAINT [FK_Wymagania_Stanowisko]
GO
ALTER TABLE [dbo].[Zatrudnienie]  WITH CHECK ADD  CONSTRAINT [FK_Zatrudnienie_Aplikant] FOREIGN KEY([aplikant_id])
REFERENCES [dbo].[Aplikant] ([aplikant_id])
GO
ALTER TABLE [dbo].[Zatrudnienie] CHECK CONSTRAINT [FK_Zatrudnienie_Aplikant]
GO
ALTER TABLE [dbo].[Zatrudnienie]  WITH CHECK ADD  CONSTRAINT [FK_Zatrudnienie_CV] FOREIGN KEY([cv_id])
REFERENCES [dbo].[CV] ([cv_id])
GO
ALTER TABLE [dbo].[Zatrudnienie] CHECK CONSTRAINT [FK_Zatrudnienie_CV]
GO
ALTER TABLE [dbo].[Zatrudnienie]  WITH CHECK ADD  CONSTRAINT [FK_Zatrudnienie_Firma] FOREIGN KEY([firma_id])
REFERENCES [dbo].[Firma] ([firma_id])
GO
ALTER TABLE [dbo].[Zatrudnienie] CHECK CONSTRAINT [FK_Zatrudnienie_Firma]
GO
ALTER TABLE [dbo].[Zatrudnienie]  WITH CHECK ADD  CONSTRAINT [FK_Zatrudnienie_Rekruter] FOREIGN KEY([rekruter_id])
REFERENCES [dbo].[Rekruter] ([rekruter_id])
GO
ALTER TABLE [dbo].[Zatrudnienie] CHECK CONSTRAINT [FK_Zatrudnienie_Rekruter]
GO
ALTER TABLE [dbo].[Zatrudnienie]  WITH CHECK ADD  CONSTRAINT [FK_Zatrudnienie_Reprezentant_firmy] FOREIGN KEY([reprezentant_id])
REFERENCES [dbo].[Reprezentant_firmy] ([reprezentant_id])
GO
ALTER TABLE [dbo].[Zatrudnienie] CHECK CONSTRAINT [FK_Zatrudnienie_Reprezentant_firmy]
GO
ALTER TABLE [dbo].[Zatrudnienie]  WITH CHECK ADD  CONSTRAINT [FK_Zatrudnienie_Stanowisko] FOREIGN KEY([stanowisko_id])
REFERENCES [dbo].[Stanowisko] ([stanowisko_id])
GO
ALTER TABLE [dbo].[Zatrudnienie] CHECK CONSTRAINT [FK_Zatrudnienie_Stanowisko]
GO
ALTER TABLE [dbo].[Zatrudnienie]  WITH CHECK ADD  CONSTRAINT [FK_Zatrudnienie_Test_Kwalifikacyjny] FOREIGN KEY([test_id])
REFERENCES [dbo].[Test_Kwalifikacyjny] ([test_id])
GO
ALTER TABLE [dbo].[Zatrudnienie] CHECK CONSTRAINT [FK_Zatrudnienie_Test_Kwalifikacyjny]
GO
ALTER TABLE [dbo].[Zatrudnienie]  WITH CHECK ADD  CONSTRAINT [FK_Zatrudnienie_Umowa] FOREIGN KEY([umowa_id])
REFERENCES [dbo].[Umowa] ([umowa_id])
GO
ALTER TABLE [dbo].[Zatrudnienie] CHECK CONSTRAINT [FK_Zatrudnienie_Umowa]
GO
