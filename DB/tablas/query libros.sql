select f.fecha_emi,df.tipo_item, df.item, df.descripcion,sum(cantidad, subtotal from detalle_factura df, factura f
where df.factura_id = f.id
and tipo_item in ('L','G')
and f.status = 'V'
and f.fecha_emi between to_date('01092019','DDMMYYYY') and to_date('30092019','DDMMYYYY')

select f.fecha_emi,df.tipo_item, df.item, df.descripcion,df.cantidad, df.p_unidad, df.subtotal from detalle_factura df, factura f
                        where df.factura_id = f.id
                        and tipo_item in ('L','G')
                        and f.status = 'V'
                        and f.fecha_emi between :P68_FECHA_INI AND :P68_FECHA_FIN
                        order by 1,2,3;
                        
                        
select DATEPARSE("yyyy-mm-dd", (STR ([Year]) + "-" + STR([Month]) + "-1" )) from dual