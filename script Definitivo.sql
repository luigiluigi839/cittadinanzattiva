DROP DATABASE IF EXISTS Progetto;

CREATE DATABASE IF NOT EXISTS Progetto;

USE Progetto;

SET FOREIGN_KEY_CHECKS = 0;


CREATE TABLE IF NOT EXISTS Regione (
    Cod_ISTAT INT PRIMARY KEY,
    Nome VARCHAR(50) NOT NULL
    ) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Provincia (
    Cod_ISTAT INT,
    Regione INT,
    Nome VARCHAR(50) NOT NULL,
    PRIMARY KEY(Cod_ISTAT, Regione),
    FOREIGN KEY (Regione)
        REFERENCES Regione (Cod_ISTAT)
    ) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Comune (
    Cod_ISTAT INT,
    Provincia INT,
    Nome VARCHAR(50) NOT NULL,
    CAP INT NOT NULL,
    PRIMARY KEY (Cod_ISTAT, Provincia),
    FOREIGN KEY (Provincia)
        REFERENCES Provincia (Cod_ISTAT)
    ) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Indirizzo (
    Via VARCHAR(50),
    Civico INT,
    Comune INT,
    PRIMARY KEY (Via, Civico, Comune),
    FOREIGN KEY (Comune)
        REFERENCES Comune(Cod_ISTAT)
    ) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS  Utente_Amministratore (
    ID INT AUTO_INCREMENT,
    Nome VARCHAR(50) NOT NULL,
    Cognome VARCHAR(50) NOT NULL,
    Email VARCHAR(50) NOT NULL,
    Username VARCHAR(15) NOT NULL,
    Password VARCHAR(20) NOT NULL,
    Telefono_Interno VARCHAR(25) NOT NULL,
    PRIMARY KEY(ID)
    ) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS  Utente_Base (
    ID INT AUTO_INCREMENT,
    Nome VARCHAR(50) NOT NULL,
    Cognome VARCHAR(50) NOT NULL,
    Email VARCHAR(50) NOT NULL,
    Username VARCHAR(15) NOT NULL,
    Password VARCHAR(20) NOT NULL,
    Cellulare VARCHAR(25) NOT NULL,
    Data_nascita DATE NOT NULL,
    Codice_Fiscale VARCHAR(16) NOT NULL,
    Via VARCHAR(50),
    Civico INT,
    Comune INT,
    PRIMARY KEY(ID),
    FOREIGN KEY (Via, Civico, Comune)
        REFERENCES Indirizzo(Via, Civico, Comune)
    ) ENGINE=INNODB;

    


CREATE TABLE IF NOT EXISTS Tipologia (
    Nome VARCHAR(50) PRIMARY KEY, 
    Descrizione VARCHAR(200)
    ) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS  Segnalazione (
    Numero INT AUTO_INCREMENT,
    Dataregistrazione timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Tipo_S VARCHAR(20) NOT NULL,
    Descrizione VARCHAR(600),
    Rating INT DEFAULT 1,
    Stato VARCHAR(20),
    Risposta VARCHAR(600),
    Tipologia VARCHAR(50),
    IDBase INT,
    IDAmministratore INT,
    Via VARCHAR(50),
    Civico INT,
    Comune INT,
    PRIMARY KEY(Numero),
    FOREIGN KEY (Tipologia)
        REFERENCES Tipologia (Nome),
    FOREIGN KEY (IDBase)
        REFERENCES Utente_Base(ID),
    FOREIGN KEY (IDAmministratore)
        REFERENCES Utente_Amministratore (ID),
    FOREIGN KEY (Via, Civico, Comune)
        REFERENCES Indirizzo(Via, Civico, Comune)
    ) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Reparto (
    ID VARCHAR(15) PRIMARY KEY, 
    Nome VARCHAR(50) NOT NULL, 
    Descrizione VARCHAR(200) DEFAULT NULL
    ) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Soggetto_Competente (
    ID VARCHAR(15) PRIMARY KEY,
    Nome VARCHAR(50) NOT NULL,
    Descrizione VARCHAR(200),
    Telefono VARCHAR(25) NOT NULL,
    Email VARCHAR(50),
    Nome_Referente VARCHAR(50),
    Cognome_Referente VARCHAR(50),
    Servizio_Offerto VARCHAR(50),
    Note VARCHAR(200),
    P_IVA VARCHAR(13)
    ) ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS Coordinazione (
    IDReparto VARCHAR(15),
    NomeTipologia VARCHAR(50),
    PRIMARY KEY(IDReparto, NomeTipologia),
    FOREIGN KEY (NomeTipologia)
        REFERENCES Tipologia (Nome),
    FOREIGN KEY (IDReparto)
        REFERENCES Reparto (ID)
    ) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Avviso (
    IDReparto VARCHAR(15),
    IDsoggettoc VARCHAR(15),
    PRIMARY KEY (IDReparto, IDsoggettoc),
    FOREIGN KEY (IDReparto)
        REFERENCES Reparto(ID),
    FOREIGN KEY (IDsoggettoc)
        REFERENCES Soggetto_Competente (ID)
    ) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Competenza (
    IDReparto VARCHAR(15),
    IDAmministratore INT,
    PRIMARY KEY (IDReparto, IDAmministratore),
    FOREIGN KEY (IDReparto)
        REFERENCES Reparto (ID),
    FOREIGN KEY (IDAmministratore)
        REFERENCES Utente_Amministratore (ID)
    ) ENGINE=INNODB;

