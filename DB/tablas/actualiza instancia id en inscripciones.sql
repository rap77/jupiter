DECLARE 
BEGIN
    FOR i IN (
        SELECT
            *
        FROM
            instancias_secciones
    ) LOOP
        UPDATE inscripciones
            SET
                instancia_id = i.id
        WHERE
            seccion_id = i.seccion_id
            AND   periodo_id = i.periodo_id
            AND   horario_id = i.horario_id
            AND   horario_id IS NOT NULL;

    END LOOP;
END;
         