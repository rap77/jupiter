
select * from factura


update factura fu set monto =
(select df.monto_det from factura f,
(select df.factura_id,sum(cantidad*p_unidad) monto_det from detalle_factura df
group by factura_id) df
where f.id=df.factura_id
and nvl(f.monto,0)<>df.monto_det
and f.id=fu.id)
where to_char(creado_el,'MMYYYY')='102019'
and f.id in (select f.id from factura f,
(select df.factura_id,sum(cantidad*p_unidad) monto_det from detalle_factura df
group by factura_id) df
where f.id=df.factura_id
and nvl(f.monto,0)<>df.monto_det
and f.id=fu.id) 

select * from detalle_factura