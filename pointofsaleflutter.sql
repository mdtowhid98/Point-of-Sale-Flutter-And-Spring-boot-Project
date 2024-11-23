-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: pointofsaleflutter
-- ------------------------------------------------------
-- Server version	8.0.37

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `branches`
--

DROP TABLE IF EXISTS `branches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `branches` (
  `id` int NOT NULL AUTO_INCREMENT,
  `branch_name` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branches`
--

LOCK TABLES `branches` WRITE;
/*!40000 ALTER TABLE `branches` DISABLE KEYS */;
INSERT INTO `branches` VALUES (1,'Dhanmondi','Dhaka'),(2,'Banani','Dhaka'),(3,'Gulshan','Dhaka');
/*!40000 ALTER TABLE `branches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `categoryname` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Omeprazole'),(2,'Flucloxacilin Sodium'),(3,'Montelukast Sodium'),(4,'Esomeprazole'),(5,'Vitamin B1, B6 & B12');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `cell` int NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` int NOT NULL AUTO_INCREMENT,
  `expiry_date` date DEFAULT NULL,
  `manufacture_date` date DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `quantity` int NOT NULL,
  `stock` int NOT NULL,
  `unitprice` int NOT NULL,
  `branch_id` int DEFAULT NULL,
  `category_id` int DEFAULT NULL,
  `supplier_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK7yh1cmuib7hnrbu4ntka4v7ro` (`branch_id`),
  KEY `FKowomku74u72o6h8q0khj7id8q` (`category_id`),
  KEY `FKhiwr0cl8fpxh1xm9y17wo5up0` (`supplier_id`),
  CONSTRAINT `FK7yh1cmuib7hnrbu4ntka4v7ro` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `FKhiwr0cl8fpxh1xm9y17wo5up0` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`),
  CONSTRAINT `FKowomku74u72o6h8q0khj7id8q` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,'2024-11-30','2024-11-01','Xeldrin Capsule (Enteric Coated) 20 mg','Xeldrin_Capsule__Enteric_Coated__20_mg_4b4e050e-ad6a-4c1c-bb5a-914cad79758a',0,35,6,1,1,1),(2,'2025-02-28','2024-11-01','Fluclox Capsule 500 mg','Fluclox_Capsule_500_mg_ff869c97-be4d-4db6-909f-c90edf7af617',0,80,14,1,2,1),(3,'2025-04-30','2024-11-01','Monas Tablet 10 mg','Monas_Tablet_10_mg_12bf6bc8-ead0-40dc-9016-e3a78778ff50',0,18,17,1,3,2),(4,'2025-05-31','2024-11-01','Seclo Capsule (Enteric Coated) 20 mg','Seclo_Capsule__Enteric_Coated__20_mg_77d7ea29-d825-4dc6-8655-1f31acb48023',0,280,60,1,1,3),(5,'2025-05-31','2024-11-01','Neuro-B Tablet 100 mg','Neuro-B_Tablet_100_mg_84e3f00f-399b-409e-96ba-957bc923b453',0,36,10,1,5,3),(6,'2025-06-30','2024-11-01','Xeldrin Capsule (Enteric Coated) 20 mg','Xeldrin_Capsule__Enteric_Coated__20_mg_f9ae6532-696c-4b1d-a568-449bea6f1755',0,10000,6,2,1,1),(7,'2025-05-31','2024-11-01','Fluclox Capsule 500 mg','Fluclox_Capsule_500_mg_c28a54b0-8222-477c-8eb1-914ae369c06d',0,1000,14,2,2,1),(8,'2025-04-30','2024-11-01','Monas Tablet 10 mg','Monas_Tablet_10_mg_dab0e080-592b-418e-a714-6aace45bf8d9',0,10000,10,2,3,2),(9,'2025-03-28','2024-11-01','Maxima Capsule (Enteric Coated) 20 mg','Maxima_Capsule__Enteric_Coated__20_mg_d2944a33-639b-4b9a-b4c5-f6c2611fabb6',0,10000,7,2,4,2),(10,'2025-03-31','2024-11-02','Seclo Capsule (Enteric Coated) 20 mg','Seclo_Capsule__Enteric_Coated__20_mg_97affdb1-351c-400a-ade5-9e4878487097',0,10000,60,2,1,3),(11,'2025-04-29','2024-11-01','Neuro-B Tablet 100 mg','Neuro-B_Tablet_100_mg_60927102-e6d5-4a15-8c6a-be8a97476c25',0,10000,10,2,5,3),(12,'2025-05-31','2024-11-01','Xeldrin Capsule (Enteric Coated) 20 mg','Xeldrin_Capsule__Enteric_Coated__20_mg_b29dc645-cb05-44ac-985d-b26cf9f57045',0,1000,6,3,1,1),(13,'2025-03-28','2024-11-01','Fluclox Capsule 500 mg','Fluclox_Capsule_500_mg_d73d7bcf-39e0-4902-b452-cc250ddfd918',0,1000,14,3,2,1),(14,'2024-11-25','2024-11-01','Monas Tablet 10 mg','Monas_Tablet_10_mg_0d2cb79d-5fc6-4c46-9788-1a952f9730f2',0,1000,10,3,3,2),(15,'2024-11-25','2024-11-01','Maxima Capsule (Enteric Coated) 20 mg','Maxima_Capsule__Enteric_Coated__20_mg_e216326a-afb1-4f25-829b-6d32e0e1dcf2',0,1000,7,3,4,2);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales`
--

DROP TABLE IF EXISTS `sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customername` varchar(255) DEFAULT NULL,
  `discount` float NOT NULL,
  `quantity` int NOT NULL,
  `salesdate` date DEFAULT NULL,
  `totalprice` int NOT NULL,
  `sales_details_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKb6pnjoyoc51ead5sdtsixkuht` (`sales_details_id`),
  CONSTRAINT `FKb6pnjoyoc51ead5sdtsixkuht` FOREIGN KEY (`sales_details_id`) REFERENCES `sales_details` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales`
--

LOCK TABLES `sales` WRITE;
/*!40000 ALTER TABLE `sales` DISABLE KEYS */;
INSERT INTO `sales` VALUES (1,'Towhid',0,2,'2024-11-23',9060,NULL),(2,'Kutub',0,2,'2024-11-24',1620,NULL),(3,'Sabab',0,2,'2024-11-23',12280,NULL),(4,'Nirob',0,2,'2024-11-25',6340,NULL),(5,'Raju',0,2,'2024-11-26',3300,NULL),(6,'rezvi',0,3,'2024-11-23',4850,NULL),(7,'nafis',0,3,'2024-11-26',3630,NULL),(8,'kutub',0,2,'2024-11-27',3510,NULL),(9,'raju',0,2,'2024-11-23',1234,NULL);
/*!40000 ALTER TABLE `sales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_details`
--

DROP TABLE IF EXISTS `sales_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `discount` float NOT NULL,
  `quantity` int NOT NULL,
  `total_price` float NOT NULL,
  `unit_price` float NOT NULL,
  `product_id` int NOT NULL,
  `sales_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKfro6i33ctcc7us92q7j85j41m` (`product_id`),
  KEY `FK9k57fsnt2gom2tvbrft8p9q0x` (`sales_id`),
  CONSTRAINT `FK9k57fsnt2gom2tvbrft8p9q0x` FOREIGN KEY (`sales_id`) REFERENCES `sales` (`id`),
  CONSTRAINT `FKfro6i33ctcc7us92q7j85j41m` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_details`
--

LOCK TABLES `sales_details` WRITE;
/*!40000 ALTER TABLE `sales_details` DISABLE KEYS */;
INSERT INTO `sales_details` VALUES (1,0,150,9000,60,4,1),(2,0,6,60,10,5,1),(3,0,20,120,6,1,2),(4,0,25,1500,60,4,2),(5,0,20,280,14,2,3),(6,0,200,12000,60,4,3),(7,0,100,6000,60,4,4),(8,0,20,340,17,3,4),(9,0,30,300,10,5,5),(10,0,50,3000,60,4,5),(11,0,75,4500,60,4,6),(12,0,25,150,6,1,6),(13,0,20,200,10,5,6),(14,0,20,120,6,1,7),(15,0,50,3000,60,4,7),(16,0,30,510,17,3,7),(17,0,50,3000,60,4,8),(18,0,30,510,17,3,8),(19,0,20,1200,60,4,9),(20,0,2,34,17,3,9);
/*!40000 ALTER TABLE `sales_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_product`
--

DROP TABLE IF EXISTS `sales_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales_product` (
  `sales_id` int NOT NULL,
  `product_id` int NOT NULL,
  KEY `FK7dl4fmr89kvli7uaj1u19306i` (`product_id`),
  KEY `FK18ebowds3h9totm6kall9ovbh` (`sales_id`),
  CONSTRAINT `FK18ebowds3h9totm6kall9ovbh` FOREIGN KEY (`sales_id`) REFERENCES `sales` (`id`),
  CONSTRAINT `FK7dl4fmr89kvli7uaj1u19306i` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_product`
--

LOCK TABLES `sales_product` WRITE;
/*!40000 ALTER TABLE `sales_product` DISABLE KEYS */;
INSERT INTO `sales_product` VALUES (1,4),(1,5),(2,1),(2,4),(3,2),(3,4),(4,4),(4,3),(5,5),(5,4),(6,4),(6,1),(6,5),(7,1),(7,4),(7,3),(8,4),(8,3),(9,4),(9,3);
/*!40000 ALTER TABLE `sales_product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `suppliers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `cell` int NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
INSERT INTO `suppliers` VALUES (1,'Dhaka',5418545,'aci@gmail.com','ACI Limited'),(2,'Dhaka',415415,'acme@gmail.com','ACME Laboratories Ltd.'),(3,'Dhaka',4185415,'square@gmail.com','Square Pharmaceuticals PLC');
/*!40000 ALTER TABLE `suppliers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `token`
--

DROP TABLE IF EXISTS `token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `token` (
  `id` int NOT NULL AUTO_INCREMENT,
  `is_logged_out` bit(1) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKj8rfw4x0wjjyibfqq566j4qng` (`user_id`),
  CONSTRAINT `FKj8rfw4x0wjjyibfqq566j4qng` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `token`
--

LOCK TABLES `token` WRITE;
/*!40000 ALTER TABLE `token` DISABLE KEYS */;
INSERT INTO `token` VALUES (1,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhbGFtbWR0b3doaWR1bDlAZ21haWwuY29tIiwicm9sZSI6IlVTRVIiLCJpYXQiOjE3MzIyOTMwOTIsImV4cCI6MTczMjM3OTQ5Mn0.Fpscqk_0owC5bXrAXhHBvM6iGRfAu3iFUVX6fySeDPHyG2zs5hGesFj2-863U35f',1),(2,_binary '\0','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZHRvd2hpZHVsYTQ2MEBnbWFpbC5jb20iLCJyb2xlIjoiVVNFUiIsImlhdCI6MTczMjI5MzE2NSwiZXhwIjoxNzMyMzc5NTY1fQ.nvnAwoSs-7EDZ8w-tF2M5-SwacqWwh63xhf46Rf3OHfB37lUfRy0g_KGKocjLHl4',2),(3,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhbGFtbWR0b3doaWR1bDlAZ21haWwuY29tIiwicm9sZSI6IlVTRVIiLCJpYXQiOjE3MzIyOTMzNjQsImV4cCI6MTczMjM3OTc2NH0.75Og48BpHp2nrc7TNOO7hYS8wJfEf1Gykeq5ooLMTYiZwBpa_axK3Mt6XFmSw4VE',1),(4,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhbGFtbWR0b3doaWR1bDlAZ21haWwuY29tIiwicm9sZSI6IkFETUlOIiwiaWF0IjoxNzMyMjkzMzkwLCJleHAiOjE3MzIzNzk3OTB9.64LdwL_6hek9WJq-hB-c_JJ8bMkYrvBITsAWUzUWNBTkJZxpFQtHZnO2s8S4AEBV',1),(5,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhbGFtbWR0b3doaWR1bDlAZ21haWwuY29tIiwicm9sZSI6IkFETUlOIiwiaWF0IjoxNzMyMzM1NjA3LCJleHAiOjE3MzI0MjIwMDd9.b5d-wReeUrNvghKboWnOvwC-IWRNtRQtGyfaJKRGjrDKBBAab_f6xr8YLVm-Jugo',1),(6,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhbGFtbWR0b3doaWR1bDlAZ21haWwuY29tIiwicm9sZSI6IkFETUlOIiwiaWF0IjoxNzMyMzM1ODk1LCJleHAiOjE3MzI0MjIyOTV9.a4HnH8az_-g8loWrLE0xCsTmsCI6NVC8jRkiE7MAscgtRBXDhO33LcUyj1zIBNnE',1),(7,_binary '\0','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhbGFtbWR0b3doaWR1bDlAZ21haWwuY29tIiwicm9sZSI6IkFETUlOIiwiaWF0IjoxNzMyMzM2Mjc0LCJleHAiOjE3MzI0MjI2NzR9.FziMNKG1nbqdTWnclP7XMY7vkuGF7rUvkdl7LFVBHm6pb-nH5vx_2JHM2QiDlPWP',1);
/*!40000 ALTER TABLE `token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `active` bit(1) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `cell` varchar(255) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('ADMIN','PHARMACIST','USER') DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK6dotkott2kjsp8vw4d0m25fb7` (`email`),
  UNIQUE KEY `UK3wfgv34acy32imea493ekogs5` (`cell`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,_binary '','Naogaon','01767515057','2024-11-06','alammdtowhidul9@gmail.com','Male',NULL,'Md Towhidul Alam','$2a$10$EunTdiC3IA5AV3P7bfjz6ODjbGzY185qrYUKdxSgdUc/gSMNG1ys2','ADMIN'),(2,_binary '','wr','4845985','2024-11-15','mdtowhidula460@gmail.com','Male',NULL,'Towhid','$2a$10$86kk2XnDT98D5I/8YSyJ7OxBDNc4GWJxlO/WILVYFhndqjIgrZtyy','USER');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-23 11:21:22
