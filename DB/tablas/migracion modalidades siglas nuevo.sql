set pagesize 0
set feedback off
set head off
select 'update FUNDAUC.MODALIDADES SET SIGLAS = '''||SIGLAS||''' where id_modalidad='||ID_MODALIDAD||';' from MODALIDADES

