-- Generado por Oracle SQL Developer Data Modeler 18.4.0.339.1532
--   en:        2019-07-04 14:57:52 VET
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



DROP TABLE gl_area_telefonica CASCADE CONSTRAINTS;

DROP TABLE gl_ciudades CASCADE CONSTRAINTS;

DROP TABLE gl_continente CASCADE CONSTRAINTS;

DROP TABLE gl_direcciones CASCADE CONSTRAINTS;

DROP TABLE gl_estados CASCADE CONSTRAINTS;

DROP TABLE gl_moneda CASCADE CONSTRAINTS;

DROP TABLE gl_municipios CASCADE CONSTRAINTS;

DROP TABLE gl_paises CASCADE CONSTRAINTS;

DROP TABLE gl_parroquias CASCADE CONSTRAINTS;

DROP TABLE gl_tasa_cambio CASCADE CONSTRAINTS;

DROP TABLE gl_telefonos CASCADE CONSTRAINTS;

DROP TABLE gl_tipo_local CASCADE CONSTRAINTS;

DROP TABLE gl_tipos_direcciones CASCADE CONSTRAINTS;

DROP TABLE gl_tipos_edificaciones CASCADE CONSTRAINTS;

DROP TABLE gl_tipos_telefonos CASCADE CONSTRAINTS;

DROP TABLE gl_tipos_vias CASCADE CONSTRAINTS;

DROP TABLE gl_tipos_zonas CASCADE CONSTRAINTS;

DROP TABLE gl_urbanizaciones CASCADE CONSTRAINTS;

DROP TABLE gl_zonas_postales CASCADE CONSTRAINTS;

CREATE TABLE gl_area_telefonica (
    id            NUMBER
        CONSTRAINT nnc_gl_area_telefonica_id NOT NULL,
    pai_id        CHAR(2),
    codigo        NUMBER(6)
        CONSTRAINT nnc_gl_are_telef_cod NOT NULL,
    descripcion   VARCHAR2(50 BYTE)
        CONSTRAINT nnc_are_tel_des NOT NULL,
    area_movil    VARCHAR2(1 CHAR)
        CONSTRAINT nnc_are_tel_are_movil NOT NULL
);

ALTER TABLE gl_area_telefonica
    ADD CONSTRAINT entero_06_1719424533 CHECK ( codigo BETWEEN 0 AND 999999 );

ALTER TABLE gl_area_telefonica
    ADD CONSTRAINT si_no_1532367099 CHECK ( area_movil IN (
        'N',
        'S'
    ) );

COMMENT ON TABLE gl_area_telefonica IS
    'Código de Area Teléfonica. Ej: 1 VE 241 Valencia';

COMMENT ON COLUMN gl_area_telefonica.id IS
    'Número de Identificación Interno del Código de Area Teléfonica.';

COMMENT ON COLUMN gl_area_telefonica.pai_id IS
    'Código del País. Ej: VE, US.';

COMMENT ON COLUMN gl_area_telefonica.codigo IS
    'Código de Area Teléfonica. Ej: 241, 416';

COMMENT ON COLUMN gl_area_telefonica.descripcion IS
    'Descripción de Código de Area Teléfonica. Ej: Valencia, Movilnet.';

CREATE UNIQUE INDEX gl_area_telefonica_id_idx ON
    gl_area_telefonica (
        id
    ASC );

CREATE UNIQUE INDEX area_tel_cod_pai_id_idx ON
    gl_area_telefonica (
        codigo
    ASC,
        pai_id
    ASC );

ALTER TABLE gl_area_telefonica ADD CONSTRAINT area_telef_pk PRIMARY KEY ( id );

ALTER TABLE gl_area_telefonica ADD CONSTRAINT area_telef_codigo_pai_id_un UNIQUE ( codigo,
                                                                                   pai_id );

CREATE TABLE gl_ciudades (
    id              NUMBER
        CONSTRAINT nnc_ciu_id NOT NULL,
    est_id          NUMBER
        CONSTRAINT nnc_ciu_est_id NOT NULL,
    mun_id          NUMBER,
    nombre          VARCHAR2(50 BYTE)
        CONSTRAINT nnc_ciu_nombre NOT NULL,
    "COD SUDEBIP"   VARCHAR2(12 BYTE),
    area_telef_id   NUMBER
);

ALTER TABLE gl_ciudades
    ADD CONSTRAINT ck_ciud_id CHECK ( id BETWEEN 1 AND 99999999 );

ALTER TABLE gl_ciudades
    ADD CONSTRAINT ck_ciu_est_id CHECK ( est_id BETWEEN 1 AND 99999999 );

ALTER TABLE gl_ciudades
    ADD CONSTRAINT ck_ciu_mun_id CHECK ( mun_id BETWEEN 1 AND 99999999 );

COMMENT ON TABLE gl_ciudades IS
    'Ciudad, Población, Caserio, etc. Ej: 1 Valencia, Carabobo.';

COMMENT ON COLUMN gl_ciudades.id IS
    'Número de Identificación Interno de la Ciudad Población o Caserio.';

COMMENT ON COLUMN gl_ciudades.est_id IS
    'Estado de la Ciudad. Número de Identificación Interno del Estado, Departamento o Provincia.';

COMMENT ON COLUMN gl_ciudades.mun_id IS
    'Número de Identificación Interna del Municipio.';

COMMENT ON COLUMN gl_ciudades.nombre IS
    'Nombre de la Ciudad, Población o Caserio. Ej: Valencia.';

