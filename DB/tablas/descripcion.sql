select df.descripcion,tokencount(replace(df.descripcion,'AEC-A','AECA'),'-'),
decode(
  tokencount(replace(df.descripcion,'AEC-A','AECA'),'-')
  ,3,
    replace(REGEXP_REPLACE(replace(df.descripcion,'AEC-A','AECA'),'-','|',1,2),'AECA','AEC-A')
  ,7,
    REGEXP_REPLACE(
      REGEXP_REPLACE(
        REGEXP_REPLACE(
          REGEXP_REPLACE(
             replace(df.descripcion,'AEC-A','AECA')
          ,'-','|',1,1)
        ,'-','|',1,1)
      ,'-','|',1,2)
  ,df.descripcion
) remplazo 
from ces.detalle_factura df, factura f
where df.id_fact = f.id_fact --and  item not in (select id_mat from materiales)
and tipo_item = 'C'