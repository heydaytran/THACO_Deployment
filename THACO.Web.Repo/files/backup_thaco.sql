﻿--
-- Script was generated by Devart dbForge Studio 2020 for MySQL, Version 9.0.338.0
-- Product home page: http://www.devart.com/dbforge/mysql/studio
-- Script date 4/26/2024 11:21:56 PM
-- Server version: 8.0.32
-- Client version: 4.1
--

-- 
-- Disable foreign keys
-- 
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

-- 
-- Set SQL mode
-- 
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- 
-- Set character set the client will use to send SQL statements to the server
--
SET NAMES 'utf8';

--
-- Set default database
--
USE `thaco-web`;

--
-- Drop table `bookmark_type`
--
DROP TABLE IF EXISTS bookmark_type;

--
-- Drop table `checker`
--
DROP TABLE IF EXISTS checker;

--
-- Drop table `customer`
--
DROP TABLE IF EXISTS customer;

--
-- Drop table `dossier`
--
DROP TABLE IF EXISTS dossier;

--
-- Drop table `manufacturer`
--
DROP TABLE IF EXISTS manufacturer;

--
-- Drop table `tai_lieu_goc`
--
DROP TABLE IF EXISTS tai_lieu_goc;

--
-- Drop table `time_sheet`
--
DROP TABLE IF EXISTS time_sheet;

--
-- Drop table `time_sheet_target`
--
DROP TABLE IF EXISTS time_sheet_target;

--
-- Drop procedure `Proc_GenEntity`
--
DROP PROCEDURE IF EXISTS Proc_GenEntity;

--
-- Drop function `SnakeToPascal`
--
DROP FUNCTION IF EXISTS SnakeToPascal;

--
-- Set default database
--
USE `thaco-web`;

DELIMITER $$

--
-- Create function `SnakeToPascal`
--
CREATE DEFINER = 'root'@'%'
FUNCTION SnakeToPascal (str varchar(200))
RETURNS varchar(200) CHARSET utf8mb4
NO SQL
BEGIN
  DECLARE n,
          pos int DEFAULT 1;
  DECLARE sub,
          proper varchar(128) DEFAULT '';

  IF LENGTH(TRIM(str)) > 0 THEN
    WHILE pos > 0 DO
      SET pos = LOCATE('_', TRIM(str), n);
      IF pos = 0 THEN
        SET sub = LOWER(TRIM(SUBSTR(TRIM(str), n)));
      ELSE
        SET sub = LOWER(TRIM(SUBSTR(TRIM(str), n, pos - n)));
      END IF;

      SET proper = CONCAT_WS('', proper, CONCAT(UPPER(LEFT(sub, 1)), SUBSTR(sub, 2)));
      SET n = pos + 1;
    END WHILE;
  END IF;

  RETURN TRIM(proper);
END
$$

