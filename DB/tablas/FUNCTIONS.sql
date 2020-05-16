--------------------------------------------------------
--  DDL for Function ACT_FECHAS_JSONHV
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FUNDAUC"."ACT_FECHAS_JSONHV" (metadata IN CLOB) RETURN CLOB IS

  meta          CLOB;
  md_obj        JSON_OBJECT_T;
  li_arr        JSON_ARRAY_T;
  fi_item       JSON_ELEMENT_T;
  ff_item       JSON_ELEMENT_T;
  sec_obj       JSON_OBJECT_T;
  fac_obj        JSON_OBJECT_T;
  per_obj        JSON_OBJECT_T;
  f_fact        DATE;
  f_ini         DATE;
  f_fin         DATE;
  nro_fact      NUMBER;
  id_per        NUMBER;
  id_fac        NUMBER;

  PROCEDURE display (p_obj IN JSON_OBJECT_T) IS
  BEGIN
    DBMS_OUTPUT.put_line(p_obj.stringify);
  END;
  PROCEDURE display (p_ele IN JSON_ELEMENT_T) IS
  BEGIN
    DBMS_OUTPUT.put_line(p_ele.stringify);
  END;
  PROCEDURE display (p_arr IN JSON_ARRAY_T) IS
  BEGIN
    DBMS_OUTPUT.put_line(p_arr.stringify);
  END;

BEGIN
  select metadata into meta from hoja_vida_est where rownum = 1;

  md_obj := JSON_OBJECT_T.parse(meta);

    per_obj := JSON_OBJECT_T(md_obj.get_Object('seccion').get_Object('periodo'));

    fi_item := JSON_OBJECT_T(md_obj.get_Object('seccion')).get('id_horario');
    ff_item := JSON_OBJECT_T(md_obj.get_Object('seccion')).get('horario');

    f_ini := to_date(per_obj.get_string('fecha_ini'),'DD/MM/YYYY');
    f_fin := to_date(per_obj.get_string('fecha_fin'),'DD/MM/YYYY');

    per_obj.put('fecha_ini',to_char(f_ini,'YYYY-MM-DD')||'T'||to_char(f_ini,'HH24:MI:SS'));
    per_obj.put('fecha_fin',to_char(f_fin,'YYYY-MM-DD')||'T'||to_char(f_fin,'HH24:MI:SS'));

 --   DBMS_OUTPUT.PUT_LINE(to_char(f_ini,'YYYY-MM-DD')||'T'||to_char(f_ini,'HH24:MI:SS')||'Z');

    fac_obj := JSON_OBJECT_T(md_obj.get_Object('factura'));

    id_fac := fac_obj.get_number('id');

    select id_fact, fecha_emi into nro_fact, f_fact from factura where id=id_fac;

    fac_obj.put('fecha_emi',f_fact);
    fac_obj.put('nro_fac',nro_fact);

    meta := md_obj.to_string;
  --  display(md_obj);
    return meta;

END;

/
--------------------------------------------------------
--  DDL for Function ARREGLA_JSONHV
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FUNDAUC"."ARREGLA_JSONHV" (metadata IN CLOB) RETURN CLOB IS

  meta          CLOB;
  md_obj        JSON_OBJECT_T;
  li_arr        JSON_ARRAY_T;
  id_item       JSON_ELEMENT_T;
  hr_item       JSON_ELEMENT_T;
  sec_obj       JSON_OBJECT_T;
  fac_obj        JSON_OBJECT_T;
  hor_obj        JSON_OBJECT_T;

  PROCEDURE display (p_obj IN JSON_OBJECT_T) IS
  BEGIN
    DBMS_OUTPUT.put_line(p_obj.stringify);
  END;
  PROCEDURE display (p_ele IN JSON_ELEMENT_T) IS
  BEGIN
    DBMS_OUTPUT.put_line(p_ele.stringify);
  END;
  PROCEDURE display (p_arr IN JSON_ARRAY_T) IS
  BEGIN
    DBMS_OUTPUT.put_line(p_arr.stringify);
  END;

