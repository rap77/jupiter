declare
  v_hora_id number;
begin
  for i in (
     select inscripcion_id,renglon, utl_horarios.getIdHorario(token(descripcion,3,'|') ,utl_modalidades.getIdModalidad(token(descripcion,4,'|'))) id_horario from INSCRIPCION_FACTURA if,detalle_factura df
     where if.factura_id=df.factura_id and tipo_item='C'
     and tokencount(descripcion,'|') = 5
  ) loop
  begin
--        select id_horario into v_hora_id from utl_inscripciones.tt(i.renglon);
        update inscripciones set horario_id=i.id_horario where id = i.inscripcion_id and horario_id is null;
    exception
    WHEN NO_DATA_FOUND THEN NULL;
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM||'- renglon='||i.renglon);
    end;
    end loop;
end;


select id_horario into v_hora_id from utl_inscripciones.tt(31);

select utl_horarios.getIdHorario('07:00 AM-09:00 AM',utl_modalidades.getIdModalidad('MARTES A VIERNES')) from dual
select renglon,utl_horarios.getIdHorario(token(descripcion,3,'|') ,utl_modalidades.getIdModalidad(token(descripcion,5,'|'))) id_horario ,tokencount(descripcion,'|'),descripcion from detalle_factura
select renglon,token(descripcion,3,'|'),token(descripcion,4,'|'), descripcion from detalle_factura
where tipo_item='C'
and tokencount(descripcion,'|') = 5
and renglon=5429

        SELECT
            id
        FROM
            calendarios_detalle cd,
            metodos m
        WHERE
            modalidad = 3
            AND   fecha_ini = to_date('27092019','DDMMYYYY')
            AND   m.id_metodo = 'CAV03'
            AND   m.id_calendario = cd.id_calendario;
            
            
select token('AEC-3|NIVEL 02|09:15 AM-11:15 PM||MARTES A VIERNES|2 (E)',4,'|'),tokencount('|NIVEL 02','|'),INSTR ('AEC-3|NIVEL 02|09:15 AM-11:15 PM||MARTES A VIERNES|2 (E)', '|') from dual