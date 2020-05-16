
update detalle_factura set descripcion = replace(descripcion,'&#x2F;','/') where descripcion like '%&#x2F;%';
INSERT INTO "FUNDAUC"."MATERIALES" (ID_MAT, TIPO, DESCRIPCION, ID_CURSO, EVENTO, IVA_EXENTO, ACTIVO, CREADO_POR, CREADO_EL) VALUES ('MA02', 'M', 'MATRICULA DE INSCRIPCION SABATINO', '-', '1', 'S', 'S', 'PADRON', TO_DATE('2019-09-02 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO "FUNDAUC"."PRECIOS" (ITEM, TIPO_ITEM, FECHA, PRECIO1, PRECIO2, PRECIO3, STATUS) VALUES ('MA02', 'M', TO_DATE('2009-09-29 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), '80000', '0', '0', 'V');

exec tapi_gen2.create_tapi_package (p_table_name => 'SECCIONES', p_compile_table_api => TRUE);

--------------------------------------------------------
--  DDL for Package UTL_INSCRIPCIONES
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "FUNDAUC"."UTL_INSCRIPCIONES" AS 
    --Record type
   TYPE seccion_rt
   IS
      RECORD (
            seccion_id secciones.id_seccion%TYPE,
            id_metodo secciones.id_metodo%TYPE,
            nivel secciones.nivel%TYPE,
            id_horario secciones.id_horario%TYPE,
            id_modalidad secciones.modalidad%TYPE,
            id_periodo  secciones.periodo%TYPE
      );
   --Collection types (record)
   TYPE seccion_tt IS TABLE OF seccion_rt;

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
    
    FUNCTION getSeccionRec (
                p_renglon IN detalle_factura.renglon%TYPE 
               )
    RETURN seccion_rt RESULT_CACHE;

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
       'WHEN '''||v_status||''' = ''ACXC'' THEN ''Activa en Curso, por Cobrar'''||
       'WHEN '''||v_status||''' = ''ACP'' THEN ''Activa en Curso, Pagada'''||
       'WHEN '''||v_status||''' = ''AEXC'' THEN ''Activa por Comenzar, por Cobrar'''||
       'WHEN '''||v_status||''' = ''AEP'' THEN ''Activa por Comenzar, Pagada'''||
       'WHEN '''||v_status||''' = ''IF'' THEN ''Inactiva Finalizada'''||
       'WHEN '''||v_status||''' = ''AN'' THEN ''Anulada'''||
       'WHEN '''||v_status||''' = ''AEX'' THEN ''Activa por Comenzar, Exonerado'''||
       'WHEN '''||v_status||''' = ''ACX'' THEN ''Activa en Curso, Exonerado'''||
       'ELSE ''No Registrada'' END ESTATUS FROM dual';

        EXECUTE IMMEDIATE dml
        INTO eof;

