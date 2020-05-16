ALTER TABLE INSCRIPCIONES 
ADD (COHORTE_ID NUMBER );

ALTER TABLE INSCRIPCIONES
ADD CONSTRAINT INSCRIPCIONES_FK1 FOREIGN KEY
(
  COHORTE_ID 
)
REFERENCES COHORTES
(
  ID 
)
ENABLE;

COMMENT ON COLUMN INSCRIPCIONES.COHORTE_ID IS 'Cohorte id';

ALTER TABLE INSCRIPCIONES  
MODIFY (PROG_ACADEMICO NOT NULL);

create or replace TRIGGER T_COHORTES_AUID 
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
            P_MATERIALES_REC.cohorte_id := :NEW.ID;

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

        if :OLD.TIPO_DIPLO in ('DP','PC') then
          update materiales set descripcion = l_des_curso||' - '||l_ciudad
          where tipo=:OLD.TIPO_DIPLO and cohorte_id = :OLD.ID;
        elsif :OLD.TIPO_DIPLO = 'IC' then
          update materiales set descripcion = :NEW.ID_METODO||'|NIVEL '||lpad(:OLD.nivel,2,'0')||'|'||UTL_HORARIOS.GETHORARIO(:NEW.ID_HORARIO)||'|'||to_char(l_fecha,'DD/MM/YYYY')||'|'||utl_modalidades.getModalidad(:NEW.id_modalidad)
          where tipo=:OLD.TIPO_DIPLO and cohorte_id = :OLD.ID;
        end if;

    END IF;
  END;
  exception
    when no_data_found then null;
end;
/

--------------------------------------------------------
--  DDL for Table CTAXCOB
--------------------------------------------------------

  CREATE TABLE "FUNDAUC"."CTAXCOB" 
   (	"ID" NUMBER, 
	"CLIENTE_ID" NUMBER, 
	"FECHA" DATE, 
	"FACTURA_ID" NUMBER, 
	"DEPOSITO_ID" NUMBER, 
	"CREDITO" VARCHAR2(2 BYTE), 
	"MONTO" NUMBER(12,2)
   );
--------------------------------------------------------
--  DDL for Index CTAXCOB_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "FUNDAUC"."CTAXCOB_PK" ON "FUNDAUC"."CTAXCOB" ("ID");
--------------------------------------------------------
--  Constraints for Table CTAXCOB
--------------------------------------------------------

  ALTER TABLE "FUNDAUC"."CTAXCOB" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "FUNDAUC"."CTAXCOB" ADD CONSTRAINT "CTAXCOB_PK" PRIMARY KEY ("ID");
  ALTER TABLE "FUNDAUC"."CTAXCOB" MODIFY ("FECHA" NOT NULL ENABLE);
  ALTER TABLE "FUNDAUC"."CTAXCOB" MODIFY ("CREDITO" NOT NULL ENABLE);
  ALTER TABLE "FUNDAUC"."CTAXCOB" MODIFY ("MONTO" NOT NULL ENABLE);
  ALTER TABLE "FUNDAUC"."CTAXCOB" MODIFY ("CLIENTE_ID" NOT NULL ENABLE);


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
    
    FUNCTION getInscripcionesCohorte (
        vid_cohorte NUMBER
    ) RETURN NUMBER;

    FUNCTION getDesStatus (
        v_status VARCHAR2
    ) RETURN VARCHAR2;

    FUNCTION getStatusFac (
        vid_insc number
    ) RETURN VARCHAR2;

    PROCEDURE elimina_Inscripciones;

    PROCEDURE actualiza_Estatus;

    FUNCTION LOG_MESSAGE(MESSAGE IN VARCHAR2) RETURN NUMBER;

    FUNCTION getSeccionRec (
                p_renglon IN detalle_factura.renglon%TYPE 
               )
    RETURN seccion_rt RESULT_CACHE;
    
    FUNCTION getSeccionDes (
                p_id_seccion IN secciones.id%TYPE 
               )
    RETURN VARCHAR2;
    
    FUNCTION getCohorteDes (
                p_id_cohorte IN cohortes.id%TYPE 
               )
    RETURN VARCHAR2;

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
        dml := 'SELECT count(*) FROM Inscripciones WHERE estatus<>''IF'' and seccion_id = '|| vid_seccion;

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
    
    FUNCTION getInscripcionesCohorte (
        vid_cohorte NUMBER
    ) RETURN NUMBER AS
        eof  NUMBER;
        dml  VARCHAR2(2000);
    BEGIN
        dml := 'SELECT count(*) FROM Inscripciones WHERE estatus<>''IF'' and cohorte_id = '|| vid_cohorte;

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
    END getInscripcionesCohorte;

    FUNCTION getDesStatus (
        v_status VARCHAR2
    ) RETURN VARCHAR2 AS
        eof  VARCHAR2(50);
        dml  VARCHAR2(2000);
    BEGIN
      dml := 'SELECT CASE '||
       ' WHEN '''||v_status||''' = ''ACXC'' THEN ''Activa en Curso, por Cobrar'''||
       ' WHEN '''||v_status||''' = ''ACP'' THEN ''Activa en Curso, Pagada'''||
       ' WHEN '''||v_status||''' = ''AEXC'' THEN ''Activa por Comenzar, por Cobrar'''||
       ' WHEN '''||v_status||''' = ''AEP'' THEN ''Activa por Comenzar, Pagada'''||
       ' WHEN '''||v_status||''' = ''IF'' THEN ''Inactiva Finalizada'''||
       ' WHEN '''||v_status||''' = ''IFXC'' THEN ''Inactiva Finalizada, por Cobrar'''||
       ' WHEN '''||v_status||''' = ''AN'' THEN ''Anulada'''||
       ' WHEN '''||v_status||''' = ''AEX'' THEN ''Activa por Comenzar, Exonerado'''||
       ' WHEN '''||v_status||''' = ''ACX'' THEN ''Activa en Curso, Exonerado'''||
       ' WHEN '''||v_status||''' = ''AES'' THEN ''Activa por Comenzar, Suspendido'''||
       ' WHEN '''||v_status||''' = ''ACS'' THEN ''Activa en Curso, Suspendido'''||
       ' ELSE ''No Registrada'' END ESTATUS FROM dual';

        EXECUTE IMMEDIATE dml
        INTO eof;
