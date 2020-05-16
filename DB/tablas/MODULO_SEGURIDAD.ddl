-- Generado por Oracle SQL Developer Data Modeler 18.4.0.339.1532
--   en:        2019-04-10 21:51:20 VET
--   sitio:      Oracle Database 12cR2
--   tipo:      Oracle Database 12cR2



CREATE TABLE gl_personas (
    id           NUMBER NOT NULL,
    tp_per_id    CHAR(2)
        CONSTRAINT nnc_per_gl_tipos_personas_id NOT NULL,
    nombre       VARCHAR2(100 BYTE)
        CONSTRAINT nnc_per_nombre NOT NULL,
    instancias   VARCHAR2(255 BYTE)
)
LOGGING;

COMMENT ON TABLE gl_personas IS
    'Persona. Ej: 1 Esculapio C.A., J, 2 Jessy Divo N.';

COMMENT ON COLUMN gl_personas.id IS
    'Número de Identificación Interno de la Persona.';

COMMENT ON COLUMN gl_personas.nombre IS
    'Nombre Completo o Razón Social de la Persona.';

COMMENT ON COLUMN gl_personas.instancias IS
    'Nombres a que pertenece la Persona Ej. FAMILIAR, ESTUDIANTE, PROVEEDOR, ETC';

CREATE UNIQUE INDEX per_id_idx ON
    gl_personas (
        id
    ASC )
        LOGGING;

ALTER TABLE gl_personas ADD CONSTRAINT gl_personas_pk PRIMARY KEY ( id );

CREATE TABLE gl_tipos_personas (
    id            CHAR(2) NOT NULL,
    descripcion   VARCHAR2(50 BYTE) NOT NULL
)
LOGGING;

COMMENT ON TABLE gl_tipos_personas IS
    'Tipo de Persona. Ej: N Natural, J Juridica. Unidad Organiacional';

COMMENT ON COLUMN gl_tipos_personas.id IS
    'Código del Tipo de Persona, Ej: PN. PJ. UO.';

COMMENT ON COLUMN gl_tipos_personas.descripcion IS
    'Descripción del Tipo de Persona. Ej: Natural, Juridica. Unidad Organizacional';

CREATE UNIQUE INDEX gl_tipo_persona_pk ON
    gl_tipos_personas (
        id
    ASC )
        LOGGING;

ALTER TABLE gl_tipos_personas ADD CONSTRAINT gl_tipos_personas_pk PRIMARY KEY ( id );

CREATE TABLE gl_tipos_unidades_org (
    id            NUMBER NOT NULL,
    descripcion   VARCHAR2(100 BYTE) NOT NULL
)
LOGGING;

COMMENT ON TABLE gl_tipos_unidades_org IS
    'Tipos de Unidad Organizacional Ej: Direccion, Departamento,Seccion, Fundacion,';

COMMENT ON COLUMN gl_tipos_unidades_org.id IS
    'Identificador Unico del Tipo de Unidad Organizacional';

COMMENT ON COLUMN gl_tipos_unidades_org.descripcion IS
    'Descripción del TIpo de Unidad Organizacional';

CREATE UNIQUE INDEX pl_tipo_unidad_org_pk ON
    gl_tipos_unidades_org (
        id
    ASC )
        LOGGING;

ALTER TABLE gl_tipos_unidades_org ADD CONSTRAINT gl_tipos_unidades_org_pk PRIMARY KEY ( id );

CREATE TABLE gl_unidades_org (
    id               NUMBER NOT NULL,
    uni_org_per_id   NUMBER,
    tp_uni_org_id    NUMBER,
    descripcion      VARCHAR2(255 BYTE) NOT NULL
)
LOGGING;

COMMENT ON TABLE gl_unidades_org IS
    'Unidades Organizacionales';

COMMENT ON COLUMN gl_unidades_org.id IS
    'Número de Identificación Interno de la Persona.';

COMMENT ON COLUMN gl_unidades_org.uni_org_per_id IS
    'Número de Identificación Interno de la Persona.';

COMMENT ON COLUMN gl_unidades_org.tp_uni_org_id IS
    'Identificador Unico del Tipo de Unidad Organizacional';