--DBMS_OUTPUT.PUT_LINE(dml);
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
      
   --   dbms_output.put_line('ID='||vid_insc||' EXONERADO '||l_inscripciones_rec.es_exonerado);
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
    
    FUNCTION getSeccionRec (
                p_renglon IN detalle_factura.renglon%TYPE 
               )
    RETURN seccion_rt RESULT_CACHE
    IS
      l_seccion_rec seccion_rt;
      l_fecha_ini date;
   BEGIN

      select item,
             token(descripcion,1,'|') id_metodo,
             to_number(replace(token(descripcion,2,'|'),'NIVEL ','')) nivel, 
             utl_horarios.getIdHorario(token(descripcion,3,'|'),utl_modalidades.getIdModalidad(token(descripcion,5,'|'))) id_horario,
             utl_modalidades.getIdModalidad(token(descripcion,5,'|')) id_modalidad,
             to_date(token(descripcion,4,'|'),'DD/MM/YYYY') fecha_ini
      into
          l_seccion_rec.seccion_id,
          l_seccion_rec.id_metodo,
          l_seccion_rec.nivel,
          l_seccion_rec.id_horario,
          l_seccion_rec.id_modalidad,
          l_fecha_ini
      from detalle_factura
      where renglon = p_renglon;
      
    /*  DBMS_OUTPUT.PUT_LINE('Renglon='||p_renglon);
      DBMS_OUTPUT.PUT_LINE('SeccionID='||l_seccion_rec.seccion_id);
      DBMS_OUTPUT.PUT_LINE('IdMetodo='||l_seccion_rec.id_metodo);
      DBMS_OUTPUT.PUT_LINE('Nivel='||l_seccion_rec.nivel);
      DBMS_OUTPUT.PUT_LINE('Horario='||l_seccion_rec.id_horario);
      DBMS_OUTPUT.PUT_LINE('id_modalidad='||l_seccion_rec.id_modalidad);
      DBMS_OUTPUT.PUT_LINE('fecha_ini='||to_char(l_fecha_ini,'DDMMYYYY'));*/
      
      select id
        into l_seccion_rec.id_periodo
      from calendarios_detalle cd, metodos m
        where modalidad=l_seccion_rec.id_modalidad
          and fecha_ini=l_fecha_ini
          and m.id_metodo=l_seccion_rec.id_metodo
          and m.id_calendario=cd.id_calendario;

    --  DBMS_OUTPUT.PUT_LINE('id_periodo='||l_seccion_rec.id_periodo);

      RETURN l_seccion_rec;
      
      exception
      when no_data_found then
         l_seccion_rec := null;
         RETURN l_seccion_rec;

   END getSeccionRec;
    
END utl_inscripciones;

/

--------------------------------------------------------
--  DDL for Package UTL_PERIODOS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "FUNDAUC"."UTL_PERIODOS" AS 

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

--------------------------------------------------------
--  DDL for Package Body UTL_PERIODOS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "FUNDAUC"."UTL_PERIODOS" AS

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
          WHEN l_hoy BETWEEN l_fini and l_ffin THEN eof := 'En Curso';
          WHEN l_hoy < l_fini THEN eof := 'Por Comenzar';
          WHEN l_hoy > l_ffin THEN eof := 'Finalizado';
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

--------------------------------------------------------
--  DDL for Package UTL_MODALIDADES
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "FUNDAUC"."UTL_MODALIDADES" AS 
    
    FUNCTION getModalidad (
        vid_modalidad NUMBER
    ) RETURN VARCHAR2;
    
    FUNCTION getIdModalidad (
        vdes_modalidad VARCHAR2
    ) RETURN NUMBER;

END UTL_MODALIDADES;

/

