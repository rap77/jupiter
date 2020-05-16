--------------------------------------------------------
--  DDL for Type STRING_AGG_TYPE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "FUNDAUC"."STRING_AGG_TYPE" as object
   (
      total varchar2(4000),
      static function
           ODCIAggregateInitialize(sctx IN OUT string_agg_type )
           return number,
      member function
           ODCIAggregateIterate(self IN OUT string_agg_type ,
                                value IN varchar2 )
           return number,
      member function
           ODCIAggregateTerminate(self IN string_agg_type,
                                  returnValue OUT  varchar2,
                                  flags IN number)
           return number,
      member function
           ODCIAggregateMerge(self IN OUT string_agg_type,
                              ctx2 IN string_agg_type)
           return number
 )
/
CREATE OR REPLACE EDITIONABLE TYPE BODY "FUNDAUC"."STRING_AGG_TYPE" 
   is
   static function ODCIAggregateInitialize(sctx IN OUT string_agg_type)
   return number
   is
   begin
       sctx := string_agg_type( null );
       return ODCIConst.Success;
   end;
   member function ODCIAggregateIterate(self IN OUT string_agg_type,
                                        value IN varchar2 )
   return number
   is
   begin
       self.total := self.total || ',' || value;
       return ODCIConst.Success;
   end;
   member function ODCIAggregateTerminate(self IN string_agg_type,
                                          returnValue OUT varchar2,
                                          flags IN number)
   return number
   is
   begin
       returnValue := ltrim(self.total,',');
       return ODCIConst.Success;
   end;
   member function ODCIAggregateMerge(self IN OUT string_agg_type,
                                      ctx2 IN string_agg_type)
  return number
   is
   begin
       self.total := self.total || ctx2.total;
       return ODCIConst.Success;
   end;
   end;



