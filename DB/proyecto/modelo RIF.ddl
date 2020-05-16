-- Generado por Oracle SQL Developer Data Modeler 19.4.0.350.1424
--   en:        2020-01-22 08:59:07 VET
--   sitio:      Oracle Database 12cR2
--   tipo:      Oracle Database 12cR2



CREATE TABLE gl_docidenti (
    id                NUMBER NOT NULL,
    tp_docid_id       NUMBER NOT NULL,
    per_id            NUMBER NOT NULL,
    identificacion    VARCHAR2(20 BYTE) NOT NULL,
    activo            CHAR(1) DEFAULT 'S' NOT NULL,
    "F VENCIMIENTO"   DATE NOT NULL,
    "VERIFICADO EL"   DATE NOT NULL,
    "VERIFICADO POR"  NUMBER
)
LOGGING;

ALTER TABLE gl_docidenti
    ADD CONSTRAINT si_no_2070896744 CHECK ( id IN (
        n,
        s
    ) );

ALTER TABLE gl_docidenti
    ADD CONSTRAINT si_no_218164223 CHECK ( activo IN (
        'N',
        'S'
    ) );

ALTER TABLE gl_docidenti
    ADD CONSTRAINT fecha_988613808 CHECK ( "F VENCIMIENTO" BETWEEN TO_DATE('01/01/1800', 'DD/MM/YYYY') AND TO_DATE('31/12/2100', 'DD/MM/YYYY') );

COMMENT ON TABLE gl_docidenti IS
    'Número o Código de Identificación. Ej:1 CP 1234.';

COMMENT ON COLUMN gl_docidenti.id IS
    'Número de Identificación Interno del Número o Código de Identificación.';

COMMENT ON COLUMN gl_docidenti.tp_docid_id IS
    ' Número de Identificación Interno del Tipo de Número o Código de Identificación.';

COMMENT ON COLUMN gl_docidenti.per_id IS
    'Persona a la que pertenece el Número o Código de Identificación. Número de Identificación Interno de la Persona.';

COMMENT ON COLUMN gl_docidenti.identificacion IS
    'Número o Código de Identificación. Ej: CP 1234.';

COMMENT ON COLUMN gl_docidenti.activo IS
    'Está Activo el Número o Código de Identificación?. Ej: S, N.';

COMMENT ON COLUMN gl_docidenti."F VENCIMIENTO" IS
    'Fecha de Vencimiento de la Identificación.';

COMMENT ON COLUMN gl_docidenti."VERIFICADO EL" IS
    'Fecha cuando se verifico el documento';

COMMENT ON COLUMN gl_docidenti."VERIFICADO POR" IS
    'Usuario quien verifico el documento de identificacion';

CREATE UNIQUE INDEX docienti_pk ON
    gl_docidenti (
        id
    ASC )
        LOGGING;

CREATE UNIQUE INDEX docidenti_ak1 ON
    gl_docidenti (
        tp_docid_id
    ASC,
        per_id
    ASC )
        LOGGING;

CREATE UNIQUE INDEX docidenti_ak2 ON
    gl_docidenti (
        tp_docid_id
    ASC,
        identificacion
    ASC )
        LOGGING;

ALTER TABLE gl_docidenti ADD CONSTRAINT gl_docidenti_pk PRIMARY KEY ( id );

ALTER TABLE gl_docidenti ADD CONSTRAINT tp_docid_id_ide_un UNIQUE ( tp_docid_id,
                                                                    identificacion );

ALTER TABLE gl_docidenti ADD CONSTRAINT tp_docid_id_per_un UNIQUE ( tp_docid_id,
                                                                    per_id );

CREATE TABLE gl_letras_rif (
    id           CHAR(1 CHAR) NOT NULL,
    tp_per_id    CHAR(2) NOT NULL,
    descripcion  VARCHAR2(20 BYTE) NOT NULL
)
LOGGING;

COMMENT ON TABLE gl_letras_rif IS
    'Letra del Registro de Información Fiscal. Ej: J Juridica, G Gobierno, V Venezolano, E Extranjero, P Pasaporte.';

