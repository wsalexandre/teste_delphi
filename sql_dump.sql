/*
SQLyog Enterprise v8.71 
MySQL - 11.2.0-MariaDB : Database - teste_delphi
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`teste_delphi` /*!40100 DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci */;

USE `teste_delphi`;

/*Table structure for table `clientes` */

DROP TABLE IF EXISTS `clientes`;

CREATE TABLE `clientes` (
  `Codigo` int(11) NOT NULL,
  `Nome` varchar(255) DEFAULT NULL,
  `Cidade` varchar(255) DEFAULT NULL,
  `UF` char(2) DEFAULT NULL,
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

/*Data for the table `clientes` */

insert  into `clientes`(`Codigo`,`Nome`,`Cidade`,`UF`) values (1,'João da Silva','São Paulo','SP'),(2,'Maria Oliveira','Rio de Janeiro','RJ'),(3,'Pedro Santos','Belo Horizonte','MG'),(4,'Ana Souza','Curitiba','PR'),(5,'José Pereira','Porto Alegre','RS'),(6,'Marcos Rodrigues','Recife','PE'),(7,'Fernanda Lima','Salvador','BA'),(8,'Ricardo Alves','Fortaleza','CE'),(9,'Juliana Castro','Manaus','AM'),(10,'Bruno Gomes','Goiânia','GO'),(11,'Paula Cardoso','Belém','PA'),(12,'Lucas Barbosa','São Luís','MA'),(13,'Beatriz Cunha','Maceió','AL'),(14,'Gustavo Nascimento','Teresina','PI'),(15,'Amanda Ferreira','Natal','RN'),(16,'Rafael Melo','João Pessoa','PB'),(17,'Larissa Barros','Aracaju','SE'),(18,'Thiago Freitas','Cuiabá','MT'),(19,'Mariana Martins','Campo Grande','MS'),(20,'Felipe Costa','Rio Branco','AC');

/*Table structure for table `pedidos` */

DROP TABLE IF EXISTS `pedidos`;

CREATE TABLE `pedidos` (
  `NumeroPedido` int(11) NOT NULL AUTO_INCREMENT,
  `DataEmissao` datetime DEFAULT NULL,
  `CodigoCliente` int(11) DEFAULT NULL,
  `ValorTotal` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`NumeroPedido`),
  KEY `idx_pedidos_cliente` (`CodigoCliente`),
  CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`CodigoCliente`) REFERENCES `clientes` (`Codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

/*Data for the table `pedidos` */

insert  into `pedidos`(`NumeroPedido`,`DataEmissao`,`CodigoCliente`,`ValorTotal`) values (1,'2024-10-28 00:00:00',17,'79.90');

/*Table structure for table `pedidos_produtos` */

DROP TABLE IF EXISTS `pedidos_produtos`;

CREATE TABLE `pedidos_produtos` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `NumeroPedido` int(11) DEFAULT NULL,
  `CodigoProduto` int(11) DEFAULT NULL,
  `Quantidade` int(11) DEFAULT NULL,
  `ValorUnitario` decimal(10,2) DEFAULT NULL,
  `ValorTotal` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `idx_pedidos_produtos_pedido` (`NumeroPedido`),
  KEY `idx_pedidos_produtos_produto` (`CodigoProduto`),
  CONSTRAINT `pedidos_produtos_ibfk_1` FOREIGN KEY (`NumeroPedido`) REFERENCES `pedidos` (`NumeroPedido`),
  CONSTRAINT `pedidos_produtos_ibfk_2` FOREIGN KEY (`CodigoProduto`) REFERENCES `produtos` (`Codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

/*Data for the table `pedidos_produtos` */

insert  into `pedidos_produtos`(`Id`,`NumeroPedido`,`CodigoProduto`,`Quantidade`,`ValorUnitario`,`ValorTotal`) values (1,1,5,1,'79.90','79.90');

/*Table structure for table `produtos` */

DROP TABLE IF EXISTS `produtos`;

CREATE TABLE `produtos` (
  `Codigo` int(11) NOT NULL,
  `Descricao` varchar(255) DEFAULT NULL,
  `PrecoVenda` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

/*Data for the table `produtos` */

insert  into `produtos`(`Codigo`,`Descricao`,`PrecoVenda`) values (1,'Camiseta','29.90'),(2,'Calça Jeans','89.90'),(3,'Tênis','129.90'),(4,'Blusa','39.90'),(5,'Vestido','79.90'),(6,'Saia','49.90'),(7,'Short','34.90'),(8,'Camisa Polo','59.90'),(9,'Jaqueta','159.90'),(10,'Meia','9.90'),(11,'Boné','24.90'),(12,'Bolsa','69.90'),(13,'Carteira','34.90'),(14,'Cinto','29.90'),(15,'Óculos de Sol','89.90'),(16,'Relógio','199.90'),(17,'Colar','49.90'),(18,'Brinco','29.90'),(19,'Anel','79.90'),(20,'Pulseira','39.90');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
