--------------------------------------------------------
-- Archivo creado  - lunes-diciembre-10-2018   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table ODP_TIPO
--------------------------------------------------------

  CREATE TABLE "JUPITER"."ODP_TIPO" 
   (	"OPT_CODIGO" NUMBER(5,0), 
	"OPT_DESCRIPCION" VARCHAR2(100 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "JUPITER" ;
 

   COMMENT ON COLUMN "JUPITER"."ODP_TIPO"."OPT_CODIGO" IS 'Codigo del tipo de orden de pago';
 
   COMMENT ON COLUMN "JUPITER"."ODP_TIPO"."OPT_DESCRIPCION" IS 'Descripcion del tipo de Pago';
 
   COMMENT ON TABLE "JUPITER"."ODP_TIPO"  IS 'Tabla que guarda los tipos de orden de pago 
Ej: Nomina, Nomina Primera Quincena, Pago de bienes y servicios, avances a justificar';
REM INSERTING into JUPITER.ODP_TIPO
SET DEFINE OFF;
--------------------------------------------------------
--  DDL for Index ODP_TIPO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "JUPITER"."ODP_TIPO_PK" ON "JUPITER"."ODP_TIPO" ("OPT_CODIGO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  Constraints for Table ODP_TIPO
--------------------------------------------------------

  ALTER TABLE "JUPITER"."ODP_TIPO" ADD CONSTRAINT "ODP_TIPO_PK" PRIMARY KEY ("OPT_CODIGO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
 
  ALTER TABLE "JUPITER"."ODP_TIPO" MODIFY ("OPT_CODIGO" NOT NULL ENABLE);
 
  ALTER TABLE "JUPITER"."ODP_TIPO" MODIFY ("OPT_DESCRIPCION" NOT NULL ENABLE);