COMMENT ON COLUMN gl_unidades_org.descripcion IS
    'Descripcion de la Unidad Organizacional';

CREATE UNIQUE INDEX pl_unidad_org_pk ON
    gl_unidades_org (
        id
    ASC )
        LOGGING;

ALTER TABLE gl_unidades_org ADD CONSTRAINT gl_unidades_org_pk PRIMARY KEY ( id );

CREATE TABLE sg_mensajes (
    id              NUMBER NOT NULL,
    tp_men_id       NUMBER,
    usu_id_para     NUMBER NOT NULL,
    usu_id_de       NUMBER NOT NULL,
    contenido_msg   VARCHAR2(4000 BYTE) NOT NULL,
    asunto_msg      VARCHAR2(80 BYTE) NOT NULL,
    fec_recepcion   DATE,
    nro_envio       NUMBER
)
LOGGING;

COMMENT ON TABLE sg_mensajes IS
    'repositorio de Alertas y mensajes de lo que ocurre en el sistema';

COMMENT ON COLUMN sg_mensajes.id IS
    'Identificador Unico del Mensaje';

COMMENT ON COLUMN sg_mensajes.tp_men_id IS
    'identificador unico del tipo de buzon';

COMMENT ON COLUMN sg_mensajes.usu_id_para IS
    'is del usuario que recibe';

COMMENT ON COLUMN sg_mensajes.usu_id_de IS
    'id del usuario que envia';

COMMENT ON COLUMN sg_mensajes.contenido_msg IS
    'Contenido del Envio';

COMMENT ON COLUMN sg_mensajes.asunto_msg IS
    'asunto del envio';

COMMENT ON COLUMN sg_mensajes.fec_recepcion IS
    'fecha de recepcion del mensaje';

COMMENT ON COLUMN sg_mensajes.nro_envio IS
    'numero del envio';

CREATE UNIQUE INDEX sg_mensajes_pk ON
    sg_mensajes (
        id
    ASC )
        LOGGING;

ALTER TABLE sg_mensajes ADD CONSTRAINT sg_mensajes_pk PRIMARY KEY ( id );

CREATE TABLE sg_opciones_menu (
    id                    NUMBER NOT NULL,
    op_men_id             NUMBER,
    descripcion           VARCHAR2(50 BYTE) NOT NULL,
    url                   VARCHAR2(240 BYTE) NOT NULL,
    "ORDEN DISPLAY"       NUMBER(6) NOT NULL,
    pagina_id             NUMBER(10) NOT NULL,
    "DESPLEGAR EN MENU"   CHAR(1) DEFAULT 'S' NOT NULL
)
LOGGING;

ALTER TABLE sg_opciones_menu
    ADD CONSTRAINT entero_06_588641392 CHECK ( "ORDEN DISPLAY" BETWEEN 0 AND 999999 );

ALTER TABLE sg_opciones_menu
    ADD CONSTRAINT entero_10_1317504989 CHECK ( pagina_id BETWEEN 0 AND 9999999999 );

ALTER TABLE sg_opciones_menu
    ADD CONSTRAINT si_no_1295777420 CHECK ( "DESPLEGAR EN MENU" IN (
        'N',
        'S'
    ) );

COMMENT ON TABLE sg_opciones_menu IS
    'Opciones del Menu de Cada Sistema';

COMMENT ON COLUMN sg_opciones_menu.id IS
    'identificador unico de opcion de menu';

COMMENT ON COLUMN sg_opciones_menu.op_men_id IS
    'identificador unico de opcion de menu';

COMMENT ON COLUMN sg_opciones_menu.descripcion IS
    'Descripcion de la opcion del menu';

COMMENT ON COLUMN sg_opciones_menu.url IS
    'direccion url de la opcion de menu';

COMMENT ON COLUMN sg_opciones_menu."ORDEN DISPLAY" IS
    'orden en que se desplegan las opciones del menu';

COMMENT ON COLUMN sg_opciones_menu.pagina_id IS
    'numero de pagina asociada a la opcion de menu en caso de APEX';

