--------------------------------------------------------
--  DDL for View V_NOMINAS_CALC
--------------------------------------------------------
CREATE OR REPLACE FORCE EDITIONABLE VIEW "JUPITER"."V_NOMINAS_CALC" (
    "MN_CIA",
    "TN_DESCRIPCION",
    "MN_FRECUENCIA",
    "MN_FECHA",
    "TOTAL_TRAB",
    "T_ASIG",
    "T_DED",
    "T_NOMINA",
    "STATUS"
) AS
    SELECT
        mn_cia,
        '('
        || mn_tiponom
        || ') '
        || tn_descripcion tn_descripcion,
        mn_frecuencia,
        mn_fecha,
        COUNT(DISTINCT mn_empleado) total_trab,
        SUM(DECODE(cp_tipo, 'A', mn_monto, 0)) t_asig,
        SUM(DECODE(cp_tipo, 'D', mn_monto, 0)) t_ded,
        SUM(DECODE(cp_tipo, 'A', mn_monto, 0)) - SUM(DECODE(cp_tipo, 'D', mn_monto, 0)) t_nomina,
        CASE
            WHEN mn_flgcierre = '*' THEN
                'CERRADA PARCIAL'
            ELSE
                'CALCULADA'
        END status
    FROM
        tipos_nom,
        movi_nom,
        conceptos,
        empleados
    WHERE
        tn_codigo = mn_tiponom
        AND mn_empleado = em_numero
        AND mn_empleado <> 127
        AND cp_codigo = mn_concepto
    GROUP BY
        mn_cia,
        '('
        || mn_tiponom
        || ') '
        || tn_descripcion,
        mn_frecuencia,
        mn_fecha,
        CASE
                WHEN mn_flgcierre = '*' THEN
                    'CERRADA PARCIAL'
                ELSE
                    'CALCULADA'
            END
    UNION ALL
    SELECT
        mn_cia,
        '('
        || mn_tiponom
        || ') '
        || tn_descripcion tn_descripcion,
        mn_frecuencia,
        mn_fecha,
        COUNT(DISTINCT mn_empleado) total_trab,
        SUM(DECODE(cp_tipo, 'A', mn_monto, 0)) t_asig,
        SUM(DECODE(cp_tipo, 'D', mn_monto, 0)) t_ded,
        SUM(DECODE(cp_tipo, 'A', mn_monto, 0)) - SUM(DECODE(cp_tipo, 'D', mn_monto, 0)) t_nomina,
        'CERRADA' status
    FROM
        tipos_nom,
        movi_nomhis,
        conceptos,
        empleados
    WHERE
        tn_codigo = mn_tiponom
        AND mn_empleado = em_numero
        AND mn_empleado <> 127
        AND TO_CHAR(mn_fecha, 'MMYYYY') = TO_CHAR(SYSDATE - 60, 'MMYYYY')
        AND cp_codigo = mn_concepto
    GROUP BY
        mn_cia,
        '('
        || mn_tiponom
        || ') '
        || tn_descripcion,
        mn_frecuencia,
        mn_fecha,
        'CERRADA'
    ORDER BY
        1,
        2,
        4,
        3;