BEGIN

  md_obj := JSON_OBJECT_T.parse(metadata);

    hor_obj := new JSON_OBJECT_T('{"horario":{}}');

    id_item := JSON_OBJECT_T(md_obj.get_Object('seccion')).get('id_horario');
    hr_item := JSON_OBJECT_T(md_obj.get_Object('seccion')).get('horario');

  --  DBMS_OUTPUT.PUT_LINE(JSON_OBJECT_T(md_obj.get_Object('seccion')).get('id_horario').to_string);

    hor_obj.put('id_horario',id_item);
    hor_obj.put('horario',hr_item);

 --   display(hor_obj);

    fac_obj := JSON_OBJECT_T(md_obj.get_Object('seccion').get_Object('factura'));
    sec_obj := JSON_OBJECT_T(md_obj.get_Object('seccion'));
    sec_obj.remove('factura');
    sec_obj.remove('id_horario');
    sec_obj.remove('horario');

    sec_obj.put('horario',hor_obj);

    md_obj.put('factura',fac_obj);

    meta := md_obj.to_string;

    return meta;

END;

/
--------------------------------------------------------
--  DDL for Function BUSCACAMPO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FUNDAUC"."BUSCACAMPO" (
   table_name IN VARCHAR2,
   colum_des  IN VARCHAR2,
   condition IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2 IS

   sql_stmt  VARCHAR2(4000); -- almacena el valor de la sentencia SQL
   where_clause VARCHAR2(4000) := ' WHERE ' || condition; -- almacena la condicion
   descrip   VARCHAR2(1000); -- almacena el valor del campo.

BEGIN
   IF condition IS NULL THEN where_clause := NULL; END IF; -- si la condicion el nula se elimina el where
   sql_stmt := 'SELECT ' || colum_des || ' from ' || table_name || where_clause; -- armado de la sentencia
   begin
   DBMS_OUTPUT.put_line(sql_stmt);
   EXECUTE IMMEDIATE sql_stmt INTO descrip; -- ejecucion de la sentencia
   exception
   when no_data_found then -- si no consigue datos
     descrip := '0'; -- asigna un 0 al valor indicando que no se cumple la condicion
   when others then -- en cualquier otro caso
     dbms_output.put_line(SQLERRM); -- despliega el error
	 descrip := SQLERRM;
   end;
   return(descrip); -- retorna el valor del campo
END;

/
--------------------------------------------------------
--  DDL for Function ESNUMERO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FUNDAUC"."ESNUMERO" (v_num IN VARCHAR2)
   RETURN NUMBER
AS
   s_num    NUMBER := 1;
   v_prov   NUMBER;
BEGIN
   v_prov := TO_NUMBER (v_num);
   RETURN s_num;
EXCEPTION
   WHEN OTHERS
   THEN
      s_num := 0;
      RETURN s_num;
END;

/
--------------------------------------------------------
--  DDL for Function EXISTE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FUNDAUC"."EXISTE" (vtabla    VARCHAR2,
                                            vwhere    VARCHAR2)
   RETURN BOOLEAN AUTHID CURRENT_USER
IS
   eof     NUMBER;
   dml     VARCHAR2(2000);

  -- vcampo VARCHAR2(30) := buscafkr(vprop,vtabla,vtablar);