SET FOREIGN_KEY_CHECKS = 1;

/*Trigger che blocca l'update di segnalazioni ad utenti non residenti in quel Comune*/

DELIMITER $$
CREATE TRIGGER `SoloResidentiUP` BEFORE UPDATE ON `segnalazione`
 FOR EACH ROW BEGIN
    DECLARE id_cittadino INT;
    DECLARE comuneCittadino INT;
    SET id_cittadino = NEW.IDBase;
    

    SELECT Utente_Base.Comune
    FROM Utente_Base 
    WHERE Utente_Base.ID=id_cittadino LIMIT 1 INTO comuneCittadino;

    IF comuneCittadino != NEW.Comune THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='l'utente non è residente in questo Comune!';

    END IF;
END $$
DELIMITER ;

/*Trigger che blocca l'inserimento di nuove segnalazioni ad utenti non residenti in quel Comune*/

DELIMITER $$
CREATE OR REPLACE TRIGGER SoloResidenti BEFORE INSERT ON Segnalazione
FOR EACH ROW 
BEGIN
    DECLARE id_cittadino INT;
    DECLARE comuneCittadino INT;
    SET id_cittadino = NEW.IDBase;
    

    SELECT Utente_Base.Comune
    FROM Utente_Base 
    WHERE Utente_Base.ID=id_cittadino LIMIT 1 INTO comuneCittadino;

    IF comuneCittadino != NEW.Comune THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Non sei residente in questo Comune!';

    END IF;
END $$
DELIMITER ;

/*Trigger che blocca l'inserimento ad utenti con lo stesso numero di telefono*/

DELIMITER $$
CREATE OR REPLACE TRIGGER TelefonoInterno BEFORE INSERT ON Utente_Amministratore
FOR EACH ROW 
BEGIN
    DECLARE Telefono varchar(25);
    DECLARE tel_utente varchar(25);
    SET Telefono = NEW.Telefono_Interno;
    

    SELECT Utente_Amministratore.Telefono_Interno
    FROM Utente_Amministratore 
    WHERE Utente_Amministratore.Telefono_Interno=Telefono INTO tel_utente;

    IF tel_utente = NEW.Telefono_Interno THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Telefono gia registrato da un altro Utente';

    END IF;
END $$
DELIMITER ;

/*Trigger che controlla prima di aggiornare che il nuovo reparto e' diverso dal vecchio reparto*/

DELIMITER $$
CREATE OR REPLACE TRIGGER SpostaAmministratore BEFORE UPDATE ON Competenza
FOR EACH ROW 
BEGIN
    IF NEW.IDAmministratore <> OLD.IDAmministratore THEN 
		SET NEW.IDAmministratore = OLD.IDAmministratore;

    END IF;
END $$
DELIMITER ;


INSERT INTO Regione (Cod_ISTAT, Nome) VALUES
(5,'Veneto');

INSERT INTO Provincia (Cod_ISTAT, Regione, Nome) VALUES
(26086,5,'Treviso');



