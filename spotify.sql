
DROP SCHEMA IF EXISTS `spotify` ;

CREATE SCHEMA IF NOT EXISTS `spotify` DEFAULT CHARACTER SET utf8 ;
USE `spotify` ;

-- -----------------------------------------------------
-- Table `spotify`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`user` (
  `id_user` INT NOT NULL AUTO_INCREMENT,
  `user_type` SET("free", "premium") NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `username` VARCHAR(50) NOT NULL,
  `birth_date` DATE NULL,
  `gender` ENUM("male", "female", "other") NULL,
  `country` VARCHAR(45) NULL,
  `postal_code` VARCHAR(5) NULL,
  PRIMARY KEY (`id_user`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE)
ENGINE = InnoDB


-- -----------------------------------------------------
-- Table `spotify`.`subscription`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`subscription` (
  `id_subscription` INT NOT NULL AUTO_INCREMENT,
  `user` INT NOT NULL,
  `start_subscription` DATETIME NOT NULL DEFAULT NOW(),
  `end_subscription` DATETIME NOT NULL,
  `payment` ENUM("card", "paypal") NOT NULL,
  PRIMARY KEY (`id_subscription`),
  INDEX `user_subscription_idx` (`user` ASC) VISIBLE,
  CONSTRAINT `user_subscription`
    FOREIGN KEY (`user`)
    REFERENCES `spotify`.`user` (`id_user`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`card`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`card` (
  `id_card` INT NOT NULL AUTO_INCREMENT,
  `user` INT NOT NULL,
  `card_code` VARCHAR(20) NULL,
  `expiration_date` DATE NULL,
  `cvv` SMALLINT NULL,
  `username` VARCHAR(100) NULL,
  PRIMARY KEY (`id_card`),
  INDEX `user_cards_idx` (`user` ASC) VISIBLE,
  CONSTRAINT `user_cards`
    FOREIGN KEY (`user`)
    REFERENCES `spotify`.`user` (`id_user`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`payment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`payment` (
  `id_payment` INT NOT NULL AUTO_INCREMENT,
  `user` INT NOT NULL,
  `card` INT NOT NULL,
  `amount` INT NOT NULL,
  `payment_date` DATETIME NULL DEFAULT NOW(),
  PRIMARY KEY (`id_payment`),
  INDEX `user_payment_idx` (`user` ASC) VISIBLE,
  CONSTRAINT `user_payment`
    FOREIGN KEY (`user`)
    REFERENCES `spotify`.`user` (`id_user`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `card_payment`
    FOREIGN KEY (`id_payment`)
    REFERENCES `spotify`.`card` (`id_card`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`playlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`playlist` (
  `id_playlist` INT NOT NULL AUTO_INCREMENT,
  `user` INT NOT NULL,
  `title` VARCHAR(150) NOT NULL,
  `songs` INT NOT NULL,
  `creation_date` DATETIME NULL DEFAULT NOW(),
  `status` ENUM("active", "deleted") NOT NULL DEFAULT 'active',
  `delete_date` DATETIME NULL,
  PRIMARY KEY (`id_playlist`),
  INDEX `user_playlist_idx` (`user` ASC) VISIBLE,
  CONSTRAINT `user_playlist`
    FOREIGN KEY (`user`)
    REFERENCES `spotify`.`user` (`id_user`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`musician`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`musician` (
  `id_musician` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) NOT NULL,
  `profile_img` VARCHAR(250) NULL,
  PRIMARY KEY (`id_musician`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`album`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`album` (
  `id_album` INT NOT NULL AUTO_INCREMENT,
  `musician` INT NOT NULL,
  `title` VARCHAR(200) NOT NULL,
  `publication_year` INT NOT NULL,
  `cover_img` VARCHAR(250) NULL,
  PRIMARY KEY (`id_album`),
  INDEX `musician_album_idx` (`musician` ASC) VISIBLE,
  CONSTRAINT `musician_album`
    FOREIGN KEY (`musician`)
    REFERENCES `spotify`.`musician` (`id_musician`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`song`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`song` (
  `id_song` INT NOT NULL AUTO_INCREMENT,
  `album` INT NOT NULL,
  `title` VARCHAR(200) NOT NULL,
  `duration` INT NOT NULL,
  `play` INT NOT NULL,
  PRIMARY KEY (`id_song`),
  INDEX `album_song_idx` (`album` ASC) VISIBLE,
  CONSTRAINT `album_song`
    FOREIGN KEY (`album`)
    REFERENCES `spotify`.`album` (`id_album`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`shared`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`shared` (
  `playlist` INT NOT NULL,
  `user` INT NOT NULL,
  `song` INT NOT NULL,
  `added_date` DATETIME NULL DEFAULT NOW(),
  PRIMARY KEY (`playlist`, `user`, `song`),
  INDEX `playlist_user_idx` (`user` ASC) VISIBLE,
  INDEX `song_shared_idx` (`song` ASC) VISIBLE,
  CONSTRAINT `playlist_shared`
    FOREIGN KEY (`playlist`)
    REFERENCES `spotify`.`playlist` (`id_playlist`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `user_shared`
    FOREIGN KEY (`user`)
    REFERENCES `spotify`.`user` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `song_shared`
    FOREIGN KEY (`song`)
    REFERENCES `spotify`.`song` (`id_song`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`follow`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`follow` (
  `id_user` INT NOT NULL,
  `id_musician` INT NOT NULL,
  PRIMARY KEY (`id_user`, `id_musician`),
  INDEX `musician_follow_idx` (`id_musician` ASC) VISIBLE,
  CONSTRAINT `user_follow`
    FOREIGN KEY (`id_user`)
    REFERENCES `spotify`.`user` (`id_user`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `musician_follow`
    FOREIGN KEY (`id_musician`)
    REFERENCES `spotify`.`musician` (`id_musician`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`related_musicians`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`related_musicians` (
  `musician` INT NOT NULL,
  `related_to` INT NOT NULL,
  PRIMARY KEY (`musician`, `related_to`),
  INDEX `related_to_musician_idx` (`related_to` ASC) VISIBLE,
  CONSTRAINT `related_musicians`
    FOREIGN KEY (`musician`)
    REFERENCES `spotify`.`musician` (`id_musician`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `related_to_musician`
    FOREIGN KEY (`related_to`)
    REFERENCES `spotify`.`musician` (`id_musician`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`favourtie_album`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`favourtie_album` (
  `id_user` INT NOT NULL,
  `id_album` INT NOT NULL,
  PRIMARY KEY (`id_user`, `id_album`),
  INDEX `album_favourite_idx` (`id_album` ASC) VISIBLE,
  CONSTRAINT `user_favourite_album`
    FOREIGN KEY (`id_user`)
    REFERENCES `spotify`.`user` (`id_user`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `album_favourite`
    FOREIGN KEY (`id_album`)
    REFERENCES `spotify`.`album` (`id_album`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`favourite_song`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`favourite_song` (
  `id_user` INT NOT NULL,
  `id_song` INT NOT NULL,
  PRIMARY KEY (`id_user`, `id_song`),
  INDEX `favourite_song_idx` (`id_song` ASC) VISIBLE,
  CONSTRAINT `user_favourite_song`
    FOREIGN KEY (`id_user`)
    REFERENCES `spotify`.`user` (`id_user`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `favourite_song`
    FOREIGN KEY (`id_song`)
    REFERENCES `spotify`.`song` (`id_song`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;



-- DATA 


-- User
INSERT INTO `spotify`.`user` (`user_type`, `email`, `password`, `username`, `birth_date`, `gender`, `country`, `postal_code`) 
VALUES
('free', 'mail1@mail.com', MD5('pass123'), 'user1', DATE('1991-01-01'), 'male', 'India', '00001'),
('free', 'mail2@mail.com', MD5('pass123'), 'user2', DATE('1992-01-01'), 'female', 'China', '00002'),
('premium', 'mail2@mail.com', MD5('pass123'), 'user3', DATE('1990-01-01'), 'male', 'India', '00003'),
('free', 'mail3@mail.com', MD5('pass123'), 'user4', DATE('1993-01-01'), 'female', 'China', '00004'),
('premium', 'mail4@mail.com', MD5('pass123'), 'user5', DATE('1994-01-01'), 'male', 'India', '00005'),
('premium', 'mail5@mail.com', MD5('pass123'), 'user6', DATE('1995-01-01'), 'male', 'China', '00006'),
('free', 'mail6@mail.com', MD5('pass123'), 'user7', DATE('1996-01-01'), 'female', 'China', '00007'),
('free', 'mail7@mail.com', MD5('pass123'), 'user8', DATE('1997-01-01'), 'male', 'China', '00008'),
('free', 'mail8@mail.com', MD5('pass123'), 'user9', DATE('1998-01-01'), 'female', 'India', '00009'),
('premium', 'mail9@mail.com', MD5('pass123'), 'user10', DATE('1999-01-01'), 'male', 'India', '00010'),
('premium', 'mail10@mail.com', MD5('pass123'), 'user11', DATE('1980-01-01'), 'other', 'India', '00011'),
('premium', 'mail11@mail.com', MD5('pass123'), 'user12', DATE('1970-01-01'), 'other', 'India', '00012');


-- Subscription
INSERT INTO `spotify`.`subscription` (`user`, `start_subscription`, `end_subscription`, `payment`) 
VALUES 
(3, DATE('2020-05-05'), '2025-05-05', 'paypal'),
(5, DATE('2021-05-05'), '2026-05-05', 'paypal'),
(6, DATE('2022-05-05'), '2027-05-05', 'card'),
(10, DATE('2023-05-05'), '2028-05-05', 'card'),
(11, DATE('2024-05-05'), '2029-05-05', 'paypal'),
(12, DATE('2025-05-05'), '2030-05-05', 'card');


-- Card
INSERT INTO `spotify`.`card` (`user`, `card_code`, `expiration_date`, `cvv`, `username`) 
VALUES
(3, null, null, null, 'userpaypal1'),
(5, null, null, null, 'userpaypal2'),
(6, '1234567890123456', '2025-05-05', '123', 'user4'),
(10, '1234567811123456', '2025-01-05', '125', 'user5'),
(11, null, null, null, 'userpaypal3'),
(12, '1234567890122456', '2025-04-05', '124', 'user6');

-- Payment
INSERT INTO `spotify`.`payment` (`user`, `card`, `amount`, `payment_date`) 
VALUES 
(3, 1, '100', DATE('2020-05-05')),
(3, 1, '100', DATE('2018-05-05')),
(5, 2, '200', DATE('2021-05-05')),
(6, 3, '300', DATE('2022-05-05')),
(10, 4, '400', DATE('2017-05-05')),
(10, 4, '400', DATE('2020-05-05')),
(10, 4, '400', DATE('2023-05-05')),
(11, 5, '500', DATE('2024-05-05')),
(12, 6, '600', DATE('2025-05-05'));


-- Playlist
INSERT INTO `spotify`.`playlist` (`user`, `title`, `songs`, `creation_date`, `status`, `delete_date`) 
VALUES 
(1, 'My super secret playlist 1', 25, DATE('2001-10-10'), 'active', null),
(1, 'Supremas de Mósteles TOP Hits', 25, DATE('2004-10-10'), 'deleted', DATE('2005-10-10')), 
(2, 'My super secret playlist 1', 25, DATE('2018-10-10'), 'active', null),
(3, 'My super secret playlist 1', 25, DATE('2021-10-10'), 'active', null),
(4, 'My super secret playlist 1', 25, DATE('2011-10-10'), 'deleted', DATE('2015-10-10'));

-- Musician 
INSERT INTO `spotify`.`musician` (`name`, `profile_img`) 
VALUES 
('Farrukito', 'notimage.png'),
('Bustamante', 'notimage.png'),
('Flos mariae', 'notimage.png'),
('Efecto pastillo', 'notimage.png'),
('Kisz', 'notimage.png'),
('Sensaciones', 'notimage.png');

-- Musician related
INSERT INTO `spotify`.`related_musicians` (`musician`, `related_to`) 
VALUES 
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(2, 3),
(2, 4),
(2, 5),
(2, 6),
(3, 4),
(3, 5),
(3, 6),
(4, 5),
(4, 6),
(5, 6);

-- Musician follows
INSERT INTO `spotify`.`follow` (`id_user`, `id_musician`) VALUES 
(1, 1),
(1, 2),
(1, 3),
(2, 5),
(3, 2),
(3, 1);

-- Album
INSERT INTO `spotify`.`album` (`musician`, `title`, `publication_year`, `cover_img`) 
VALUES 
(1, 'Album 1', 1990, 'noimage.png'),
(1, 'Album 2', 1991, 'noimage.png'),
(2, 'Album 1', 2015, 'noimage.png'),
(3, 'Album 1', 2002, 'noimage.png'),
(4, 'Album 1', 2021, 'noimage.png'),
(4, 'Album 2', 1923, 'noimage.png');

-- Favourite album
INSERT INTO `spotify`.`favourtie_album` (`id_user`, `id_album`) 
VALUES 
(1, 2),
(1, 3),
(2, 1),
(3, 1),
(4, 1),
(4, 2);

-- Song
INSERT INTO `spotify`.`song` (`album`, `title`, `duration`, `play`) 
VALUES 
(1, 'Song 1', 220, 5000),
(2, 'Song 2', 250, 3000),
(3, 'Song 3', 11, 50100),
(4, 'Song 4', 134, 200),
(5, 'Song 5', 186, 10),
(6, 'Song 6', 702, 169),
(1, 'Song 7', 112, 114422),
(1, 'Song 8', 240, 2415),
(4, 'Song 9', 453, 9582);

-- Favourite song
INSERT INTO `spotify`.`favourite_song` (`id_user`, `id_song`) 
VALUES 
(1, 1),
(1, 2),
(1, 3),
(2, 4),
(3, 5),
(4, 6),
(4, 7),
(4, 8),
(4, 9);


-- Shared playlist
INSERT INTO `spotify`.`shared` (`playlist`, `user`, `song`, `added_date`) 
VALUES 
(1, 2, 1, DATE('2020-03-01')),
(1, 2, 2, DATE('2022-03-01')),
(3, 1, 1, DATE('2021-03-01')),
(3, 5, 4, DATE('2024-03-01'));