--
-- Create procedure `Proc_GenEntity`
--
CREATE PROCEDURE Proc_GenEntity (IN tableName varchar(150))
SQL SECURITY INVOKER
COMMENT 'Tạo Entity'
BEGIN
  SELECT
    field
  FROM (SELECT
      CONCAT('public ',
      CASE WHEN
          DATA_TYPE = 'char' AND
          CHARACTER_MAXIMUM_LENGTH = 36 THEN 'Guid' WHEN DATA_TYPE = 'bit' THEN 'bool' WHEN
          DATA_TYPE = 'int' THEN 'int' WHEN DATA_TYPE = 'bidgint' THEN 'long' WHEN
          DATA_TYPE = 'tinyint' THEN 'int' WHEN DATA_TYPE = 'double' THEN 'decimal' WHEN
          DATA_TYPE = 'decimal' THEN 'decimal' WHEN DATA_TYPE = 'float' THEN 'decimal' WHEN
          DATA_TYPE = 'date' THEN 'DateTime' WHEN DATA_TYPE = 'datetime' THEN 'DateTime' WHEN
          DATA_TYPE = 'timestamp' THEN 'DateTime' ELSE 'string' END,
      ' ',
      CASE IS_NULLABLE WHEN 'YES' THEN '?' ELSE '' END,
      ' ',
      column_name,
      ' {get;set;}') AS field,
      100 AS gp,
      ordinal_position AS so
    FROM information_schema.COLUMNS
    WHERE TABLE_NAME = tableName
    AND TABLE_SCHEMA = 'thaco-web'
    UNION ALL
    SELECT
      '/// <summary>',
      10,
      ordinal_position
    FROM information_schema.COLUMNS
    WHERE TABLE_NAME = tableName
    AND TABLE_SCHEMA = 'thaco-web'
    UNION ALL
    SELECT
      CONCAT('/// ',
      CASE WHEN
          column_key = 'PRI' AND
          (column_comment IS NULL OR
          column_comment = '') THEN 'PK' ELSE column_comment END),
      20,
      ordinal_position
    FROM information_schema.COLUMNS
    WHERE TABLE_NAME = tableName
    AND TABLE_SCHEMA = 'thaco-web'
    UNION ALL
    SELECT
      '/// <summary>',
      30,
      ordinal_position
    FROM information_schema.COLUMNS
    WHERE TABLE_NAME = tableName
    AND TABLE_SCHEMA = 'thaco-web'
    UNION ALL
    SELECT
      '[Key]',
      40,
      ordinal_position
    FROM information_schema.COLUMNS
    WHERE TABLE_NAME = tableName
    AND column_key = 'PRI'
    AND TABLE_SCHEMA = 'thaco-web'
    UNION ALL
    SELECT
      '/// <summary>',
      -30,
      0
    UNION ALL
    SELECT
      CONCAT('/// ', table_comment),
      -29,
      0
    FROM information_schema.tables
    WHERE TABLE_NAME = tableName
    AND TABLE_SCHEMA = 'thaco-web'
    UNION ALL
    SELECT
      '/// <summary>',
      -28,
      0
    UNION ALL
    SELECT
      CONCAT('[Table("', LOWER(tableName), '")]'),
      -10,
      0
    UNION ALL
    SELECT
      CONCAT('public class ', SnakeToPascal(tableName), 'Entity'),
      -9,
      0
    UNION ALL
    SELECT
      '{',
      -8,
      0
    UNION ALL
    SELECT
      '}',
      1000,
      1000) AS T
  ORDER BY so, gp;

END
$$

DELIMITER ;

--
-- Create table `time_sheet_target`
--
CREATE TABLE time_sheet_target (
  time_sheet_target_id char(36) NOT NULL DEFAULT '',
  time_sheet_id char(36) NOT NULL DEFAULT '',
  deadline_checker_date datetime DEFAULT NULL,
  target varchar(255) DEFAULT NULL,
  created_date datetime DEFAULT NULL,
  created_by varchar(255) DEFAULT NULL,
  modified_date datetime DEFAULT NULL,
  modified_by varchar(255) DEFAULT NULL
)
ENGINE = INNODB,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_unicode_ci;

--
-- Create table `time_sheet`
--
CREATE TABLE time_sheet (
  time_sheet_id char(36) NOT NULL DEFAULT '',
  time_sheet_code varchar(50) DEFAULT NULL,
  task varchar(255) DEFAULT NULL,
  bookmark_type_id char(36) DEFAULT NULL,
  bookmark_type_code varchar(50) DEFAULT NULL,
  start_date datetime DEFAULT NULL COMMENT 'ngày bắt đầu công việc',
  contract varchar(50) DEFAULT NULL COMMENT 'mã đơn hàng',
  customer varchar(50) DEFAULT NULL COMMENT 'mã khách hàng',
  status varchar(20) DEFAULT NULL COMMENT 'trạng thái công việc(todo, doing, pending, done, complete, cancel)',
  status_date datetime DEFAULT NULL,
  complete tinyint DEFAULT 0,
  plan tinyint DEFAULT 0,
  deadline_customer_date datetime DEFAULT NULL,
  detail varchar(255) DEFAULT NULL,
  created_by varchar(255) DEFAULT NULL,
  created_date datetime DEFAULT NULL,
  modified_by varchar(255) DEFAULT NULL,
  modified_date datetime DEFAULT NULL,
  PRIMARY KEY (time_sheet_id)
)
ENGINE = INNODB,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_unicode_ci,
COMMENT = 'Hồ sơ';

