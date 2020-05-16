DECLARE
    l_codigo VARCHAR2(50);
    l_codigo_new VARCHAR2(50);
    l_letra  VARCHAR2(1);
    l_num    NUMBER;
    
    FUNCTION CODIF (NUM NUMBER) RETURN VARCHAR2 AS
      LET VARCHAR2(1);
    BEGIN
      SELECT TRANSLATE(TO_CHAR(NUM),'123456789','ABCDEFGHI') 
      INTO LET
      FROM DUAL;
      
      RETURN LET;
    END CODIF;
    
    FUNCTION DECOD (LET VARCHAR2) RETURN NUMBER AS
      NUM NUMBER;
    BEGIN
      SELECT TRANSLATE(TO_CHAR(LET),'ABCDEFGHI','123456789') 
      INTO NUM
      FROM DUAL;
      RETURN NUM;
    END DECOD;
    
    PROCEDURE display (p_obj IN VARCHAR2) IS
    BEGIN
        DBMS_OUTPUT.put_line(p_obj);
    END;
    
BEGIN

    for i in (
        select id,'('||metodo_id||'|'||lpad(nivel,2,'0')||'|'||utl_modalidades.getSiglas(modalidad_id)||'|'||utl_periodos.getPeriodoMin(periodo_id)||'|'||utl_horarios.getHorarioMin(horario_id)||')' codigo 
        from instancias_secciones
        order by seccion_id,f_inicio
        ) LOOP
    
    begin
      l_letra := CODIF(1);
  --  display('l_codigo_new1='||i.codigo);
        select max(codigo_sec) 
        into l_codigo
        from instancias_secciones
        where substr(codigo_sec,1,length(codigo_sec)-1) = i.codigo;
        
    --    display('l_codigo1='||l_codigo);
        
        if l_codigo is null then
            display('l codigo is null');
            l_letra := CODIF(1);
            update instancias_secciones set codigo_sec = i.codigo||l_letra where id =i.id;        
        else
            l_letra:=substr(l_codigo,length(l_codigo),1);
   --         display('l_letra1='||l_letra);
            l_num:=DECOD(l_letra)+1;
   --         display('l_num='||l_num);
            l_letra:=CODIF(l_num);
   --         display('l_letra2='||l_letra);
            update instancias_secciones set codigo_sec = i.codigo||l_letra where id =i.id;        
        end if;
    
    exception
        when no_data_found then
            l_letra := CODIF(1);
            update instancias_secciones set codigo_sec = i.codigo||l_letra where id =i.id;
    END;      
    END LOOP;
END;


DECLARE
    l_codigo VARCHAR2(50);
    l_codigo_new VARCHAR2(50);
    l_letra  VARCHAR2(1);
    l_num    NUMBER;
    
    FUNCTION CODIF (NUM NUMBER) RETURN VARCHAR2 AS
      LET VARCHAR2(1);
    BEGIN
      SELECT TRANSLATE(TO_CHAR(NUM),'123456789','ABCDEFGHI') 
      INTO LET
      FROM DUAL;
      
      RETURN LET;
    END CODIF;
    
    FUNCTION DECOD (LET VARCHAR2) RETURN NUMBER AS
      NUM NUMBER;
    BEGIN
      SELECT TRANSLATE(TO_CHAR(LET),'ABCDEFGHI','123456789') 
      INTO NUM
      FROM DUAL;
      RETURN NUM;
    END DECOD;
    
    PROCEDURE display (p_obj IN VARCHAR2) IS
    BEGIN
        DBMS_OUTPUT.put_line(p_obj);
    END;
    
BEGIN

    for i in (

        select id,'('||id_metodo||'|'||lpad(nivel,2,'0')||'|'||utl_modalidades.getSiglas(modalidad)||'|'||utl_periodos.getPeriodoMin(periodo)||'|'||utl_horarios.getHorarioMin(id_horario)||')' codigo 
        from secciones
--        where periodo=83 and nivel =1
        order by id
        ) LOOP
    
    begin
      l_letra := CODIF(1);
  --  display('l_codigo_new1='||i.codigo);
  
        select max(id_seccion) 
        into l_codigo
        from secciones
        where substr(id_seccion,1,length(id_seccion)-1) = i.codigo;
        
    --    display('l_codigo1='||l_codigo);
        
        if l_codigo is null then
   --         display('l codigo is null');
            l_letra := CODIF(1);
            update secciones set id_seccion = i.codigo||l_letra where id =i.id; 
   --         display(i.codigo||l_letra);
        else
            l_letra:=substr(l_codigo,length(l_codigo),1);
   --         display('l_letra1='||l_letra);
            l_num:=DECOD(l_letra)+1;
   --         display('l_num='||l_num);
            l_letra:=CODIF(l_num);
   --         display('l_letra2='||l_letra);
            update secciones set id_seccion = i.codigo||l_letra where id =i.id; 
   --         display(i.codigo||l_letra);
        end if;
    
    exception
        when no_data_found then
            l_letra := CODIF(1);
            update secciones set id_seccion = i.codigo||l_letra where id =i.id;
        when others then
            display(i.codigo||l_letra||'-'||i.id);
    END;      
    END LOOP;
END;