INSERT INTO Comune (Cod_ISTAT, Provincia, Nome, CAP) VALUES
(26001,26086,'Altivole',31030),
(26002,26086,'Arcade',31030),
(26003,26086,'Asolo',31011),
(26004,26086,'Borso del Grappa',31030),
(26005,26086,'Breda di Piave',31030),
(26006,26086,'Caerano di San Marco',31031),
(26007,26086,'Cappella Maggiore',31012),
(26008,26086,'Carbonera',31030),
(26009,26086,'Casale sul Sile',31032),
(26010,26086,'Casier',31030),
(26011,26086,'Castelcucco',31030),
(26012,26086,'Castelfranco Veneto',31033),
(26013,26086,'Castello di Godego',31030),
(26014,26086,'Cavaso del Tomba',31034),
(26015,26086,'Cessalto',31040),
(26016,26086,'Chiarano',31040),
(26017,26086,'Cimadolmo',31010),
(26018,26086,'Cison di Valmarino',31030),
(26019,26086,'Codogne',31013),
(26020,26086,'Colle Umberto',31014),
(26021,26086,'Conegliano',31015),
(26022,26086,'Cordignano',31016),
(26023,26086,'Cornuda',31041),
(26024,26086,'Crespano del Grappa',31017),
(26025,26086,'Crocetta del Montello',31035),
(26026,26086,'Farra di Soligo',31010),
(26027,26086,'Follina',31051),
(26028,26086,'Fontanelle',31043),
(26029,26086,'Fonte',31010),
(26030,26086,'Fregona',31010),
(26031,26086,'Gaiarine',31018),
(26032,26086,'Giavera del Montello',31040),
(26033,26086,'Godega di Sant Urbano',31010),
(26034,26086,'Gorgo al Monticano',31040),
(26035,26086,'Istrana',31036),
(26036,26086,'Loria',31037),
(26037,26086,'Mansue',31040),
(26038,26086,'Mareno di Piave',31010),
(26039,26086,'Maser',31010),
(26040,26086,'Maserada sul Piave',31052),
(26041,26086,'Meduna di Livenza',31040),
(26042,26086,'Miane',31050),
(26043,26086,'Mogliano Veneto',31021),
(26044,26086,'Monastier di Treviso',31050),
(26045,26086,'Monfumo',31010),
(26046,26086,'Montebelluna',31044),
(26047,26086,'Morgano',31050),
(26048,26086,'Moriago della Battaglia',31010),
(26049,26086,'Motta di Livenza',31045),
(26050,26086,'Nervesa della Battaglia',31040),
(26051,26086,'Oderzo',31046),
(26052,26086,'Ormelle',31024),
(26053,26086,'Orsago',31010),
(26054,26086,'Paderno del Grappa',31017),
(26055,26086,'Paese',31038),
(26056,26086,'Pederobba',31040),
(26057,26086,'Pieve di Soligo',31053),
(26058,26086,'Ponte di Piave',31047),
(26059,26086,'Ponzano Veneto',31050),
(26060,26086,'Portobuffole',31040),
(26061,26086,'Possagno',31054),
(26062,26086,'Povegliano',31050),
(26063,26086,'Preganziol',31022),
(26064,26086,'Quinto di Treviso',31055),
(26065,26086,'Refrontolo',31020),
(26066,26086,'Resana',31023),
(26067,26086,'Revine Lago',31020),
(26068,26086,'Riese Pio X',31039),
(26069,26086,'Roncade',31056),
(26070,26086,'Salgareda',31040),
(26071,26086,'San Biagio di Callalta',31048),
(26072,26086,'San Fior',31020),
(26073,26086,'San Pietro di Feletto',31020),
(26074,26086,'San Polo di Piave',31020),
(26075,26086,'Santa Lucia di Piave',31025),
(26076,26086,'San Vendemiano',31020),
(26077,26086,'San Zenone degli Ezzelini',31020),
(26078,26086,'Sarmede',31026),
(26079,26086,'Segusino',31040),
(26080,26086,'Sernaglia della Battaglia',31020),
(26081,26086,'Silea',31057),
(26082,26086,'Spresiano',31027),
(26083,26086,'Susegana',31058),
(26084,26086,'Tarzo',31020),
(26085,26086,'Trevignano',31040),
(26086,26086,'Treviso',31100),
(26087,26086,'Valdobbiadene',31049),
(26088,26086,'Vazzola',31028),
(26089,26086,'Vedelago',31050),
(26090,26086,'Vidor',31020),
(26091,26086,'Villorba',31020),
(26092,26086,'Vittorio Veneto',31029),
(26093,26086,'Volpago del Montello',31040),
(26094,26086,'Zenson di Piave',31050),
(26095,26086,'Zero Branco',31059);

INSERT INTO Indirizzo (Via, Civico, Comune) VALUES
('via delle Acquette',1,26086),
('via Adamello',45,26086),
('via Adige',23,26086),
('via Carlo Agnoletti',11,26086),
('via F.lli Agosti',22,26086),
('via Leon Battista Alberti',5,26086),
('via Albona',7,26086),
('via Aleandro',78,26086),
('via Aleardo Aleardi',65,26086),
('via Alfieri',3,26086),
('via degli Alpini',8,26086),
('via Altino',76,26086),
('via Alzaia',8,26086),
('via Amalfi',65,26086),
('via Pomponio Amalteo',9,26086),
('via G. Amendola',22,26086),
('via Amundsen',11,26086),
('via A. Anassilide',8,26086),
('piazza Giannino Ancilotto',64,26086),
('via Flaminio',7,26012),
('via Fogazzaro',98,26012),
('via Foiana',9,26012),
('vicolo Fonderia',12,26012),
('via Fonderia',1,26012),
('vicolo Fontane A',8,26012),
('vicolo Fontane B',9,26012),
('strada di Fontane',89,26012),
('via delle Fontanelle',8,26012),
('via San pio X',158,26012),
('via Forcellini',78,26089),
('via Fornaci',76,26089),
('via Forte Marghera',43,26089),
('via Forzetta',3,26089),
('via Foscari',4,26089),
('via Foscarini',5,26089),
('via Foscolo',9,26089),
('via Fossagera',11,26089),
('vicolo Fossagera',12,26089),
('via Fosse Ardeatine',26,26089);

