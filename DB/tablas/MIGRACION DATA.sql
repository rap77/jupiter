PURGE RECYCLEBIN;
PROMPT DESACTIVANDO RESTRICCIONES

begin
  for cur in (select fk.owner, fk.constraint_name , fk.table_name 
    from all_constraints fk, all_constraints pk 
     where fk.CONSTRAINT_TYPE = 'R' and 
           pk.owner = 'FUNDAUC' and
           fk.r_owner = pk.owner and
           fk.R_CONSTRAINT_NAME = pk.CONSTRAINT_NAME /*and 
           pk.TABLE_NAME = 'CALENDARIOS'*/) loop
    execute immediate 'ALTER TABLE "'||cur.owner||'"."'||cur.table_name||'" MODIFY CONSTRAINT "'||cur.constraint_name||'" DISABLE';
  end loop;
end;
/
begin
  for cur in (select owner, constraint_name , table_name 
    from all_constraints
     where owner = 'FUNDAUC'/* and
           TABLE_NAME = 'CALENDARIOS'*/) loop
     execute immediate 'ALTER TABLE '||cur.owner||'.'||cur.table_name||' MODIFY CONSTRAINT "'||cur.constraint_name||'" DISABLE ';
  end loop;
end;
/

PROMPT TABLA MODALIDADES
truncate table modalidades;


insert into modalidades
select ID_MODALIDAD,DESCRIPCION,
case 
    when instr(descripcion,'INTENSIVO',1)>0 THEN
      '2,3,4,5'
    when instr(descripcion,'MARTES A VIERNES',1)>0 THEN
      '2,3,4,5'
    when instr(descripcion,'SABATINO',1)>0 THEN
      '6'
    else
      replace(replace(replace(replace(replace(replace(replace(replace(descripcion,'/',','),'LUNES','1'),'MARTES','2'),'MIERCOLES','3'),'JUEVES','4'),'VIERNES','5'),'SABADOS','6'),'SOLO ','')
end dias
from ces.modalidades
where id_modalidad not in (18);

PROMPT TABLA DE CALENDARIOS
truncate table calendarios;
insert into calendarios
select id_calendario, descripcion, periodos, 'S' from ces.calendarios;

PROMPT TABLA DE CALENDARIOS_DETALLE
truncate table calendarios_detalle;

PROMPT ELIMINA DUPLICADOS CES.CALENDARIOS_DETALLE
delete from ces.calendarios_detalle
    where rowid in  
    (select max(rowid) from ces.calendarios_detalle
    group by id_calendario,periodo,modalidad
    having count(*)>1);

insert into calendarios_detalle
select ID_CALENDARIO,PERIODO,FECHA_INI,FECHA_FIN,MODALIDAD,'S' PERIODO_ACTIVO,rownum from ces.calendarios_detalle
where fecha_ini>to_date('01012019','DDMMYYYY') and modalidad in (select id_modalidad from modalidades);

PROMPT TABLA TIPO_MATERIAL
truncate table tipo_material;
insert into tipo_material
select * from ces.tipo_material;

PROMPT TABLA METODOS
truncate table metodos;
insert into metodos
select * from ces.metodos;


PROMPT TABLA DIPLOMADOS
truncate table diplomados;

insert into diplomados
select ID_DIPLOMADO,DESCRIPCION,HORAS,COORDINADOR,MODULOS,STATUS,CLASE_DOC,MINIMO,MAXIMO,COD_CONTABLE,COD_DESCUENTO, rownum ID from
(select ID_DIPLOMADO,DESCRIPCION,HORAS,COORDINADOR,MODULOS,STATUS,CLASE_DOC,MINIMO,MAXIMO,COD_CONTABLE,COD_DESCUENTO
from ces.diplomados
union
select id_certi, descripcion,nvl(horas,0),nvl(coordinador,'SIN ASIGNAR'),0,'V',clase_doc,0,0,cod_contable,null--,(select max(id) from diplomados)+rownum 
from ces.diplo_certi where id_certi not in (select id_diplomado from ces.diplomados))

PROMPT TABLA SALONES
truncate table salones;
insert into salones
select * from ces.salones;

PROMPT TABLA EDIFICIOS
truncate table edificios;
insert into edificios
select * from ces.edificios;

