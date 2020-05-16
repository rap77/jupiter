DECLARE
  meta          CLOB;
  md_obj        JSON_OBJECT_T;
  li_arr        JSON_ARRAY_T;
  li_item       JSON_ELEMENT_T;
  sec_obj       JSON_OBJECT_T;
  fac_obj        JSON_OBJECT_T;
  hor_obj        JSON_OBJECT_T;
  
  PROCEDURE display (p_obj IN JSON_OBJECT_T) IS
  BEGIN
    DBMS_OUTPUT.put_line(p_obj.stringify);
  END;

BEGIN
  select metadata into meta from hoja_vida_est where rownum=1;
  md_obj := JSON_OBJECT_T.parse(meta);

    hor_obj := new JSON_OBJECT_T();
    
    li_item := JSON_OBJECT_T(md_obj.get_Object('seccion').get_Object('id_horario'));
    
    hor_obj.put('horario',li_item);

    fac_obj := JSON_OBJECT_T(md_obj.get_Object('seccion').get_Object('factura'));
    sec_obj := JSON_OBJECT_T(md_obj.get_Object('seccion'));
    sec_obj.remove('factura');
    sec_obj.remove('id_horario');
    sec_obj.remove('horario');
    
    sec_obj.put('horario',hor_obj);
    
    md_obj.put('factura',fac_obj);
    
    display(md_obj);

END;
/