COMMENT ON COLUMN gl_ciudades."COD SUDEBIP" IS
    'Codigo de Ciudad Sugerido por la SUDEBIP';

CREATE UNIQUE INDEX ciu_id_idx ON
    gl_ciudades (
        id
    ASC );

ALTER TABLE gl_ciudades ADD CONSTRAINT gl_ciudades_pk PRIMARY KEY ( id );

CREATE TABLE gl_continente (
    id       NUMBER
        CONSTRAINT nnc_gl_continente_id NOT NULL,
    nombre   VARCHAR2(50 BYTE)
        CONSTRAINT nnc_gl_continente_nombre NOT NULL
);

COMMENT ON TABLE gl_continente IS
    'Continente. Ej 1 America.';

COMMENT ON COLUMN gl_continente.id IS
    'Número de Identificación interna del Continente.';

COMMENT ON COLUMN gl_continente.nombre IS
    'Nombre del Continente. Ej: America, Europa.';

CREATE UNIQUE INDEX gl_continente_id_idx ON
    gl_continente (
        id
    ASC );

ALTER TABLE gl_continente ADD CONSTRAINT gl_continente_pk PRIMARY KEY ( id );

CREATE TABLE gl_direcciones (
    id            NUMBER
        CONSTRAINT nnc_dir_id NOT NULL,
    per_id        NUMBER,
    tp_dir_id     NUMBER
        CONSTRAINT nnc_dir_tp_dir_id NOT NULL,
    tp_zon_id     NUMBER
        CONSTRAINT nnc_dir_tp_zon_id NOT NULL,
    urb_id        NUMBER
        CONSTRAINT nnc_dir_urb_id NOT NULL,
    tp_via_id     NUMBER,
    via           VARCHAR2(50 BYTE),
    tp_edif_id    NUMBER,
    edificacion   VARCHAR2(50 BYTE),
    num_edif      VARCHAR2(20 BYTE),
    piso_edif     VARCHAR2(20 BYTE),
    apartamento   VARCHAR2(20 BYTE),
    referencia    VARCHAR2(50 BYTE),
    tp_local_id   NUMBER,
    ciu_id        NUMBER,
    mun_id        NUMBER,
    parr_id       NUMBER,
    zon_pos_id    NUMBER,
    activa        CHAR(1 CHAR) DEFAULT 'S'
        CONSTRAINT nnc_dir_activa NOT NULL
);

ALTER TABLE gl_direcciones
    ADD CONSTRAINT ck_dir_activa CHECK ( activa IN (
        'N',
        'S'
    ) );

COMMENT ON TABLE gl_direcciones IS
    'Dirección. Ej: 1 Avenidad Bolivar, Edficio Poliven, Piso 8, Oficina 4, Camoruco, San José, Valencia. Edo Carabobo';

COMMENT ON COLUMN gl_direcciones.id IS
    'Número de Identificación Interno de la Dirección.';

COMMENT ON COLUMN gl_direcciones.per_id IS
    'Número de Identificación Interno de la Persona.';

COMMENT ON COLUMN gl_direcciones.tp_dir_id IS
    'Tipo de Dirección. Número de Identificación Interno del Tipo de Dirección.';

COMMENT ON COLUMN gl_direcciones.tp_zon_id IS
    'id del tipo de la zona';

COMMENT ON COLUMN gl_direcciones.urb_id IS
    'Urbanización o Barrio de la Dirección. Número de Identificación Interna de la Urbanización o Barrio.';

COMMENT ON COLUMN gl_direcciones.tp_via_id IS
    'Tipo de Via de la Dirección. Número de Identificación Interno del Tipo de Via. eJ Avenida, Calle';

COMMENT ON COLUMN gl_direcciones.via IS
    'Via de la Dirección: Ej: Avenida Bolivar. Calle 197';

COMMENT ON COLUMN gl_direcciones.tp_edif_id IS
    'Tipo de Edificación de la Dirección. Número de Identificación Interna del Tipo de Edificación.Ej Edificio, Casa';

COMMENT ON COLUMN gl_direcciones.edificacion IS
    'Edficación de la Dirección. Ej: Edificio La Estrella';

COMMENT ON COLUMN gl_direcciones.num_edif IS
    'Número de la Edificación de la Dirección. Ej: 120-34';

COMMENT ON COLUMN gl_direcciones.piso_edif IS
    'Número de Piso de la Edificación. Ej: Piso 8.';

COMMENT ON COLUMN gl_direcciones.apartamento IS
    'Numero de Apartamento de la Dirección. Ej: Apertamento 8H.';

COMMENT ON COLUMN gl_direcciones.referencia IS
    'Referencias de la Dirección. Ej: Al lado de Supermercado XYZ.';

COMMENT ON COLUMN gl_direcciones.tp_local_id IS
    'Identificador Unico del Tipo de Local';

COMMENT ON COLUMN gl_direcciones.ciu_id IS
    'Ciudad, Población o Caserio de la Dirección. Número de Identificación Interno de la Ciudad Población o Caserio.';

COMMENT ON COLUMN gl_direcciones.mun_id IS
    'Número de Identificación Interna del Municipio.';

COMMENT ON COLUMN gl_direcciones.parr_id IS
    'Parroquia de la Dirección. Número de Identificación Interna de la Parroquia.';

COMMENT ON COLUMN gl_direcciones.zon_pos_id IS
    'Número de Identificación Interno de la Zona Postal';

