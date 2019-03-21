--------------------------------------------------------
-- Archivo creado  - miércoles-marzo-06-2019   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function GET_CIAHV
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "JUPITER"."GET_CIAHV" (
    v_emp IN NUMBER,
    v_fnom DATE
) RETURN NUMBER AS
    r_ret NUMBER := 0;
BEGIN 
  SELECT  hv_monto hv_cia
    INTO r_ret
    FROM hoja_vida
   WHERE hv_evento = 13
     AND hv_empleado = v_emp
     AND v_fnom BETWEEN nvl(hv_fecha, TO_DATE('01012000', 'DDMMYYYY')) AND nvl(hv_fechafin, v_fnom);
    RETURN r_ret;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
     SELECT ce_cia
    INTO r_ret
    FROM contratos_emp
   WHERE ce_empleado = v_emp;
   RETURN r_ret;
   WHEN OTHERS THEN
        r_ret := 0;
        RETURN r_ret;
END;

/
