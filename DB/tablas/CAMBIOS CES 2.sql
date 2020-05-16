-- Generado por Oracle SQL Developer Data Modeler 18.4.0.339.1532
--   en:        2019-07-09 12:07:49 VET
--   sitio:      Oracle Database 12cR2
--   tipo:      Oracle Database 12cR2




CREATE TABLE inscripciones (
    id               NUMBER NOT NULL,
    fecha_ins        DATE,
    est_matricula    NUMBER(10) NOT NULL,
    sec_id_seccion   VARCHAR2(8 BYTE) NOT NULL,
    sec_id_metodo    VARCHAR2(10 BYTE) NOT NULL,
    fecha_pago       DATE,
    nro_factura      NUMBER(10),
    estatus          VARCHAR2(255)
)
LOGGING;

COMMENT ON COLUMN inscripciones.id IS
    'Identificador unico de la iscripcion del estudiante en el curso';

COMMENT ON COLUMN inscripciones.fecha_ins IS
    'Fecha de la Inscripcion';

COMMENT ON COLUMN inscripciones.fecha_pago IS
    'Fecha de Pago de la Inscripcion';

COMMENT ON COLUMN inscripciones.nro_factura IS
    'Numero de Factura con que se Efectuo la Inscripcion';

COMMENT ON COLUMN inscripciones.estatus IS
    'Estado de laInscripcion Ej, Pre-Inscripcion, Inscripcion Efectiva, Inscripcion Anulada, Inscripcion Exonerada, Inactiva';

ALTER TABLE inscripciones ADD CONSTRAINT inscripciones_pk PRIMARY KEY ( id );



ALTER TABLE ces.calendarios_detalle MODIFY (
    periodo
        NOT NULL NOT DEFERRABLE ENABLE VALIDATE
);
ALTER TABLE ces.calendarios_detalle ADD (
    periodo_activo CHAR(1) DEFAULT 'S'
);

ALTER TABLE ces.calendarios_detalle
    ADD CONSTRAINT ck_per_activo CHECK ( periodo_activo IN (
        'N',
        'S'
    ) );

COMMENT ON COLUMN ces.calendarios_detalle.periodo_activo IS
    'Si el Periodo esta Activo o no';
------ falla
create table cal_detalle_bak201907up as select * from calendarios_detalle;
delete calendarios_detalle;

ALTER TABLE ces.calendarios_detalle ADD (
    id NUMBER NOT NULL
);

COMMENT ON COLUMN ces.calendarios_detalle.id IS
    'Identificador Unico de Calendario';
ALTER TABLE ces.calendarios_detalle MODIFY (
    periodo_activo CHAR(1)
);

        
    ALTER TABLE ces.calendarios_detalle ADD CONSTRAINT calendarios_detalle_pk PRIMARY KEY ( id );
    
    delete from cal_detalle_bak201907up a
    where rowid > (select min(rowid) from cal_detalle_bak20190710 b
    where b.id_calendario = a.id_calendario
      and b.periodo=a.periodo
      and b.modalidad=a.modalidad);
    
insert into calendarios_detalle select distinct ID_CALENDARIO, 
	PERIODO, 
	FECHA_INI, 
	FECHA_FIN, 
	VIGENCIA, 
	MODALIDAD, 
	'S' PERIODO_ACTIVO, 
	rownum ID from cal_detalle_bak201907up;
    
CREATE UNIQUE INDEX ces.calendarios_detalle_idx ON
    ces.calendarios_detalle (
        id_calendario
    ASC,
        periodo
    ASC,
        modalidad
    ASC )
        TABLESPACE users LOGGING;
------ fin falla   

ALTER TABLE ces.condiciones_especiales MODIFY (
    id_condicion
        NOT NULL NOT DEFERRABLE ENABLE VALIDATE
);
ALTER TABLE ces.condiciones_especiales ADD CONSTRAINT condiciones_especiales_pk PRIMARY KEY ( id_condicion );
ALTER TABLE ces.edificios MODIFY (
    id_edif
        NOT NULL NOT DEFERRABLE ENABLE VALIDATE
);
ALTER TABLE ces.edificios ADD CONSTRAINT edificios_pk PRIMARY KEY ( id_edif );
---------- falla
update estudiante set profesion=null
where profesion = '-';
update estudiante set zona = null;
create table estudiante_bak201907up as select * from estudiante;
begin
  for cur in (select fk.owner, fk.constraint_name , fk.table_name 
    from all_constraints fk, all_constraints pk 
     where fk.CONSTRAINT_TYPE = 'R' and 
           pk.owner = 'CES' and
           fk.r_owner = pk.owner and
           fk.R_CONSTRAINT_NAME = pk.CONSTRAINT_NAME and 
           pk.TABLE_NAME = 'ESTUDIANTE') loop
    execute immediate 'ALTER TABLE "'||cur.owner||'"."'||cur.table_name||'" MODIFY CONSTRAINT "'||cur.constraint_name||'" DISABLE';
  end loop;
end;
delete estudiante;

