--------------------------------------------------------
--  DDL for Trigger CALENDARIOS_DETALLE_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FUNDAUC"."CALENDARIOS_DETALLE_TRG" 
before insert on calendarios_detalle 
for each row 
begin
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT CALENDARIOS_DETALLE_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
end;
/
ALTER TRIGGER "FUNDAUC"."CALENDARIOS_DETALLE_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger CALENDARIOS_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FUNDAUC"."CALENDARIOS_TRG" 
BEFORE INSERT ON CALENDARIOS 
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID_CALENDARIO IS NULL THEN
      SELECT CALENDARIOS_SEQ.NEXTVAL INTO :NEW.ID_CALENDARIO FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/
ALTER TRIGGER "FUNDAUC"."CALENDARIOS_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger CIUDADES_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FUNDAUC"."CIUDADES_TRG" 
BEFORE INSERT ON CIUDADES 
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID_CIUDAD IS NULL THEN
      SELECT CIUDADES_SEQ.NEXTVAL INTO :NEW.ID_CIUDAD FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/
ALTER TRIGGER "FUNDAUC"."CIUDADES_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger CLIENTES_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FUNDAUC"."CLIENTES_TRG" 
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
ALTER TRIGGER "FUNDAUC"."CLIENTES_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger COHORTES_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FUNDAUC"."COHORTES_TRG" 
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
ALTER TRIGGER "FUNDAUC"."COHORTES_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger CONDICIONES_ESPECIALES_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FUNDAUC"."CONDICIONES_ESPECIALES_TRG" 
BEFORE INSERT ON CONDICIONES_ESPECIALES 
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID_CONDICION IS NULL THEN
      SELECT CONDICIONES_ESPECIALES_SEQ.NEXTVAL INTO :NEW.ID_CONDICION FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/
ALTER TRIGGER "FUNDAUC"."CONDICIONES_ESPECIALES_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger CTAXCOB_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FUNDAUC"."CTAXCOB_TRG" 
BEFORE INSERT ON CTAXCOB 
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT CTAXCOB_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;

/
ALTER TRIGGER "FUNDAUC"."CTAXCOB_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger DEPOSITO_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FUNDAUC"."DEPOSITO_TRG" 
BEFORE INSERT ON DEPOSITO 
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.REFERENCIA IS NULL THEN
      SELECT DEPOSITO_SEQ.NEXTVAL INTO :NEW.REFERENCIA FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/
ALTER TRIGGER "FUNDAUC"."DEPOSITO_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger DEPT_TRG1
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FUNDAUC"."DEPT_TRG1" 
              before insert on dept
              for each row
              begin
                  if :new.deptno is null then
                      select dept_seq.nextval into :new.deptno from sys.dual;
                 end if;
              end;
/
ALTER TRIGGER "FUNDAUC"."DEPT_TRG1" ENABLE;
--------------------------------------------------------
--  DDL for Trigger DETALLE_FACTURA_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FUNDAUC"."DETALLE_FACTURA_TRG" 
before insert on detalle_factura 
for each row 
begin
  <<COLUMN_SEQUENCES>>
  BEGIN
    NULL;
  END COLUMN_SEQUENCES;
end;
/
ALTER TRIGGER "FUNDAUC"."DETALLE_FACTURA_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger DIPLOMADOS_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FUNDAUC"."DIPLOMADOS_TRG" 
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
ALTER TRIGGER "FUNDAUC"."DIPLOMADOS_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger EMP_TRG1
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FUNDAUC"."EMP_TRG1" 
              before insert on emp
              for each row
              begin
                  if :new.empno is null then
                      select emp_seq.nextval into :new.empno from sys.dual;
                 end if;
              end;
/
ALTER TRIGGER "FUNDAUC"."EMP_TRG1" ENABLE;
--------------------------------------------------------
--  DDL for Trigger ESTUDIANTE_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FUNDAUC"."ESTUDIANTE_TRG" 
BEFORE INSERT OR UPDATE ON ESTUDIANTE 
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.MATRICULA IS NULL THEN
      SELECT MAX(MATRICULA)+1 INTO :NEW.MATRICULA FROM ESTUDIANTE;
    ELSIF UPDATING THEN
      :NEW.MODIFICADO_POR := coalesce(sys_context('APEX$SESSION', 'app_user'), regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), sys_context('userenv', 'session_user'));
      :NEW.MODIFICADO_EL := SYSDATE;
    END IF;
  END COLUMN_SEQUENCES;
END;
/
ALTER TRIGGER "FUNDAUC"."ESTUDIANTE_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger FACTURA_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FUNDAUC"."FACTURA_TRG" 
before insert on factura 
for each row 
begin
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT FACTURA_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
end;
/
ALTER TRIGGER "FUNDAUC"."FACTURA_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger HOJA_VIDA_EST_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FUNDAUC"."HOJA_VIDA_EST_TRG" 
BEFORE INSERT ON HOJA_VIDA_EST 
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT HOJA_VIDA_EST_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;