/******************************************************************************
   NAME:       EXISTE
   PURPOSE:    Verifica si existe una tabla en la base de datos

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        30/11/2011   padron       1. Created this function.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     EXISTE_TABLA
      Sysdate:         30/11/2011
      Date and Time:   30/11/2011, 08:17:30 a.m., and 30/11/2011 08:17:30 a.m.
      Username:        padron (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
BEGIN
   dml := '
   SELECT count(*)
     FROM '||vtabla||'
    WHERE '||vwhere;

    EXECUTE IMMEDIATE dml into eof;

--DBMS_OUTPUT.PUT_LINE(dml);

   if eof = 0 then
     RETURN false;
   else
     RETURN true;
   end if;

EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      eof := 0;
      return false;
   WHEN OTHERS
   THEN
      eof := 0;

      DBMS_OUTPUT.PUT_LINE('EXISTE: '||SQLERRM||dml);
            return false;
END EXISTE;

/
--------------------------------------------------------
--  DDL for Function GET_BASEIMP
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FUNDAUC"."GET_BASEIMP" (valor    VARCHAR2,
                                            monto    NUMBER)
   RETURN NUMBER AUTHID CURRENT_USER
IS
   rmonto     NUMBER;

BEGIN

 CASE (VALOR)  
    WHEN 'N' THEN
        rmonto :=  monto;
    ELSE
        rmonto := 0;
 END CASE;

     RETURN rmonto;
END GET_BASEIMP;

/
--------------------------------------------------------
--  DDL for Function GET_EXENTO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FUNDAUC"."GET_EXENTO" (valor    VARCHAR2,
                                            monto    NUMBER)
   RETURN NUMBER AUTHID CURRENT_USER
IS
   rmonto     NUMBER;

BEGIN

 CASE (VALOR)  
    WHEN 'S' THEN
        rmonto :=  monto;
    ELSE
        rmonto := 0;
 END CASE;

     RETURN rmonto;
END GET_EXENTO;

/
--------------------------------------------------------
--  DDL for Function GETHACECUANTO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FUNDAUC"."GETHACECUANTO" (
    p_date IN DATE
) RETURN VARCHAR2 AS
    x   VARCHAR2(255);
BEGIN
    x := 'hace '|| 
        CASE
            WHEN SYSDATE - p_date < 1 / 1440 THEN round(24 * 60 * 60 * (SYSDATE - p_date) )
            || ' segundos'
            WHEN SYSDATE - p_date < 1 / 24 THEN round(24 * 60 * (SYSDATE - p_date) )
            || ' minutos'
            WHEN SYSDATE - p_date < 1 THEN round(24 * (SYSDATE - p_date) )
            || ' horas'
            WHEN SYSDATE - p_date < 14 THEN trunc(SYSDATE - p_date)
            || ' dias'
                $IF $$BRITISH $THEN
            WHEN MOD(trunc(SYSDATE - p_date),14) = 0 THEN trunc(SYSDATE - p_date) / 14
            || ' quincenas'
                $END
            WHEN SYSDATE - p_date < 60 THEN trunc( (SYSDATE - p_date) / 7)
            || ' semanas'
            WHEN SYSDATE - p_date < 365 THEN round(months_between(SYSDATE,p_date) )
            || ' meses'
            ELSE round(months_between(SYSDATE,p_date) / 12,1)
            || ' años'
        END;

    x := regexp_replace(x,'(^1 &#91;&#91;:alnum:&#93;&#93;{4,10})s','\1');
    x := x;
    RETURN x;
END getHaceCuanto;

/
--------------------------------------------------------
--  DDL for Function GET_INSCRIPCION_JSON
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FUNDAUC"."GET_INSCRIPCION_JSON" (
   p_ins_id in inscripciones.id%type,
   p_tipo char,
   p_codigo number
)
   return clob
is
  l_inscripcion_row inscripciones%ROWTYPE;
  l_seccion_row secciones%ROWTYPE;
  l_cohorte_row cohortes%ROWTYPE;
 
  TYPE horario_typer
   IS
      RECORD (
            id_horario horarios.id_horario%TYPE,
            horario VARCHAR2(255)
      );
  l_horario_row horario_typer;
  
  l_periodo_row calendarios_detalle%ROWTYPE;
  l_factura_row factura%ROWTYPE;
  l_cod_json_clob clob;
  l_periodo number := 0;
  l_horario number := 0;

BEGIN

  APEX_JSON.initialize_clob_output;


  APEX_JSON.open_object; -- {

  if p_tipo = 'S' then
      SELECT s.*
      INTO   l_seccion_row
      FROM   secciones s
      WHERE  s.id = p_codigo;

     l_periodo := l_seccion_row.periodo;
     l_horario := l_seccion_row.id_horario;

      APEX_JSON.open_object('seccion'); -- seccion {

      APEX_JSON.write('id_seccion', l_seccion_row.id_seccion);
      APEX_JSON.write('codigo',l_seccion_row.id);
      APEX_JSON.write('id_metodo', l_seccion_row.id_metodo);
      APEX_JSON.write('nivel', l_seccion_row.nivel);
      APEX_JSON.write('id_salon',l_seccion_row.id_salon);
      APEX_JSON.write('tope',l_seccion_row.tope);
      APEX_JSON.write('status',l_seccion_row.status);
      APEX_JSON.write('id_edif',l_seccion_row.id_edif);
      APEX_JSON.write('cedula_prof',l_seccion_row.cedula_prof);
      APEX_JSON.write('modalidad',utl_modalidades.getModalidad(l_seccion_row.modalidad));
  end if;
    if p_tipo = 'C' then
      SELECT s.*
      INTO   l_cohorte_row
      FROM   cohortes s
      WHERE  s.id = p_codigo;

      l_periodo := l_cohorte_row.periodo;

      APEX_JSON.open_object('cohorte'); -- cohorte {

      APEX_JSON.write('codigo', l_cohorte_row.codigo);
      APEX_JSON.write('id',l_cohorte_row.id);
      APEX_JSON.write('diplomado_id', l_cohorte_row.diplomado_id);
      APEX_JSON.write('cohorte', l_cohorte_row.cohorte);
      APEX_JSON.write('costo',l_cohorte_row.costo);
      APEX_JSON.write('cupo',l_cohorte_row.cupo);
      APEX_JSON.write('status',l_cohorte_row.status);
      APEX_JSON.write('cuotas',l_cohorte_row.cuotas);
      APEX_JSON.write('facilitador',l_cohorte_row.facilitador);
      APEX_JSON.write('id_modalidad',utl_modalidades.getModalidad(l_cohorte_row.id_modalidad));
      APEX_JSON.write('id_ciudad',l_cohorte_row.id_ciudad);
      APEX_JSON.write('empresa',l_cohorte_row.empresa);
  end if;


  begin
  select * into l_periodo_row
  from calendarios_detalle
  where id = l_periodo;

  APEX_JSON.open_object('periodo'); -- periodo {
  APEX_JSON.write('id',l_periodo_row.id);
  APEX_JSON.write('id_calendario',l_periodo_row.id_calendario);
  APEX_JSON.write('cod_periodo',l_periodo_row.periodo);
  APEX_JSON.write('fecha_ini',to_char(l_periodo_row.fecha_ini,'YYYY-MM-DD')||'T'||to_char(l_periodo_row.fecha_ini,'HH24:MI:SS')||'Z');
  APEX_JSON.write('fecha_fin',to_char(l_periodo_row.fecha_fin,'YYYY-MM-DD')||'T'||to_char(l_periodo_row.fecha_ini,'HH24:MI:SS')||'Z');
  APEX_JSON.write('modalidad',l_periodo_row.modalidad);
  APEX_JSON.write('periodo_activo',l_periodo_row.periodo_activo);

  exception
  when no_data_found then
     APEX_JSON.open_object('periodo'); -- periodo {
     APEX_JSON.write('id',l_periodo);
  end;
  APEX_JSON.close_object; -- } --periodo
  
  begin
  select id_horario, UTL_HORARIOS.GETHORARIO(id_horario) horario 
  into l_horario_row
  from horarios
  where id_horario = l_horario;

  APEX_JSON.open_object('horario'); -- horario {
  APEX_JSON.write('id_horario',l_horario_row.id_horario);
  APEX_JSON.write('horario',l_horario_row.horario);

  exception
  when no_data_found then
     APEX_JSON.open_object('horario'); -- horario {
     APEX_JSON.write('id_horario',l_periodo);
  end;
  APEX_JSON.close_object; -- } --horario

  
  APEX_JSON.close_object; -- } --seccion
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
      APEX_JSON.write('fecha_emi',l_factura_row.fecha_emi);
      APEX_JSON.write('nro_fac',l_factura_row.id_fact);
      APEX_JSON.close_object; -- } --factura}

      exception
      when no_data_found then
         APEX_JSON.open_object('factura'); -- factura {
         APEX_JSON.close_object; -- } --factura}
  end;
   
/*    begin
       select * into l_inscripcion_row
       from inscripciones
       where id = p_ins_id;

      APEX_JSON.open_object('inscripcion'); -- inscripcion {
      APEX_JSON.write('id',l_inscripcion_row.id);
      APEX_JSON.write('fecha_ins',l_inscripcion_row.fecha_ins);
      APEX_JSON.write('est_matricula',l_inscripcion_row.est_matricula);
      APEX_JSON.write('seccion_id',l_inscripcion_row.seccion_id);
      APEX_JSON.write('periodo_id',l_inscripcion_row.periodo_id);
      APEX_JSON.write('cohorte_id',l_inscripcion_row.cohorte_id);
      APEX_JSON.write('horario_id',l_inscripcion_row.horario_id);
      APEX_JSON.write('es_exonerado',l_inscripcion_row.es_exonerado);
      APEX_JSON.write('es_suspendido',l_inscripcion_row.es_suspendido);
      APEX_JSON.write('estatus',l_inscripcion_row.estatus);
      APEX_JSON.close_object; -- } --inscripcion}

      exception
      when no_data_found then
         APEX_JSON.open_object('inscripcion'); -- inscripcion {
         APEX_JSON.close_object; -- } --inscripcion}
  end;*/


  
  

  APEX_JSON.close_object; -- } objeto

  DBMS_OUTPUT.put_line(APEX_JSON.get_clob_output);

  l_cod_json_clob := apex_json.get_clob_output;

  APEX_JSON.free_output;

  return l_cod_json_clob;
