-- CAMBIO TABLA COHORTES
ALTER TABLE COHORTES 
DROP COLUMN FECHA_INI;

ALTER TABLE COHORTES 
DROP COLUMN FECHA_FIN;

ALTER TABLE COHORTES 
ADD (PERIODO NUMBER );

ALTER TABLE COHORTES RENAME COLUMN CANT_ACTUAL TO CUPO;

ALTER TABLE COHORTES  
MODIFY (ID_HORARIO NUMBER );

ALTER TABLE COHORTES 
ADD (ID_CALENDARIO NUMBER );

ALTER TABLE COHORTES 
ADD (NIVEL NUMBER );

ALTER TABLE COHORTES 
ADD (ID_METODO NUMBER );

ALTER TABLE COHORTES RENAME COLUMN CIUDAD TO ID_CIUDAD;

ALTER TABLE COHORTES  
MODIFY (ID_CIUDAD NUMBER );

ALTER TABLE COHORTES 
ADD (EMPRESA NUMBER );

ALTER TABLE COHORTES 
DROP COLUMN ID_DIPLOMADO;

ALTER TABLE COHORTES RENAME COLUMN DIPLOMADOS_ID TO DIPLOMADO_ID;

CREATE SEQUENCE COHORTES_SEQ;

CREATE OR REPLACE TRIGGER COHORTES_TRG 
BEFORE INSERT OR UPDATE ON COHORTES 
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT COHORTES_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
      :NEW.CREADO_POR := coalesce(sys_context('APEX$SESSION', 'app_user'), regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), sys_context('userenv', 'session_user'));
      :NEW.CREADO_EL := SYSDATE;

    ELSIF UPDATING THEN
      :NEW.MODIFICADO_POR := coalesce(sys_context('APEX$SESSION', 'app_user'), regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), sys_context('userenv', 'session_user'));
      :NEW.MODIFICADO_EL := SYSDATE;
    END IF;
  END COLUMN_SEQUENCES;
END;
/

ALTER TABLE TIPO_MATERIAL RENAME COLUMN FVTC TO USA_SECCION;

ALTER TABLE TIPO_MATERIAL  
MODIFY (USA_SECCION DEFAULT 'N' NOT NULL);

UPDATE "FUNDAUC"."TIPO_MATERIAL" SET USA_SECCION = 'S' WHERE ABREV = 'IC';
UPDATE "FUNDAUC"."TIPO_MATERIAL" SET CFP = 'N' WHERE CFP IS NULL;
UPDATE "FUNDAUC"."TIPO_MATERIAL" SET USA_SECCION = 'S' WHERE ABREV = 'DP';
UPDATE "FUNDAUC"."TIPO_MATERIAL" SET USA_SECCION = 'S' WHERE ABREV = 'C';
UPDATE "FUNDAUC"."TIPO_MATERIAL" SET USA_SECCION = 'S' WHERE ABREV = 'PC';
UPDATE "FUNDAUC"."TIPO_MATERIAL" SET USA_SECCION = 'N' WHERE ABREV = 'O';


--CAMBIOS TABLA CLIENTES

begin
  for cur in (select fk.owner, fk.constraint_name , fk.table_name 
    from all_constraints fk, all_constraints pk 
     where fk.CONSTRAINT_TYPE = 'R' and 
           pk.owner = 'FUNDAUC' and
           fk.r_owner = pk.owner and
           fk.R_CONSTRAINT_NAME = pk.CONSTRAINT_NAME and 
           pk.TABLE_NAME = 'CLIENTES') loop
    execute immediate 'ALTER TABLE "'||cur.owner||'"."'||cur.table_name||'" MODIFY CONSTRAINT "'||cur.constraint_name||'" DISABLE';
  end loop;
end;
/

begin
  for cur in (select owner, constraint_name , table_name 
    from all_constraints
     where owner = 'FUNDAUC' and
           TABLE_NAME = 'CLIENTES') loop
     execute immediate 'ALTER TABLE '||cur.owner||'.'||cur.table_name||' MODIFY CONSTRAINT "'||cur.constraint_name||'" DISABLE ';
  end loop;
end;
/

delete from clientes;

ALTER TABLE CLIENTES 
DROP CONSTRAINT EMPRESAS_PK;

ALTER TABLE CLIENTES 
ADD (ID NUMBER NOT NULL);

ALTER TABLE CLIENTES
ADD CONSTRAINT CLIENTES_PK PRIMARY KEY 
(
  ID 
)
ENABLE;

ALTER TABLE CLIENTES  
MODIFY (RIF NOT NULL);

ALTER TABLE CLIENTES
ADD CONSTRAINT CLIENTES_UK1 UNIQUE 
(
  RIF 
)
USING INDEX SYS_C0018547
ENABLE;

ALTER TABLE CLIENTES  
MODIFY (RIF NOT NULL);

CREATE SEQUENCE CLIENTES_SEQ;

CREATE OR REPLACE TRIGGER CLIENTES_TRG 
BEFORE INSERT ON CLIENTES 
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT CLIENTES_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/

-- CAMBIO TABLA INSCRIPCIONES
ALTER TABLE INSCRIPCIONES RENAME COLUMN FACTURA_ID TO PERIODO_ID;

ALTER TABLE INSCRIPCIONES 
ADD (PROG_ACADEMICO NUMBER );

exec tapi_gen2.create_tapi_package (p_table_name => 'INSCRIPCIONES', p_compile_table_api => TRUE);

update inscripciones set estatus = 'AXC'
where id in (select inscripcion_id from factura f, inscripcion_factura if where f.id=if.factura_id and id_fact is null and status='PC');

update inscripciones set estatus = 'AP'
where id in (select inscripcion_id from factura f, inscripcion_factura if where f.id=if.factura_id and id_fact is not null and status='V');

