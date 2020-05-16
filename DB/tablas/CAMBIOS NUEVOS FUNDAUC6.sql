select DESCRIPCION as display_value, ID_PAGO as return_value 
  from FORMA_PAGO
  
 order by 1
 
 
 select decode(count(*),0,6,9) from ctaxcob
 where factura_id = 234
 
 select * from factura_deposito fd, factura f
 where fd.factura_id = f.id
 and escredito='S'
 
 
 select * from tapi_factura.tt(711)
 
 ------------------------------
 
 exec tapi_gen2.create_tapi_package (p_table_name => 'CTAXCOB', p_compile_table_api => TRUE);
 
CREATE SEQUENCE CTAXCOB_SEQ;

CREATE OR REPLACE TRIGGER CTAXCOB_TRG 
BEFORE INSERT ON CTAXCOB 
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT CTAXCOB_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/
--------------------------------------------------------
--  DDL for Trigger T_FACTURA_DEPOSITO_SEQ
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "FUNDAUC"."T_FACTURA_DEPOSITO_SEQ" 
   after insert on "FUNDAUC"."FACTURA_DEPOSITO" 
   for each row 
declare   
   P_FACTURA_REC FUNDAUC.TAPI_FACTURA.FACTURA_RT;
   P_CTAXCOB_REC FUNDAUC.TAPI_CTAXCOB.CTAXCOB_RT;
   P_IGNORE_NULLS BOOLEAN;
   P_ULT_FAC NUMBER := UTL_CONFIGURACION.getConfUltFactura();
   l_es_credito char(1);
   l_rif  varchar2(10);
   l_ctaxcob number := 0;
   l_monto_fac number := 0;
begin  
   if inserting then 
      if :NEW."FACTURA_ID" is not null then 
        select escredito into l_es_credito from tapi_factura.tt(:NEW.FACTURA_ID);
        

        P_IGNORE_NULLS := TRUE;

          P_FACTURA_REC.ID := :NEW.FACTURA_ID;
          P_FACTURA_REC.ID_FACT := P_ULT_FAC;
          if l_es_credito = 'S' then
            P_FACTURA_REC.STATUS := 'PP';
          else
            P_FACTURA_REC.STATUS := 'V';
          end if;
          P_FACTURA_REC.FECHA_EMI := SYSDATE;
          P_FACTURA_REC.FACTURADO_POR := coalesce(sys_context('APEX$SESSION', 'app_user'), regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), sys_context('userenv', 'session_user'));
          
          TAPI_FACTURA.UPD(
            P_FACTURA_REC => P_FACTURA_REC,
            P_IGNORE_NULLS => P_IGNORE_NULLS
          );

          UTL_CONFIGURACION.actConfUltFactura(P_ULT_FAC);
          
          if l_es_credito = 'S' then
            select rif, fecha_emi, id, monto 
              into l_rif,P_CTAXCOB_REC.FECHA,P_CTAXCOB_REC.FACTURA_ID, l_monto_fac  
              from tapi_factura.tt(:NEW.FACTURA_ID);
              
            select id into P_CTAXCOB_REC.CLIENTE_ID from clientes where rif = l_rif;
            
            select count(*) into l_ctaxcob from ctaxcob where factura_id = :NEW.FACTURA_ID;
            
            if l_ctaxcob = 0 then
              P_CTAXCOB_REC.DEPOSITO_ID := :NEW.DEPOSITO_ID;
              P_CTAXCOB_REC.CREDITO := 'DB';
              P_CTAXCOB_REC.MONTO := l_monto_fac;
            else
              P_CTAXCOB_REC.DEPOSITO_ID := :NEW.DEPOSITO_ID;
              P_CTAXCOB_REC.CREDITO := 'CR';
              select monto into P_CTAXCOB_REC.MONTO from tapi_deposito.tt(:NEW.DEPOSITO_ID);
            end if;
            
          end if;
          
          
      end if; 
   end if; 
end;
/
ALTER TRIGGER "FUNDAUC"."T_FACTURA_DEPOSITO_SEQ" ENABLE;
