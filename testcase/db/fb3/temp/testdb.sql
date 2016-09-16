/********************* ROLES **********************/

/********************* UDFS ***********************/

/****************** SEQUENCES ********************/

CREATE SEQUENCE GEN_TABLE1_ID;
/******************** DOMAINS *********************/

CREATE DOMAIN MON$SEC_DATABASE
 AS char(7) CHARACTER SET ASCII
 NOT NULL
 COLLATE ASCII;
CREATE DOMAIN PK
 AS bigint
 NOT NULL
;
CREATE DOMAIN SEC$KEY
 AS varchar(10) CHARACTER SET UNICODE_FSS
 COLLATE UNICODE_FSS;
CREATE DOMAIN SEC$NAME_PART
 AS varchar(10) CHARACTER SET UNICODE_FSS
 COLLATE UNICODE_FSS;
CREATE DOMAIN SEC$USER_NAME
 AS varchar(10) CHARACTER SET UNICODE_FSS
 COLLATE UNICODE_FSS;
CREATE DOMAIN SEC$VALUE
 AS varchar(85) CHARACTER SET UNICODE_FSS
 COLLATE UNICODE_FSS;
/******************* PROCEDURES ******************/

/******************** TABLES **********************/

CREATE TABLE TABLE1
(
  INT1 integer,
  PK bigint NOT NULL,
  STR1 varchar(20),
  BO1 boolean,
  TEXTBLOB blob sub_type 1,
  BINBLOB blob sub_type 0,
  FLO1 float,
  DO1 double precision,
  TI1 time,
  DA1 date,
  TS1 timestamp,
  BCD1 numeric(12,3),
  BCD2 numeric(18,6),
  AR1 integer[0..4],
  BYTES7 char(7) CHARACTER SET OCTETS,
  VARBYTES10 varchar(10) CHARACTER SET OCTETS,
  GUID1 char(16) CHARACTER SET OCTETS,
  CONSTRAINT PK_TABLE1_1 PRIMARY KEY (PK)
);
/********************* VIEWS **********************/

/******************* EXCEPTIONS *******************/

/******************** TRIGGERS ********************/

SET TERM ^ ;
CREATE TRIGGER TABLE1_BI FOR TABLE1 ACTIVE
BEFORE insert POSITION 0
AS
DECLARE VARIABLE tmp DECIMAL(18,0);
BEGIN
  IF (NEW.PK IS NULL) THEN
    NEW.PK = GEN_ID(GEN_TABLE1_ID, 1);
  ELSE
  BEGIN
    tmp = GEN_ID(GEN_TABLE1_ID, 0);
    if (tmp < new.PK) then
      tmp = GEN_ID(GEN_TABLE1_ID, new.PK-tmp);
  END
END^
SET TERM ; ^

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON TABLE1 TO  SYSDBA WITH GRANT OPTION;

