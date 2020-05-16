alter session set current_schema="HR";
-- Generado por Oracle SQL Developer Data Modeler 18.4.0.339.1532
--   en:        2019-04-14 15:11:00 VET
--   sitio:      Oracle Database 12cR2
--   tipo:      Oracle Database 12cR2



DROP TABLE gl_atributos CASCADE CONSTRAINTS;

DROP TABLE gl_categorias_datos CASCADE CONSTRAINTS;

DROP TABLE gl_doc_atributos CASCADE CONSTRAINTS;

DROP TABLE gl_documento CASCADE CONSTRAINTS;

DROP TABLE gl_estatus CASCADE CONSTRAINTS;

DROP TABLE gl_tablas_maestro CASCADE CONSTRAINTS;

DROP TABLE gl_tipos_atributos CASCADE CONSTRAINTS;

DROP TABLE gl_tipos_datos CASCADE CONSTRAINTS;

DROP TABLE gl_tipos_documentos CASCADE CONSTRAINTS;

CREATE TABLE gl_atributos (
    id                 NUMBER(10) NOT NULL,
    descripcion        VARCHAR2(255 BYTE) NOT NULL,
    tipo_atributo_id   NUMBER(10),
    tipo_dato_id       NUMBER(10),
    tabla_maestro_id   NUMBER(10),
    atributo_id_sup    NUMBER(10),
    longitud_dato      NUMBER(3) DEFAULT 0,
    usa_lista          CHAR(1) DEFAULT 'N' NOT NULL,
    longitud           NUMBER(10),
    precision          NUMBER(10),
    alias_atributo     VARCHAR2(30 BYTE)
)
LOGGING;

ALTER TABLE gl_atributos
    ADD CONSTRAINT entero_03_890575273 CHECK ( longitud_dato BETWEEN 0 AND 999 );

ALTER TABLE gl_atributos
    ADD CONSTRAINT si_no_172126867 CHECK ( usa_lista IN (
        'N',
        'S'
    ) );

ALTER TABLE gl_atributos
    ADD CONSTRAINT entero_10_1894158607 CHECK ( longitud BETWEEN 0 AND 9999999999 );

ALTER TABLE gl_atributos
    ADD CONSTRAINT entero_10_1569693921 CHECK ( precision BETWEEN 0 AND 9999999999 );

COMMENT ON TABLE gl_atributos IS
    'Atributos adicionales de Productos y Otras definiciones donde se necesite ampliar campos adicionales';

COMMENT ON COLUMN gl_atributos.id IS
    'identificador unico del atributo';

COMMENT ON COLUMN gl_atributos.descripcion IS
    'Descripcion del atributo';

COMMENT ON COLUMN gl_atributos.tipo_atributo_id IS
    'identificador unico del tipo de atributo';

COMMENT ON COLUMN gl_atributos.tipo_dato_id IS
    'identificador unico del tipo de dato';

COMMENT ON COLUMN gl_atributos.tabla_maestro_id IS
    'Identificador Unico de la Tabla Maestro';

COMMENT ON COLUMN gl_atributos.atributo_id_sup IS
    'identificador unico del atributo que contiene un atributo en general';

COMMENT ON COLUMN gl_atributos.longitud_dato IS
    'Longitud de datos del atributo';

COMMENT ON COLUMN gl_atributos.usa_lista IS
    'Si el campo utiliza una lista dependiente de otra tabla';

COMMENT ON COLUMN gl_atributos.longitud IS
    'Longitud del Atributo';

COMMENT ON COLUMN gl_atributos.precision IS
    'Presicion del Atributo en el Caso de los montos la cantidad de Decimales';

COMMENT ON COLUMN gl_atributos.alias_atributo IS
    'Alias de un Atributo si Aplica';

CREATE UNIQUE INDEX gl_atributos_pk ON
    gl_atributos (
        id
    ASC )
        LOGGING;

