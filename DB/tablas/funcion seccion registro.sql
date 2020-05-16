declare

    TYPE seccion_rt IS RECORD ( 
    seccion_id secciones.id_seccion%TYPE,
    id_metodo secciones.id_metodo%TYPE,
    nivel secciones.nivel%TYPE,
    id_horario secciones.id_horario%TYPE,
    id_modalidad secciones.modalidad%TYPE,
    id_periodo secciones.periodo%TYPE );
    
        l_seccion_rec   seccion_rt;
        l_fecha_ini     DATE;
        p_renglon number := 33;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('ENTRANDO...');
        

        SELECT
            item,
            token(descripcion,1,'|') id_metodo,
            to_number(replace(token(descripcion,2,'|'),'NIVEL ','') ) nivel,
            utl_horarios.getidhorario(token(descripcion,3,'|'),utl_modalidades.getidmodalidad(token(descripcion,5,'|') ) ) id_horario,
            utl_modalidades.getidmodalidad(token(descripcion,5,'|') ) id_modalidad,
            TO_DATE(token(descripcion,4,'|'),'DD/MM/YYYY') fecha_ini
        INTO
            l_seccion_rec.seccion_id,l_seccion_rec.id_metodo,l_seccion_rec.nivel,l_seccion_rec.id_horario,l_seccion_rec.id_modalidad,l_fecha_ini
        FROM
            detalle_factura
        WHERE
            renglon = p_renglon;

      DBMS_OUTPUT.PUT_LINE('Renglon='||p_renglon);
      DBMS_OUTPUT.PUT_LINE('SeccionID='||l_seccion_rec.seccion_id);
      DBMS_OUTPUT.PUT_LINE('IdMetodo='||l_seccion_rec.id_metodo);
      DBMS_OUTPUT.PUT_LINE('Nivel='||l_seccion_rec.nivel);
      DBMS_OUTPUT.PUT_LINE('Horario='||l_seccion_rec.id_horario);
      DBMS_OUTPUT.PUT_LINE('id_modalidad='||l_seccion_rec.id_modalidad);
      DBMS_OUTPUT.PUT_LINE('fecha_ini='||to_char(l_fecha_ini,'DDMMYYYY'));

        SELECT
            id
        INTO
            l_seccion_rec.id_periodo
        FROM
            calendarios_detalle cd,
            metodos m
        WHERE
            modalidad = l_seccion_rec.id_modalidad
            AND   fecha_ini = l_fecha_ini
            AND   m.id_metodo = l_seccion_rec.id_metodo
            AND   m.id_calendario = cd.id_calendario;

      DBMS_OUTPUT.PUT_LINE('id_periodo='||l_seccion_rec.id_periodo);

     --   RETURN l_seccion_rec;
    EXCEPTION
        WHEN no_data_found THEN
            l_seccion_rec := NULL;
   --         RETURN l_seccion_rec;
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
    END getseccionrec;
