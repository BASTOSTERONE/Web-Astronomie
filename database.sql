/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.5.29-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: astronomie_db
-- ------------------------------------------------------
-- Server version	10.5.29-MariaDB-0+deb11u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `actualite`
--

DROP TABLE IF EXISTS `actualite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `actualite` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` varchar(255) NOT NULL,
  `date_publication` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actualite`
--

LOCK TABLES `actualite` WRITE;
/*!40000 ALTER TABLE `actualite` DISABLE KEYS */;
/*!40000 ALTER TABLE `actualite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `appareil_photo`
--

DROP TABLE IF EXISTS `appareil_photo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `appareil_photo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `categorie` varchar(50) NOT NULL,
  `marque` varchar(100) NOT NULL,
  `modele` varchar(100) NOT NULL,
  `date_sortie` varchar(50) DEFAULT NULL,
  `score` int(11) DEFAULT NULL,
  `resume` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appareil_photo`
--

LOCK TABLES `appareil_photo` WRITE;
/*!40000 ALTER TABLE `appareil_photo` DISABLE KEYS */;
INSERT INTO `appareil_photo` VALUES (1,'Amateur','Canon','EOS 2000D','2018',4,'Appareil idéal pour débuter en astrophotographie avec un budget maîtrisé.'),(2,'Amateur sérieux','Nikon','D7500','2017',5,'Excellente montée en ISO, parfait pour capturer la voie lactée.'),(3,'Professionnel','Sony','Alpha 7 IV','2021',5,'Capteur plein format surpuissant pour les ciels profonds les plus sombres.');
/*!40000 ALTER TABLE `appareil_photo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `photographie`
--

DROP TABLE IF EXISTS `photographie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `photographie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `titre` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `url_image` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `photographie`
--

LOCK TABLES `photographie` WRITE;
/*!40000 ALTER TABLE `photographie` DISABLE KEYS */;
INSERT INTO `photographie` VALUES (1,'Nébuleuse d\'Orion','Une des nébuleuses les plus brillantes, visible à l\'œil nu.','https://images.unsplash.com/photo-1462331940025-496dfbfc7564?q=80&w=800&auto=format&fit=crop'),(2,'Galaxie d\'Andromède','La galaxie spirale la plus proche de notre Voie lactée.','https://images.unsplash.com/photo-1543722530-d2c3201371e7?q=80&w=800&auto=format&fit=crop'),(3,'Surface lunaire','Détail des cratères de notre satellite naturel.','https://images.unsplash.com/photo-1522030299830-16b8d3d049fe?q=80&w=800&auto=format&fit=crop');
/*!40000 ALTER TABLE `photographie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `telescope`
--

DROP TABLE IF EXISTS `telescope`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `telescope` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `categorie` varchar(50) NOT NULL,
  `marque` varchar(100) NOT NULL,
  `modele` varchar(100) NOT NULL,
  `date_sortie` varchar(50) DEFAULT NULL,
  `score` int(11) DEFAULT NULL,
  `resume` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `telescope`
--

LOCK TABLES `telescope` WRITE;
/*!40000 ALTER TABLE `telescope` DISABLE KEYS */;
INSERT INTO `telescope` VALUES (1,'Téléscopes pour enfants','Celestron','FirstScope','2019',3,'Compact et facile à utiliser pour observer la lune depuis sa chambre.'),(2,'Automatisés','Sky-Watcher','Maksutov','2020',4,'Motorisé avec suivi automatique des planètes, idéal pour ne jamais perdre sa cible.'),(3,'Téléscopes complets','Orion','SkyQuest XT8','2015',5,'Le classique Dobson 200mm, un puits de lumière incroyable pour observer les nébuleuses.');
/*!40000 ALTER TABLE `telescope` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'sterone','pbkdf2:sha256:1000000$qkJxQgiKYTTmTyV5$65a9cf468aae052e15d4a65ac2a224e6efbccbb248db1643b0b543bca3b6eb3c');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-17 13:40:08
