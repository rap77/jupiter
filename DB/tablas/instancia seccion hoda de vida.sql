insert into instancias_secciones
select distinct null,i.seccion_id,hv.metadata.seccion.id_seccion codigo_sec,hv.metadata.seccion.id_metodo metodo_id, hv.metadata.seccion.nivel nivel,hv.metadata.seccion.periodo.id periodo_id,hv.metadata.seccion.horario.id_horario horario_id,utl_modalidades.getIdModalidad(hv.metadata.seccion.modalidad) modalidad_id,null salon_id,null/*,hv.metadata.seccion.cedula_prof*/ cedula_prof,to_date(hv.metadata.seccion.periodo.fecha_ini,'DD/MM/YYYY') f_inicio,to_date(hv.metadata.seccion.periodo.fecha_fin,'DD/MM/YYYY')  f_fin,null status 
from hoja_vida_est hv, inscripciones i
where hv.evento_id = 2 and hv.matricula = i.est_matricula and hv.metadata.seccion.periodo.id=i.periodo_id

select horario_id,CODIGO_SEC,utl_inscripciones.getCodigoSeccion(metodo_id,nivel,periodo_id,modalidad_id,horario_id) from instancias_secciones
where periodo_id=31 and nivel=2

update instancias_secciones set codigo_sec = null

select substr(codigo_sec,length(codigo_sec),1),substr(codigo_sec,1,length(codigo_sec)-1) from instancias_secciones where id=254

select est_matricula, seccion_id, periodo_id from inscripciones

select * from hoja_vida_est

create table secciones_bak as select * from secciones

update instancias_secciones set f_inicio= UTL_PERIODOS.GETPERIODOFECINISEC(SECCION_ID)
where seccion_id=347
 
select UTL_PERIODOS.GETPERIODOFECINISEC(345) from dual

select id,id_seccion,'('||id_metodo||'|'||lpad(nivel,2,'0')||'|'||utl_modalidades.getSiglas(modalidad)||'|'||utl_periodos.getperiodoMin(periodo)||'|'||utl_horarios.getHorarioMin(id_horario)||')' codigo, length('('||id_metodo||'|'||nivel||'|'||periodo||'|'||utl_modalidades.getSiglas(modalidad)||'|'||utl_horarios.getHorarioMin(id_horario)||')') lon from secciones