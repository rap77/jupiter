set pagesize 0
set feedback off
set head off
select 'Insert into FUNDAUC.HORARIOS (ID_HORARIO,HORA,MODALIDAD,HORA_FIN) values ('||ID_HORARIO||',to_date('''||TO_CHAR(HORA,'DDMMYYYY HHMISSAM')||''',''DDMMYYYY HHMISSAM''),'||MODALIDAD||',to_date('''||TO_CHAR(HORA_FIN,'DDMMYYYY HHMISSAM')||''',''DDMMYYYY HHMISSAM'')'||');' from HORARIOS
