-- MySQL Script generated by MySQL Workbench
-- Mon Dec  3 22:09:54 2018
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema shopstore
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema shopstore
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `shopstore` DEFAULT CHARACTER SET utf8 ;
USE `shopstore` ;

-- -----------------------------------------------------
-- Table `shopstore`.`ProductDim`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `shopstore`.`ProductDim` ;

CREATE TABLE IF NOT EXISTS `shopstore`.`ProductDim` (
  `ProductKey` INT NOT NULL AUTO_INCREMENT,
  `ProductID` INT NULL,
  `Name` VARCHAR(45) NULL,
  `Measure` VARCHAR(45) NULL,
  PRIMARY KEY (`ProductKey`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `shopstore`.`CustomerDim`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `shopstore`.`CustomerDim` ;

CREATE TABLE IF NOT EXISTS `shopstore`.`CustomerDim` (
  `CustomerKey` INT NOT NULL AUTO_INCREMENT,
  `CustomerID` INT NULL,
  `CompanyName` VARCHAR(45) NULL,
  `ContactName` VARCHAR(45) NULL,
  `City` VARCHAR(45) NULL,
  `Address` VARCHAR(45) NULL,
  `Email` VARCHAR(45) NULL,
  `PhoneNumber` VARCHAR(45) NULL,
  PRIMARY KEY (`CustomerKey`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `shopstore`.`StatusDim`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `shopstore`.`StatusDim` ;

CREATE TABLE IF NOT EXISTS `shopstore`.`StatusDim` (
  `StatusKey` INT NOT NULL AUTO_INCREMENT,
  `OrderStatusID` INT NULL,
  `Name` VARCHAR(45) NULL,
  PRIMARY KEY (`StatusKey`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `shopstore`.`ShipmentDim`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `shopstore`.`ShipmentDim` ;

CREATE TABLE IF NOT EXISTS `shopstore`.`ShipmentDim` (
  `ShipmentKey` INT NOT NULL AUTO_INCREMENT,
  `ShipmentTypeID` INT NULL,
  `Name` VARCHAR(45) NULL,
  `Description` VARCHAR(255) NULL,
  PRIMARY KEY (`ShipmentKey`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `shopstore`.`DateDim`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `shopstore`.`DateDim` ;

CREATE TABLE IF NOT EXISTS `shopstore`.`DateDim` (
  `DateKey` INT NOT NULL AUTO_INCREMENT,
  `DateYear` INT NULL,
  `DateMonth` INT NULL,
  `DateDay` INT NULL,
  `IsHoliday` TINYINT NULL,
  `IsWeekend` TINYINT NULL,
  PRIMARY KEY (`DateKey`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `shopstore`.`OrderDim`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `shopstore`.`OrderDim` ;

CREATE TABLE IF NOT EXISTS `shopstore`.`OrderDim` (
  `OrderKey` INT NOT NULL AUTO_INCREMENT,
  `OrderID` INT NULL,
  `CreationDate` DATETIME NULL,
  `PlannedDate` DATETIME NULL,
  `ShipmentDate` DATETIME NULL,
  PRIMARY KEY (`OrderKey`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `shopstore`.`SalesFact`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `shopstore`.`SalesFact` ;

CREATE TABLE IF NOT EXISTS `shopstore`.`SalesFact` (
  `ProductKey` INT NOT NULL,
  `CustomerKey` INT NOT NULL,
  `OrderKey` INT NOT NULL,
  `StatusKey` INT NOT NULL,
  `ShipmentKey` INT NOT NULL,
  `CreationDateKey` INT NOT NULL,
  `PlannedDateKey` INT NOT NULL,
  `ShipmentDateKey` INT NOT NULL,
  `OrderPositionID` INT NOT NULL,
  `Quantity` DOUBLE NULL,
  `SalePrice` DOUBLE NULL,
  `ProductPrice` DOUBLE NULL,
  PRIMARY KEY (`ProductKey`, `CustomerKey`, `OrderKey`, `StatusKey`, `ShipmentKey`, `CreationDateKey`, `PlannedDateKey`, `ShipmentDateKey`),
  CONSTRAINT `fk_OrderPositionFact_ProductDim1`
    FOREIGN KEY (`ProductKey`)
    REFERENCES `shopstore`.`ProductDim` (`ProductKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SalesFact_CustomerDim1`
    FOREIGN KEY (`CustomerKey`)
    REFERENCES `shopstore`.`CustomerDim` (`CustomerKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SalesFact_StatusDim1`
    FOREIGN KEY (`StatusKey`)
    REFERENCES `shopstore`.`StatusDim` (`StatusKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SalesFact_ShipmentDim1`
    FOREIGN KEY (`ShipmentKey`)
    REFERENCES `shopstore`.`ShipmentDim` (`ShipmentKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SalesFact_DateDim1`
    FOREIGN KEY (`CreationDateKey`)
    REFERENCES `shopstore`.`DateDim` (`DateKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SalesFact_OrderDim1`
    FOREIGN KEY (`OrderKey`)
    REFERENCES `shopstore`.`OrderDim` (`OrderKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SalesFact_DateDim2`
    FOREIGN KEY (`PlannedDateKey`)
    REFERENCES `shopstore`.`DateDim` (`DateKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SalesFact_DateDim3`
    FOREIGN KEY (`ShipmentDateKey`)
    REFERENCES `shopstore`.`DateDim` (`DateKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
