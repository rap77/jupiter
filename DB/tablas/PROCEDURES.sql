--------------------------------------------------------
--  DDL for Procedure IMPRIME_PDF
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FUNDAUC"."IMPRIME_PDF" 
(p_id IN NUMBER)
is
    l_mime varchar2(255);
    l_length number;
    l_file_name varchar2(200);
    l_blob blob;
begin
    select '', pdf_blob, DBMS_LOB.getlength(pdf_blob)
    into l_mime, l_blob, l_length
    from material_digital
    where PDF_ID = p_id;
    owa_util.mime_header( nvl(l_mime,'application/pdf'), FALSE );
    htp.p('Content-length: ' || l_length);
    owa_util.http_header_close;
    -- descargar el reporte pdf
    wpg_docload.download_file(l_blob);
end;

/
--------------------------------------------------------
--  DDL for Procedure PL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FUNDAUC"."PL" (
aiv_text                       in     varchar2 ) is
/*
pl.prc
by Donald J. Bales on 2014-10-20
A wrapper procedure for SYS.DBMS_OUTPUT.put_line()
for the lazy typist.
*/

begin
  SYS.DBMS_OUTPUT.put_line(aiv_text);
end pl;

/
--------------------------------------------------------
--  DDL for Procedure SET_CONTEXTO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FUNDAUC"."SET_CONTEXTO" 
( pname  VARCHAR2
, pvalue VARCHAR2) IS
BEGIN
  -- Create a session with a previously defined context.
  DBMS_SESSION.SET_CONTEXT('FUNDAUC_CTX',pname,pvalue);
END;

/
--------------------------------------------------------
--  DDL for Procedure SHOW_PDF
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FUNDAUC"."SHOW_PDF" 
AS
   l_blob    BLOB;
   l_bfile   BFILE;
BEGIN
   DBMS_LOB.createtemporary (l_blob, TRUE, DBMS_LOB.SESSION);
   --create or replace directory MY_FILES as 'c:\pdfs'; --'/users/pdf/files'
   l_bfile := BFILENAME ('MISPDF', 'my.pdf');
   DBMS_LOB.fileopen (l_bfile);
   DBMS_LOB.loadfromfile (l_blob, l_bfile, DBMS_LOB.getlength (l_bfile));
   DBMS_LOB.fileclose (l_bfile);

   OWA_UTIL.mime_header ('application/pdf',
                         bclose_header      => FALSE);
   ------------------------------------------------------------------------
   -- set content length
   ------------------------------------------------------------------------
   HTP.p ('Content-length: ' || DBMS_LOB.getlength (l_blob));
   OWA_UTIL.http_header_close;
   ------------------------------------------------------------------------
   -- download the file and display in browser
   ------------------------------------------------------------------------
   WPG_DOCLOAD.download_file (l_blob);
   ------------------------------------------------------------------------
   -- release resources
   ------------------------------------------------------------------------
   DBMS_LOB.freetemporary (l_blob);

EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

/