ALTER TABLE gl_atributos ADD CONSTRAINT gl_atributos_pk PRIMARY KEY ( id );

CREATE TABLE gl_categorias_datos (
    id            NUMBER(10) NOT NULL,
    descripcion   VARCHAR2(80 BYTE) NOT NULL
)
LOGGING;

COMMENT ON TABLE gl_categorias_datos IS
    'Categoria de los Datos
Ej. Estandar, Personalizados, Extendidos';

COMMENT ON COLUMN gl_categorias_datos.id IS
    'Identificador Unico de la Categoria del Dato';

COMMENT ON COLUMN gl_categorias_datos.descripcion IS
    'Descripcion de la Categoria del Dato';

CREATE UNIQUE INDEX gl_categorias_datos_pk ON
    gl_categorias_datos (
        id
    ASC )
        LOGGING;

ALTER TABLE gl_categorias_datos ADD CONSTRAINT gl_categorias_datos_pk PRIMARY KEY ( id );

CREATE TABLE gl_doc_atributos (
    id               NUMBER NOT NULL,
    atr_id           NUMBER(10) NOT NULL,
    doc_atr_id_sup   NUMBER,
    es_requerido     CHAR(1) DEFAULT 'S' NOT NULL,
    no_duplicados    CHAR(1) DEFAULT 'S' NOT NULL,
    valor            VARCHAR2(255 BYTE)
)
LOGGING;

ALTER TABLE gl_doc_atributos
    ADD CONSTRAINT si_no_1814721180 CHECK ( es_requerido IN (
        'N',
        'S'
    ) );

ALTER TABLE gl_doc_atributos
    ADD CONSTRAINT si_no_832269258 CHECK ( no_duplicados IN (
        'N',
        'S'
    ) );

COMMENT ON TABLE gl_doc_atributos IS
    'Contiene los campos que contiene un documento personalizado';

COMMENT ON COLUMN gl_doc_atributos.id IS
    'identificador unico de documento';

COMMENT ON COLUMN gl_doc_atributos.atr_id IS
    'identificador unico del atributo';

COMMENT ON COLUMN gl_doc_atributos.doc_atr_id_sup IS
    'identificador unico del atributo superior';

COMMENT ON COLUMN gl_doc_atributos.es_requerido IS
    'Si el Atributo es Requerido o No';

COMMENT ON COLUMN gl_doc_atributos.no_duplicados IS
    'Si el Atributo debe o no Aceptar Valores Duplicados';

COMMENT ON COLUMN gl_doc_atributos.valor IS
    'Valor del Atributo del Documento';

CREATE UNIQUE INDEX gl_doc_atributos_pk ON
    gl_doc_atributos (
        id
    ASC )
        LOGGING;

ALTER TABLE gl_doc_atributos ADD CONSTRAINT gl_doc_atributos_pk PRIMARY KEY ( id );

CREATE TABLE gl_documento (
    id               NUMBER NOT NULL,
    tipo_doc_id      NUMBER(10),
    estatus_id       NUMBER(10),
    fecha_creacion   DATE,
    meta_data        VARCHAR2(4000 BYTE)
)
LOGGING;

COMMENT ON TABLE gl_documento IS
    'Tabla que guarda todos los documentos';

COMMENT ON COLUMN gl_documento.id IS
    'identificador unico de documento';

COMMENT ON COLUMN gl_documento.tipo_doc_id IS
    'ID  que identifica un registro dentro de la tabla. Es autogenerado por una secuencia';

COMMENT ON COLUMN gl_documento.fecha_creacion IS
    'Fecha de Creacion de Documento';

COMMENT ON COLUMN gl_documento.meta_data IS
    'Meta data de un documento en formato JSON';

CREATE UNIQUE INDEX gl_documento_pk ON
    gl_documento (
        id
    ASC )
        LOGGING;

ALTER TABLE gl_documento ADD CONSTRAINT gl_documento_pk PRIMARY KEY ( id );

