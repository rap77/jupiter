-- Generado por Oracle SQL Developer Data Modeler 18.4.0.339.1532
--   en:        2019-07-05 10:22:17 VET
--   sitio:      Oracle Database 12cR2
--   tipo:      Oracle Database 12cR2




COMMENT ON TABLE ces.bancos IS
    'BANCOS';
COMMENT ON TABLE ces.calendario_cfp IS
    'CALENDARIO_CFP';
COMMENT ON TABLE ces.calendarios IS
    'CALENDARIOS';
COMMENT ON TABLE ces.calendarios_detalle IS
    'CALENDARIOS_DETALLE';
COMMENT ON TABLE ces.ciudades IS
    'CIUDADES';
COMMENT ON TABLE ces.clase_doc_prog IS
    'CLASE_DOC_PROG';
COMMENT ON TABLE ces.clases_doc IS
    'CLASES_DOC';
COMMENT ON TABLE ces.codigo_concepto IS
    'CODIGO_CONCEPTO';
COMMENT ON TABLE ces.codigo_diplomado IS
    'CODIGO_DIPLOMADO';
COMMENT ON TABLE ces.cohorte_certi IS
    'COHORTE_CERTI';
COMMENT ON TABLE ces.cohortes IS
    'COHORTES';
COMMENT ON TABLE ces.companias IS
    'COMPANIAS';
COMMENT ON TABLE ces.conceptos IS
    'CONCEPTOS';
COMMENT ON TABLE ces.conceptos_tipo IS
    'CONCEPTOS_TIPO';
COMMENT ON TABLE ces.condiciones_especiales IS
    'CONDICIONES_ESPECIALES';
COMMENT ON TABLE ces.cuentas_por_cobrar IS
    'CUENTAS_POR_COBRAR';
COMMENT ON TABLE ces.deposito IS
    'DEPOSITO';
COMMENT ON TABLE ces.deposito_ac IS
    'DEPOSITO_AC';
COMMENT ON TABLE ces.detalle_factura IS
    'DETALLE_FACTURA';
COMMENT ON TABLE ces.detalle_factura_ac IS
    'DETALLE_FACTURA_AC';
COMMENT ON TABLE ces.detalle_paquete IS
    'DETALLE_PAQUETE';
COMMENT ON TABLE ces.diplo_certi IS
    'DIPLO_CERTI';
COMMENT ON TABLE ces.diplo_temp IS
    'DIPLO_TEMP';
COMMENT ON TABLE ces.diplomados IS
    'DIPLOMADOS';
COMMENT ON TABLE ces.documentos_pru IS
    'DOCUMENTOS_PRU';
COMMENT ON TABLE ces.documentos_trf IS
    'DOCUMENTOS_TRF';
COMMENT ON TABLE ces.documentos_x IS
    'DOCUMENTOS_X';
COMMENT ON TABLE ces.edificios IS
    'EDIFICIOS';
COMMENT ON TABLE ces.empresa_tipo IS
    'EMPRESA_TIPO';
COMMENT ON TABLE ces.empresas IS
    'EMPRESAS';
COMMENT ON TABLE ces.errores IS
    'ERRORES';
COMMENT ON TABLE ces.estados IS
    'ESTADOS';
COMMENT ON TABLE ces.estudiante IS
    'ESTUDIANTE';
COMMENT ON TABLE ces.eventos IS
    'EVENTOS';
COMMENT ON TABLE ces.factura IS
    'FACTURA';
COMMENT ON TABLE ces.factura_ac IS
    'FACTURA_AC';
COMMENT ON TABLE ces.factura_deposito IS
    'FACTURA_DEPOSITO';
COMMENT ON TABLE ces.ficha_academica IS
    'FICHA_ACADEMICA';
COMMENT ON TABLE ces.ficha_academica_bak IS
    'FICHA_ACADEMICA_BAK';
COMMENT ON TABLE ces.ficha_pago IS
    'FICHA_PAGO';
COMMENT ON TABLE ces.ficha_pago_ac IS
    'FICHA_PAGO_AC';
COMMENT ON TABLE ces.ficha_pago_cfp IS
    'FICHA_PAGO_CFP';
COMMENT ON TABLE ces.forma_pago IS
    'FORMA_PAGO';
COMMENT ON TABLE ces.horario_diplomado IS
    'HORARIO_DIPLOMADO';
COMMENT ON TABLE ces.horario_temp IS
    'HORARIO_TEMP';
COMMENT ON TABLE ces.horarios IS
    'HORARIOS';
COMMENT ON TABLE ces.htmldb_plan_table IS
    'HTMLDB_PLAN_TABLE';
COMMENT ON TABLE ces.mat_new IS
    'MAT_NEW';
COMMENT ON TABLE ces.materiales IS
    'MATERIALES';
COMMENT ON TABLE ces.materiales_bak IS
    'MATERIALES_BAK';
COMMENT ON TABLE ces.metodos IS
    'METODOS';
COMMENT ON TABLE ces.modalidades IS
    'MODALIDADES';
COMMENT ON TABLE ces.modulos_diplomado IS
    'MODULOS_DIPLOMADO';
COMMENT ON TABLE ces.niveles IS
    'NIVELES';
COMMENT ON TABLE ces.ocupaciones IS
    'OCUPACIONES';
COMMENT ON TABLE ces.paquetes IS
    'PAQUETES';
COMMENT ON TABLE ces.ponderacion_niveles IS
    'PONDERACION_NIVELES';
COMMENT ON TABLE ces.precios IS
    'PRECIOS';
COMMENT ON TABLE ces.profesor IS
    'PROFESOR';
COMMENT ON TABLE ces.programa_academico IS
    'PROGRAMA_ACADEMICO';
COMMENT ON TABLE ces.programas_academicos IS
    'PROGRAMAS_ACADEMICOS';
COMMENT ON TABLE ces.roles IS
    'ROLES';
COMMENT ON TABLE ces.saldo_acum_bancos IS
    'SALDO_ACUM_BANCOS';
COMMENT ON TABLE ces.saldo_acum_conceptos IS
    'SALDO_ACUM_CONCEPTOS';
COMMENT ON TABLE ces.saldo_mensual_bancos IS
    'SALDO_MENSUAL_BANCOS';
COMMENT ON TABLE ces.saldo_mensual_conceptos IS
    'SALDO_MENSUAL_CONCEPTOS';
COMMENT ON TABLE ces.salones IS
    'SALONES';
COMMENT ON TABLE ces.secciones IS
    'SECCIONES';
COMMENT ON TABLE ces.secciones_his IS
    'SECCIONES_HIS';
COMMENT ON TABLE ces.status IS
    'STATUS';
COMMENT ON TABLE ces.teste IS
    'TESTE';
COMMENT ON TABLE ces.tipo_empresa IS
    'TIPO_EMPRESA';
COMMENT ON TABLE ces.tipo_estudiante IS
    'TIPO_ESTUDIANTE';
COMMENT ON TABLE ces.tipo_mat_prog IS
    'TIPO_MAT_PROG';
COMMENT ON TABLE ces.tipo_material IS
    'TIPO_MATERIAL';
COMMENT ON TABLE ces.tipo_profesor IS
    'TIPO_PROFESOR';
COMMENT ON TABLE ces.tipos_doc IS
    'TIPOS_DOC';
COMMENT ON TABLE ces.usuarios IS
    'USUARIOS';
COMMENT ON TABLE ces.zonas IS
    'ZONAS';
COMMENT ON COLUMN ces.bancos.id_banco IS
    'ID_BANCO';
COMMENT ON COLUMN ces.bancos.nombre IS
    'NOMBRE';
COMMENT ON COLUMN ces.bancos.ciudad IS
    'CIUDAD';
COMMENT ON COLUMN ces.bancos.debito IS
    'DEBITO';
COMMENT ON COLUMN ces.bancos.deposito IS
    'DEPOSITO';
COMMENT ON COLUMN ces.bancos.credito IS
    'CREDITO';
COMMENT ON COLUMN ces.bancos.cta IS
    'CTA';
ALTER TABLE ces.bancos RENAME CONSTRAINT sys_c0018511 TO bancos_pk;


-- Error while generating DDL for (PK) BANCOS_PK. See log file for details.
COMMENT ON COLUMN ces.calendario_cfp.diplomado IS
    'DIPLOMADO';
COMMENT ON COLUMN ces.calendario_cfp.fecha_corte IS
    'FECHA_CORTE';
COMMENT ON COLUMN ces.calendario_cfp.cuota IS
    'CUOTA';
COMMENT ON COLUMN ces.calendario_cfp.cohorte IS
    'COHORTE';
COMMENT ON COLUMN ces.calendarios.id_calendario IS
    'ID_CALENDARIO';
COMMENT ON COLUMN ces.calendarios.descripcion IS
    'DESCRIPCION';
COMMENT ON COLUMN ces.calendarios.periodos IS
    'PERIODOS';
ALTER TABLE ces.calendarios RENAME CONSTRAINT sys_c0018513 TO calendarios_pk;
COMMENT ON COLUMN ces.calendarios_detalle.id_calendario IS
    'ID_CALENDARIO';

ALTER TABLE ces.calendarios_detalle MODIFY (
    id_calendario
        NOT NULL NOT DEFERRABLE ENABLE VALIDATE
);
COMMENT ON COLUMN ces.calendarios_detalle.periodo IS
    'PERIODO';
COMMENT ON COLUMN ces.calendarios_detalle.fecha_ini IS
    'FECHA_INI';
COMMENT ON COLUMN ces.calendarios_detalle.fecha_fin IS
    'FECHA_FIN';
COMMENT ON COLUMN ces.calendarios_detalle.vigencia IS
    'VIGENCIA';
COMMENT ON COLUMN ces.calendarios_detalle.modalidad IS
    'MODALIDAD';

ALTER TABLE ces.calendarios_detalle MODIFY (
    modalidad
        NOT NULL NOT DEFERRABLE ENABLE VALIDATE
);
COMMENT ON COLUMN ces.ciudades.id_ciudad IS
    'ID_CIUDAD';
COMMENT ON COLUMN ces.ciudades.id_estado IS
    'ID_ESTADO';
COMMENT ON COLUMN ces.ciudades.nombre IS
    'NOMBRE';
ALTER TABLE ces.ciudades RENAME CONSTRAINT sys_c0018514 TO ciudades_pk;


-- Error while generating DDL for (PK) CIUDADES_PK. See log file for details.
COMMENT ON COLUMN ces.clase_doc_prog.id_compania IS
    'ID_COMPANIA';
COMMENT ON COLUMN ces.clase_doc_prog.id_programa IS
    'ID_PROGRAMA';
COMMENT ON COLUMN ces.clase_doc_prog.clase IS
    'CLASE';
COMMENT ON COLUMN ces.clases_doc.cd_tipo IS
    'CD_TIPO';
COMMENT ON COLUMN ces.clases_doc.cd_codigo IS
    'CD_CODIGO';
COMMENT ON COLUMN ces.clases_doc.cd_descrip IS
    'CD_DESCRIP';
COMMENT ON COLUMN ces.clases_doc.cd_signo IS
    'CD_SIGNO';