COMMENT ON COLUMN sg_opciones_menu."DESPLEGAR EN MENU" IS
    'esta opcion va a ser desplegada en el menu?';

CREATE UNIQUE INDEX sg_opcion_menu_pk ON
    sg_opciones_menu (
        id
    ASC )
        LOGGING;

ALTER TABLE sg_opciones_menu ADD CONSTRAINT sg_opciones_menu_pk PRIMARY KEY ( id );

CREATE TABLE sg_roles (
    id            NUMBER NOT NULL,
    descripcion   VARCHAR2(80 BYTE) NOT NULL
)
LOGGING;

COMMENT ON TABLE sg_roles IS
    'Rolesl de Usuarios del Sistema. Ej: SUPERUSUARIO Super Usuario del sistema';

COMMENT ON COLUMN sg_roles.id IS
    'Código del Perfil.';

COMMENT ON COLUMN sg_roles.descripcion IS
    'Descripción del Perfil.';

CREATE UNIQUE INDEX sg_rol_pk ON
    sg_roles (
        id
    ASC )
        LOGGING;

ALTER TABLE sg_roles ADD CONSTRAINT sg_roles_pk PRIMARY KEY ( id );

CREATE TABLE sg_roles_opciones_menu (
    op_men_id   NUMBER NOT NULL,
    rol_id      NUMBER NOT NULL
)
LOGGING;

COMMENT ON TABLE sg_roles_opciones_menu IS
    'Guarda el acceso que tienen los roles en las opciones del menu';

COMMENT ON COLUMN sg_roles_opciones_menu.op_men_id IS
    'identificador unico de opcion de menu';

COMMENT ON COLUMN sg_roles_opciones_menu.rol_id IS
    'Código del Perfil.';

CREATE UNIQUE INDEX sg_rol_opcion_menu_pk ON
    sg_roles_opciones_menu (
        op_men_id
    ASC,
        rol_id
    ASC )
        LOGGING;

ALTER TABLE sg_roles_opciones_menu ADD CONSTRAINT sg_roles_opciones_menu_pk PRIMARY KEY ( op_men_id,
                                                                                          rol_id );

CREATE TABLE sg_tipos_mensajes (
    id            NUMBER NOT NULL,
    descripcion   VARCHAR2(50 BYTE) NOT NULL
)
LOGGING;

COMMENT ON TABLE sg_tipos_mensajes IS
    'Tipo de Mensaje del usuario de sistema, Ej. Documentos, Alertas, etc';

COMMENT ON COLUMN sg_tipos_mensajes.id IS
    'identificador unico del tipo de buzon';

COMMENT ON COLUMN sg_tipos_mensajes.descripcion IS
    'descripcion del tipo de buzon';

CREATE UNIQUE INDEX sg_tipo_buzon_pk ON
    sg_tipos_mensajes (
        id
    ASC )
        LOGGING;

ALTER TABLE sg_tipos_mensajes ADD CONSTRAINT sg_tipos_mensajes_pk PRIMARY KEY ( id );

CREATE TABLE sg_usuarios (
    id                 NUMBER NOT NULL,
    login              VARCHAR2(30 BYTE) NOT NULL,
    clave              VARCHAR2(255 BYTE) NOT NULL,
    creado_el          DATE NOT NULL,
    expirado           CHAR(1) DEFAULT 'S' NOT NULL,
    bloqueado          CHAR(1) DEFAULT 'S' NOT NULL,
    fec_cambio_clave   DATE,
    fec_ult_entrada    DATE,
    activo             CHAR(1) DEFAULT 'S' NOT NULL
)
LOGGING;



ALTER TABLE SG_USUARIOS 
    ADD CONSTRAINT SI_NO_605223752 
    CHECK (EXPIRADO IN ('N', 'S')) 
;

ALTER TABLE SG_USUARIOS 
    ADD CONSTRAINT SI_NO_555097223 
    CHECK (BLOQUEADO IN ('N', 'S')) 