COMMENT ON COLUMN gl_letras_rif.id IS
    'Letra del Registro de Información Fiscal. Ej: J, G, V, E, P';

COMMENT ON COLUMN gl_letras_rif.tp_per_id IS
    'Tipo de Persona de la Letra del Registro de Información Fiscal. Código del Tipo de Persona, Ej: N. J.';

COMMENT ON COLUMN gl_letras_rif.descripcion IS
    'Descripción de la Letra del Registro de Información Fiscal. Ej: Juridico, Gobierno, Venezolano, Extranjero, Pasaporte.';

CREATE UNIQUE INDEX letra_rif_pk ON
    gl_letras_rif (
        id
    ASC )
        LOGGING;

ALTER TABLE gl_letras_rif ADD CONSTRAINT gl_letras_rif_pk PRIMARY KEY ( id );

CREATE TABLE gl_rif (
    id           NUMBER(10) NOT NULL,
    per_id       NUMBER NOT NULL,
    tp_docid_id  NUMBER NOT NULL,
    let_rif_id   CHAR(1 CHAR) NOT NULL,
    numero       NUMBER(10) NOT NULL,
    digito       NUMBER(1),
    activo       CHAR(1 CHAR) NOT NULL
)
LOGGING;

ALTER TABLE gl_rif
    ADD CONSTRAINT "ENTERO_09}_743649518" CHECK ( numero BETWEEN 1 AND 999999999 );

ALTER TABLE gl_rif
    ADD CONSTRAINT "ENTERO_01}_878657258" CHECK ( digito BETWEEN 0 AND 9 );

ALTER TABLE gl_rif
    ADD CONSTRAINT si_no_1987291074 CHECK ( activo IN (
        'N',
        'S'
    ) );

COMMENT ON TABLE gl_rif IS
    'Número de Registro de Información Fiscal o Cédula de Identidad. Ej: G 20000025041 4, V 15165102 6.';

COMMENT ON COLUMN gl_rif.id IS
    'Número de Identificación Interno del Registro de Información Fiscal.';

COMMENT ON COLUMN gl_rif.per_id IS
    'Persona a quien pertenece el Número del Registro de Información Fiscal. Número de Identificación Interno de la Persona.';

COMMENT ON COLUMN gl_rif.tp_docid_id IS
    'Número de Identificación Interno del Tipo de Número o Código de Identificación.';

COMMENT ON COLUMN gl_rif.let_rif_id IS
    'Letra del Registro de Información Fiscal. Ej: J, G, V, E, P';

COMMENT ON COLUMN gl_rif.numero IS
    'Número del Registro de Información Fiscal.';

COMMENT ON COLUMN gl_rif.digito IS
    'Dígito de Verficación del Registro de Información Fiscal.';

COMMENT ON COLUMN gl_rif.activo IS
    'Registro de Informaión Fiscal Activo?. Ej: S, N.';

CREATE UNIQUE INDEX gl_rif_pk ON
    gl_rif (
        id
    ASC )
        LOGGING;

CREATE UNIQUE INDEX gl_rif_ak1 ON
    gl_rif (
        let_rif_id
    ASC,
        numero
    ASC )
        LOGGING;

ALTER TABLE gl_rif ADD CONSTRAINT gl_rif_pk PRIMARY KEY ( id );

ALTER TABLE gl_rif ADD CONSTRAINT let_rif_id_num_un UNIQUE ( let_rif_id,
                                                             numero );

CREATE TABLE gl_tipos_docidenti (
    id           NUMBER NOT NULL,
    descripcion  VARCHAR2(20 BYTE) NOT NULL
)
LOGGING;

COMMENT ON TABLE gl_tipos_docidenti IS
    'Tipo de Número o Código de Identificación. Ej: 1 Colegio de Contadores, 2 IMPRE.';

COMMENT ON COLUMN gl_tipos_docidenti.id IS
    'Número de Identificación Interno del Tipo de Número o Código de Identificación.';

