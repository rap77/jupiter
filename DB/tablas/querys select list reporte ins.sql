select distinct lpad(utl_periodos.getPeriodo(i.periodo_id),27,' ')||' '||utl_periodos.getstatusPeriodo(i.periodo_id) d, i.periodo_id r
from instancias_secciones i
order by to_date(token(substr(lpad(utl_periodos.getPeriodo(i.periodo_id),27,' '),7),1,'-'),'DD/MM/YYYY')


select distinct S.CODIGO_SEC||'|'||S.METODO_ID||'|'||ME.DESCRIPCION||'|'||'NIVEL '||S.NIVEL||'|'||S.ESTATUS as d, s.ID as r
  from INSTANCIAS_SECCIONES S, METODOS ME
  WHERE S.METODO_ID = ME.ID_METODO
  AND S.ID IN (SELECT distinct INSTANCIA_ID FROM INSCRIPCIONES)
  AND s.PERIODO_ID = :P57_PERIODO_ID
 order by 1
 