--
-- Create index `UK_time_sheet_time_sheet_code` on table `time_sheet`
--
ALTER TABLE time_sheet
ADD UNIQUE INDEX UK_time_sheet_time_sheet_code (time_sheet_code);

--
-- Create table `tai_lieu_goc`
--
CREATE TABLE tai_lieu_goc (
  tai_lieu_goc_id char(36) DEFAULT NULL,
  stt varchar(255) DEFAULT NULL,
  ngay_nhan datetime DEFAULT NULL,
  ngay_gui datetime DEFAULT NULL,
  loai_giay_to varchar(255) DEFAULT NULL,
  san_pham varchar(255) DEFAULT NULL,
  ma_tra_cuu_online varchar(255) DEFAULT NULL,
  ghi_chu varchar(255) DEFAULT NULL,
  created_by varchar(255) DEFAULT NULL,
  created_date datetime DEFAULT NULL,
  modified_by varchar(255) DEFAULT NULL,
  modified_date datetime DEFAULT NULL
)
ENGINE = INNODB,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_unicode_ci,
COMMENT = 'Tài liệu gốc';

--
-- Create table `manufacturer`
--
CREATE TABLE manufacturer (
  manufacturer_id char(36) NOT NULL DEFAULT '',
  stt varchar(255) DEFAULT NULL,
  cong_ty varchar(255) DEFAULT NULL,
  dia_chi varchar(255) DEFAULT NULL,
  thong_tin_nhan_su varchar(255) DEFAULT NULL,
  chuyen_phat varchar(255) DEFAULT NULL,
  ghi_chu varchar(255) DEFAULT NULL,
  created_by varchar(255) DEFAULT NULL,
  created_date datetime DEFAULT NULL,
  modified_by varchar(255) DEFAULT NULL,
  modified_date datetime DEFAULT NULL,
  PRIMARY KEY (manufacturer_id)
)
ENGINE = INNODB,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_unicode_ci,
COMMENT = 'nhà chế tạo';

--
-- Create table `dossier`
--
CREATE TABLE dossier (
  dossier_id char(36) NOT NULL DEFAULT '',
  dossier_code varchar(50) DEFAULT NULL,
  contract_code varchar(50) DEFAULT NULL,
  bookmark_type_code varchar(50) DEFAULT NULL,
  dosage_form varchar(255) DEFAULT NULL,
  product_name varchar(255) DEFAULT NULL,
  api varchar(255) DEFAULT NULL,
  manufacturer varchar(255) DEFAULT NULL,
  applicant varchar(255) DEFAULT NULL,
  submission_code varchar(50) DEFAULT NULL,
  submission_date datetime DEFAULT NULL,
  status varchar(255) DEFAULT NULL,
  status_date datetime DEFAULT NULL,
  visa_No varchar(255) DEFAULT NULL,
  note varchar(255) DEFAULT NULL,
  created_by varchar(255) DEFAULT NULL,
  created_date datetime DEFAULT NULL,
  modified_by varchar(255) DEFAULT NULL,
  modified_date datetime DEFAULT NULL,
  PRIMARY KEY (dossier_id)
)
ENGINE = INNODB,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_unicode_ci,
COMMENT = 'Hồ sơ';

--
-- Create index `UK_dossier_dossier_code` on table `dossier`
--
ALTER TABLE dossier
ADD UNIQUE INDEX UK_dossier_dossier_code (dossier_code);

