--------------------------------------------------------
--  DDL for Trigger T_SECCIONES_AUID
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "FUNDAUC"."T_SECCIONES_AUID" 
AFTER
    UPDATE OR DELETE OR INSERT ON  secciones 
for each row 
DECLARE
  l_fecha date;
  l_precio number;
  P_MATERIALES_REC FUNDAUC.TAPI_MATERIALES.MATERIALES_RT;
  P_PRECIOS_REC FUNDAUC.TAPI_PRECIOS.PRECIOS_RT;
  
begin
  BEGIN
    select fecha_ini into l_fecha from calendarios_detalle
    where id = :NEW.PERIODO;
    select max(precio1) into l_precio from precios
    where tipo_item = 'C';
    IF INSERTING THEN
      --Inserta Secciones nuevas
      
            P_MATERIALES_REC.id_mat := :NEW.ID_SECCION;
            P_MATERIALES_REC.tipo := 'C';
            P_MATERIALES_REC.descripcion := :NEW.ID_METODO||'|NIVEL '||lpad(:OLD.nivel,2,'0')||'|'||UTL_HORARIOS.GETHORARIO(:NEW.ID_HORARIO)||'|'||to_char(l_fecha,'DD/MM/YYYY')||'|'||utl_modalidades.getModalidad(:NEW.modalidad)||'|'||:NEW.id_salon;
            P_MATERIALES_REC.id_curso := :NEW.ID_METODO;
            P_MATERIALES_REC.evento := 2;
            P_MATERIALES_REC.nivel := :NEW.NIVEL;
            P_MATERIALES_REC.iva_exento := 'S';
            P_MATERIALES_REC.activo := 'S';
          --  P_MATERIALES_REC.id := 
            P_MATERIALES_REC.seccion_id := :NEW.ID;
            P_MATERIALES_REC.creado_por := coalesce(sys_context('APEX$SESSION', 'app_user'), regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), sys_context('userenv', 'session_user'));
            P_MATERIALES_REC.creado_el := SYSDATE;
            P_MATERIALES_REC.modificado_por := null;
            P_MATERIALES_REC.modificado_el := null;
            P_MATERIALES_REC.cohortes_id := null;

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
        
        insert into precios
        select id_mat,tipo,sysdate,decode(tipo,'C',150000,0),0,0,'V',0,0 from materiales
        where tipo in ('C') and id_mat not in (select item from precios where tipo_item='C');

    ELSIF UPDATING THEN
       
        update materiales set descripcion = :NEW.ID_METODO||'|NIVEL '||lpad(:OLD.nivel,2,'0')||'|'||UTL_HORARIOS.GETHORARIO(:NEW.ID_HORARIO)||'|'||to_char(l_fecha,'DD/MM/YYYY')||'|'||utl_modalidades.getModalidad(:NEW.modalidad)||'|'||:NEW.id_salon
        where tipo='C' and seccion_id = :OLD.ID;
        
    END IF;
  END;
end;
/
ALTER TRIGGER "FUNDAUC"."T_SECCIONES_AUID" ENABLE;


--------------------------------------------------------
--  DDL for Trigger MATERIALES_TRG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "FUNDAUC"."MATERIALES_TRG" 
BEFORE INSERT ON MATERIALES 
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT MATERIALES_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/
ALTER TRIGGER "FUNDAUC"."MATERIALES_TRG" ENABLE;

--------------------------------------------------------
--  DDL for Function GET_SECCION_JSON
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "FUNDAUC"."GET_SECCION_JSON" (
   p_secc_id in secciones.id%type
)
   return clob
is

  l_seccionid   secciones.id%TYPE := 10;
  l_seccion_row secciones%ROWTYPE;
  l_periodo_row calendarios_detalle%ROWTYPE;
  l_secc_json_clob clob;

BEGIN

  APEX_JSON.initialize_clob_output;

  APEX_JSON.open_object; -- {

  SELECT s.*
  INTO   l_seccion_row
  FROM   secciones s
  WHERE  s.id = l_seccionid;

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
  
  APEX_JSON.close_object; -- }
  APEX_JSON.close_object; -- }

  DBMS_OUTPUT.put_line(APEX_JSON.get_clob_output);

  l_secc_json_clob := apex_json.get_clob_output;

  APEX_JSON.free_output;

  return l_secc_json_clob;
END get_seccion_json;

/