COMMENT ON COLUMN ces.clases_doc.cd_naturaleza IS
    'CD_NATURALEZA';
COMMENT ON COLUMN ces.clases_doc.cd_aplica IS
    'CD_APLICA';
COMMENT ON COLUMN ces.clases_doc.cd_multireg IS
    'CD_MULTIREG';
COMMENT ON COLUMN ces.clases_doc.cd_vcmto IS
    'CD_VCMTO';
COMMENT ON COLUMN ces.clases_doc.cd_autonum IS
    'CD_AUTONUM';
COMMENT ON COLUMN ces.clases_doc.cd_correlativo IS
    'CD_CORRELATIVO';
COMMENT ON COLUMN ces.clases_doc.cd_iva IS
    'CD_IVA';
COMMENT ON COLUMN ces.clases_doc.cd_abrv IS
    'CD_ABRV';
COMMENT ON COLUMN ces.clases_doc.cd_banco IS
    'CD_BANCO';
COMMENT ON COLUMN ces.clases_doc.cd_fpago IS
    'CD_FPAGO';
COMMENT ON COLUMN ces.clases_doc.cd_vendcob IS
    'CD_VENDCOB';
COMMENT ON COLUMN ces.clases_doc.cd_imprime IS
    'CD_IMPRIME';
COMMENT ON COLUMN ces.clases_doc.cd_tipocompbte IS
    'CD_TIPOCOMPBTE';
COMMENT ON COLUMN ces.clases_doc.cd_porcent IS
    'CD_PORCENT';
COMMENT ON COLUMN ces.codigo_concepto.cod_contable IS
    'COD_CONTABLE';
COMMENT ON COLUMN ces.codigo_concepto.concepto IS
    'CONCEPTO';
COMMENT ON COLUMN ces.codigo_concepto.tipo IS
    'TIPO';
COMMENT ON COLUMN ces.codigo_diplomado.cod_contable IS
    'COD_CONTABLE';
COMMENT ON COLUMN ces.codigo_diplomado.descripcion IS
    'DESCRIPCION';
COMMENT ON COLUMN ces.codigo_diplomado.cod_descuento IS
    'COD_DESCUENTO';
COMMENT ON COLUMN ces.cohorte_certi.id IS
    'ID';
COMMENT ON COLUMN ces.cohorte_certi.id_certi IS
    'ID_CERTI';
COMMENT ON COLUMN ces.cohorte_certi.cant IS
    'CANT';
COMMENT ON COLUMN ces.cohorte_certi.monto IS
    'MONTO';
COMMENT ON COLUMN ces.cohorte_certi.pagado IS
    'PAGADO';
COMMENT ON COLUMN ces.cohorte_certi.restante IS
    'RESTANTE';
COMMENT ON COLUMN ces.cohorte_certi.status IS
    'STATUS';
COMMENT ON COLUMN ces.cohorte_certi.ciudad IS
    'CIUDAD';


-- Error while generating DDL for CCERTI_PK. See log file for details.



-- Error while generating DDL for (PK) CCERTI_PK. See log file for details.

COMMENT ON COLUMN ces.cohortes.id IS
    'ID';
COMMENT ON COLUMN ces.cohortes.id_diplomado IS
    'ID_DIPLOMADO';
COMMENT ON COLUMN ces.cohortes.id_horario IS
    'ID_HORARIO';
COMMENT ON COLUMN ces.cohortes.id_modalidad IS
    'ID_MODALIDAD';
COMMENT ON COLUMN ces.cohortes.cohorte IS
    'COHORTE';
COMMENT ON COLUMN ces.cohortes.cant_actual IS
    'CANT_ACTUAL';
COMMENT ON COLUMN ces.cohortes.fecha_ini IS
    'FECHA_INI';
COMMENT ON COLUMN ces.cohortes.fecha_fin IS
    'FECHA_FIN';
COMMENT ON COLUMN ces.cohortes.costo IS
    'COSTO';
COMMENT ON COLUMN ces.cohortes.inicial IS
    'INICIAL';
COMMENT ON COLUMN ces.cohortes.costo_cuota IS
    'COSTO_CUOTA';
COMMENT ON COLUMN ces.cohortes.cuotas IS
    'CUOTAS';
COMMENT ON COLUMN ces.cohortes.status IS
    'STATUS';
COMMENT ON COLUMN ces.cohortes.ciudad IS
    'CIUDAD';
ALTER TABLE ces.cohortes RENAME CONSTRAINT sys_c0018518 TO cohortes_pk;


-- Error while generating DDL for (PK) COHORTES_PK. See log file for details.
COMMENT ON COLUMN ces.companias.codigo IS
    'CODIGO';
COMMENT ON COLUMN ces.companias.descripcion IS
    'DESCRIPCION';
COMMENT ON COLUMN ces.companias.id IS
    'ID';
COMMENT ON COLUMN ces.companias.direccion IS
    'DIRECCION';
COMMENT ON COLUMN ces.companias.telefono IS
    'TELEFONO';
COMMENT ON COLUMN ces.companias.email IS
    'EMAIL';
COMMENT ON COLUMN ces.companias.director IS
    'DIRECTOR';
COMMENT ON COLUMN ces.companias.ciudad IS
    'CIUDAD';
COMMENT ON COLUMN ces.companias.serie IS
    'SERIE';
COMMENT ON COLUMN ces.companias.activa IS
    'ACTIVA';
COMMENT ON COLUMN ces.companias.iva IS
    'IVA';
ALTER TABLE ces.companias RENAME CONSTRAINT sys_c0018522 TO companias_pk;


-- Error while generating DDL for (PK) COMPANIAS_PK. See log file for details.
COMMENT ON COLUMN ces.conceptos.id_concepto IS
    'ID_CONCEPTO';
COMMENT ON COLUMN ces.conceptos.descripcion IS
    'DESCRIPCION';
COMMENT ON COLUMN ces.conceptos.orden IS
    'ORDEN';
COMMENT ON COLUMN ces.conceptos.id_concepto_sup IS
    'ID_CONCEPTO_SUP';


-- Error while generating DDL for CONCEPTOS_PK. See log file for details.



-- Error while generating DDL for (PK) CONCEPTOS_PK. See log file for details.

COMMENT ON COLUMN ces.conceptos_tipo.id_concepto IS
    'ID_CONCEPTO';
COMMENT ON COLUMN ces.conceptos_tipo.tipo IS
    'TIPO';
COMMENT ON COLUMN ces.conceptos_tipo.id_mat IS
    'ID_MAT';
COMMENT ON COLUMN ces.conceptos_tipo.rif IS
    'RIF';


-- Error while generating DDL for CONCEPTOS_TIPO_PK. See log file for details.



-- Error while generating DDL for (PK) CONCEPTOS_TIPO_PK. See log file for details.

COMMENT ON COLUMN ces.condiciones_especiales.id_condicion IS
    'ID_CONDICION';
COMMENT ON COLUMN ces.condiciones_especiales.descripcion IS
    'DESCRIPCION';
COMMENT ON COLUMN ces.condiciones_especiales.descuento IS
    'DESCUENTO';
COMMENT ON COLUMN ces.cuentas_por_cobrar.cliente IS
    'CLIENTE';
COMMENT ON COLUMN ces.cuentas_por_cobrar.saldo IS
    'SALDO';
COMMENT ON COLUMN ces.cuentas_por_cobrar.ultimo_pago IS
    'ULTIMO_PAGO';
COMMENT ON COLUMN ces.cuentas_por_cobrar.ultimo_monto IS
    'ULTIMO_MONTO';
COMMENT ON COLUMN ces.cuentas_por_cobrar.fec_emi IS
    'FEC_EMI';
COMMENT ON COLUMN ces.cuentas_por_cobrar.ultimo_deposito IS
    'ULTIMO_DEPOSITO';
COMMENT ON COLUMN ces.cuentas_por_cobrar.id_fact IS
    'ID_FACT';
COMMENT ON COLUMN ces.cuentas_por_cobrar.prog_academico IS
    'PROG_ACADEMICO';
COMMENT ON COLUMN ces.deposito.referencia IS
    'REFERENCIA';
COMMENT ON COLUMN ces.deposito.fecha_emi IS
    'FECHA_EMI';
COMMENT ON COLUMN ces.deposito.id_banco IS
    'ID_BANCO';
COMMENT ON COLUMN ces.deposito.monto IS
    'MONTO';
COMMENT ON COLUMN ces.deposito.cia IS
    'CIA';
COMMENT ON COLUMN ces.deposito.clase IS
    'CLASE';
COMMENT ON COLUMN ces.deposito.usuario IS
    'USUARIO';
COMMENT ON COLUMN ces.deposito.status IS
    'STATUS';
COMMENT ON COLUMN ces.deposito.forma_pago IS
    'FORMA_PAGO';
COMMENT ON COLUMN ces.deposito.prog_academico IS
    'PROG_ACADEMICO';


-- Error while generating DDL for PK_DEPOSITO. See log file for details.



-- Error while generating DDL for (PK) PK_DEPOSITO. See log file for details.

COMMENT ON COLUMN ces.deposito_ac.referencia IS
    'REFERENCIA';
COMMENT ON COLUMN ces.deposito_ac.fecha_emi IS
    'FECHA_EMI';
COMMENT ON COLUMN ces.deposito_ac.id_banco IS
    'ID_BANCO';
COMMENT ON COLUMN ces.deposito_ac.monto IS
    'MONTO';
COMMENT ON COLUMN ces.deposito_ac.cia IS
    'CIA';
COMMENT ON COLUMN ces.deposito_ac.clase IS
    'CLASE';
COMMENT ON COLUMN ces.deposito_ac.usuario IS
    'USUARIO';
COMMENT ON COLUMN ces.deposito_ac.status IS
    'STATUS';
COMMENT ON COLUMN ces.deposito_ac.forma_pago IS
    'FORMA_PAGO';
COMMENT ON COLUMN ces.deposito_ac.prog_academico IS
    'PROG_ACADEMICO';
COMMENT ON COLUMN ces.detalle_factura.renglon IS
    'RENGLON';
COMMENT ON COLUMN ces.detalle_factura.programa IS
    'PROGRAMA';
COMMENT ON COLUMN ces.detalle_factura.id_fact IS
    'ID_FACT';
COMMENT ON COLUMN ces.detalle_factura.tipo_item IS
    'TIPO_ITEM';
COMMENT ON COLUMN ces.detalle_factura.item IS
    'ITEM';
COMMENT ON COLUMN ces.detalle_factura.descripcion IS
    'DESCRIPCION';
COMMENT ON COLUMN ces.detalle_factura.cantidad IS
    'CANTIDAD';
COMMENT ON COLUMN ces.detalle_factura.p_unidad IS
    'P_UNIDAD';
COMMENT ON COLUMN ces.detalle_factura.bs_descuento IS
    'BS_DESCUENTO';
COMMENT ON COLUMN ces.detalle_factura.subtotal IS
    'SUBTOTAL';
COMMENT ON COLUMN ces.detalle_factura.extension IS
    'EXTENSION';
ALTER TABLE ces.detalle_factura RENAME CONSTRAINT sys_c0018532 TO detalle_factura_pk;


