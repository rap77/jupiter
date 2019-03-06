CREATE OR REPLACE FORCE EDITIONABLE VIEW "JUPITER"."V_NOM_MAESTRO" (
    "VNM_ID",
    "VNM_CIA",
    "VNM_TIPONOM",
    "VNM_FRECUENCIA",
    "VNM_FECHA",
    "VNM_DESCRIPCION",
    "VNM_NUMTRAB",
    "VNM_TOTALNOMINA"
) AS
    SELECT
        to_char(mn_fecha,'YYYYMMDD')||lpad(mn_cia,2,'0')||lpad(mn_tiponom,2,'0')||mn_frecuencia id,
        mn_cia,
        mn_tiponom,
        mn_frecuencia,
        mn_fecha,
        CASE
                WHEN tn_ordinaria = 'S' THEN
                    DECODE(mn_frecuencia, 2, '1RA QUINCENA', 4, '2DA QUINCENA')
                    || '|'
                ELSE
                    NULL
            END
        || tn_descripcion
        || '|'
        || ci_descripcion
        || '|'
        || TRIM(TO_CHAR(mn_fecha, 'MONTH'))
        || ','
        || TO_CHAR(mn_fecha, 'YYYY') descripcion,
        COUNT(DISTINCT mn_empleado) cant_trab,
        SUM(
            CASE
                WHEN cp_tipo = 'A' THEN
                    mn_monto
                ELSE
                    mn_monto * - 1
            END
        ) total_nomina
    FROM
        movi_nom,
        tipos_nom,
        cias,
        conceptos
    WHERE
        mn_tiponom = tn_codigo
        AND mn_cia = ci_codigo
        AND mn_concepto = cp_codigo
    GROUP BY
        to_char(mn_fecha,'YYYYMMDD')||lpad(mn_cia,2,'0')||lpad(mn_tiponom,2,'0')||mn_frecuencia,
        mn_cia,
        mn_tiponom,
        mn_frecuencia,
        mn_fecha,
        CASE
                WHEN tn_ordinaria = 'S' THEN
                    DECODE(mn_frecuencia, 2, '1RA QUINCENA', 4, '2DA QUINCENA')
                    || '|'
                ELSE
                    NULL
            END
        || tn_descripcion
        || '|'
        || ci_descripcion
        || '|'
        || TRIM(TO_CHAR(mn_fecha, 'MONTH'))
        || ','
        || TO_CHAR(mn_fecha, 'YYYY');