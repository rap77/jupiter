select sid,serial#,osuser,machine,terminal,program,status from v$session

alter system kill session '20,86';
alter system kill session '16,770';