-- Error while generating DDL for (PK) DETALLE_FACTURA_PK. See log file for details.
COMMENT ON COLUMN ces.detalle_factura_ac.renglon IS
    'RENGLON';
COMMENT ON COLUMN ces.detalle_factura_ac.programa IS
    'PROGRAMA';
COMMENT ON COLUMN ces.detalle_factura_ac.id_fact IS
    'ID_FACT';
COMMENT ON COLUMN ces.detalle_factura_ac.tipo_item IS
    'TIPO_ITEM';
COMMENT ON COLUMN ces.detalle_factura_ac.item IS
    'ITEM';
COMMENT ON COLUMN ces.detalle_factura_ac.descripcion IS
    'DESCRIPCION';
COMMENT ON COLUMN ces.detalle_factura_ac.cantidad IS
    'CANTIDAD';
COMMENT ON COLUMN ces.detalle_factura_ac.p_unidad IS
    'P_UNIDAD';
COMMENT ON COLUMN ces.detalle_factura_ac.bs_descuento IS
    'BS_DESCUENTO';
COMMENT ON COLUMN ces.detalle_factura_ac.subtotal IS
    'SUBTOTAL';
COMMENT ON COLUMN ces.detalle_factura_ac.extension IS
    'EXTENSION';
COMMENT ON COLUMN ces.detalle_paquete.id_mat IS
    'ID_MAT';
COMMENT ON COLUMN ces.detalle_paquete.id_paquete IS
    'ID_PAQUETE';
COMMENT ON COLUMN ces.diplo_certi.id_certi IS
    'ID_CERTI';
COMMENT ON COLUMN ces.diplo_certi.descripcion IS
    'DESCRIPCION';
COMMENT ON COLUMN ces.diplo_certi.horas IS
    'HORAS';
COMMENT ON COLUMN ces.diplo_certi.coordinador IS
    'COORDINADOR';
COMMENT ON COLUMN ces.diplo_certi.clase_doc IS
    'CLASE_DOC';
COMMENT ON COLUMN ces.diplo_certi.cod_contable IS
    'COD_CONTABLE';
COMMENT ON COLUMN ces.diplo_temp.id_diplomado IS
    'ID_DIPLOMADO';
COMMENT ON COLUMN ces.diplo_temp.descripcion IS
    'DESCRIPCION';
COMMENT ON COLUMN ces.diplo_temp.horas IS
    'HORAS';
COMMENT ON COLUMN ces.diplo_temp.coordinador IS
    'COORDINADOR';
COMMENT ON COLUMN ces.diplo_temp.modulos IS
    'MODULOS';
COMMENT ON COLUMN ces.diplo_temp.status IS
    'STATUS';
COMMENT ON COLUMN ces.diplo_temp.clase_doc IS
    'CLASE_DOC';
COMMENT ON COLUMN ces.diplo_temp.minimo IS
    'MINIMO';
COMMENT ON COLUMN ces.diplo_temp.maximo IS
    'MAXIMO';
COMMENT ON COLUMN ces.diplo_temp.cod_contable IS
    'COD_CONTABLE';
COMMENT ON COLUMN ces.diplo_temp.cod_descuento IS
    'COD_DESCUENTO';
COMMENT ON COLUMN ces.diplomados.id_diplomado IS
    'ID_DIPLOMADO';
COMMENT ON COLUMN ces.diplomados.descripcion IS
    'DESCRIPCION';
COMMENT ON COLUMN ces.diplomados.horas IS
    'HORAS';
COMMENT ON COLUMN ces.diplomados.coordinador IS
    'COORDINADOR';
COMMENT ON COLUMN ces.diplomados.modulos IS
    'MODULOS';
COMMENT ON COLUMN ces.diplomados.status IS
    'STATUS';
COMMENT ON COLUMN ces.diplomados.clase_doc IS
    'CLASE_DOC';
COMMENT ON COLUMN ces.diplomados.minimo IS
    'MINIMO';
COMMENT ON COLUMN ces.diplomados.maximo IS
    'MAXIMO';
COMMENT ON COLUMN ces.diplomados.cod_contable IS
    'COD_CONTABLE';
COMMENT ON COLUMN ces.diplomados.cod_descuento IS
    'COD_DESCUENTO';


-- Error while generating DDL for DIPLOMADOS_PK. See log file for details.



-- Error while generating DDL for (PK) DIPLOMADOS_PK. See log file for details.

COMMENT ON COLUMN ces.documentos_pru.dc_cia IS
    'DC_CIA';
COMMENT ON COLUMN ces.documentos_pru.dc_tipo IS
    'DC_TIPO';
COMMENT ON COLUMN ces.documentos_pru.dc_clase IS
    'DC_CLASE';
COMMENT ON COLUMN ces.documentos_pru.dc_numero IS
    'DC_NUMERO';
COMMENT ON COLUMN ces.documentos_pru.dc_flgcp IS
    'DC_FLGCP';
COMMENT ON COLUMN ces.documentos_pru.dc_clipro IS
    'DC_CLIPRO';
COMMENT ON COLUMN ces.documentos_pru.dc_referencia IS
    'DC_REFERENCIA';
COMMENT ON COLUMN ces.documentos_pru.dc_fecemi IS
    'DC_FECEMI';
COMMENT ON COLUMN ces.documentos_pru.dc_fecven IS
    'DC_FECVEN';
COMMENT ON COLUMN ces.documentos_pru.dc_monto IS
    'DC_MONTO';
COMMENT ON COLUMN ces.documentos_pru.dc_saldo IS
    'DC_SALDO';
COMMENT ON COLUMN ces.documentos_pru.dc_usrcre IS
    'DC_USRCRE';
COMMENT ON COLUMN ces.documentos_pru.dc_usranul IS
    'DC_USRANUL';
COMMENT ON COLUMN ces.documentos_pru.dc_usrmod IS
    'DC_USRMOD';
COMMENT ON COLUMN ces.documentos_pru.dc_feccre IS
    'DC_FECCRE';
COMMENT ON COLUMN ces.documentos_pru.dc_fecanul IS
    'DC_FECANUL';
COMMENT ON COLUMN ces.documentos_pru.dc_fecmod IS
    'DC_FECMOD';
COMMENT ON COLUMN ces.documentos_pru.dc_feccanc IS
    'DC_FECCANC';
COMMENT ON COLUMN ces.documentos_pru.dc_status IS
    'DC_STATUS';
COMMENT ON COLUMN ces.documentos_pru.dc_piva IS
    'DC_PIVA';
COMMENT ON COLUMN ces.documentos_pru.dc_iva IS
    'DC_IVA';
COMMENT ON COLUMN ces.documentos_pru.dc_banco IS
    'DC_BANCO';
COMMENT ON COLUMN ces.documentos_pru.dc_cobrador IS
    'DC_COBRADOR';
COMMENT ON COLUMN ces.documentos_pru.dc_fpago IS
    'DC_FPAGO';
COMMENT ON COLUMN ces.documentos_pru.dc_numref IS
    'DC_NUMREF';
COMMENT ON COLUMN ces.documentos_pru.dc_ciudad IS
    'DC_CIUDAD';
COMMENT ON COLUMN ces.documentos_pru.dc_fecref IS
    'DC_FECREF';
COMMENT ON COLUMN ces.documentos_pru.dc_tasacam IS
    'DC_TASACAM';
COMMENT ON COLUMN ces.documentos_pru.dc_moneda IS
    'DC_MONEDA';
COMMENT ON COLUMN ces.documentos_pru.dc_auxiliar IS
    'DC_AUXILIAR';
COMMENT ON COLUMN ces.documentos_pru.dc_beneficiario IS
    'DC_BENEFICIARIO';
COMMENT ON COLUMN ces.documentos_pru.dc_statusc IS
    'DC_STATUSC';
COMMENT ON COLUMN ces.documentos_pru.dc_nrofac IS
    'DC_NROFAC';
ALTER TABLE ces.documentos_pru RENAME CONSTRAINT sys_c0018544 TO documentos_pru_pk;


-- Error while generating DDL for (PK) DOCUMENTOS_PRU_PK. See log file for details.
COMMENT ON COLUMN ces.documentos_trf.dc_cia IS
    'DC_CIA';
COMMENT ON COLUMN ces.documentos_trf.dc_tipo IS
    'DC_TIPO';
COMMENT ON COLUMN ces.documentos_trf.dc_clase IS
    'DC_CLASE';
COMMENT ON COLUMN ces.documentos_trf.dc_numero IS
    'DC_NUMERO';
COMMENT ON COLUMN ces.documentos_trf.dc_flgcp IS
    'DC_FLGCP';
COMMENT ON COLUMN ces.documentos_trf.dc_clipro IS
    'DC_CLIPRO';
COMMENT ON COLUMN ces.documentos_trf.dc_referencia IS
    'DC_REFERENCIA';
COMMENT ON COLUMN ces.documentos_trf.dc_fecemi IS
    'DC_FECEMI';
COMMENT ON COLUMN ces.documentos_trf.dc_fecven IS
    'DC_FECVEN';
COMMENT ON COLUMN ces.documentos_trf.dc_monto IS
    'DC_MONTO';
COMMENT ON COLUMN ces.documentos_trf.dc_saldo IS
    'DC_SALDO';
COMMENT ON COLUMN ces.documentos_trf.dc_usrcre IS
    'DC_USRCRE';
COMMENT ON COLUMN ces.documentos_trf.dc_usranul IS
    'DC_USRANUL';
COMMENT ON COLUMN ces.documentos_trf.dc_usrmod IS
    'DC_USRMOD';
COMMENT ON COLUMN ces.documentos_trf.dc_feccre IS
    'DC_FECCRE';
COMMENT ON COLUMN ces.documentos_trf.dc_fecanul IS
    'DC_FECANUL';
COMMENT ON COLUMN ces.documentos_trf.dc_fecmod IS
    'DC_FECMOD';
COMMENT ON COLUMN ces.documentos_trf.dc_feccanc IS
    'DC_FECCANC';
COMMENT ON COLUMN ces.documentos_trf.dc_status IS
    'DC_STATUS';
COMMENT ON COLUMN ces.documentos_trf.dc_piva IS
    'DC_PIVA';
COMMENT ON COLUMN ces.documentos_trf.dc_iva IS
    'DC_IVA';
COMMENT ON COLUMN ces.documentos_trf.dc_banco IS
    'DC_BANCO';
COMMENT ON COLUMN ces.documentos_trf.dc_cobrador IS
    'DC_COBRADOR';
COMMENT ON COLUMN ces.documentos_trf.dc_fpago IS
    'DC_FPAGO';
COMMENT ON COLUMN ces.documentos_trf.dc_numref IS
    'DC_NUMREF';
COMMENT ON COLUMN ces.documentos_trf.dc_ciudad IS
    'DC_CIUDAD';
COMMENT ON COLUMN ces.documentos_trf.dc_fecref IS
    'DC_FECREF';
COMMENT ON COLUMN ces.documentos_trf.dc_tasacam IS
    'DC_TASACAM';
COMMENT ON COLUMN ces.documentos_trf.dc_moneda IS
    'DC_MONEDA';