PROMPT TABLA BANCOS
truncate table bancos;
insert into bancos
select * from ces.bancos;

PROMPT TABLA COMPANIAS
truncate table companias;
insert into companias
select * from ces.companias;

PROMPT TABLA HORARIOS
truncate table horarios;
insert into horarios
select rownum,hora,modalidad,hora_fin from ces.horarios
where rowid not in
(select min(rowid) from ces.horarios
group by modalidad,to_char(hora,'HH:MI AM'),to_char(hora_fin,'HH:MI AM')
having count(*)>1)

PROMPT TABLA PROFESOR
truncate table profesor;
insert into profesor
select cedula_prof,nacionalidad,nombre,telf_hab, telf_cel, ciudad, estado, email, sexo, edo_civil, grado_ins, profesion, fecha_nac, status, id_tipo_prof, rif, sede, apellido, zona, null direccion  from ces.profesor;

PROMPT TABLA ESTUDIANTE
truncate table estudiante;
insert into estudiante
SELECT
    cedula_est,
    nacionalidad,
    e.nombre,
    telf_hab,
    telf_cel,
    case 
      when upper(ciudad) in (select upper(NOMBRE) from ciudades) then
        (select id_ciudad from ciudades where upper(nombre) = upper(ciudad))
      else
        0
    end ciudad,
    case 
      when upper(estado) in (select upper(NOMBRE) from estados) then
        (select id_estado from estados where upper(nombre) = upper(estado))
      else
        0
    end estado,
    email,
    sexo,
    edo_civil,
    grado_ins,
    DECODE(profesion, 'Estudiante', 1, 2) profesion,
    fecha_nac,
    status,
    id_tipo_est,
    rif,
    matricula,
    decode(sede,'FEM',null,sede) sede,
    decode(nvl(condicion_especial,0),'-',0,5,0,3,0,nvl(condicion_especial,0)) condicion_especial,
    apellido,
    NULL zona,
    cedula_rep,
    direccion
FROM
    ces.estudiante e


PROMPT TABLA SECCIONES
truncate table secciones;
insert into secciones
select ID_SECCION||decode(a.ID_METODO,'CAJ','-J','CA.ADULTOS','-A',null) ID_SECCION,
	a.ID_METODO,
	NIVEL,
	ID_SALON,
	TOPE,
	STATUS,
	CANT_ACTUAL,
	ID_EDIF,
	HORARIO,
	CEDULA_PROF,
	a.MODALIDAD,
	FEC_INICIO,
	dc.id PERIODO
	,h.ID_HORARIO
    ,dc.id_calendario ID_CALENDARIO
    ,rownum id 
    , user
    ,sysdate
    ,null
    ,null
    from ces.secciones a, horarios h
    , calendarios_detalle dc
    , calendarios c, metodos m
    where a.horario = to_char(hora,'HH:MI PM')||'-'||to_char(hora_fin,'HH:MI PM')
    and h.modalidad=a.modalidad
    and dc.periodo = a.periodo and a.fec_inicio = dc.fecha_ini
    and a.modalidad=dc.modalidad
    and dc.id_calendario=c.id_calendario
    and c.id_calendario=m.id_calendario
    and a.id_metodo=m.id_metodo 
    order by 1;

--SECCIONS QUE NO ESTAN
    select s.id_seccion,s.id_metodo,s.nivel,s.salon,s.tope, s.status,s.cant_actual, s.edificio, s.horario, s.modalidad,m.id_modalidad,fec_inicio,dc.periodo from
    (select distinct decode(df.item,'DEUC','DES',df.item) id_seccion,
    substr(descripcion,1,instr(descripcion,'|',1,1)-1) ID_METODO,
    to_number(replace(replace(substr(descripcion,instr(descripcion,'|',1,1)+1,instr(descripcion,'|',1,2)-instr(descripcion,'|',1,1)-1),'NIVEL ',''),'-','')) nivel,
    to_number(trim(substr(descripcion,instr(descripcion,'|',1,5)+1,2))) SALON,0 TOPE,'C' STATUS,0 CANT_ACTUAL,null EDIFICIO,
    substr(descripcion,instr(descripcion,'|',1,2)+1,instr(descripcion,'|',1,3)-instr(descripcion,'|',1,2)-1) HORARIO,
    null cedula_prof,
    substr(descripcion,instr(descripcion,'|',1,4)+1,instr(descripcion,'|',1,5)-instr(descripcion,'|',1,4)-1) MODALIDAD,
    to_date(substr(descripcion,instr(descripcion,'|',1,3)+1,instr(descripcion,'|',1,4)-instr(descripcion,'|',1,3)-1),'DD/MM/YYYY') FEC_INICIO,
    df.descripcion
    from ces.detalle_factura df, factura f
    where df.id_fact = f.id_fact and  item not in (select id_mat from materiales) and tipo_item='C') s, modalidades m, calendarios_detalle dc
    where m.descripcion=s.modalidad
    and dc.fecha_ini=s.fec_inicio
    and dc.modalidad=m.id_modalidad

      
    