;
ALTER TABLE sg_usuarios ADD constraint fecha_1619296754 CHECK ( creado_el BETWEEN TO_DATE ( '01/01/1800','DD/MM/YYYY') and TO_DATE('31/12/2100','DD/MM/YYYY' ) ) 
;
ALTER TABLE SG_USUARIOS 
    ADD CONSTRAINT FECHA_791425479 
    CHECK (FEC_CAMBIO_CLAVE BETWEEN TO_DATE('01/01/1800','DD/MM/YYYY') and TO_DATE('31/12/2100','DD/MM/YYYY')) 
;

ALTER TABLE SG_USUARIOS 
    ADD CONSTRAINT FECHA_742397503 
    CHECK (FEC_ULT_ENTRADA BETWEEN TO_DATE('01/01/1800','DD/MM/YYYY') and TO_DATE('31/12/2100','DD/MM/YYYY'));

ALTER TABLE sg_usuarios
    ADD CONSTRAINT si_no_1211562213 CHECK ( activo IN (
        'N',
        'S'
    ) );

COMMENT ON TABLE sg_usuarios IS
    'Usuarios de los sistemas';

COMMENT ON COLUMN sg_usuarios.id IS
    'Número de Identificación Interno de la Persona.';

COMMENT ON COLUMN sg_usuarios.login IS
    'Cuenta de Conexíon del Usuario.';

COMMENT ON COLUMN sg_usuarios.clave IS
    'Contraseña del Usuario';

COMMENT ON COLUMN sg_usuarios.creado_el IS
    'Fecha de la Contraseña';

COMMENT ON COLUMN sg_usuarios.expirado IS
    'El usuario esta expirado?';

COMMENT ON COLUMN sg_usuarios.bloqueado IS
    'El usuario esta bloqueado?';

COMMENT ON COLUMN sg_usuarios.fec_cambio_clave IS
    'fecha cuando cambio la contraseña';

COMMENT ON COLUMN sg_usuarios.fec_ult_entrada IS
    'Fecha de la ultima vez que entro al sistema';

COMMENT ON COLUMN sg_usuarios.activo IS
    'Está Activo el Usuario?';

CREATE UNIQUE INDEX sg_usuario_pk ON
    sg_usuarios (
        id
    ASC )
        LOGGING;

ALTER TABLE sg_usuarios ADD CONSTRAINT sg_usuarios_pk PRIMARY KEY ( id );

CREATE TABLE sg_usuarios_roles (
    rol_id       NUMBER NOT NULL,
    usu_per_id   NUMBER NOT NULL
)
LOGGING;

COMMENT ON TABLE sg_usuarios_roles IS
    'Perfiles del Usuario. Ej: HVILLAQU TRAPLA';

COMMENT ON COLUMN sg_usuarios_roles.rol_id IS
    'Código del Perfil.';

COMMENT ON COLUMN sg_usuarios_roles.usu_per_id IS
    'Número de Identificación Interno de la Persona.';

CREATE UNIQUE INDEX sg_usuario_rol_pk ON
    sg_usuarios_roles (
        rol_id
    ASC,
        usu_per_id
    ASC )
        LOGGING;

ALTER TABLE sg_usuarios_roles ADD CONSTRAINT sg_usuarios_roles_pk PRIMARY KEY ( rol_id,
                                                                                usu_per_id );

CREATE TABLE sg_usuarios_unid_org (
    usu_per_id       NUMBER NOT NULL,
    uni_org_per_id   NUMBER NOT NULL
)
LOGGING;

ALTER TABLE sg_usuarios_unid_org
    ADD CONSTRAINT "ID}_1349203210" CHECK ( uni_org_per_id BETWEEN 1 AND 99999999 );

COMMENT ON TABLE sg_usuarios_unid_org IS
    'Dependencias con la que puede trabajar el usuario en el sistema. Ej: HVILLAQU Rectorado.';

COMMENT ON COLUMN sg_usuarios_unid_org.usu_per_id IS
    'Número de Identificación Interno de la Persona.';

COMMENT ON COLUMN sg_usuarios_unid_org.uni_org_per_id IS
    'Número de Identificación Interno de la Persona.';