COMMENT ON COLUMN ces.documentos_trf.dc_auxiliar IS
    'DC_AUXILIAR';
COMMENT ON COLUMN ces.documentos_trf.dc_beneficiario IS
    'DC_BENEFICIARIO';
COMMENT ON COLUMN ces.documentos_trf.dc_statusc IS
    'DC_STATUSC';
COMMENT ON COLUMN ces.documentos_trf.dc_nrofac IS
    'DC_NROFAC';


-- Error while generating DDL for PK_DOCUMENTOS. See log file for details.



-- Error while generating DDL for (PK) PK_DOCUMENTOS. See log file for details.

COMMENT ON COLUMN ces.documentos_x.dc_cia IS
    'DC_CIA';
COMMENT ON COLUMN ces.documentos_x.dc_tipo IS
    'DC_TIPO';
COMMENT ON COLUMN ces.documentos_x.dc_clase IS
    'DC_CLASE';
COMMENT ON COLUMN ces.documentos_x.dc_numero IS
    'DC_NUMERO';
COMMENT ON COLUMN ces.documentos_x.dc_flgcp IS
    'DC_FLGCP';
COMMENT ON COLUMN ces.documentos_x.dc_clipro IS
    'DC_CLIPRO';
COMMENT ON COLUMN ces.documentos_x.dc_referencia IS
    'DC_REFERENCIA';
COMMENT ON COLUMN ces.documentos_x.dc_fecemi IS
    'DC_FECEMI';
COMMENT ON COLUMN ces.documentos_x.dc_fecven IS
    'DC_FECVEN';
COMMENT ON COLUMN ces.documentos_x.dc_monto IS
    'DC_MONTO';
COMMENT ON COLUMN ces.documentos_x.dc_saldo IS
    'DC_SALDO';
COMMENT ON COLUMN ces.documentos_x.dc_usrcre IS
    'DC_USRCRE';
COMMENT ON COLUMN ces.documentos_x.dc_usranul IS
    'DC_USRANUL';
COMMENT ON COLUMN ces.documentos_x.dc_usrmod IS
    'DC_USRMOD';
COMMENT ON COLUMN ces.documentos_x.dc_feccre IS
    'DC_FECCRE';
COMMENT ON COLUMN ces.documentos_x.dc_fecanul IS
    'DC_FECANUL';
COMMENT ON COLUMN ces.documentos_x.dc_fecmod IS
    'DC_FECMOD';
COMMENT ON COLUMN ces.documentos_x.dc_feccanc IS
    'DC_FECCANC';
COMMENT ON COLUMN ces.documentos_x.dc_status IS
    'DC_STATUS';
COMMENT ON COLUMN ces.documentos_x.dc_piva IS
    'DC_PIVA';
COMMENT ON COLUMN ces.documentos_x.dc_iva IS
    'DC_IVA';
COMMENT ON COLUMN ces.documentos_x.dc_banco IS
    'DC_BANCO';
COMMENT ON COLUMN ces.documentos_x.dc_cobrador IS
    'DC_COBRADOR';
COMMENT ON COLUMN ces.documentos_x.dc_fpago IS
    'DC_FPAGO';
COMMENT ON COLUMN ces.documentos_x.dc_numref IS
    'DC_NUMREF';
COMMENT ON COLUMN ces.documentos_x.dc_ciudad IS
    'DC_CIUDAD';
COMMENT ON COLUMN ces.documentos_x.dc_fecref IS
    'DC_FECREF';
COMMENT ON COLUMN ces.documentos_x.dc_tasacam IS
    'DC_TASACAM';
COMMENT ON COLUMN ces.documentos_x.dc_moneda IS
    'DC_MONEDA';
COMMENT ON COLUMN ces.documentos_x.dc_auxiliar IS
    'DC_AUXILIAR';
COMMENT ON COLUMN ces.documentos_x.dc_beneficiario IS
    'DC_BENEFICIARIO';
COMMENT ON COLUMN ces.documentos_x.dc_statusc IS
    'DC_STATUSC';
COMMENT ON COLUMN ces.documentos_x.dc_nrofac IS
    'DC_NROFAC';
COMMENT ON COLUMN ces.edificios.id_edif IS
    'ID_EDIF';
COMMENT ON COLUMN ces.edificios.descripcion IS
    'DESCRIPCION';
COMMENT ON COLUMN ces.empresa_tipo.rif IS
    'RIF';
COMMENT ON COLUMN ces.empresa_tipo.tipo IS
    'TIPO';


-- Error while generating DDL for EMPRESA_TIPO_PK. See log file for details.



-- Error while generating DDL for (PK) EMPRESA_TIPO_PK. See log file for details.

COMMENT ON COLUMN ces.empresas.rif IS
    'RIF';
COMMENT ON COLUMN ces.empresas.razon IS
    'RAZON';
COMMENT ON COLUMN ces.empresas.direccion IS
    'DIRECCION';
COMMENT ON COLUMN ces.empresas.telefono IS
    'TELEFONO';
ALTER TABLE ces.empresas RENAME CONSTRAINT sys_c0018547 TO empresas_pk;


-- Error while generating DDL for (PK) EMPRESAS_PK. See log file for details.
COMMENT ON COLUMN ces.errores.nro_msg IS
    'NRO_MSG';
COMMENT ON COLUMN ces.errores.codigo IS
    'CODIGO';
COMMENT ON COLUMN ces.errores.msgtxt IS
    'MSGTXT';


-- Error while generating DDL for UN_ERR. See log file for details.

ALTER TABLE ces.errores RENAME CONSTRAINT sys_c0018551 TO errores_pk;


-- Error while generating DDL for (PK) ERRORES_PK. See log file for details.
COMMENT ON COLUMN ces.estados.id_estado IS
    'ID_ESTADO';
COMMENT ON COLUMN ces.estados.nombre IS
    'NOMBRE';
ALTER TABLE ces.estados RENAME CONSTRAINT sys_c0018552 TO estados_pk;


-- Error while generating DDL for (PK) ESTADOS_PK. See log file for details.
COMMENT ON COLUMN ces.estudiante.matricula IS
    'MATRICULA';
COMMENT ON COLUMN ces.estudiante.cedula_est IS
    'CEDULA_EST';
COMMENT ON COLUMN ces.estudiante.nacionalidad IS
    'NACIONALIDAD';
COMMENT ON COLUMN ces.estudiante.nombre IS
    'NOMBRE';
COMMENT ON COLUMN ces.estudiante.telf_hab IS
    'TELF_HAB';
COMMENT ON COLUMN ces.estudiante.telf_cel IS
    'TELF_CEL';
COMMENT ON COLUMN ces.estudiante.ciudad IS
    'CIUDAD';
COMMENT ON COLUMN ces.estudiante.estado IS
    'ESTADO';
COMMENT ON COLUMN ces.estudiante.email IS
    'EMAIL';
COMMENT ON COLUMN ces.estudiante.sexo IS
    'SEXO';
COMMENT ON COLUMN ces.estudiante.edo_civil IS
    'EDO_CIVIL';
COMMENT ON COLUMN ces.estudiante.grado_ins IS
    'GRADO_INS';
COMMENT ON COLUMN ces.estudiante.profesion IS
    'PROFESION';
COMMENT ON COLUMN ces.estudiante.fecha_nac IS
    'FECHA_NAC';
COMMENT ON COLUMN ces.estudiante.status IS
    'STATUS';
COMMENT ON COLUMN ces.estudiante.id_tipo_est IS
    'ID_TIPO_EST';
COMMENT ON COLUMN ces.estudiante.rif IS
    'RIF';
COMMENT ON COLUMN ces.estudiante.sede IS
    'SEDE';
COMMENT ON COLUMN ces.estudiante.condicion_especial IS
    'CONDICION_ESPECIAL';
COMMENT ON COLUMN ces.estudiante.apellido IS
    'APELLIDO';
COMMENT ON COLUMN ces.estudiante.zona IS
    'ZONA';
COMMENT ON COLUMN ces.estudiante.cedula_rep IS
    'CEDULA_REP';
COMMENT ON COLUMN ces.estudiante.direccion IS
    'DIRECCION';


-- Error while generating DDL for IDX_CEDULA_EST_UN. See log file for details.



-- Error while generating DDL for PK_ESTUDIANTE. See log file for details.



-- Error while generating DDL for (PK) PK_ESTUDIANTE. See log file for details.

COMMENT ON COLUMN ces.eventos.id_evento IS
    'ID_EVENTO';
COMMENT ON COLUMN ces.eventos.descripcion IS
    'DESCRIPCION';
COMMENT ON COLUMN ces.eventos.in_curso IS
    'IN_CURSO';
COMMENT ON COLUMN ces.eventos.in_seccion IS
    'IN_SECCION';
COMMENT ON COLUMN ces.eventos.in_monto IS
    'IN_MONTO';
COMMENT ON COLUMN ces.eventos.in_cantidad IS
    'IN_CANTIDAD';
COMMENT ON COLUMN ces.eventos.in_evaluacion IS
    'IN_EVALUACION';
ALTER TABLE ces.eventos RENAME CONSTRAINT sys_c0018558 TO eventos_pk;


-- Error while generating DDL for (PK) EVENTOS_PK. See log file for details.
COMMENT ON COLUMN ces.factura.id_fact IS
    'ID_FACT';
COMMENT ON COLUMN ces.factura.tipo IS
    'TIPO';
COMMENT ON COLUMN ces.factura.cedula_est IS
    'CEDULA_EST';
COMMENT ON COLUMN ces.factura.nombre_cliente IS
    'NOMBRE_CLIENTE';
COMMENT ON COLUMN ces.factura.vendedor IS
    'VENDEDOR';
COMMENT ON COLUMN ces.factura.fecha_emi IS
    'FECHA_EMI';
COMMENT ON COLUMN ces.factura.monto IS
    'MONTO';
COMMENT ON COLUMN ces.factura.p_iva IS
    'P_IVA';
COMMENT ON COLUMN ces.factura.monto_iva IS
    'MONTO_IVA';
COMMENT ON COLUMN ces.factura.flete IS
    'FLETE';
COMMENT ON COLUMN ces.factura.bs_descuento IS
    'BS_DESCUENTO';
COMMENT ON COLUMN ces.factura.dir_fiscal IS
    'DIR_FISCAL';
COMMENT ON COLUMN ces.factura.rif IS
    'RIF';
COMMENT ON COLUMN ces.factura.status IS
    'STATUS';
COMMENT ON COLUMN ces.factura.caja IS
    'CAJA';
COMMENT ON COLUMN ces.factura.exceso IS
    'EXCESO';
COMMENT ON COLUMN ces.factura.programa IS
    'PROGRAMA';
COMMENT ON COLUMN ces.factura.contabilidad IS
    'CONTABILIDAD';
COMMENT ON COLUMN ces.factura.nombre_est IS
    'NOMBRE_EST';
COMMENT ON COLUMN ces.factura.prog_academico IS
    'PROG_ACADEMICO';
COMMENT ON COLUMN ces.factura.usuario IS
    'USUARIO';
COMMENT ON COLUMN ces.factura.monto_exento IS
    'MONTO_EXENTO';
COMMENT ON COLUMN ces.factura.base_imponible IS
    'BASE_IMPONIBLE';


