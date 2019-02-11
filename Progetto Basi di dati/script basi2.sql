DROP DATABASE Progetto;

CREATE DATABASE IF NOT EXISTS Progetto;

USE Progetto;

SET FOREIGN_KEY_CHECKS = 0;



CREATE TABLE IF NOT EXISTS  Utente_Amministratore (
    ID INT(11) AUTO_INCREMENT,
    Nome VARCHAR(50) NOT NULL,
    Cognome VARCHAR(50) NOT NULL,
    Email VARCHAR(50) NOT NULL,
    Username VARCHAR(15) NOT NULL,
    Password VARCHAR(20) NOT NULL,
    Telefono_Interno INT(14) NOT NULL,
    PRIMARY KEY(ID)
    ) ENGINE=INNODB;

    INSERT INTO Utente_Amministratore (Nome, Cognome, Email, Username, Password, Telefono_Interno) VALUES
    ('Anna','Rossi','annarossi@gmail.com','aaaa','aaaa',0423494847),
    ('Mario','Verdi','marioverdi@gmail.com','bbbb','bbbb',0423454746),
    ('Gianni','Grigio','giannigrigio@gmail.com','cccc','cccc',0425679876),
    ('Francesca','Blu','francescablu@gmail.com','eeee','eeee',0422345678);


CREATE TABLE IF NOT EXISTS  Utente_base (
    ID INT(11) AUTO_INCREMENT,
    Nome VARCHAR(50) NOT NULL,
    Cognome VARCHAR(50) NOT NULL,
    Email VARCHAR(50) NOT NULL,
    Username VARCHAR(15) NOT NULL,
    Password VARCHAR(20) NOT NULL,
    Cellulare INT(14) NOT NULL,
    Data_nascita DATE NOT NULL,
    Codice_Fiscale VARCHAR(16) NOT NULL,
    PRIMARY KEY(ID)
    ) ENGINE=INNODB;

    INSERT INTO Utente_Base (Nome, Cognome, Email, Username, Password, Cellulare, Data_Nascita, Codice_Fiscale) VALUES
    ('Sara','Bianchi','sarabianchi@gmail.com','jjjj','aaaa',3451234786,'1976-12-08','SRBNCH76C12F330L'),
    ('Aimone','Cataldo','aimonecataldo@gmail.com','ffff','bbbb',3287856443,'1906-11-04','CTLMNA06D11H501R'),
    ('Ferruccio','Tosi','ferrucciotosi@hotmail.it','gggg','cccc',3256787342,'1908-30-10','TSOFRC08R30F839X'),
    ('Prospero','Puddu','prosperopuddu@live.com','zzzz','zzzz',3568754112,'1910-28-03','PDDPSP10C28D612B');


CREATE TABLE IF NOT EXISTS  Segnalazione (
    Numero INT(11) AUTO_INCREMENT,
    Dataregistrazione timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Tipo_S VARCHAR(20) NOT NULL,
    Descrizione VARCHAR(600),
    Rating INT(11),
    Stato VARCHAR(20),
    Risposta VARCHAR(600),
    PRIMARY KEY(Numero)
    ) ENGINE=INNODB;


INSERT INTO Segnalazione (Tipo_S, Descrizione, Rating, Stato, Risposta) VALUES
('DISFUNSIONE','ce un lampione non funzionante',1,'in lavorazione',NULL),
('SUGGERIMENTO','Sarebbe bello avere una rotonda al posto del semaforo',1,NULL,NULL);



CREATE TABLE IF NOT EXISTS Tipologia (
    ID VARCHAR(10) PRIMARY KEY, 
    Nome VARCHAR(50) NOT NULL, 
    Descrizione VARCHAR(200)
    ) ENGINE=INNODB;


INSERT INTO Tipologia (ID, Nome, Descrizione) VALUES
('REC001','Animali','tutto sugli animali'),
('DIS001','Automobili abbandonati',NULL),
('SUG001','Barriere architettoniche',NULL),
('DIS002','Buche/strade dissestate',NULL),
('REC002','Contenitori rifiuti',NULL),
('REC003','Furti/microcriminalita',NULL),
('REC004','Graffiti',NULL),
('REC005','Immigrati/nomadi',NULL),
('REC006','Inquinamento',NULL),
('DIS003','Illuminazione pubblica',NULL),
('REC007','Abusivismo/Occupazione',NULL),
('DIS004','Parcheggi/Divieti di sosta',NULL),
('DIS005','Rifiuti',NULL),
('DIS006','Segnaletica Stradale / Semafori',NULL),
('REC008','Situazioni di Degrado Sociale',NULL),
('DIS007','Verde Pubblico',NULL);



CREATE TABLE IF NOT EXISTS Reparto (
    ID VARCHAR(15) PRIMARY KEY, 
    Nome VARCHAR(50) NOT NULL, 
    Descrizione VARCHAR(200) DEFAULT NULL
    ) ENGINE=INNODB;

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




CREATE TABLE IF NOT EXISTS Soggetto_Competente (
    ID VARCHAR(15) PRIMARY KEY,
    Nome VARCHAR(50) NOT NULL,
    Descrizione VARCHAR(200),
    Telefono INT(14) NOT NULL,
    Email VARCHAR(50),
    Nome_Referente VARCHAR(50),
    Cognome_Referente VARCHAR(50),
    Servizio_Offerto VARCHAR(50),
    Note VARCHAR(200),
    P_IVA VARCHAR(11)
    ) ENGINE=INNODB;

