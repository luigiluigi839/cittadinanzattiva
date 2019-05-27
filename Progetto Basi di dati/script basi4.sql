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



/*
DELIMITER $$
CREATE OR REPLACE TRIGGER AumentaRating BEFORE INSERT ON Segnalazione
FOR EACH ROW 
BEGIN
    DECLARE NuovoRating INT;
    DECLARE Tiposegnalazione VARCHAR(20);
    DECLARE DescrSegnalazione VARCHAR(600);
    DECLARE TipologiaSegnalazione VARCHAR(50);
    declare ViaS VARCHAR(50);
    declare CivicoS INT; 
    declare ComuneS INT;


    select Tipo_S, Descrizione, Tipologia, Via, Civico, Comune
    FROM segnalazione
    INTO Tiposegnalazione, DescrSegnalazione, TipologiaSegnalazione, ViaS, CivicoS, ComuneS;

    IF (Tiposegnalazione=NEW.Tipo_S and DescrSegnalazione=NEW.Descrizione and TipologiaSegnalazione=NEW.Tipologia and ViaS=NEW.Via and CivicoS=NEW.Civico and ComuneS=NEW.Comune)
    THEN set OLD.Rating=Rating+1;


    END IF;
END $$
DELIMITER ;

DELIMITER &&
CREATE PROCEDURE CambiaPostazioneAmm (IN CodDipendente INT, IN NuovoReparto VARCHAR(15))
BEGIN
UPDATE Competenza
SET IDReparto = NuovoReparto
WHERE IDAmministratore = CodDipendente;
END &&
DELIMITER ;
*/

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
    ('Francesca','Blu','francescablu@gmail.com','eeee','eeee','0422345678');

INSERT INTO Utente_Base (Nome, Cognome, Email, Username, Password, Cellulare, Data_Nascita, Codice_Fiscale, Via, Civico, Comune) VALUES
    ('Sara','Bianchi','sarabianchi@gmail.com','jjjj','aaaa','3451234786','1976-12-08','SRBNCH76C12F330L','via Carlo Agnoletti',11,26086),
    ('Simone','Cataldo','simonecataldo@gmail.com','ffff','bbbb','3287856443','1906-11-04','CTLMNA06D11H501R','via Pomponio Amalteo',9,26086),
    ('Ferruccio','Tosi','ferrucciotosi@hotmail.it','gggg','cccc','3256787342','1908-10-30','TSOFRC08R30F839X','vicolo Fonderia',12,26012),
    ('Prospero','Puddu','prosperopuddu@live.com','zzzz','zzzz','3568754112','1910-03-20','PDDPSP10C28D612B','via Foscarini',5,26089);

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
('Atro',NULL);

INSERT INTO Segnalazione (Tipo_S, Descrizione, Rating, Stato, Risposta,Tipologia,IDBase, IDAmministratore, Via, Civico, Comune) VALUES
('DISFUNZIONE','ce un lampione non funzionante',1,'in lavorazione',NULL, 'Illuminazione pubblica',1,NULL,'via Adige',23,26086 ),
('SUGGERIMENTO','Sarebbe bello avere una rotonda al posto del semaforo',1,NULL,NULL,'Segnaletica Stradale / Semafori',2,3,'via G. Amendola',22,26086),
('RECLAMO','ce qualcuno che abitualmente ruba le biciclette',1,'in lavorazione',NULL,'Furti/microcriminalita',3,2,'vicolo Fontane B',9,26012),
('DISFUNZIONE','Manca la segnaletica in tutta la strada',3,'risolto','Abbiamo ripristinato la strada','Segnaletica Stradale / Semafori',4,1,'via Fossagera',11,26089),
('DISFUNZIONE','Manca la segnaletica1 in tutta la strada',3,'risolto','Abbiamo ripristinato la strada','Segnaletica Stradale / Semafori',4,2,'via Fossagera',11,26089),
('DISFUNZIONE','Manca la segnaletica2 in tutta la strada',3,'risolto','Abbiamo ripristinato la strada','Segnaletica Stradale / Semafori',4,3,'via Fossagera',11,26089),
('DISFUNZIONE','Manca la segnaletica3 in tutta la strada',3,'risolto','Abbiamo ripristinato la strada','Segnaletica Stradale / Semafori',4,3,'via Fossagera',11,26089),
('DISFUNZIONE','Il contenitore dell immondizia non è stato svuotato',2,NULL,NULL,'Contenitori rifiuti',2,1,'via Alzaia',8,26086),
('DISFUNZIONE','ce un lampione non funzionante2',1,'in lavorazione',NULL, 'Illuminazione pubblica',1,1,'via Adige',23,26086 ),
('DISFUNZIONE','ce un lampione non funzionante3',1,'in lavorazione',NULL, 'Illuminazione pubblica',1,2,'via Adige',23,26086 ),
('DISFUNZIONE','ce un lampione non funzionante4',1,'in lavorazione',NULL, 'Illuminazione pubblica',1,3,'via Adige',23,26086 ),
('DISFUNZIONE','ce un lampione non funzionante5',1,'in lavorazione',NULL, 'Illuminazione pubblica',1,3,'via Adige',23,26086 ),
('DISFUNZIONE','ce un lampione non funzionante6',1,'in lavorazione',NULL, 'Illuminazione pubblica',1,2,'via Adige',23,26086 ),
('DISFUNZIONE','ce un lampione non funzionante7',1,'in lavorazione',NULL, 'Illuminazione pubblica',1,3,'via Adige',23,26086 );

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
('Uff018',4);