/
ALTER TRIGGER "FUNDAUC"."HOJA_VIDA_EST_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger HORARIOS_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FUNDAUC"."HORARIOS_TRG" 
before insert on horarios 
for each row 
begin
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID_HORARIO IS NULL THEN
      SELECT HORARIOS_SEQ.NEXTVAL INTO :NEW.ID_HORARIO FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
end;
/
ALTER TRIGGER "FUNDAUC"."HORARIOS_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger INSCRIPCIONES_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FUNDAUC"."INSCRIPCIONES_TRG" 
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
                :NEW.ESTATUS := 'AEXC';
                :NEW.ES_EXONERADO := 'N';
              when utl_periodos.getStatusPeriodoSec(:NEW.SECCION_ID)='Por Comenzar' and p_estudiante_rec.condicion_especial = 5 then 
                :NEW.ESTATUS := 'AEX';
                :NEW.ES_EXONERADO := 'S';
          end case;

    END IF;
  END COLUMN_SEQUENCES;
END;
/
ALTER TRIGGER "FUNDAUC"."INSCRIPCIONES_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger INSTANCIAS_SECCIONES_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FUNDAUC"."INSTANCIAS_SECCIONES_TRG" 
BEFORE INSERT ON INSTANCIAS_SECCIONES 
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT INSTANCIAS_SECCIONES_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/
ALTER TRIGGER "FUNDAUC"."INSTANCIAS_SECCIONES_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger MATERIALES_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FUNDAUC"."MATERIALES_TRG" 
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
--  DDL for Trigger SECCIONES_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FUNDAUC"."SECCIONES_TRG" 
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
/
ALTER TRIGGER "FUNDAUC"."SECCIONES_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger T_COHORTES_AUID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FUNDAUC"."T_COHORTES_AUID" 
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

            P_PRECIOS_REC.id := P_MATERIALES_REC.id;
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
ALTER TRIGGER "FUNDAUC"."T_COHORTES_AUID" ENABLE;
--------------------------------------------------------
--  DDL for Trigger T_DETALLE_FACTURA_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FUNDAUC"."T_DETALLE_FACTURA_AIUD" AFTER
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
--  DDL for Trigger T_FACTURA_DEPOSITO_SEQ
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FUNDAUC"."T_FACTURA_DEPOSITO_SEQ" 
   after insert on "FUNDAUC"."FACTURA_DEPOSITO" 
   for each row 
declare   
   P_FACTURA_REC FUNDAUC.TAPI_FACTURA.FACTURA_RT;
   P_CTAXCOB_REC FUNDAUC.TAPI_CTAXCOB.CTAXCOB_RT;
   P_IGNORE_NULLS BOOLEAN;
   P_ULT_FAC NUMBER := UTL_CONFIGURACION.getConfUltFactura();
   l_es_credito varchar2(1);
   l_rif  varchar2(16);
   l_ctaxcob number := 0;
   l_monto_fac number := 0;
begin  
   if inserting then 
      if :NEW."FACTURA_ID" is not null then 
        select escredito into l_es_credito from table(tapi_factura.tt(:NEW.FACTURA_ID));


        P_IGNORE_NULLS := TRUE;

          P_FACTURA_REC.ID := :NEW.FACTURA_ID;
          P_FACTURA_REC.ID_FACT := P_ULT_FAC;
          if l_es_credito = 'S' then
            P_FACTURA_REC.STATUS := 'PP';
          else
            P_FACTURA_REC.STATUS := 'V';
          end if;
          P_FACTURA_REC.FECHA_EMI := SYSDATE;
          P_FACTURA_REC.FACTURADO_POR := coalesce(sys_context('APEX$SESSION', 'app_user'), regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), sys_context('userenv', 'session_user'));

          TAPI_FACTURA.UPD(
            P_FACTURA_REC => P_FACTURA_REC,
            P_IGNORE_NULLS => P_IGNORE_NULLS
          );

          UTL_CONFIGURACION.actConfUltFactura(P_ULT_FAC);

          if l_es_credito = 'S' then
            select rif, fecha_emi, id, monto 
              into l_rif,P_CTAXCOB_REC.FECHA,P_CTAXCOB_REC.FACTURA_ID, l_monto_fac  
              from table(tapi_factura.tt(:NEW.FACTURA_ID));

            select id into P_CTAXCOB_REC.CLIENTE_ID from clientes where rif = l_rif;

            select count(*) into l_ctaxcob from ctaxcob where factura_id = :NEW.FACTURA_ID;

            if l_ctaxcob = 0 then
              P_CTAXCOB_REC.DEPOSITO_ID := :NEW.DEPOSITO_ID;
              P_CTAXCOB_REC.CREDITO := 'DB';
              P_CTAXCOB_REC.MONTO := l_monto_fac;
            else
              P_CTAXCOB_REC.DEPOSITO_ID := :NEW.DEPOSITO_ID;
              P_CTAXCOB_REC.CREDITO := 'CR';
              select monto into P_CTAXCOB_REC.MONTO from table(tapi_deposito.tt(:NEW.DEPOSITO_ID));
            end if;

            tapi_ctaxcob.ins(p_ctaxcob_rec => p_ctaxcob_rec);

          end if;


      end if; 
   end if; 
