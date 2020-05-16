BEGIN
    FOR i IN (
        SELECT
            hv.metadata,
            to_number(hv.metadata.seccion.horario.id_horario) horario_id,
            to_number(hv.metadata.inscripcion.id) inscripcion_id
        FROM
            hoja_vida_est hv
        WHERE
            evento_id = 2
            AND   hv.metadata.inscripcion.id IS NOT NULL
    ) LOOP
        BEGIN
     /*       dbms_output.put_line('horario='
            || i.horario_id
            || ' id='
            || i.inscripcion_id);
*/
            UPDATE inscripciones
                SET
                    horario_id = i.horario_id
            WHERE
                id = i.inscripcion_id;
    
        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line(sqlerrm);
        END;
    END LOOP;
END;


BEGIN
    FOR i IN (
        SELECT
            id seccion_id,id_horario horario_id
        FROM
            secciones
    ) LOOP
        BEGIN
     /*       dbms_output.put_line('horario='
            || i.horario_id
            || ' id='
            || i.inscripcion_id);
*/
            UPDATE inscripciones
                SET
                    horario_id = i.horario_id
            WHERE
                seccion_id = i.seccion_id
                and horario_id is null;
    
        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line(sqlerrm);
        END;
    END LOOP;
END;



select df.item
,token(df.descripcion,1,'|') metodo_id
,to_number(replace(token(df.descripcion,2,'|'),'NIVEL ','')) nivel
--,utl_horarios.getIdhorario(token(df.descripcion,3,'|'),utl_modalidades.getIdModalidad(token(df.descripcion,5,'|'))) horario_id
,replace(token(df.descripcion,4,'|'),'&#x2F;','/') fecha_ini
,utl_modalidades.getIdModalidad(token(df.descripcion,5,'|')) modalidad_id
,df.descripcion,f.id
,e.matricula 
from detalle_factura df, factura f, estudiante e
where tipo_item = 'C'
and df.factura_id=f.id
and f.cedula_est=e.cedula_est