CREATE TABLE gl_estatus (
    id            NUMBER(10) NOT NULL,
    tipo_doc_id   NUMBER(10),
    nombre        VARCHAR2(80 BYTE) NOT NULL,
    descripcion   VARCHAR2(4000 BYTE) NOT NULL,
    activo        CHAR(1) DEFAULT 'S' NOT NULL
)
LOGGING;

ALTER TABLE gl_estatus
    ADD CONSTRAINT si_no_1212479709 CHECK ( activo IN (
        'N',
        'S'
    ) );

COMMENT ON TABLE gl_estatus IS
    'Guarda los estatus del sistema';

COMMENT ON COLUMN gl_estatus.tipo_doc_id IS
    'ID  que identifica un registro dentro de la tabla. Es autogenerado por una secuencia';

CREATE UNIQUE INDEX gl_estatus_pk ON
    gl_estatus (
        id
    ASC )
        LOGGING;

ALTER TABLE gl_estatus ADD CONSTRAINT gl_estatus_pk PRIMARY KEY ( id );

CREATE TABLE gl_tablas_maestro (
    id              NUMBER(10) NOT NULL,
    nombre_tabla    VARCHAR2(30 BYTE) NOT NULL,
    campo_muestra   VARCHAR2(30 BYTE) NOT NULL,
    campo_retorno   VARCHAR2(30 BYTE) NOT NULL
)
LOGGING;

COMMENT ON TABLE gl_tablas_maestro IS
    'Guarda las tablas maestro para los campos lista';

COMMENT ON COLUMN gl_tablas_maestro.id IS
    'Identificador Unico de la Tabla Maestro';

COMMENT ON COLUMN gl_tablas_maestro.nombre_tabla IS
    'Nombre de la Tabla Maestro';

COMMENT ON COLUMN gl_tablas_maestro.campo_muestra IS
    'Campo que debe mostrar la Lista de Valores';

COMMENT ON COLUMN gl_tablas_maestro.campo_retorno IS
    'Campo que contiene el Valor de Retorno de la Lista de Valores';

CREATE UNIQUE INDEX gl_tablas_maestro_pk ON
    gl_tablas_maestro (
        id
    ASC )
        LOGGING;

ALTER TABLE gl_tablas_maestro ADD CONSTRAINT gl_tablas_maestro_pk PRIMARY KEY ( id );

CREATE TABLE gl_tipos_atributos (
    id                  NUMBER(10) NOT NULL,
    des_tipo_atributo   VARCHAR2(80 BYTE) NOT NULL
)
LOGGING;

COMMENT ON TABLE gl_tipos_atributos IS
    'Tipos de Atributo de Informacion
Ej: Contenedor, que puede agrupar varios atributos, Ejemplo: Nombre contiene los atributos primer nombre, segundo nombre, primer apellido y segundo apellido, hasta apellido de casada'
    ;

COMMENT ON COLUMN gl_tipos_atributos.id IS
    'identificador unico del tipo de atributo';

COMMENT ON COLUMN gl_tipos_atributos.des_tipo_atributo IS
    'Descripcion del tipo de Atributo
Ej: 1. Comunes, 2. Individuales';

CREATE UNIQUE INDEX cp_tipos_atributos_pk ON
    gl_tipos_atributos (
        id
    ASC )
        LOGGING;

ALTER TABLE gl_tipos_atributos ADD CONSTRAINT cp_tipos_atributos_pk PRIMARY KEY ( id );

CREATE TABLE gl_tipos_datos (
    id              NUMBER(10) NOT NULL,
    cat_dato_id     NUMBER(10) NOT NULL,
    des_tipo_dato   VARCHAR2(50 BYTE) NOT NULL
)
LOGGING;

COMMENT ON TABLE gl_tipos_datos IS
    'Tipos de Dato
Ej. entero, monto, texto, email, fecha, area_texto, url, etc.';

