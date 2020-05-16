REM INSERTING into USUARIOS
SET DEFINE OFF;
Insert into USUARIOS (CEDULA,NOMBRE_USUARIO,CONTRASENA,ID_ROL,EMAIL,NOMBRE,CIA,PROG_ACADEMICO) values ('24571340','NSALINAS',toolkit.encrypt('NS31'),'1','natysv.31@gmail.com','NATHALIE SALINAS','1','6');


update materiales ma set descripcion =
(select s.id_metodo||'|NIVEL '||lpad(s.nivel,2,'0')||'|'||UTL_HORARIOS.GETHORARIO(S.ID_HORARIO)||'|'||to_char(utl_periodos.getPeriodoFecIniSec(s.PERIODO),'DD/MM/YYYY')||'|'||utl_modalidades.getModalidad(s.modalidad)||'|'||id_salon
from secciones s
where s.id = ma.seccion_id
and ma.descripcion != s.id_metodo||'|NIVEL '||lpad(s.nivel,2,'0')||'|'||UTL_HORARIOS.GETHORARIO(S.ID_HORARIO)||'|'||to_char(utl_periodos.getPeriodoFecIniSec(s.PERIODO),'DD/MM/YYYY')||'|'||utl_modalidades.getModalidad(s.modalidad)||'|'||id_salon
and ma.tipo='C')
where tipo='C' and seccion_id in (select s.id
from secciones s
where s.id = ma.seccion_id
and ma.descripcion != s.id_metodo||'|NIVEL '||lpad(s.nivel,2,'0')||'|'||UTL_HORARIOS.GETHORARIO(S.ID_HORARIO)||'|'||to_char(utl_periodos.getPeriodoFecIniSec(s.PERIODO),'DD/MM/YYYY')||'|'||utl_modalidades.getModalidad(s.modalidad)||'|'||id_salon
and ma.tipo='C')


update materiales ma set id_mat =
(select id_seccion
from secciones s
where s.id = ma.seccion_id
and ma.id_mat != s.id_seccion and ma.tipo='C')
where tipo='C' and seccion_id in (select s.id
from secciones s
where s.id = ma.seccion_id
and ma.id_mat != s.id_seccion and ma.tipo='C')



insert into materiales
select s.ID_SECCION, 'C' TIPO, s.id_metodo||'|NIVEL '||lpad(s.nivel,2,'0')||'|'||UTL_HORARIOS.GETHORARIO(S.ID_HORARIO)||'|'||to_char(utl_periodos.getPeriodoFecIniSec(s.PERIODO),'DD/MM/YYYY')||'|'||utl_modalidades.getModalidad(s.modalidad)||'|'||id_salon DESCRIPCION,s.id_metodo ID_CURSO,2,s.nivel NIVEL,'S','S',(select max(id) from materiales)+rownum id,s.id SECCION_ID,'ADMIN' CREADO_POR,SYSDATE CREADO_EL,null MODIFICADO_POR,null MODIFICADO_EL,null COHORTE_ID
from secciones s
where s.id not in (select seccion_id from materiales where tipo='C');

insert into precios
select id_mat,tipo,sysdate,decode(tipo,'C',150000,0),0,0,'V',0,0 from materiales
where tipo in ('C')
and id_mat not in (select item from precios where tipo_item='C');

select * from secciones 
where id_seccion not in (select id_mat from materiales)