END get_inscripcion_json;

/
--------------------------------------------------------
--  DDL for Function INS_INSCRIPCION_JSONHV
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FUNDAUC"."INS_INSCRIPCION_JSONHV" (metadata IN CLOB) RETURN CLOB IS

  meta          CLOB;
  md_obj        JSON_OBJECT_T;
  li_arr        JSON_ARRAY_T;
  id_item       JSON_ELEMENT_T;
  hr_item       JSON_ELEMENT_T;
  hor_obj       JSON_OBJECT_T;
  fac_obj        JSON_OBJECT_T;
  ins_obj        JSON_OBJECT_T;
  l_inscripcion_row inscripciones%ROWTYPE;
  fac_id       NUMBER;
  hor_id       NUMBER;

  PROCEDURE display (p_obj IN JSON_OBJECT_T) IS
  BEGIN
    DBMS_OUTPUT.put_line(p_obj.stringify);
  END;
  PROCEDURE display (p_obj IN CLOB) IS
  BEGIN
    DBMS_OUTPUT.put_line(p_obj);
  END;
  PROCEDURE display (p_ele IN JSON_ELEMENT_T) IS
  BEGIN
    DBMS_OUTPUT.put_line(p_ele.stringify);
  END;
  PROCEDURE display (p_arr IN JSON_ARRAY_T) IS
  BEGIN
    DBMS_OUTPUT.put_line(p_arr.stringify);
  END;