COMMENT ON COLUMN gl_direcciones.activa IS
    'Está activa la Dirección?. Ej: S,N.';

CREATE UNIQUE INDEX dir_id_idx ON
    gl_direcciones (
        id
    ASC );

ALTER TABLE gl_direcciones ADD CONSTRAINT gl_direcciones_pk PRIMARY KEY ( id );

CREATE TABLE gl_estados (
    id       NUMBER
        CONSTRAINT nnc_est_id NOT NULL,
    pai_id   CHAR(2),
    nombre   VARCHAR2(50 BYTE)
        CONSTRAINT nnc_est_nombre NOT NULL
);

ALTER TABLE gl_estados
    ADD CONSTRAINT ck_est_id CHECK ( id BETWEEN 1 AND 99999999 );

COMMENT ON TABLE gl_estados IS
    'Estado, Departamento, Provincial, etc. Ej: 1 Carabobo.';

COMMENT ON COLUMN gl_estados.id IS
    'Número de Identificación Interno del Estado, Departamento o Provincia.';

COMMENT ON COLUMN gl_estados.pai_id IS
    'Código del País. Ej: VE, US.';

COMMENT ON COLUMN gl_estados.nombre IS
    'Nombre del Estado, Departamento o Provincia. Ej: Carabobo.';

CREATE UNIQUE INDEX est_id_idx ON
    gl_estados (
        id
    ASC );

ALTER TABLE gl_estados ADD CONSTRAINT gl_estados_pk PRIMARY KEY ( id );

CREATE TABLE gl_moneda (
    id             NUMBER
        CONSTRAINT nnc_gl_moneda_id NOT NULL,
    denominacion   VARCHAR2(80 BYTE)
        CONSTRAINT nnc_gl_moneda_denominacion NOT NULL,
    codigo         VARCHAR2(3 BYTE)
        CONSTRAINT nnc_gl_moneda_codigo NOT NULL,
    simbolo        VARCHAR2(5 BYTE)
);

ALTER TABLE gl_moneda
    ADD CONSTRAINT id_moneda CHECK ( id BETWEEN 1 AND 99999999 );

COMMENT ON TABLE gl_moneda IS
    'Moneda. Ej: USD Dolar Americano.';

COMMENT ON COLUMN gl_moneda.id IS
    'Número de Identificación Interna de la Moneda.';

COMMENT ON COLUMN gl_moneda.denominacion IS
    'Denominación de la Moneda. Ej: Bolivares Fuertes Dolar Americano.';

COMMENT ON COLUMN gl_moneda.codigo IS
    'Código de la Moneda. Ej: VEF';

COMMENT ON COLUMN gl_moneda.simbolo IS
    'Simbolo de la Moneda. Ej: Bs.F';

CREATE UNIQUE INDEX gl_moneda_id_idx ON
    gl_moneda (
        id
    ASC );

ALTER TABLE gl_moneda ADD CONSTRAINT gl_moneda_pk PRIMARY KEY ( id );

CREATE TABLE gl_municipios (
    id              NUMBER
        CONSTRAINT nnc_mun_id NOT NULL,
    est_id          NUMBER
        CONSTRAINT nnc_mun_est_id NOT NULL,
    nombre          VARCHAR2(50 BYTE)
        CONSTRAINT nnc_mun_nombre NOT NULL,
    "COD SUDEBIP"   VARCHAR2(12 BYTE)
);

ALTER TABLE gl_municipios
    ADD CONSTRAINT ck_mun_id CHECK ( id BETWEEN 1 AND 99999999 );

ALTER TABLE gl_municipios
    ADD CONSTRAINT ck_mun_gl_estados_id CHECK ( est_id BETWEEN 1 AND 99999999 );

COMMENT ON TABLE gl_municipios IS
    'Municipio, Canton, Condado, etc. Ej: Naguanagua.';

COMMENT ON COLUMN gl_municipios.id IS
    'Número de Identificación Interna del Municipio.';

COMMENT ON COLUMN gl_municipios.est_id IS
    'Estado del Municipio. Número de Identificación Interno del Estado, Departamento o Provincia.';

COMMENT ON COLUMN gl_municipios.nombre IS
    'Nombre del Municipio. Ej: San José';

COMMENT ON COLUMN gl_municipios."COD SUDEBIP" IS
    'Codigo de Municipio Sugerido por la SUDEBIP';

CREATE UNIQUE INDEX mun_id_idx ON
    gl_municipios (
        id
    ASC );

ALTER TABLE gl_municipios ADD CONSTRAINT gl_municipios_pk PRIMARY KEY ( id );

CREATE TABLE gl_paises (
    id              CHAR(2)
        CONSTRAINT nnc_pai_id NOT NULL,
    moneda_id       NUMBER,
    contnente_id    NUMBER,
    nombre          VARCHAR2(100 BYTE)
        CONSTRAINT nnc_pai_nombre NOT NULL,
    "COD SUDEBIP"   VARCHAR2(5 BYTE)
        CONSTRAINT "NNC_PAI_COD SUDEBIP" NOT NULL,
    discado_inter   NUMBER(6),
    nacionalidad    VARCHAR2(50 BYTE)
);

ALTER TABLE gl_paises
    ADD CONSTRAINT ck_mon_id CHECK ( moneda_id BETWEEN 1 AND 99999999 );

ALTER TABLE gl_paises
    ADD CONSTRAINT ck_conti_id CHECK ( contnente_id BETWEEN 1 AND 99999999 );