update inscripciones set estatus = 'AN'
where id in (select inscripcion_id from factura f, inscripcion_factura if where f.id=if.factura_id and status = 'A');

update inscripciones i set periodo_id = (select periodo from secciones where id = i.seccion_id);

update inscripciones i set prog_academico = (select prog_academico from factura where inscripcion_id = i.id);

--CAMBIO TABLA FACTURA
ALTER TABLE FACTURA 
ADD (ESCREDITO CHAR(1) DEFAULT 'N' NOT NULL);

COMMENT ON COLUMN FACTURA.ESCREDITO IS 'Si es A credito o al contado';

ALTER TABLE FACTURA 
DROP CONSTRAINT FACTURA_FK1;

ALTER TABLE FACTURA 
DROP COLUMN INSCRIPCION_ID;

exec tapi_gen2.create_tapi_package (p_table_name => 'FACTURA', p_compile_table_api => TRUE)



--------------------------------------------------------
--  DDL for Table INSCRIPCION_FACTURA
--------------------------------------------------------

  CREATE TABLE "FUNDAUC"."INSCRIPCION_FACTURA" 
   (	"INSCRIPCION_ID" NUMBER, 
	"FACTURA_ID" NUMBER
   );

   COMMENT ON COLUMN "FUNDAUC"."INSCRIPCION_FACTURA"."INSCRIPCION_ID" IS 'Id de la inscripcion';
