begin
    for i in (select id,id_seccion,utl_inscripciones.getSeccionDes(id) des,id_metodo,nivel from secciones) loop
        begin
            update materiales set id_mat=i.id_seccion,descripcion=i.des, id_curso=i.id_metodo,nivel=i.nivel
            where seccion_id=i.id and tipo='C';
        exception
            when others then
              DBMS_OUTPUT.PUT_LINE(SQLERRM||'-'||i.id_seccion);
        end;
    end loop;
end;


select id,utl_inscripciones.getCodigoSeccion(id_metodo,nivel,modalidad,periodo,id_horario) from secciones

select utl_periodos.getperiodomin(14) from dual

select * from secciones where periodo not in (select id from calendarios_detalle)


select hv.metadata.seccion.periodo from hoja_vida_est hv
where metadata is not null
and hv.metadata.seccion.periodo.id='65'