INSERT INTO Utente_Amministratore (Nome, Cognome, Email, Username, Password, Telefono_Interno) VALUES
    ('Anna','Rossi','annarossi@gmail.com','aaaa','aaaa','0423494847'),
    ('Mario','Verdi','marioverdi@gmail.com','bbbb','bbbb','0423454746'),
    ('Gianni','Grigio','giannigrigio@gmail.com','cccc','cccc','0425679876'),
    ('Francesca','Blu','francescablu@gmail.com','eeee','eeee','0422345678'),
    ('Sara','Scazzi','sarascazzi@gmail.com','ssss','sssss','0425679879');

INSERT INTO Utente_Base (Nome, Cognome, Email, Username, Password, Cellulare, Data_Nascita, Codice_Fiscale, Via, Civico, Comune) VALUES
    ('Sara','Bianchi','sarabianchi@gmail.com','jjjj','aaaa','3451234786','1976-12-08','SRBNCH76C12F330L','via Carlo Agnoletti',11,26086),
    ('Simone','Cataldo','simonecataldo@gmail.com','ffff','bbbb','3287856443','1906-11-04','CTLMNA06D11H501R','via Pomponio Amalteo',9,26086),
    ('Ferruccio','Tosi','ferrucciotosi@hotmail.it','gggg','cccc','3256787342','1908-10-30','TSOFRC08R30F839X','vicolo Fonderia',12,26012),
    ('Prospero','Puddu','prosperopuddu@live.com','zzzz','zzzz','3568754112','1910-03-20','PDDPSP10C28D612B','via Foscarini',5,26089),
	('Marilisa','Baudo','marilisabaudo@hotmail.it','iiii','iiii','3456675766','1902-12-31','BDAMLS02T71L736E','via F.lli Agosti',22,26086),
	('Helene','Bevilacqua','helenebevilacqua@live.it','pppp','pppp','3215432322','1906-10-05','BVLHLN06R45L736X','via Fogazzaro',98,26012),
	('Roberto','Digiovanni','robertodigiovanni@gmail.com','jjj','jjj','3447687998','1907-12-09','DGVRRT07T09G273F','via Pomponio Amalteo',9,26086),
	('Olmo','Monti','olmomonti@outlook.com','ttt','tttt','3338743112','1909-03-04','MNTLMO09C04F205F','via San pio X',158,26012);

INSERT INTO Tipologia (Nome, Descrizione) VALUES
('Animali','tutto sugli animali'),
('Automobili abbandonati',NULL),
('Barriere architettoniche',NULL),
('Buche/strade dissestate',NULL),
('Contenitori rifiuti',NULL),
('Furti/microcriminalita',NULL),
('Graffiti',NULL),
('Immigrati/nomadi',NULL),
('Inquinamento',NULL),
('Illuminazione pubblica',NULL),
('Abusivismo/Occupazione',NULL),
('Parcheggi/Divieti di sosta',NULL),
('Rifiuti',NULL),
('Segnaletica Stradale / Semafori',NULL),
('Situazioni di Degrado Sociale',NULL),
('Verde Pubblico',NULL),
('Altro',NULL);