--DBMS_OUTPUT.PUT_LINE(v_status);
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

    dbms_output.put_line('Entrando...'||vid_insc);
    dbms_output.put_line('ID='||vid_insc||' EXONERADO '||l_inscripciones_rec.es_exonerado||' SUSPENDIDO '||l_inscripciones_rec.es_suspendido);

      if (l_inscripciones_rec.es_exonerado = 'N' and l_inscripciones_rec.es_suspendido = 'N') THEN
          select * 
          into l_ins_fac_rec
          from inscripcion_factura
          where inscripcion_id = vid_insc;

          select * 
          into l_factura_rec
          from factura
          where id = l_ins_fac_rec.factura_id;
      end if;

    dbms_output.put_line('ID='||vid_insc||' EXONERADO '||l_inscripciones_rec.es_exonerado||' SUSPENDIDO '||l_inscripciones_rec.es_suspendido);

    CASE
    WHEN l_inscripciones_rec.es_exonerado = 'S' THEN eof := '<span class="rap-badge-exonerado">EXONERADO</span>';
    WHEN l_inscripciones_rec.es_suspendido = 'S' THEN eof := '<span class="rap-badge-exonerado">SUSPENDIDO</span>';
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

    PROCEDURE actualiza_estatus IS
        L_RC NUMBER;
    BEGIN
        L_RC := LOG_MESSAGE('[INFO] EJECUTANDO JOB ACTUALIZA ESTATUS INSCRIPCIONES ');

        for cur in (select id,
        case
              when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='Finalizado' and
              (case
                   when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
                   when instr(utl_inscripciones.getStatusFac(id),'SUSPENDIDO') > 1 then 'S'
                   when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
                   when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
                   else 'X'
              end) = 'PC' then 'IFXC'
              when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='Finalizado' then 'IF'
              when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='En Curso' and 
              fecha_ins+9 < to_date(token(substr(UTL_PERIODOS.GETPERIODO(107),4),1,'-'),'DD/MM/YYYY') and
              (case
                   when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
                   when instr(utl_inscripciones.getStatusFac(id),'SUSPENDIDO') > 1 then 'S'
                   when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
                   when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
                   else 'X'
              end) <> 'PC' then 'IF'
              when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='En Curso' and 
              (case
                   when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
                   when instr(utl_inscripciones.getStatusFac(id),'SUSPENDIDO') > 1 then 'S'
                   when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
                   when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
                   else 'X'
              end) = 'X' then 'ACP'
              when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='En Curso' and 
              (case
                   when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
                   when instr(utl_inscripciones.getStatusFac(id),'SUSPENDIDO') > 1 then 'S'
                   when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
                   when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
                   else 'X'
              end) = 'PC' then 'ACXC'
              when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='En Curso' and 
              (case
                   when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
                   when instr(utl_inscripciones.getStatusFac(id),'SUSPENDIDO') > 1 then 'S'
                   when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
                   when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
                   else 'X'
              end) = 'E' then 'ACX'
              when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='En Curso' and 
              (case
                   when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
                   when instr(utl_inscripciones.getStatusFac(id),'SUSPENDIDO') > 1 then 'S'
                   when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
                   when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
                   else 'X'
              end) = 'S' then 'ACS'
              when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='Por Comenzar' and 
              (case
                   when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
                   when instr(utl_inscripciones.getStatusFac(id),'SUSPENDIDO') > 1 then 'S'
                   when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
                   when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
                   else 'X'
              end) = 'X' then 'AEP'
              when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='Por Comenzar' and 
              (case
                   when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
                   when instr(utl_inscripciones.getStatusFac(id),'SUSPENDIDO') > 1 then 'S'
                   when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
                   when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
                   else 'X'
              end) = 'PC' then 'AECX'
              when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='Por Comenzar' and 
              (case
                   when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
                   when instr(utl_inscripciones.getStatusFac(id),'SUSPENDIDO') > 1 then 'S'
                   when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
                   when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
                   else 'X'
              end) = 'E' then 'AEX'
              when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='Por Comenzar' and 
              (case
                   when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
                   when instr(utl_inscripciones.getStatusFac(id),'SUSPENDIDO') > 1 then 'S'
                   when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
                   when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
                   else 'X'
              end) = 'S' then 'AES'
              when (case
                   when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
                   when instr(utl_inscripciones.getStatusFac(id),'SUSPENDIDO') > 1 then 'S'
                   when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
                   when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
                   else 'X'
              end) = 'A' then 'AN'
            end estatus
        from inscripciones where estatus <> 'IF') loop
             execute immediate 'update inscripciones set estatus='''||cur.estatus||''' where id='||cur.ID;
          end loop;

        DBMS_OUTPUT.PUT_LINE ('[INFO] JOB EJECUTADO');
        L_RC := LOG_MESSAGE('[INFO] JOB ACTUALIZA_ESTATUS EJECUTADO');
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
   
    FUNCTION getSeccionDes (
                p_id_seccion IN secciones.id%TYPE 
               )
    RETURN VARCHAR2
    IS
      l_seccion_des VARCHAR2(255);
   BEGIN

      select  S.ID_SECCION||'|'||s.id_metodo||'|NIVEL '||lpad(s.nivel,2,'0')||'|'||UTL_HORARIOS.GETHORARIO(S.ID_HORARIO)||'|'||to_char(cd.fecha_ini,'DD/MM/YYYY')||'|'||m.descripcion||'|'||id_salon SECCION
      into
          l_seccion_des
      from secciones s, modalidades M, calendarios_detalle cd
      where s.id = p_id_seccion
      and s.modalidad=m.id_modalidad
      and s.periodo = cd.id;

    --  DBMS_OUTPUT.PUT_LINE('id_periodo='||l_seccion_rec.id_periodo);

      RETURN l_seccion_des;

      exception
      when no_data_found then
         l_seccion_des := null;
         RETURN l_seccion_des;

   END getSeccionDes;
   
    FUNCTION getCohorteDes (
                p_id_cohorte IN cohortes.id%TYPE 
               )
    RETURN VARCHAR2
    IS
      l_cohorte_des VARCHAR2(255);
   BEGIN

      select upper(descripcion||' - '||cd.nombre) des
      into
          l_cohorte_des
      from diplomados d, cohortes c, ciudades cd
      where c.id = p_id_cohorte
      and c.diplomado_id=d.id
      and c.id_ciudad = cd.id_ciudad;

    --  DBMS_OUTPUT.PUT_LINE('id_periodo='||l_seccion_rec.id_periodo);

      RETURN l_cohorte_des;

      exception
      when no_data_found then
         l_cohorte_des := null;
         RETURN l_cohorte_des;

   END getCohorteDes;

END utl_inscripciones;

/