--
-- Create table `customer`
--
CREATE TABLE customer (
  customer_id char(36) NOT NULL DEFAULT '',
  stt varchar(255) DEFAULT NULL,
  cong_ty varchar(255) DEFAULT NULL,
  dia_chi varchar(255) DEFAULT NULL,
  thong_tin_nhan_su varchar(255) DEFAULT NULL,
  chuyen_phat varchar(255) DEFAULT NULL,
  ghi_chu varchar(255) DEFAULT NULL,
  created_by varchar(255) DEFAULT NULL,
  created_date datetime DEFAULT NULL,
  modified_by varchar(255) DEFAULT NULL,
  modified_date datetime DEFAULT NULL,
  PRIMARY KEY (customer_id)
)
ENGINE = INNODB,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_unicode_ci,
COMMENT = 'khách hàng';

--
-- Create table `checker`
--
CREATE TABLE checker (
  checker_id char(36) NOT NULL DEFAULT '',
  checker_code varchar(50) NOT NULL DEFAULT '',
  checker_name varchar(100) NOT NULL DEFAULT '',
  ref_x1 int NOT NULL DEFAULT 0 COMMENT 'Khối lượng việc  được giao trong tháng',
  ref_x2 int NOT NULL DEFAULT 0 COMMENT 'Khối lượng việc đã đạt trong tháng',
  ref_x3 int NOT NULL DEFAULT 0 COMMENT 'Khối lượng việc phát sinh có tiền',
  email varchar(50) DEFAULT NULL,
  phone_number varchar(20) DEFAULT NULL,
  password varchar(255) DEFAULT NULL,
  created_date datetime DEFAULT NULL,
  created_by varchar(255) DEFAULT NULL,
  modified_date datetime DEFAULT NULL,
  modified_by varchar(255) DEFAULT NULL,
  PRIMARY KEY (checker_id)
)
ENGINE = INNODB,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_unicode_ci,
COMMENT = 'Người dùng';

--
-- Create index `UK_checker_checker_code` on table `checker`
--
ALTER TABLE checker
ADD UNIQUE INDEX UK_checker_checker_code (checker_code);

--
-- Create table `bookmark_type`
--
CREATE TABLE bookmark_type (
  bookmark_type_id char(36) NOT NULL DEFAULT '',
  bookmark_type_code varchar(50) NOT NULL DEFAULT '',
  desciption varchar(255) DEFAULT NULL,
  workload int NOT NULL DEFAULT 0 COMMENT 'kl quy đổi mã hồ sơ',
  x3 tinyint DEFAULT 0 COMMENT 'đánh dấu mã việc đc thu tiền về',
  created_by varchar(255) DEFAULT NULL,
  created_date datetime DEFAULT NULL,
  modified_by varchar(255) DEFAULT NULL,
  modified_date datetime DEFAULT NULL,
  PRIMARY KEY (bookmark_type_id)
)
ENGINE = INNODB,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_unicode_ci,
COMMENT = 'Loại hồ sơ';

--
-- Create index `UK_bookmark_type_bookmark_type_code` on table `bookmark_type`
--
ALTER TABLE bookmark_type
ADD UNIQUE INDEX UK_bookmark_type_bookmark_type_code (bookmark_type_code);

-- 
-- Dumping data for table time_sheet_target
--
-- Table `thaco-web`.time_sheet_target does not contain any data (it is empty)

-- 
-- Dumping data for table time_sheet
--
-- Table `thaco-web`.time_sheet does not contain any data (it is empty)

-- 
-- Dumping data for table tai_lieu_goc
--
-- Table `thaco-web`.tai_lieu_goc does not contain any data (it is empty)

-- 
-- Dumping data for table manufacturer
--
-- Table `thaco-web`.manufacturer does not contain any data (it is empty)

-- 
-- Dumping data for table dossier
--
-- Table `thaco-web`.dossier does not contain any data (it is empty)

-- 
-- Dumping data for table customer
--
-- Table `thaco-web`.customer does not contain any data (it is empty)

-- 
-- Dumping data for table checker
--
-- Table `thaco-web`.checker does not contain any data (it is empty)

-- 
-- Dumping data for table bookmark_type
--
-- Table `thaco-web`.bookmark_type does not contain any data (it is empty)

-- 
-- Restore previous SQL mode
-- 
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;

-- 
-- Enable foreign keys
-- 
/*!40014 SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS */;