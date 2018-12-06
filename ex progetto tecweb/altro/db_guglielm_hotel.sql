CREATE TABLE amministratori(
    nome varchar(15) primary key,
    email varchar(50) UNIQUE not null,
    password varchar(50) not null
);

CREATE TABLE appartamenti(
    idStanza varchar(4) primary key,
    nomeStanza varchar(100) not null
);
CREATE TABLE prenotazioni(
    id int unsigned auto_increment primary key,
    nomeUtente varchar(15) not null,
    email varchar(50) not null,
    data_arrivo date,
    data_partenza date,
    nStanza tinyint unsigned,
    tipoStanza varchar(4),
    FOREIGN KEY (tipoStanza) REFERENCES appartamenti(idStanza) ON DELETE CASCADE
);

CREATE TABLE prezzi_disponibilita(
    idStanza varchar(4),
    da date,
    a date,
    costoGiornaliero int unsigned,
    maxStanze tinyint unsigned,
    primary key(idStanza,da,a),
    FOREIGN KEY (idStanza) REFERENCES appartamenti(idStanza) ON DELETE CASCADE
);
/* VECCHIO TRIGGER NON USARE


CREATE TRIGGER `update_nStanza` BEFORE INSERT ON `prenotazioni` FOR EACH ROW BEGIN
DECLARE contati tinyint;
SELECT COUNT(*) INTO contati FROM prenotazioni WHERE tipoStanza=NEW.tipoStanza;
SET NEW.nStanza=contati+1;
END
*/

CREATE TRIGGER `update_nStanza` BEFORE INSERT ON `prenotazioni` FOR EACH ROW BEGIN
DECLARE contati tinyint;
SELECT COUNT(*) INTO contati FROM prenotazioni
    WHERE ((NEW.data_arrivo BETWEEN data_arrivo AND data_partenza)
    OR (data_arrivo BETWEEN NEW.data_arrivo AND NEW.data_partenza))
    AND tipoStanza = NEW.tipoStanza;
SET NEW.nStanza=contati+1;
END


INSERT INTO `amministratori` (`nome`, `email`, `password`) VALUES
('Enrico', 'e.sanguin@gmail.com', '743c3e86bedbe9772dadf2e6ea374da9');

INSERT INTO `appartamenti` (`idStanza`, `nomeStanza`) VALUES
('A', 'Singola Classica'),
('B', 'Doppia Classica'),
('C', 'Superior'),
('D', 'Suite');

INSERT INTO `prezzi_disponibilita` (`idStanza`, `da`, `a`, `costoGiornaliero`, `maxStanze`) VALUES
('A','2018-06-18','2019-06-15','50','4'),
('B','2018-07-16','2019-12-31','64','3'),
('C','2018-10-12','2018-12-12','85','3'),
('D','2018-12-12','2019-12-01','104','1');

INSERT INTO `prenotazioni` (`nomeUtente`, `email`, `data_arrivo`, `data_partenza`, `tipoStanza`) VALUES
('Carlo', 'carlo@gmail.com', '2018-06-20', '2018-06-30', 'A'),
('Giuseppe', 'giuseppe@gmail.com', '2018-07-20', '2018-07-25', 'B');