end;

/
ALTER TRIGGER "FUNDAUC"."T_FACTURA_DEPOSITO_SEQ" ENABLE;
--------------------------------------------------------
--  DDL for Trigger T_INSCRIPCIONES_BID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FUNDAUC"."T_INSCRIPCIONES_BID" AFTER
    DELETE OR INSERT OR UPDATE ON inscripciones
    FOR EACH ROW
DECLARE
    p_factura_rec           fundauc.tapi_factura.factura_rt;
    p_estudiante_rec        fundauc.tapi_estudiante.estudiante_rt;
    p_cond_especial_rec     fundauc.tapi_condiciones_especiales.condiciones_especiales_rt;
    p_detalle_factura_rec   fundauc.tapi_detalle_factura.detalle_factura_rt;
    p_material_mat_rec      fundauc.utl_materiales.detalle_factura_rt;
    p_hoja_vida_est_rec     fundauc.tapi_hoja_vida_est.hoja_vida_est_rt;
    l_precio                NUMBER := 0;
    l_fact_id               NUMBER := 0;
    l_modalidad             NUMBER := 0;
    P_IGNORE_NULLS          BOOLEAN;
    l_facid                 NUMBER := 0;
    l_renglonid             NUMBER := 0;
BEGIN
    IF
        inserting  --si esta insertando
    THEN
        --llena registro estudiante con el numero de matricula
        p_estudiante_rec := tapi_estudiante.rt(p_matricula =>:new.est_matricula);
        --llena registro de condicion especial
        p_cond_especial_rec := tapi_condiciones_especiales.rt(p_id_condicion => p_estudiante_rec.condicion_especial);

        -- si el codigo de la seccion no esta vacio
        if :NEW.SECCION_ID is not null then
            -- llena la variable modalidad de la seccion
            SELECT
                modalidad
            INTO
                l_modalidad
            FROM
                TABLE ( tapi_secciones.tt(:new.seccion_id) );
        end if;

        -- si el codigo de la cohorte no es nulo
        if :NEW.COHORTE_ID is not null then
            SELECT
                id_modalidad
            INTO
                l_modalidad
            FROM
                TABLE ( tapi_cohortes.tt(:new.cohorte_id) );
        end if;

        -- si la condicion especial no es EXONERADO o no es suspendido
        IF
            p_estudiante_rec.condicion_especial != 5 OR :new.es_suspendido != 'S'
        THEN
            -- llena registro de factura
            p_factura_rec.id_fact := NULL;
            p_factura_rec.tipo := 'FA';
            p_factura_rec.cedula_est := p_estudiante_rec.cedula_est;
            p_factura_rec.nombre_cliente := p_estudiante_rec.nombre
            || ' '
            || p_estudiante_rec.apellido;
            p_factura_rec.fecha_emi := NULL;
            p_factura_rec.monto := 0;
            p_factura_rec.p_iva := 0;
            p_factura_rec.monto_iva := 0;
            p_factura_rec.flete := 0;
            p_factura_rec.bs_descuento := 0;
            p_factura_rec.dir_fiscal := p_estudiante_rec.direccion;
            p_factura_rec.rif := p_estudiante_rec.cedula_est;
            p_factura_rec.status := 'PC';
            p_factura_rec.programa := global.getval('SEDE');
            p_factura_rec.prog_academico := to_number(global.getval('PROG') );
            p_factura_rec.creado_por := coalesce(sys_context('APEX$SESSION','app_user'),regexp_substr(sys_context('userenv','client_identifier'
),'^[^:]*'),sys_context('userenv','session_user') );
            p_factura_rec.creado_el := SYSDATE;
            p_factura_rec.monto_exento := 0;
            p_factura_rec.base_imponible := 0;
            p_factura_rec.escredito := 'N';
            p_factura_rec.id := factura_seq.nextval;

            --inserta registro de factura
            tapi_factura.ins(p_factura_rec => p_factura_rec);

            --inserta en inscripcion_factura
            INSERT INTO inscripcion_factura (
                inscripcion_id,
                factura_id
            ) VALUES (
                :new.id,
                p_factura_rec.id
            );

            -- si el tipo de estudiante es NUEVO INGRESO
            IF
                p_estudiante_rec.id_tipo_est = 0
            THEN
                --llena el registro de materiales con el codigo de la seccion y el tipo de material CURSO
                p_material_mat_rec := utl_materiales.getrecdetallefac(:new.seccion_id,'C');
                -- llena el registro del detalle de la factura del CURSO
                p_detalle_factura_rec.renglon := detalle_factura_seq.nextval;
                p_detalle_factura_rec.tipo_item := p_material_mat_rec.tipo_item;
                p_detalle_factura_rec.item := p_material_mat_rec.item;
                p_detalle_factura_rec.descripcion := p_material_mat_rec.descripcion;
                p_detalle_factura_rec.cantidad := p_material_mat_rec.cantidad;
                p_detalle_factura_rec.p_unidad := p_material_mat_rec.p_unidad;
                p_detalle_factura_rec.bs_descuento := p_material_mat_rec.bs_descuento;
                p_detalle_factura_rec.subtotal := p_material_mat_rec.subtotal;
                p_detalle_factura_rec.materiales_id := p_material_mat_rec.materiales_id;
                p_detalle_factura_rec.factura_id := p_factura_rec.id;

                --inserta el detalle de la factura de CURSO
                tapi_detalle_factura.ins(p_detalle_factura_rec => p_detalle_factura_rec);

                --llena registro de la hojade vida para CURSO
                p_hoja_vida_est_rec.id := hoja_vida_est_seq.nextval;
                p_hoja_vida_est_rec.matricula :=:new.est_matricula;
                p_hoja_vida_est_rec.evento_id := 2;
                p_hoja_vida_est_rec.fecha := systimestamp;
                
                --si es seccion
                if :NEW.SECCION_ID is not null then
                  -- elcampometadata con el json del seccion
                  p_hoja_vida_est_rec.metadata := get_inscripcion_json(:new.id,'S',:new.seccion_id);
                end if; 
                --si es chorte
                if :NEW.COHORTE_ID is not null then
                  --llena el campo metadata con el json de la cohorte
                  p_hoja_vida_est_rec.metadata := get_inscripcion_json(:new.id,'C',:new.cohorte_id);
                end if;  
                --llena el campo observacion con el estatus de la inscripcion
                p_hoja_vida_est_rec.observacion := upper(utl_inscripciones.getdesstatus(:new.estatus) );
                --inserta en la hoja de vida para CURSO
                tapi_hoja_vida_est.ins(p_hoja_vida_est_rec);

                -- llena registro de material con el codigo de INSCRIPCION
                p_material_mat_rec := utl_materiales.getrecdetallefac('IN01');
                -- llena el registro de detalle de factura de INSCRIPCION
                p_detalle_factura_rec.renglon := detalle_factura_seq.nextval;
                p_detalle_factura_rec.tipo_item := p_material_mat_rec.tipo_item;
                p_detalle_factura_rec.item := p_material_mat_rec.item;
                p_detalle_factura_rec.descripcion := p_material_mat_rec.descripcion;
                p_detalle_factura_rec.cantidad := p_material_mat_rec.cantidad;
                p_detalle_factura_rec.p_unidad := p_material_mat_rec.p_unidad;
                p_detalle_factura_rec.bs_descuento := p_material_mat_rec.bs_descuento;
                p_detalle_factura_rec.subtotal := p_material_mat_rec.subtotal;
                p_detalle_factura_rec.materiales_id := p_material_mat_rec.materiales_id;
                p_detalle_factura_rec.factura_id := p_factura_rec.id;
                -- Inserta detalle de factura de INSCRIPCION
                tapi_detalle_factura.ins(p_detalle_factura_rec => p_detalle_factura_rec);

                -- llena registro hoja de vida para INSCRIPCION
                p_hoja_vida_est_rec.id := hoja_vida_est_seq.nextval;
                p_hoja_vida_est_rec.matricula :=:new.est_matricula;
                p_hoja_vida_est_rec.evento_id := 1;
                p_hoja_vida_est_rec.fecha := systimestamp;
                p_hoja_vida_est_rec.metadata := NULL;
                p_hoja_vida_est_rec.observacion := 'PAGO DE INSCRIPCION';

                -- Inserta en hoja de vida para INSCRIPCION
                tapi_hoja_vida_est.ins(p_hoja_vida_est_rec);
            ELSE --si el tipo de estudiante no es NUEVO INGRESO
                --llena registro materiales con info de CURSO
                p_material_mat_rec := utl_materiales.getrecdetallefac(:new.seccion_id,'C');
                --llena registro del detalle factura para CURSO 
                p_detalle_factura_rec.renglon := detalle_factura_seq.nextval;
                p_detalle_factura_rec.tipo_item := p_material_mat_rec.tipo_item;
                p_detalle_factura_rec.item := p_material_mat_rec.item;
                p_detalle_factura_rec.descripcion := p_material_mat_rec.descripcion;
                p_detalle_factura_rec.cantidad := p_material_mat_rec.cantidad;
                p_detalle_factura_rec.p_unidad := p_material_mat_rec.p_unidad;
                p_detalle_factura_rec.bs_descuento := p_material_mat_rec.bs_descuento;
                p_detalle_factura_rec.subtotal := p_material_mat_rec.subtotal;
                p_detalle_factura_rec.materiales_id := p_material_mat_rec.materiales_id;
                p_detalle_factura_rec.factura_id := p_factura_rec.id;
                --inserta detalle factura para CURSO
                tapi_detalle_factura.ins(p_detalle_factura_rec => p_detalle_factura_rec);
                -- llena registro hoja de vida para CURSO
                p_hoja_vida_est_rec.id := hoja_vida_est_seq.nextval;
                p_hoja_vida_est_rec.matricula :=:new.est_matricula;
                p_hoja_vida_est_rec.evento_id := 2;
                p_hoja_vida_est_rec.fecha := systimestamp;
                --si es seccion
                if :NEW.SECCION_ID is not null then
                  p_hoja_vida_est_rec.metadata := get_inscripcion_json(:new.id,'S',:new.seccion_id);
                end if; 
                --si es cohorte
                if :NEW.COHORTE_ID is not null then
                  p_hoja_vida_est_rec.metadata := get_inscripcion_json(:new.id,'C',:new.cohorte_id);
                end if;  
                -- lleno observacion con el estado del la inscripcion
                p_hoja_vida_est_rec.observacion := upper(utl_inscripciones.getdesstatus(:new.estatus) );
                --inserta registro de hoja de vida para CURSO
                tapi_hoja_vida_est.ins(p_hoja_vida_est_rec);
                
                -- llena registro de materiales con el concepto de INSCRIPCION
                p_material_mat_rec := utl_materiales.getrecdetallefac('IN01');
                p_detalle_factura_rec.renglon := detalle_factura_seq.nextval;
                p_detalle_factura_rec.tipo_item := p_material_mat_rec.tipo_item;
                p_detalle_factura_rec.item := p_material_mat_rec.item;
                p_detalle_factura_rec.descripcion := p_material_mat_rec.descripcion;
                p_detalle_factura_rec.cantidad := p_material_mat_rec.cantidad;
                p_detalle_factura_rec.p_unidad := p_material_mat_rec.p_unidad;
                p_detalle_factura_rec.bs_descuento := p_material_mat_rec.bs_descuento;
                p_detalle_factura_rec.subtotal := p_material_mat_rec.subtotal;
                p_detalle_factura_rec.materiales_id := p_material_mat_rec.materiales_id;
                p_detalle_factura_rec.factura_id := p_factura_rec.id;
                --inserta registro de detalle de facatura para INSCRIPCION
                tapi_detalle_factura.ins(p_detalle_factura_rec => p_detalle_factura_rec);
                --llena registro hoja de vida para INSCRIPCION
                p_hoja_vida_est_rec.id := hoja_vida_est_seq.nextval;
                p_hoja_vida_est_rec.matricula :=:new.est_matricula;
                p_hoja_vida_est_rec.evento_id := 1;
                p_hoja_vida_est_rec.fecha := systimestamp;
                p_hoja_vida_est_rec.metadata := NULL;
                p_hoja_vida_est_rec.observacion := 'PAGO DE INSCRIPCION';
                --Inserta registro hoja de vida para inscripcion
                tapi_hoja_vida_est.ins(p_hoja_vida_est_rec);


            END IF; -- fin si el estudiante es NUEVO ingreso o no

            --si el estudiante tiene algun tipo de DESCUENTO
            IF
                p_cond_especial_rec.descuento IS NOT NULL
            THEN
                --llena registro de materia con el DESCUENTO
                p_material_mat_rec := utl_materiales.getrecdetallefac(p_cond_especial_rec.descuento);
                -- recalcula el precio con el descuento
                l_precio := ( ( ( p_detalle_factura_rec.cantidad * p_detalle_factura_rec.p_unidad ) * p_cond_especial_rec.porcentaje ) / 100 ) *-1;
                --actualiza la tabla de precios
                UPDATE precios
                    SET
                        precio1 = l_precio
                WHERE
                    id = p_material_mat_rec.materiales_id;
                --llena registro detalle_factura con el DESCUENTO
                p_detalle_factura_rec.renglon := detalle_factura_seq.nextval;
                p_detalle_factura_rec.tipo_item := p_material_mat_rec.tipo_item;
                p_detalle_factura_rec.item := p_material_mat_rec.item;
                p_detalle_factura_rec.descripcion := p_material_mat_rec.descripcion;
                p_detalle_factura_rec.cantidad := p_material_mat_rec.cantidad;
                p_detalle_factura_rec.p_unidad := l_precio; --p_material_cur.p_unidad;
                p_detalle_factura_rec.bs_descuento := p_material_mat_rec.bs_descuento;
                p_detalle_factura_rec.subtotal := p_material_mat_rec.subtotal;
                p_detalle_factura_rec.materiales_id := p_material_mat_rec.materiales_id;
                p_detalle_factura_rec.factura_id := p_factura_rec.id;
                --inserta registro en detalle_factura para DESCUENTO
                tapi_detalle_factura.ins(p_detalle_factura_rec => p_detalle_factura_rec);
                --llena registro hova de vida para DESCUENTO
                p_hoja_vida_est_rec.id := hoja_vida_est_seq.nextval;
                p_hoja_vida_est_rec.matricula :=:new.est_matricula;
                p_hoja_vida_est_rec.evento_id := 53;
                p_hoja_vida_est_rec.fecha := systimestamp;
                --si es seccion
                if :NEW.SECCION_ID is not null then
                  p_hoja_vida_est_rec.metadata := get_inscripcion_json(:new.id,'S',:new.seccion_id);
                end if; 
                --si es cohorte
                if :NEW.COHORTE_ID is not null then
                  p_hoja_vida_est_rec.metadata := get_inscripcion_json(:new.id,'C',:new.cohorte_id);
                end if;  
                p_hoja_vida_est_rec.observacion := 'Descuento del '
                || p_cond_especial_rec.porcentaje
                || '%, por condición especial ('
                || p_cond_especial_rec.descripcion
                || ')';
                -- inserta en hoja de vida para DESCUENTO
                tapi_hoja_vida_est.ins(p_hoja_vida_est_rec);
            END IF; -- fin si tiene descuento

        ELSE -- si el estudiante esta EXONERADO o es SUSPENDIDO
            --si es exonerado
            if :NEW.es_exonerado = 'S' then
                --llena registro de hoja de vida para EXONERADO O BECADO
                p_hoja_vida_est_rec.id := hoja_vida_est_seq.nextval;
                p_hoja_vida_est_rec.matricula :=:new.est_matricula;
                p_hoja_vida_est_rec.evento_id := 29;
                p_hoja_vida_est_rec.fecha := systimestamp;
                --si es seccion
                if :NEW.SECCION_ID is not null then
                  p_hoja_vida_est_rec.metadata := get_inscripcion_json(:new.id,'S',:new.seccion_id);
                end if; 
                --si es cohorte
                if :NEW.COHORTE_ID is not null then
                  p_hoja_vida_est_rec.metadata := get_inscripcion_json(:new.id,'C',:new.cohorte_id);
                end if;  
                p_hoja_vida_est_rec.observacion := 'ESTUDIANTE EXONERADO O BECADO';
                
             --   tapi_hoja_vida_est.ins(p_hoja_vida_est_rec);
            elsif :NEW.es_suspendido = 'S' then -- Si es Suspendido
                --llena registro de hoja de vida para SUSPENDIDO
                p_hoja_vida_est_rec.id := hoja_vida_est_seq.nextval;
                p_hoja_vida_est_rec.matricula :=:new.est_matricula;
                p_hoja_vida_est_rec.evento_id := 51;
                p_hoja_vida_est_rec.fecha := systimestamp;
                --si es seccion
                if :NEW.SECCION_ID is not null then
                  p_hoja_vida_est_rec.metadata := get_inscripcion_json(:new.id,'S',:new.seccion_id);
                end if; 
                --si es cohorte
                if :NEW.COHORTE_ID is not null then
                  p_hoja_vida_est_rec.metadata := get_inscripcion_json(:new.id,'C',:new.cohorte_id);
                end if;  
                p_hoja_vida_est_rec.observacion := 'ESTUDIANTE SUSPENDIO CURSO';

              END IF; --fin si es exonerado o suspendido
              -- inserta hoja de vida para EXONERADO O BECADO
              tapi_hoja_vida_est.ins(p_hoja_vida_est_rec);

        end if;

    ELSIF deleting THEN --si esta borrando registro
        -- trae el id de la factura de la inscripcion
        SELECT
            factura_id
        INTO
            l_fact_id
        FROM
            inscripcion_factura
        WHERE
            inscripcion_id =:old.id;
        --elimina registro de inscripcion factura
        DELETE FROM inscripcion_factura
        WHERE
            inscripcion_id =:old.id;
        --elimina registro detalle de la factura
        DELETE FROM detalle_factura WHERE
            factura_id = l_fact_id;
        --elimina registro de factura
        DELETE FROM factura WHERE
            id = l_fact_id;
    ELSIF updating THEN -- si esta modificando inscripcion

        -- si cambio el codigo de la seccion
        if :NEW.SECCION_ID<>:OLD.SECCION_ID then
          -- trae el id de la factura de inscripcion_factura
          select factura_id into l_facid from inscripcion_factura where inscripcion_id = :OLD.ID;
          -- trae el renglon del detalle de la factura donde sea curso
          select renglon into l_renglonid from detalle_factura where factura_id = l_facid and tipo_item='C';

          -- llena el registro de materiales con la nueva seccion
          p_material_mat_rec := utl_materiales.getrecdetallefac(:new.seccion_id,'C');

          P_IGNORE_NULLS := TRUE;

          -- llena el registro del detalle de la factura a modificar
          p_detalle_factura_rec.renglon := l_renglonid;
          p_detalle_factura_rec.item := p_material_mat_rec.item;
          p_detalle_factura_rec.materiales_id := p_material_mat_rec.materiales_id;
          p_detalle_factura_rec.descripcion := p_material_mat_rec.descripcion;

          --modifica registro del detalle de factura
          TAPI_DETALLE_FACTURA.UPD(
            P_DETALLE_FACTURA_REC => P_DETALLE_FACTURA_REC,
            P_IGNORE_NULLS => P_IGNORE_NULLS
          );
            -- llena registro de hoja de vida CAMBIO DE SECCION
            p_hoja_vida_est_rec.id := hoja_vida_est_seq.nextval;
            p_hoja_vida_est_rec.matricula :=:new.est_matricula;
            p_hoja_vida_est_rec.evento_id := 66;
            p_hoja_vida_est_rec.fecha := systimestamp;
            --si es seccion
            if :NEW.SECCION_ID is not null then
              p_hoja_vida_est_rec.metadata := get_inscripcion_json(:new.id,'S',:new.seccion_id);
            end if; 
            --si es cohorte
            if :NEW.COHORTE_ID is not null then
              p_hoja_vida_est_rec.metadata := get_inscripcion_json(:new.id,'C',:new.cohorte_id);
            end if;  
            p_hoja_vida_est_rec.observacion := 'CAMBIO DE SECCION '||utl_inscripciones.getSeccionCod(:OLD.SECCION_ID)||' PARA '||utl_inscripciones.getSeccionCod(:NEW.SECCION_ID);
            --inserta registro de hoja de vida
            tapi_hoja_vida_est.ins(p_hoja_vida_est_rec);
         end if;
   END IF;