ALTER TABLE gl_paises
    ADD CONSTRAINT entero_03_1392340439 CHECK ( discado_inter BETWEEN 0 AND 999 );

COMMENT ON TABLE gl_paises IS
    'Pais. Ej: VE Venezuela';

COMMENT ON COLUMN gl_paises.id IS
    'Código del País. Ej: VE, US.';

COMMENT ON COLUMN gl_paises.moneda_id IS
    'Moneda del País. Número de Identificación Interna de la Moneda.';

COMMENT ON COLUMN gl_paises.contnente_id IS
    'Número de Identificación interna del Continente.';

COMMENT ON COLUMN gl_paises.nombre IS
    'Nombre del País. Venezuela. Estados Unidos.';

COMMENT ON COLUMN gl_paises."COD SUDEBIP" IS
    'Codigo del Sistema de Inventario SUDEBIP';

COMMENT ON COLUMN gl_paises.discado_inter IS
    'Número de Discado Internacional del País. Ej: 58, 1';

CREATE UNIQUE INDEX pai_id_idx ON
    gl_paises (
        id
    ASC );

ALTER TABLE gl_paises ADD CONSTRAINT gl_paises_pk PRIMARY KEY ( id );

CREATE TABLE gl_parroquias (
    id              NUMBER
        CONSTRAINT nnc_parr_id NOT NULL,
    mun_id          NUMBER
        CONSTRAINT nnc_parr_mun_id NOT NULL,
    nombre          VARCHAR2(50 BYTE)
        CONSTRAINT nnc_parr_nombre NOT NULL,
    "COD SUDEBIP"   VARCHAR2(12 BYTE)
);

ALTER TABLE gl_parroquias
    ADD CONSTRAINT ck_parr_id CHECK ( id BETWEEN 1 AND 99999999 );

ALTER TABLE gl_parroquias
    ADD CONSTRAINT ck_parr_gl_municipios_id CHECK ( mun_id BETWEEN 1 AND 99999999 );

COMMENT ON TABLE gl_parroquias IS
    'Parroquia. Ej: 1 San José.';

COMMENT ON COLUMN gl_parroquias.id IS
    'Número de Identificación Interna de la Parroquia.';

COMMENT ON COLUMN gl_parroquias.mun_id IS
    'Municipio de la Parroquia. Número de Identificación Interna del Municipio.';

COMMENT ON COLUMN gl_parroquias.nombre IS
    'Nombre de la Parroquia.';

COMMENT ON COLUMN gl_parroquias."COD SUDEBIP" IS
    'Codigo de Parroquia Sugerido por la SUDEBIP';

CREATE UNIQUE INDEX parr_id_idx ON
    gl_parroquias (
        id
    ASC );

ALTER TABLE gl_parroquias ADD CONSTRAINT gl_parroquias_pk PRIMARY KEY ( id );

CREATE TABLE gl_tasa_cambio (
    id             NUMBER
        CONSTRAINT nnc_gl_tasa_cambio_id NOT NULL,
    moneda_id2     NUMBER
        CONSTRAINT nnc_tas_cam_cmon_id NOT NULL,
    moneda_id      NUMBER
        CONSTRAINT nnc_tas_cam_mon_id NOT NULL,
    tasa_cambio    NUMBER(14, 8) DEFAULT 0
        CONSTRAINT nnc_gl_tasa_cambio_tasa_cambio NOT NULL,
    fecha_inicio   DATE
        CONSTRAINT nnc_gl_tas_cam_fec_ini NOT NULL,
    fecha_fin      DATE
);

ALTER TABLE gl_tasa_cambio
    ADD CONSTRAINT ck_tas_cam_id CHECK ( id BETWEEN 1 AND 99999999 );

ALTER TABLE gl_tasa_cambio
    ADD CONSTRAINT ck_tc_cmon_id CHECK ( moneda_id2 BETWEEN 1 AND 99999999 );

ALTER TABLE gl_tasa_cambio
    ADD CONSTRAINT ck_tc_mon_id CHECK ( moneda_id BETWEEN 1 AND 99999999 );

ALTER TABLE gl_tasa_cambio
    ADD CONSTRAINT tasa_cambio_187570076 CHECK ( tasa_cambio BETWEEN 0 AND 999999.99999999 );

ALTER TABLE gl_tasa_cambio
    ADD CONSTRAINT fecha_1857980128 CHECK ( fecha_inicio BETWEEN TO_DATE('01/01/1800', 'DD/MM/YYYY') AND TO_DATE('31/12/2010', 'DD/MM/YYYY'
    ) );

ALTER TABLE gl_tasa_cambio
    ADD CONSTRAINT fecha_345346 CHECK ( fecha_fin BETWEEN TO_DATE('01/01/1800', 'DD/MM/YYYY') AND TO_DATE('31/12/2100', 'DD/MM/YYYY'
    ) );

COMMENT ON TABLE gl_tasa_cambio IS
    'Tasa de Cambio. Ej: BSF, BS, 1000.00000000';

COMMENT ON COLUMN gl_tasa_cambio.id IS
    'Número interno de Identificación de la Tasa de Cambio.';

COMMENT ON COLUMN gl_tasa_cambio.moneda_id2 IS
    'Moneda Base de la Tasa de Cambio. Número de Identificación Interna de la Moneda.';

COMMENT ON COLUMN gl_tasa_cambio.moneda_id IS
    'Moneda de Cambio de la Tasa de Cambio. Número de Identificación Interna de la Moneda.';