--------------------------------------------------------
--  DDL for Index INSCRIPCION_FACTURA_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "FUNDAUC"."INSCRIPCION_FACTURA_PK" ON "FUNDAUC"."INSCRIPCION_FACTURA" ("INSCRIPCION_ID", "FACTURA_ID");
--------------------------------------------------------
--  Constraints for Table INSCRIPCION_FACTURA
--------------------------------------------------------

  ALTER TABLE "FUNDAUC"."INSCRIPCION_FACTURA" MODIFY ("INSCRIPCION_ID" NOT NULL ENABLE);
  ALTER TABLE "FUNDAUC"."INSCRIPCION_FACTURA" MODIFY ("FACTURA_ID" NOT NULL ENABLE);
  ALTER TABLE "FUNDAUC"."INSCRIPCION_FACTURA" ADD CONSTRAINT "INSCRIP_FAC_PK" PRIMARY KEY ("INSCRIPCION_ID", "FACTURA_ID")
  USING INDEX (CREATE UNIQUE INDEX "FUNDAUC"."INSCRIPCION_FACTURA_PK" ON "FUNDAUC"."INSCRIPCION_FACTURA" ("INSCRIPCION_ID", "FACTURA_ID")
  
  
  -- INSER DATA NUEVA
INSERT INTO "FUNDAUC"."FORMA_PAGO" (ID_PAGO, DESCRIPCION, VENCIMIENTO, TIPO) VALUES ('6', 'CUENTA X COBRAR', '0', 'F');

INSERT INTO "FUNDAUC"."PROGRAMA_ACADEMICO" (ID, DESCRIPCION, ACTIVO) VALUES ('7', 'IN COMPANY', 'S');

  
insert into inscripcion_factura
select i.id inscripcion_id,f.id from inscripciones i, factura_bak f
where i.id=f.inscripcion_id;

CREATE SEQUENCE DIPLOMADOS_SEQ;

CREATE OR REPLACE TRIGGER DIPLOMADOS_TRG 
BEFORE INSERT ON DIPLOMADOS 
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT DIPLOMADOS_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/


------------------------------------------------------------------------
--CAMBIO PAQUETES
create or replace PACKAGE "TOOLKIT" AS

  FUNCTION encrypt (p_text  IN  VARCHAR2) RETURN RAW;

  FUNCTION decrypt (p_raw  IN  RAW) RETURN VARCHAR2;

  FUNCTION F_LOGIN (p_username IN VARCHAR2, p_password VARCHAR2) RETURN BOOLEAN;
  
  FUNCTION get_tipo_acceso (p_usr IN VARCHAR2, p_app VARCHAR2) RETURN CHAR;

END toolkit;
/

create or replace PACKAGE BODY "TOOLKIT" AS

  g_key     RAW(32767)  := UTL_RAW.cast_to_raw('fundauc2019');
  g_pad_chr VARCHAR2(1) := '~';

  PROCEDURE padstring (p_text  IN OUT  VARCHAR2);


  -- --------------------------------------------------
  FUNCTION encrypt (p_text  IN  VARCHAR2) RETURN RAW IS
  -- --------------------------------------------------
    l_text       VARCHAR2(32767) := p_text;
    l_encrypted  RAW(32767);
  BEGIN
    padstring(l_text);
    DBMS_OBFUSCATION_TOOLKIT.desencrypt(input          => UTL_RAW.cast_to_raw(l_text),
                                        key            => g_key,
                                        encrypted_data => l_encrypted);
    RETURN l_encrypted;
  END;
  -- --------------------------------------------------



  -- --------------------------------------------------
  FUNCTION decrypt (p_raw  IN  RAW) RETURN VARCHAR2 IS
  -- --------------------------------------------------
    l_decrypted  VARCHAR2(32767);
  BEGIN
    DBMS_OBFUSCATION_TOOLKIT.desdecrypt(input => p_raw,
                                        key   => g_key,
                                        decrypted_data => l_decrypted);

    RETURN RTrim(UTL_RAW.cast_to_varchar2(l_decrypted), g_pad_chr);
  END;
  -- --------------------------------------------------

  -- --------------------------------------------------
  FUNCTION F_LOGIN (p_username IN VARCHAR2, p_password VARCHAR2) RETURN BOOLEAN IS
    l_return number;
    l_usuario usuarios.nombre_usuario%type;
    l_password usuarios.contrasena%type;
    begin 
      begin
      select nombre_usuario,contrasena into l_usuario, l_password from usuarios where UPPER(nombre_usuario) = UPPER(p_username);

     if toolkit.encrypt(p_password) = l_password and l_usuario = p_username then
--      DBMS_OUTPUT.PUT_LINE('if = ' || upper(p_password)||'='||l_password ||' and '||l_usuario||'='||upper(p_username));
--      if upper(p_password) = upper(l_password) and upper(l_usuario) = upper(p_username) then
        return true;
        else
        return false;
      end if;
      exception when no_data_found then
        return false;  
      end;
  END;
  -- --------------------------------------------------

  -- --------------------------------------------------
  PROCEDURE padstring (p_text  IN OUT  VARCHAR2) IS
  -- --------------------------------------------------
    l_units  NUMBER;
  BEGIN
    IF LENGTH(p_text) MOD 8 > 0 THEN
      l_units := TRUNC(LENGTH(p_text)/8) + 1;
      p_text  := RPAD(p_text, l_units * 8, g_pad_chr);
    END IF;
  END;
  -- --------------------------------------------------
  
  FUNCTION get_tipo_acceso (p_usr IN VARCHAR2, p_app VARCHAR2) RETURN CHAR IS
    l_return CHAR(1) := null;
    l_usuario usuarios.nombre_usuario%type;
    l_app_id  number;
  BEGIN
    FOR c IN (select role_static_id from apex_appl_acl_user_roles where application_id = p_app and user_name = p_usr) LOOP
        IF c.role_static_id in ('CONTROLEST','SUPCONTROLEST') and l_return is null THEN
            l_return := 'I';
        ELSIF c.role_static_id in ('DIPLOMADOS','SUPDIPLO') and l_return is null THEN
            l_return := 'D';
        ELSIF c.role_static_id in ('ADMINISTRATOR') THEN
            l_return := 'T';
        END IF;
    END LOOP;
    return l_return;
  END;
  
END toolkit;
/




--------------------------------------------------------
--  DDL for Function GET_INSCRIPCION_JSON
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "FUNDAUC"."GET_INSCRIPCION_JSON" (
   p_ins_id in inscripciones.id%type,
   p_seccion_id inscripciones.seccion_id%type
)
   return clob
is
 -- l_inscripcion_row inscripciones%ROWTYPE;
  l_seccion_row secciones%ROWTYPE;
  l_periodo_row calendarios_detalle%ROWTYPE;
  l_factura_row factura%ROWTYPE;
  l_secc_json_clob clob;

BEGIN

  APEX_JSON.initialize_clob_output;
  
 /* select * into l_inscripcion_row
  from inscripciones
  where id = p_ins_id;*/
  
  APEX_JSON.open_object; -- {

  SELECT s.*
  INTO   l_seccion_row
  FROM   secciones s
  WHERE  s.id = p_seccion_id;

  APEX_JSON.open_object('seccion'); -- department {

  APEX_JSON.write('id_seccion', l_seccion_row.id_seccion);
  APEX_JSON.write('codigo',l_seccion_row.id);
  APEX_JSON.write('id_metodo', l_seccion_row.id_metodo);
  APEX_JSON.write('nivel', l_seccion_row.nivel);
  APEX_JSON.write('id_salon',l_seccion_row.id_salon);
  APEX_JSON.write('tope',l_seccion_row.tope);
  APEX_JSON.write('status',l_seccion_row.status);
  APEX_JSON.write('id_edif',l_seccion_row.id_edif);
  APEX_JSON.write('id_horario',l_seccion_row.id_horario);
  APEX_JSON.write('horario',UTL_HORARIOS.GETHORARIO(l_seccion_row.id_horario));
  APEX_JSON.write('cedula_prof',l_seccion_row.cedula_prof);
  APEX_JSON.write('modalidad',utl_modalidades.getModalidad(l_seccion_row.modalidad));

  select * into l_periodo_row
  from calendarios_detalle
  where id = l_seccion_row.periodo;
  APEX_JSON.open_object('periodo'); -- periodo {
  APEX_JSON.write('id',l_periodo_row.id);
  APEX_JSON.write('id_calendario',l_periodo_row.id_calendario);
  APEX_JSON.write('cod_periodo',l_periodo_row.periodo);
  APEX_JSON.write('fecha_ini',to_char(l_periodo_row.fecha_ini,'DD/MM/YYYY'));
  APEX_JSON.write('fecha_fin',to_char(l_periodo_row.fecha_fin,'DD/MM/YYYY'));
  APEX_JSON.write('modalidad',l_periodo_row.modalidad);
  APEX_JSON.write('periodo_activo',l_periodo_row.periodo_activo);
  
  APEX_JSON.close_object; -- } --periodo
  
  begin
      select f.* 
      into l_factura_row
      from factura f, inscripcion_factura if
      where f.id = if.factura_id
      and if.inscripcion_id = p_ins_id; 
      
      APEX_JSON.open_object('factura'); -- factura {
      APEX_JSON.write('id',l_factura_row.id);
      APEX_JSON.write('tipo_fac',l_factura_row.tipo);
      APEX_JSON.write('cedula_est',l_factura_row.cedula_est);
      APEX_JSON.write('rif',l_factura_row.rif);
      APEX_JSON.write('nombre_cliente',l_factura_row.nombre_cliente);
      APEX_JSON.write('dir_fiscal',l_factura_row.dir_fiscal);
      APEX_JSON.write('fecha_emi',l_factura_row.fecha_emi);
      APEX_JSON.write('status',l_factura_row.status);
      APEX_JSON.write('programa',l_factura_row.programa);
      APEX_JSON.write('monto',l_factura_row.monto);
      APEX_JSON.close_object; -- } --factura}
      
      exception
      when no_data_found then
         APEX_JSON.open_object('factura'); -- factura {
         APEX_JSON.close_object; -- } --factura}
  end;
  
  APEX_JSON.close_object; -- }
  APEX_JSON.close_object; -- }

  DBMS_OUTPUT.put_line(APEX_JSON.get_clob_output);

  l_secc_json_clob := apex_json.get_clob_output;

  APEX_JSON.free_output;

  return l_secc_json_clob;
