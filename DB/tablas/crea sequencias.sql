set pagesize 0
set feedback off
select 'CREATE SEQUENCE '||SEQUENCE_NAME||' INCREMENT BY 1 MAXVALUE 9999999999999999999999999999 MINVALUE 1 NOCACHE;'
from all_sequences
where sequence_owner = 'FUNDAUC'


select * from all_sequences

DROP SEQUENCE DETALLE_FACTURA_SEQ;

CREATE SEQUENCE CALENDARIOS_DETALLE_SEQ INCREMENT BY 1 START WITH 1072 MAXVALUE 9999999999999999999999999999 MINVALUE 1 CACHE 20;

set serveroutput on
declare
  l_reg number:=0;
  l_id varchar2(255);
  l_dml varchar2(2000);
begin
  for cur in (select sequence_owner, sequence_name , replace(sequence_name,'_SEQ','') table_name 
        from all_sequences
         where sequence_owner = 'FUNDAUC') loop
      begin
         l_dml := 'SELECT column_name FROM all_cons_columns WHERE OWNER='''||
                              cur.sequence_owner||''' AND constraint_name = ('||
                             'SELECT constraint_name FROM all_constraints WHERE OWNER='''||
                              cur.sequence_owner||''' AND UPPER(table_name) = UPPER('''||
                              cur.table_name||''') AND CONSTRAINT_TYPE = ''P'')';
         DBMS_OUTPUT.PUT_LINE('BUSCANDO ID...');
         execute immediate l_dml into l_id;
         DBMS_OUTPUT.PUT_LINE('ID Conseguido '||l_id);
         execute immediate 'SELECT max('||l_id||') from '||cur.table_name into l_reg;
         DBMS_OUTPUT.PUT_LINE(cur.table_name||' '||l_reg);
         execute immediate 'DROP SEQUENCE '||cur.sequence_name;
         DBMS_OUTPUT.PUT_LINE('SEQUENCIA '||cur.sequence_name||' Borrada. ');
         execute immediate 'CREATE SEQUENCE '||cur.sequence_name||' INCREMENT BY 1 START WITH '||to_char(l_reg+1)||'MAXVALUE 9999999999999999999999999999 MINVALUE 1 NOCACHE';
         DBMS_OUTPUT.PUT_LINE('SEQUENCIA '||cur.sequence_name||' Creada. ');
         
         exception
         when others then
            DBMS_OUTPUT.PUT_LINE('ERROR SEQUENCIA '||cur.sequence_name||l_dml||' '||SQLERRM);
     end;
  end loop;
end;


select * from all_constraints
where owner = 'FUNDAUC'
select * from all_cons_columns

SELECT * FROM all_cons_columns WHERE owner='FUNDAUC' and constraint_name = (                            
SELECT constraint_name FROM all_constraints WHERE OWNER='FUNDAUC' AND UPPER(table_name) = UPPER('DEPOSITO') AND CONSTRAINT_TYPE = 'P')