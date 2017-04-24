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
-- Table structure for table `LOAD_PREDICTIONS`
--

DROP TABLE IF EXISTS `LOAD_PREDICTIONS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `LOAD_PREDICTIONS` (
  `SEASON` int(11) NOT NULL,
  `DIVISION` varchar(45) NOT NULL,
  `FIXTURE_DATE` date NOT NULL,
  `HOME_TEAM` varchar(45) NOT NULL,
  `AWAY_TEAM` varchar(45) NOT NULL,
  `METHOD` varchar(45) NOT NULL,
  `FTR` varchar(1) NOT NULL,
  `CONFIDENCE` float NOT NULL,
  PRIMARY KEY (`SEASON`,`DIVISION`,`FIXTURE_DATE`,`HOME_TEAM`,`AWAY_TEAM`,`METHOD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LOAD_PREDICTIONS`
--

LOCK TABLES `LOAD_PREDICTIONS` WRITE;
/*!40000 ALTER TABLE `LOAD_PREDICTIONS` DISABLE KEYS */;
INSERT  IGNORE INTO `LOAD_PREDICTIONS` (`SEASON`, `DIVISION`, `FIXTURE_DATE`, `HOME_TEAM`, `AWAY_TEAM`, `METHOD`, `FTR`, `CONFIDENCE`) VALUES (16,'B1','2017-01-20','Gent','Charleroi','V1','H',0.485333),(16,'B1','2017-01-21','Eupen','Genk','V1','H',0.483668),(16,'B1','2017-01-21','Kortrijk','Waregem','V1','A',0.472689),(16,'B1','2017-01-21','Mouscron','Lokeren','V1','A',0.472369),(16,'B1','2017-01-21','Waasland-Beveren','Oostende','V1','H',0.434723),(16,'B1','2017-01-22','Anderlecht','St Truiden','V1','H',0.787686),(16,'B1','2017-01-22','Mechelen','Westerlo','V1','H',0.714018),(16,'B1','2017-01-22','Standard','Club Brugge','V1','H',0.471126),(16,'B1','2017-01-24','Genk','Kortrijk','V1','H',0.652808),(16,'B1','2017-01-24','Oostende','Charleroi','V1','H',0.507968),(16,'B1','2017-01-24','Waregem','Mouscron','V1','H',0.724252),(16,'B1','2017-01-25','Club Brugge','Waasland-Beveren','V1','H',0.816402),(16,'B1','2017-01-25','Lokeren','Gent','V1','H',0.432782),(16,'B1','2017-01-25','St Truiden','Mechelen','V1','A',0.474021),(16,'B1','2017-01-25','Westerlo','Anderlecht','V1','A',0.691801),(16,'D1','2017-01-20','Freiburg','Bayern Munich','V1','A',0.580085),(16,'D1','2017-01-21','Augsburg','Hoffenheim','V1','D',0.469572),(16,'D1','2017-01-21','Darmstadt','M\'gladbach','V1','H',0.539745),(16,'D1','2017-01-21','RB Leipzig','Ein Frankfurt','V1','H',0.594732),(16,'D1','2017-01-21','Schalke 04','Ingolstadt','V1','H',0.563636),(16,'D1','2017-01-21','Werder Bremen','Dortmund','V1','A',0.484998),(16,'D1','2017-01-21','Wolfsburg','Hamburg','V1','H',0.478905),(16,'D1','2017-01-22','Leverkusen','Hertha','V1','A',0.50792),(16,'D1','2017-01-22','Mainz','FC Koln','V1','H',0.514537),(16,'D1','2017-01-27','Schalke 04','Ein Frankfurt','V1','A',0.495931),(16,'D1','2017-01-28','Darmstadt','FC Koln','V1','A',0.451605),(16,'D1','2017-01-28','Ingolstadt','Hamburg','V1','H',0.446921),(16,'D1','2017-01-28','Leverkusen','M\'gladbach','V1','H',0.592332),(16,'D1','2017-01-28','RB Leipzig','Hoffenheim','V1','H',0.538763),(16,'D1','2017-01-28','Werder Bremen','Bayern Munich','V1','A',0.736973),(16,'D1','2017-01-28','Wolfsburg','Augsburg','V1','A',0.45415),(16,'D1','2017-01-29','Freiburg','Hertha','V1','H',0.486465),(16,'D1','2017-01-29','Mainz','Dortmund','V1','H',0.491086),(16,'D1','2017-02-03','Hamburg','Leverkusen','V1','A',0.513277),(16,'D1','2017-02-04','Bayern Munich','Schalke 04','V1','H',0.868058),(16,'D1','2017-02-04','Dortmund','RB Leipzig','V1','D',0.422757),(16,'D1','2017-02-04','FC Koln','Wolfsburg','V1','H',0.549144),(16,'D1','2017-02-04','Hertha','Ingolstadt','V1','H',0.776851),(16,'D1','2017-02-04','Hoffenheim','Mainz','V1','H',0.640226),(16,'D1','2017-02-04','M\'gladbach','Freiburg','V1','H',0.509426),(16,'D1','2017-02-05','Augsburg','Werder Bremen','V1','H',0.431836),(16,'D1','2017-02-05','Ein Frankfurt','Darmstadt','V1','H',0.800252),(16,'D2','2017-01-27','Fortuna Dusseldorf','Sandhausen','V1','D',0.450026),(16,'D2','2017-01-27','Munich 1860','Greuther Furth','V1','H',0.425125),(16,'D2','2017-01-27','Union Berlin','Bochum','V1','H',0.556976),(16,'D2','2017-01-28','Erzgebirge Aue','Heidenheim','V1','A',0.593176),(16,'D2','2017-01-28','Wurzburger Kickers','Braunschweig','V1','D',0.419807),(16,'D2','2017-01-29','Karlsruhe','Bielefeld','V1','D',0.419512),(16,'D2','2017-01-29','Nurnberg','Dresden','V1','A',0.415412),(16,'D2','2017-01-29','St Pauli','Stuttgart','V1','A',0.643917),(16,'D2','2017-01-30','Hannover','Kaiserslautern','V1','H',0.586119),(16,'E0','2017-01-03','Bournemouth','Arsenal','V1','A',0.546719),(16,'E0','2017-01-03','Crystal Palace','Swansea','V1','H',0.475583),(16,'E0','2017-01-03','Stoke','Watford','V1','H',0.425423),(16,'E0','2017-01-04','Tottenham','Chelsea','V1','A',0.441347),(16,'E0','2017-01-14','Burnley','Southampton','V1','H',0.50387),(16,'E0','2017-01-14','Hull','Bournemouth','V1','H',0.477673),(16,'E0','2017-01-14','Leicester','Chelsea','V1','A',0.72899),(16,'E0','2017-01-14','Sunderland','Stoke','V1','A',0.428952),(16,'E0','2017-01-14','Swansea','Arsenal','V1','A',0.766243),(16,'E0','2017-01-14','Tottenham','West Brom','V1','H',0.680207),(16,'E0','2017-01-14','Watford','Middlesbrough','V1','H',0.43704),(16,'E0','2017-01-14','West Ham','Crystal Palace','V1','H',0.493873),(16,'E0','2017-01-15','Everton','Man City','V1','A',0.504786),(16,'E0','2017-01-15','Man United','Liverpool','V1','D',0.418084),(16,'E0','2017-01-21','Bournemouth','Watford','V1','H',0.567185),(16,'E0','2017-01-21','Crystal Palace','Everton','V1','A',0.491253),(16,'E0','2017-01-21','Liverpool','Swansea','V1','H',0.873414),(16,'E0','2017-01-21','Man City','Tottenham','V1','H',0.491825),(16,'E0','2017-01-21','Middlesbrough','West Ham','V1','A',0.439791),(16,'E0','2017-01-21','Stoke','Man United','V1','A',0.542063),(16,'E0','2017-01-21','West Brom','Sunderland','V1','H',0.732825),(16,'E0','2017-01-22','Arsenal','Burnley','V1','H',0.860283),(16,'E0','2017-01-22','Chelsea','Hull','V1','H',0.896565),(16,'E0','2017-01-22','Southampton','Leicester','V1','H',0.566213),(16,'E1','2017-01-12','Reading','QPR','V1','H',0.809829),(16,'E1','2017-01-13','Leeds','Derby','V1','H',0.4678),(16,'E1','2017-01-14','Birmingham','Nott\'m Forest','V1','H',0.593287),(16,'E1','2017-01-14','Bristol City','Cardiff','V1','H',0.481695),(16,'E1','2017-01-14','Burton','Wigan','V1','H',0.473802),(16,'E1','2017-01-14','Fulham','Barnsley','V1','A',0.429275),(16,'E1','2017-01-14','Ipswich','Blackburn','V1','H',0.575548),(16,'E1','2017-01-14','Preston','Brighton','V1','A',0.550393),(16,'E1','2017-01-14','Rotherham','Norwich','V1','A',0.564227),(16,'E1','2017-01-14','Sheffield Weds','Huddersfield','V1','H',0.469958),(16,'E1','2017-01-14','Wolves','Aston Villa','V1','D',0.428072),(16,'E1','2017-01-16','Brentford','Newcastle','V1','A',0.543567),(16,'E1','2017-05-06','Aston Villa','Wolves','V1','D',0.449374),(16,'E2','2017-01-07','Bradford','Chesterfield','V1','H',0.72253),(16,'E2','2017-01-07','Bristol Rvs','Northampton','V1','H',0.524751),(16,'E2','2017-01-07','Scunthorpe','Bury','V1','H',0.768644),(16,'E2','2017-01-07','Southend','Sheffield United','V1','D',0.420938),(16,'E2','2017-01-07','Swindon','Shrewsbury','V1','H',0.496979),(16,'E2','2017-01-14','AFC Wimbledon','Oxford','V1','H',0.420022),(16,'E2','2017-01-14','Bolton','Swindon','V1','H',0.807734),(16,'E2','2017-01-14','Bury','Peterboro','V1','A',0.576036),(16,'E2','2017-01-14','Charlton','Millwall','V1','H',0.424403),(16,'E2','2017-01-14','Chesterfield','Coventry','V1','H',0.564323),(16,'E2','2017-01-14','Fleetwood Town','Bristol Rvs','V1','H',0.639607),(16,'E2','2017-01-14','Northampton','Scunthorpe','V1','A',0.577426),(16,'E2','2017-01-14','Oldham','Gillingham','V1','A',0.419743),(16,'E2','2017-01-14','Port Vale','Milton Keynes Dons','V1','H',0.455647),(16,'E2','2017-01-14','Shrewsbury','Bradford','V1','A',0.515983),(16,'E2','2017-01-14','Southend','Rochdale','V1','H',0.522067),(16,'E2','2017-01-14','Walsall','Sheffield United','V1','A',0.502128),(16,'E3','2017-01-05','Doncaster','Portsmouth','V1','H',0.575812),(16,'E3','2017-01-07','Colchester','Carlisle','V1','A',0.42741),(16,'E3','2017-01-07','Hartlepool','Grimsby','V1','A',0.419497),(16,'E3','2017-01-07','Leyton Orient','Barnet','V1','A',0.509935),(16,'E3','2017-01-07','Mansfield','Crewe','V1','D',0.455299),(16,'E3','2017-01-07','Morecambe','Notts County','V1','A',0.482757),(16,'E3','2017-01-07','Stevenage','Newport County','V1','H',0.541002),(16,'EC','2017-01-07','Aldershot','Southport','V1','H',0.728582),(16,'EC','2017-01-07','Braintree Town','Chester','V1','A',0.44755),(16,'EC','2017-01-07','Bromley','Forest Green','V1','A',0.509576),(16,'EC','2017-01-07','Dover Athletic','York','V1','H',0.828332),(16,'EC','2017-01-07','Guiseley','Maidstone','V1','H',0.435439),(16,'EC','2017-01-07','North Ferriby','Dag and Red','V1','A',0.663134),(16,'EC','2017-01-07','Solihull','Gateshead','V1','A',0.422479),(16,'EC','2017-01-07','Torquay','Boreham Wood','V1','H',0.420685),(16,'EC','2017-01-07','Wrexham','Woking','V1','H',0.631903),(16,'EC','2017-01-10','Barrow','Southport','V1','H',0.744822),(16,'EC','2017-01-10','Braintree Town','Sutton','V1','H',0.436135),(16,'EC','2017-01-10','Eastleigh','Forest Green','V1','A',0.439861),(16,'EC','2017-01-10','Macclesfield','Dover Athletic','V1','A',0.503074),(16,'F1','2017-01-13','Lille','St Etienne','V1','H',0.434506),(16,'F1','2017-01-14','Angers','Bordeaux','V1','A',0.385763),(16,'F1','2017-01-14','Lorient','Guingamp','V1','A',0.485545),(16,'F1','2017-01-14','Montpellier','Dijon','V1','H',0.537784),(16,'F1','2017-01-14','Nancy','Bastia','V1','H',0.454899),(16,'F1','2017-01-14','Rennes','Paris SG','V1','H',0.468883),(16,'F1','2017-01-14','Toulouse','Nantes','V1','H',0.543552),(16,'F1','2017-01-15','Caen','Lyon','V1','A',0.557643),(16,'F1','2017-01-15','Marseille','Monaco','V1','A',0.510231),(16,'F1','2017-01-15','Nice','Metz','V1','H',0.866699),(16,'F1','2017-01-18','Nantes','Caen','V1','H',0.518189),(16,'F1','2017-01-21','Bastia','Nice','V1','A',0.57411),(16,'F1','2017-01-21','Bordeaux','Toulouse','V1','H',0.475238),(16,'F1','2017-01-21','Caen','Nancy','V1','H',0.452126),(16,'F1','2017-01-21','Dijon','Lille','V1','H',0.578425),(16,'F1','2017-01-21','Guingamp','Rennes','V1','H',0.633035),(16,'F1','2017-01-21','Lyon','Marseille','V1','H',0.509653),(16,'F1','2017-01-21','Metz','Montpellier','V1','H',0.471728),(16,'F1','2017-01-21','Monaco','Lorient','V1','H',0.900867),(16,'F1','2017-01-21','Nantes','Paris SG','V1','A',0.592016),(16,'F1','2017-01-21','St Etienne','Angers','V1','H',0.598507),(16,'F1','2017-01-28','Angers','Metz','V1','H',0.441126),(16,'F1','2017-01-28','Bastia','Caen','V1','H',0.610286),(16,'F1','2017-01-28','Lorient','Dijon','V1','H',0.501038),(16,'F1','2017-01-28','Lyon','Lille','V1','H',0.831436),(16,'F1','2017-01-28','Marseille','Montpellier','V1','H',0.634279),(16,'F1','2017-01-28','Nancy','Bordeaux','V1','D',0.439528),(16,'F1','2017-01-28','Nice','Guingamp','V1','H',0.682267),(16,'F1','2017-01-28','Paris SG','Monaco','V1','H',0.51175),(16,'F1','2017-01-28','Rennes','Nantes','V1','H',0.601333),(16,'F1','2017-01-28','Toulouse','St Etienne','V1','H',0.51452),(16,'G1','2017-01-03','Iraklis','Xanthi','V1','A',0.659126),(16,'G1','2017-01-03','Levadeiakos','PAOK','V1','A',0.453742),(16,'G1','2017-01-04','AEK','Panetolikos','V1','H',0.615414),(16,'G1','2017-01-04','Kerkyra','Atromitos','V1','A',0.481386),(16,'G1','2017-01-04','Larisa','Veria','V1','D',0.448043),(16,'G1','2017-01-04','Olympiakos','Asteras Tripolis','V1','H',0.890028),(16,'G1','2017-01-05','Panionios','Giannina','V1','H',0.435177),(16,'G1','2017-01-05','Platanias','Panathinaikos','V1','D',0.433257),(16,'I1','2017-01-07','Empoli','Palermo','V1','H',0.430487),(16,'I1','2017-01-07','Napoli','Sampdoria','V1','H',0.685698),(16,'I1','2017-01-08','Chievo','Atalanta','V1','A',0.478661),(16,'I1','2017-01-08','Genoa','Roma','V1','H',0.443274),(16,'I1','2017-01-08','Juventus','Bologna','V1','H',0.886896),(16,'I1','2017-01-08','Lazio','Crotone','V1','H',0.813035),(16,'I1','2017-01-08','Milan','Cagliari','V1','H',0.873647),(16,'I1','2017-01-08','Pescara','Fiorentina','V1','A',0.488011),(16,'I1','2017-01-08','Sassuolo','Torino','V1','A',0.501063),(16,'I1','2017-01-08','Udinese','Inter','V1','H',0.488235),(16,'I1','2017-01-14','Crotone','Bologna','V1','H',0.442059),(16,'I1','2017-01-14','Inter','Chievo','V1','H',0.669934),(16,'I1','2017-01-15','Cagliari','Genoa','V1','H',0.63181),(16,'I1','2017-01-15','Fiorentina','Juventus','V1','A',0.550419),(16,'I1','2017-01-15','Lazio','Atalanta','V1','H',0.534037),(16,'I1','2017-01-15','Napoli','Pescara','V1','H',0.724333),(16,'I1','2017-01-15','Sampdoria','Empoli','V1','H',0.558764),(16,'I1','2017-01-15','Sassuolo','Palermo','V1','H',0.512565),(16,'I1','2017-01-15','Udinese','Roma','V1','A',0.522709),(16,'I1','2017-01-16','Torino','Milan','V1','H',0.487438),(16,'I2','2017-01-21','Brescia','Avellino','V1','H',0.606311),(16,'I2','2017-01-21','Carpi','Vicenza','V1','D',0.415173),(16,'I2','2017-01-21','Cittadella','Bari','V1','H',0.521276),(16,'I2','2017-01-21','Latina','Verona','V1','D',0.42974),(16,'I2','2017-01-21','Pisa','Ternana','V1','D',0.486754),(16,'I2','2017-01-21','Spal','Benevento','V1','H',0.506333),(16,'I2','2017-01-21','Trapani','Novara','V1','D',0.4047),(16,'I2','2017-01-21','Virtus Entella','Frosinone','V1','H',0.441962),(16,'I2','2017-01-22','Ascoli','Pro Vercelli','V1','D',0.488812),(16,'I2','2017-01-22','Salernitana','Spezia','V1','D',0.528887),(16,'I2','2017-01-23','Perugia','Cesena','V1','H',0.515624),(16,'N1','2017-01-13','Go Ahead Eagles','AZ Alkmaar','V1','A',0.541866),(16,'N1','2017-01-14','Heerenveen','Den Haag','V1','H',0.725988),(16,'N1','2017-01-14','Heracles','Groningen','V1','D',0.427738),(16,'N1','2017-01-14','PSV Eindhoven','Excelsior','V1','H',0.70389),(16,'N1','2017-01-14','Sparta Rotterdam','Utrecht','V1','D',0.449672),(16,'N1','2017-01-15','Roda','Feyenoord','V1','A',0.624667),(16,'N1','2017-01-15','Vitesse','Twente','V1','D',0.426868),(16,'N1','2017-01-15','Willem II','Nijmegen','V1','D',0.497841),(16,'N1','2017-01-15','Zwolle','Ajax','V1','A',0.749104),(16,'P1','2017-01-07','Estoril','Maritimo','V1','A',0.472404),(16,'P1','2017-01-07','Nacional','Sp Braga','V1','A',0.666893),(16,'P1','2017-01-07','Pacos Ferreira','Porto','V1','A',0.507187),(16,'P1','2017-01-08','Boavista','Setubal','V1','A',0.386344),(16,'P1','2017-01-08','Rio Ave','Chaves','V1','H',0.440139),(16,'P1','2017-01-08','Sp Lisbon','Feirense','V1','H',0.87368),(16,'P1','2017-01-08','Tondela','Arouca','V1','A',0.439586),(16,'SC1','2017-01-06','Hibernian','Dundee United','V1','D',0.419957),(16,'SC1','2017-01-07','Ayr','Dunfermline','V1','D',0.442202),(16,'SC1','2017-01-07','Morton','Dumbarton','V1','H',0.571654),(16,'SC1','2017-01-07','Raith Rvs','Falkirk','V1','D',0.420416),(16,'SC1','2017-01-07','St Mirren','Queen of Sth','V1','A',0.479024),(16,'SP1','2017-01-06','Espanol','La Coruna','V1','H',0.533125),(16,'SP1','2017-01-07','Eibar','Ath Madrid','V1','H',0.47167),(16,'SP1','2017-01-07','Las Palmas','Sp Gijon','V1','H',0.702745),(16,'SP1','2017-01-07','Real Madrid','Granada','V1','H',0.849968),(16,'SP1','2017-01-07','Sociedad','Sevilla','V1','A',0.46924),(16,'SP1','2017-01-08','Ath Bilbao','Alaves','V1','H',0.507331),(16,'SP1','2017-01-08','Betis','Leganes','V1','H',0.485666),(16,'SP1','2017-01-08','Celta','Malaga','V1','H',0.558712),(16,'SP1','2017-01-08','Villarreal','Barcelona','V1','D',0.416104),(16,'SP1','2017-01-09','Osasuna','Valencia','V1','A',0.425939),(16,'SP1','2017-01-13','Malaga','Sociedad','V1','H',0.457784),(16,'SP1','2017-01-14','Ath Madrid','Betis','V1','H',0.747563),(16,'SP1','2017-01-14','Barcelona','Las Palmas','V1','H',0.585896),(16,'SP1','2017-01-14','La Coruna','Villarreal','V1','A',0.477314),(16,'SP1','2017-01-14','Leganes','Ath Bilbao','V1','A',0.514112),(16,'SP1','2017-01-15','Celta','Alaves','V1','H',0.458056),(16,'SP1','2017-01-15','Granada','Osasuna','V1','H',0.432383),(16,'SP1','2017-01-15','Sevilla','Real Madrid','V1','D',0.400822),(16,'SP1','2017-01-15','Valencia','Espanol','V1','A',0.511598),(16,'SP1','2017-01-20','Las Palmas','La Coruna','V1','H',0.626586),(16,'SP1','2017-01-21','Alaves','Leganes','V1','H',0.427468),(16,'SP1','2017-01-21','Espanol','Granada','V1','H',0.543561),(16,'SP1','2017-01-21','Real Madrid','Malaga','V1','H',0.705249),(16,'SP1','2017-01-21','Villarreal','Valencia','V1','H',0.712453),(16,'SP1','2017-01-22','Ath Bilbao','Ath Madrid','V1','H',0.504056),(16,'SP1','2017-01-22','Betis','Sp Gijon','V1','H',0.689315),(16,'SP1','2017-01-22','Eibar','Barcelona','V1','A',0.496257),(16,'SP1','2017-01-22','Osasuna','Sevilla','V1','A',0.706079),(16,'SP1','2017-01-23','Sociedad','Celta','V1','H',0.779161),(16,'SP2','2017-01-06','Almeria','Getafe','V1','D',0.437426),(16,'SP2','2017-01-06','Mallorca','Mirandes','V1','D',0.469944),(16,'SP2','2017-01-06','Numancia','Huesca','V1','H',0.47842),(16,'SP2','2017-01-06','Valladolid','Reus Deportiu','V1','H',0.441645),(16,'SP2','2017-01-07','Cordoba','Vallecano','V1','H',0.515155),(16,'SP2','2017-01-07','Levante','Lugo','V1','H',0.580994),(16,'SP2','2017-01-08','Elche','Cadiz','V1','H',0.463173),(16,'SP2','2017-01-08','Gimnastic','Tenerife','V1','D',0.479101),(16,'SP2','2017-01-08','Sevilla B','Oviedo','V1','H',0.580428),(16,'SP2','2017-01-08','Zaragoza','Girona','V1','H',0.467055);
/*!40000 ALTER TABLE `LOAD_PREDICTIONS` ENABLE KEYS */;
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