BEGIN

--  select metadata into meta from hoja_vida_est where rownum = 1;
  md_obj := JSON_OBJECT_T.parse(metadata);

--  display(md_obj);

    ins_obj := new JSON_OBJECT_T();

--    display(ins_obj);
    hor_obj := JSON_OBJECT_T(md_obj.get_Object('seccion').get_Object('horario'));

--    display(hor_obj);

    hor_id := hor_obj.get_number('id_horario');

    fac_obj := JSON_OBJECT_T(md_obj.get_Object('factura'));

    fac_id := fac_obj.get_number('id');

    select * into l_inscripcion_row
       from inscripciones
       where id in (select inscripcion_id from INSCRIPCION_FACTURA where factura_id=fac_id);

    ins_obj.put('id',l_inscripcion_row.id);
    ins_obj.put('fecha_ins',l_inscripcion_row.fecha_ins);
    ins_obj.put('est_matricula',l_inscripcion_row.est_matricula);
    ins_obj.put('seccion_id',l_inscripcion_row.seccion_id);
    ins_obj.put('periodo_id',l_inscripcion_row.periodo_id);
    ins_obj.put('cohorte_id',l_inscripcion_row.cohorte_id);
    ins_obj.put('horario_id',hor_id);
    ins_obj.put('es_exonerado',l_inscripcion_row.es_exonerado);
    ins_obj.put('es_suspendido',l_inscripcion_row.es_suspendido);
    ins_obj.put('estatus',l_inscripcion_row.estatus);