END get_inscripcion_json;
/

--------------------------------------------------------
--  DDL for Trigger INSCRIPCIONES_TRG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "FUNDAUC"."INSCRIPCIONES_TRG" 
BEFORE INSERT ON INSCRIPCIONES 
FOR EACH ROW 
DECLARE
    p_estudiante_rec fundauc.tapi_estudiante.estudiante_rt;
    
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT INSCRIPCIONES_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
      
      select periodo into :NEW.PERIODO_ID from secciones where id = :NEW.SECCION_ID;
      
      p_estudiante_rec := TAPI_ESTUDIANTE.RT(P_MATRICULA => :NEW.EST_MATRICULA);
      
      if p_estudiante_rec.condicion_especial = 5 then
            :NEW.ES_EXONERADO := 'S';
            :NEW.ESTATUS := 'AP';
      else
          :NEW.ES_EXONERADO := 'N';
          :NEW.ESTATUS := 'AXC';  
      end if;
    END IF;
  END COLUMN_SEQUENCES;
END;
/
ALTER TRIGGER "FUNDAUC"."INSCRIPCIONES_TRG" ENABLE;


--------------------------------------------------------
--  DDL for Trigger T_INSCRIPCIONES_BID
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "FUNDAUC"."T_INSCRIPCIONES_BID" 
AFTER
    DELETE OR INSERT ON inscripciones
    FOR EACH ROW 
DECLARE
    p_factura_rec fundauc.tapi_factura.factura_rt;
    p_estudiante_rec fundauc.tapi_estudiante.estudiante_rt;
    p_cond_especial_rec fundauc.tapi_condiciones_especiales.condiciones_especiales_rt;
    p_detalle_factura_rec fundauc.tapi_detalle_factura.detalle_factura_rt;
    p_material_mat FUNDAUC.UTL_MATERIALES.DETALLE_FACTURA_RT;
    p_material_cur FUNDAUC.UTL_MATERIALES.DETALLE_FACTURA_RT;
    P_HOJA_VIDA_EST_REC FUNDAUC.TAPI_HOJA_VIDA_EST.HOJA_VIDA_EST_RT;
    l_precio number := 0;
    l_fact_id number := 0;