PROMPT TABLA COHORTES
truncate table cohortes;

insert into cohortes
select c.CODIGO,c.ID_DIPLOMADO,c.ID_HORARIO ,c.ID_MODALIDAD,c.COHORTE,c.CANT_ACTUAL,c.FECHA_INI,c.FECHA_FIN,c.COSTO,c.INICIAL,c.COSTO_CUOTA,c.CUOTAS,c.STATUS,c.CIUDAD,rownum ID
, TIPO_DIPLO
,CREADO_POR
, CREADO_EL
,MODIFICADO_POR
,MODIFICADO_EL
,d.id DIPLOMADOS_ID
from
(select c.ID CODIGO,c.ID_DIPLOMADO,c.ID_HORARIO ,c.ID_MODALIDAD,c.COHORTE,c.CANT_ACTUAL,c.FECHA_INI,c.FECHA_FIN,c.COSTO,c.INICIAL,c.COSTO_CUOTA,c.CUOTAS,c.STATUS,c.CIUDAD
,'ADMINISTRADO' TIPO_DIPLO
,'PADRON' CREADO_POR
,SYSDATE CREADO_EL
,null MODIFICADO_POR
,null MODIFICADO_EL
from ces.cohortes c
union
select c.id CODIGO, c.ID_CERTI ID_DIPLOMADO, null HORARIO, null MODALIDAD, null COHORTE, CANT, null F_INI, null F_FIN, monto COSTO,0 INICIAL, 0 COSTO_COUTA,0 CUOTAS,c.status,ciudad,'CERTIFICACION' TIPO_DIPLO,'PADRON' CREADO_POR,SYSDATE CREADO_EL,null MODIFICADO_POR,null MODIFICADO_EL
from ces.cohorte_certi c) c, diplomados d
where c.id_diplomado=d.id_diplomado;

PROMPT TABLA MATERIALES
truncate table materiales;
insert into materiales
select decode(id_mat,'DEUC','DES',ID_MAT) ID_MAT,TIPO,DESCRIPCION,ID_CURSO,EVENTO,NIVEL,IVA_EXENTO,ACTIVO,rownum ID, NULL SECCION_ID,'PADRON' CREADO_POR, SYSDATE CREADO_EL,null MODIFICADO_POR,null MODIFICADO_EL,null COHORTE_ID  from ces.materiales
where tipo not in ('C','DP','PC');

insert into materiales
select s.ID_SECCION, 'C' TIPO, s.id_metodo||'|NIVEL '||lpad(s.nivel,2,'0')||'|'||UTL_HORARIOS.GETHORARIO(S.ID_HORARIO)||'|'||to_char(cd.fecha_ini,'DD/MM/YYYY')||'|'||utl_modalidades.getModalidad(s.modalidad)||'|'||id_salon DESCRIPCION,s.id_metodo ID_CURSO,2,s.nivel NIVEL,'S','S',(select max(id) from materiales)+rownum,s.id SECCION_ID,'ADMIN' CREADO_POR,SYSDATE CREADO_EL,null MODIFICADO_POR,null MODIFICADO_EL,null COHORTE_ID
from secciones s, metodos m, calendarios_detalle cd
where s.id_metodo=m.id_metodo
and s.periodo=cd.id
order by 1;