/
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_A57DFA36_DUMMY_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_A57DFA36_DUMMY_1 as table of number;
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_A57DFA36_183_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_A57DFA36_183_1 as table of "FUNDAUC"."SYS_PLSQL_A57DFA36_87_1";
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_A57DFA36_87_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_A57DFA36_87_1 as object (TIPO_ITEM VARCHAR2(2 BYTE),
FECHA DATE,
PRECIO1 NUMBER(14,2),
PRECIO2 NUMBER(14,2),
PRECIO3 NUMBER(14,2),
STATUS VARCHAR2(1 BYTE),
PRECIO4 NUMBER(14,2),
PRECIO5 NUMBER(14,2),
ID NUMBER,
HASH VARCHAR2(40 BYTE),
ROW_ID VARCHAR2(64 BYTE));
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_A9D531FF_DUMMY_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_A9D531FF_DUMMY_1 as table of number;
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_A9D531FF_149_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_A9D531FF_149_1 as table of "FUNDAUC"."SYS_PLSQL_A9D531FF_71_1";
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_A9D531FF_71_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_A9D531FF_71_1 as object (ID NUMBER,
CLIENTE_ID NUMBER,
FECHA DATE,
FACTURA_ID NUMBER,
DEPOSITO_ID NUMBER,
CREDITO VARCHAR2(2 BYTE),
MONTO NUMBER(12,2),
HASH VARCHAR2(40 BYTE),
ROW_ID VARCHAR2(64 BYTE));
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_D26CE444_DUMMY_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_D26CE444_DUMMY_1 as table of number;
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_D26CE444_135_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_D26CE444_135_1 as object (ID NUMBER,
FECHA_INS TIMESTAMP (6) ,
EST_MATRICULA NUMBER(10),
FECHA_PAGO DATE,
ESTATUS VARCHAR2(255 BYTE),
SECCION_ID NUMBER,
PERIODO_ID NUMBER,
CREADO_POR VARCHAR2(255 BYTE),
ES_EXONERADO CHAR(1 BYTE),
PROG_ACADEMICO NUMBER,
ES_SUSPENDIDO CHAR(1 BYTE),
COHORTE_ID NUMBER,
HORARIO_ID NUMBER,
MODIFICADO_POR VARCHAR2(255 BYTE),
MODIFICADO_EL DATE,
HASH VARCHAR2(40 BYTE),
ROW_ID VARCHAR2(64 BYTE));
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_D26CE444_285_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_D26CE444_285_1 as table of "FUNDAUC"."SYS_PLSQL_D26CE444_135_1";
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_D3F5E14_DUMMY_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_D3F5E14_DUMMY_1 as table of number;
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_D3F5E14_47_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_D3F5E14_47_1 as object (ID_CONDICION VARCHAR2(2 BYTE),
DESCRIPCION VARCHAR2(30 BYTE),
DESCUENTO VARCHAR2(10 BYTE),
PORCENTAJE NUMBER(10,2),
HASH VARCHAR2(40 BYTE),
ROW_ID VARCHAR2(64 BYTE));
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_D3F5E14_98_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_D3F5E14_98_1 as table of "FUNDAUC"."SYS_PLSQL_D3F5E14_47_1";
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_D984D45A_DUMMY_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_D984D45A_DUMMY_1 as table of number;
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_D984D45A_183_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_D984D45A_183_1 as table of "FUNDAUC"."SYS_PLSQL_D984D45A_87_1";
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_D984D45A_87_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_D984D45A_87_1 as object (REFERENCIA VARCHAR2(20 BYTE),
FECHA_EMI DATE,
ID_BANCO NUMBER(2),
MONTO NUMBER(14,2),
SEDE VARCHAR2(5 BYTE),
USUARIO VARCHAR2(50 BYTE),
STATUS VARCHAR2(1 BYTE),
FORMA_PAGO NUMBER(2),
ID NUMBER,
HASH VARCHAR2(40 BYTE),
ROW_ID VARCHAR2(64 BYTE));
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_FD56EEDC_DUMMY_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_FD56EEDC_DUMMY_1 as table of number;
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_FD56EEDC_111_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_FD56EEDC_111_1 as object (ID NUMBER,
SECCION_ID NUMBER,
CODIGO_SEC VARCHAR2(50 BYTE),
METODO_ID VARCHAR2(20 BYTE),
NIVEL NUMBER(2),
PERIODO_ID NUMBER,
HORARIO_ID NUMBER,
MODALIDAD_ID NUMBER,
CEDULA_PROF VARCHAR2(20 BYTE),
F_INICIO DATE,
F_FIN DATE,
ESTATUS VARCHAR2(20 BYTE),
HASH VARCHAR2(40 BYTE),
ROW_ID VARCHAR2(64 BYTE));
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_FD56EEDC_234_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_FD56EEDC_234_1 as table of "FUNDAUC"."SYS_PLSQL_FD56EEDC_111_1";
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_103C5D84_DUMMY_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_103C5D84_DUMMY_1 as table of number;
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_103C5D84_231_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_103C5D84_231_1 as object (CEDULA_EST NUMBER(10),
NACIONALIDAD CHAR(1 BYTE),
NOMBRE VARCHAR2(50 BYTE),
TELF_HAB VARCHAR2(14 BYTE),
TELF_CEL VARCHAR2(14 BYTE),
CIUDAD NUMBER(10),
ESTADO NUMBER(10),
EMAIL VARCHAR2(50 BYTE),
SEXO CHAR(1 BYTE),
EDO_CIVIL VARCHAR2(20 BYTE),
GRADO_INS VARCHAR2(20 BYTE),
PROFESION NUMBER,
FECHA_NAC DATE,
STATUS VARCHAR2(2 BYTE),
ID_TIPO_EST VARCHAR2(1 BYTE),
RIF VARCHAR2(16 BYTE),
MATRICULA NUMBER(10),
SEDE VARCHAR2(3 BYTE),
CONDICION_ESPECIAL VARCHAR2(2 BYTE),
APELLIDO VARCHAR2(30 BYTE),
ZONA NUMBER,
CEDULA_REP VARCHAR2(16 BYTE),
DIRECCION VARCHAR2(500 BYTE),
CREADO_POR VARCHAR2(30 BYTE),
CREADO_EL DATE,
MODIFICADO_POR VARCHAR2(30 BYTE),
MODIFICADO_EL DATE,
HASH VARCHAR2(40 BYTE),
ROW_ID VARCHAR2(64 BYTE));
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_103C5D84_489_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_103C5D84_489_1 as table of "FUNDAUC"."SYS_PLSQL_103C5D84_231_1";
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_4324232B_DUMMY_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_4324232B_DUMMY_1 as table of number;
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_4324232B_167_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_4324232B_167_1 as object (ID_SECCION VARCHAR2(50 BYTE),
ID_METODO VARCHAR2(10 BYTE),
NIVEL NUMBER(2),
ID_SALON NUMBER(3),
TOPE NUMBER(2),
STATUS CHAR(1 BYTE),
ID_EDIF NUMBER(3),
HORARIO VARCHAR2(17 BYTE),
CEDULA_PROF NUMBER(10),
MODALIDAD NUMBER(3),
FEC_INICIO DATE,
PERIODO NUMBER,
ID_HORARIO NUMBER(3),
ID_CALENDARIO NUMBER,
ID NUMBER,
CREADO_POR VARCHAR2(255 BYTE),
CREADO_EL DATE,
MODIFICADO_POR VARCHAR2(255 BYTE),
MODIFICADO_EL DATE,
HASH VARCHAR2(40 BYTE),
ROW_ID VARCHAR2(64 BYTE));
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_4324232B_353_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_4324232B_353_1 as table of "FUNDAUC"."SYS_PLSQL_4324232B_167_1";
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_4401B2CE_DUMMY_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_4401B2CE_DUMMY_1 as table of number;
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_4401B2CE_200_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_4401B2CE_200_1 as table of "FUNDAUC"."SYS_PLSQL_4401B2CE_95_1";
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_4401B2CE_95_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_4401B2CE_95_1 as object (RENGLON NUMBER(12),
TIPO_ITEM VARCHAR2(3 BYTE),
ITEM VARCHAR2(20 BYTE),
DESCRIPCION VARCHAR2(255 BYTE),
CANTIDAD NUMBER(8,2),
P_UNIDAD NUMBER(14,2),
BS_DESCUENTO NUMBER(14,2),
SUBTOTAL NUMBER(14,2),
MATERIALES_ID NUMBER,
FACTURA_ID NUMBER,
HASH VARCHAR2(40 BYTE),
ROW_ID VARCHAR2(64 BYTE));
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_48C7DF34_DUMMY_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_48C7DF34_DUMMY_1 as table of number;
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_48C7DF34_199_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_48C7DF34_199_1 as object (ID_FACT NUMBER(8),
TIPO VARCHAR2(2 BYTE),
CEDULA_EST NUMBER(10),
NOMBRE_CLIENTE VARCHAR2(100 BYTE),
FECHA_EMI DATE,
MONTO NUMBER(14,2),
P_IVA NUMBER(5,2),
MONTO_IVA NUMBER(14,2),
FLETE NUMBER(14,2),
BS_DESCUENTO NUMBER(14,2),
DIR_FISCAL VARCHAR2(500 BYTE),
RIF VARCHAR2(16 BYTE),
STATUS VARCHAR2(2 BYTE),
PROGRAMA VARCHAR2(3 BYTE),
PROG_ACADEMICO NUMBER(2),
CREADO_POR VARCHAR2(30 BYTE),
MONTO_EXENTO NUMBER(14,2),
BASE_IMPONIBLE NUMBER(14,2),
ID NUMBER,
CREADO_EL DATE,
FACTURADO_POR VARCHAR2(30 BYTE),
OBSERVACIONES VARCHAR2(2000 BYTE),
ESCREDITO CHAR(1 BYTE),
HASH VARCHAR2(40 BYTE),
ROW_ID VARCHAR2(64 BYTE));
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_48C7DF34_421_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_48C7DF34_421_1 as table of "FUNDAUC"."SYS_PLSQL_48C7DF34_199_1";
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_5F389762_DUMMY_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_5F389762_DUMMY_1 as table of number;
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_5F389762_149_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_5F389762_149_1 as table of "FUNDAUC"."SYS_PLSQL_5F389762_71_1";
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_5F389762_71_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_5F389762_71_1 as object (ID_CALENDARIO NUMBER(3),
PERIODO NUMBER(6),
FECHA_INI DATE,
FECHA_FIN DATE,
MODALIDAD NUMBER(2),
PERIODO_ACTIVO CHAR(1 BYTE),
ID NUMBER,
HASH VARCHAR2(40 BYTE),
ROW_ID VARCHAR2(64 BYTE));
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_563E914C_DUMMY_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_563E914C_DUMMY_1 as table of number;
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_563E914C_31_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_563E914C_31_1 as object (DEPOSITO_ID NUMBER,
FACTURA_ID NUMBER,
HASH VARCHAR2(40 BYTE),
ROW_ID VARCHAR2(64 BYTE));
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_563E914C_64_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_563E914C_64_1 as table of "FUNDAUC"."SYS_PLSQL_563E914C_31_1";
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_6C2F9E7E_DUMMY_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_6C2F9E7E_DUMMY_1 as table of number;
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_6C2F9E7E_47_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_6C2F9E7E_47_1 as object (ID_CALENDARIO NUMBER(3),
DESCRIPCION VARCHAR2(200 BYTE),
ACTIVO CHAR(1 BYTE),
TIPO_CAL CHAR(1 BYTE),
HASH VARCHAR2(40 BYTE),
ROW_ID VARCHAR2(64 BYTE));
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_6C2F9E7E_98_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_6C2F9E7E_98_1 as table of "FUNDAUC"."SYS_PLSQL_6C2F9E7E_47_1";
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_61F81DB9_DUMMY_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_61F81DB9_DUMMY_1 as table of number;
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_61F81DB9_132_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_61F81DB9_132_1 as table of "FUNDAUC"."SYS_PLSQL_61F81DB9_63_1";
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_61F81DB9_63_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_61F81DB9_63_1 as object (ID NUMBER,
MATRICULA NUMBER,
EVENTO_ID NUMBER,
FECHA TIMESTAMP (6) ,
METADATA CLOB,
OBSERVACION VARCHAR2(4000 BYTE),
HASH VARCHAR2(40 BYTE),
ROW_ID VARCHAR2(64 BYTE));
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_8FB2B9A5_DUMMY_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_8FB2B9A5_DUMMY_1 as table of number;
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_8FB2B9A5_207_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_8FB2B9A5_207_1 as object (CODIGO VARCHAR2(20 BYTE),
ID_HORARIO NUMBER,
ID_MODALIDAD NUMBER(2),
COHORTE NUMBER(3),
CUPO NUMBER(5),
COSTO NUMBER(14,2),
INICIAL NUMBER(14,2),
COSTO_CUOTA NUMBER(14,2),
CUOTAS NUMBER(3),
STATUS CHAR(1 BYTE),
ID_CIUDAD NUMBER,
ID NUMBER,
TIPO_DIPLO VARCHAR2(15 BYTE),
CREADO_POR VARCHAR2(255 BYTE),
CREADO_EL DATE,
MODIFICADO_POR VARCHAR2(255 BYTE),
MODIFICADO_EL DATE,
DIPLOMADO_ID NUMBER,
PERIODO NUMBER,
ID_CALENDARIO NUMBER,
NIVEL NUMBER,
ID_METODO NUMBER,
EMPRESA NUMBER,
FACILITADOR NUMBER(10),
HASH VARCHAR2(40 BYTE),
ROW_ID VARCHAR2(64 BYTE));
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_8FB2B9A5_438_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_8FB2B9A5_438_1 as table of "FUNDAUC"."SYS_PLSQL_8FB2B9A5_207_1";
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_9E128FDB_DUMMY_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_9E128FDB_DUMMY_1 as table of number;
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_9E128FDB_135_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_9E128FDB_135_1 as object (ID_MAT VARCHAR2(50 BYTE),
TIPO VARCHAR2(3 BYTE),
DESCRIPCION VARCHAR2(255 BYTE),
ID_CURSO VARCHAR2(10 BYTE),
EVENTO NUMBER(2),
NIVEL NUMBER(2),
IVA_EXENTO CHAR(1 BYTE),
ACTIVO CHAR(1 BYTE),
ID NUMBER,
SECCION_ID NUMBER,
CREADO_POR VARCHAR2(255 BYTE),
CREADO_EL DATE,
MODIFICADO_POR VARCHAR2(255 BYTE),
MODIFICADO_EL DATE,
COHORTE_ID NUMBER,
HASH VARCHAR2(40 BYTE),
ROW_ID VARCHAR2(64 BYTE));
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_9E128FDB_285_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_9E128FDB_285_1 as table of "FUNDAUC"."SYS_PLSQL_9E128FDB_135_1";
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_93F503A2_DUMMY_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_93F503A2_DUMMY_1 as table of number;
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_93F503A2_127_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_93F503A2_127_1 as object (CEDULA NUMBER(10),
NOMBRE_USUARIO VARCHAR2(50 BYTE),
CONTRASENA VARCHAR2(255 BYTE),
ID_ROL NUMBER(3),
EMAIL VARCHAR2(100 BYTE),
NOMBRE VARCHAR2(50 BYTE),
CIA NUMBER(2),
PROG_ACADEMICO NUMBER(2),
ACTIVO CHAR(1 BYTE),
BLOQUEADO CHAR(1 BYTE),
CREADO_POR VARCHAR2(100 BYTE),
CREADO_EL DATE,
MODIFICADO_POR VARCHAR2(100 BYTE),
MODIFICADO_EL DATE,
HASH VARCHAR2(40 BYTE),
ROW_ID VARCHAR2(64 BYTE));
-- No se ha podido presentar el DDL TYPE para el objeto FUNDAUC.SYS_PLSQL_93F503A2_268_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE TYPE           SYS_PLSQL_93F503A2_268_1 as table of "FUNDAUC"."SYS_PLSQL_93F503A2_127_1";