ALTER TABLE ces.estudiante MODIFY (
    ciudad NUMBER(10)
);
ALTER TABLE ces.estudiante MODIFY (
    estado NUMBER(10)
);
ALTER TABLE ces.estudiante MODIFY (
    profesion NUMBER
);
ALTER TABLE ces.estudiante MODIFY (
    zona NUMBER
);


insert into estudiante select * from estudiante_bak201907up;

begin
  for cur in (select fk.owner, fk.constraint_name , fk.table_name 
   from all_constraints fk, all_constraints pk 
    where fk.CONSTRAINT_TYPE = 'R' and 
          pk.owner = 'CES' and
          fk.r_owner = pk.owner and
          fk.R_CONSTRAINT_NAME = pk.CONSTRAINT_NAME and 
          pk.TABLE_NAME = 'ESTUDIANTE') loop
    execute immediate 'ALTER TABLE "'||cur.owner||'"."'||cur.table_name||'" MODIFY CONSTRAINT "'||cur.constraint_name||'" ENABLE';
  end loop;
end;
------------- fin falla
ALTER TABLE ces.ocupaciones MODIFY (
    id_ocupacion NUMBER
);
ALTER TABLE ces.profesor ADD (
    direccion VARCHAR2(255 BYTE)
);

COMMENT ON COLUMN ces.profesor.direccion IS
    'DIRECCION';
    
---- falla

create table secciones_bak201907up as select * from secciones;

delete secciones;

ALTER TABLE ces.secciones MODIFY (
    id_edif NUMBER(3)
);

ALTER TABLE ces.secciones ADD (
    id_horario NUMBER(3) NOT NULL
);
ALTER TABLE ces.secciones ADD (
    id_calendario NUMBER(3) NOT NULL
);

ALTER TABLE ces.secciones MODIFY (
    modalidad NUMBER(3)
        NOT NULL NOT DEFERRABLE ENABLE VALIDATE
);

delete horarios
where id_horario=17 and modalidad=2;

delete horarios
where id_horario=31 and modalidad=16;

delete from secciones_bak201907up where horario is null;
delete from secciones_bak201907up where (periodo,fec_inicio) not in (select periodo, fecha_ini from calendarios_detalle);
delete from secciones_bak201907up where id_metodo not in (select id_metodo from metodos);
delete from secciones_bak201907up where horario not in (select to_char(hora,'HH:MI PM')||'-'||to_char(hora_fin,'HH:MI PM') from horarios);
delete from secciones_bak201907up where (horario,modalidad) not in (select to_char(hora,'HH:MI PM')||'-'||to_char(hora_fin,'HH:MI PM'),modalidad from horarios);


insert into secciones select ID_SECCION,
	a.ID_METODO,
	NIVEL,
	ID_SALON,
	TOPE,
	STATUS,
	CANT_ACTUAL,
	ID_EDIF,
	HORARIO,
	CEDULA_PROF,
	a.MODALIDAD,
	FEC_INICIO,
	a.PERIODO
	,h.ID_HORARIO
    ,dc.id_calendario ID_CALENDARIO
    from secciones_bak201907up a, horarios h
    , calendarios_detalle dc
    , calendarios c, metodos m
    where a.horario = to_char(hora,'HH:MI PM')||'-'||to_char(hora_fin,'HH:MI PM')
    and h.modalidad=a.modalidad
    and dc.periodo = a.periodo and a.fec_inicio = dc.fecha_ini
    and a.modalidad=dc.modalidad
    and dc.id_calendario=c.id_calendario
    and c.id_calendario=m.id_calendario
    and a.id_metodo=m.id_metodo;
    

---- fin falla
ALTER TABLE ces.zonas MODIFY (
    id_zona NUMBER
);
ALTER VIEW ces.eventos_calendario DROP CONSTRAINT eventos_calendario_pk;

---- falla
update estudiante set sede = 'IV'
where sede is null;

delete ficha_pago where matricula in (select matricula from estudiante where sede not in (select codigo from companias));
delete ficha_academica where matricula in (select matricula from estudiante where sede not in (select codigo from companias));
delete estudiante where sede not in (select codigo from companias);

ALTER TABLE ces.estudiante
    ADD CONSTRAINT estudiante_companias_fk FOREIGN KEY ( sede )
        REFERENCES ces.companias ( codigo )
    NOT DEFERRABLE;
    
ALTER TABLE ces.estudiante
    ADD CONSTRAINT estudiante_estados_fk FOREIGN KEY ( estado )
        REFERENCES ces.estados ( id_estado )
    NOT DEFERRABLE;
ALTER TABLE ces.estudiante
    ADD CONSTRAINT estudiante_ciudades_fk FOREIGN KEY ( ciudad )
        REFERENCES ces.ciudades ( id_ciudad )
    NOT DEFERRABLE;
ALTER TABLE ces.estudiante
    ADD CONSTRAINT estudiante_zonas_fk FOREIGN KEY ( zona )
        REFERENCES ces.zonas ( id_zona )
    NOT DEFERRABLE;
    
    update estudiante set condicion_especial = null
    where condicion_especial in ('-',0,3,5);
    
    
