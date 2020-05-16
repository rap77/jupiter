PROMPT TABLA HORARIOS
truncate table horarios;

insert into horarios
select rownum,hora,modalidad,hora_fin from ces.horarios
where rowid not in
(select rowid from ces.horarios t1
where  exists (select 'x' from ces.horarios t2
                 where t2.modalidad = t1.modalidad
                   and to_char(t2.hora,'HH:MI AM') = to_char(t1.hora,'HH:MI AM')
                   and to_char(t2.hora_fin,'HH:MI AM') = to_char(t1.hora_fin,'HH:MI AM')
                   and t2.rowid      > t1.rowid)) and modalidad<>0;

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
        null
    end ciudad,
    case 
      when upper(estado) in (select upper(NOMBRE) from estados) then
        (select id_estado from estados where upper(nombre) = upper(estado))
      else
        null
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
    ces.estudiante e;

PROMPT TABLA SECCIONES
truncate table secciones;
insert into secciones
select ID_SECCION||decode(a.ID_METODO,'CAJ','-J','CA.ADULTOS','-A',null) ID_SECCION,
	a.ID_METODO,
	NIVEL,
	ID_SALON,
	TOPE,
	STATUS,
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

PROMPT TABLA PRECIOS
truncate table precios;
insert into precios
select * from ces.precios
where tipo_item not in ('C','DP','PC');

insert into precios
select id_mat,tipo,sysdate,decode(tipo,'C',150000,0),0,0,'V',0,0 from materiales
where tipo in ('C','DP','PC');

update tipo_material set idiomas = 'N'
where idiomas is null;

update tipo_material set ctc = 'N'
where ctc is null;

update tipo_material set cfp = 'N'
where cfp is null;

update tipo_material set FVTC = 'N'
where FVTC is null;

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