COMMENT ON COLUMN gl_tasa_cambio.tasa_cambio IS
    'Tasa de cambio. Valor por el que se debe Multiplicar la Moneda Base para obtener la Monde de Cambio.';

COMMENT ON COLUMN gl_tasa_cambio.fecha_inicio IS
    'Fecha de Inicio de Vigencia de la Tasa de Cambio.';

COMMENT ON COLUMN gl_tasa_cambio.fecha_fin IS
    'Fecha de Fin de la Vigencia de laTasa de Cambio.';

CREATE UNIQUE INDEX gl_tasa_cambio_id_idx ON
    gl_tasa_cambio (
        id
    ASC );

CREATE UNIQUE INDEX tasa_cam_fec_ini_idx ON
    gl_tasa_cambio (
        fecha_inicio
    ASC );

ALTER TABLE gl_tasa_cambio ADD CONSTRAINT gl_tasa_cambio_pk PRIMARY KEY ( id );

ALTER TABLE gl_tasa_cambio ADD CONSTRAINT gl_tasa_cambio_fecha_inicio_un UNIQUE ( fecha_inicio );

CREATE TABLE gl_telefonos (
    id               NUMBER
        CONSTRAINT nnc_tlf_id NOT NULL,
    tp_telef_id      NUMBER
        CONSTRAINT nnc_tlf_gl_tipos_telefonos_id NOT NULL,
    area_telef_id    NUMBER,
    per_id           NUMBER,
    num_telef        VARCHAR2(20 BYTE)
        CONSTRAINT "NNC_TLF_NUM TELEF" NOT NULL,
    activo_telef     CHAR(1 CHAR)
        CONSTRAINT "NNC_TLF_ACTIVO TELEFONO" NOT NULL,
    ext_telef        VARCHAR2(20 BYTE),
    nota_telef       VARCHAR2(80 BYTE),
    area_telef_id1   NUMBER
);

ALTER TABLE gl_telefonos
    ADD CONSTRAINT ck_tlf_id CHECK ( id BETWEEN 1 AND 99999999 );

ALTER TABLE gl_telefonos
    ADD CONSTRAINT si_no_388121875 CHECK ( activo_telef IN (
        'N',
        'S'
    ) );

COMMENT ON TABLE gl_telefonos IS
    'Número Teléfonico. Ej:1 0234567 2012 Directo';

COMMENT ON COLUMN gl_telefonos.id IS
    'Número de Identificación Interna del Teléfono.';

COMMENT ON COLUMN gl_telefonos.tp_telef_id IS
    'Tipo de Teléfono. Número de Identificación del Tipo de Teléfono.';

COMMENT ON COLUMN gl_telefonos.area_telef_id IS
    'Código de Area del Teléfono. Número de Identificación Interno del Código de Area Teléfonica.';

COMMENT ON COLUMN gl_telefonos.per_id IS
    'Número de Identificación Interno de la Persona.';

COMMENT ON COLUMN gl_telefonos.num_telef IS
    'Número de Teléfono. Ej: 7654321';

COMMENT ON COLUMN gl_telefonos.activo_telef IS
    'Está Activo el Teléfono. Ej: S, N.';

COMMENT ON COLUMN gl_telefonos.ext_telef IS
    'Extensión del Telefono. Ej: Ext. 123.';

COMMENT ON COLUMN gl_telefonos.nota_telef IS
    'Nota del Teléfono. Ej: Llamar solo en horas laborales.';

CREATE UNIQUE INDEX tlf_id_idx ON
    gl_telefonos (
        id
    ASC );

ALTER TABLE gl_telefonos ADD CONSTRAINT gl_telefonos_pk PRIMARY KEY ( id );

CREATE TABLE gl_tipo_local (
    id            NUMBER
        CONSTRAINT nnc_gl_tipo_local_id NOT NULL,
    descripcion   VARCHAR2(100 BYTE)
        CONSTRAINT nnc_gl_tipo_local_descripcion NOT NULL,
    abreviatura   VARCHAR2(20 BYTE)
        CONSTRAINT nnc_gl_tipo_local_abreviatura NOT NULL
);

ALTER TABLE gl_tipo_local
    ADD CONSTRAINT "ID}_1446931890" CHECK ( id BETWEEN 1 AND 99999999 );

COMMENT ON TABLE gl_tipo_local IS
    'Tipo de Local o Sitio: Ej. Apartamento, local';

COMMENT ON COLUMN gl_tipo_local.id IS
    'Identificador Unico del Tipo de Local';

COMMENT ON COLUMN gl_tipo_local.descripcion IS
    'Descripcion del Tipo de Local';

COMMENT ON COLUMN gl_tipo_local.abreviatura IS
    'Abreviatura del Tipo de local';

CREATE UNIQUE INDEX gl_tipo_local_id_idx ON
    gl_tipo_local (
        id
    ASC );

ALTER TABLE gl_tipo_local ADD CONSTRAINT gl_tipo_local_pk PRIMARY KEY ( id );

CREATE TABLE gl_tipos_direcciones (
    id            NUMBER
        CONSTRAINT nnc_tp_dir_id NOT NULL,
    descripcion   VARCHAR2(20 BYTE)
        CONSTRAINT nnc_tp_dir_descripcion NOT NULL
);

ALTER TABLE gl_tipos_direcciones
    ADD CONSTRAINT ck_tp_dir_id CHECK ( id BETWEEN 1 AND 99999999 );