--    display(ins_obj);

    md_obj.put('inscripcion',ins_obj);

    meta := md_obj.to_string;

    return meta;
  --  display(meta);

END;

/
--------------------------------------------------------
--  DDL for Function LISTA
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FUNDAUC"."LISTA" (input varchar2 )
    RETURN varchar2
    PARALLEL_ENABLE AGGREGATE USING string_agg_type;

/
--------------------------------------------------------
--  DDL for Function MAXIMO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FUNDAUC"."MAXIMO" (vtabla    VARCHAR2,
                                            vcampo    VARCHAR2,
                                            vwhere    VARCHAR2)
   RETURN NUMBER AUTHID CURRENT_USER
IS
   eof     NUMBER;
   dml     VARCHAR2(2000);

  -- vcampo VARCHAR2(30) := buscafkr(vprop,vtabla,vtablar);

/******************************************************************************
   NAME:       MINIMO
   PURPOSE:    Verifica si existe una tabla en la base de datos

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        30/11/2011   padron       1. Created this function.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     EXISTE_TABLA
      Sysdate:         30/11/2011
      Date and Time:   30/11/2011, 08:17:30 a.m., and 30/11/2011 08:17:30 a.m.
      Username:        padron (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
BEGIN
   dml := '
   SELECT max('||vcampo||')
     FROM '||vtabla||'
    WHERE '||vwhere;

    EXECUTE IMMEDIATE dml into eof;

--DBMS_OUTPUT.PUT_LINE(dml);

   if eof is null then
     eof := 0;
     RETURN eof;
   else
     RETURN eof;
   end if;

EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      eof := 0;
      return eof;
   WHEN OTHERS
   THEN
      eof := 0;

      DBMS_OUTPUT.PUT_LINE('MAXIMO: '||SQLERRM||dml);
            return eof;
END MAXIMO;

/
--------------------------------------------------------
--  DDL for Function MINIMO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FUNDAUC"."MINIMO" (vtabla    VARCHAR2,
                                            vcampo    VARCHAR2,
                                            vwhere    VARCHAR2)
   RETURN NUMBER AUTHID CURRENT_USER
IS
   eof     NUMBER;
   dml     VARCHAR2(2000);

  -- vcampo VARCHAR2(30) := buscafkr(vprop,vtabla,vtablar);

/******************************************************************************
   NAME:       MINIMO
   PURPOSE:    Verifica si existe una tabla en la base de datos

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        30/11/2011   padron       1. Created this function.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     EXISTE_TABLA
      Sysdate:         30/11/2011
      Date and Time:   30/11/2011, 08:17:30 a.m., and 30/11/2011 08:17:30 a.m.
      Username:        padron (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
BEGIN
   dml := '
   SELECT min('||vcampo||')
     FROM '||vtabla||'
    WHERE '||vwhere;

    EXECUTE IMMEDIATE dml into eof;

--DBMS_OUTPUT.PUT_LINE(dml);

   if eof is null then
     eof := 0;
     RETURN eof;
   else
     RETURN eof;
   end if;

EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      eof := 0;
      return eof;
   WHEN OTHERS
   THEN
      eof := 0;

      DBMS_OUTPUT.PUT_LINE('MINIMO: '||SQLERRM||dml);
            return eof;
END MINIMO;

/
--------------------------------------------------------
--  DDL for Function TOKEN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FUNDAUC"."TOKEN" (LINEBUF   IN VARCHAR2,
                                           col       IN NUMBER,
                                           separa    IN VARCHAR2)
   RETURN VARCHAR2
IS
   FIRST_TOKEN   VARCHAR2 (2000);
   COMA_POS      NUMBER;
   CONTENIDO     VARCHAR2 (2000) := LINEBUF;
   i             NUMBER := 0;
BEGIN
   IF CONTENIDO IS NULL
   THEN
      FIRST_TOKEN := '';
   ELSE
      LOOP
         EXIT WHEN i = col;
         COMA_POS := INSTR (CONTENIDO, separa);

         IF COMA_POS = 0
         THEN
            FIRST_TOKEN := CONTENIDO;
            CONTENIDO := NULL;
         ELSE
            IF COMA_POS = 1
            THEN
               CONTENIDO := SUBSTR (CONTENIDO, COMA_POS + LENGTH (separa));
               COMA_POS := INSTR (CONTENIDO, separa);
               DBMS_OUTPUT.PUT_LINE(i||'-'||CONTENIDO||'-'||COMA_POS||'-'||length(separa));
               FIRST_TOKEN := SUBSTR (CONTENIDO, 1, COMA_POS - 1);
               CONTENIDO := SUBSTR (CONTENIDO, COMA_POS + LENGTH (separa));
            ELSE
               FIRST_TOKEN := SUBSTR (CONTENIDO, 1, COMA_POS - 1);
               CONTENIDO := SUBSTR (CONTENIDO, COMA_POS + LENGTH (separa));
            END IF;
         END IF;

         i := i + 1;
      END LOOP;
   END IF;

   RETURN FIRST_TOKEN;
   EXCEPTION WHEN OTHERS THEN
   DBMS_OUTPUT.put_line(SQLERRM);
END;

/
--------------------------------------------------------
--  DDL for Function TOKENCOUNT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FUNDAUC"."TOKENCOUNT" (LINEBUF   IN VARCHAR2,
                                                separa    IN VARCHAR2)
   RETURN VARCHAR2
IS
   FIRST_TOKEN   VARCHAR2 (2000);
   COMA_POS      NUMBER;
   CONTENIDO     VARCHAR2 (2000) := LINEBUF;
   i             NUMBER := 0;
BEGIN
   IF CONTENIDO IS NULL
   THEN
      i := 0;
   ELSE
      LOOP
         EXIT WHEN COMA_POS = 0;
         COMA_POS := INSTR (CONTENIDO, separa);
         DBMS_OUTPUT.PUT_LINE (COMA_POS);

         IF COMA_POS = 0
         THEN
            FIRST_TOKEN := CONTENIDO;
            CONTENIDO := NULL;
         ELSE
            IF COMA_POS = 1
            THEN
               CONTENIDO := SUBSTR (CONTENIDO, COMA_POS + LENGTH (separa));
               COMA_POS := INSTR (CONTENIDO, separa);
               --DBMS_OUTPUT.PUT_LINE(i||'-'||CONTENIDO||'-'||COMA_POS);
               FIRST_TOKEN := SUBSTR (CONTENIDO, 1, COMA_POS - 1);
               CONTENIDO := SUBSTR (CONTENIDO, COMA_POS + LENGTH (separa));
            ELSE
               FIRST_TOKEN := SUBSTR (CONTENIDO, 1, COMA_POS - 1);
               CONTENIDO := SUBSTR (CONTENIDO, COMA_POS + LENGTH (separa));
            END IF;
         END IF;

         i := i + 1;
      -- DBMS_OUTPUT.PUT_LINE(i||'-'||FIRST_TOKEN);
      END LOOP;
   END IF;

   RETURN i;
END;

/
