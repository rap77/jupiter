CREATE OR REPLACE FORCE EDITIONABLE VIEW "JUPITER"."V_NOM_DETALLE" (
    "VND_ID",
    "VND_CIA",
    "VND_TIPONOM",
    "VND_FRECUENCIA",
    "VND_FECHA",
    "VND_CONTRATO",
    "VND_CONCEPTO",
    "VND_DESCONCEPTO",
    "VND_CRDB",
    "VND_MONTO"
) AS
    SELECT
        TO_CHAR(mn_fecha, 'YYYYMMDD')
        || lpad(mn_cia, 2, '0')
        || lpad(mn_tiponom, 2, '0')
        || mn_frecuencia id,
        mn_cia,
        mn_tiponom,
        mn_frecuencia,
        mn_fecha,
        DECODE(mn_tiponom, '2', DECODE(ce_contrato, 11, ce_contrato, 1), get_contratohv(mn_empleado, mn_fecha)) ce_contrato,
--        mn_empleado,
        mn_concepto,
        cp_descrip,
        DECODE(cp_tipo, 'A', 'DB', 'D', 'CR') crdb,
        SUM(mn_monto) mn_monto
    FROM
        movi_nom,
        conceptos,
        contratos_emp
     --   (select hv_monto hv_cia, hv_empleado, hv_fecha, hv_fechafin from hoja_vida where hv_evento = 13) hv_cia
    WHERE
        mn_concepto = cp_codigo
        AND mn_concepto NOT IN (
            SELECT
                cg_concepto
            FROM
                concepto_grupo
        )
        AND mn_empleado = ce_empleado
        AND ce_status IS NULL
        AND mn_cia = get_ciahv(mn_empleado, mn_fecha)
--        AND mn_empleado = 43
        AND mn_monto <> 0
    GROUP BY
        TO_CHAR(mn_fecha, 'YYYYMMDD')
        || lpad(mn_cia, 2, '0')
        || lpad(mn_tiponom, 2, '0')
        || mn_frecuencia,
        mn_cia,
        mn_tiponom,
        mn_frecuencia,
        mn_fecha,
        DECODE(mn_tiponom, '2', DECODE(ce_contrato, 11, ce_contrato, 1), get_contratohv(mn_empleado, mn_fecha)),
--        mn_empleado,
        mn_concepto,
        cp_descrip,
        DECODE(cp_tipo, 'A', 'DB', 'D', 'CR')