COMMENT ON TABLE gl_tipos_direcciones IS
    'Tipo de Dirección. Ej:1 Domicilio Fiscal, 2 Oficina, 3 Habitación.';

COMMENT ON COLUMN gl_tipos_direcciones.id IS
    'Número de Identificación Interno del Tipo de Dirección.';

COMMENT ON COLUMN gl_tipos_direcciones.descripcion IS
    'Descripción de Tipo de Dirección.  Dirección del Hogar, Dirección de la Oficina. Dirección del Domicilio Fiscal.';

CREATE UNIQUE INDEX tp_dir_id_idx ON
    gl_tipos_direcciones (
        id
    ASC );

ALTER TABLE gl_tipos_direcciones ADD CONSTRAINT gl_tipos_direcciones_pk PRIMARY KEY ( id );

CREATE TABLE gl_tipos_edificaciones (
    id               NUMBER
        CONSTRAINT nnc_tp_edif_id NOT NULL,
    descripcion      VARCHAR2(20 BYTE)
        CONSTRAINT nnc_tp_edif_descripcion NOT NULL,
    "VARIOS PISOS"   CHAR(1) DEFAULT 'N'
        CONSTRAINT "NNC_TP_EDIF_VARIOS PISOS" NOT NULL,
    abreviatura      VARCHAR2(20 BYTE)
);

ALTER TABLE gl_tipos_edificaciones
    ADD CONSTRAINT ck_tp_edif_id CHECK ( id BETWEEN 1 AND 99999999 );

ALTER TABLE gl_tipos_edificaciones
    ADD CONSTRAINT "CK_TP_EDIF_VARIOS PISOS" CHECK ( "VARIOS PISOS" IN (
        'N',
        'S'
    ) );

COMMENT ON TABLE gl_tipos_edificaciones IS
    'Tipo de Edificación. Ej: 1 Casa, 2 Quinta, 3 Edificio, 4 Centro Comercial.';

COMMENT ON COLUMN gl_tipos_edificaciones.id IS
    'Número de Identificación Interna del Tipo de Edificación.';

COMMENT ON COLUMN gl_tipos_edificaciones.descripcion IS
    'Descripción del Tipo de Edificación. Ej: Casa, Quinta, Edificio, Centro Comercial';

COMMENT ON COLUMN gl_tipos_edificaciones."VARIOS PISOS" IS
    'Si el Tipo de Edificacion tiene Varios Pisos';

COMMENT ON COLUMN gl_tipos_edificaciones.abreviatura IS
    'Abreviatura del Tipo de Edificacion: Ej. Edif, CC. Loc.';

CREATE UNIQUE INDEX tp_edif_id_idx ON
    gl_tipos_edificaciones (
        id
    ASC );

ALTER TABLE gl_tipos_edificaciones ADD CONSTRAINT gl_tipos_edificaciones_pk PRIMARY KEY ( id );

CREATE TABLE gl_tipos_telefonos (
    id            NUMBER
        CONSTRAINT nnc_gl_tipos_telefonos_id NOT NULL,
    descripcion   VARCHAR2(20 BYTE)
        CONSTRAINT nnc_tp_telef_des NOT NULL
);

COMMENT ON TABLE gl_tipos_telefonos IS
    'Tipo de Teléfono. Ej:1 Celular, 2 Habitación, 3 Oficina, 4 Fax. 5 Busca Personas.';

COMMENT ON COLUMN gl_tipos_telefonos.id IS
    'Número de Identificación del Tipo de Teléfono.';

COMMENT ON COLUMN gl_tipos_telefonos.descripcion IS
    'Descripción del Tipo de Teléfono. Ej: Teléfono de Habtiración, Teléfono Celular. Teléfono del Domicilio Fiscal.';

CREATE UNIQUE INDEX gl_tipos_telefonos_id_idx ON
    gl_tipos_telefonos (
        id
    ASC );

ALTER TABLE gl_tipos_telefonos ADD CONSTRAINT gl_tipos_telefonos_pk PRIMARY KEY ( id );

CREATE TABLE gl_tipos_vias (
    id            NUMBER
        CONSTRAINT nnc_tp_via_id NOT NULL,
    descripcion   VARCHAR2(20 BYTE)
        CONSTRAINT nnc_tp_via_descripcion NOT NULL
);

ALTER TABLE gl_tipos_vias
    ADD CONSTRAINT ck_tp_via_id CHECK ( id BETWEEN 1 AND 99999999 );

COMMENT ON TABLE gl_tipos_vias IS
    'Tipo de Vía de Acceso. Ej: 1 Calle, 2 Avenida, 3 Vereda, 4 Carretera, 5 Carrera.';

COMMENT ON COLUMN gl_tipos_vias.id IS
    'Número de Identificación Interno del Tipo de Via.';

COMMENT ON COLUMN gl_tipos_vias.descripcion IS
    'Descripción del Tipo de Via. Ej: Calle, Carrera, Avenida.';

CREATE UNIQUE INDEX tp_via_id_idx ON
    gl_tipos_vias (
        id
    ASC );

ALTER TABLE gl_tipos_vias ADD CONSTRAINT gl_tipos_vias_pk PRIMARY KEY ( id );

CREATE TABLE gl_tipos_zonas (
    id            NUMBER
        CONSTRAINT nnc_tp_zon_id NOT NULL,
    descripcion   VARCHAR2(100 BYTE)
        CONSTRAINT nnc_tp_zon_descripcion NOT NULL
);

