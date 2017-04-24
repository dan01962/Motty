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
-- Table structure for table `TEAM_MAPPING`
--

DROP TABLE IF EXISTS `TEAM_MAPPING`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TEAM_MAPPING` (
  `ODDSCHECK_NAME` varchar(45) NOT NULL,
  `DIVISION` varchar(45) NOT NULL,
  `RESULTS_NAME` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`ODDSCHECK_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TEAM_MAPPING`
--

LOCK TABLES `TEAM_MAPPING` WRITE;
/*!40000 ALTER TABLE `TEAM_MAPPING` DISABLE KEYS */;
INSERT  IGNORE INTO `TEAM_MAPPING` (`ODDSCHECK_NAME`, `DIVISION`, `RESULTS_NAME`) VALUES ('1 FC Heidenheim','D2','Heidenheim'),('1860 Munich','D2','Munich 1860'),('AC Milan','I1','Milan'),('AEK Athens','G1','AEK'),('Akhisar Belediye','T1','Akhisar Belediyespor'),('Athletic Bilbao','SP1','Ath Bilbao'),('Atletico Madrid','SP1','Ath Madrid'),('Atromitos Athinon','G1','Atromitos'),('Aue','D2','Erzgebirge Aue'),('Bayer Leverkusen','D1','Leverkusen'),('Borussia Dortmund','D1','Dortmund'),('Borussia Monchengladbach','D1','M\'gladbach'),('Braga','P1','Sp Braga'),('Bristol Rovers','E2','Bristol Rvs'),('Cambridge United','E3','Cambridge'),('Celta Vigo','SP1','Celta'),('Clermont Foot','F2','Clermont'),('Crawley','E3','Crawley Town'),('Dagenham & Redbridge','EC','Dag and Red'),('Deportivo La Coruna','SP1','La Coruna'),('Dover','EC','Dover Athletic'),('Dundee Utd','SC1','Dundee United'),('Dynamo Dresden','D2','Dresden'),('Eintracht Frankfurt','D1','Ein Frankfurt'),('Espanyol','SP1','Espanol'),('FC Heidenheim','D2','Heidenheim'),('FC Twente Youth','N1','Twente'),('Fleetwood','E2','Fleetwood Town'),('GFCO Ajaccio','F2','Ajaccio GFCO'),('Gijon','SP1','Sp Gijon'),('Gr Furth','D2','Greuther Furth'),('Guimaraes B','P1','Guimaraes'),('Hannover 0.0','D2','Hannover'),('Hertha Berlin','D1','Hertha'),('Inverness','SC0','Inverness C'),('Istanbul Basaksehir','T1','Buyuksehyr'),('Levadiakos','G1','Levadeiakos'),('Mainz 05','D1','Mainz'),('Man Utd','E0','Man United'),('MK Dons','E2','Milton Keynes Dons'),('NEC Nijmegen','N1','Nijmegen'),('North Ferriby Utd','EC','North Ferriby'),('Nottingham Forest','E1','Nott\'m Forest'),('Osmanlispor FK','T1','Osmanlispor'),('Panaitolikos','G1','Panetolikos'),('PAOK Saloniki','G1','PAOK'),('Partick Thistle','SC0','Partick'),('PAS Giannina','G1','Giannina'),('Peterborough','E2','Peterboro'),('PSG','F1','Paris SG'),('PSV','N1','PSV Eindhoven'),('Queen of the South','SC1','Queen of Sth'),('Raith Rovers','SC1','Raith Rvs'),('Rayo Vallecano','SP2','Vallecano'),('Real Sociedad','SP1','Sociedad'),('Red Star FC 93','F2','Red Star'),('Sevilla Atletico','SP2','Sevilla B'),('Sheffield Utd','E2','Sheffield United'),('Sheffield Wednesday','E1','Sheffield Weds'),('Solihull Moors','EC','Solihull'),('Sporting Lisbon','P1','Sp Lisbon'),('Standard de Liege','B1','Standard'),('Sutton Utd','EC','Sutton'),('UCAM Murcia CF','SP2','Murcia'),('US Orleans 45','F2','Orleans'),('Veria FC','G1','Veria'),('VfB Stuttgart','D2','Stuttgart'),('Vitoria Setubal','P1','Setubal'),('Waasland Beveren','B1','Waasland-Beveren'),('Zulte Waregem','B1','Waregem');
/*!40000 ALTER TABLE `TEAM_MAPPING` ENABLE KEYS */;
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
