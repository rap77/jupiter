ALTER TABLE INSCRIPCIONES 
DROP COLUMN SEC_ID_SECCION;

ALTER TABLE INSCRIPCIONES 
DROP COLUMN SEC_ID_METODO;

ALTER TABLE INSCRIPCIONES 
DROP COLUMN NRO_FACTURA;

ALTER TABLE INSCRIPCIONES 
DROP COLUMN SECCIONES_ID;

ALTER TABLE INSCRIPCIONES  
MODIFY (FACTURA_ID NULL);


create table detalle_fac_bak201907up as select * from detalle_factura;
delete detalle_factura;

ALTER TABLE ces.detalle_factura ADD (
    materiales_id NUMBER NOT NULL
);
ALTER TABLE ces.detalle_factura ADD (
    factura_id NUMBER NOT NULL
);

create table factura_bak201907up as select * from factura;
delete factura;

ALTER TABLE ces.factura ADD (
    id NUMBER NOT NULL
);

COMMENT ON COLUMN ces.factura.id IS
    'Identificador unico de Factura';
ALTER TABLE ces.factura DROP CONSTRAINT pk_fact CASCADE;

ALTER TABLE ces.factura ADD CONSTRAINT pk_fact PRIMARY KEY ( id )
    USING INDEX;
ALTER TABLE ces.ficha_academica MODIFY (
    renglon NUMBER
);
ALTER TABLE ces.ficha_pago MODIFY (
    renglon NUMBER
);
ALTER TABLE ces.ficha_pago ADD (
    factura_id NUMBER NOT NULL
);

COMMENT ON COLUMN ces.ficha_pago.factura_id IS
    'Identificador Unico de Factura';
ALTER TABLE ces.inscripciones ADD (
    seccion_id NUMBER NOT NULL
);

COMMENT ON COLUMN ces.inscripciones.seccion_id IS
    'Identificador Unico de la Seccion';
ALTER TABLE ces.inscripciones ADD (
    factura_id NUMBER NOT NULL
);
ALTER TABLE ces.materiales ADD (
    id NUMBER NOT NULL
);

COMMENT ON COLUMN ces.materiales.id IS
    'Identificador unico de material';
ALTER TABLE ces.materiales ADD (
    seccion_id NUMBER NOT NULL
);

COMMENT ON COLUMN ces.materiales.seccion_id IS
    'Identificador Unico de Seccion';
CREATE UNIQUE INDEX ces.materiales_uk ON
    ces.materiales (
        id_mat
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( INITIAL 65536 NEXT 1048576 PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS 2147483645 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL
            DEFAULT )
        LOGGING;
ALTER TABLE ces.materiales ADD CONSTRAINT materiales_pk PRIMARY KEY ( id )
    USING INDEX;
ALTER TABLE ces.secciones ADD (
    id NUMBER NOT NULL
);

COMMENT ON COLUMN ces.secciones.id IS
    'Identificador Unico de la Seccion';
CREATE UNIQUE INDEX ces.secciones_uk ON
    ces.secciones (
        id_seccion
    ASC,
        id_metodo
    ASC )
        TABLESPACE jupiter LOGGING;
ALTER TABLE ces.secciones ADD CONSTRAINT secciones_pk PRIMARY KEY ( id )
    USING INDEX;
ALTER TABLE ces.conceptos_tipo
    ADD CONSTRAINT fk_material FOREIGN KEY ( materiales_id )
        REFERENCES ces.materiales ( id )
    NOT DEFERRABLE;
ALTER TABLE ces.detalle_factura
    ADD CONSTRAINT fk_fact FOREIGN KEY ( factura_id )
        REFERENCES ces.factura ( id )
    NOT DEFERRABLE;
ALTER TABLE ces.detalle_factura
    ADD CONSTRAINT detalle_factura_tipo_material_fk FOREIGN KEY ( tipo_item )
        REFERENCES ces.tipo_material ( abrev )
    NOT DEFERRABLE;
ALTER TABLE ces.detalle_factura
    ADD CONSTRAINT detalle_factura_materiales_fk FOREIGN KEY ( materiales_id )
        REFERENCES ces.materiales ( id )
    NOT DEFERRABLE;
ALTER TABLE ces.factura
    ADD CONSTRAINT factura_companias_fk FOREIGN KEY ( programa )
        REFERENCES ces.companias ( codigo )
    NOT DEFERRABLE;
ALTER TABLE ces.ficha_pago
    ADD CONSTRAINT ficha_pago_factura_fk FOREIGN KEY ( factura_id )
        REFERENCES ces.factura ( id )
    NOT DEFERRABLE;
ALTER TABLE ces.inscripciones
    ADD CONSTRAINT inscripciones_secciones_fk FOREIGN KEY ( seccion_id )
        REFERENCES ces.secciones ( id )
    NOT DEFERRABLE;
ALTER TABLE ces.inscripciones
    ADD CONSTRAINT inscripciones_factura_fk FOREIGN KEY ( factura_id )
        REFERENCES ces.factura ( id )
    NOT DEFERRABLE;
ALTER TABLE ces.materiales
    ADD CONSTRAINT materiales_secciones_fk FOREIGN KEY ( seccion_id )
        REFERENCES ces.secciones ( id )
    NOT DEFERRABLE;
-----------------------




COMMENT ON TABLE inscripciones IS
    'Tabla de Inscripciones';

ALTER TABLE ces.inscripciones MOVE
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 );
    