BEGIN

    IF inserting THEN

            p_estudiante_rec := TAPI_ESTUDIANTE.RT(P_MATRICULA => :NEW.EST_MATRICULA);
            p_cond_especial_rec := TAPI_CONDICIONES_ESPECIALES.RT(P_ID_CONDICION => p_estudiante_rec.condicion_especial);

       if p_estudiante_rec.condicion_especial != 5 then
            p_factura_rec.id_fact := null;
            p_factura_rec.tipo := 'FA';
            p_factura_rec.cedula_est := p_estudiante_rec.cedula_est;
            p_factura_rec.nombre_cliente := p_estudiante_rec.nombre||' '||p_estudiante_rec.apellido;
            p_factura_rec.fecha_emi := null;
            p_factura_rec.monto := 0;
            p_factura_rec.p_iva := 0;
            p_factura_rec.monto_iva := 0;
            p_factura_rec.flete := 0;
            p_factura_rec.bs_descuento := 0;
            p_factura_rec.dir_fiscal := p_estudiante_rec.direccion;
            p_factura_rec.rif := p_estudiante_rec.cedula_est;
            p_factura_rec.status := 'PC';
            p_factura_rec.programa :=  global.getVal('SEDE');
            p_factura_rec.prog_academico := to_number(global.getVal('PROG'));
            p_factura_rec.creado_por := coalesce(sys_context('APEX$SESSION', 'app_user'), regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), sys_context('userenv', 'session_user'));
            p_factura_rec.creado_el := SYSDATE;
            p_factura_rec.monto_exento := 0;
            p_factura_rec.base_imponible := 0;
            p_factura_rec.escredito := 'N';
            

            p_factura_rec.id := FACTURA_SEQ.NEXTVAL;


            tapi_factura.ins(p_factura_rec => p_factura_rec);
            
            insert into INSCRIPCION_FACTURA (INSCRIPCION_ID,FACTURA_ID) VALUES (:NEW.ID,p_factura_rec.id);

            if p_estudiante_rec.id_tipo_est = 0 then

                p_material_cur := UTL_MATERIALES.GETRECDETALLEFAC(:NEW.SECCION_ID,'C');

                p_detalle_factura_rec.renglon := DETALLE_FACTURA_SEQ.NEXTVAL;
                p_detalle_factura_rec.tipo_item := p_material_cur.tipo_item;
                p_detalle_factura_rec.item := p_material_cur.item;
                p_detalle_factura_rec.descripcion := p_material_cur.descripcion;
                p_detalle_factura_rec.cantidad := p_material_cur.cantidad;
                p_detalle_factura_rec.p_unidad := p_material_cur.p_unidad;
                p_detalle_factura_rec.bs_descuento := p_material_cur.bs_descuento;
                p_detalle_factura_rec.subtotal := p_material_cur.subtotal;
                p_detalle_factura_rec.materiales_id := p_material_cur.materiales_id;
                p_detalle_factura_rec.factura_id := p_factura_rec.id;

                tapi_detalle_factura.ins(p_detalle_factura_rec => p_detalle_factura_rec);

            P_HOJA_VIDA_EST_REC.id := HOJA_VIDA_EST_SEQ.NEXTVAL;
            P_HOJA_VIDA_EST_REC.matricula := :NEW.EST_MATRICULA;
            P_HOJA_VIDA_EST_REC.evento_id := 2;
            P_HOJA_VIDA_EST_REC.fecha := systimestamp;
            P_HOJA_VIDA_EST_REC.metadata := get_inscripcion_json(:NEW.ID,:NEW.SECCION_ID);
            P_HOJA_VIDA_EST_REC.observacion := upper(utl_inscripciones.getDesStatus(:NEW.estatus));

            TAPI_HOJA_VIDA_EST.INS(P_HOJA_VIDA_EST_REC);

                p_material_mat := UTL_MATERIALES.GETRECDETALLEFAC(50,'M');

                p_detalle_factura_rec.renglon := DETALLE_FACTURA_SEQ.NEXTVAL;
                p_detalle_factura_rec.tipo_item := p_material_mat.tipo_item;
                p_detalle_factura_rec.item := p_material_mat.item;
                p_detalle_factura_rec.descripcion := p_material_mat.descripcion;
                p_detalle_factura_rec.cantidad := p_material_mat.cantidad;
                p_detalle_factura_rec.p_unidad := p_material_mat.p_unidad;
                p_detalle_factura_rec.bs_descuento := p_material_mat.bs_descuento;
                p_detalle_factura_rec.subtotal := p_material_mat.subtotal;
                p_detalle_factura_rec.materiales_id := p_material_mat.materiales_id;
                p_detalle_factura_rec.factura_id := p_factura_rec.id;

                tapi_detalle_factura.ins(p_detalle_factura_rec => p_detalle_factura_rec);

            P_HOJA_VIDA_EST_REC.id := HOJA_VIDA_EST_SEQ.NEXTVAL;
            P_HOJA_VIDA_EST_REC.matricula := :NEW.EST_MATRICULA;
            P_HOJA_VIDA_EST_REC.evento_id := 1;
            P_HOJA_VIDA_EST_REC.fecha := systimestamp;
            P_HOJA_VIDA_EST_REC.metadata := null;
            P_HOJA_VIDA_EST_REC.observacion := 'PAGO DE MATRICULA';

            TAPI_HOJA_VIDA_EST.INS(P_HOJA_VIDA_EST_REC);


            else
                p_material_cur := UTL_MATERIALES.GETRECDETALLEFAC(:NEW.SECCION_ID,'C');

                p_detalle_factura_rec.renglon := DETALLE_FACTURA_SEQ.NEXTVAL;
                p_detalle_factura_rec.tipo_item := p_material_cur.tipo_item;
                p_detalle_factura_rec.item := p_material_cur.item;
                p_detalle_factura_rec.descripcion := p_material_cur.descripcion;
                p_detalle_factura_rec.cantidad := p_material_cur.cantidad;
                p_detalle_factura_rec.p_unidad := p_material_cur.p_unidad;
                p_detalle_factura_rec.bs_descuento := p_material_cur.bs_descuento;
                p_detalle_factura_rec.subtotal := p_material_cur.subtotal;
                p_detalle_factura_rec.materiales_id := p_material_cur.materiales_id;
                p_detalle_factura_rec.factura_id := p_factura_rec.id;

                tapi_detalle_factura.ins(p_detalle_factura_rec => p_detalle_factura_rec);

                P_HOJA_VIDA_EST_REC.id := HOJA_VIDA_EST_SEQ.NEXTVAL;
                P_HOJA_VIDA_EST_REC.matricula := :NEW.EST_MATRICULA;
                P_HOJA_VIDA_EST_REC.evento_id := 2;
                P_HOJA_VIDA_EST_REC.fecha := systimestamp;
                P_HOJA_VIDA_EST_REC.metadata := get_inscripcion_json(:NEW.ID,:NEW.SECCION_ID);
                P_HOJA_VIDA_EST_REC.observacion := upper(utl_inscripciones.getDesStatus(:NEW.estatus));
    
                TAPI_HOJA_VIDA_EST.INS(P_HOJA_VIDA_EST_REC);

            end if;
            if p_cond_especial_rec.descuento is not null then
                p_material_cur := UTL_MATERIALES.GETRECDETALLEFAC(p_cond_especial_rec.descuento);
                l_precio := (((p_detalle_factura_rec.cantidad*p_detalle_factura_rec.p_unidad)*p_cond_especial_rec.porcentaje)/100)*-1;

                update precios set precio1 = l_precio
                where item = p_cond_especial_rec.descuento;


                p_detalle_factura_rec.renglon := DETALLE_FACTURA_SEQ.NEXTVAL;
                p_detalle_factura_rec.tipo_item := p_material_cur.tipo_item;
                p_detalle_factura_rec.item := p_material_cur.item;
                p_detalle_factura_rec.descripcion := p_material_cur.descripcion;
                p_detalle_factura_rec.cantidad := p_material_cur.cantidad;
                p_detalle_factura_rec.p_unidad := l_precio; --p_material_cur.p_unidad;
                p_detalle_factura_rec.bs_descuento := p_material_cur.bs_descuento;
                p_detalle_factura_rec.subtotal := p_material_cur.subtotal;
                p_detalle_factura_rec.materiales_id := p_material_cur.materiales_id;
                p_detalle_factura_rec.factura_id := p_factura_rec.id;

                tapi_detalle_factura.ins(p_detalle_factura_rec => p_detalle_factura_rec);

            P_HOJA_VIDA_EST_REC.id := HOJA_VIDA_EST_SEQ.NEXTVAL;
            P_HOJA_VIDA_EST_REC.matricula := :NEW.EST_MATRICULA;
            P_HOJA_VIDA_EST_REC.evento_id := 53;
            P_HOJA_VIDA_EST_REC.fecha := systimestamp;
            P_HOJA_VIDA_EST_REC.metadata := get_inscripcion_json(:NEW.ID,:NEW.SECCION_ID);
            P_HOJA_VIDA_EST_REC.observacion := 'Descuento del '||p_cond_especial_rec.porcentaje||'%, por condición especial ('||p_cond_especial_rec.descripcion||')';

            TAPI_HOJA_VIDA_EST.INS(P_HOJA_VIDA_EST_REC); 
            end if;
       else
            P_HOJA_VIDA_EST_REC.id := HOJA_VIDA_EST_SEQ.NEXTVAL;
            P_HOJA_VIDA_EST_REC.matricula := :NEW.EST_MATRICULA;
            P_HOJA_VIDA_EST_REC.evento_id := 2;
            P_HOJA_VIDA_EST_REC.fecha := systimestamp;
            P_HOJA_VIDA_EST_REC.metadata := get_inscripcion_json(:NEW.ID,:NEW.SECCION_ID);
            P_HOJA_VIDA_EST_REC.observacion := 'ESTUDIANTE EXONERADO';

            TAPI_HOJA_VIDA_EST.INS(P_HOJA_VIDA_EST_REC);
        end if;
    ELSIF deleting THEN
        select factura_id into l_fact_id from inscripcion_factura where inscripcion_id = :OLD.ID;

        delete from inscripcion_factura where inscripcion_id = :OLD.ID;
        delete from detalle_factura where factura_id = l_fact_id;
        delete from factura where id = l_fact_id;
    END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
