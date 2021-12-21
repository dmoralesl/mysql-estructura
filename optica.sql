-- SCHEMA

DROP SCHEMA IF EXISTS `optica` ;
CREATE SCHEMA IF NOT EXISTS `optica` DEFAULT CHARACTER SET utf8 ;

USE `optica` ;

-- -----------------------------------------------------
-- Table `optica`.`provider`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`provider` (
  `provider_name` VARCHAR(100) NOT NULL,
  `address` VARCHAR(200) NULL,
  `phone` VARCHAR(25) NULL,
  `fax` VARCHAR(25) NULL,
  `nif` VARCHAR(50) NULL,
  PRIMARY KEY (`provider_name`),
  UNIQUE INDEX `nif_UNIQUE` (`nif` ASC) VISIBLE,
  UNIQUE INDEX `phone_UNIQUE` (`phone` ASC) VISIBLE,
  UNIQUE INDEX `address_UNIQUE` (`address` ASC) VISIBLE,
  UNIQUE INDEX `fax_UNIQUE` (`fax` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`customer` (
  `customer_name` VARCHAR(100) NOT NULL,
  `address` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(25) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `registeredDate` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `referedBy` VARCHAR(45) NULL,
  PRIMARY KEY (`customer_name`),
  INDEX `referedBy_idx` (`referedBy` ASC) VISIBLE,
  CONSTRAINT `name`
    FOREIGN KEY (`referedBy`)
    REFERENCES `optica`.`customer` (`customer_name`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`glasses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`glasses` (
  `id_glasses` INT NOT NULL AUTO_INCREMENT,
  `leftLens` FLOAT NOT NULL,
  `rightLens` FLOAT NOT NULL,
  `brand` VARCHAR(45) NOT NULL,
  `provider` VARCHAR(100) NOT NULL,
  `price` FLOAT NOT NULL,
  `frameType` SET("float", "metal", "paste") NULL,
  `frameColor` VARCHAR(45) NULL,
  `glassColor` VARCHAR(45) NULL,
  `customer_name` VARCHAR(100) NOT NULL,
  `soldBy` VARCHAR(100) NULL,
  `soldDate` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_glasses`, `customer_name`),
  INDEX `name_idx` (`provider` ASC) VISIBLE,
  INDEX `fk_glasses_customer1_idx` (`customer_name` ASC) VISIBLE,
  CONSTRAINT `provider_name`
    FOREIGN KEY (`provider`)
    REFERENCES `optica`.`provider` (`provider_name`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `customer_name`
    FOREIGN KEY (`customer_name`)
    REFERENCES `optica`.`customer` (`customer_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



-- DATA

-- -----------------------------------------------------
-- Table `optica`.`provider`
-- -----------------------------------------------------
INSERT INTO `optica`.`provider` (`provider_name`, `address`, `phone`, `fax`, `nif`) VALUES
('Provider1', 'Random Street, 1', '912345601', '912345601', '000000001'),
('Provider2', 'Random Street, 2', '912345602', '912345602', '000000002'),
('Provider3', 'Random Street, 3', '912345603', '912345603', '000000003'),
('Provider4', 'Random Street, 4', '912345604', '912345604', '000000004'),
('Provider5', 'Random Street, 5', '912345605', '912345605', '000000005'),
('Provider6', 'Random Street, 6', '912345606', '912345606', '000000006'),
('Provider7', 'Random Street, 7', '912345607', '912345607', '000000007'),
('Provider8', 'Random Street, 8', '912345608', '912345608', '000000008'),
('Provider9', 'Random Street, 9', '912345609', '912345609', '000000009'),
('Provider10', 'Random Street, 10', '912345610', '912345610', '000000010'),
('Provider11', 'Random Street, 11', '912345611', '912345611', '000000011');


-- -----------------------------------------------------
-- Table `optica`.`customer`
-- -----------------------------------------------------
-- 20 random customers data
INSERT INTO `optica`.`customer` (`customer_name`, `address`, `phone`, `email`, `referedBy`) VALUES
('Customer1', 'Random Street, 1', '912345601', 'random1@mail.com ', ''),
('Customer2', 'Random Street, 2', '912345602', 'random2@mail.com', ''),
('Customer3', 'Random Street, 3', '912345603', 'random3@mail.com', 'Customer1'),
('Customer4', 'Random Street, 4', '912345604', 'random4@mail.com', ''),
('Customer5', 'Random Street, 5', '912345605', 'random5@mail.com', ''),
('Customer6', 'Random Street, 6', '912345606', 'random6@mail.com', ''),
('Customer7', 'Random Street, 7', '912345607', 'random7@mail.com', ''),
('Customer8', 'Random Street, 8', '912345608', 'random8@mail.com', ''),
('Customer9', 'Random Street, 9', '912345609', 'random9@mail.com', ''),
('Customer10', 'Random Street, 10', '912345610', 'random10@mail.com', 'Customer12'),
('Customer11', 'Random Street, 11', '912345611', 'random11@mail.com', ''),
('Customer12', 'Random Street, 12', '912345612', 'random12@mail.com', ''),
('Customer13', 'Random Street, 13', '912345613', 'random13@mail.com', ''),
('Customer14', 'Random Street, 14', '912345614', 'random14@mail.com', ''),
('Customer15', 'Random Street, 15', '912345615', 'random15@mail.com', ''),
('Customer16', 'Random Street, 16', '912345616', 'random16@mail.com', ''),
('Customer17', 'Random Street, 17', '912345617', 'random17@mail.com', ''),
('Customer18', 'Random Street, 18', '912345618', 'random18@mail.com', ''),
('Customer19', 'Random Street, 19', '912345619', 'random19@mail.com', ''),
('Customer20', 'Random Street, 20', '912345620', 'random20@mail.com', '');


-- -----------------------------------------------------
-- Table `optica`.`glasses`
-- -----------------------------------------------------

-- Create 50 glasses 
INSERT INTO `optica`.`glasses` (`leftLens`, `rightLens`, `brand`, `provider`, `price`, `frameType`, `frameColor`, `glassColor`, `customer_name`, `soldBy`) VALUES
(1.9, 1.0, 'Brand1', 'Provider1', 1.0, 'float', 'black', 'black', 'Customer1', 'Employee1'),
(3.2, 1.0, 'Brand2', 'Provider2', 1.0, 'float', 'black', 'black', 'Customer2', 'Employee1'),
(2.3, 1.0, 'Brand3', 'Provider3', 1.0, 'float', 'black', 'black', 'Customer3', 'Employee1'),
(5.0, 1.0, 'Brand4', 'Provider4', 1.0, 'float', 'black', 'black', 'Customer4', 'Employee1'),
(2.5, 1.0, 'Brand5', 'Provider5', 1.0, 'float', 'black', 'black', 'Customer5', 'Employee3'),
(1.2, 1.0, 'Brand6', 'Provider6', 1.0, 'float', 'black', 'black', 'Customer6', 'Employee3'),
(0.3, 1.0, 'Brand7', 'Provider7', 1.0, 'float', 'black', 'black', 'Customer7', 'Employee1'),
(1.0, 1.0, 'Brand8', 'Provider8', 1.0, 'float', 'black', 'black', 'Customer8', 'Employee1'),
(1.9, 1.0, 'Brand9', 'Provider9', 1.0, 'float', 'black', 'black', 'Customer9', 'Employee3'),
(3.2, 1.0, 'Brand10', 'Provider10', 1.0, 'float', 'black', 'black', 'Customer10', 'Employee1'),
(2.3, 1.0, 'Brand10', 'Provider1', 1.0, 'float', 'black', 'black', 'Customer11', 'Employee4'),
(5.0, 1.0, 'Brand9', 'Provider2', 1.0, 'float', 'black', 'black', 'Customer12', 'Employee1'),
(2.5, 1.0, 'Brand8', 'Provider3', 1.0, 'float', 'black', 'black', 'Customer13', 'Employee1'),
(1.2, 1.0, 'Brand7', 'Provider4', 1.0, 'float', 'black', 'black', 'Customer14', 'Employee1'),
(0.3, 1.0, 'Brand6', 'Provider5', 1.0, 'float', 'black', 'black', 'Customer15', 'Employee3'),
(1.0, 1.0, 'Brand5', 'Provider6', 1.0, 'float', 'black', 'black', 'Customer16', 'Employee3'),
(1.9, 1.0, 'Brand4', 'Provider7', 1.0, 'float', 'black', 'black', 'Customer17', 'Employee1'),
(3.2, 1.0, 'Brand3', 'Provider8', 1.0, 'float', 'black', 'black', 'Customer18', 'Employee3'),
(2.3, 1.0, 'Brand2', 'Provider9', 1.0, 'float', 'black', 'black', 'Customer19', 'Employee1'),
(5.0, 1.0, 'Brand1', 'Provider10', 1.0, 'float', 'black', 'black', 'Customer20', 'Employee4'),
(2.5, 1.0, 'Brand9', 'Provider1', 1.0, 'float', 'black', 'black', 'Customer1', 'Employee3'),
(1.2, 1.0, 'Brand8', 'Provider2', 1.0, 'float', 'black', 'black', 'Customer2', 'Employee1'),
(0.3, 1.0, 'Brand7', 'Provider3', 1.0, 'float', 'black', 'black', 'Customer3', 'Employee1'),
(1.0, 1.0, 'Brand6', 'Provider4', 1.0, 'float', 'black', 'black', 'Customer4', 'Employee1'),
(1.2, 1.0, 'Brand5', 'Provider5', 1.0, 'float', 'black', 'black', 'Customer5', 'Employee4'),
(0.3, 1.0, 'Brand4', 'Provider6', 1.0, 'float', 'black', 'black', 'Customer6', 'Employee3'),
(1.0, 1.0, 'Brand3', 'Provider7', 1.0, 'float', 'black', 'black', 'Customer7', 'Employee1'),
(1.9, 1.0, 'Brand2', 'Provider8', 1.0, 'float', 'black', 'black', 'Customer8', 'Employee1'),
(3.2, 1.0, 'Brand1', 'Provider9', 1.0, 'float', 'black', 'black', 'Customer9', 'Employee4'),
(2.3, 1.0, 'Brand1', 'Provider10', 1.0, 'float', 'black', 'black', 'Customer10', 'Employee3'),
(5.0, 1.0, 'Brand9', 'Provider1', 1.0, 'float', 'black', 'black', 'Customer11', 'Employee3'),
(2.5, 1.0, 'Brand8', 'Provider2', 1.0, 'float', 'black', 'black', 'Customer12', 'Employee1'),
(1.2, 1.0, 'Brand7', 'Provider3', 1.0, 'float', 'black', 'black', 'Customer13', 'Employee1'),
(0.3, 1.0, 'Brand6', 'Provider4', 1.0, 'float', 'black', 'black', 'Customer14', 'Employee3'),
(1.0, 1.0, 'Brand5', 'Provider5', 1.0, 'float', 'black', 'black', 'Customer15', 'Employee4'),
(1.9, 1.0, 'Brand4', 'Provider6', 1.0, 'float', 'black', 'black', 'Customer16', 'Employee1'),
(3.2, 1.0, 'Brand3', 'Provider7', 1.0, 'float', 'black', 'black', 'Customer17', 'Employee4'),
(2.3, 1.0, 'Brand2', 'Provider8', 1.0, 'float', 'black', 'black', 'Customer18', 'Employee1'),
(5.0, 1.0, 'Brand1', 'Provider9', 1.0, 'float', 'black', 'black', 'Customer19', 'Employee4'),
(2.5, 1.0, 'Brand1', 'Provider10', 1.0, 'float', 'black', 'black', 'Customer20', 'Employee1'),
(1.2, 1.0, 'Brand1', 'Provider1', 1.0, 'float', 'black', 'black', 'Customer1', 'Employee4'),
(0.3, 1.0, 'Brand9', 'Provider2', 1.0, 'float', 'black', 'black', 'Customer2', 'Employee1'),
(1.0, 1.0, 'Brand8', 'Provider3', 1.0, 'float', 'black', 'black', 'Customer3', 'Employee1'),
(1.9, 1.0, 'Brand7', 'Provider4', 1.0, 'float', 'black', 'black', 'Customer4', 'Employee1'),
(3.2, 1.0, 'Brand6', 'Provider5', 1.0, 'float', 'black', 'black', 'Customer5', 'Employee1'),
(2.3, 1.0, 'Brand5', 'Provider6', 1.0, 'float', 'black', 'black', 'Customer6', 'Employee3'),
(5.0, 1.0, 'Brand4', 'Provider7', 1.0, 'float', 'black', 'black', 'Customer7', 'Employee4'),
(2.5, 1.0, 'Brand3', 'Provider8', 1.0, 'float', 'black', 'black', 'Customer8', 'Employee4'),
(1.2, 1.0, 'Brand2', 'Provider9', 1.0, 'float', 'black', 'black', 'Customer9', 'Employee3'),
(0.3, 1.0, 'Brand1', 'Provider10', 1.0, 'float', 'black', 'black', 'Customer10', 'Employee41.0');


-- QUERIES
SELECT COUNT(*) FROM glasses WHERE customer_name = 'Customer1' AND soldDate BETWEEN '2021-12-15' AND '2022-03-15';
SELECT DISTINCT(brand) FROM glasses WHERE soldBy = 'Employee1' AND EXTRACT(year FROM soldDate) = '2021';
SELECT * FROM provider WHERE provider_name IN (SELECT provider.provider_name FROM provider INNER JOIN glasses ON provider.provider_name = glasses.provider);