INSERT INTO Avviso (IDReparto, IDsoggettoc) VALUES
('Uff008','EL001'),
('Uff005','VI001'),
('Uff005','VI002'),
('Uff001','ETR001'),
('Uff018','ID001');

INSERT INTO Utente_Base (Nome, Cognome, Email, Username, Password, Cellulare, Data_Nascita, Codice_Fiscale, Via, Civico, Comune) VALUES
('Angelo','Nello','Angelonello@live.it','kkkk','llll','3253324321','1987-05-16','FNKDHI56M43F295G','via Flaminio',7,26012);

/*INSERT INTO Segnalazione (Tipo_S, Descrizione, Rating, Stato, Risposta,Tipologia,IDBase, IDAmministratore, Via, Civico, Comune) VALUES
('DISFUNZIONE','ce un lampione non funzionante',1,'in lavorazione',NULL, 'Illuminazione pubblica',5,NULL,'via Adige',23,26086 );

Segnalazione (Tipo_S, Descrizione, Rating, Stato, Risposta,Tipologia,IDBase, IDAmministratore, Via, Civico, Comune) VALUES
('DISFUNZIONE','ce un lampione non funzionante',1,'in lavorazione',NULL, 'Illuminazione pubblica',1,NULL,'via Adige',23,26086 ),


DELIMITER &&
CREATE PROCEDURE CambiaPostazioneAmm (IN CodDipendente INT, IN NuovoReparto VARCHAR(15))
BEGIN
UPDATE Competenza
SET IDReparto = NuovoReparto
WHERE IDAmministratore = CodDipendente;
END&&
DELIMITER ;

CALL CambiaPostazioneDip(1,'Uff008');*/


/*Query 1, Confronta per ogni amministratore i casi gestiti e i casi risolti ordinandoli per il numero di casi risolti dal più grande al più piccolo. */

CREATE VIEW CasiGest(g_Nome,g_Cognome,g_NumeroDiCasiGestiti) AS
SELECT u.`Nome`,u.`Cognome`,COUNT(u.`Nome`) AS Casi_Gestiti
FROM `utente_amministratore`AS u, `segnalazione` AS s
WHERE u.`ID`=s.`IDamministratore`
GROUP BY Nome;

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
ORDER BY `NumeroDiCasiRisolti`  DESC

/*Query 2, mostra il numero di segnalazioni effettuate dagli utenti base solo se hanno effettuato più 3 segnalazioni ordinandole per il numero di segnalazioni effettuate dal più grande al più piccolo*/

SELECT b.`ID`, b.`Nome`, b.`Cognome`,COUNT(b.ID) AS NumeroSegnalazioniEffettuate
FROM `utente_base` AS b
LEFT JOIN segnalazione ON b.ID = segnalazione.IDBase
GROUP BY b.nome  
HAVING NumeroSegnalazioniEffettuate>3
ORDER BY NumeroSegnalazioniEffettuate DESC

/*Query 3, mostra il numero totale di segnalazioni effettuate per ogni comune ordinandole per il numero di segnalazioni effettuate dal più grande al più piccolo*/

SELECT `Cod_ISTAT`, `Nome`, `CAP`, COUNT(comune.Cod_ISTAT) AS NumeroSegnalazioniEffettuate
FROM `comune`
RIGHT JOIN segnalazione ON comune.Cod_ISTAT = segnalazione.Comune
GROUP BY comune.Cod_ISTAT
ORDER BY NumeroSegnalazioniEffettuate DESC

/*Query 4*/

