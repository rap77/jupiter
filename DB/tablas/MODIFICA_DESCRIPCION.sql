delete from ces.detalle_factura
where nvl(subtotal,0)=0;


UPDATE "CES"."DETALLE_FACTURA" SET ITEM = '01111', DESCRIPCION = 'AEC-A|NIVEL 01|02:00 PM-04:00 PM|15/01/2019|MARTES A VIERNES|1' WHERE renglon=11767432;
UPDATE "CES"."DETALLE_FACTURA" SET DESCRIPCION = 'FRA1|NIVEL 02|07:00 AM-10:00 AM|17/10/2018|INTENSIVO|1' WHERE renglon=11802435;
UPDATE "CES"."DETALLE_FACTURA" SET DESCRIPCION = 'AECJUNIOR|NIVEL 01|02:00 PM-05:00 PM|30/04/2019|SOLO MARTES|1' WHERE renglon in (11997259,12006347,12010039,12010252,12035386,12035528,12035812,12036380,12039717,12040427,12050083,12058532,12059668,12059810,12065419,12065561);
UPDATE "CES"."DETALLE_FACTURA" SET DESCRIPCION = 'AEC-A|NIVEL 10|08:00 AM-12:00 PM|29/04/2018|INTENSIVO|0' WHERE renglon in (12021257,12021328,12021541,12022606,12051574);
UPDATE "CES"."DETALLE_FACTURA" SET DESCRIPCION = 'AECJUNIOR|NIVEL 02|02:00 PM-05:00 PM|24/05/2019|SOLO LUNES|1' WHERE renglon in (12169860,12170854,12176747);
UPDATE "CES"."DETALLE_FACTURA" SET DESCRIPCION = 'AECJUNIOR|NIVEL 03|02:00 PM-05:00 PM|06/06/2019|SOLO LUNES|1' WHERE renglon in (12170002,12170286);
UPDATE "CES"."DETALLE_FACTURA" SET DESCRIPCION = 'AECJUNIOR|NIVEL 04|02:00 PM-06:00 PM|24/05/2019|SOLO VIERNES|4' WHERE renglon=12170144;
UPDATE "CES"."DETALLE_FACTURA" SET DESCRIPCION = 'AECJUNIOR|NIVEL 04|02:00 PM-05:00 PM|29/05/2019|SOLO LUNES|4' WHERE renglon=12170428;
UPDATE "CES"."DETALLE_FACTURA" SET DESCRIPCION = 'AEC-A|NIVEL 05|04:00 PM-06:00 PM|19/01/2019|INTENSIVO|1' WHERE renglon=11807050;



select renglon,df.descripcion,tokencount(replace(df.descripcion,'AEC-A','AECA'),'-'),REGEXP_REPLACE(replace(df.descripcion,'M|','M-'),'-','|',1,2) 
from ces.detalle_factura df, factura f
where df.id_fact = f.id_fact
and to_char(f.fecha_emi,'YYYY')='2019'
and tipo_item = 'C'
and df.descripcion like '%-2019%'

update ces.detalle_factura d set descripcion = replace(descripcion,'NIVEL -','NIVEL 0')
where descripcion like '%NIVEL -%';


update ces.detalle_factura d set descripcion = (select replace(df.descripcion,'15-01-2019','15/01/2019')
from ces.detalle_factura df, ces.factura f
where df.id_fact = f.id_fact
and to_char(f.fecha_emi,'YYYY')='2019'
and tipo_item = 'C'
and df.descripcion like '%-2019%'
and df.renglon=d.renglon)
where (id_fact,renglon) in (select df.id_fact,df.renglon
from ces.detalle_factura df, ces.factura f
where df.id_fact = f.id_fact
and to_char(f.fecha_emi,'YYYY')='2019'
and tipo_item = 'C'
and df.descripcion like '%-2019%');

update ces.detalle_factura d set descripcion = (select replace(df.descripcion,'19-01-2019','19/01/2019')
from ces.detalle_factura df, ces.factura f
where df.id_fact = f.id_fact
and to_char(f.fecha_emi,'YYYY')='2019'
and tipo_item = 'C'
and df.descripcion like '%-2019%'
and df.renglon=d.renglon)
where (id_fact,renglon) in (select df.id_fact,df.renglon
from ces.detalle_factura df, ces.factura f
where df.id_fact = f.id_fact
and to_char(f.fecha_emi,'YYYY')='2019'
and tipo_item = 'C'
and df.descripcion like '%-2019%');

update ces.detalle_factura d set descripcion = (select replace(df.descripcion,'25-04-2019','25/04/2019')
from ces.detalle_factura df, ces.factura f
where df.id_fact = f.id_fact
and to_char(f.fecha_emi,'YYYY')='2019'
and tipo_item = 'C'
and df.descripcion like '%-2019%'
and df.renglon=d.renglon)
where (id_fact,renglon) in (select df.id_fact,df.renglon
from ces.detalle_factura df, ces.factura f
where df.id_fact = f.id_fact
and to_char(f.fecha_emi,'YYYY')='2019'
and tipo_item = 'C'
and df.descripcion like '%-2019%');

update ces.detalle_factura d set descripcion = (select replace(REGEXP_REPLACE(replace(replace(df.descripcion,'AEC-A','AECA'),'M|','M-'),'-','|',1,2),'AECA','AEC-A') 
from ces.detalle_factura df, ces.factura f
where df.id_fact = f.id_fact
and to_char(f.fecha_emi,'YYYY')='2019'
and tipo_item = 'C'
and df.descripcion like '%M|%'
and df.renglon=d.renglon)
where (renglon,id_fact) in (select df.renglon,f.id_fact
from ces.detalle_factura df, ces.factura f
where df.id_fact = f.id_fact
and to_char(f.fecha_emi,'YYYY')='2019'
and tipo_item = 'C'
and df.descripcion like '%M|%');

update ces.detalle_factura d set descripcion = 
(select 
decode(
  tokencount(replace(df.descripcion,'AEC-A','AECA'),'-')
  ,3,
    replace(REGEXP_REPLACE(replace(df.descripcion,'AEC-A','AECA'),'-','|',1,2),'AECA','AEC-A')
  ,7,
  REGEXP_REPLACE(
    REGEXP_REPLACE(
      REGEXP_REPLACE(
        REGEXP_REPLACE(
          REGEXP_REPLACE(
             replace(df.descripcion,'AEC-A','AECA')
          ,'-','|',1,1)
        ,'-','|',1,1)
      ,'-','|',1,2)
    ,'-','|',1,2)
    ,'-','|',1,2)
  ,df.descripcion
) remplazo 
from ces.detalle_factura df, ces.factura f
where df.id_fact = f.id_fact --and  item not in (select id_mat from materiales)
and tipo_item = 'C' and d.renglon=df.renglon)
where (renglon,id_fact) in (select df.renglon,f.id_fact
from ces.detalle_factura df, ces.factura f
where df.id_fact = f.id_fact
and to_char(f.fecha_emi,'YYYY')='2019'
and tipo_item = 'C');

select * from detalle_factura where descripcion is null;