--------------------------------------------------------
--  DDL for Package Body UTL_MODALIDADES
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "FUNDAUC"."UTL_MODALIDADES" AS

    FUNCTION getModalidad (
        vid_modalidad NUMBER
    ) RETURN VARCHAR2 AS
        eof  VARCHAR2(100);
        dml  VARCHAR2(2000);
    BEGIN
        dml := 'SELECT DESCRIPCION FROM Modalidades WHERE id_modalidad = '|| vid_modalidad;

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
    END getModalidad;
    
    FUNCTION getIdModalidad (
        vdes_modalidad VARCHAR2
    ) RETURN NUMBER AS
        eof  NUMBER;
        dml  VARCHAR2(2000);
    BEGIN
        dml := 'SELECT id_modalidad FROM Modalidades WHERE DESCRIPCION = '''||vdes_modalidad||'''';

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
    END getIdModalidad;

END utl_modalidades;

/

--------------------------------------------------------
--  DDL for Package UTL_HORARIOS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "FUNDAUC"."UTL_HORARIOS" AS 

    FUNCTION getTotalHorarios (
        vid_modalidad NUMBER
    ) RETURN NUMBER;
    
    FUNCTION getHorario (
        vid_horario NUMBER
    ) RETURN VARCHAR2;
    
    FUNCTION getIdHorario (
        vdes_horario VARCHAR2,
        vid_modalidad NUMBER
    ) RETURN NUMBER;

END UTL_HORARIOS;

/

--------------------------------------------------------
--  DDL for Package Body UTL_HORARIOS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "FUNDAUC"."UTL_HORARIOS" AS

    FUNCTION getTotalHorarios (
        vid_modalidad NUMBER
    ) RETURN NUMBER AS
        eof  NUMBER;
        dml  VARCHAR2(2000);
    BEGIN
        dml := 'SELECT count(*) FROM Horarios WHERE modalidad = '|| vid_modalidad;

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
    END getTotalHorarios;

    FUNCTION getHorario (
        vid_horario NUMBER
    ) RETURN VARCHAR2 AS
        eof  VARCHAR2(100);
        dml  VARCHAR2(2000);
    BEGIN
        dml := 'SELECT to_char(HORA,''HH:MI AM'')||''-''||to_char(HORA_FIN,''HH:MI AM'') FROM Horarios WHERE id_horario = '|| vid_horario;

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
    END getHorario;
    
    FUNCTION getIdHorario (
        vdes_horario VARCHAR2,
        vid_modalidad NUMBER
    ) RETURN NUMBER AS
        eof  NUMBER;
        dml  VARCHAR2(2000);
    BEGIN
        dml := 'SELECT id_horario FROM Horarios WHERE to_char(HORA,''HH:MI AM'')||''-''||to_char(HORA_FIN,''HH:MI AM'') = '''||vdes_horario||''' AND modalidad= '||vid_modalidad;

        EXECUTE IMMEDIATE dml
        INTO eof;

DBMS_OUTPUT.PUT_LINE(dml);
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
    END getIdHorario;

END utl_horarios;

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

  begin
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
  
  exception
  when no_data_found then
     APEX_JSON.open_object('periodo'); -- periodo {
     APEX_JSON.write('id',l_seccion_row.periodo);
  end;
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
--  DDL for Trigger T_DETALLE_FACTURA_AIUD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "FUNDAUC"."T_DETALLE_FACTURA_AIUD" AFTER
    DELETE OR INSERT OR UPDATE ON detalle_factura
    FOR EACH ROW
DECLARE
    p_factura_rec fundauc.tapi_factura.factura_rt;
    mon_exento number;
    o_mon_exento number;
    base_imp number;
    o_base_imp number;
    mon_iva number;
    o_mon_iva number;
    v_iva number;
    o_subtotal number;
BEGIN
    IF inserting THEN

        v_iva := UTL_CONFIGURACION.GETCONFIVA();

        if UTL_MATERIALES.GETEXENTOIVA(:NEW.MATERIALES_ID) = 'S' THEN 
            mon_exento := :new.subtotal;
        else
            base_imp := :new.subtotal;
            mon_iva := (base_imp*v_iva)/100;
        end if;

        update factura set monto = (nvl(monto,0) + nvl(:new.subtotal,0) + nvl(mon_iva,0)), 
            p_iva = nvl(v_iva,0), 
            monto_exento = (nvl(monto_exento,0) + nvl(mon_exento,0)), 
            base_imponible = (nvl(base_imponible,0) + nvl(base_imp,0)),
            monto_iva = (nvl(monto_iva,0) + nvl(mon_iva,0))
        where id = :new.factura_id;
    ELSIF updating THEN

        o_subtotal := nvl(:old.cantidad,0) * nvl(:old.p_unidad,0);


        v_iva := UTL_CONFIGURACION.GETCONFIVA();

        if UTL_MATERIALES.GETEXENTOIVA(:OLD.MATERIALES_ID) = 'S' THEN 
            o_mon_exento := :old.subtotal;
            mon_exento := :new.subtotal;
        else

            base_imp := :new.subtotal;
            o_base_imp := :old.subtotal;
            mon_iva := (base_imp*v_iva)/100;
            o_mon_iva := (o_base_imp*v_iva)/100;
        end if;

        update factura 
          set monto = (nvl(monto,0) - nvl(:old.subtotal,0) - nvl(o_mon_iva,0)) + nvl(:new.subtotal,0) + nvl(mon_iva,0), 
            p_iva = nvl(v_iva,0), 
            monto_exento = (nvl(monto_exento,0) - nvl(o_mon_exento,0)) + nvl(mon_exento,0), 
            base_imponible = (nvl(base_imponible,0) - nvl(o_base_imp,0)) + nvl(base_imp,0),
            monto_iva = (nvl(monto_iva,0) - nvl(o_mon_iva,0)) + nvl(mon_iva,0)
        where id = :new.factura_id;
    ELSIF deleting THEN

        o_subtotal := nvl(:old.cantidad,0) * nvl(:old.p_unidad,0);
        v_iva := UTL_CONFIGURACION.GETCONFIVA();

        if UTL_MATERIALES.GETEXENTOIVA(:OLD.MATERIALES_ID) = 'S' THEN 
            o_mon_exento := o_subtotal;
        else
            o_base_imp := o_subtotal;
            o_mon_iva := (o_base_imp*v_iva)/100;
        end if;
        update factura set monto = (nvl(monto,0) - nvl(:old.subtotal,0) ),
            monto_exento = (nvl(monto_exento,0) - nvl(o_mon_exento,0)),
            base_imponible = (nvl(base_imponible,0) - nvl(o_base_imp,0))
        where id = :old.factura_id;
    END IF;

END;
/
ALTER TRIGGER "FUNDAUC"."T_DETALLE_FACTURA_AIUD" ENABLE;

--------------------------------------------------------
--  DDL for Trigger DETALLE_FACTURA_TRG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "FUNDAUC"."DETALLE_FACTURA_TRG" 
before insert on detalle_factura 
for each row 
begin
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.RENGLON IS NULL THEN
    
      SELECT DETALLE_FACTURA_SEQ.NEXTVAL INTO :NEW.RENGLON FROM SYS.DUAL;
      
      :new.subtotal := nvl(:new.cantidad,0) * nvl(:new.p_unidad,0);
    ELSIF updating THEN
    
        
        :new.subtotal := nvl(:new.cantidad,0) * nvl(:new.p_unidad,0);
    END IF;
  END COLUMN_SEQUENCES;
end;
/
ALTER TRIGGER "FUNDAUC"."DETALLE_FACTURA_TRG" ENABLE;


update inscripciones i set estatus =
(select 
case
      when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='Finalizado' and
      (case
           when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
           when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
           when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
           else 'X'
      end) = 'PC' then 'IFXC'
      when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='Finalizado' then 'IF'
      when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='En Curso' and 
      fecha_ins+9 < to_date(token(substr(UTL_PERIODOS.GETPERIODO(107),4),1,'-'),'DD/MM/YYYY') and
      (case
           when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
           when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
           when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
           else 'X'
      end) <> 'PC' then 'IF'
      when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='En Curso' and 
      (case
           when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
           when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
           when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
           else 'X'
      end) = 'X' then 'ACP'
      when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='En Curso' and 
      (case
           when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
           when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
           when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
           else 'X'
      end) = 'PC' then 'ACXC'
      when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='En Curso' and 
      (case
           when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
           when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
           when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
           else 'X'
      end) = 'E' then 'ACX'
      when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='Por Comenzar' and 
      (case
           when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
           when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
           when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
           else 'X'
      end) = 'X' then 'AEP'
      when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='Por Comenzar' and 
      (case
           when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
           when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
           when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
           else 'X'
      end) = 'PC' then 'AECX'
      when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='Por Comenzar' and 
      (case
           when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
           when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
           when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
           else 'X'
      end) = 'E' then 'AEX'
      when (case
           when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
           when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
           when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
           else 'X'
      end) = 'A' then 'AN'
    end estatus
from inscripciones where id = i.id)
/

create or replace TRIGGER INSCRIPCIONES_TRG 
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
      
          case
              when utl_periodos.getStatusPeriodoSec(:NEW.SECCION_ID)='En Curso' and p_estudiante_rec.condicion_especial <> 5 then 
                :NEW.ESTATUS :='ACXC';
                :NEW.ES_EXONERADO := 'N';
              when utl_periodos.getStatusPeriodoSec(:NEW.SECCION_ID)='En Curso' and p_estudiante_rec.condicion_especial = 5 then 
                :NEW.ESTATUS := 'ACX';
                :NEW.ES_EXONERADO := 'S';
              when utl_periodos.getStatusPeriodoSec(:NEW.SECCION_ID)='Por Comenzar' and p_estudiante_rec.condicion_especial <> 5 then 
                :NEW.ESTATUS := 'AECX';
                :NEW.ES_EXONERADO := 'N';
              when utl_periodos.getStatusPeriodoSec(:NEW.SECCION_ID)='Por COmenzar' and p_estudiante_rec.condicion_especial = 5 then 
                :NEW.ESTATUS := 'AEX';
          end case;
    
    END IF;
  END COLUMN_SEQUENCES;
END;

create or replace TRIGGER "T_DETALLE_FACTURA_BIUD" BEFORE
    DELETE OR INSERT OR UPDATE ON detalle_factura
    FOR EACH ROW
DECLARE
    p_factura_rec fundauc.tapi_factura.factura_rt;
    mon_exento number;
    o_mon_exento number;
    base_imp number;
    o_base_imp number;
    mon_iva number;
    o_mon_iva number;
    v_iva number;
    o_subtotal number;
BEGIN
    IF inserting THEN
        :new.subtotal := nvl(:new.cantidad,0) * nvl(:new.p_unidad,0);
        v_iva := UTL_CONFIGURACION.GETCONFIVA();

        if UTL_MATERIALES.GETEXENTOIVA(:NEW.MATERIALES_ID) = 'S' THEN 
            mon_exento := :new.subtotal;
        else
            base_imp := :new.subtotal;
            mon_iva := (base_imp*v_iva)/100;
        end if;

        update factura set monto = (nvl(monto,0) + nvl(:new.subtotal,0) + nvl(mon_iva,0)), 
            p_iva = nvl(v_iva,0), 
            monto_exento = (nvl(monto_exento,0) + nvl(mon_exento,0)), 
            base_imponible = (nvl(base_imponible,0) + nvl(base_imp,0)),
            monto_iva = (nvl(monto_iva,0) + nvl(mon_iva,0))
        where id = :new.factura_id;
    ELSIF updating THEN

        o_subtotal := nvl(:old.cantidad,0) * nvl(:old.p_unidad,0);
        :new.subtotal := nvl(:new.cantidad,0) * nvl(:new.p_unidad,0);


        v_iva := UTL_CONFIGURACION.GETCONFIVA();

        if UTL_MATERIALES.GETEXENTOIVA(:OLD.MATERIALES_ID) = 'S' THEN 
            o_mon_exento := :old.subtotal;
            mon_exento := :new.subtotal;
        else

            base_imp := :new.subtotal;
            o_base_imp := :old.subtotal;
            mon_iva := (base_imp*v_iva)/100;
            o_mon_iva := (o_base_imp*v_iva)/100;
        end if;

        update factura 
          set monto = (nvl(monto,0) - nvl(:old.subtotal,0) - nvl(o_mon_iva,0)) + nvl(:new.subtotal,0) + nvl(mon_iva,0), 
            p_iva = nvl(v_iva,0), 
            monto_exento = (nvl(monto_exento,0) - nvl(o_mon_exento,0)) + nvl(mon_exento,0), 
            base_imponible = (nvl(base_imponible,0) - nvl(o_base_imp,0)) + nvl(base_imp,0),
            monto_iva = (nvl(monto_iva,0) - nvl(o_mon_iva,0)) + nvl(mon_iva,0)
        where id = :new.factura_id;
    ELSIF deleting THEN

        o_subtotal := nvl(:old.cantidad,0) * nvl(:old.p_unidad,0);
        v_iva := UTL_CONFIGURACION.GETCONFIVA();

        if UTL_MATERIALES.GETEXENTOIVA(:OLD.MATERIALES_ID) = 'S' THEN 
            o_mon_exento := o_subtotal;
        else
            o_base_imp := o_subtotal;
            o_mon_iva := (o_base_imp*v_iva)/100;
        end if;
        update factura set monto = (nvl(monto,0) - nvl(:old.subtotal,0) ),
            monto_exento = (nvl(monto_exento,0) - nvl(o_mon_exento,0)),
            base_imponible = (nvl(base_imponible,0) - nvl(o_base_imp,0))
        where id = :old.factura_id;
    END IF;

END;