COMMENT ON COLUMN gl_tipos_datos.id IS
    'identificador unico del tipo de dato';

COMMENT ON COLUMN gl_tipos_datos.des_tipo_dato IS
    'Descripcion del tipo de dato Ej. int, float,string,date';

CREATE UNIQUE INDEX cp_tipos_datos_pk ON
    gl_tipos_datos (
        id
    ASC )
        LOGGING;

ALTER TABLE gl_tipos_datos ADD CONSTRAINT gl_tipos_datos_pk PRIMARY KEY ( id );

CREATE TABLE gl_tipos_documentos (
    id                      NUMBER(10) NOT NULL,
    descripcion             VARCHAR2(240 BYTE) NOT NULL,
    abreviatura             VARCHAR2(3 BYTE),
    afecta_inventario_e_s   CHAR(1) DEFAULT 'S'
)
LOGGING;

COMMENT ON TABLE gl_tipos_documentos IS
    'Tabla utilizada para registrar los tipos de documentos existentes dentro del SIGAUC. Los estatus que pueden tener estos documentos son manejados a través de las tablas GL_ESTATUS y GL_ESTATUS_SECUENCIA'
    ;

COMMENT ON COLUMN gl_tipos_documentos.id IS
    'ID  que identifica un registro dentro de la tabla. ';

COMMENT ON COLUMN gl_tipos_documentos.descripcion IS
    'Descripcion del Tipo de Documento';

COMMENT ON COLUMN gl_tipos_documentos.afecta_inventario_e_s IS
    'Este Documento Afecta Inventario Entrada (E) o Salida (S)';

CREATE UNIQUE INDEX gl_tipos_documentos_pk ON
    gl_tipos_documentos (
        id
    ASC )
        LOGGING;

ALTER TABLE gl_tipos_documentos ADD CONSTRAINT gl_tipos_documentos_pk PRIMARY KEY ( id );

ALTER TABLE gl_atributos
    ADD CONSTRAINT atr_tp_dat_fk FOREIGN KEY ( tipo_dato_id )
        REFERENCES gl_tipos_datos ( id )
            ON DELETE SET NULL
    NOT DEFERRABLE;

ALTER TABLE gl_doc_atributos
    ADD CONSTRAINT doc_atr_atr_fk FOREIGN KEY ( atr_id )
        REFERENCES gl_atributos ( id )
    NOT DEFERRABLE;

ALTER TABLE gl_doc_atributos
    ADD CONSTRAINT doc_atr_doc_atr_fk FOREIGN KEY ( doc_atr_id_sup )
        REFERENCES gl_doc_atributos ( id )
            ON DELETE SET NULL
    NOT DEFERRABLE;

ALTER TABLE gl_doc_atributos
    ADD CONSTRAINT doc_atr_doc_fk FOREIGN KEY ( id )
        REFERENCES gl_documento ( id )
    NOT DEFERRABLE;

ALTER TABLE gl_documento
    ADD CONSTRAINT doc_tip_doc_fk FOREIGN KEY ( tipo_doc_id )
        REFERENCES gl_tipos_documentos ( id )
            ON DELETE SET NULL
    NOT DEFERRABLE;

ALTER TABLE gl_atributos
    ADD CONSTRAINT gl_atributos_fk1 FOREIGN KEY ( tipo_atributo_id )
        REFERENCES gl_tipos_atributos ( id )
            ON DELETE SET NULL
    NOT DEFERRABLE;

ALTER TABLE gl_atributos
    ADD CONSTRAINT gl_atributos_fk2 FOREIGN KEY ( tabla_maestro_id )
        REFERENCES gl_tablas_maestro ( id )
            ON DELETE SET NULL
    NOT DEFERRABLE;

ALTER TABLE gl_atributos
    ADD CONSTRAINT gl_atributos_gl_atributos_fk FOREIGN KEY ( atributo_id_sup )
        REFERENCES gl_atributos ( id )
            ON DELETE SET NULL
    NOT DEFERRABLE;