EXCEPTION
    WHEN no_data_found THEN
        NULL;
END;
/
ALTER TRIGGER "FUNDAUC"."T_INSCRIPCIONES_BID" ENABLE;
--------------------------------------------------------
--  DDL for Trigger T_SECCIONES_AUID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FUNDAUC"."T_SECCIONES_AUID" 
AFTER
    UPDATE OF PERIODO, MODALIDAD, ID_HORARIO OR DELETE OR INSERT ON  secciones 
for each row 
DECLARE
  l_precio number;
  P_MATERIALES_REC FUNDAUC.TAPI_MATERIALES.MATERIALES_RT;
  P_PRECIOS_REC FUNDAUC.TAPI_PRECIOS.PRECIOS_RT;
  P_INSTANCIAS_SECCIONES_REC FUNDAUC.TAPI_INSTANCIAS_SECCIONES.INSTANCIAS_SECCIONES_RT;
  l_id  number;
  P_IGNORE_NULLS          BOOLEAN;

begin
  BEGIN

    IF INSERTING THEN -- inserta
      --Inserta Secciones nuevas
          -- selecciona el maximo precio entre todos los cursos
          select max(precio1) into l_precio from precios
          where tipo_item = 'C';
            --llena el registro de materiales con la SECCION
            P_MATERIALES_REC.id_mat := :NEW.ID_SECCION;
            P_MATERIALES_REC.tipo := 'C';
            P_MATERIALES_REC.descripcion := :NEW.ID_METODO||'|NIVEL '||lpad(:NEW.nivel,2,'0')||'|'||UTL_HORARIOS.GETHORARIO(:NEW.ID_HORARIO)||'|'||to_char(utl_periodos.getPeriodoFInicio(:NEW.PERIODO),'DD/MM/YYYY')||'|'||utl_modalidades.getModalidad(:NEW.modalidad)||'|'||:NEW.id_salon;
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
            P_MATERIALES_REC.cohorte_id := null;
      --inserta registro de materiales
      TAPI_MATERIALES.INS(P_MATERIALES_REC);
            --llena registro de precios
            P_PRECIOS_REC.id := P_MATERIALES_REC.id;
            P_PRECIOS_REC.tipo_item := P_MATERIALES_REC.tipo;
            P_PRECIOS_REC.fecha := SYSDATE;
            P_PRECIOS_REC.precio1 := l_precio;
            P_PRECIOS_REC.precio2 := 0;
            P_PRECIOS_REC.precio3 := 0;
            P_PRECIOS_REC.status := 'V';
            P_PRECIOS_REC.precio4 := 0;
            P_PRECIOS_REC.precio5 := 0;

        --Inserta registro de precios
        TAPI_PRECIOS.INS(P_PRECIOS_REC);
        
        -- llena registro de instancias secciones
        P_INSTANCIAS_SECCIONES_REC.seccion_id := :NEW.ID;
        P_INSTANCIAS_SECCIONES_REC.codigo_sec := :NEW.ID_SECCION;
        P_INSTANCIAS_SECCIONES_REC.metodo_id  := :NEW.ID_METODO;
        P_INSTANCIAS_SECCIONES_REC.nivel := :NEW.NIVEL;
        P_INSTANCIAS_SECCIONES_REC.periodo_id := :NEW.PERIODO;
        P_INSTANCIAS_SECCIONES_REC.horario_id := :NEW.ID_HORARIO;
        P_INSTANCIAS_SECCIONES_REC.modalidad_id := :NEW.MODALIDAD;
        P_INSTANCIAS_SECCIONES_REC.cedula_prof := :NEW.CEDULA_PROF;
        P_INSTANCIAS_SECCIONES_REC.f_inicio := utl_periodos.getPeriodoFInicio(:NEW.PERIODO);
        P_INSTANCIAS_SECCIONES_REC.f_fin := utl_periodos.getPeriodoFFin(:NEW.PERIODO);
        P_INSTANCIAS_SECCIONES_REC.estatus := 'ABIERTA';
    
        --Inserta registro de instancias secciones
        TAPI_INSTANCIAS_SECCIONES.INS(P_INSTANCIAS_SECCIONES_REC);

    ELSIF updating then -- si se esta modificando
        -- actualiza tabla de materiales con la descripcion modificada
        update materiales set descripcion = :NEW.ID_METODO||'|NIVEL '||lpad(:NEW.nivel,2,'0')||'|'||UTL_HORARIOS.GETHORARIO(:NEW.ID_HORARIO)||'|'||to_char(nvl(utl_periodos.getPeriodoFecIniSec(:NEW.ID),utl_periodos.getPeriodoFecIniSec(:OLD.ID)),'DD/MM/YYYY')||'|'||utl_modalidades.getModalidad(:NEW.modalidad)||'|'||:NEW.id_salon
               where tipo='C' and seccion_id = :OLD.ID;
                
        select id into P_INSTANCIAS_SECCIONES_REC.id 
        from INSTANCIAS_SECCIONES
        where seccion_id = :OLD.ID;
          
        P_IGNORE_NULLS := TRUE;
        
        if :NEW.ID_SECCION<>:OLD.ID_SECCION then
            P_INSTANCIAS_SECCIONES_REC.codigo_sec := :NEW.ID_SECCION;
        end if;
        if :NEW.ID_METODO<>:OLD.ID_METODO then
            P_INSTANCIAS_SECCIONES_REC.metodo_id  := :NEW.ID_METODO;
        end if;
        if :NEW.NIVEL<>:OLD.NIVEL then
            P_INSTANCIAS_SECCIONES_REC.nivel := :NEW.NIVEL;
        end if;
        if :NEW.PERIODO<>:OLD.PERIODO then
            P_INSTANCIAS_SECCIONES_REC.periodo_id := :NEW.PERIODO;
        end if;
        if :NEW.ID_HORARIO<>:OLD.ID_HORARIO then
            P_INSTANCIAS_SECCIONES_REC.horario_id := :NEW.ID_HORARIO;
        end if;
        if :NEW.MODALIDAD<>:OLD.MODALIDAD then
            P_INSTANCIAS_SECCIONES_REC.modalidad_id := :NEW.MODALIDAD;
        end if;
        if :NEW.CEDULA_PROF<>:OLD.CEDULA_PROF then
            P_INSTANCIAS_SECCIONES_REC.cedula_prof := :NEW.CEDULA_PROF;
        end if;
      
        TAPI_INSTANCIAS_SECCIONES.UPD(
            P_INSTANCIAS_SECCIONES_REC => P_INSTANCIAS_SECCIONES_REC,
            P_IGNORE_NULLS => P_IGNORE_NULLS
        );

      --si cambio el periodo o la modalidad o el horario
/*      if :NEW.PERIODO<>:OLD.PERIODO or :NEW.MODALIDAD<>:OLD.MODALIDAD or :NEW.ID_HORARIO<>:OLD.ID_HORARIO then

            update inscripciones set estatus = 'IF'
            where estatus not in ('ACXC','AEXC') and seccion_id = :OLD.ID;

            update inscripciones set estatus = 'IFXC'
            where estatus in ('ACXC','AEXC') and seccion_id = :OLD.ID;
       end if;*/

    ELSIF deleting then --si esta borrando
       --trae el id del material
       select id into l_id from materiales where seccion_id = :OLD.ID and tipo='C';
       --elimina el precio
       delete from precios where id = l_id;
       --elimina el material
       delete from materiales where id = l_id;
       --elimina de instancias_secciones
       delete from instancias_secciones where seccion_id=:OLD.ID;
    END IF;
  END;
end;
/
ALTER TRIGGER "FUNDAUC"."T_SECCIONES_AUID" ENABLE;