COMMENT ON COLUMN gl_tipos_docidenti.descripcion IS
    'Descripción del Tipo de Número o Codigo de Identificación. Ej: Número del Colegio de Contadores. Número de Pasaporte.';

CREATE UNIQUE INDEX gl_tipo_identificacion_pk ON
    gl_tipos_docidenti (
        id
    ASC )
        LOGGING;

ALTER TABLE gl_tipos_docidenti ADD CONSTRAINT gl_tipos_docidenti_pk PRIMARY KEY ( id );

CREATE TABLE "GL LETRAS RIF TIPOS ID" (
    let_rif_id   CHAR(1 CHAR) NOT NULL,
    tp_docid_id  NUMBER NOT NULL
)
LOGGING;

ALTER TABLE "GL LETRAS RIF TIPOS ID"
    ADD CONSTRAINT "ID}_407704439" CHECK ( tp_docid_id BETWEEN 1 AND 99999999 );

COMMENT ON TABLE "GL LETRAS RIF TIPOS ID" IS
    'Relacion entre las letras del rif y los tipos de identificacion';

COMMENT ON COLUMN "GL LETRAS RIF TIPOS ID".let_rif_id IS
    'Letra del Registro de Información Fiscal. Ej: J, G, V, E, P ';

COMMENT ON COLUMN "GL LETRAS RIF TIPOS ID".tp_docid_id IS
    'Número de Identificación Interno del Tipo de Número o Código de Identificación.';

CREATE UNIQUE INDEX let_rif_tipo_id_pk ON
    "GL LETRAS RIF TIPOS ID" (
        let_rif_id
    ASC,
        tp_docid_id
    ASC )
        LOGGING;

ALTER TABLE "GL LETRAS RIF TIPOS ID" ADD CONSTRAINT let_rif_tp_id_pk PRIMARY KEY ( let_rif_id,
                                                                                   tp_docid_id );

ALTER TABLE gl_docidenti
    ADD CONSTRAINT docid_per_fk FOREIGN KEY ( per_id )
        REFERENCES gl_personas ( id )
    NOT DEFERRABLE;

ALTER TABLE gl_docidenti
    ADD CONSTRAINT docid_tp_docid_fk FOREIGN KEY ( tp_docid_id )
        REFERENCES gl_tipos_docidenti ( id )
    NOT DEFERRABLE;

ALTER TABLE gl_letras_rif
    ADD CONSTRAINT let_rif_tp_per_fk FOREIGN KEY ( tp_per_id )
        REFERENCES gl_tipos_personas ( id )
    NOT DEFERRABLE;

ALTER TABLE "GL LETRAS RIF TIPOS ID"
    ADD CONSTRAINT lrif_tid_lrif_fk FOREIGN KEY ( let_rif_id )
        REFERENCES gl_letras_rif ( id )
    NOT DEFERRABLE;

ALTER TABLE "GL LETRAS RIF TIPOS ID"
    ADD CONSTRAINT lrif_tid_tpdocid_fk FOREIGN KEY ( tp_docid_id )
        REFERENCES gl_tipos_docidenti ( id )
    NOT DEFERRABLE;

ALTER TABLE gl_rif
    ADD CONSTRAINT rif_let_rif_fk FOREIGN KEY ( let_rif_id )
        REFERENCES gl_letras_rif ( id )
    NOT DEFERRABLE;

ALTER TABLE gl_rif
    ADD CONSTRAINT rif_per_fk FOREIGN KEY ( per_id )
        REFERENCES gl_personas ( id )
    NOT DEFERRABLE;

ALTER TABLE gl_rif
    ADD CONSTRAINT rif_tp_docid_fk FOREIGN KEY ( tp_docid_id )
        REFERENCES gl_tipos_docidenti ( id )
    NOT DEFERRABLE;



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                             5
-- CREATE INDEX                             8
-- ALTER TABLE                             23
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
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
-- CREATE SEQUENCE                          0
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
