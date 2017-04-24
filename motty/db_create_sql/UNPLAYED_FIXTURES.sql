CREATE DATABASE  IF NOT EXISTS `MOTSON` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `MOTSON`;
-- MySQL dump 10.13  Distrib 5.7.12, for osx10.9 (x86_64)
--
-- Host: localhost    Database: FOOTBALL_PREDICT
-- ------------------------------------------------------
-- Server version	5.7.16

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `UNPLAYED_FIXTURES`
--

DROP TABLE IF EXISTS `UNPLAYED_FIXTURES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UNPLAYED_FIXTURES` (
  `SEASON` int(11) NOT NULL,
  `DIVISION` varchar(45) NOT NULL,
  `HOME_TEAM` varchar(45) NOT NULL,
  `AWAY_TEAM` varchar(45) NOT NULL,
  `FIXTURE_DATE` date NOT NULL,
  `ODDS_HOME` float DEFAULT NULL,
  `ODDS_DRAW` float DEFAULT NULL,
  `ODDS_AWAY` float DEFAULT NULL,
  PRIMARY KEY (`SEASON`,`DIVISION`,`HOME_TEAM`,`AWAY_TEAM`,`FIXTURE_DATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UNPLAYED_FIXTURES`
--

LOCK TABLES `UNPLAYED_FIXTURES` WRITE;
/*!40000 ALTER TABLE `UNPLAYED_FIXTURES` DISABLE KEYS */;
INSERT  IGNORE INTO `UNPLAYED_FIXTURES` (`SEASON`, `DIVISION`, `HOME_TEAM`, `AWAY_TEAM`, `FIXTURE_DATE`, `ODDS_HOME`, `ODDS_DRAW`, `ODDS_AWAY`) VALUES (16,'B1','Anderlecht','St Truiden','2017-01-22',0.26,5.75,11.5),(16,'B1','Club Brugge','Waasland-Beveren','2017-01-25',0.2,6,11),(16,'B1','Eupen','Genk','2017-01-21',2.46,2.6,1.17),(16,'B1','Genk','Kortrijk','2017-01-24',0.5,3.2,5.5),(16,'B1','Gent','Charleroi','2017-01-20',0.58,3.2,5.6),(16,'B1','Kortrijk','Waregem','2017-01-21',1.92,2.5,1.51),(16,'B1','Lokeren','Gent','2017-01-25',2.5,2.65,1),(16,'B1','Mechelen','Westerlo','2017-01-22',0.45,3.95,7),(16,'B1','Mouscron','Lokeren','2017-01-21',1.98,2.45,1.5),(16,'B1','Oostende','Charleroi','2017-01-24',1.1,2.7,2.2),(16,'B1','St Truiden','Mechelen','2017-01-25',1.4,2.5,1.8),(16,'B1','Standard','Club Brugge','2017-01-22',1.88,2.55,1.55),(16,'B1','Waasland-Beveren','Oostende','2017-01-21',2.3,2.55,1.27),(16,'B1','Waregem','Mouscron','2017-01-24',0.45,3.4,6),(16,'B1','Westerlo','Anderlecht','2017-01-25',6.5,3.6,0.4),(16,'D1','Augsburg','Hoffenheim','2017-01-21',1.87,2.55,1.61),(16,'D1','Augsburg','Werder Bremen','2017-02-05',1.2,2.5,2.75),(16,'D1','Bayern Munich','Schalke 04','2017-02-04',0.23,6.3,14.5),(16,'D1','Darmstadt','FC Koln','2017-01-28',2.8,2.4,1.2),(16,'D1','Darmstadt','M\'gladbach','2017-01-21',3.75,2.75,0.91),(16,'D1','Dortmund','RB Leipzig','2017-02-04',0.85,2.95,4.1),(16,'D1','Ein Frankfurt','Darmstadt','2017-02-05',0.57,3.45,5.5),(16,'D1','FC Koln','Wolfsburg','2017-02-04',1.55,2.4,2.04),(16,'D1','Freiburg','Bayern Munich','2017-01-20',16.5,6.6,0.22),(16,'D1','Freiburg','Hertha','2017-01-29',1.6,2.4,2),(16,'D1','Hamburg','Leverkusen','2017-02-03',2.5,2.5,1.4),(16,'D1','Hertha','Ingolstadt','2017-02-04',1,2.5,3.35),(16,'D1','Hoffenheim','Mainz','2017-02-04',1.05,2.7,2.88),(16,'D1','Ingolstadt','Hamburg','2017-01-28',1.2,2.4,2.8),(16,'D1','Leverkusen','Hertha','2017-01-22',0.75,3,4.5),(16,'D1','Leverkusen','M\'gladbach','2017-01-28',1.06,2.75,2.82),(16,'D1','M\'gladbach','Freiburg','2017-02-04',0.85,2.8,3.75),(16,'D1','Mainz','Dortmund','2017-01-29',4.4,3.6,0.68),(16,'D1','Mainz','FC Koln','2017-01-22',1.52,2.48,2.02),(16,'D1','RB Leipzig','Ein Frankfurt','2017-01-21',0.75,3,4.75),(16,'D1','RB Leipzig','Hoffenheim','2017-01-28',0.95,2.75,3.4),(16,'D1','Schalke 04','Ein Frankfurt','2017-01-27',1,2.75,3.05),(16,'D1','Schalke 04','Ingolstadt','2017-01-21',0.83,3,4),(16,'D1','Werder Bremen','Bayern Munich','2017-01-28',18,7.2,0.22),(16,'D1','Werder Bremen','Dortmund','2017-01-21',6,3.95,0.5),(16,'D1','Wolfsburg','Augsburg','2017-01-28',1.05,2.6,3.2),(16,'D1','Wolfsburg','Hamburg','2017-01-21',0.95,2.68,3.6),(16,'D2','Erzgebirge Aue','Heidenheim','2017-01-28',2,2.3,1.57),(16,'D2','Fortuna Dusseldorf','Sandhausen','2017-01-27',1.4,2.4,2.3),(16,'D2','Hannover','Kaiserslautern','2017-01-30',0.75,2.8,4.5),(16,'D2','Karlsruhe','Bielefeld','2017-01-29',1.4,2.3,2.3),(16,'D2','Munich 1860','Greuther Furth','2017-01-27',1.4,2.4,2.3),(16,'D2','Nurnberg','Dresden','2017-01-29',1.35,2.6,2.3),(16,'D2','St Pauli','Stuttgart','2017-01-29',2.84,2.6,1.07),(16,'D2','Union Berlin','Bochum','2017-01-27',0.88,2.85,3.5),(16,'D2','Wurzburger Kickers','Braunschweig','2017-01-28',1.77,2.25,1.85),(16,'E0','Arsenal','Burnley','2017-01-22',0.22,6.5,18),(16,'E0','Bournemouth','Watford','2017-01-21',0.91,2.7,3.6),(16,'E0','Burnley','Southampton','2017-01-14',2.75,2.4,1.22),(16,'E0','Chelsea','Hull','2017-01-22',0.2,6.8,21),(16,'E0','Crystal Palace','Everton','2017-01-21',2.2,2.4,1.45),(16,'E0','Everton','Man City','2017-01-15',3.55,2.84,0.91),(16,'E0','Hull','Bournemouth','2017-01-14',2.15,2.4,1.5),(16,'E0','Leicester','Chelsea','2017-01-14',5.5,3.2,0.64),(16,'E0','Liverpool','Swansea','2017-01-21',0.22,6.5,19),(16,'E0','Man City','Tottenham','2017-01-21',1.1,2.65,3.25),(16,'E0','Man United','Liverpool','2017-01-15',1.2,2.5,2.65),(16,'E0','Middlesbrough','West Ham','2017-01-21',1.62,2.3,2),(16,'E0','Southampton','Leicester','2017-01-22',1,2.6,3.55),(16,'E0','Stoke','Man United','2017-01-21',5.25,3,0.67),(16,'E0','Sunderland','Stoke','2017-01-14',2.05,2.4,1.6),(16,'E0','Swansea','Arsenal','2017-01-14',7.2,4,0.47),(16,'E0','Tottenham','West Brom','2017-01-14',0.36,4.5,11),(16,'E0','Watford','Middlesbrough','2017-01-14',1.6,2.25,2.25),(16,'E0','West Brom','Sunderland','2017-01-21',0.91,2.6,3.8),(16,'E0','West Ham','Crystal Palace','2017-01-14',1.23,2.55,2.5),(16,'E1','Aston Villa','Wolves','2017-05-06',1.62,2.3,1.5),(16,'E1','Birmingham','Nott\'m Forest','2017-01-14',1.17,2.5,2.65),(16,'E1','Brentford','Newcastle','2017-01-16',3.25,2.8,0.95),(16,'E1','Bristol City','Cardiff','2017-01-14',1.3,2.4,2.6),(16,'E1','Burton','Wigan','2017-01-14',1.32,2.3,2.5),(16,'E1','Fulham','Barnsley','2017-01-14',0.71,3.2,4.2),(16,'E1','Ipswich','Blackburn','2017-01-14',1.1,2.4,3.25),(16,'E1','Leeds','Derby','2017-01-13',1.7,2.3,2.06),(16,'E1','Preston','Brighton','2017-01-14',2.85,2.5,1.15),(16,'E1','Reading','QPR','2017-01-12',0.83,2.75,3.9),(16,'E1','Rotherham','Norwich','2017-01-14',4,3,0.75),(16,'E1','Sheffield Weds','Huddersfield','2017-01-14',1.3,2.5,2.65),(16,'E1','Wolves','Aston Villa','2017-01-14',1.6,2.3,2.05),(16,'E2','AFC Wimbledon','Oxford','2017-01-14',0.04,2.3,0.04),(16,'E2','Bolton','Swindon','2017-01-14',0.06,2.4,1.1),(16,'E2','Bradford','Chesterfield','2017-01-07',0.6,3.25,5.5),(16,'E2','Bristol Rvs','Northampton','2017-01-07',1,2.7,2.92),(16,'E2','Bury','Peterboro','2017-01-14',0.33,2.3,0.04),(16,'E2','Charlton','Millwall','2017-01-14',0.04,2.3,0.04),(16,'E2','Chesterfield','Coventry','2017-01-14',0.04,2.3,0.04),(16,'E2','Fleetwood Town','Bristol Rvs','2017-01-14',0.57,2.3,0.67),(16,'E2','Northampton','Scunthorpe','2017-01-14',0.04,2.3,0.04),(16,'E2','Oldham','Gillingham','2017-01-14',0.25,2.3,0.04),(16,'E2','Port Vale','Milton Keynes Dons','2017-01-14',0.25,2.3,0.25),(16,'E2','Scunthorpe','Bury','2017-01-07',0.53,3.5,6),(16,'E2','Shrewsbury','Bradford','2017-01-14',0.04,2.3,0.03),(16,'E2','Southend','Rochdale','2017-01-14',0.67,2.3,0.8),(16,'E2','Southend','Sheffield United','2017-01-07',3.2,2.6,0.95),(16,'E2','Swindon','Shrewsbury','2017-01-07',1.2,2.5,2.5),(16,'E2','Walsall','Sheffield United','2017-01-14',0.91,2.3,0.36),(16,'E3','Colchester','Carlisle','2017-01-07',1.6,2.7,1.75),(16,'E3','Doncaster','Portsmouth','2017-01-05',2,2.3,1.75),(16,'E3','Hartlepool','Grimsby','2017-01-07',1.91,2.7,1.55),(16,'E3','Leyton Orient','Barnet','2017-01-07',1.5,2.6,2.1),(16,'E3','Mansfield','Crewe','2017-01-07',1.1,2.46,2.96),(16,'E3','Morecambe','Notts County','2017-01-07',1.65,2.6,1.75),(16,'E3','Stevenage','Newport County','2017-01-07',1.2,2.6,2.68),(16,'EC','Aldershot','Southport','2017-01-07',0.75,3,4.1),(16,'EC','Barrow','Southport','2017-01-10',0.02,2.6,2),(16,'EC','Braintree Town','Chester','2017-01-07',1.6,2.45,1.88),(16,'EC','Braintree Town','Sutton','2017-01-10',0.02,2.3,0.02),(16,'EC','Bromley','Forest Green','2017-01-07',3.1,2.8,0.97),(16,'EC','Dover Athletic','York','2017-01-07',0.62,3.35,5.6),(16,'EC','Eastleigh','Forest Green','2017-01-10',0.02,2.3,0.02),(16,'EC','Guiseley','Maidstone','2017-01-07',1.11,2.6,2.66),(16,'EC','Macclesfield','Dover Athletic','2017-01-10',0.02,2.3,0.02),(16,'EC','North Ferriby','Dag and Red','2017-01-07',4.75,3.1,0.67),(16,'EC','Solihull','Gateshead','2017-01-07',2.1,2.6,1.38),(16,'EC','Torquay','Boreham Wood','2017-01-07',1.62,2.4,1.88),(16,'EC','Wrexham','Woking','2017-01-07',1.01,2.75,2.82),(16,'F1','Angers','Bordeaux','2017-01-14',1.9,2.1,1.86),(16,'F1','Angers','Metz','2017-01-28',1.05,2.2,3.55),(16,'F1','Bastia','Caen','2017-01-28',1.17,2,3.4),(16,'F1','Bastia','Nice','2017-01-21',2.15,2.4,1.44),(16,'F1','Bordeaux','Toulouse','2017-01-21',1.1,2.5,2.86),(16,'F1','Caen','Lyon','2017-01-15',3.33,2.7,1),(16,'F1','Caen','Nancy','2017-01-21',1.3,2.34,2.7),(16,'F1','Dijon','Lille','2017-01-21',2,2.3,1.6),(16,'F1','Guingamp','Rennes','2017-01-21',1.4,2.25,2.6),(16,'F1','Lille','St Etienne','2017-01-13',1.4,2.1,2.7),(16,'F1','Lorient','Dijon','2017-01-28',0.97,2.5,3.4),(16,'F1','Lorient','Guingamp','2017-01-14',1.65,2.2,2.1),(16,'F1','Lyon','Lille','2017-01-28',0.36,4.2,9.5),(16,'F1','Lyon','Marseille','2017-01-21',0.9,2.52,3.95),(16,'F1','Marseille','Monaco','2017-01-15',2.1,2.52,1.45),(16,'F1','Marseille','Montpellier','2017-01-28',0.92,2.6,3.5),(16,'F1','Metz','Montpellier','2017-01-21',1.55,2.15,2.22),(16,'F1','Monaco','Lorient','2017-01-21',0.52,3.75,6.5),(16,'F1','Montpellier','Dijon','2017-01-14',0.75,2.8,4.4),(16,'F1','Nancy','Bastia','2017-01-14',1,2.3,3.6),(16,'F1','Nancy','Bordeaux','2017-01-28',2.3,2,1.6),(16,'F1','Nantes','Caen','2017-01-18',0.97,2.42,3.55),(16,'F1','Nantes','Paris SG','2017-01-21',10,4,0.38),(16,'F1','Nice','Guingamp','2017-01-28',0.77,2.8,4.2),(16,'F1','Nice','Metz','2017-01-15',0.55,3.45,6.8),(16,'F1','Paris SG','Monaco','2017-01-28',0.65,3.15,4.8),(16,'F1','Rennes','Nantes','2017-01-28',0.55,3,6.9),(16,'F1','Rennes','Paris SG','2017-01-14',5.8,3.3,0.57),(16,'F1','St Etienne','Angers','2017-01-21',0.85,2.45,4.3),(16,'F1','Toulouse','Nantes','2017-01-14',1.15,2.3,3.2),(16,'F1','Toulouse','St Etienne','2017-01-28',1.55,1.96,2.44),(16,'G1','Panionios','Giannina','2017-01-05',0.85,2.42,4.5),(16,'G1','Platanias','Panathinaikos','2017-01-05',4,2.4,1),(16,'I1','Cagliari','Genoa','2017-01-15',1.72,2.45,1.9),(16,'I1','Chievo','Atalanta','2017-01-08',1.88,2.16,1.9),(16,'I1','Crotone','Bologna','2017-01-14',2.1,2.25,1.65),(16,'I1','Empoli','Palermo','2017-01-07',1.03,2.4,3.55),(16,'I1','Fiorentina','Juventus','2017-01-15',4.4,2.65,0.91),(16,'I1','Genoa','Roma','2017-01-08',3.35,2.8,0.92),(16,'I1','Inter','Chievo','2017-01-14',0.5,3.6,7.2),(16,'I1','Juventus','Bologna','2017-01-08',0.21,6.5,20),(16,'I1','Lazio','Atalanta','2017-01-15',0.86,2.72,3.8),(16,'I1','Lazio','Crotone','2017-01-08',0.3,5.3,14),(16,'I1','Milan','Cagliari','2017-01-08',0.44,4,8.1),(16,'I1','Napoli','Pescara','2017-01-15',0.17,8.5,25),(16,'I1','Napoli','Sampdoria','2017-01-07',0.3,5.5,12),(16,'I1','Pescara','Fiorentina','2017-01-08',3.4,2.75,0.92),(16,'I1','Sampdoria','Empoli','2017-01-15',0.9,2.7,4),(16,'I1','Sassuolo','Palermo','2017-01-15',0.7,3,5.3),(16,'I1','Sassuolo','Torino','2017-01-08',1.86,2.5,1.72),(16,'I1','Torino','Milan','2017-01-16',1.61,2.4,2.04),(16,'I1','Udinese','Inter','2017-01-08',3.15,2.6,1.02),(16,'I1','Udinese','Roma','2017-01-15',4.3,2.75,0.83),(16,'I2','Ascoli','Pro Vercelli','2017-01-22',1.25,2.1,2.7),(16,'I2','Brescia','Avellino','2017-01-21',1.2,2.2,2.8),(16,'I2','Carpi','Vicenza','2017-01-21',0.75,2.4,5),(16,'I2','Cittadella','Bari','2017-01-21',1.4,2.2,2.25),(16,'I2','Latina','Verona','2017-01-21',2.5,2.25,1.3),(16,'I2','Perugia','Cesena','2017-01-23',1.1,2.2,3),(16,'I2','Pisa','Ternana','2017-01-21',1.2,2,3.2),(16,'I2','Salernitana','Spezia','2017-01-22',1.3,2.1,2.5),(16,'I2','Spal','Benevento','2017-01-21',1.1,2.3,3),(16,'I2','Trapani','Novara','2017-01-21',1.55,2.1,2.2),(16,'I2','Virtus Entella','Frosinone','2017-01-21',1.5,2.1,2.12),(16,'N1','Go Ahead Eagles','AZ Alkmaar','2017-01-13',3.6,3,0.76),(16,'N1','Heerenveen','Den Haag','2017-01-14',0.59,3.33,5),(16,'N1','Heracles','Groningen','2017-01-14',1.4,2.45,2.1),(16,'N1','PSV Eindhoven','Excelsior','2017-01-14',0.17,7,18),(16,'N1','Roda','Feyenoord','2017-01-15',7,4,0.4),(16,'N1','Sparta Rotterdam','Utrecht','2017-01-14',2.12,2.55,1.25),(16,'N1','Vitesse','Twente','2017-01-15',1,1.1,1.55),(16,'N1','Willem II','Nijmegen','2017-01-15',0.95,2.5,3.2),(16,'N1','Zwolle','Ajax','2017-01-15',7,3.75,0.5),(16,'P1','Benfica','Guimaraes','2017-01-07',0.62,0.95,3.33),(16,'P1','Boavista','Setubal','2017-01-08',1.5,2.15,2.4),(16,'P1','Estoril','Maritimo','2017-01-07',2,2.15,1.76),(16,'P1','Nacional','Sp Braga','2017-01-07',2.68,2.56,1.15),(16,'P1','Pacos Ferreira','Porto','2017-01-07',9,4.5,0.37),(16,'P1','Rio Ave','Chaves','2017-01-08',0.94,2.3,4),(16,'P1','Sp Lisbon','Feirense','2017-01-08',0.19,6.9,20),(16,'P1','Tondela','Arouca','2017-01-08',1.55,2.2,2.16),(16,'SC0','Aberdeen','Dundee','2017-01-27',0.53,3,4.5),(16,'SC0','Celtic','Hearts','2017-01-29',0.22,5,9),(16,'SC0','Celtic','St Johnstone','2017-01-25',0.17,5.5,12),(16,'SC0','Inverness C','Partick','2017-01-28',1.38,2.4,1.75),(16,'SC0','Kilmarnock','Ross County','2017-01-28',1.88,2.4,1.25),(16,'SC0','Motherwell','Rangers','2017-01-28',5,3.5,0.44),(16,'SC0','St Johnstone','Hamilton','2017-01-28',0.73,2.5,3.5),(16,'SC1','Ayr','Dunfermline','2017-01-07',1.88,2.4,1.69),(16,'SC1','Dumbarton','Hibernian','2017-01-14',1,1,0.02),(16,'SC1','Dundee United','Queen of Sth','2017-01-14',0.02,1,1),(16,'SC1','Dunfermline','St Mirren','2017-01-14',0.02,0.5,0.5),(16,'SC1','Falkirk','Ayr','2017-01-14',0.02,0.95,0.95),(16,'SC1','Hibernian','Dundee United','2017-01-06',0.85,2.65,3.65),(16,'SC1','Morton','Dumbarton','2017-01-07',0.76,2.9,4),(16,'SC1','Morton','Raith Rvs','2017-01-14',0.02,0.5,0.5),(16,'SC1','Raith Rvs','Falkirk','2017-01-07',1.88,2.4,1.6),(16,'SC1','St Mirren','Queen of Sth','2017-01-07',1.6,2.4,1.86),(16,'SP1','Alaves','Leganes','2017-01-21',1.15,2.25,3.15),(16,'SP1','Ath Bilbao','Alaves','2017-01-08',0.6,3.05,6),(16,'SP1','Ath Bilbao','Ath Madrid','2017-01-22',2.68,2.4,1.22),(16,'SP1','Ath Madrid','Betis','2017-01-14',0.27,5.8,16),(16,'SP1','Barcelona','Las Palmas','2017-01-14',0.11,13,30),(16,'SP1','Betis','Leganes','2017-01-08',1.15,2.4,3.1),(16,'SP1','Betis','Sp Gijon','2017-01-22',0.75,2.92,4.6),(16,'SP1','Celta','Alaves','2017-01-15',0.8,3,4.25),(16,'SP1','Celta','Malaga','2017-01-08',0.91,2.86,3.35),(16,'SP1','Eibar','Ath Madrid','2017-01-07',5,2.85,0.72),(16,'SP1','Eibar','Barcelona','2017-01-22',12.5,5.3,0.28),(16,'SP1','Espanol','Granada','2017-01-21',0.68,3.05,4.8),(16,'SP1','Espanol','La Coruna','2017-01-06',1.14,2.44,2.9),(16,'SP1','Granada','Osasuna','2017-01-15',1.07,2.6,3.2),(16,'SP1','La Coruna','Villarreal','2017-01-14',2,2.3,1.71),(16,'SP1','Las Palmas','La Coruna','2017-01-20',1.1,2.45,3),(16,'SP1','Las Palmas','Sp Gijon','2017-01-07',0.73,3.05,4.5),(16,'SP1','Leganes','Ath Bilbao','2017-01-14',2.7,2.52,1.3),(16,'SP1','Malaga','Sociedad','2017-01-13',1.65,2.4,1.8),(16,'SP1','Osasuna','Sevilla','2017-01-22',5.4,3.15,0.65),(16,'SP1','Osasuna','Valencia','2017-01-09',3.05,2.7,1.02),(16,'SP1','Real Madrid','Granada','2017-01-07',0.08,15.5,30),(16,'SP1','Real Madrid','Malaga','2017-01-21',0.09,14.5,28),(16,'SP1','Sevilla','Real Madrid','2017-01-15',3,3,0.95),(16,'SP1','Sociedad','Celta','2017-01-23',1.21,2.65,2.46),(16,'SP1','Sociedad','Sevilla','2017-01-07',1.4,2.5,2.2),(16,'SP1','Valencia','Espanol','2017-01-15',0.8,2.9,3.95),(16,'SP1','Villarreal','Barcelona','2017-01-08',5.5,3.8,0.53),(16,'SP1','Villarreal','Valencia','2017-01-21',0.75,2.9,4.4),(16,'SP2','Alcorcon','Murcia','2017-01-08',1.08,2.3,3.4),(16,'SP2','Almeria','Getafe','2017-01-06',1.6,2.15,2.2),(16,'SP2','Cordoba','Vallecano','2017-01-07',1.7,2.3,1.96),(16,'SP2','Elche','Cadiz','2017-01-08',1.42,2.2,2.4),(16,'SP2','Gimnastic','Tenerife','2017-01-08',1.54,2.1,2.3),(16,'SP2','Levante','Lugo','2017-01-07',0.85,2.5,4.2),(16,'SP2','Mallorca','Mirandes','2017-01-06',0.84,2.5,4.25),(16,'SP2','Numancia','Huesca','2017-01-06',1.2,2.3,2.8),(16,'SP2','Sevilla B','Oviedo','2017-01-08',1.23,2.25,2.85),(16,'SP2','Valladolid','Reus Deportiu','2017-01-06',1,2.3,3.7),(16,'SP2','Zaragoza','Girona','2017-01-08',1.7,2.2,1.96);
/*!40000 ALTER TABLE `UNPLAYED_FIXTURES` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-01-05 18:31:41