ALTER TABLE ces.estudiante
    ADD CONSTRAINT estudiante_condiciones_especiales_fk FOREIGN KEY ( condicion_especial )
        REFERENCES ces.condiciones_especiales ( id_condicion )
    NOT DEFERRABLE;
    
    
ALTER TABLE ces.estudiante
    ADD CONSTRAINT estudiante_ocupaciones_fk FOREIGN KEY ( profesion )
        REFERENCES ces.ocupaciones ( id_ocupacion )
    NOT DEFERRABLE;
---- fin falla
ALTER TABLE inscripciones
    ADD CONSTRAINT inscripciones_estudiante_fk FOREIGN KEY ( est_matricula )
        REFERENCES ces.estudiante ( matricula )
    NOT DEFERRABLE;
ALTER TABLE inscripciones
    ADD CONSTRAINT inscripciones_secciones_fk FOREIGN KEY ( sec_id_seccion,
                                                            sec_id_metodo )
        REFERENCES ces.secciones ( id_seccion,
                                   id_metodo )
    NOT DEFERRABLE;
ALTER TABLE ces.salones
    ADD CONSTRAINT salones_edificios_fk FOREIGN KEY ( edificio )
        REFERENCES ces.edificios ( id_edif )
    NOT DEFERRABLE;
---- falla
ALTER TABLE ces.secciones
    ADD CONSTRAINT secciones_metodos_fk FOREIGN KEY ( id_metodo )
        REFERENCES ces.metodos ( id_metodo )
    NOT DEFERRABLE;
ALTER TABLE ces.secciones
    ADD CONSTRAINT secciones_salones_fk FOREIGN KEY ( id_salon,
                                                      id_edif )
        REFERENCES ces.salones ( id_salon,
                                 edificio )
    NOT DEFERRABLE;
---- fin falla
ALTER TABLE ces.secciones
    ADD CONSTRAINT secciones_modalidades_fk FOREIGN KEY ( modalidad )
        REFERENCES ces.modalidades ( id_modalidad )
    NOT DEFERRABLE;
---- falla 
ALTER TABLE ces.secciones
    ADD CONSTRAINT secciones_horarios_fk FOREIGN KEY ( id_horario,
                                                       modalidad )
        REFERENCES ces.horarios ( id_horario,
                                  modalidad )
    NOT DEFERRABLE;
    
    update secciones set cedula_prof = null
    where cedula_prof not in (select cedula_prof from profesor);
    
    
ALTER TABLE ces.secciones
    ADD CONSTRAINT secciones_profesor_fk FOREIGN KEY ( cedula_prof )
        REFERENCES ces.profesor ( cedula_prof )
    NOT DEFERRABLE;
    
ALTER TABLE ces.secciones
    ADD CONSTRAINT secciones_calendarios_detalle_fk FOREIGN KEY ( id_calendario )
        REFERENCES ces.calendarios_detalle ( id )
    NOT DEFERRABLE;
---- fin falla

ALTER TABLE ces.calendarios_detalle MODIFY (
    periodo_activo DEFAULT 'S'
);
ALTER TABLE ces.conceptos_tipo ADD (
    materiales_id NUMBER
);

ALTER TABLE ces.inscripciones ADD (
    secciones_id NUMBER NOT NULL
);


ALTER TABLE ces.materiales MODIFY (
    tipo VARCHAR2(3 BYTE)
        NOT NULL NOT DEFERRABLE ENABLE VALIDATE
);


ALTER TABLE ces.materiales DROP CONSTRAINT materiales_pk CASCADE;


ALTER TABLE ces.secciones MODIFY (
    id_calendario NUMBER
);


ALTER TABLE ces.secciones DROP CONSTRAINT secciones_pk CASCADE;

ALTER TABLE ces.materiales
    ADD CONSTRAINT materiales_tipo_material_fk FOREIGN KEY ( tipo )
        REFERENCES ces.tipo_material ( abrev )
    NOT DEFERRABLE;
    
    
-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                             1
-- CREATE INDEX                             0
-- CREATE VIEW                              0
-- ALTER TABLE                             40
-- ALTER INDEX                              0
-- ALTER VIEW                               1
-- DROP TABLE                               0
-- DROP INDEX                               0
-- DROP VIEW                                0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- DROP PACKAGE                             0
-- DROP PACKAGE BODY                        0
-- DROP PROCEDURE                           0
-- DROP FUNCTION                            0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- DROP TRIGGER                             0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- DROP TYPE                                0
-- CREATE SEQUENCE                          0
-- ALTER SEQUENCE                           0
-- DROP SEQUENCE                            0
-- CREATE MATERIALIZED VIEW                 0
-- DROP MATERIALIZED VIEW                   0
-- CREATE SYNONYM                           0
-- DROP SYNONYM                             0
-- CREATE DIMENSION                         0
-- DROP DIMENSION                           0
-- CREATE CONTEXT                           0
-- DROP CONTEXT                             0
-- CREATE DIRECTORY                         0
-- DROP DIRECTORY                           0

-- 
-- ERRORS                                   0
-- WARNINGS                                 0