COMMENT ON TABLE ces.material_digital IS
    'Tabla de Material Digital';

ALTER TABLE ces.cohortes RENAME COLUMN id TO codigo;

-- falla
create table cohortes_bak201907up as select * from cohortes;
delete cohortes;

ALTER TABLE ces.cohortes ADD (
    id NUMBER NOT NULL
);

-- fin falla
COMMENT ON COLUMN ces.cohortes.codigo IS
    'CODIGO';

COMMENT ON COLUMN ces.cohortes.id IS
    'Identificador unico de Cohorte';

ALTER TABLE ces.cohortes MODIFY (
    id NUMBER
);
ALTER TABLE ces.cohortes ADD (
    tipo_diplo VARCHAR2(15 BYTE) NOT NULL
);

COMMENT ON COLUMN ces.cohortes.tipo_diplo IS
    'Tipo de diplomado: Ej ADMINISTRADO, CERTIFICACION';
ALTER TABLE ces.cohortes ADD (
    creado_por VARCHAR2(255 BYTE)
);

COMMENT ON COLUMN ces.cohortes.creado_por IS
    'usuario quien crea la seccion';
ALTER TABLE ces.cohortes ADD (
    creado_el DATE
);

COMMENT ON COLUMN ces.cohortes.creado_el IS
    'Fecha de Creacion';
ALTER TABLE ces.cohortes ADD (
    modificado_por VARCHAR2(255 BYTE)
);

COMMENT ON COLUMN ces.cohortes.modificado_por IS
    'usuario quien modifica la seccion';
ALTER TABLE ces.cohortes ADD (
    modificado_el DATE
);

COMMENT ON COLUMN ces.cohortes.modificado_el IS
    'Fecha de Modificacion';
ALTER TABLE ces.cohortes ADD (
    diplomados_id NUMBER NOT NULL
);
ALTER INDEX ces.sys_c0018518 RENAME TO cohortes_uk;
ALTER INDEX ces.sys_c0018518 RENAME TO cohortes_pk;

insert into cohortes
select c.CODIGO,c.ID_DIPLOMADO,c.ID_HORARIO ,c.ID_MODALIDAD,c.COHORTE,c.CANT_ACTUAL,c.FECHA_INI,c.FECHA_FIN,c.COSTO,c.INICIAL,c.COSTO_CUOTA,c.CUOTAS,c.STATUS,c.CIUDAD
,rownum ID
,'ADMINISTRADO' TIPO_DIPLO
,'PADRON' CREADO_POR
,SYSDATE CREADO_EL
,null MODIFICADO_POR
,null MODIFICADO_EL
,d.id DIPLOMADOS_ID
from cohortes_bak201907up c, diplomados d
where c.id_diplomado=d.id_diplomado;

update cohorte_certi set id = 'CT-'||id

insert into cohortes
select c.ID CODIGO, c.ID_CERTI ID_DIPLOMADO, null HORARIO, null MODALIDAD, null COHORTE, CANT, null F_INI, null F_FIN, monto COSTO,0 INICIAL, 0 COSTO_COUTA,0 CUOTAS,c.status,ciudad, (select max(id) from cohortes)+rownum ID,'CERTIFICACION' TIPO_DIPLO,'PADRON' CREADO_POR,SYSDATE CREADO_EL,null MODIFICADO_POR,null MODIFICADO_EL,d.id id_dplomado
from cohorte_certi c, diplomados d
where c.id_certi=d.id_diplomado and c.id not in (select codigo from cohortes);


-- fin cohorte
create table deposito_bak201907up as select * from deposito;
delete deposito;

ALTER TABLE ces.deposito ADD (
    id NUMBER NOT NULL
);

COMMENT ON COLUMN ces.deposito.id IS
    'Identificador Unido del Pago de factura';
ALTER TABLE ces.deposito DROP CONSTRAINT pk_deposito CASCADE DROP INDEX;