-- Error while generating DDL for PK_FACT. See log file for details.



-- Error while generating DDL for (PK) PK_FACT. See log file for details.

COMMENT ON COLUMN ces.factura_ac.id_fact IS
    'ID_FACT';
COMMENT ON COLUMN ces.factura_ac.tipo IS
    'TIPO';
COMMENT ON COLUMN ces.factura_ac.cedula_est IS
    'CEDULA_EST';
COMMENT ON COLUMN ces.factura_ac.nombre_cliente IS
    'NOMBRE_CLIENTE';
COMMENT ON COLUMN ces.factura_ac.vendedor IS
    'VENDEDOR';
COMMENT ON COLUMN ces.factura_ac.fecha_emi IS
    'FECHA_EMI';
COMMENT ON COLUMN ces.factura_ac.monto IS
    'MONTO';
COMMENT ON COLUMN ces.factura_ac.p_iva IS
    'P_IVA';
COMMENT ON COLUMN ces.factura_ac.monto_iva IS
    'MONTO_IVA';
COMMENT ON COLUMN ces.factura_ac.flete IS
    'FLETE';
COMMENT ON COLUMN ces.factura_ac.bs_descuento IS
    'BS_DESCUENTO';
COMMENT ON COLUMN ces.factura_ac.dir_fiscal IS
    'DIR_FISCAL';
COMMENT ON COLUMN ces.factura_ac.rif IS
    'RIF';
COMMENT ON COLUMN ces.factura_ac.status IS
    'STATUS';
COMMENT ON COLUMN ces.factura_ac.caja IS
    'CAJA';
COMMENT ON COLUMN ces.factura_ac.exceso IS
    'EXCESO';
COMMENT ON COLUMN ces.factura_ac.programa IS
    'PROGRAMA';
COMMENT ON COLUMN ces.factura_ac.contabilidad IS
    'CONTABILIDAD';
COMMENT ON COLUMN ces.factura_ac.nombre_est IS
    'NOMBRE_EST';
COMMENT ON COLUMN ces.factura_ac.prog_academico IS
    'PROG_ACADEMICO';
COMMENT ON COLUMN ces.factura_ac.usuario IS
    'USUARIO';
COMMENT ON COLUMN ces.factura_deposito.id_fact IS
    'ID_FACT';
COMMENT ON COLUMN ces.factura_deposito.referencia IS
    'REFERENCIA';
COMMENT ON COLUMN ces.factura_deposito.id_banco IS
    'ID_BANCO';
COMMENT ON COLUMN ces.factura_deposito.forma_pago IS
    'FORMA_PAGO';
COMMENT ON COLUMN ces.factura_deposito.manual IS
    'MANUAL';
COMMENT ON COLUMN ces.factura_deposito.fecha_cre IS
    'FECHA_CRE';
COMMENT ON COLUMN ces.factura_deposito.programa IS
    'PROGRAMA';


-- Error while generating DDL for PK_FACDEP. See log file for details.



-- Error while generating DDL for (PK) PK_FACDEP. See log file for details.

COMMENT ON COLUMN ces.ficha_academica.renglon IS
    'RENGLON';
COMMENT ON COLUMN ces.ficha_academica.id_evento IS
    'ID_EVENTO';
COMMENT ON COLUMN ces.ficha_academica.fecha IS
    'FECHA';
COMMENT ON COLUMN ces.ficha_academica.calificacion IS
    'CALIFICACION';
COMMENT ON COLUMN ces.ficha_academica.observacion IS
    'OBSERVACION';
COMMENT ON COLUMN ces.ficha_academica.id_seccion IS
    'ID_SECCION';
COMMENT ON COLUMN ces.ficha_academica.id_curso IS
    'ID_CURSO';
COMMENT ON COLUMN ces.ficha_academica.matricula IS
    'MATRICULA';
COMMENT ON COLUMN ces.ficha_academica.status IS
    'STATUS';
COMMENT ON COLUMN ces.ficha_academica.fec_inicio IS
    'FEC_INICIO';
ALTER TABLE ces.ficha_academica RENAME CONSTRAINT sys_c0018564 TO ficha_academica_pk;


-- Error while generating DDL for (PK) FICHA_ACADEMICA_PK. See log file for details.
COMMENT ON COLUMN ces.ficha_academica_bak.renglon IS
    'RENGLON';
COMMENT ON COLUMN ces.ficha_academica_bak.id_evento IS
    'ID_EVENTO';
COMMENT ON COLUMN ces.ficha_academica_bak.fecha IS
    'FECHA';
COMMENT ON COLUMN ces.ficha_academica_bak.calificacion IS
    'CALIFICACION';
COMMENT ON COLUMN ces.ficha_academica_bak.observacion IS
    'OBSERVACION';
COMMENT ON COLUMN ces.ficha_academica_bak.id_seccion IS
    'ID_SECCION';
COMMENT ON COLUMN ces.ficha_academica_bak.id_curso IS
    'ID_CURSO';
COMMENT ON COLUMN ces.ficha_academica_bak.matricula IS
    'MATRICULA';
COMMENT ON COLUMN ces.ficha_academica_bak.status IS
    'STATUS';
COMMENT ON COLUMN ces.ficha_academica_bak.fec_inicio IS
    'FEC_INICIO';
COMMENT ON COLUMN ces.ficha_pago.renglon IS
    'RENGLON';
COMMENT ON COLUMN ces.ficha_pago.id_evento IS
    'ID_EVENTO';
COMMENT ON COLUMN ces.ficha_pago.fecha IS
    'FECHA';
COMMENT ON COLUMN ces.ficha_pago.monto IS
    'MONTO';
COMMENT ON COLUMN ces.ficha_pago.programa IS
    'PROGRAMA';
COMMENT ON COLUMN ces.ficha_pago.id_fact IS
    'ID_FACT';
COMMENT ON COLUMN ces.ficha_pago.observacion IS
    'OBSERVACION';
COMMENT ON COLUMN ces.ficha_pago.cuota_o_libro IS
    'CUOTA_O_LIBRO';
COMMENT ON COLUMN ces.ficha_pago.matricula IS
    'MATRICULA';
COMMENT ON COLUMN ces.ficha_pago.status IS
    'STATUS';
COMMENT ON COLUMN ces.ficha_pago.nivel IS
    'NIVEL';
ALTER TABLE ces.ficha_pago RENAME CONSTRAINT sys_c0018569 TO ficha_pago_pk;


-- Error while generating DDL for (PK) FICHA_PAGO_PK. See log file for details.
COMMENT ON COLUMN ces.ficha_pago_ac.renglon IS
    'RENGLON';
COMMENT ON COLUMN ces.ficha_pago_ac.id_evento IS
    'ID_EVENTO';
COMMENT ON COLUMN ces.ficha_pago_ac.fecha IS
    'FECHA';
COMMENT ON COLUMN ces.ficha_pago_ac.monto IS
    'MONTO';
COMMENT ON COLUMN ces.ficha_pago_ac.programa IS
    'PROGRAMA';
COMMENT ON COLUMN ces.ficha_pago_ac.id_fact IS
    'ID_FACT';
COMMENT ON COLUMN ces.ficha_pago_ac.observacion IS
    'OBSERVACION';
COMMENT ON COLUMN ces.ficha_pago_ac.cuota_o_libro IS
    'CUOTA_O_LIBRO';
COMMENT ON COLUMN ces.ficha_pago_ac.matricula IS
    'MATRICULA';
COMMENT ON COLUMN ces.ficha_pago_ac.status IS
    'STATUS';
COMMENT ON COLUMN ces.ficha_pago_ac.nivel IS
    'NIVEL';
COMMENT ON COLUMN ces.ficha_pago_cfp.renglon IS
    'RENGLON';
COMMENT ON COLUMN ces.ficha_pago_cfp.id_evento IS
    'ID_EVENTO';
COMMENT ON COLUMN ces.ficha_pago_cfp.fecha IS
    'FECHA';
COMMENT ON COLUMN ces.ficha_pago_cfp.monto IS
    'MONTO';
COMMENT ON COLUMN ces.ficha_pago_cfp.programa IS
    'PROGRAMA';
COMMENT ON COLUMN ces.ficha_pago_cfp.id_fact IS
    'ID_FACT';
COMMENT ON COLUMN ces.ficha_pago_cfp.observacion IS
    'OBSERVACION';
COMMENT ON COLUMN ces.ficha_pago_cfp.matricula IS
    'MATRICULA';
COMMENT ON COLUMN ces.ficha_pago_cfp.ult_cuota IS
    'ULT_CUOTA';
COMMENT ON COLUMN ces.ficha_pago_cfp.status IS
    'STATUS';
COMMENT ON COLUMN ces.ficha_pago_cfp.acumulado IS
    'ACUMULADO';
COMMENT ON COLUMN ces.ficha_pago_cfp.id_diplomado IS
    'ID_DIPLOMADO';
ALTER TABLE ces.ficha_pago_cfp RENAME CONSTRAINT sys_c0018576 TO ficha_pago_cfp_pk;


-- Error while generating DDL for (PK) FICHA_PAGO_CFP_PK. See log file for details.
COMMENT ON COLUMN ces.forma_pago.id_pago IS
    'ID_PAGO';
COMMENT ON COLUMN ces.forma_pago.descripcion IS
    'DESCRIPCION';
COMMENT ON COLUMN ces.forma_pago.vencimiento IS
    'VENCIMIENTO';
COMMENT ON COLUMN ces.forma_pago.tipo IS
    'TIPO';
ALTER TABLE ces.forma_pago RENAME CONSTRAINT sys_c0018578 TO forma_pago_pk;


-- Error while generating DDL for (PK) FORMA_PAGO_PK. See log file for details.
COMMENT ON COLUMN ces.horario_diplomado.id_diplomado IS
    'ID_DIPLOMADO';
COMMENT ON COLUMN ces.horario_diplomado.id_horario IS
    'ID_HORARIO';
COMMENT ON COLUMN ces.horario_diplomado.id_modalidad IS
    'ID_MODALIDAD';


-- Error while generating DDL for PK_HD. See log file for details.



-- Error while generating DDL for (PK) PK_HD. See log file for details.

COMMENT ON COLUMN ces.horario_temp.id_horario IS
    'ID_HORARIO';
COMMENT ON COLUMN ces.horario_temp.hora IS
    'HORA';
COMMENT ON COLUMN ces.horario_temp.modalidad IS
    'MODALIDAD';
COMMENT ON COLUMN ces.horario_temp.hora_fin IS
    'HORA_FIN';
COMMENT ON COLUMN ces.horarios.id_horario IS
    'ID_HORARIO';
COMMENT ON COLUMN ces.horarios.hora IS
    'HORA';
COMMENT ON COLUMN ces.horarios.modalidad IS
    'MODALIDAD';
COMMENT ON COLUMN ces.horarios.hora_fin IS
    'HORA_FIN';


-- Error while generating DDL for PK_HORARIOS. See log file for details.



-- Error while generating DDL for (PK) PK_HORARIOS. See log file for details.

COMMENT ON COLUMN ces.htmldb_plan_table.statement_id IS
    'STATEMENT_ID';