ALTER TABLE gl_tipos_zonas
    ADD CONSTRAINT ck_tp_zon_id CHECK ( id BETWEEN 1 AND 99999999 );

COMMENT ON TABLE gl_tipos_zonas IS
    'Tipo de Zona: EJ. Urbanizacion, sector, barrio, conjunto residencial';

COMMENT ON COLUMN gl_tipos_zonas.id IS
    'id del tipo de la zona';

COMMENT ON COLUMN gl_tipos_zonas.descripcion IS
    'Descripcion del Tipo de Zona';

CREATE UNIQUE INDEX tp_zon_id_idx ON
    gl_tipos_zonas (
        id
    ASC );

ALTER TABLE gl_tipos_zonas ADD CONSTRAINT gl_tipos_zonas_pk PRIMARY KEY ( id );

CREATE TABLE gl_urbanizaciones (
    id       NUMBER
        CONSTRAINT nnc_urb_id NOT NULL,
    ciu_id   NUMBER
        CONSTRAINT nnc_urb_ciu_id NOT NULL,
    nombre   VARCHAR2(50 BYTE)
        CONSTRAINT nnc_urb_nombre NOT NULL
);

ALTER TABLE gl_urbanizaciones
    ADD CONSTRAINT ck_urb_id CHECK ( id BETWEEN 1 AND 99999999 );

ALTER TABLE gl_urbanizaciones
    ADD CONSTRAINT ck_urb_ciu_id CHECK ( ciu_id BETWEEN 1 AND 99999999 );

COMMENT ON TABLE gl_urbanizaciones IS
    'Urbanización, Barrio, Sector, Parcelamiento. Ej: 1 El Trigal, 2 El Combate.';

COMMENT ON COLUMN gl_urbanizaciones.id IS
    'Número de Identificación Interna de la Urbanización o Barrio.';

COMMENT ON COLUMN gl_urbanizaciones.ciu_id IS
    'Ciudad, Población o Caserio de la Urbanización o Barrio. Número de Identificación Interno de la Ciudad banización. Población o Caserio.'
    ;

COMMENT ON COLUMN gl_urbanizaciones.nombre IS
    'Nombre de la Urbanización o Barrio. Ej: El Trigal.';

CREATE UNIQUE INDEX urb_id_idx ON
    gl_urbanizaciones (
        id
    ASC );

ALTER TABLE gl_urbanizaciones ADD CONSTRAINT gl_urbanizaciones_pk PRIMARY KEY ( id );

CREATE TABLE gl_zonas_postales (
    id            NUMBER
        CONSTRAINT nnc_zon_pos_id NOT NULL,
    est_id        NUMBER
        CONSTRAINT nnc_zon_pos_est_id NOT NULL,
    codigo        VARCHAR2(20 BYTE)
        CONSTRAINT nnc_zon_pos_codigo NOT NULL,
    descripcion   VARCHAR2(80 BYTE)
        CONSTRAINT nnc_zon_pos_descripcion NOT NULL
);

ALTER TABLE gl_zonas_postales
    ADD CONSTRAINT ck_zon_pos_id CHECK ( id BETWEEN 1 AND 99999999 );

ALTER TABLE gl_zonas_postales
    ADD CONSTRAINT ck_zon_est_id CHECK ( est_id BETWEEN 1 AND 99999999 );

COMMENT ON TABLE gl_zonas_postales IS
    'Número de Zona de Identificación Postal. Ej: 1240, Carabobo.';

COMMENT ON COLUMN gl_zonas_postales.id IS
    'Número de Identificación Interno de la Zona Postal';

COMMENT ON COLUMN gl_zonas_postales.est_id IS
    'Número de Identificación Interno del Estado, Departamento o Provincia.';

COMMENT ON COLUMN gl_zonas_postales.codigo IS
    'Codigo de la Zona Postal. Ej: 1060.';

COMMENT ON COLUMN gl_zonas_postales.descripcion IS
    'Descripción de la Zona Postal. Ej: Chacao.';

CREATE UNIQUE INDEX zon_pos_id_idx ON
    gl_zonas_postales (
        id
    ASC );

ALTER TABLE gl_zonas_postales ADD CONSTRAINT gl_zonas_postales_pk PRIMARY KEY ( id );

ALTER TABLE gl_area_telefonica
    ADD CONSTRAINT area_telef_pai_fk FOREIGN KEY ( pai_id )
        REFERENCES gl_paises ( id )
            ON DELETE SET NULL;

ALTER TABLE gl_ciudades
    ADD CONSTRAINT ciu_area_telef_fk FOREIGN KEY ( area_telef_id )
        REFERENCES gl_area_telefonica ( id )
            ON DELETE SET NULL;

ALTER TABLE gl_ciudades
    ADD CONSTRAINT ciu_est_fk FOREIGN KEY ( est_id )
        REFERENCES gl_estados ( id );

ALTER TABLE gl_ciudades
    ADD CONSTRAINT ciu_mun_fk FOREIGN KEY ( mun_id )
        REFERENCES gl_municipios ( id )
            ON DELETE SET NULL;

ALTER TABLE gl_direcciones
    ADD CONSTRAINT dir_ciu_fk FOREIGN KEY ( ciu_id )
        REFERENCES gl_ciudades ( id )
            ON DELETE SET NULL;

