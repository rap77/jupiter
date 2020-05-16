    declare
        l_rc   NUMBER;
    BEGIN
      --  l_rc := log_message('[INFO] EJECUTANDO JOB ACTUALIZA ESTATUS INSCRIPCIONES ');
        FOR cur IN (
            SELECT
                id,
                CASE
                        WHEN utl_periodos.getstatusperiodoinssec(seccion_id) = 'Finalizado'
                             AND (
                            CASE
                                WHEN instr(utl_inscripciones.getstatusfac(id),'EXONERADO') > 1  THEN 'E'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'SUSPENDIDO') > 1 THEN 'S'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'POR COBRAR') > 1 THEN 'PC'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'ANULADA') > 1    THEN 'A'
                                ELSE 'X'
                            END
                        ) = 'PC' THEN 'IFXC'
                        WHEN utl_periodos.getstatusperiodoInssec(seccion_id) = 'Finalizado'   THEN 'IF'
                        WHEN utl_periodos.getstatusperiodoInssec(seccion_id) = 'En Curso'
                             AND fecha_ins + 9 < utl_periodos.getperiodoFInicio(periodo_id)
                             AND (
                            CASE
                                WHEN instr(utl_inscripciones.getstatusfac(id),'EXONERADO') > 1  THEN 'E'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'SUSPENDIDO') > 1 THEN 'S'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'POR COBRAR') > 1 THEN 'PC'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'ANULADA') > 1    THEN 'A'
                                ELSE 'X'
                            END
                        ) <> 'PC' THEN 'IF'
                        WHEN utl_periodos.getstatusperiodoInssec(seccion_id) = 'En Curso'
                             AND (
                            CASE
                                WHEN instr(utl_inscripciones.getstatusfac(id),'EXONERADO') > 1  THEN 'E'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'SUSPENDIDO') > 1 THEN 'S'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'POR COBRAR') > 1 THEN 'PC'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'ANULADA') > 1    THEN 'A'
                                ELSE 'X'
                            END
                        ) = 'X' THEN 'ACP'
                        WHEN utl_periodos.getstatusperiodoInssec(seccion_id) = 'En Curso'
                             AND (
                            CASE
                                WHEN instr(utl_inscripciones.getstatusfac(id),'EXONERADO') > 1  THEN 'E'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'SUSPENDIDO') > 1 THEN 'S'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'POR COBRAR') > 1 THEN 'PC'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'ANULADA') > 1    THEN 'A'
                                ELSE 'X'
                            END
                        ) = 'PC' THEN 'ACXC'
                        WHEN utl_periodos.getstatusperiodoInssec(seccion_id) = 'En Curso'
                             AND (
                            CASE
                                WHEN instr(utl_inscripciones.getstatusfac(id),'EXONERADO') > 1  THEN 'E'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'SUSPENDIDO') > 1 THEN 'S'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'POR COBRAR') > 1 THEN 'PC'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'ANULADA') > 1    THEN 'A'
                                ELSE 'X'
                            END
                        ) = 'E' THEN 'ACX'
                        WHEN utl_periodos.getstatusperiodoInssec(seccion_id) = 'En Curso'
                             AND (
                            CASE
                                WHEN instr(utl_inscripciones.getstatusfac(id),'EXONERADO') > 1  THEN 'E'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'SUSPENDIDO') > 1 THEN 'S'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'POR COBRAR') > 1 THEN 'PC'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'ANULADA') > 1    THEN 'A'
                                ELSE 'X'
                            END
                        ) = 'S' THEN 'ACS'
                        WHEN utl_periodos.getstatusperiodoInssec(seccion_id) = 'Por Comenzar'
                             AND (
                            CASE
                                WHEN instr(utl_inscripciones.getstatusfac(id),'EXONERADO') > 1  THEN 'E'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'SUSPENDIDO') > 1 THEN 'S'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'POR COBRAR') > 1 THEN 'PC'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'ANULADA') > 1    THEN 'A'
                                ELSE 'X'
                            END
                        ) = 'X' THEN 'AEP'
                        WHEN utl_periodos.getstatusperiodoInssec(seccion_id) = 'Por Comenzar'
                             AND (
                            CASE
                                WHEN instr(utl_inscripciones.getstatusfac(id),'EXONERADO') > 1  THEN 'E'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'SUSPENDIDO') > 1 THEN 'S'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'POR COBRAR') > 1 THEN 'PC'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'ANULADA') > 1    THEN 'A'
                                ELSE 'X'
                            END
                        ) = 'PC' THEN 'AEXC'
                        WHEN utl_periodos.getstatusperiodoInssec(seccion_id) = 'Por Comenzar'
                             AND (
                            CASE
                                WHEN instr(utl_inscripciones.getstatusfac(id),'EXONERADO') > 1  THEN 'E'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'SUSPENDIDO') > 1 THEN 'S'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'POR COBRAR') > 1 THEN 'PC'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'ANULADA') > 1    THEN 'A'
                                ELSE 'X'
                            END
                        ) = 'E' THEN 'AEX'
                        WHEN utl_periodos.getstatusperiodoInssec(seccion_id) = 'Por Comenzar'
                             AND (
                            CASE
                                WHEN instr(utl_inscripciones.getstatusfac(id),'EXONERADO') > 1  THEN 'E'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'SUSPENDIDO') > 1 THEN 'S'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'POR COBRAR') > 1 THEN 'PC'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'ANULADA') > 1    THEN 'A'
                                ELSE 'X'
                            END
                        ) = 'S' THEN 'AES'
                        WHEN (
                            CASE
                                WHEN instr(utl_inscripciones.getstatusfac(id),'EXONERADO') > 1  THEN 'E'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'SUSPENDIDO') > 1 THEN 'S'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'POR COBRAR') > 1 THEN 'PC'
                                WHEN instr(utl_inscripciones.getstatusfac(id),'ANULADA') > 1    THEN 'A'
                                ELSE 'X'
                            END
                        ) = 'A' THEN 'AN'
                    END
                estatus
            FROM
                inscripciones
            where id = 921
           order by id
        ) LOOP
         dbms_output.put_line(cur.id||'='||cur.estatus);
            EXECUTE IMMEDIATE 'update inscripciones set estatus='''
            || cur.estatus
            || ''' where id='
            || cur.id;
        END LOOP;

        dbms_output.put_line('[INFO] JOB EJECUTADO');
    --    l_rc := log_message('[INFO] JOB ACTUALIZA_ESTATUS EJECUTADO');
    END;
    
    