INSERT INTO `segnalazione` (`Numero`, `Dataregistrazione`, `Tipo_S`, `Descrizione`, `Rating`, `Stato`, `Risposta`, `Tipologia`, `IDBase`, `IDAmministratore`, `Via`, `Civico`, `Comune`) VALUES
(1, '2019-04-25 08:02:17', 'DISFUNZIONE', 'ce un lampione non funzionante', 1, 'in lavorazione', NULL, 'Illuminazione pubblica', 1, NULL, 'via Adige', 23, 26086),
(2, '2019-05-01 08:02:17', 'SUGGERIMENTO', 'Sarebbe bello avere una rotonda al posto del semaforo', 1, 'risolto', 'è in progetto', 'Segnaletica Stradale / Semafori', 2, 3, 'via G. Amendola', 22, 26086),
(3, '2019-06-02 08:02:17', 'RECLAMO', 'ce qualcuno che abitualmente ruba le biciclette', 1, 'in lavorazione', NULL, 'Furti/microcriminalita', 3, 2, 'vicolo Fontane B', 9, 26012),
(4, '2019-06-03 08:02:17', 'DISFUNZIONE', 'Manca la segnaletica in tutta la strada', 3, 'risolto', 'Abbiamo ripristinato la strada', 'Segnaletica Stradale / Semafori', 4, 3, 'via Fossagera', 11, 26089),
(5, '2019-06-04 08:02:17', 'DISFUNZIONE', 'Il contenitore dell immondizia non è stato svuotato', 2, NULL, NULL, 'Contenitori rifiuti', 2, 1, 'via Alzaia', 8, 26086),
(6, '2019-06-05 08:02:17', 'RECLAMO', 'Manca la segnaletica in tutta la strada', 3, 'risolto', 'Abbiamo ripristinato la strada', 'Segnaletica Stradale / Semafori', 8, 3, 'via San pio X', 158, 26012),
(7, '2019-06-06 08:02:17', 'RECLAMO', 'Hanno fatto dei graffiti nel sottopasso nuovo', 2, 'risolto', 'è stato ricolorato', 'Graffiti', 8, 3, 'via San pio X', 158, 26012),
(8, '2019-06-07 08:02:17', 'RECLAMO', 'Non ce l aria condizionata in biblioteca', 2, 'in lavorazione', NULL, 'Altro', 8, 4, 'via San pio X', 158, 26012),
(9, '2019-06-08 08:02:17', 'SUGGERIMENTO', 'Vogliamo il palio quest anno', 1, 'risolto', 'è stato avvertito l\'assessore alla cultura', 'Altro', 2, 5, 'via G. Amendola', 22, 26086),
(10, '2019-06-09 08:02:17', 'RECLAMO', 'Bisogna tagliare l erba', 2, 'in lavorazione', 'sono stati allertati gli stradini', 'Verde Pubblico', 8, 2, 'via San pio X', 158, 26012),
(11, '2019-06-09 08:50:17', 'DISFUNZIONE', 'C\'è una buca enorme', 3, 'risolto', 'Abbiamo ripristinato la strada', 'Buche/strade dissestate', 7, 1, 'via Albona', 7, 26086),
(12, '2019-06-10 08:02:17', 'DISFUNZIONE', 'C\'è un auto ferma da una settimana ', 6, 'risolto', 'è stato avvisato il proprietario', 'Automobili abbandonati', 2, 2, 'via Altino', 76, 26086),
(13, '2019-06-11 08:02:17', 'RECLAMO', 'gli addetti ai lavori hanno abbandonato dei cartelli', 100, 'risolto', 'sono stati rimossi', 'Segnaletica Stradale / Semafori', 6, 5, 'vicolo Fonderia', 12, 26012),
(14, '2019-06-12 08:02:17', 'SUGGERIMENTO', 'ci sono dei barboni sotto al ponte non è possibile trovargli una sistemazione in parrocchia', 40, 'in lavorazione', NULL, 'Situazioni di Degrado Sociale', 1, 4, 'via Leon Battista Alberti', 5, 26086),
(15, '2019-06-13 08:02:17', 'DISFUNZIONE', 'non sono stati raccolti i rifiuti stamattina', 23, 'risolto', 'torneranno domani mattina', 'Rifiuti', 2, 2, 'via Amalfi', 65, 26086),
(16, '2019-06-13 08:30:17', 'SUGGERIMENTO', 'servirebbero dei lampioni sulla curva', 35, 'in lavorazione', NULL, 'Illuminazione pubblica', 4, 1, 'via Forte Marghera', 43, 26089),
(17, '2019-06-14 08:02:17', 'DISFUNZIONE', 'Il contenitore dell immondizia è stato danneggiato', 25, 'in lavorazione', NULL, 'Contenitori rifiuti', 2, 3, 'via Alzaia', 8, 26086),
(18, '2019-06-15 08:02:17', 'RECLAMO', 'ci sono troppi bisognini di cani sotto i portici', 16, 'in risolto', 'abbiamo messo dei cartelli e delle telecamere', 'Animali', 1, 5, 'via Amalfi', 65, 26086),
(19, '2019-06-16 08:02:17', 'RECLAMO', 'troppa gente parcheggia in doppia fila', 145, 'in lavorazione', NULL, 'Parcheggi/Divieti di sosta', 8, 2, 'via Flaminio', 7, 26012),
(20, '2019-06-17 08:02:17', 'SUGGERIMENTO', 'di sera la strada e\' troppo buia', 13, 'risolto', 'l\'anno prossimo installeranno dei lampioni', 'Illuminazione pubblica', 4, 3, 'via Fosse Ardeatine', 26, 26089),
(21, '2019-06-18 08:02:17', 'SUGGERIMENTO', 'sono disabile e non riesco ad entrare nell\'edificio', 177, 'risolto', 'verrà installata una rampa a breve', 'Barriere architettoniche', 3, 4, 'strada di Fontane', 89, 26012),
(22, '2019-06-19 08:02:17', 'RECLAMO', 'durante la notte fanno casino dietro la piazzetta', 14, 'in lavorazione', 'manderemo delle pattuglie a controllare', 'Furti/microcriminalita', 5, 1, 'via G. Amendola', 22, 26086),
(23, '2019-06-25 08:02:17', 'DISFUNZIONE', 'c\'è una tubatura delle fogne che puzza', 134, 'in lavorazione', NULL, 'Altro', 6, 5, 'via Foiana', 9, 26012);