insert into materiales
select s.CODIGO, DECODE(TIPO_DIPLO,'CERTIFICACION','PC','ADMINISTRADO','DP') TIPO, m.descripcion||' - '||s.ciudad DESCRIPCION,s.id_diplomado ID_CURSO,2,0 NIVEL,'S','S',(select max(id) from materiales)+rownum,null SECCION_ID,'ADMIN' CREADO_POR,SYSDATE CREADO_EL,null MODIFICADO_POR,null MODIFICADO_EL,s.id  COHORTE_ID
from cohortes s, diplomados m
where s.id_diplomado=m.id_diplomado
order by 1;

select decode(df.item,'DEUC','DES',df.item) item,df.tipo_item,df.descripcion,substr(descripcion,1,instr(descripcion,'|',1,1)-1) ID_CURSO,2,to_number(replace(replace(substr(descripcion,instr(descripcion,'|',1,1)+1,instr(descripcion,'|',1,2)-instr(descripcion,'|',1,1)-1),'NIVEL ',''),'-','')) nivel,   from ces.detalle_factura df, factura f
where df.id_fact = f.id_fact and  item not in (select id_mat from materiales)

PROMPT TABLA PRECIOS
truncate table precios;
insert into precios
select * from ces.precios
where tipo_item not in ('C','DP','PC');

insert into precios
select id_mat,tipo,sysdate,decode(tipo,'C',90000,0),0,0,'V',0,0 from materiales
where tipo in ('C','DP','PC');

PROMPT TABLA FACTURA
truncate table factura;
insert into factura
select ID_FACT, TIPO,CEDULA_EST,NOMBRE_CLIENTE,FECHA_EMI,MONTO,P_IVA, MONTO_IVA,FLETE,BS_DESCUENTO,DIR_FISCAL,RIF,STATUS,PROGRAMA,PROG_ACADEMICO,USUARIO,MONTO_EXENTO,BASE_IMPONIBLE,rownum 
from ces.factura
where fecha_emi>to_date('01012019','DDMMYYYY');

PROMPT TABLA DETALLE_FACTURA 7223
truncate table detalle_factura;
insert into select * from detalle_factura
select df.renglon,df.id_fact,df.tipo_item,decode(df.item,'DEUC','DES',df.item) item,REGEXP_REPLACE(replace(df.descripcion,'M|','M-'),'-','|',1,2),df.cantidad,df.p_unidad,df.bs_descuento,df.subtotal, null materiales_id,f.id factura_id 
from ces.detalle_factura df, factura f
, materiales m
where df.id_fact = f.id_fact
and df.item=m.id_mat

select renglon,df.descripcion,tokencount(replace(df.descripcion,'AEC-A','AECA'),'-'),REGEXP_REPLACE(replace(df.descripcion,'M|','M-'),'-','|',1,2) from ces.detalle_factura df, factura f
where df.id_fact = f.id_fact --and  item not in (select id_mat from materiales)
and tipo_item = 'C'



begin
  for cur in (select owner, constraint_name , table_name 
    from all_constraints
     where owner = 'FUNDAUC' and constraint_type='P' and status = 'DISABLED') loop
     execute immediate 'ALTER TABLE '||cur.owner||'.'||cur.table_name||' ENABLE CONSTRAINT "'||cur.constraint_name||'"';
  end loop;
end;
/
begin
  for cur in (select fk.owner, fk.constraint_name , fk.table_name 
    from all_constraints fk, all_constraints pk 
     where fk.CONSTRAINT_TYPE = 'R' and 
           pk.owner = 'FUNDAUC' and
           fk.r_owner = pk.owner and
           fk.R_CONSTRAINT_NAME = pk.CONSTRAINT_NAME /*and 
           pk.TABLE_NAME = 'CALENDARIOS'*/) loop
    execute immediate 'ALTER TABLE "'||cur.owner||'"."'||cur.table_name||'" MODIFY CONSTRAINT "'||cur.constraint_name||'" ENABLE';
  end loop;
end;
/
begin
  for cur in (select owner, trigger_name , table_name 
    from all_triggers
     where owner = 'FUNDAUC'/* and
           TABLE_NAME = 'CALENDARIOS'*/) loop
     execute immediate 'ALTER TRIGGER '||cur.owner||'.'||cur.trigger_name||' ENABLE ';
  end loop;
end;
/
exec tapi_gen2.create_tapi_package (p_table_name => 'DEPOSITO', p_compile_table_api => TRUE);