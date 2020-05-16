Exec dbms_xdb.setftpport('2100');
EXEC dbms_xdb.setlistenerlocalaccess(false);
ALTER USER apex_public_user ACCOUNT UNLOCK;
ALTER USER apex_public_user IDENTIFIED BY oracle;

EXEC dbms_xdb.setlistenerlocalaccess(true);

EXEC dbms_xdb.sethttpport(8181);