INSERT INTO Reparto (ID, Nome) VALUES
('Uff001', 'Ambiente'),
('Uff002', 'Appalti'), 
('Uff003', 'Attività Produttive'), 
('Uff004', 'Biblioteca'), 
('Uff005', 'Corpo Polizia Locale'), 
('Uff006', 'Edilizia Privata'), 
('Uff007', 'Gabinetto Sindaco'), 
('Uff008', 'Manutenzioni'), 
('Uff009', 'Opere Pubbliche'), 
('Uff010', 'Programmazione e Controllo di Gestione'), 
('Uff011', 'Protezione Civile'), 
('Uff012', ' Risorse Finanziarie'), 
('Uff013', 'Risorse Tributarie e Patrimoniali'), 
('Uff014', 'Risorse Umane e Organizzazione'), 
('Uff015', 'Segreteria di Consiglio e Giunta'), 
('Uff016', 'Servizi Culturali'), 
('Uff017','Servizio Demografici ed Elettorali'), 
('Uff018', 'Acquedotto - Fognatura e Depurazione Acque reflue'), 
('Uff019', 'Servizi scolastici e sportivi'), 
('Uff020', 'Servizi Sociali'), 
('Uff021', 'Sistemi informativi'), 
('Uff022', 'Urbanistica');


INSERT INTO Soggetto_Competente (ID, Nome, Descrizione, Telefono, Email, Nome_Referente, Cognome_Referente, Servizio_Offerto, Note, P_IVA ) VALUES
('VI001', 'Polizia locale',NULL,'0978115544','polizia@gmail.com','Tiziano','Bruni',NULL,NULL,NULL),
('VI002','Vigili del fuoco',NULL,'0564231154','vigilifuoco@live.it','Jason','Born',NULL,NULL,NULL),
('EL001','Elettrolux','elettricista','0967432133','elettrolux@hotmail.com','Paolo','Ghione','cavetteria',NULL,'0987451187'),
('ID001','Idroplanet','idraulico','0564896754','idroplanet@yahoo.it','Giacomo','Sartori','idraulica',NULL,'78654320984'),
('ETR001','ETRASPA','Gestione rifiuti','0234578766','etraspa@gmail.com','Giovanni','Verdi',NULL,NULL,'2398652135');


INSERT INTO Coordinazione (IDReparto, NomeTipologia) VALUES
('Uff001','Verde Pubblico'),
('Uff001','Rifiuti'),
('Uff001','Contenitori rifiuti'),
('Uff001','Barriere architettoniche'),
('Uff004','Altro'),  
('Uff005','Immigrati/nomadi'),
('Uff005','Situazioni di Degrado Sociale'),
('Uff005','Parcheggi/Divieti di sosta'),
('Uff005','Abusivismo/Occupazione'),
('Uff005','Graffiti'),
('Uff005','Furti/microcriminalita'),
('Uff005','Animali' ),
('Uff005','Automobili abbandonati'),
('Uff008','Verde Pubblico'),
('Uff008','Segnaletica Stradale / Semafori'),
('Uff008','Inquinamento'),
('Uff008','Graffiti'),
('Uff008','Illuminazione pubblica'),
('Uff008','Barriere architettoniche'),
('Uff009','Buche/strade dissestate'), 
('Uff009','Barriere architettoniche'),
('Uff020','Situazioni di Degrado Sociale'),
('Uff020','Abusivismo/Occupazione'),
('Uff020','Immigrati/nomadi');


INSERT INTO Competenza (IDReparto, IDAmministratore) VALUES
('Uff001',2),
('Uff001',3),
('Uff001',4),
('Uff005',1),
('Uff005',2),
('Uff008',3),
('Uff003',3),
('Uff003',4),
('Uff018',4);


INSERT INTO Avviso (IDReparto, IDsoggettoc) VALUES
('Uff008','EL001'),
('Uff005','VI001'),
('Uff005','VI002'),
('Uff001','ETR001'),
('Uff018','ID001');


/*                             -le seguenti INSERT sono state usate per testare i trigger--

INSERT INTO Utente_Base (Nome, Cognome, Email, Username, Password, Cellulare, Data_Nascita, Codice_Fiscale, Via, Civico, Comune) VALUES
('Angelo','Nello','Angelonello@live.it','kkkk','llll','3253324321','1987-05-16','FNKDHI56M43F295G','via Flaminio',7,26012);

INSERT INTO Segnalazione (Tipo_S, Descrizione, Rating, Stato, Risposta,Tipologia,IDBase, IDAmministratore, Via, Civico, Comune) VALUES
('DISFUNZIONE','ce un lampione non funzionante',1,'in lavorazione',NULL, 'Illuminazione pubblica',5,NULL,'via Adige',23,26086 );

Segnalazione (Tipo_S, Descrizione, Rating, Stato, Risposta,Tipologia,IDBase, IDAmministratore, Via, Civico, Comune) VALUES
('DISFUNZIONE','ce un lampione non funzionante',1,'in lavorazione',NULL, 'Illuminazione pubblica',1,NULL,'via Adige',23,26086 ),
*/