COMMENT ON COLUMN ces.htmldb_plan_table.plan_id IS
    'PLAN_ID';
COMMENT ON COLUMN ces.htmldb_plan_table.timestamp IS
    'TIMESTAMP';
COMMENT ON COLUMN ces.htmldb_plan_table.remarks IS
    'REMARKS';
COMMENT ON COLUMN ces.htmldb_plan_table.operation IS
    'OPERATION';
COMMENT ON COLUMN ces.htmldb_plan_table.options IS
    'OPTIONS';
COMMENT ON COLUMN ces.htmldb_plan_table.object_node IS
    'OBJECT_NODE';
COMMENT ON COLUMN ces.htmldb_plan_table.object_owner IS
    'OBJECT_OWNER';
COMMENT ON COLUMN ces.htmldb_plan_table.object_name IS
    'OBJECT_NAME';
COMMENT ON COLUMN ces.htmldb_plan_table.object_alias IS
    'OBJECT_ALIAS';
COMMENT ON COLUMN ces.htmldb_plan_table.object_instance IS
    'OBJECT_INSTANCE';
COMMENT ON COLUMN ces.htmldb_plan_table.object_type IS
    'OBJECT_TYPE';
COMMENT ON COLUMN ces.htmldb_plan_table.optimizer IS
    'OPTIMIZER';
COMMENT ON COLUMN ces.htmldb_plan_table.search_columns IS
    'SEARCH_COLUMNS';
COMMENT ON COLUMN ces.htmldb_plan_table.id IS
    'ID';
COMMENT ON COLUMN ces.htmldb_plan_table.parent_id IS
    'PARENT_ID';
COMMENT ON COLUMN ces.htmldb_plan_table.depth IS
    'DEPTH';
COMMENT ON COLUMN ces.htmldb_plan_table.position IS
    'POSITION';
COMMENT ON COLUMN ces.htmldb_plan_table.cost IS
    'COST';
COMMENT ON COLUMN ces.htmldb_plan_table.cardinality IS
    'CARDINALITY';
COMMENT ON COLUMN ces.htmldb_plan_table.bytes IS
    'BYTES';
COMMENT ON COLUMN ces.htmldb_plan_table.other_tag IS
    'OTHER_TAG';
COMMENT ON COLUMN ces.htmldb_plan_table.partition_start IS
    'PARTITION_START';
COMMENT ON COLUMN ces.htmldb_plan_table.partition_stop IS
    'PARTITION_STOP';
COMMENT ON COLUMN ces.htmldb_plan_table.partition_id IS
    'PARTITION_ID';
COMMENT ON COLUMN ces.htmldb_plan_table.other IS
    'OTHER';
COMMENT ON COLUMN ces.htmldb_plan_table.distribution IS
    'DISTRIBUTION';
COMMENT ON COLUMN ces.htmldb_plan_table.cpu_cost IS
    'CPU_COST';
COMMENT ON COLUMN ces.htmldb_plan_table.io_cost IS
    'IO_COST';
COMMENT ON COLUMN ces.htmldb_plan_table.temp_space IS
    'TEMP_SPACE';
COMMENT ON COLUMN ces.htmldb_plan_table.access_predicates IS
    'ACCESS_PREDICATES';
COMMENT ON COLUMN ces.htmldb_plan_table.filter_predicates IS
    'FILTER_PREDICATES';
COMMENT ON COLUMN ces.htmldb_plan_table.projection IS
    'PROJECTION';
COMMENT ON COLUMN ces.htmldb_plan_table.time IS
    'TIME';
COMMENT ON COLUMN ces.htmldb_plan_table.qblock_name IS
    'QBLOCK_NAME';
COMMENT ON COLUMN ces.mat_new.id_mat IS
    'ID_MAT';
COMMENT ON COLUMN ces.mat_new.tipo IS
    'TIPO';
COMMENT ON COLUMN ces.mat_new.descripcion IS
    'DESCRIPCION';
COMMENT ON COLUMN ces.materiales.id_mat IS
    'ID_MAT';
COMMENT ON COLUMN ces.materiales.tipo IS
    'TIPO';
COMMENT ON COLUMN ces.materiales.descripcion IS
    'DESCRIPCION';
COMMENT ON COLUMN ces.materiales.id_curso IS
    'ID_CURSO';
COMMENT ON COLUMN ces.materiales.evento IS
    'EVENTO';
COMMENT ON COLUMN ces.materiales.nivel IS
    'NIVEL';
COMMENT ON COLUMN ces.materiales.iva_exento IS
    'IVA_EXENTO';
COMMENT ON COLUMN ces.materiales.activo IS
    'ACTIVO';
ALTER TABLE ces.materiales RENAME CONSTRAINT sys_c0018582 TO materiales_pk;


-- Error while generating DDL for (PK) MATERIALES_PK. See log file for details.
COMMENT ON COLUMN ces.materiales_bak.id_mat IS
    'ID_MAT';
COMMENT ON COLUMN ces.materiales_bak.tipo IS
    'TIPO';
COMMENT ON COLUMN ces.materiales_bak.descripcion IS
    'DESCRIPCION';
COMMENT ON COLUMN ces.materiales_bak.id_curso IS
    'ID_CURSO';
COMMENT ON COLUMN ces.materiales_bak.evento IS
    'EVENTO';
COMMENT ON COLUMN ces.materiales_bak.nivel IS
    'NIVEL';
COMMENT ON COLUMN ces.materiales_bak.iva_exento IS
    'IVA_EXENTO';
COMMENT ON COLUMN ces.materiales_bak.activo IS
    'ACTIVO';
COMMENT ON COLUMN ces.metodos.id_metodo IS
    'ID_METODO';
COMMENT ON COLUMN ces.metodos.descripcion IS
    'DESCRIPCION';
COMMENT ON COLUMN ces.metodos.idioma IS
    'IDIOMA';
COMMENT ON COLUMN ces.metodos.niveles IS
    'NIVELES';
COMMENT ON COLUMN ces.metodos.evaluaciones IS
    'EVALUACIONES';
COMMENT ON COLUMN ces.metodos.diurno IS
    'DIURNO';
COMMENT ON COLUMN ces.metodos.nocturno IS
    'NOCTURNO';
COMMENT ON COLUMN ces.metodos.sabatino IS
    'SABATINO';
COMMENT ON COLUMN ces.metodos.id_calendario IS
    'ID_CALENDARIO';
COMMENT ON COLUMN ces.metodos.prog_academico IS
    'PROG_ACADEMICO';
COMMENT ON COLUMN ces.metodos.cuotas IS
    'CUOTAS';


-- Error while generating DDL for PK_METODO. See log file for details.



-- Error while generating DDL for (PK) PK_METODO. See log file for details.

COMMENT ON COLUMN ces.modalidades.id_modalidad IS
    'ID_MODALIDAD';
COMMENT ON COLUMN ces.modalidades.descripcion IS
    'DESCRIPCION';
COMMENT ON COLUMN ces.modulos_diplomado.id_diplomado IS
    'ID_DIPLOMADO';
COMMENT ON COLUMN ces.modulos_diplomado.modulo IS
    'MODULO';
COMMENT ON COLUMN ces.modulos_diplomado.descripcion IS
    'DESCRIPCION';
COMMENT ON COLUMN ces.modulos_diplomado.facilitador IS
    'FACILITADOR';
COMMENT ON COLUMN ces.modulos_diplomado.duracion IS
    'DURACION';
COMMENT ON COLUMN ces.modulos_diplomado.num_clases IS
    'NUM_CLASES';


-- Error while generating DDL for PK_MOD_CFP. See log file for details.



-- Error while generating DDL for (PK) PK_MOD_CFP. See log file for details.

COMMENT ON COLUMN ces.niveles.id_metodo IS
    'ID_METODO';
COMMENT ON COLUMN ces.niveles.nivel IS
    'NIVEL';
COMMENT ON COLUMN ces.niveles.horas IS
    'HORAS';
COMMENT ON COLUMN ces.niveles.nota_minima IS
    'NOTA_MINIMA';
COMMENT ON COLUMN ces.niveles.abrev IS
    'ABREV';


-- Error while generating DDL for PK_NIVEL. See log file for details.



-- Error while generating DDL for (PK) PK_NIVEL. See log file for details.

COMMENT ON COLUMN ces.ocupaciones.id_ocupacion IS
    'ID_OCUPACION';
COMMENT ON COLUMN ces.ocupaciones.nombre IS
    'NOMBRE';
ALTER TABLE ces.ocupaciones RENAME CONSTRAINT sys_c0018591 TO ocupaciones_pk;


-- Error while generating DDL for (PK) OCUPACIONES_PK. See log file for details.
COMMENT ON COLUMN ces.paquetes.id_paquete IS
    'ID_PAQUETE';
COMMENT ON COLUMN ces.paquetes.descripcion IS
    'DESCRIPCION';
ALTER TABLE ces.paquetes RENAME CONSTRAINT sys_c0018592 TO paquetes_pk;


-- Error while generating DDL for (PK) PAQUETES_PK. See log file for details.
COMMENT ON COLUMN ces.ponderacion_niveles.nivel IS
    'NIVEL';
COMMENT ON COLUMN ces.ponderacion_niveles.porcentaje IS
    'PORCENTAJE';
COMMENT ON COLUMN ces.ponderacion_niveles.id_metodo IS
    'ID_METODO';
COMMENT ON COLUMN ces.precios.item IS
    'ITEM';
COMMENT ON COLUMN ces.precios.tipo_item IS
    'TIPO_ITEM';
COMMENT ON COLUMN ces.precios.fecha IS
    'FECHA';
COMMENT ON COLUMN ces.precios.precio1 IS
    'PRECIO1';
COMMENT ON COLUMN ces.precios.precio2 IS
    'PRECIO2';
COMMENT ON COLUMN ces.precios.precio3 IS
    'PRECIO3';
COMMENT ON COLUMN ces.precios.status IS
    'STATUS';
COMMENT ON COLUMN ces.precios.precio4 IS
    'PRECIO4';
COMMENT ON COLUMN ces.precios.precio5 IS
    'PRECIO5';


-- Error while generating DDL for PK_PRECIOS. See log file for details.



-- Error while generating DDL for (PK) PK_PRECIOS. See log file for details.

COMMENT ON COLUMN ces.profesor.cedula_prof IS
    'CEDULA_PROF';
COMMENT ON COLUMN ces.profesor.nacionalidad IS
    'NACIONALIDAD';
COMMENT ON COLUMN ces.profesor.nombre IS
    'NOMBRE';
COMMENT ON COLUMN ces.profesor.telf_hab IS
    'TELF_HAB';
COMMENT ON COLUMN ces.profesor.telf_cel IS
    'TELF_CEL';
COMMENT ON COLUMN ces.profesor.ciudad IS
    'CIUDAD';
COMMENT ON COLUMN ces.profesor.estado IS
    'ESTADO';
COMMENT ON COLUMN ces.profesor.email IS
    'EMAIL';
COMMENT ON COLUMN ces.profesor.sexo IS
    'SEXO';
COMMENT ON COLUMN ces.profesor.edo_civil IS
    'EDO_CIVIL';
