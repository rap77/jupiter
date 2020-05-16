GRANT CREATE ANY JOB TO FUNDAUC;
GRANT EXECUTE ON DBMS_SCHEDULER TO FUNDAUC;
GRANT MANAGE SCHEDULER TO FUNDAUC;

BEGIN
DBMS_RULE_ADM.GRANT_SYSTEM_PRIVILEGE(DBMS_RULE_ADM.CREATE_RULE_OBJ, 'FUNDAUC');
DBMS_RULE_ADM.GRANT_SYSTEM_PRIVILEGE(DBMS_RULE_ADM.CREATE_RULE_SET_OBJ, 'FUNDAUC');
DBMS_RULE_ADM.GRANT_SYSTEM_PRIVILEGE(DBMS_RULE_ADM.CREATE_EVALUATION_CONTEXT_OBJ, 'FUNDAUC');
END;
/

BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'elimina_inscripciones',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'FUNDAUC.UTL_INSCRIPCIONES.ELIMINA_INSCRIPCIONES',
   start_date         =>  '07-SEP-19 06.00.00 PM America/Caracas',
   repeat_interval    =>  'FREQ=DAILY;INTERVAL=2', /* every other day */
   end_date           =>  '07-SEP-99 07.00.00 PM America/Caracas',
   auto_drop          =>   FALSE,
   job_class          =>  'batch_update_jobs',
   comments           =>  'Elimina las inscripciones que no se finalizaron en el dia');
END;
/

BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '"FUNDAUC"."ELIMINAR_INSCRIPCIONES"',
            job_type => 'STORED_PROCEDURE',
            job_action => 'FUNDAUC.UTL_INSCRIPCIONES.ELIMINA_INSCRIPCIONES',
            number_of_arguments => 0,
            start_date => TO_TIMESTAMP_TZ('2019-09-08 08:41:55.000000000 AMERICA/CARACAS','YYYY-MM-DD HH24:MI:SS.FF TZR'),
            repeat_interval => 'FREQ=DAILY;BYTIME=170000;BYDAY=MON,TUE,WED,THU,FRI,SAT',
            end_date => NULL,
            enabled => TRUE,
            auto_drop => FALSE,
            comments => 'Elimina las inscripciones que quedaron pendientes al final del dia');

    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"FUNDAUC"."ELIMINAR_INSCRIPCIONES"', 
             attribute => 'restartable', value => TRUE);
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"FUNDAUC"."ELIMINAR_INSCRIPCIONES"', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_FULL);
  
    DBMS_SCHEDULER.enable(
             name => '"FUNDAUC"."ELIMINAR_INSCRIPCIONES"');
END;

BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '"FUNDAUC"."ELIMINA_INSCRIPCIONES"',
            job_type => 'STORED_PROCEDURE',
            job_action => 'FUNDAUC.UTL_INSCRIPCIONES.ELIMINA_INSCRIPCIONES',
            number_of_arguments => 0,
            start_date => TO_TIMESTAMP_TZ('2019-09-08 09:00:26.000000000 AMERICA/CARACAS','YYYY-MM-DD HH24:MI:SS.FF TZR'),
            repeat_interval => 'FREQ=DAILY;BYTIME=170000;BYDAY=MON,TUE,WED,THU,FRI,SAT',
            end_date => NULL,
            enabled => FALSE,
            auto_drop => FALSE,
            comments => 'Elimina las inscripciones que quedaron en proceso al final del dia');

    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"FUNDAUC"."ELIMINA_INSCRIPCIONES"', 
             attribute => 'job_priority', value => '1');
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"FUNDAUC"."ELIMINA_INSCRIPCIONES"', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
  
    DBMS_SCHEDULER.enable(
             name => '"FUNDAUC"."ELIMINA_INSCRIPCIONES"');
END;