END;
/
ALTER TRIGGER "FUNDAUC"."T_INSCRIPCIONES_BID" ENABLE;

--------------------------------------------------------
--  DDL for Package UTL_INSCRIPCIONES
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "FUNDAUC"."UTL_INSCRIPCIONES" AS 

    FUNCTION getInscripcionesSeccion (
        vid_seccion NUMBER
    ) RETURN NUMBER;
    
    FUNCTION getDesStatus (
        v_status VARCHAR2
    ) RETURN VARCHAR2;
    
    FUNCTION getStatusFac (
        vid_insc number
    ) RETURN VARCHAR2;
    
    PROCEDURE elimina_Inscripciones;
    
    FUNCTION LOG_MESSAGE(MESSAGE IN VARCHAR2) RETURN NUMBER;

END UTL_INSCRIPCIONES;

/

--------------------------------------------------------
--  DDL for Package Body UTL_INSCRIPCIONES
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "FUNDAUC"."UTL_INSCRIPCIONES" AS

    FUNCTION getInscripcionesSeccion (
        vid_seccion NUMBER
    ) RETURN NUMBER AS
        eof  NUMBER;
        dml  VARCHAR2(2000);
    BEGIN
        dml := 'SELECT count(*) FROM Inscripciones WHERE seccion_id = '|| vid_seccion;

        EXECUTE IMMEDIATE dml
        INTO eof;

DBMS_OUTPUT.PUT_LINE(dml);
        IF eof IS NULL THEN
            eof := 0;
            RETURN eof;
        ELSE
            RETURN eof;
        END IF;

    EXCEPTION
        WHEN no_data_found THEN
            eof := 0;
            RETURN eof;
        WHEN OTHERS THEN
            eof := 0;
            dbms_output.put_line('COUNT: '
                                 || sqlerrm
                                 || dml);
            RETURN eof;
    END getInscripcionesSeccion;
    
    FUNCTION getDesStatus (
        v_status VARCHAR2
    ) RETURN VARCHAR2 AS
        eof  VARCHAR2(20);
        dml  VARCHAR2(2000);
    BEGIN
      dml := 'SELECT CASE '||
       'WHEN '''||v_status||''' = ''AXC'' THEN ''Activa, por Cobrar'''||
       'WHEN '''||v_status||''' = ''AP'' THEN ''Activa, Pagada'''||
       'WHEN '''||v_status||''' = ''IF'' THEN ''Inactiva, Finalizada'''||
       'WHEN '''||v_status||''' = ''AN'' THEN ''Anulada'''||
       'WHEN '''||v_status||''' = ''AE'' THEN ''En Ejecución'''||
       'ELSE ''No Registrada'' END ESTATUS FROM dual';

        EXECUTE IMMEDIATE dml
        INTO eof;