CREATE UNIQUE INDEX sg_usuario_dependencia_pk ON
    sg_usuarios_unid_org (
        usu_per_id
    ASC,
        uni_org_per_id
    ASC )
        LOGGING;

ALTER TABLE sg_usuarios_unid_org ADD CONSTRAINT sg_usuarios_unid_org_pk PRIMARY KEY ( usu_per_id,
                                                                                      uni_org_per_id );

ALTER TABLE sg_mensajes
    ADD CONSTRAINT men_tp_men_fk FOREIGN KEY ( tp_men_id )
        REFERENCES sg_tipos_mensajes ( id )
            ON DELETE SET NULL
    NOT DEFERRABLE;

ALTER TABLE sg_mensajes
    ADD CONSTRAINT men_usu_fk FOREIGN KEY ( usu_id_para )
        REFERENCES sg_usuarios ( id )
    NOT DEFERRABLE;

ALTER TABLE sg_mensajes
    ADD CONSTRAINT men_usu_fkv1 FOREIGN KEY ( usu_id_de )
        REFERENCES sg_usuarios ( id )
    NOT DEFERRABLE;

ALTER TABLE sg_opciones_menu
    ADD CONSTRAINT op_men_op_men_fk FOREIGN KEY ( op_men_id )
        REFERENCES sg_opciones_menu ( id )
            ON DELETE SET NULL
    NOT DEFERRABLE;

ALTER TABLE gl_personas
    ADD CONSTRAINT per_tp_per_fk FOREIGN KEY ( tp_per_id )
        REFERENCES gl_tipos_personas ( id )
    NOT DEFERRABLE;

ALTER TABLE sg_roles_opciones_menu
    ADD CONSTRAINT rol_op_men_op_men_fk FOREIGN KEY ( op_men_id )
        REFERENCES sg_opciones_menu ( id )
    NOT DEFERRABLE;

ALTER TABLE sg_roles_opciones_menu
    ADD CONSTRAINT rol_op_men_rol_fk FOREIGN KEY ( rol_id )
        REFERENCES sg_roles ( id )
    NOT DEFERRABLE;

ALTER TABLE gl_unidades_org
    ADD CONSTRAINT uni_org_per_fk FOREIGN KEY ( id )
        REFERENCES gl_personas ( id )
    NOT DEFERRABLE;

ALTER TABLE gl_unidades_org
    ADD CONSTRAINT uni_org_tp_uni_org_fk FOREIGN KEY ( tp_uni_org_id )
        REFERENCES gl_tipos_unidades_org ( id )
            ON DELETE SET NULL
    NOT DEFERRABLE;

ALTER TABLE gl_unidades_org
    ADD CONSTRAINT uni_org_uni_org_fk FOREIGN KEY ( uni_org_per_id )
        REFERENCES gl_unidades_org ( id )
            ON DELETE SET NULL
    NOT DEFERRABLE;

ALTER TABLE sg_usuarios
    ADD CONSTRAINT usu_per_fk FOREIGN KEY ( id )
        REFERENCES gl_personas ( id )
    NOT DEFERRABLE;

ALTER TABLE sg_usuarios_roles
    ADD CONSTRAINT usu_rol_rol_fk FOREIGN KEY ( rol_id )
        REFERENCES sg_roles ( id )
    NOT DEFERRABLE;

ALTER TABLE sg_usuarios_roles
    ADD CONSTRAINT usu_rol_usu_fk FOREIGN KEY ( usu_per_id )
        REFERENCES sg_usuarios ( id )
    NOT DEFERRABLE;

ALTER TABLE sg_usuarios_unid_org
    ADD CONSTRAINT usu_uni_org_uni_org_fk FOREIGN KEY ( uni_org_per_id )
        REFERENCES gl_unidades_org ( id )
    NOT DEFERRABLE;

ALTER TABLE sg_usuarios_unid_org
    ADD CONSTRAINT usu_uni_org_usu_fk FOREIGN KEY ( usu_per_id )
        REFERENCES sg_usuarios ( id )
    NOT DEFERRABLE;



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            12
-- CREATE INDEX                            12
-- ALTER TABLE                             37
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
