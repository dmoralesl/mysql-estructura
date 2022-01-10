
DROP SCHEMA IF EXISTS `youtube` ;

CREATE SCHEMA IF NOT EXISTS `youtube` DEFAULT CHARACTER SET utf8 ;
USE `youtube` ;

-- -----------------------------------------------------
-- Table `youtube`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`user` (
  `id_user` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(40) NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  `birth_date` DATE NULL,
  `sex` ENUM("male", "female") NULL,
  `country` VARCHAR(45) NULL,
  `postal_code` VARCHAR(5) NULL,
  `creation_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`id_user`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`video`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`video` (
  `id_video` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(45) NOT NULL,
  `description` LONGTEXT NULL,
  `size` FLOAT NOT NULL,
  `filename` VARCHAR(100) NOT NULL,
  `duration` FLOAT NOT NULL,
  `thumnail` VARCHAR(45) NULL,
  `views` INT NULL,
  `likes` INT NULL,
  `dislikes` INT NULL,
  `status` ENUM("public", "hidden", "private") NOT NULL,
  `user` INT NOT NULL,
  `date_published` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_video`),
  INDEX `user_video_idx` (`user` ASC) VISIBLE,
  CONSTRAINT `user_video`
    FOREIGN KEY (`user`)
    REFERENCES `youtube`.`user` (`id_user`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`label`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`label` (
  `id_label` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_label`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`video_labels`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`video_labels` (
  `id_video` INT NOT NULL,
  `id_label` INT NOT NULL,
  PRIMARY KEY (`id_video`, `id_label`),
  INDEX `label_video_idx` (`id_label` ASC) VISIBLE,
  CONSTRAINT `video_label`
    FOREIGN KEY (`id_video`)
    REFERENCES `youtube`.`video` (`id_video`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `label_video`
    FOREIGN KEY (`id_label`)
    REFERENCES `youtube`.`label` (`id_label`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `youtube`.`subscriptions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`subscriptions` (
  `id_user` INT NOT NULL,
  `id_channel` INT NOT NULL,
  PRIMARY KEY (`id_user`, `id_channel`),
  INDEX `user_subscription_user_idx` (`id_channel` ASC) VISIBLE,
  CONSTRAINT `user_subscription_channel`
    FOREIGN KEY (`id_user`)
    REFERENCES `youtube`.`user` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `user_subscription_user`
    FOREIGN KEY (`id_channel`)
    REFERENCES `youtube`.`user` (`id_user`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`reaction`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`reaction` (
  `id_user` INT NOT NULL,
  `id_video` INT NOT NULL,
  `creation_date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `reaction` SET("like", "dislike") NOT NULL,
  PRIMARY KEY (`id_user`, `id_video`),
  INDEX `video_dislike_user_idx` (`id_video` ASC) VISIBLE,
  CONSTRAINT `user_reaction_video`
    FOREIGN KEY (`id_user`)
    REFERENCES `youtube`.`user` (`id_user`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `video_reaction_user`
    FOREIGN KEY (`id_video`)
    REFERENCES `youtube`.`video` (`id_video`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`playlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`playlist` (
  `id_playlist` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `creation_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` ENUM("public", "private") NOT NULL,
  `user` INT NULL,
  PRIMARY KEY (`id_playlist`),
  INDEX `user_playlist_idx` (`user` ASC) VISIBLE,
  CONSTRAINT `user_playlist`
    FOREIGN KEY (`user`)
    REFERENCES `youtube`.`user` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`playlist_videos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`playlist_videos` (
  `id_playlist` INT NOT NULL,
  `id_video` INT NOT NULL,
  PRIMARY KEY (`id_playlist`, `id_video`),
  INDEX `video_playlist_idx` (`id_video` ASC) VISIBLE,
  CONSTRAINT `playlist_video`
    FOREIGN KEY (`id_playlist`)
    REFERENCES `youtube`.`playlist` (`id_playlist`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `video_playlist`
    FOREIGN KEY (`id_video`)
    REFERENCES `youtube`.`video` (`id_video`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`comment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`comment` (
  `id_comment` INT NOT NULL AUTO_INCREMENT,
  `text` LONGTEXT NOT NULL,
  `creation_datetime` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `user` INT NOT NULL,
  `video` INT NOT NULL,
  PRIMARY KEY (`id_comment`),
  INDEX `user_comment_idx` (`user` ASC) VISIBLE,
  INDEX `video_comment_idx` (`video` ASC) VISIBLE,
  CONSTRAINT `user_comment`
    FOREIGN KEY (`user`)
    REFERENCES `youtube`.`user` (`id_user`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `video_comment`
    FOREIGN KEY (`video`)
    REFERENCES `youtube`.`video` (`id_video`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`reaction_comment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`reaction_comment` (
  `id_user` INT NOT NULL,
  `id_comment` INT NOT NULL,
  `reaction` ENUM("like", "dislike") NOT NULL,
  `creation_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_user`, `id_comment`),
  INDEX `comment_user_idx` (`id_comment` ASC) VISIBLE,
  CONSTRAINT `user_reaction_comment`
    FOREIGN KEY (`id_user`)
    REFERENCES `youtube`.`user` (`id_user`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `comment_reaction_user`
    FOREIGN KEY (`id_comment`)
    REFERENCES `youtube`.`comment` (`id_comment`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;



-- DATA

-- User
INSERT INTO `youtube`.`user`
(`email`,
`password`,
`username`,
`birth_date`,
`sex`,
`country`,
`postal_code`)
VALUES
('fake1@mail.com', MD5('pass123'), 'user1', DATE('1999-01-01'), 'male', 'Morocco', '51001'),
('fake2@mail.com', MD5('pass123'), 'user2', DATE('1999-02-01'), 'female', 'Portugal', '51002'),
('fake3@mail.com', MD5('pass123'), 'user3', DATE('1999-03-01'), 'male', 'Spain', '51003'),
('fake4@mail.com', MD5('pass123'), 'user4', DATE('1999-04-01'), 'female', 'France', '51004'),
('fake5@mail.com', MD5('pass123'), 'user5', DATE('1999-05-01'), 'female', 'Spain', '51005'),
('fake6@mail.com', MD5('pass123'), 'user6', DATE('1999-06-01'), 'female', 'Italy', '51006'),
('fake7@mail.com', MD5('pass123'), 'user7', DATE('1999-07-01'), 'male', 'Germany', '51007'),
('fake8@mail.com', MD5('pass123'), 'user8', DATE('1999-08-01'), 'male', 'England', '51008'),
('fake9@mail.com', MD5('pass123'), 'user9', DATE('1999-09-01'), 'male', 'Germany', '51009'),
('fake10@mail.com', MD5('pass123'), 'user10', DATE('1999-10-01'), 'female', 'Poland', '51010');


-- Label
INSERT INTO `youtube`.`label`
(`id_label`,
`name`)
VALUES
(1, 'Gaming'),
(2, 'Science'),
(3, 'Sports'),
(4, 'DIY'),
(5, 'Beauty');

-- Videos
INSERT INTO `youtube`.`video`
(`title`,
`description`,
`size`,
`filename`,
`duration`,
`thumnail`,
`views`,
`likes`,
`dislikes`,
`status`,
`user`)
VALUES
('My video 1', 'This is my first video', 25554.5, 'video1.mp4', 12004, 'thumnail1.jpg', 24, 0, 5, 'public', 1),
('My video 2', 'This is my second video', 211193, 'video2.mp4', 322229, 'thumnail2.jpg', 19993, 1222, 355, 'public', 2),
('My video 3', 'This is my third video', 35100, 'video3.mp4', 12344, 'thumnail3.jpg', 2999111, 10442, 90, 'hidden', 3),
('My video 4', 'This is my fourth video', 9991.3, 'video4.mp4', 31123, 'thumnail4.jpg', 277543, 1456, 234, 'public', 4),
('My video 5', 'This is my fifth video', 5674443.2, 'video5.mp4', 90441, 'thumnail5.jpg', 908, 18, 3, 'hidden', 5),
('My video 6', 'This is my sixth video', 323222, 'video6.mp4', 9887, 'thumnail6.jpg', 109984, 108, 20, 'public', 6),
('My video 7', 'This is my seventh video', 512, 'video7.mp4', 321, 'thumnail7.jpg', 5554334, 1998, 2768, 'private', 7),
('My video 8', 'This is my eighth video', 434311.55, 'video8.mp4', 8773, 'thumnail8.jpg', 43, 1, 0, 'private', 9),
('My video 9', null, 7655543, 'video9.mp4', 9011,'thumnail9.jpg', 86774, 25, 90, 'public', 3),
('My video 10', '',  1222, 'video10.mp4', 87665, 'thumnail10.jpg', 12345, 87, 65, 'hidden', 1);


-- Video labels
INSERT INTO `youtube`.`video_labels`
(`id_video`, `id_label`)
VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(2, 5),
(3, 1),
(3, 2),
(3, 3),
(3, 4),
(3, 5),
(4, 1),
(4, 2),
(4, 3),
(4, 4),
(4, 5),
(5, 1),
(5, 2),
(5, 3),
(5, 4),
(5, 5),
(6, 1),
(6, 2),
(6, 3),
(6, 4),
(6, 5),
(7, 1),
(7, 2),
(7, 3),
(7, 4),
(7, 5),
(8, 1),
(8, 2),
(8, 3),
(8, 4),
(8, 5),
(9, 1),
(9, 2),
(9, 3),
(9, 4),
(9, 5),
(10, 1),
(10, 2),
(10, 3),
(10, 4),
(10, 5);



-- Reaction
INSERT INTO `youtube`.`reaction`
(`id_user`, `id_video`, `reaction`)
VALUES
(1, 1, 'like'),
(2, 1, 'dislike'),
(3, 1, 'like'),
(4, 1, 'dislike'),
(5, 1, 'like'),
(6, 1, 'dislike'),
(7, 1, 'like'),
(8, 1, 'dislike'),
(9, 1, 'like'),
(10, 1, 'dislike'),
(1, 2, 'like'),
(2, 2, 'dislike'),
(3, 2, 'like'),
(4, 2, 'dislike'),
(5, 2, 'like'),
(6, 2, 'dislike'),
(7, 2, 'like'),
(8, 2, 'dislike'),
(9, 2, 'like'),
(10, 2, 'dislike'),
(1, 3, 'like'),
(2, 3, 'dislike'),
(3, 3, 'like'),
(4, 3, 'dislike'),
(5, 3, 'like'),
(6, 3, 'dislike'),
(7, 3, 'like'),
(8, 3, 'dislike'),
(9, 3, 'like'),
(10, 3, 'dislike'),
(1, 4, 'like'),
(2, 4, 'dislike'),
(3, 4, 'like'),
(4, 4, 'dislike'),
(5, 4, 'like'),
(6, 4, 'dislike'),
(7, 4, 'like'),
(8, 4, 'dislike'),
(9, 4, 'like'),
(10, 4, 'dislike'),
(1, 5, 'like'),
(2, 5, 'dislike'),
(3, 5, 'like'),
(4, 5, 'dislike'),
(5, 5, 'like'),
(6, 5, 'dislike'),
(7, 5, 'like'),
(8, 5, 'dislike'),
(9, 5, 'like'),
(10, 5, 'dislike'),
(1, 6, 'like'),
(2, 6, 'dislike'),
(3, 6, 'like'),
(4, 6, 'dislike'),
(5, 6, 'like'),
(6, 6, 'dislike'),
(7, 6, 'like'),
(8, 6, 'dislike'),
(9, 6, 'like'),
(10, 6, 'dislike'),
(1, 7, 'like'),
(2, 7, 'dislike'),
(3, 7, 'like'),
(4, 7, 'dislike'),
(5, 7, 'like'),
(6, 7, 'dislike'),
(7, 7, 'like'),
(8, 7, 'dislike'),
(9, 7, 'like'),
(10, 7, 'dislike'),
(1, 8, 'like'),
(2, 8, 'dislike'),
(3, 8, 'like'),
(4, 8, 'dislike'),
(5, 8, 'like'),
(6, 8, 'dislike'),
(7, 8, 'like'),
(8, 8, 'dislike'),
(9, 8, 'like'),
(10, 8, 'dislike'),
(1, 9, 'like'),
(2, 9, 'dislike'),
(3, 9, 'like'),
(4, 9, 'dislike'),
(5, 9, 'like'),
(6, 9, 'dislike'),
(7, 9, 'like'),
(8, 9, 'dislike'),
(9, 9, 'like'),
(10, 9, 'dislike'),
(1, 10, 'like'),
(2, 10, 'dislike'),
(3, 10, 'like'),
(4, 10, 'dislike'),
(5, 10, 'like'),
(6, 10, 'dislike'),
(7, 10, 'like'),
(8, 10, 'dislike'),
(9, 10, 'like'),
(10, 10, 'dislike');


-- Playlist
INSERT INTO `youtube`.`playlist`
(`name`, `status`, `user`)
VALUES
('My playlist 1', 'public', 1),
('My playlist 2', 'private', 2),
('My playlist 3', 'public', 3),
('My playlist 4', 'public', 4),
('My playlist 5', 'public', 5),
('My playlist 6', 'private', 1),
('My playlist 7', 'private', 7),
('My playlist 8', 'public', 8),
('My playlist 9', 'public', 2),
('My playlist 10', 'private', 10),
('My playlist 11', 'private', 1),
('My playlist 12', 'public', 2),
('My playlist 13', 'private', 3),
('My playlist 14', 'public', 4),
('My playlist 15', 'public', 5);


-- Playlist videos
INSERT INTO `youtube`.`playlist_videos`
(`id_playlist`, `id_video`)
VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 9),
(1, 10),
(1, 11),
(1, 12),
(1, 13),
(1, 14),
(1, 15),
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(2, 5),
(2, 6),
(2, 7),
(2, 8),
(2, 9),
(2, 10),
(2, 11),
(2, 12),
(2, 13),
(2, 14),
(2, 15),
(3, 1),
(3, 2),
(3, 3),
(3, 4),
(3, 5),
(3, 6),
(3, 7),
(3, 8),
(3, 9),
(3, 10),
(3, 11),
(3, 12),
(3, 13),
(3, 14),
(3, 15),
(4, 1),
(4, 2),
(4, 3),
(4, 4),
(4, 5),
(4, 6),
(4, 7),
(4, 8),
(4, 9),
(4, 10),
(4, 11),
(4, 12),
(4, 13),
(4, 14),
(4, 15),
(5, 1),
(5, 2),
(5, 3),
(5, 4),
(5, 5),
(5, 6),
(5, 7),
(5, 8),
(5, 9),
(5, 10),
(5, 11),
(5, 12),
(5, 13),
(5, 14),
(5, 15),
(6, 1),
(6, 2),
(6, 3),
(6, 4),
(6, 5),
(6, 6),
(6, 7),
(6, 8),
(6, 9),
(6, 10),
(6, 11),
(6, 12),
(6, 13),
(6, 14),
(6, 15),
(7, 1),
(7, 2),
(7, 3),
(7, 4),
(7, 5),
(7, 6),
(7, 7),
(7, 8),
(7, 9),
(7, 10),
(7, 11),
(7, 12),
(7, 13),
(7, 14),
(7, 15),
(8, 1),
(8, 2),
(8, 3),
(8, 4),
(8, 5),
(8, 6),
(8, 7),
(8, 8),
(8, 9),
(8, 10),
(8, 11),
(8, 12),
(8, 13),
(8, 14),
(8, 15),
(9, 1),
(9, 2),
(9, 3),
(9, 4),
(9, 5),
(9, 6),
(9, 7),
(9, 8),
(9, 9),
(9, 10),
(9, 11),
(9, 12),
(9, 13),
(9, 14),
(9, 15),
(10, 1),
(10, 2),
(10, 3),
(10, 4),
(10, 5),
(10, 6),
(10, 7);


-- Channel
INSERT INTO `youtube`.`channel`
(`name`, `description`, `user`)
VALUES
('Channel 1', 'This is the first channel', 1),
('Channel 2', 'This is the second channel', 2),
('Channel 3', 'This is the third channel', 3),
('Channel 4', 'This is the fourth channel', 4),
('Channel 5', 'This is the fifth channel', 5),
('Channel 6', 'This is the sixth channel', 1),
('Channel 7', 'This is the seventh channel', 7),
('Channel 8', 'This is the eighth channel', 8),
('Channel 9', 'This is the ninth channel', 2),
('Channel 10', 'This is the tenth channel', 10),
('Channel 11', 'This is the eleventh channel', 1),
('Channel 12', 'This is the twelfth channel', 2),
('Channel 13', 'This is the thirteenth channel', 3),
('Channel 14', 'This is the fourteenth channel', 4),
('Channel 15', 'This is the fifteenth channel', 5);


-- Subscriptions
INSERT INTO `youtube`.`subscriptions`
(`id_channel`, `id_user`)
VALUES
-- Subscriptions for 15 channels from 10 users
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 9),
(1, 10),
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(2, 5),
(2, 6),
(2, 7),
(2, 8),
(2, 9),
(2, 10),
(3, 1),
(3, 2),
(3, 3),
(3, 4),
(3, 5),
(3, 6),
(3, 7),
(3, 8),
(3, 9),
(3, 10),
(4, 1),
(4, 2),
(4, 3),
(4, 4),
(4, 5),
(4, 6),
(4, 7),
(4, 8),
(4, 9),
(4, 10),
(5, 1),
(5, 2),
(5, 3),
(5, 4),
(5, 5),
(5, 6),
(5, 7),
(5, 8),
(5, 9),
(5, 10),
(6, 1),
(6, 2),
(6, 3),
(6, 4),
(6, 5),
(6, 6),
(6, 7),
(6, 8),
(6, 9),
(6, 10),
(7, 1),
(7, 2),
(7, 3),
(7, 4),
(7, 5),
(7, 6),
(7, 7),
(7, 8),
(7, 9),
(7, 10),
(8, 1),
(8, 2),
(8, 3),
(8, 4),
(8, 5),
(8, 6),
(8, 7),
(8, 8),
(8, 9),
(8, 10),
(9, 1),
(9, 2),
(9, 3);


-- Comments
INSERT INTO `youtube`.`comment`
(`user`, `video`, `text`)
VALUES
(1, 1, 'This is the first comment'),
(2, 1, 'This is the second comment'),
(3, 1, 'This is the third comment'),
(4, 1, 'This is the fourth comment'),
(5, 1, 'This is the fifth comment'),
(6, 1, 'This is the sixth comment'),
(7, 1, 'This is the seventh comment'),
(8, 1, 'This is the eighth comment'),
(9, 1, 'This is the ninth comment'),
(10, 1, 'This is the tenth comment'),
(1, 2, 'This is the first comment'),
(2, 2, 'This is the second comment'),
(3, 2, 'This is the third comment'),
(4, 2, 'This is the fourth comment'),
(5, 2, 'This is the fifth comment'),
(6, 2, 'This is the sixth comment'),
(7, 2, 'This is the seventh comment'),
(8, 2, 'This is the eighth comment'),
(9, 2, 'This is the ninth comment'),
(10, 2, 'This is the tenth comment'),
(1, 3, 'This is the first comment'),
(2, 3, 'This is the second comment'),
(3, 3, 'This is the third comment'),
(4, 3, 'This is the fourth comment'),
(5, 3, 'This is the fifth comment'),
(6, 3, 'This is the sixth comment'),
(7, 3, 'This is the seventh comment'),
(8, 3, 'This is the eighth comment'),
(9, 3, 'This is the ninth comment'),
(10, 3, 'This is the tenth comment'),
(1, 4, 'This is the first comment'),
(2, 4, 'This is the second comment'),
(3, 4, 'This is the third comment'),
(4, 4, 'This is the fourth comment'),
(5, 4, 'This is the fifth comment'),
(6, 4, 'This is the sixth comment'),
(7, 4, 'This is the seventh comment'),
(8, 4, 'This is the eighth comment');


-- Comment reactions
INSERT INTO `youtube`.`reaction_comment`
(`id_user`, `id_comment`, `reaction`)
VALUES
(1, 1, 'like'),
(2, 1, 'like'),
(3, 1, 'dislike'),
(4, 1, 'like'),
(5, 1, 'like'),
(6, 1, 'like'),
(7, 1, 'like'),
(8, 1, 'like'),
(9, 1, 'like'),
(10, 1, 'like'),
(1, 2, 'like'),
(2, 2, 'like'),
(3, 2, 'dislike'),
(4, 2, 'like'),
(5, 2, 'like'),
(6, 2, 'like'),
(7, 2, 'like'),
(8, 2, 'like'),
(9, 2, 'like'),
(10, 2, 'like'),
(1, 3, 'like'),
(2, 3, 'like'),
(3, 3, 'dislike'),
(4, 3, 'like'),
(5, 3, 'like'),
(6, 3, 'like'),
(7, 3, 'like'),
(8, 3, 'like'),
(9, 3, 'like'),
(10, 3, 'like'),
(1, 4, 'like'),
(2, 4, 'like'),
(3, 4, 'dislike'),
(4, 4, 'like'),
(5, 4, 'like'),
(6, 4, 'like'),
(7, 4, 'like'),
(8, 4, 'like'),
(9, 4, 'like'),
(10, 4, 'like');