DBMS_OUTPUT.PUT_LINE(dml);
        IF eof IS NULL THEN
            RETURN eof;
        ELSE
            RETURN eof;
        END IF;

    EXCEPTION
        WHEN no_data_found THEN
            RETURN eof;
        WHEN OTHERS THEN
            dbms_output.put_line('COUNT: '
                                 || sqlerrm
                                 || dml);
            RETURN eof;
    END getDesStatus;
    
    FUNCTION getStatusFac (
        vid_insc number
    ) RETURN VARCHAR2 AS
        eof  VARCHAR2(255);
        
        l_ins_fac_rec inscripcion_factura%ROWTYPE;
        l_factura_rec factura%ROWTYPE;
        l_inscripciones_rec inscripciones%ROWTYPE;
    BEGIN
      
      select * 
      into l_inscripciones_rec
      from inscripciones
      where id = vid_insc;
      
      if l_inscripciones_rec.es_exonerado != 'S' THEN
          select * 
          into l_ins_fac_rec
          from inscripcion_factura
          where inscripcion_id = vid_insc;
          
          select * 
          into l_factura_rec
          from factura
          where id = l_ins_fac_rec.factura_id;
      end if;
      
      dbms_output.put_line('ID='||vid_insc||' EXONERADO '||l_inscripciones_rec.es_exonerado);
    CASE
    WHEN l_inscripciones_rec.es_exonerado = 'S' THEN eof := '<span class="rap-badge-exonerado">EXONERADO</span>';
    ELSE
      CASE
          WHEN l_factura_rec.STATUS = 'A' THEN eof := '<span class="rap-badge-anulada">ANULADA</span>';
          WHEN l_factura_rec.STATUS = 'V' THEN eof := '<span class="rap-badge-emitida">'||l_factura_rec.ID_FACT||'</span>';
          WHEN l_factura_rec.STATUS = 'PC' THEN eof := '<span class="rap-badge-pendiente">POR COBRAR</span>';
      END CASE;
    END CASE;

        IF eof IS NULL THEN
            RETURN 'NO REGISTRADO';
        ELSE
            RETURN eof;
        END IF;

    EXCEPTION
        WHEN no_data_found THEN
            RETURN 'NO REGISTRADO';
        WHEN OTHERS THEN
            dbms_output.put_line('COUNT: '
                                 || sqlerrm
                                 );
            RETURN eof;
    END getStatusFac;

    PROCEDURE elimina_Inscripciones IS
        L_RC NUMBER;
    BEGIN
        L_RC := LOG_MESSAGE('[INFO] EJECUTANDO JOB ELIMINA_INSCRIPCIONES ');
        delete inscripciones where estatus = 'Activa, En Proceso';
        DBMS_OUTPUT.PUT_LINE ('[INFO] JOB EJECUTADO');
        L_RC := LOG_MESSAGE('[INFO] JOB ELIMINA_INSCRIPCIONES EJECUTADO');
    END;

    FUNCTION LOG_MESSAGE(MESSAGE IN VARCHAR2) RETURN NUMBER
    AS 
        L_ID NUMBER;
    BEGIN
        BEGIN
            SELECT (NVL(MAX(LOG_ID),0) + 1) INTO L_ID FROM JOB_LOG; 
            INSERT INTO JOB_LOG(LOG_ID, LOG_MESSAGE, LOG_TIME) 
            VALUES (L_ID, MESSAGE, SYSDATE);
            RETURN 0;
            EXCEPTION
                WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE ('[INFO] ERROR WHILE LOG_MESSAGE '  || SQLCODE || ' ' || SUBSTR(SQLERRM, 1, 64)); 
                RETURN 1;
        END;	
    END LOG_MESSAGE;
END utl_inscripciones;
/

create or replace PACKAGE UTL_PERIODOS AS 

    FUNCTION getTotalperiodos (
        vid_calendario NUMBER
    ) RETURN NUMBER;
    
    FUNCTION getPeriodo (
        vid_periodo NUMBER
    ) RETURN VARCHAR2;
    
    FUNCTION getStatusPeriodo (
        vid_periodo NUMBER
    ) RETURN VARCHAR2;

END UTL_PERIODOS;
/

create or replace PACKAGE BODY utl_periodos AS

    FUNCTION getTotalPeriodos (
        vid_calendario NUMBER
    ) RETURN NUMBER AS
        eof  NUMBER;
        dml  VARCHAR2(2000);
    BEGIN
        dml := 'SELECT count(*) FROM calendarios_detalle WHERE id_calendario = '|| vid_calendario;

        EXECUTE IMMEDIATE dml
        INTO eof;

--DBMS_OUTPUT.PUT_LINE(dml);
        IF eof IS NULL THEN
            eof := 0;
            RETURN eof;
        ELSE
            RETURN eof;
        END IF;

    EXCEPTION
        WHEN no_data_found THEN
            eof := 0;
            RETURN eof;
        WHEN OTHERS THEN
            eof := 0;
            dbms_output.put_line('COUNT: '
                                 || sqlerrm
                                 || dml);
            RETURN eof;
    END getTotalPeriodos;

    FUNCTION getPeriodo (
        vid_periodo NUMBER
    ) RETURN VARCHAR2 AS
        eof  VARCHAR2(100);
        dml  VARCHAR2(2000);
    BEGIN
        dml := 'SELECT ''(''||PERIODO||'') ''||TO_CHAR(FECHA_INI,''DD/MM/YYYY'')||''-''||TO_CHAR(FECHA_FIN,''DD/MM/YYYY'') FROM calendarios_detalle WHERE id = '|| vid_periodo;

        EXECUTE IMMEDIATE dml
        INTO eof;

--DBMS_OUTPUT.PUT_LINE(dml);
        IF eof IS NULL THEN
            eof := NULL;
            RETURN eof;
        ELSE
            RETURN eof;
        END IF;

    EXCEPTION
        WHEN no_data_found THEN
            eof := NULL;
            RETURN eof;
        WHEN OTHERS THEN
            eof := NULL;
            dbms_output.put_line('COUNT: '
                                 || sqlerrm
                                 || dml);
            RETURN eof;
    END getPeriodo;
    
    FUNCTION getStatusPeriodo (
        vid_periodo NUMBER
    ) RETURN VARCHAR2 AS
        l_fini date;
        l_ffin date;
        l_hoy date := sysdate;
        eof varchar(20);
    BEGIN
        SELECT FECHA_INI,FECHA_FIN into l_fini, l_ffin FROM calendarios_detalle WHERE id = vid_periodo;

        CASE
          WHEN l_hoy BETWEEN l_fini and l_ffin THEN eof := 'En Curso'
          WHEN l_hoy < l_fini THEN eof := 'Por Comenzar'
          WHEN l_hoy > l_ffin THEN eof := 'Finalizado'
        END CASE;

--DBMS_OUTPUT.PUT_LINE(dml);
        IF eof IS NULL THEN
            eof := NULL;
            RETURN eof;
        ELSE
            RETURN eof;
        END IF;

    EXCEPTION
        WHEN no_data_found THEN
            eof := NULL;
            RETURN eof;
        WHEN OTHERS THEN
            eof := NULL;
            dbms_output.put_line('STATUS: '
                                 || sqlerrm);
            RETURN eof;
    END getStatusPeriodo;

END utl_periodos;
/
  
