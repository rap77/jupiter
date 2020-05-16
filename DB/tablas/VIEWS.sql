--------------------------------------------------------
--  DDL for View EVENTOS_CALENDARIO
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FUNDAUC"."EVENTOS_CALENDARIO" ("ID_CALENDARIO", "DESCRIPCION", "FECHA_INI", "FECHA_FIN", "ID_SECCION", "PERIODO", "ID_METODO", "NIVEL", "HORARIO", "DIAS") AS 
  SELECT
        c.id_calendario,
        c.descripcion
        || ' ('
        || m.descripcion
        || ')' AS descripcion,
        cd.fecha_ini,
        cd.fecha_fin,
        s.id_seccion,
        s.periodo,
        s.id_metodo,
        s.nivel,
        s.horario,
        m.dias
    FROM
        fundauc.calendarios           c,
        fundauc.calendarios_detalle   cd,
        fundauc.modalidades           m,
        fundauc.secciones             s
    WHERE
        c.id_calendario = cd.id_calendario
        AND m.id_modalidad = cd.modalidad
        AND s.periodo = cd.periodo
        AND s.fec_inicio = cd.fecha_ini
;
--------------------------------------------------------
--  DDL for View MOVIMIENTO_CAJA
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FUNDAUC"."MOVIMIENTO_CAJA" ("PROG_ACADEMICO", "ORDEN", "FEC_FAC", "TIPO_ITEM", "ITEM", "TOTAL") AS 
  select decode(prog_academico,1,'IDIOMAS',2,'IDIOMAS',3,'DIPLOMADOS',6,'DIRECCION CENTRAL') prog_academico,orden, fec_fac,tipo_item,item,sum(total) total from