/*                            -la seguente procedura sposta un amministratore in un altro reparto*/

DELIMITER &&
CREATE PROCEDURE CambiaPostazioneAmm (IN CodDipendente INT, IN NuovoReparto VARCHAR(15))
BEGIN
UPDATE Competenza
SET IDReparto = NuovoReparto
WHERE IDAmministratore = CodDipendente;
END&&
DELIMITER ;



/*--CALL CambiaPostazioneAmm(1,'Uff008');*/
	


/*--Funzione che ritorna il totale delle segnalazioni di uno specifico Comune*/

DELIMITER &&
CREATE FUNCTION TotaleSegnalazioni(Nomecomune VARCHAR(50))
RETURNS INT(5)
BEGIN
DECLARE Totale INT;
SELECT count(*) into Totale
FROM segnalazione s join comune c on s.comune=c.Cod_ISTAT
where c.Nome=Nomecomune;
return Totale;
END&&
DELIMITER ;

/*Funzione che ritorna il numero di segnalazioni risolte di uno specifico ufficio*/
DELIMITER &&
CREATE FUNCTION RisoltiperUfficio(NomeUfficio VARCHAR(50))
RETURNS INT(5)
BEGIN
DECLARE Risolti int;

select COUNT(*) into Risolti
		from segnalazione s join Utente_Amministratore U on s.IDAmministratore=u.ID join competenza c on u.ID=c.IDAmministratore join reparto r on r.ID=c.IDReparto
        where r.ID=NomeUfficio and s.Stato='risolto';
return Risolti;
END&&
DELIMITER ;

/*------Query 1, Confronta per ogni amministratore i casi gestiti e i casi risolti ordinandoli per il numero di casi risolti dal più grande al più piccolo. */

DROP VIEW IF EXISTS casigest;
CREATE VIEW CasiGest(g_Nome,g_Cognome,g_NumeroDiCasiGestiti) AS
SELECT u.`Nome`,u.`Cognome`,COUNT(u.`Nome`) AS Casi_Gestiti
FROM `utente_amministratore`AS u, `segnalazione` AS s
WHERE u.`ID`=s.`IDamministratore`
GROUP BY Nome;
DROP VIEW IF EXISTS casirisolti;
CREATE VIEW CasiRisolti(r_Nome,r_Cognome,r_NumeroDiCasiRisolti) AS
SELECT u.`Nome`,u.`Cognome`,COUNT(u.`Nome`) AS Casi_Risolti
FROM `utente_amministratore`AS u, `segnalazione` AS s
WHERE u.`ID`=s.`IDamministratore` AND s.`Stato`="risolto"
GROUP BY Nome;

SELECT g_Nome AS Nome, g_Cognome AS Cognome, g_NumeroDiCasiGestiti AS NumeroDiCasiGestiti, r_NumeroDiCasiRisolti AS NumeroDiCasiRisolti
FROM(SELECT * FROM casigest
LEFT JOIN casirisolti ON casigest.g_Nome = casirisolti.r_Nome
UNION 
SELECT * FROM casigest
RIGHT JOIN casirisolti ON casigest.g_Nome = casirisolti.r_Nome)AS P  
ORDER BY `NumeroDiCasiRisolti`  DESC;

/*-------Query 2, mostra il numero di segnalazioni effettuate dagli utenti base solo se hanno effettuato più 3 segnalazioni ordinandole per il numero di segnalazioni effettuate dal più grande al più piccolo*/

SELECT b.`ID`, b.`Nome`, b.`Cognome`,COUNT(b.ID) AS NumeroSegnalazioniEffettuate
FROM `utente_base` AS b
LEFT JOIN segnalazione ON b.ID = segnalazione.IDBase
GROUP BY b.nome  
HAVING NumeroSegnalazioniEffettuate>3
ORDER BY NumeroSegnalazioniEffettuate DESC;

/*--------Query 3, mostra il numero totale di segnalazioni effettuate per ogni comune ordinandole per il numero di segnalazioni effettuate dal più grande al più piccolo*/

SELECT `Cod_ISTAT`, `Nome`, `CAP`, COUNT(comune.Cod_ISTAT) AS NumeroSegnalazioniEffettuate
FROM `comune`
RIGHT JOIN segnalazione ON comune.Cod_ISTAT = segnalazione.Comune
GROUP BY comune.Cod_ISTAT
ORDER BY NumeroSegnalazioniEffettuate DESC;