ALTER TABLE gl_direcciones
    ADD CONSTRAINT dir_mun_fk FOREIGN KEY ( mun_id )
        REFERENCES gl_municipios ( id )
            ON DELETE SET NULL;

ALTER TABLE gl_direcciones
    ADD CONSTRAINT dir_parr_fk FOREIGN KEY ( parr_id )
        REFERENCES gl_parroquias ( id )
            ON DELETE SET NULL;

ALTER TABLE gl_direcciones
    ADD CONSTRAINT dir_per_fk FOREIGN KEY ( per_id )
        REFERENCES gl_personas ( id )
            ON DELETE SET NULL;

ALTER TABLE gl_direcciones
    ADD CONSTRAINT dir_tp_dir_fk FOREIGN KEY ( tp_dir_id )
        REFERENCES gl_tipos_direcciones ( id );

ALTER TABLE gl_direcciones
    ADD CONSTRAINT dir_tp_edif_fk FOREIGN KEY ( tp_edif_id )
        REFERENCES gl_tipos_edificaciones ( id );

ALTER TABLE gl_direcciones
    ADD CONSTRAINT dir_tp_local_fk FOREIGN KEY ( tp_local_id )
        REFERENCES gl_tipo_local ( id )
            ON DELETE SET NULL;

ALTER TABLE gl_direcciones
    ADD CONSTRAINT dir_tp_via_fk FOREIGN KEY ( tp_via_id )
        REFERENCES gl_tipos_vias ( id );

ALTER TABLE gl_direcciones
    ADD CONSTRAINT dir_tp_zon_fk FOREIGN KEY ( tp_zon_id )
        REFERENCES gl_tipos_zonas ( id );

ALTER TABLE gl_direcciones
    ADD CONSTRAINT dir_urb_fk FOREIGN KEY ( urb_id )
        REFERENCES gl_urbanizaciones ( id );

ALTER TABLE gl_direcciones
    ADD CONSTRAINT dir_zon_pos_fk FOREIGN KEY ( zon_pos_id )
        REFERENCES gl_zonas_postales ( id )
            ON DELETE SET NULL;

ALTER TABLE gl_estados
    ADD CONSTRAINT est_pai_fk FOREIGN KEY ( pai_id )
        REFERENCES gl_paises ( id )
            ON DELETE SET NULL;

ALTER TABLE gl_tasa_cambio
    ADD CONSTRAINT gl_tasa_cambio_moneda_fk FOREIGN KEY ( moneda_id )
        REFERENCES gl_moneda ( id );

ALTER TABLE gl_tasa_cambio
    ADD CONSTRAINT gl_tasa_cambio_moneda_fkv1 FOREIGN KEY ( moneda_id2 )
        REFERENCES gl_moneda ( id );

ALTER TABLE gl_municipios
    ADD CONSTRAINT mun_est_fk FOREIGN KEY ( est_id )
        REFERENCES gl_estados ( id );

ALTER TABLE gl_paises
    ADD CONSTRAINT pai_contnente_fk FOREIGN KEY ( contnente_id )
        REFERENCES gl_continente ( id )
            ON DELETE SET NULL;

ALTER TABLE gl_paises
    ADD CONSTRAINT pai_moneda_fk FOREIGN KEY ( moneda_id )
        REFERENCES gl_moneda ( id )
            ON DELETE SET NULL;

ALTER TABLE gl_parroquias
    ADD CONSTRAINT parr_mun_fk FOREIGN KEY ( mun_id )
        REFERENCES gl_municipios ( id );

ALTER TABLE gl_telefonos
    ADD CONSTRAINT tlf_area_telef_fk FOREIGN KEY ( area_telef_id1 )
        REFERENCES gl_area_telefonica ( id )
            ON DELETE SET NULL;

ALTER TABLE gl_telefonos
    ADD CONSTRAINT tlf_per_fk FOREIGN KEY ( per_id )
        REFERENCES gl_personas ( id )
            ON DELETE SET NULL;

ALTER TABLE gl_telefonos
    ADD CONSTRAINT tlf_tp_telef_fk FOREIGN KEY ( tp_telef_id )
        REFERENCES gl_tipos_telefonos ( id );

ALTER TABLE gl_urbanizaciones
    ADD CONSTRAINT urb_ciu_fk FOREIGN KEY ( ciu_id )
        REFERENCES gl_ciudades ( id );

ALTER TABLE gl_zonas_postales
    ADD CONSTRAINT zon_pos_est_fk FOREIGN KEY ( est_id )
        REFERENCES gl_estados ( id );

ALTER TABLE gl_inf_nacimientos
    ADD CONSTRAINT inf_nac_ciu_fk FOREIGN KEY ( ciu_id )
        REFERENCES gl_ciudades ( id )
            ON DELETE SET NULL;

ALTER TABLE gl_inf_nacimientos
    ADD CONSTRAINT inf_nac_est_fk FOREIGN KEY ( est_id )
        REFERENCES gl_estados ( id )
            ON DELETE SET NULL;

ALTER TABLE gl_inf_nacimientos
    ADD CONSTRAINT inf_nac_mun_fk FOREIGN KEY ( mun_id )
        REFERENCES gl_municipios ( id )
            ON DELETE SET NULL;

ALTER TABLE gl_inf_nacimientos
    ADD CONSTRAINT inf_nac_pai_fk FOREIGN KEY ( pai_id )
        REFERENCES gl_paises ( id )
            ON DELETE SET NULL;



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            19
-- CREATE INDEX                            21
-- ALTER TABLE                             85
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