(
/* Libros y Guias paquetes*/
select f.prog_academico,c.orden orden,c.descripcion concepto,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')) curso,to_number(trim(token(df.descripcion,3, ' '))) nivel,f.fecha_emi fec_fac,df.id_fact,m.tipo tipo_item,m.id_mat item,m.descripcion,decode(m.tipo,'G',165,'L',325,0) p_venta, sum(decode(m.tipo,'G',165,'L',325,0)) total, count(*) cant
from factura f,detalle_factura df,tipo_material tm, materiales m, metodos mt, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact
and df.tipo_item=tm.abrev and tipo_item in 'C' and subtotal=1720 and m.tipo in ('G','L')
and decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' '))=m.id_curso and token(df.descripcion,3, ' ')=lpad(m.nivel,2,'0')
and decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' '))=mt.id_metodo and mt.idioma='INGLES'
and f.status='V' and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1) and c.id_concepto= ct.id_concepto and ct.tipo=m.tipo
group by f.prog_academico,c.orden,c.descripcion,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')),to_number(trim(token(df.descripcion,3, ' '))),f.fecha_emi,df.id_fact, m.tipo,m.id_mat,m.descripcion
UNION
select f.prog_academico,c.orden orden,c.descripcion concepto,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')) curso,to_number(trim(token(df.descripcion,3, ' '))) nivel,f.fecha_emi fec_fac,df.id_fact,m.tipo tipo_item,m.id_mat item,m.descripcion,decode(m.tipo,'G',165,'L',325,0) p_venta, sum(decode(m.tipo,'G',165,'L',325,0)) total, count(*) cant
from factura f,detalle_factura df,tipo_material tm, materiales m, metodos mt, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact
and df.tipo_item=tm.abrev and tipo_item in 'C' and subtotal=1840 and m.tipo in ('G','L')
and decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' '))=m.id_curso and token(df.descripcion,3, ' ')=lpad(m.nivel,2,'0')
and decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' '))=mt.id_metodo and mt.idioma='INGLES'
and f.status='V' and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1) and c.id_concepto= ct.id_concepto and ct.tipo=m.tipo
group by f.prog_academico,c.orden,c.descripcion,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')),to_number(trim(token(df.descripcion,3, ' '))),f.fecha_emi,df.id_fact, m.tipo,m.id_mat,m.descripcion
/* Guias paquetes */
UNION
select f.prog_academico,c.orden orden,c.descripcion concepto,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')) curso,to_number(trim(token(df.descripcion,3, ' '))) nivel,f.fecha_emi fec_fac,df.id_fact,m.tipo tipo_item,m.id_mat item,m.descripcion,264 p_venta, sum(264) total, count(*) cant
from factura f,detalle_factura df,tipo_material tm, materiales m, metodos mt, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact
and df.tipo_item=tm.abrev and tipo_item in 'C' and subtotal=1990 and m.tipo='G'
and decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' '))=m.id_curso and token(df.descripcion,3, ' ')=lpad(m.nivel,2,'0')
and decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' '))=mt.id_metodo and mt.idioma='INGLES'
and f.status='V' and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1) and c.id_concepto= ct.id_concepto and ct.tipo=m.tipo
group by f.prog_academico,c.orden,c.descripcion,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')),to_number(trim(token(df.descripcion,3, ' '))),f.fecha_emi,df.id_fact, m.tipo,m.id_mat,m.descripcion
UNION
select f.prog_academico,c.orden orden,c.descripcion concepto,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')) curso,to_number(trim(token(df.descripcion,3, ' '))) nivel,f.fecha_emi fec_fac,df.id_fact,m.tipo tipo_item,m.id_mat item,m.descripcion,264 p_venta, sum(264) total, count(*) cant
from factura f,detalle_factura df,tipo_material tm, materiales m, metodos mt, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact 
and df.tipo_item=tm.abrev and tipo_item in 'C' and subtotal=2260 and m.tipo='G'
and decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' '))=m.id_curso and token(df.descripcion,3, ' ')=lpad(m.nivel,2,'0')
and decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' '))=mt.id_metodo and mt.idioma='INGLES'
and f.status='V' and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1) and c.id_concepto= ct.id_concepto and ct.tipo=m.tipo
group by f.prog_academico,c.orden,c.descripcion,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')),to_number(trim(token(df.descripcion,3, ' '))),f.fecha_emi,df.id_fact, m.tipo,m.id_mat,m.descripcion
UNION
select f.prog_academico,c.orden orden,c.descripcion concepto,m.id_curso curso,m.nivel,f.fecha_emi fec_fac,df.id_fact,df.tipo_item,df.item,m.descripcion,p_unidad p_venta, sum(decode(df.subtotal,0,df.p_unidad,df.subtotal)) total,decode(cantidad,0,1,cantidad) cant
from factura f,detalle_factura df,tipo_material tm, materiales m, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact 
and df.tipo_item=tm.abrev and tipo_item='G' and f.status='V' and df.item=m.id_mat
and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1) and c.id_concepto= ct.id_concepto and ct.tipo=m.tipo
group by f.prog_academico,c.orden,c.descripcion,m.id_curso,m.nivel,f.fecha_emi,df.id_fact, df.tipo_item,df.item,m.descripcion,p_unidad, cantidad
UNION
select f.prog_academico,c.orden orden,c.descripcion concepto,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')) curso,to_number(trim(token(df.descripcion,3, ' '))) nivel,f.fecha_emi fec_fac,df.id_fact,m.tipo tipo_item,m.id_mat item,m.descripcion,264 p_venta, sum(264) total, count(*) cant
from factura f,detalle_factura df,tipo_material tm, materiales m, metodos mt, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact 
and df.tipo_item=tm.abrev and tipo_item in 'C' and subtotal=2500 and m.tipo='G'
and decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' '))=m.id_curso and token(df.descripcion,3, ' ')=lpad(m.nivel,2,'0')
and decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' '))=mt.id_metodo and mt.idioma='INGLES'
and f.status='V' and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1) and c.id_concepto= ct.id_concepto and ct.tipo=m.tipo
group by f.prog_academico,c.orden,c.descripcion,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')),to_number(trim(token(df.descripcion,3, ' '))),f.fecha_emi,df.id_fact, m.tipo,m.id_mat,m.descripcion
UNION
select f.prog_academico,c.orden orden,c.descripcion concepto,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')) curso,to_number(trim(token(df.descripcion,3, ' '))) nivel,f.fecha_emi fec_fac,df.id_fact,m.tipo tipo_item,m.id_mat item,m.descripcion,264 p_venta, sum(264) total, count(*) cant
from factura f,detalle_factura df,tipo_material tm, materiales m, metodos mt, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact 
and df.tipo_item=tm.abrev and tipo_item in 'C' and subtotal=2770 and m.tipo='G'
and decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' '))=m.id_curso and token(df.descripcion,3, ' ')=lpad(m.nivel,2,'0')
and decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' '))=mt.id_metodo and mt.idioma='INGLES'
and f.status='V' and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1) and c.id_concepto= ct.id_concepto and ct.tipo=m.tipo
group by f.prog_academico,c.orden,c.descripcion,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')),to_number(trim(token(df.descripcion,3, ' '))),f.fecha_emi,df.id_fact, m.tipo,m.id_mat,m.descripcion
UNION
/* Libros paquetes*/
select f.prog_academico,c.orden orden,c.descripcion concepto,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')) curso,to_number(trim(token(df.descripcion,3, ' '))) nivel,f.fecha_emi fec_fac,df.id_fact,m.tipo tipo_item,m.id_mat item,m.descripcion,510 p_venta, sum(510) total, count(*) cant
from factura f,detalle_factura df,tipo_material tm, materiales m, metodos mt, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact 
and df.tipo_item=tm.abrev and tipo_item in 'C' and subtotal=2500 and m.tipo='L'
and decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' '))=m.id_curso and token(df.descripcion,3, ' ')=lpad(m.nivel,2,'0')
and decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' '))=mt.id_metodo and mt.idioma='INGLES'
and f.status='V' and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1) and c.id_concepto= ct.id_concepto and ct.tipo=m.tipo
group by f.prog_academico,c.orden,c.descripcion,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')),to_number(trim(token(df.descripcion,3, ' '))),f.fecha_emi,df.id_fact, m.tipo,m.id_mat,m.descripcion
UNION
select f.prog_academico,c.orden orden,c.descripcion concepto,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')) curso,to_number(trim(token(df.descripcion,3, ' '))) nivel,f.fecha_emi fec_fac,df.id_fact,m.tipo tipo_item,m.id_mat item,m.descripcion,510 p_venta, sum(510) total, count(*) cant
from factura f,detalle_factura df,tipo_material tm, materiales m, metodos mt, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact
and df.tipo_item=tm.abrev and tipo_item in 'C' and subtotal=2770 and m.tipo='L'
and decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' '))=m.id_curso and token(df.descripcion,3, ' ')=lpad(m.nivel,2,'0')
and decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' '))=mt.id_metodo and mt.idioma='INGLES'
and f.status='V' and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1) and c.id_concepto= ct.id_concepto and ct.tipo=m.tipo
group by f.prog_academico,c.orden,c.descripcion,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')),to_number(trim(token(df.descripcion,3, ' '))),f.fecha_emi,df.id_fact, m.tipo,m.id_mat,m.descripcion
UNION
select f.prog_academico,c.orden orden,c.descripcion concepto,m.id_curso curso, m.nivel,f.fecha_emi fec_fac,df.id_fact,df.tipo_item,df.item,m.descripcion,p_unidad p_venta, sum(decode(df.subtotal,0,df.p_unidad,df.subtotal)) total,decode(cantidad,0,1,cantidad) cant
from factura f,detalle_factura df,tipo_material tm, materiales m, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact
and df.tipo_item=tm.abrev and tipo_item='L' and f.status='V' and DF.P_UNIDAD>0 and df.item=m.id_mat
and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1) and c.id_concepto= ct.id_concepto and ct.tipo=df.tipo_item
group by f.prog_academico,c.orden,c.descripcion,m.id_curso, m.nivel,f.fecha_emi,df.id_fact, df.tipo_item,df.item,m.descripcion,p_unidad, cantidad
/* libros monto negativo sin libro */
UNION
select f.prog_academico,c.orden orden,c.descripcion concepto,m.id_curso curso, m.nivel,f.fecha_emi fec_fac,df.id_fact,df.tipo_item,df.item,m.descripcion,decode(p_unidad,-395,-325,p_unidad)*-1 p_venta, sum(decode(df.subtotal,0,df.p_unidad,df.subtotal)) total,decode(cantidad,0,-1,cantidad*-1) cant
from factura f,detalle_factura df,tipo_material tm, materiales m, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact 
and df.tipo_item=tm.abrev and tipo_item='L' and f.status='V' and DF.P_UNIDAD<0 and df.item=m.id_mat
and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1) and c.id_concepto= ct.id_concepto and ct.tipo=df.tipo_item
group by f.prog_academico,c.orden,c.descripcion,m.id_curso, m.nivel,f.fecha_emi,df.id_fact, df.tipo_item,df.item,m.descripcion,p_unidad, cantidad
UNION
/* Cursos de Libros y Guias paquetes*/
select f.prog_academico,c.orden orden,c.descripcion concepto,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')) curso,to_number(trim(token(df.descripcion,3, ' '))) nivel,f.fecha_emi fec_fac,df.id_fact,df.tipo_item tipo_item,df.item item,df.descripcion,p_unidad - (165+325) p_venta, sum(df.subtotal-(165+325)) total, count(*) cant
from factura f,detalle_factura df,tipo_material tm, metodos mt, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact 
and df.tipo_item=tm.abrev and tipo_item in 'C' and subtotal=1720
and decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' '))=mt.id_metodo and mt.idioma='INGLES'
and f.status='V' and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1) and c.id_concepto= ct.id_concepto and ct.tipo=df.tipo_item
group by f.prog_academico,c.orden,c.descripcion,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')),to_number(trim(token(df.descripcion,3, ' '))),f.fecha_emi,df.id_fact, df.tipo_item,df.item,df.descripcion,p_unidad - (165+325)
UNION
select f.prog_academico,c.orden orden,c.descripcion concepto,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')) curso,to_number(trim(token(df.descripcion,3, ' '))) nivel,f.fecha_emi fec_fac,df.id_fact,df.tipo_item tipo_item,df.item item,df.descripcion,p_unidad - (165+325) p_venta, sum(df.subtotal-(165+325)) total, count(*) cant
from factura f,detalle_factura df,tipo_material tm, metodos mt, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact 
and df.tipo_item=tm.abrev and tipo_item in 'C' and subtotal=1840
and decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' '))=mt.id_metodo and mt.idioma='INGLES'
and f.status='V' and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1) and c.id_concepto= ct.id_concepto and ct.tipo=df.tipo_item
group by f.prog_academico,c.orden,c.descripcion,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')),to_number(trim(token(df.descripcion,3, ' '))),f.fecha_emi,df.id_fact, df.tipo_item,df.item,df.descripcion,p_unidad - (165+325)
/*Cursos con Guias paquetes */
UNION
select f.prog_academico,c.orden orden,c.descripcion concepto,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')) curso,to_number(trim(token(df.descripcion,3, ' '))) nivel,f.fecha_emi fec_fac,df.id_fact,df.tipo_item tipo_item,df.item item,df.descripcion,p_unidad - (264) p_venta, sum(df.subtotal-(264)) total, count(*) cant
from factura f,detalle_factura df,tipo_material tm, metodos mt, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact 
and df.tipo_item=tm.abrev and tipo_item in 'C' and subtotal=1990
and decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' '))=mt.id_metodo and mt.idioma='INGLES'
and f.status='V' and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1) and c.id_concepto= ct.id_concepto and ct.tipo=df.tipo_item
group by f.prog_academico,c.orden,c.descripcion,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')),to_number(trim(token(df.descripcion,3, ' '))),f.fecha_emi,df.id_fact, df.tipo_item,df.item,df.descripcion,p_unidad - (264)
UNION
select f.prog_academico,c.orden orden,c.descripcion concepto,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')) curso,to_number(trim(token(df.descripcion,3, ' '))) nivel,f.fecha_emi fec_fac,df.id_fact,df.tipo_item tipo_item,df.item item,df.descripcion,p_unidad - (264) p_venta, sum(df.subtotal-(264)) total, count(*) cant
from factura f,detalle_factura df,tipo_material tm, metodos mt, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact 
and df.tipo_item=tm.abrev and tipo_item in 'C' and subtotal=2260
and decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' '))=mt.id_metodo and mt.idioma='INGLES'
and f.status='V' and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1) and c.id_concepto= ct.id_concepto and ct.tipo=df.tipo_item
group by f.prog_academico,c.orden,c.descripcion,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')),to_number(trim(token(df.descripcion,3, ' '))),f.fecha_emi,df.id_fact, df.tipo_item,df.item,df.descripcion,p_unidad - (264)
UNION
/* Curso nivel 10 con Guia Empaquetada */
select f.prog_academico,c.orden orden,c.descripcion concepto,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')) curso,to_number(trim(token(df.descripcion,3, ' '))) nivel,f.fecha_emi fec_fac,df.id_fact,df.tipo_item tipo_item,df.item item,df.descripcion,p_unidad - (264) p_venta, sum(df.subtotal-(264)) total, count(*) cant
from factura f,detalle_factura df,tipo_material tm, metodos mt, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact
and df.tipo_item=tm.abrev and tipo_item in 'C' and subtotal=2500
and decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' '))=mt.id_metodo and mt.idioma='INGLES'
and f.status='V' and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1) and c.id_concepto= ct.id_concepto and ct.tipo=df.tipo_item
group by f.prog_academico,c.orden,c.descripcion,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')),to_number(trim(token(df.descripcion,3, ' '))),f.fecha_emi,df.id_fact, df.tipo_item,df.item,df.descripcion,p_unidad - (264)
UNION
select f.prog_academico,c.orden orden,c.descripcion concepto,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')) curso,to_number(trim(token(df.descripcion,3, ' '))) nivel,f.fecha_emi fec_fac,df.id_fact,df.tipo_item tipo_item,df.item item,df.descripcion,p_unidad - (264) p_venta, sum(df.subtotal-(264)) total, count(*) cant
from factura f,detalle_factura df,tipo_material tm, metodos mt, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact 
and df.tipo_item=tm.abrev and tipo_item in 'C' and subtotal=2770
and decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' '))=mt.id_metodo and mt.idioma='INGLES'
and f.status='V' and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1) and c.id_concepto= ct.id_concepto and ct.tipo=df.tipo_item
group by f.prog_academico,c.orden,c.descripcion,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')),to_number(trim(token(df.descripcion,3, ' '))),f.fecha_emi,df.id_fact, df.tipo_item,df.item,df.descripcion,p_unidad - (264)
UNION
/* Cursos Libros paquetes*/
select f.prog_academico,c.orden orden,c.descripcion concepto,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')) curso,to_number(trim(token(df.descripcion,3, ' '))) nivel,f.fecha_emi fec_fac,df.id_fact,df.tipo_item tipo_item,df.item item,df.descripcion,p_unidad - (264) p_venta, sum(df.subtotal-(264)) total, count(*) cant
from factura f,detalle_factura df,tipo_material tm, metodos mt, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact
and df.tipo_item=tm.abrev and tipo_item in 'C' and subtotal=2770
and decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' '))=mt.id_metodo and mt.idioma='INGLES'
and f.status='V' and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1) and c.id_concepto= ct.id_concepto and ct.tipo=df.tipo_item
group by f.prog_academico,c.orden,c.descripcion,decode(token(df.descripcion, 1, ' '),'AEC-A','AEC',token(df.descripcion, 1, ' ')),to_number(trim(token(df.descripcion,3, ' '))),f.fecha_emi,df.id_fact, df.tipo_item,df.item,df.descripcion,p_unidad - (264)
UNION
/*Control de Notas*/
select f.prog_academico,c.orden orden,c.descripcion concepto,null curso,null nivel,f.fecha_emi fec_fac,df.id_fact,df.tipo_item,df.item,tm.descripcion,p_unidad p_venta, sum(df.subtotal) total,count(*) cant
from factura f,detalle_factura df,tipo_material tm, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact 
and df.tipo_item=tm.abrev and f.status='V' and tipo_item = 'B'
and c.id_concepto= ct.id_concepto and ct.tipo=df.tipo_item
and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1)
group by f.prog_academico,c.orden,c.descripcion,f.fecha_emi,df.id_fact,df.tipo_item,df.item,tm.descripcion,p_unidad
UNION
/*Examenes*/
select f.prog_academico,c.orden orden,c.descripcion concepto,null curso,null nivel,f.fecha_emi fec_fac,df.id_fact,df.tipo_item,df.item,tm.descripcion,p_unidad p_venta, sum(df.subtotal) total,count(*) cant
from factura f,detalle_factura df,tipo_material tm, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact 
and df.tipo_item=tm.abrev and f.status='V' and tipo_item = 'E'
and c.id_concepto= ct.id_concepto and ct.tipo=df.tipo_item
and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1)
group by f.prog_academico,c.orden,c.descripcion,f.fecha_emi,df.id_fact,df.tipo_item,df.item,tm.descripcion,p_unidad
UNION
/*Matriculas*/
select f.prog_academico,c.orden orden,c.descripcion concepto,null curso,null nivel,f.fecha_emi fec_fac,df.id_fact,df.tipo_item,df.item,tm.descripcion,p_unidad p_venta, sum(df.subtotal) total,count(*) cant
from factura f,detalle_factura df,tipo_material tm, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact 
and df.tipo_item=tm.abrev and f.status='V' and tipo_item = 'M'
and c.id_concepto= ct.id_concepto and ct.tipo=df.tipo_item
and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1)
group by f.prog_academico,c.orden,c.descripcion,f.fecha_emi,df.id_fact,df.tipo_item,df.item,tm.descripcion,p_unidad
UNION
/*Aranceles de Graduacio y Ubicacion*/
select f.prog_academico,c.orden orden,c.descripcion concepto,null curso,null nivel,f.fecha_emi fec_fac,df.id_fact,df.tipo_item,df.item,tm.descripcion,p_unidad p_venta, sum(df.subtotal) total,count(*) cant
from factura f,detalle_factura df,tipo_material tm, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact 
and df.tipo_item=tm.abrev and f.status='V' and tipo_item = 'A'
and c.id_concepto= ct.id_concepto and ct.tipo=df.tipo_item and ct.id_mat=df.item
and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1)
group by f.prog_academico,c.orden,c.descripcion,f.fecha_emi,df.id_fact,df.tipo_item,df.item,tm.descripcion,p_unidad
UNION
/*Ingresos Diferidos*/
select f.prog_academico,c.orden orden,c.descripcion concepto,null curso,null nivel,f.fecha_emi fec_fac,df.id_fact,df.tipo_item,df.item,tm.descripcion,p_unidad p_venta, sum(df.subtotal) total,count(*) cant
from factura f,detalle_factura df,tipo_material tm, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact 
and df.tipo_item=tm.abrev and f.status='V' and tipo_item = 'ID'
and c.id_concepto= ct.id_concepto and ct.tipo=df.tipo_item
and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1)
group by f.prog_academico,c.orden,c.descripcion,f.fecha_emi,df.id_fact,df.tipo_item,df.item,tm.descripcion,p_unidad
UNION
/*Descuentos*/
select f.prog_academico,c.orden orden,c.descripcion concepto,null curso,null nivel,f.fecha_emi fec_fac,df.id_fact,df.tipo_item,df.item,tm.descripcion,p_unidad p_venta, sum(df.subtotal) total,count(*) cant
from factura f,detalle_factura df,tipo_material tm, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact 
and df.tipo_item=tm.abrev and f.status='V' and tipo_item = 'D'
and c.id_concepto= ct.id_concepto and ct.tipo=df.tipo_item
and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1)
group by f.prog_academico,c.orden,c.descripcion,f.fecha_emi,df.id_fact,df.tipo_item,df.item,tm.descripcion,p_unidad
UNION
/*Constacia de Estudios*/
select f.prog_academico,c.orden orden,c.descripcion concepto,null curso,null nivel,f.fecha_emi fec_fac,df.id_fact,df.tipo_item,df.item,tm.descripcion,p_unidad p_venta, sum(df.subtotal) total,count(*) cant
from factura f,detalle_factura df,tipo_material tm, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact 
and df.tipo_item=tm.abrev and f.status='V' and tipo_item = 'CO'
and c.id_concepto= ct.id_concepto and ct.tipo=df.tipo_item
and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1)
group by f.prog_academico,c.orden,c.descripcion,f.fecha_emi,df.id_fact,df.tipo_item,df.item,tm.descripcion,p_unidad
UNION
/*Reposicion de Factura*/
select f.prog_academico,c.orden orden,c.descripcion concepto,null curso,null nivel,f.fecha_emi fec_fac,df.id_fact,df.tipo_item,df.item,tm.descripcion,p_unidad p_venta, sum(df.subtotal) total,count(*) cant
from factura f,detalle_factura df,tipo_material tm, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact 
and df.tipo_item=tm.abrev and f.status='V' and tipo_item = 'F'
and c.id_concepto= ct.id_concepto and ct.tipo=df.tipo_item
and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1)
group by f.prog_academico,c.orden,c.descripcion,f.fecha_emi,df.id_fact,df.tipo_item,df.item,tm.descripcion,p_unidad
UNION
/*Recargo Administrativo*/
select f.prog_academico,c.orden orden,c.descripcion concepto,null curso,null nivel,f.fecha_emi fec_fac,df.id_fact,df.tipo_item,df.item,tm.descripcion,p_unidad p_venta, sum(df.subtotal) total,count(*) cant
from factura f,detalle_factura df,tipo_material tm, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact 
and df.tipo_item=tm.abrev and f.status='V' and tipo_item = 'R'
and c.id_concepto= ct.id_concepto and ct.tipo=df.tipo_item
and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1)
group by f.prog_academico,c.orden,c.descripcion,f.fecha_emi,df.id_fact,df.tipo_item,df.item,tm.descripcion,p_unidad
UNION
/*Colocacion de Nota*/
select f.prog_academico,c.orden orden,c.descripcion concepto,null curso,null nivel,f.fecha_emi fec_fac,df.id_fact,df.tipo_item,df.item,tm.descripcion,p_unidad p_venta, sum(df.subtotal) total,count(*) cant
from factura f,detalle_factura df,tipo_material tm, conceptos c, conceptos_tipo ct
where f.id_fact = df.id_fact 
and df.tipo_item=tm.abrev and f.status='V' and tipo_item = 'O' and df.item = 'CN'
and c.id_concepto= ct.id_concepto and ct.tipo=df.tipo_item
and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1)
group by f.prog_academico,c.orden,c.descripcion,f.fecha_emi,df.id_fact,df.tipo_item,df.item,tm.descripcion,p_unidad
UNION
/*Diplomados y Certificaciones*/
select f.prog_academico,c.orden orden,d.descripcion concepto,null curso,null nivel,f.fecha_emi fec_fac,df.id_fact,df.tipo_item,df.item,tm.descripcion,p_unidad p_venta, sum(df.subtotal) total,count(*) cant
from factura f,detalle_factura df,tipo_material tm, conceptos c, conceptos_tipo ct,
(select distinct id,id_diplocer from 
(select id,id_diplomado id_diplocer from cohortes
UNION
select id, id_certi id_diplocer from cohorte_certi)) ch, 
(select distinct id, descripcion from
(select id_diplomado id, descripcion, 'DIPLOMADO' tipo from diplomados
UNION
select id_certi id,descripcion, 'CERTIFICACION' tipo from diplo_certi)) d
where f.id_fact = df.id_fact 
and df.tipo_item=tm.abrev and f.status='V' and tipo_item in ('CU','PC') and df.item=ch.id and ch.id_diplocer=d.id
and c.id_concepto= ct.id_concepto and ct.tipo=df.tipo_item
and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1)
group by f.prog_academico,c.orden,d.descripcion,f.fecha_emi,df.id_fact,df.tipo_item,df.item,tm.descripcion,p_unidad
UNION
/*Diplomados Empresas*/
select 3 prog_academico,c.orden orden,e.razon concepto,null curso,null nivel,f.fecha_emi fec_fac,df.id_fact,df.tipo_item,df.item,tm.descripcion,p_unidad p_venta, sum(nvl(df.subtotal,0)) total,count(*) cant
from factura f,detalle_factura df,tipo_material tm, conceptos c, conceptos_tipo ct, empresas e
where f.id_fact = df.id_fact 
and df.tipo_item=tm.abrev and f.status='V' and tipo_item = 'DC' and f.rif=e.rif 
and c.id_concepto= ct.id_concepto and ct.tipo=df.tipo_item
and nvl(f.rif,' ') in (select rif from empresa_tipo where tipo = 2)
group by f.prog_academico,c.orden,e.razon,f.fecha_emi,df.id_fact,df.tipo_item,df.item,tm.descripcion,p_unidad
UNION
/*Diplomados Empresas Cuentas x Cobrar*/
select 3 prog_academico,c.orden orden,e.razon concepto,null curso,null nivel,f.fecha_emi fec_fac,df.id_fact,df.tipo_item,df.item,tm.descripcion,p_unidad p_venta, sum(df.subtotal*-1) total,count(*) cant
from factura f,detalle_factura df,tipo_material tm, conceptos c, conceptos_tipo ct, empresas e, cuentas_por_cobrar cc
where f.id_fact = df.id_fact 
and df.tipo_item=tm.abrev and f.status='V' and tipo_item = 'DC' and f.rif=e.rif and f.rif=cc.cliente and f.id_fact=cc.id_fact
and c.id_concepto= ct.id_concepto and ct.tipo=df.tipo_item
and nvl(f.rif,' ') in (select rif from empresa_tipo where tipo = 2)
group by f.prog_academico,c.orden,e.razon,f.fecha_emi,df.id_fact,df.tipo_item,df.item,tm.descripcion,p_unidad
UNION
/*Bancos*/
select distinct f.prog_academico,1 orden,fp.descripcion concepto,null curso, null nivel,f.fecha_emi fec_fac,to_number(fd.referencia) ID_FACT,decode(d.forma_pago,3,'DEPOSITOS','PUNTO DE VENTA') tipo_item,to_char(fd.id_banco) item,b.nombre descripcion,0 P_VENTA,d.monto total, 1 cant
from factura f,factura_deposito fd, bancos b, deposito d, forma_pago fp
where f.id_fact=fd.id_fact
AND f.status='V'
and b.id_banco=fd.id_banco and fd.id_banco=d.ID_BANCO and fd.referencia=d.referencia and d.forma_pago = fp.id_pago
and nvl(f.rif,' ') not in (select rif from empresa_tipo where tipo = 1)
)
group by decode(prog_academico,1,'IDIOMAS',2,'IDIOMAS',3,'DIPLOMADOS',6,'DIRECCION CENTRAL'),orden, fec_fac,tipo_item,item
;