COMMENT ON COLUMN ces.profesor.grado_ins IS
    'GRADO_INS';
COMMENT ON COLUMN ces.profesor.profesion IS
    'PROFESION';
COMMENT ON COLUMN ces.profesor.fecha_nac IS
    'FECHA_NAC';
COMMENT ON COLUMN ces.profesor.status IS
    'STATUS';
COMMENT ON COLUMN ces.profesor.id_tipo_prof IS
    'ID_TIPO_PROF';
COMMENT ON COLUMN ces.profesor.rif IS
    'RIF';
COMMENT ON COLUMN ces.profesor.sede IS
    'SEDE';
COMMENT ON COLUMN ces.profesor.apellido IS
    'APELLIDO';
COMMENT ON COLUMN ces.profesor.zona IS
    'ZONA';
ALTER TABLE ces.profesor RENAME CONSTRAINT sys_c0018599 TO profesor_pk;


-- Error while generating DDL for (PK) PROFESOR_PK. See log file for details.
COMMENT ON COLUMN ces.programa_academico.id IS
    'ID';
COMMENT ON COLUMN ces.programa_academico.descripcion IS
    'DESCRIPCION';
COMMENT ON COLUMN ces.programa_academico.activo IS
    'ACTIVO';
ALTER TABLE ces.programa_academico RENAME CONSTRAINT sys_c0018602 TO programa_academico_pk;


-- Error while generating DDL for (PK) PROGRAMA_ACADEMICO_PK. See log file for details.
COMMENT ON COLUMN ces.programas_academicos.id_programa IS
    'ID_PROGRAMA';
COMMENT ON COLUMN ces.programas_academicos.descripcion IS
    'DESCRIPCION';
ALTER TABLE ces.programas_academicos RENAME CONSTRAINT sys_c0018601 TO programas_academicos_pk;


-- Error while generating DDL for (PK) PROGRAMAS_ACADEMICOS_PK. See log file for details.
COMMENT ON COLUMN ces.roles.id_rol IS
    'ID_ROL';
COMMENT ON COLUMN ces.roles.descripcion IS
    'DESCRIPCION';
ALTER TABLE ces.roles RENAME CONSTRAINT sys_c0018603 TO roles_pk;


-- Error while generating DDL for (PK) ROLES_PK. See log file for details.
COMMENT ON COLUMN ces.saldo_acum_bancos.id_banco IS
    'ID_BANCO';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_1 IS
    'DIA_1';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_2 IS
    'DIA_2';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_3 IS
    'DIA_3';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_4 IS
    'DIA_4';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_5 IS
    'DIA_5';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_6 IS
    'DIA_6';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_7 IS
    'DIA_7';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_8 IS
    'DIA_8';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_9 IS
    'DIA_9';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_10 IS
    'DIA_10';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_11 IS
    'DIA_11';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_12 IS
    'DIA_12';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_13 IS
    'DIA_13';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_14 IS
    'DIA_14';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_15 IS
    'DIA_15';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_16 IS
    'DIA_16';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_17 IS
    'DIA_17';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_18 IS
    'DIA_18';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_19 IS
    'DIA_19';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_20 IS
    'DIA_20';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_21 IS
    'DIA_21';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_22 IS
    'DIA_22';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_23 IS
    'DIA_23';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_24 IS
    'DIA_24';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_25 IS
    'DIA_25';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_26 IS
    'DIA_26';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_27 IS
    'DIA_27';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_28 IS
    'DIA_28';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_29 IS
    'DIA_29';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_30 IS
    'DIA_30';
COMMENT ON COLUMN ces.saldo_acum_bancos.dia_31 IS
    'DIA_31';
COMMENT ON COLUMN ces.saldo_acum_bancos.prog_academico IS
    'PROG_ACADEMICO';
COMMENT ON COLUMN ces.saldo_acum_bancos.saldo IS
    'SALDO';
COMMENT ON COLUMN ces.saldo_acum_bancos.forma_pago IS
    'FORMA_PAGO';
COMMENT ON COLUMN ces.saldo_acum_conceptos.cod_contable IS
    'COD_CONTABLE';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_1 IS
    'DIA_1';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_2 IS
    'DIA_2';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_3 IS
    'DIA_3';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_4 IS
    'DIA_4';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_5 IS
    'DIA_5';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_6 IS
    'DIA_6';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_7 IS
    'DIA_7';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_8 IS
    'DIA_8';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_9 IS
    'DIA_9';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_10 IS
    'DIA_10';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_11 IS
    'DIA_11';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_12 IS
    'DIA_12';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_13 IS
    'DIA_13';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_14 IS
    'DIA_14';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_15 IS
    'DIA_15';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_16 IS
    'DIA_16';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_17 IS
    'DIA_17';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_18 IS
    'DIA_18';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_19 IS
    'DIA_19';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_20 IS
    'DIA_20';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_21 IS
    'DIA_21';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_22 IS
    'DIA_22';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_23 IS
    'DIA_23';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_24 IS
    'DIA_24';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_25 IS
    'DIA_25';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_26 IS
    'DIA_26';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_27 IS
    'DIA_27';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_28 IS
    'DIA_28';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_29 IS
    'DIA_29';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_30 IS
    'DIA_30';
COMMENT ON COLUMN ces.saldo_acum_conceptos.dia_31 IS
    'DIA_31';
COMMENT ON COLUMN ces.saldo_acum_conceptos.prog_academico IS
    'PROG_ACADEMICO';
COMMENT ON COLUMN ces.saldo_acum_conceptos.saldo IS
    'SALDO';
COMMENT ON COLUMN ces.saldo_mensual_bancos.id_banco IS
    'ID_BANCO';
COMMENT ON COLUMN ces.saldo_mensual_bancos.mes_1 IS
    'MES_1';
COMMENT ON COLUMN ces.saldo_mensual_bancos.mes_2 IS
    'MES_2';
COMMENT ON COLUMN ces.saldo_mensual_bancos.mes_3 IS
    'MES_3';
COMMENT ON COLUMN ces.saldo_mensual_bancos.mes_4 IS
    'MES_4';
COMMENT ON COLUMN ces.saldo_mensual_bancos.mes_5 IS
    'MES_5';
COMMENT ON COLUMN ces.saldo_mensual_bancos.mes_6 IS
    'MES_6';
COMMENT ON COLUMN ces.saldo_mensual_bancos.mes_7 IS
    'MES_7';
COMMENT ON COLUMN ces.saldo_mensual_bancos.mes_8 IS
    'MES_8';
COMMENT ON COLUMN ces.saldo_mensual_bancos.mes_9 IS
    'MES_9';
COMMENT ON COLUMN ces.saldo_mensual_bancos.mes_10 IS
    'MES_10';
COMMENT ON COLUMN ces.saldo_mensual_bancos.mes_11 IS
    'MES_11';
COMMENT ON COLUMN ces.saldo_mensual_bancos.mes_12 IS
    'MES_12';
COMMENT ON COLUMN ces.saldo_mensual_bancos.prog_academico IS
    'PROG_ACADEMICO';
COMMENT ON COLUMN ces.saldo_mensual_conceptos.cod_contable IS
    'COD_CONTABLE';
COMMENT ON COLUMN ces.saldo_mensual_conceptos.mes_1 IS
    'MES_1';
COMMENT ON COLUMN ces.saldo_mensual_conceptos.mes_2 IS
    'MES_2';
COMMENT ON COLUMN ces.saldo_mensual_conceptos.mes_3 IS
    'MES_3';
COMMENT ON COLUMN ces.saldo_mensual_conceptos.mes_4 IS
    'MES_4';
COMMENT ON COLUMN ces.saldo_mensual_conceptos.mes_5 IS
    'MES_5';
COMMENT ON COLUMN ces.saldo_mensual_conceptos.mes_6 IS
    'MES_6';
COMMENT ON COLUMN ces.saldo_mensual_conceptos.mes_7 IS
    'MES_7';
COMMENT ON COLUMN ces.saldo_mensual_conceptos.mes_8 IS
    'MES_8';
COMMENT ON COLUMN ces.saldo_mensual_conceptos.mes_9 IS
    'MES_9';
COMMENT ON COLUMN ces.saldo_mensual_conceptos.mes_10 IS
    'MES_10';
COMMENT ON COLUMN ces.saldo_mensual_conceptos.mes_11 IS
    'MES_11';
COMMENT ON COLUMN ces.saldo_mensual_conceptos.mes_12 IS
    'MES_12';
COMMENT ON COLUMN ces.saldo_mensual_conceptos.prog_academico IS
    'PROG_ACADEMICO';
COMMENT ON COLUMN ces.salones.id_salon IS
    'ID_SALON';
COMMENT ON COLUMN ces.salones.edificio IS
    'EDIFICIO';
COMMENT ON COLUMN ces.salones.descripcion IS
    'DESCRIPCION';
COMMENT ON COLUMN ces.salones.capacidad IS
    'CAPACIDAD';
COMMENT ON COLUMN ces.salones.ancho IS
    'ANCHO';
COMMENT ON COLUMN ces.salones.largo IS
    'LARGO';


-- Error while generating DDL for PK_SALON. See log file for details.



-- Error while generating DDL for (PK) PK_SALON. See log file for details.

COMMENT ON COLUMN ces.secciones.id_seccion IS
    'ID_SECCION';
COMMENT ON COLUMN ces.secciones.id_metodo IS
    'ID_METODO';
COMMENT ON COLUMN ces.secciones.nivel IS
    'NIVEL';
COMMENT ON COLUMN ces.secciones.id_salon IS
    'ID_SALON';
COMMENT ON COLUMN ces.secciones.tope IS
    'TOPE';
COMMENT ON COLUMN ces.secciones.status IS
    'STATUS';
COMMENT ON COLUMN ces.secciones.cant_actual IS
    'CANT_ACTUAL';
COMMENT ON COLUMN ces.secciones.id_edif IS
    'ID_EDIF';
COMMENT ON COLUMN ces.secciones.horario IS
    'HORARIO';
COMMENT ON COLUMN ces.secciones.cedula_prof IS
    'CEDULA_PROF';
COMMENT ON COLUMN ces.secciones.modalidad IS
    'MODALIDAD';
COMMENT ON COLUMN ces.secciones.fec_inicio IS
    'FEC_INICIO';
COMMENT ON COLUMN ces.secciones.periodo IS
    'PERIODO';


-- Error while generating DDL for SECCIONES_PK. See log file for details.



-- Error while generating DDL for (PK) SECCIONES_PK. See log file for details.

COMMENT ON COLUMN ces.secciones_his.id_seccion IS
    'ID_SECCION';
COMMENT ON COLUMN ces.secciones_his.id_metodo IS
    'ID_METODO';
COMMENT ON COLUMN ces.secciones_his.nivel IS
    'NIVEL';
COMMENT ON COLUMN ces.secciones_his.id_salon IS
    'ID_SALON';
COMMENT ON COLUMN ces.secciones_his.tope IS
    'TOPE';
COMMENT ON COLUMN ces.secciones_his.status IS
    'STATUS';
COMMENT ON COLUMN ces.secciones_his.cant_actual IS
    'CANT_ACTUAL';