ALTER TABLE gl_documento
    ADD CONSTRAINT gl_documento_gl_estatus_fk FOREIGN KEY ( estatus_id )
        REFERENCES gl_estatus ( id )
            ON DELETE SET NULL
    NOT DEFERRABLE;

ALTER TABLE gl_estatus
    ADD CONSTRAINT st_tip_doc_fk FOREIGN KEY ( tipo_doc_id )
        REFERENCES gl_tipos_documentos ( id )
            ON DELETE SET NULL
    NOT DEFERRABLE;

ALTER TABLE gl_tipos_datos
    ADD CONSTRAINT tip_dat_cat_dat_fk FOREIGN KEY ( cat_dato_id )
        REFERENCES gl_categorias_datos ( id )
    NOT DEFERRABLE;

ALTER TABLE cp_clase_atributo
    ADD CONSTRAINT cp_clase_atributo_fk0 FOREIGN KEY ( atr_id )
        REFERENCES gl_atributos ( id )
    NOT DEFERRABLE;

ALTER TABLE cp_rc
    ADD CONSTRAINT cp_rc_fk0 FOREIGN KEY ( id )
        REFERENCES gl_documento ( id )
    NOT DEFERRABLE;

ALTER TABLE in_bien_atributo
    ADD CONSTRAINT in_bien_atributo_fk2 FOREIGN KEY ( id_atributo )
        REFERENCES gl_atributos ( id )
            ON DELETE SET NULL
    NOT DEFERRABLE;

ALTER TABLE in_garantia
    ADD CONSTRAINT in_garantia_fk1 FOREIGN KEY ( id_documento )
        REFERENCES gl_documento ( id )
            ON DELETE SET NULL
    NOT DEFERRABLE;

ALTER TABLE in_tipo_bien_atributos
    ADD CONSTRAINT in_tipo_bien_atributos_fk0 FOREIGN KEY ( id_atributo )
        REFERENCES gl_atributos ( id )
    NOT DEFERRABLE;

ALTER TABLE in_tipo_forma_atributos
    ADD CONSTRAINT in_tipo_forma_atributos_fk0 FOREIGN KEY ( id_atributo )
        REFERENCES gl_atributos ( id )
    NOT DEFERRABLE;

CREATE SEQUENCE attr_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER attr_id_trg BEFORE
    INSERT ON gl_atributos
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := attr_id_seq.nextval;
END;
/

CREATE SEQUENCE cat_dat_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER cat_dat_id_trg BEFORE
    INSERT ON gl_categorias_datos
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := cat_dat_id_seq.nextval;
END;
/

CREATE SEQUENCE doc_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER doc_id_trg BEFORE
    INSERT ON gl_documento
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := doc_id_seq.nextval;
END;
/

CREATE SEQUENCE st_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER st_id_trg BEFORE
    INSERT ON gl_estatus
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := st_id_seq.nextval;
END;
/

CREATE SEQUENCE gl_tablas_maestro_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER gl_tablas_maestro_id_trg BEFORE
    INSERT ON gl_tablas_maestro
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := gl_tablas_maestro_id_seq.nextval;
END;
/

CREATE SEQUENCE tp_atr_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER tp_atr_id_trg BEFORE
    INSERT ON gl_tipos_atributos
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := tp_atr_id_seq.nextval;
END;
/

CREATE SEQUENCE tp_dat_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER tp_dat_id_trg BEFORE
    INSERT ON gl_tipos_datos
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := tp_dat_id_seq.nextval;
END;
/

CREATE SEQUENCE tip_doc_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER tip_doc_id_trg BEFORE
    INSERT ON gl_tipos_documentos
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := tip_doc_id_seq.nextval;
END;
/

@../data/documentos/DOCUMENTOS.sql

-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                             9
-- CREATE INDEX                             9
-- ALTER TABLE                             33
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           8
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          8
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