/*--------------Query 4, trovare il numero di segnalazioni gestite e risolte dal reparto “Uff001” divise per utente e ordinarle per il numero di casi risolti */

DROP VIEW IF EXISTS utentirep001;
CREATE VIEW utentirep001(ID,Nome,Cognome) AS
SELECT
        utente_amministratore.ID,utente_amministratore.Nome,utente_amministratore.Cognome
    FROM
        `competenza`
    LEFT JOIN utente_amministratore ON competenza.IDAmministratore = utente_amministratore.ID
    WHERE
        competenza.IDReparto = "uff001";
DROP VIEW IF EXISTS risoltirep001;
CREATE VIEW risoltirep001(r_Nome,r_Cognome,r_CasiRisolti) AS
SELECT
    u.`Nome`,
    u.`Cognome`,
    COUNT(u.`Nome`) AS Casi_Risolti
FROM
    utentirep001 AS u,
`segnalazione` AS s
WHERE
    u.`ID` = s.`IDamministratore` AND s.`Stato` = "risolto"
GROUP BY
    Nome;
    
DROP VIEW IF EXISTS gestitirep001;
CREATE VIEW gestitirep001(g_Nome,g_Cognome,g_CasiGestiti) AS
SELECT
    u.`Nome`,
    u.`Cognome`,
    COUNT(u.`Nome`) AS Casi_Gestiti
FROM
    utentirep001 AS u,
`segnalazione` AS s
WHERE
    u.`ID` = s.`IDamministratore` 
GROUP BY
    Nome;
    
SELECT g_Nome AS Nome, g_Cognome AS Cognome, g_CasiGestiti AS NumeroDiCasiGestiti, r_CasiRisolti AS NumeroDiCasiRisolti
FROM(SELECT * FROM gestitirep001
LEFT JOIN risoltirep001 ON gestitirep001.g_Nome = risoltirep001.r_Nome
UNION 
SELECT * FROM gestitirep001
RIGHT JOIN risoltirep001 ON gestitirep001.g_Nome = risoltirep001.r_Nome)AS P
ORDER BY `NumeroDiCasiRisolti`  DESC;

/*------------Query 5, trovare tutte le segnalazioni risolte dal reparto “Uff005” */

DROP VIEW IF EXISTS utentirep005;
CREATE VIEW utentirep005(ID,Nome,Cognome) AS
SELECT
        utente_amministratore.ID,utente_amministratore.Nome,utente_amministratore.Cognome
    FROM
        `competenza`
    LEFT JOIN utente_amministratore ON competenza.IDAmministratore = utente_amministratore.ID
    WHERE
        competenza.IDReparto = "uff005";

SELECT * FROM segnalazione, utentirep005
WHERE segnalazione.IDAmministratore=utentirep005.ID AND segnalazione.Stato="risolto";

/*---------------Query 6, trovare il numero di segnalazioni gestite e risolte dal reparto “Uff003” divise per tipo e ordinarle per il numero di casi risolti */

DROP VIEW IF EXISTS utentirep003;
CREATE VIEW utentirep003(ID,Nome,Cognome) AS
SELECT utente_amministratore.ID,utente_amministratore.Nome,utente_amministratore.Cognome
FROM `competenza`
LEFT JOIN utente_amministratore ON competenza.IDAmministratore = utente_amministratore.ID
WHERE competenza.IDReparto = "uff003";


DROP VIEW IF EXISTS gestitirep003;

CREATE VIEW gestitirep003(g_Numero,g_Tipo,g_Stato,g_IdAmm) AS
SELECT s.numero,s.Tipo_S,s.Stato,s.IDAmministratore
FROM utentirep003 AS u,`segnalazione` AS s
WHERE u.`ID` = s.`IDamministratore` ;


DROP VIEW IF EXISTS tipogestitirep003;

CREATE VIEW tipogestitirep003(g_Tipo,Gestite) AS
SELECT `g_Tipo`,COUNT(g_Numero) FROM `gestitirep003` WHERE 1
GROUP BY g_Tipo;

DROP VIEW IF EXISTS tiporisoltirep003;

CREATE VIEW tiporisoltirep003(r_Tipo,Risolte) AS
SELECT `g_Tipo`,COUNT(g_Numero) 
FROM gestitirep003 
WHERE gestitirep003.g_Stato="Risolto"
GROUP BY g_Tipo;


SELECT g_Tipo AS Tipo,Gestite,Risolte FROM(
SELECT * FROM tipogestitirep003
LEFT JOIN tiporisoltirep003 ON tipogestitirep003.g_Tipo=tiporisoltirep003.r_Tipo
UNION
SELECT * FROM tipogestitirep003
RIGHT JOIN tiporisoltirep003 ON tipogestitirep003.g_Tipo=tiporisoltirep003.r_Tipo) AS C
ORDER BY Risolte DESC;