begin
  for cur in (select id,
case
      when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='Finalizado' and
      (case
           when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
           when instr(utl_inscripciones.getStatusFac(id),'SUSPENDIDO') > 1 then 'S'
           when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
           when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
           else 'X'
      end) = 'PC' then 'IFXC'
      when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='Finalizado' then 'IF'
      when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='En Curso' and 
      fecha_ins+9 < to_date(token(substr(UTL_PERIODOS.GETPERIODO(107),4),1,'-'),'DD/MM/YYYY') and
      (case
           when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
           when instr(utl_inscripciones.getStatusFac(id),'SUSPENDIDO') > 1 then 'S'
           when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
           when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
           else 'X'
      end) <> 'PC' then 'IF'
      when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='En Curso' and 
      (case
           when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
           when instr(utl_inscripciones.getStatusFac(id),'SUSPENDIDO') > 1 then 'S'
           when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
           when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
           else 'X'
      end) = 'X' then 'ACP'
      when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='En Curso' and 
      (case
           when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
           when instr(utl_inscripciones.getStatusFac(id),'SUSPENDIDO') > 1 then 'S'
           when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
           when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
           else 'X'
      end) = 'PC' then 'ACXC'
      when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='En Curso' and 
      (case
           when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
           when instr(utl_inscripciones.getStatusFac(id),'SUSPENDIDO') > 1 then 'S'
           when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
           when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
           else 'X'
      end) = 'E' then 'ACX'
      when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='En Curso' and 
      (case
           when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
           when instr(utl_inscripciones.getStatusFac(id),'SUSPENDIDO') > 1 then 'S'
           when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
           when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
           else 'X'
      end) = 'S' then 'ACS'
      when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='Por Comenzar' and 
      (case
           when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
           when instr(utl_inscripciones.getStatusFac(id),'SUSPENDIDO') > 1 then 'S'
           when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
           when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
           else 'X'
      end) = 'X' then 'AEP'
      when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='Por Comenzar' and 
      (case
           when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
           when instr(utl_inscripciones.getStatusFac(id),'SUSPENDIDO') > 1 then 'S'
           when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
           when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
           else 'X'
      end) = 'PC' then 'AECX'
      when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='Por Comenzar' and 
      (case
           when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
           when instr(utl_inscripciones.getStatusFac(id),'SUSPENDIDO') > 1 then 'S'
           when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
           when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
           else 'X'
      end) = 'E' then 'AEX'
      when UTL_PERIODOS.GETSTATUSPERIODOSEC(SECCION_ID)='Por Comenzar' and 
      (case
           when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
           when instr(utl_inscripciones.getStatusFac(id),'SUSPENDIDO') > 1 then 'S'
           when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
           when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
           else 'X'
      end) = 'S' then 'AES'
      when (case
           when instr(utl_inscripciones.getStatusFac(id),'EXONERADO') > 1 then 'E'
           when instr(utl_inscripciones.getStatusFac(id),'SUSPENDIDO') > 1 then 'S'
           when instr(utl_inscripciones.getStatusFac(id),'POR COBRAR') > 1 then 'PC'
           when instr(utl_inscripciones.getStatusFac(id),'ANULADA') > 1 then 'A'
           else 'X'
      end) = 'A' then 'AN'
    end estatus
from inscripciones where estatus <> 'IF') loop
     execute immediate 'update inscripciones set estatus='''||cur.estatus||''' where id='||cur.ID;
  end loop;
end;