INSERT INTO Soggetto_Competente (ID, Nome, Descrizione, Telefono, Email, Nome_Referente, Cognome_Referente, Servizio_Offerto, Note, P_IVA ) VALUES
('VI001', 'Polizia locale',NULL,0978115544,'polizia@gmail.com','Tiziano','Bruni',NULL,NULL,NULL),
('VI002','Vigili del fuoco',NULL,0564231154,'vigilifuoco@live.it','Jason','Born',NULL,NULL,NULL),
('EL001','Elettrolux','elettricista',0967432133,'elettrolux@hotmail.com','Paolo','Ghione','cavetteria',NULL,'0987451187'),
('ID001','Idroplanet','idraulico',0564896754,'idroplanet@yahoo.it','Giacomo','Sartori','idraulica',NULL,'78654320984');



CREATE TABLE IF NOT EXISTS Coordinazione (
    IDTipologia VARCHAR(10),
    IDReparto VARCHAR(15),
    PRIMARY KEY(IDTipologia, IDReparto),
    FOREIGN KEY (IDTipologia)
        REFERENCES Tipologia (ID),
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
    IDAmministratore INT(11),
    PRIMARY KEY (IDReparto, IDAmministratore),
    FOREIGN KEY (IDReparto)
        REFERENCES Reparto (ID),
    FOREIGN KEY (IDAmministratore)
        REFERENCES Utente_Amministratore (ID)
    ) ENGINE=INNODB;




CREATE TABLE IF NOT EXISTS Regione (
    Cod_ISTAT INT(11) PRIMARY KEY,
    Nome VARCHAR(10) NOT NULL
    ) ENGINE=INNODB;

INSERT INTO Regione (Cod_ISTAT, Nome) VALUES
(5,'Veneto');




CREATE TABLE IF NOT EXISTS Provincia (
    Cod_ISTAT INT(11),
    Regione INT(11),
    Nome VARCHAR(10) NOT NULL,
    PRIMARY KEY(Cod_ISTAT, Regione),
    FOREIGN KEY (Regione)
        REFERENCES Regione (Cod_ISTAT)
    ) ENGINE=INNODB;


INSERT INTO Provincia (Cod_ISTAT, Regione, Nome) VALUES
(26086,5,'Treviso');




CREATE TABLE IF NOT EXISTS Comune (
    Cod_ISTAT INT(11),
    Provincia INT(11),
    Nome VARCHAR(20) NOT NULL,
    CAP INT(5) NOT NULL,
    PRIMARY KEY (Cod_ISTAT, Provincia),
    FOREIGN KEY (Provincia)
        REFERENCES Provincia (Cod_ISTAT)
    ) ENGINE=INNODB;

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




CREATE TABLE IF NOT EXISTS Indirizzo (
    Via VARCHAR(50),
    Civico SMALLINT,
    Comune INT(11),
    IDBase INT(11) DEFAULT NULL,
    Segnalazione INT(11) DEFAULT NULL,
    PRIMARY KEY (Via, Civico, Comune),
    FOREIGN KEY (Comune)
        REFERENCES Comune (Cod_ISTAT),
    FOREIGN KEY(IDBase)
        REFERENCES Utente_Base(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(Segnalazione)
        REFERENCES Segnalazione (Numero)
    ) ENGINE=INNODB;


INSERT INTO Indirizzo (Via, Civico, Comune, IDBase, Segnalazione ) VALUES
('via delle Acquette',1,26086,1,1),
('via Adamello',45,26086,NULL,NULL),
('via Adige',23,26086,NULL,NULL),
('via Carlo Agnoletti',11,26086,NULL,NULL),
('via F.lli Agosti',22,26086,NULL,NULL),
('via Leon Battista Alberti',5,26086,NULL,NULL),
('via Albona',7,26086,NULL,NULL),
('via Aleandro',78,26086,2,2),
('via Aleardo Aleardi',65,26086,NULL,NULL),
('via Alfieri',3,26086,NULL,NULL),
('via degli Alpini',8,26086,NULL,NULL),
('via Altino',76,26086,NULL,NULL),
('via Alzaia',8,26086,3,2),
('via Amalfi',65,26086,NULL,NULL),
('via Pomponio Amalteo',9,26086,NULL,NULL),
('via G. Amendola',22,26086,NULL,NULL),
('via Amundsen',11,26086,NULL,NULL),
('via A. Anassilide',8,26086,NULL,NULL),
('piazza Giannino Ancilotto',64,26086,NULL,NULL),
('via Flaminio',7,26012,NULL,NULL),
('via Fogazzaro',98,26012,4,2),
('via Foiana',9,26012,NULL,NULL),
('vicolo Fonderia',12,26012,NULL,NULL),
('via Fonderia',1,26012,NULL,NULL),
('vicolo Fontane A',8,26012,NULL,NULL),
('vicolo Fontane B',9,26012,NULL,NULL),
('strada di Fontane',89,26012,NULL,NULL),
('via delle Fontanelle',8,26012,NULL,NULL),
('via Forcellini',78,26089,NULL,NULL),
('via Fornaci',76,26089,NULL,NULL),
('via Forte Marghera',43,26089,NULL,NULL),
('via Forzetta',3,26089,NULL,NULL),
('via Foscari',NULL,26089,NULL,NULL),
('via Foscarini',NULL,26089,NULL,NULL),
('via Foscolo',NULL,26089,NULL,NULL),
('via Fossagera',NULL,26089,NULL,NULL),
('vicolo Fossagera',NULL,26089,NULL,NULL),
('via Fosse Ardeatine',NULL,26089,NULL,NULL);

SET FOREIGN_KEY_CHECKS = 1;