COMMENT ON COLUMN ces.secciones_his.id_edif IS
    'ID_EDIF';
COMMENT ON COLUMN ces.secciones_his.horario IS
    'HORARIO';
COMMENT ON COLUMN ces.secciones_his.cedula_prof IS
    'CEDULA_PROF';
COMMENT ON COLUMN ces.secciones_his.modalidad IS
    'MODALIDAD';
COMMENT ON COLUMN ces.secciones_his.fec_inicio IS
    'FEC_INICIO';
COMMENT ON COLUMN ces.secciones_his.periodo IS
    'PERIODO';
COMMENT ON COLUMN ces.secciones_his.fecha_accion IS
    'FECHA_ACCION';
COMMENT ON COLUMN ces.secciones_his.tipo_accion IS
    'TIPO_ACCION';
COMMENT ON COLUMN ces.status.id IS
    'ID';
COMMENT ON COLUMN ces.status.descripcion IS
    'DESCRIPCION';
COMMENT ON COLUMN ces.teste.dc_cia IS
    'DC_CIA';
COMMENT ON COLUMN ces.teste.dc_tipo IS
    'DC_TIPO';
COMMENT ON COLUMN ces.teste.dc_clase IS
    'DC_CLASE';
COMMENT ON COLUMN ces.teste.dc_numero IS
    'DC_NUMERO';
COMMENT ON COLUMN ces.teste.dc_flgcp IS
    'DC_FLGCP';
COMMENT ON COLUMN ces.teste.dc_clipro IS
    'DC_CLIPRO';
COMMENT ON COLUMN ces.teste.dc_referencia IS
    'DC_REFERENCIA';
COMMENT ON COLUMN ces.teste.dc_fecemi IS
    'DC_FECEMI';
COMMENT ON COLUMN ces.teste.dc_fecven IS
    'DC_FECVEN';
COMMENT ON COLUMN ces.teste.dc_monto IS
    'DC_MONTO';
COMMENT ON COLUMN ces.teste.dc_saldo IS
    'DC_SALDO';
COMMENT ON COLUMN ces.teste.dc_usrcre IS
    'DC_USRCRE';
COMMENT ON COLUMN ces.teste.dc_usranul IS
    'DC_USRANUL';
COMMENT ON COLUMN ces.teste.dc_usrmod IS
    'DC_USRMOD';
COMMENT ON COLUMN ces.teste.dc_feccre IS
    'DC_FECCRE';
COMMENT ON COLUMN ces.teste.dc_fecanul IS
    'DC_FECANUL';
COMMENT ON COLUMN ces.teste.dc_fecmod IS
    'DC_FECMOD';
COMMENT ON COLUMN ces.teste.dc_feccanc IS
    'DC_FECCANC';
COMMENT ON COLUMN ces.teste.dc_status IS
    'DC_STATUS';
COMMENT ON COLUMN ces.teste.dc_piva IS
    'DC_PIVA';
COMMENT ON COLUMN ces.teste.dc_iva IS
    'DC_IVA';
COMMENT ON COLUMN ces.teste.dc_banco IS
    'DC_BANCO';
COMMENT ON COLUMN ces.teste.dc_cobrador IS
    'DC_COBRADOR';
COMMENT ON COLUMN ces.teste.dc_fpago IS
    'DC_FPAGO';
COMMENT ON COLUMN ces.teste.dc_numref IS
    'DC_NUMREF';
COMMENT ON COLUMN ces.teste.dc_ciudad IS
    'DC_CIUDAD';
COMMENT ON COLUMN ces.teste.dc_fecref IS
    'DC_FECREF';
COMMENT ON COLUMN ces.teste.dc_tasacam IS
    'DC_TASACAM';
COMMENT ON COLUMN ces.teste.dc_moneda IS
    'DC_MONEDA';
COMMENT ON COLUMN ces.teste.dc_auxiliar IS
    'DC_AUXILIAR';
COMMENT ON COLUMN ces.teste.dc_beneficiario IS
    'DC_BENEFICIARIO';
COMMENT ON COLUMN ces.teste.dc_statusc IS
    'DC_STATUSC';
COMMENT ON COLUMN ces.teste.dc_nrofac IS
    'DC_NROFAC';
COMMENT ON COLUMN ces.tipo_empresa.id_tipo IS
    'ID_TIPO';
COMMENT ON COLUMN ces.tipo_empresa.descripcion IS
    'DESCRIPCION';


-- Error while generating DDL for TIPO_EMPRESA_PK. See log file for details.



-- Error while generating DDL for (PK) TIPO_EMPRESA_PK. See log file for details.

COMMENT ON COLUMN ces.tipo_estudiante.id_tipo_est IS
    'ID_TIPO_EST';
COMMENT ON COLUMN ces.tipo_estudiante.descripcion IS
    'DESCRIPCION';
ALTER TABLE ces.tipo_estudiante RENAME CONSTRAINT sys_c0018611 TO tipo_estudiante_pk;


-- Error while generating DDL for (PK) TIPO_ESTUDIANTE_PK. See log file for details.
COMMENT ON COLUMN ces.tipo_mat_prog.id_tipo_material IS
    'ID_TIPO_MATERIAL';
COMMENT ON COLUMN ces.tipo_mat_prog.id_prog_acad IS
    'ID_PROG_ACAD';


-- Error while generating DDL for TIPO_MAT_PROG_PK. See log file for details.



-- Error while generating DDL for (PK) TIPO_MAT_PROG_PK. See log file for details.

COMMENT ON COLUMN ces.tipo_material.abrev IS
    'ABREV';
COMMENT ON COLUMN ces.tipo_material.descripcion IS
    'DESCRIPCION';
COMMENT ON COLUMN ces.tipo_material.idiomas IS
    'IDIOMAS';
COMMENT ON COLUMN ces.tipo_material.ctc IS
    'CTC';
COMMENT ON COLUMN ces.tipo_material.cfp IS
    'CFP';
COMMENT ON COLUMN ces.tipo_material.fvtc IS
    'FVTC';


-- Error while generating DDL for PK_TIPO_MATERIAL. See log file for details.



-- Error while generating DDL for (PK) PK_TIPO_MATERIAL. See log file for details.

COMMENT ON COLUMN ces.tipo_profesor.id_tipo_prof IS
    'ID_TIPO_PROF';
COMMENT ON COLUMN ces.tipo_profesor.descripcion IS
    'DESCRIPCION';
ALTER TABLE ces.tipo_profesor RENAME CONSTRAINT sys_c0018615 TO tipo_profesor_pk;


-- Error while generating DDL for (PK) TIPO_PROFESOR_PK. See log file for details.
COMMENT ON COLUMN ces.tipos_doc.td_codigo IS
    'TD_CODIGO';
COMMENT ON COLUMN ces.tipos_doc.td_nombre IS
    'TD_NOMBRE';
COMMENT ON COLUMN ces.tipos_doc.td_usrcre IS
    'TD_USRCRE';
COMMENT ON COLUMN ces.tipos_doc.td_usrmod IS
    'TD_USRMOD';
COMMENT ON COLUMN ces.tipos_doc.td_feccre IS
    'TD_FECCRE';
COMMENT ON COLUMN ces.tipos_doc.td_fecmod IS
    'TD_FECMOD';
COMMENT ON COLUMN ces.tipos_doc.td_abrv IS
    'TD_ABRV';
COMMENT ON COLUMN ces.usuarios.cedula IS
    'CEDULA';
COMMENT ON COLUMN ces.usuarios.nombre_usuario IS
    'NOMBRE_USUARIO';
COMMENT ON COLUMN ces.usuarios.contrasena IS
    'CONTRASENA';
COMMENT ON COLUMN ces.usuarios.id_rol IS
    'ID_ROL';
COMMENT ON COLUMN ces.usuarios.email IS
    'EMAIL';
COMMENT ON COLUMN ces.usuarios.nombre IS
    'NOMBRE';
COMMENT ON COLUMN ces.usuarios.cia IS
    'CIA';
COMMENT ON COLUMN ces.usuarios.prog_academico IS
    'PROG_ACADEMICO';
ALTER TABLE ces.usuarios RENAME CONSTRAINT sys_c0018616 TO usuarios_pk;


-- Error while generating DDL for (PK) USUARIOS_PK. See log file for details.
COMMENT ON COLUMN ces.zonas.id_zona IS
    'ID_ZONA';
COMMENT ON COLUMN ces.zonas.descripcion IS
    'DESCRIPCION';
COMMENT ON COLUMN ces.zonas.id_ciudad IS
    'ID_CIUDAD';
ALTER TABLE ces.zonas RENAME CONSTRAINT sys_c0018618 TO zonas_pk;


-- Error while generating DDL for (PK) ZONAS_PK. See log file for details.
create or replace view ces.eventos_calendario as
SELECT
    ces.calendarios.id_calendario,
    ces.calendarios.descripcion
    || ' ('
    || ces.modalidades.descripcion
    || ')' AS DESCRIPCION,
    ces.calendarios_detalle.fecha_ini,
    ces.calendarios_detalle.fecha_fin
FROM
    ces.calendarios
    INNER JOIN ces.calendarios_detalle ON ces.calendarios.id_calendario = ces.calendarios_detalle.id_calendario
    INNER JOIN ces.modalidades ON ces.modalidades.id_modalidad = ces.calendarios_detalle.modalidad;
    
ALTER VIEW ces.eventos_calendario ADD CONSTRAINT eventos_calendario_pk PRIMARY KEY ( id_calendario ) DISABLE;

ALTER TABLE ces.calendarios_detalle
    ADD CONSTRAINT calendarios_detalle_calendarios_fk FOREIGN KEY ( id_calendario )
        REFERENCES ces.calendarios ( id_calendario )
    NOT DEFERRABLE;
ALTER TABLE ces.calendarios_detalle
    ADD CONSTRAINT calendarios_detalle_modalidades_fk FOREIGN KEY ( modalidad )
        REFERENCES ces.modalidades ( id_modalidad )
    NOT DEFERRABLE;
ALTER TABLE ces.ciudades RENAME CONSTRAINT sys_c0018628 TO ciud_est_fk;
ALTER TABLE ces.detalle_paquete RENAME CONSTRAINT sys_c0018627 TO det_paq_paq_fk;
ALTER TABLE ces.estudiante RENAME CONSTRAINT sys_c0018633 TO est_tp_est_fk;
ALTER TABLE ces.ficha_academica RENAME CONSTRAINT sys_c0018632 TO pk_ficha_academica;
ALTER TABLE ces.ficha_pago RENAME CONSTRAINT sys_c0018630 TO fic_pag_even_fk;
ALTER TABLE ces.ficha_pago_cfp RENAME CONSTRAINT sys_c0018629 TO fic_pcfp_even_fk;
ALTER TABLE ces.profesor RENAME CONSTRAINT sys_c0018634 TO prof_tp_prof_fk;
ALTER TABLE ces.usuarios RENAME CONSTRAINT sys_c0018631 TO usr_rol_fk;

-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                             0
-- CREATE INDEX                             0
-- CREATE VIEW                              0
-- ALTER TABLE                             38
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
-- ERRORS                                  69
-- WARNINGS                                 0
