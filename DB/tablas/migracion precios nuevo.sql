set pagesize 0
set feedback off
set head off
select 'Insert into FUNDAUC.PRECIOS (ID,TIPO_ITEM,FECHA,PRECIO1,PRECIO2,PRECIO3,STATUS,PRECIO4,PRECIO5) values ('||M.ID||','''||TIPO_ITEM||''',to_date('''||TO_CHAR(FECHA,'DDMMYYYY')||''',''DDMMYYYY''),'||nvl(PRECIO1,0)||','||nvl(PRECIO2,0)||','||nvl(PRECIO3,0)||','''||STATUS||''','||nvl(PRECIO4,0)||','||nvl(PRECIO5,0)||');' from PRECIOS P, MATERIALES M
WHERE P.ITEM = M.ID_MAT