create or replace TRIGGER COHORTES_TRG 
BEFORE INSERT OR UPDATE ON COHORTES 
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT COHORTES_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
      :NEW.CREADO_POR := coalesce(sys_context('APEX$SESSION', 'app_user'), regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), sys_context('userenv', 'session_user'));
      :NEW.CREADO_EL := SYSDATE;

    ELSIF UPDATING THEN
      :NEW.MODIFICADO_POR := coalesce(sys_context('APEX$SESSION', 'app_user'), regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), sys_context('userenv', 'session_user'));
      :NEW.MODIFICADO_EL := SYSDATE;
    END IF;
  END COLUMN_SEQUENCES;
END;
/
--------------------------------------------------------
--  DDL for Trigger T_COHORTES_AUID
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "FUNDAUC"."T_COHORTES_AUID" 
AFTER
    UPDATE OR DELETE OR INSERT ON  cohortes
for each row 
DECLARE
  l_fecha date;
  l_precio number;
  l_id_curso varchar2(10);
  l_des_curso varchar(255);
  l_ciudad    varchar2(255);
  P_MATERIALES_REC FUNDAUC.TAPI_MATERIALES.MATERIALES_RT;
  P_PRECIOS_REC FUNDAUC.TAPI_PRECIOS.PRECIOS_RT;

begin
  BEGIN
    select fecha_ini into l_fecha from calendarios_detalle
    where id = :NEW.PERIODO;
    
    if :NEW.TIPO_DIPLO in ('DP','PC') then
        select id_diplomado, descripcion into l_id_curso, l_des_curso from diplomados
        where id = :NEW.DIPLOMADO_ID;
        
        select upper(nombre) into l_ciudad from ciudades
        where id_ciudad = :NEW.ID_CIUDAD;
    elsif :NEW.TIPO_DIPLO = 'IC' then
        l_id_curso := :NEW.ID_METODO;
    end if;
    
    select max(precio1) into l_precio from precios
    where tipo_item = 'C';
    IF INSERTING THEN
      --Inserta Secciones nuevas

            P_MATERIALES_REC.id_mat := :NEW.CODIGO;
            P_MATERIALES_REC.tipo := :NEW.TIPO_DIPLO;
            if :NEW.TIPO_DIPLO in ('DP','PC') then
              P_MATERIALES_REC.descripcion := l_des_curso||' - '||l_ciudad;
            elsif :NEW.TIPO_DIPLO = 'IC' then
              P_MATERIALES_REC.descripcion := :NEW.ID_METODO||'|NIVEL '||lpad(:OLD.nivel,2,'0')||'|'||UTL_HORARIOS.GETHORARIO(:NEW.ID_HORARIO)||'|'||to_char(l_fecha,'DD/MM/YYYY')||'|'||utl_modalidades.getModalidad(:NEW.id_modalidad);
            end if;
            P_MATERIALES_REC.id_curso := l_id_curso;
            P_MATERIALES_REC.evento := 2;
            P_MATERIALES_REC.nivel := :NEW.NIVEL;
            P_MATERIALES_REC.iva_exento := 'S';
            P_MATERIALES_REC.activo := 'S';
          --  P_MATERIALES_REC.id := 
            P_MATERIALES_REC.seccion_id := null;
            P_MATERIALES_REC.creado_por := coalesce(sys_context('APEX$SESSION', 'app_user'), regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), sys_context('userenv', 'session_user'));
            P_MATERIALES_REC.creado_el := SYSDATE;
            P_MATERIALES_REC.modificado_por := null;
            P_MATERIALES_REC.modificado_el := null;
            P_MATERIALES_REC.cohortes_id := :NEW.ID;

      TAPI_MATERIALES.INS(P_MATERIALES_REC);

            P_PRECIOS_REC.item := P_MATERIALES_REC.id_mat;
            P_PRECIOS_REC.tipo_item := P_MATERIALES_REC.tipo;
            P_PRECIOS_REC.fecha := SYSDATE;
            P_PRECIOS_REC.precio1 := l_precio;
            P_PRECIOS_REC.precio2 := 0;
            P_PRECIOS_REC.precio3 := 0;
            P_PRECIOS_REC.status := 'V';
            P_PRECIOS_REC.precio4 := 0;
            P_PRECIOS_REC.precio5 := 0;


        TAPI_PRECIOS.INS(P_PRECIOS_REC);


    ELSIF UPDATING THEN

        if :NEW.TIPO_DIPLO in ('DP','PC') then
          update materiales set descripcion = l_des_curso||' - '||l_ciudad
          where tipo='C' and seccion_id = :OLD.ID;
        elsif :NEW.TIPO_DIPLO = 'IC' then
          update materiales set descripcion = :NEW.ID_METODO||'|NIVEL '||lpad(:OLD.nivel,2,'0')||'|'||UTL_HORARIOS.GETHORARIO(:NEW.ID_HORARIO)||'|'||to_char(l_fecha,'DD/MM/YYYY')||'|'||utl_modalidades.getModalidad(:NEW.id_modalidad)
          where tipo='C' and seccion_id = :OLD.ID;
        end if;

    END IF;
  END;
end;
/
ALTER TRIGGER "FUNDAUC"."T_COHORTES_AUID" ENABLE;

create or replace TRIGGER "SECCIONES_TRG" 
before insert or update on secciones 
for each row 
begin
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT SECCIONES_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
      :NEW.CREADO_POR := coalesce(sys_context('APEX$SESSION', 'app_user'), regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), sys_context('userenv', 'session_user'));
      :NEW.CREADO_EL := SYSDATE;

    ELSIF UPDATING THEN
      :NEW.MODIFICADO_POR := coalesce(sys_context('APEX$SESSION', 'app_user'), regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), sys_context('userenv', 'session_user'));
      :NEW.MODIFICADO_EL := SYSDATE;
    END IF;
  END COLUMN_SEQUENCES;
end;