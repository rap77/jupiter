--------------------------------------------------------
-- Archivo creado  - miércoles-febrero-13-2019   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table OP_DETALLE
--------------------------------------------------------

  CREATE TABLE "JUPITER"."OP_DETALLE" 
   (	"OPD_ODPID" NUMBER, 
	"OPD_RENGLON" NUMBER(5,0), 
	"OPD_CONCPAGO" NUMBER(10,0), 
	"OPD_CRDB" VARCHAR2(2 BYTE), 
	"OPD_MONTO" NUMBER(12,2)
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  TABLESPACE "JUPITER" ;
 

   COMMENT ON COLUMN "JUPITER"."OP_DETALLE"."OPD_ODPID" IS 'Id del MAestro de la orden de Pago';
 
   COMMENT ON COLUMN "JUPITER"."OP_DETALLE"."OPD_RENGLON" IS 'Renglon identificador del detalle de orden de pago';
 
   COMMENT ON COLUMN "JUPITER"."OP_DETALLE"."OPD_CONCPAGO" IS 'Codigo Concepto del pago';
 
   COMMENT ON COLUMN "JUPITER"."OP_DETALLE"."OPD_CRDB" IS 'Afectación del concepto debe o haber';
 
   COMMENT ON COLUMN "JUPITER"."OP_DETALLE"."OPD_MONTO" IS 'Monto del Concepto de la Orden de Pago';
 
   COMMENT ON TABLE "JUPITER"."OP_DETALLE"  IS 'Tabla que guarda el Detalle de Ordenes de Pago';
REM INSERTING into JUPITER.OP_DETALLE
SET DEFINE OFF;
--------------------------------------------------------
--  DDL for Index OP_DETALLE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "JUPITER"."OP_DETALLE_PK" ON "JUPITER"."OP_DETALLE" ("OPD_ODPID", "OPD_RENGLON") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS NOCOMPRESS LOGGING
  TABLESPACE "JUPITER" ;
--------------------------------------------------------
--  Constraints for Table OP_DETALLE
--------------------------------------------------------

  ALTER TABLE "JUPITER"."OP_DETALLE" ADD CONSTRAINT "OP_DETALLE_PK" PRIMARY KEY ("OPD_ODPID", "OPD_RENGLON")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS NOCOMPRESS LOGGING
  TABLESPACE "JUPIER"  ENABLE;
 
  ALTER TABLE "JUPITER"."OP_DETALLE" MODIFY ("OPD_ODPID" NOT NULL ENABLE);
 
  ALTER TABLE "JUPITER"."OP_DETALLE" MODIFY ("OPD_RENGLON" NOT NULL ENABLE);