CREATE UNIQUE INDEX ces.deposito_uk ON
    ces.deposito (
        referencia
    ASC,
        id_banco
    ASC,
        forma_pago
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( INITIAL 4194304 NEXT 1048576 PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS 2147483645 FREELISTS 1 FREELIST GROUPS 1
            BUFFER_POOL DEFAULT )
        LOGGING;

ALTER TABLE ces.deposito ADD CONSTRAINT pk_deposito PRIMARY KEY ( id )
    USING INDEX;
    

insert into deposito
select REFERENCIA,FECHA_EMI,ID_BANCO,MONTO,CIA,CLASE,USUARIO,STATUS,FORMA_PAGO,PROG_ACADEMICO, rownum ID from deposito_bak201907up

--fin deposito

CREATE UNIQUE INDEX ces.sys_c0018532 ON
    ces.detalle_factura (
        renglon
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( INITIAL 4194304 NEXT 1048576 PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS 2147483645 FREELISTS 1 FREELIST GROUPS 1
            BUFFER_POOL DEFAULT )
        LOGGING;
ALTER INDEX ces.detalle_factura_pk PCTFREE 10 PCTUSED 40 INITRANS 2
    STORAGE ( BUFFER_POOL DEFAULT );

ALTER INDEX ces.detalle_factura_pk REBUILD
    STORAGE ( INITIAL 4194304 NEXT 1048576 PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS 2147483645 FREELISTS 1 FREELIST GROUPS 1 );
    
ALTER TABLE ces.diplo_certi ADD CONSTRAINT diplo_certi_pk PRIMARY KEY ( id_certi );
-- diplomados

create table diplomados_bak201907up as select * from diplomados;
delete diplomados;

ALTER TABLE ces.diplomados ADD (
    id NUMBER NOT NULL
);

COMMENT ON COLUMN ces.diplomados.id IS
    'Identificador unico de diplomado';
ALTER INDEX ces.diplomados_pk RENAME TO diplomados_uk;
ALTER TABLE ces.diplomados DROP CONSTRAINT diplomados_pk CASCADE DROP INDEX;

CREATE UNIQUE INDEX ces.diplomados_pk ON
    ces.diplomados (
        id
    ASC )
        TABLESPACE users LOGGING;

ALTER TABLE ces.diplomados ADD CONSTRAINT diplomados_pk PRIMARY KEY ( id )
    USING INDEX;
    
insert into diplomados
select ID_DIPLOMADO,DESCRIPCION,HORAS,COORDINADOR,MODULOS,STATUS,CLASE_DOC,MINIMO,MAXIMO,COD_CONTABLE,COD_DESCUENTO,rownum ID
from diplomados_bak201907up

insert into diplomados
select id_certi, descripcion,nvl(horas,0),nvl(coordinador,'SIN ASIGNAR'),0,'V',clase_doc,0,0,cod_contable,null,(select max(id) from diplomados)+rownum from diplo_certi where id_certi not in (select id_diplomado from diplomados)

-- factura
ALTER TABLE ces.factura MODIFY (
    id_fact
        NOT NULL NOT DEFERRABLE ENABLE VALIDATE
);
ALTER TABLE ces.factura MODIFY (
    programa
        NOT NULL NOT DEFERRABLE ENABLE VALIDATE
);

--Error for index CES.PK_FACT - it'll prevents constraint PK_FACT to have index created - make it non unique
ALTER INDEX ces.pk_fact REBUILD TABLESPACE users
    STORAGE ( INITIAL 4194304 NEXT 1048576 PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS 2147483645 FREELISTS 1 FREELIST GROUPS 1 );
--factura_deposito
create table fac_dep_bak201907up as select * from factura_deposito;
delete factura_deposito;

ALTER TABLE ces.factura_deposito ADD (
    deposito_id NUMBER NOT NULL
);
ALTER TABLE ces.factura_deposito ADD (
    factura_id NUMBER NOT NULL
);
ALTER TABLE ces.factura_deposito ADD CONSTRAINT factura_deposito_pk PRIMARY KEY ( factura_id,
                                                                                  deposito_id );
insert into factura_deposito                                                                                  
select null ID_FACT, null REFERENCIA,d.id DEPOSITO_ID, f.id FACTURA_ID from fac_dep_bak201907up fd, factura f, deposito d
where fd.id_fact=f.id_fact and fd.referencia=d.referencia
-- inscripciones                                                                                  
DROP TRIGGER ces.inscripciones_trg;

ALTER TABLE ces.inscripciones ADD (
    creado_por VARCHAR2(255 BYTE) DEFAULT coalesce(sys_context('APEX$SESSION', 'app_user'), regexp_substr(sys_context('userenv', 'client_identifier'
    ), '^[^:]*'), sys_context('userenv', 'session_user'))
);

COMMENT ON COLUMN ces.inscripciones.creado_por IS
    'Usuario quien creo la Inscripcion';
ALTER INDEX ces.inscripciones_pk REBUILD
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 );
ALTER INDEX inscripciones_pk REBUILD
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 );
    
