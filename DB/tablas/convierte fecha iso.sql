select TO_CHAR(
        SYSTIMESTAMP AT TIME ZONE 'UTC',
        'yyyy-mm-dd"T"hh24:mi:ss.ff3"Z"'
    ) from calendarios_detalle
    
    
    
    select TO_CHAR(to_timestamp(sysdate) AT TIME ZONE 'UTC','yyyy-mm-dd"T"hh24:mi:ss.ff3"Z"') from dual
    
    select CAST(to_timestamp_tz(to_char(sysdate,'YYYY-MM-DD')||'T'||to_char(sysdate,'HH24:MI:SS')||'Z','YYYY-MM-DD"T"HH24:MI:SSTZH:TZM') AS DATE)
from dual

SELECT CAST(SYSTIMESTAMP AS DATE) FROM dual;