--materiales

update materiales set iva_exento = nvl(iva_exento,'N');

ALTER TABLE ces.materiales MODIFY (
    iva_exento
        NOT NULL NOT DEFERRABLE ENABLE VALIDATE
);
DROP TRIGGER ces.materiales_trg;

ALTER TABLE ces.materiales ADD (
    creado_por VARCHAR2(255 BYTE) DEFAULT coalesce(sys_context('APEX$SESSION', 'app_user'), regexp_substr(sys_context('userenv', 'client_identifier'
    ), '^[^:]*'), sys_context('userenv', 'session_user'))
);

COMMENT ON COLUMN ces.materiales.creado_por IS
    'Usuario quien creo el material';
ALTER TABLE ces.materiales ADD (
    creado_el DATE DEFAULT SYSDATE
);

COMMENT ON COLUMN ces.materiales.creado_el IS
    'Fecha en que se creo el material';
ALTER TABLE ces.materiales ADD (
    modificado_por VARCHAR2(255 BYTE)
);

COMMENT ON COLUMN ces.materiales.modificado_por IS
    'Usuario quien modifico el material';
ALTER TABLE ces.materiales ADD (
    "MODIFICADO:EL" DATE
);

COMMENT ON COLUMN ces.materiales."MODIFICADO:EL" IS
    'fecha cuando se modifico el material';
ALTER TABLE ces.materiales ADD (
    cohortes_id NUMBER
);
DROP INDEX ces.materiales_uk;

CREATE UNIQUE INDEX ces.materiales_uk ON
    ces.materiales (
        id_mat
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( INITIAL 65536 NEXT 1048576 PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS 2147483645 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL
            DEFAULT )
        LOGGING;
ALTER INDEX ces.materiales_pk REBUILD TABLESPACE users;
-- secciones
ALTER TABLE ces.secciones MODIFY (
    id_metodo
        NOT NULL NOT DEFERRABLE ENABLE VALIDATE
);
ALTER TABLE ces.secciones MODIFY (
    periodo NUMBER NULL
);
ALTER TABLE ces.secciones ADD (
    creado_por VARCHAR2(255 BYTE)
);

COMMENT ON COLUMN ces.secciones.creado_por IS
    'usuario quien crea la seccion';
ALTER TABLE ces.secciones ADD (
    creado_el DATE
);

COMMENT ON COLUMN ces.secciones.creado_el IS
    'Fecha de Creacion';
ALTER TABLE ces.secciones ADD (
    modificado_por VARCHAR2(255 BYTE)
);

COMMENT ON COLUMN ces.secciones.modificado_por IS
    'usuario quien modifica la seccion';
ALTER TABLE ces.secciones ADD (
    modificado_el DATE
);

COMMENT ON COLUMN ces.secciones.modificado_el IS
    'Fecha de Modificacion';


ALTER INDEX ces.secciones_pk REBUILD TABLESPACE users;
-- cohorte_certi
ALTER TABLE ces.cohorte_certi
    ADD CONSTRAINT cohorte_certi_diplo_certi_fk FOREIGN KEY ( id_certi )
        REFERENCES ces.diplo_certi ( id_certi )
    NOT DEFERRABLE;
ALTER TABLE ces.cohortes
    ADD CONSTRAINT cohortes_diplomados_fk FOREIGN KEY ( diplomados_id )
        REFERENCES ces.diplomados ( id )
    NOT DEFERRABLE;
ALTER TABLE ces.factura_deposito
    ADD CONSTRAINT factura_deposito_deposito_fk FOREIGN KEY ( deposito_id )
        REFERENCES ces.deposito ( id )
    NOT DEFERRABLE;
ALTER TABLE ces.factura_deposito
    ADD CONSTRAINT factura_deposito_factura_fk FOREIGN KEY ( factura_id )
        REFERENCES ces.factura ( id )
    NOT DEFERRABLE;
ALTER TABLE ces.materiales
    ADD CONSTRAINT materiales_cohortes_fk FOREIGN KEY ( cohortes_id )
        REFERENCES ces.cohortes ( id )
    NOT DEFERRABLE;

---------------------
    
select lista(COLUMN_NAME) from all_tab_columns   
where OWNER='CES'
and TABLE_NAME='FACTURA_DEPOSITO'
order by column_id

delete from detalle_factura where id_fact in (select id_fact from factura where to_char(fecha_emi,'YYYY')='2019' )