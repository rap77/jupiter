--------------------------------------------------------
--  DDL for Package APEX_ENHANCED_LOV_ITEM
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."APEX_ENHANCED_LOV_ITEM" as
  procedure render (
      p_item   in            apex_plugin.t_item,
      p_plugin in            apex_plugin.t_plugin,
      p_param  in            apex_plugin.t_item_render_param,
      p_result in out nocopy apex_plugin.t_item_render_result 
  );

  procedure ajax(
    p_item   in            apex_plugin.t_item,
    p_plugin in            apex_plugin.t_plugin,
    p_param  in            apex_plugin.t_item_ajax_param,
    p_result in out nocopy apex_plugin.t_item_ajax_result 
  );
end;

/
--------------------------------------------------------
--  DDL for Package AS_PDF3_MOD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."AS_PDF3_MOD" 
is
/**********************************************
**
** Additional comment by Andreas Weiden:
**AS_PDF3_MOD

** The following methods were added by me for additinal functionality needed for PK_JRXML_REPGEN
**
** -   PR_GOTO_PAGE
** -   PR_GOTO_CURRENT_PAGE;
** -   PR_LINE
** -   PR_POLYGON
** -   PR_PATH
**
** Changed in parameter p_txt for procedure raw2page  from blob to raw
** Added global collection g_settings_per_tab to store different pageformat for each page.
** changed add_page to write a MediaBox-entry with the g_settings_per_tab-content for each page
**
** Change in subset_font:Checking for raw-length reduced from 32778 to 32000 because of raw-length-error
** in specific cases
**
** Various changes for font-usage: The access to g_fonts(g_current_font) is very slow, replaced it with a specific font-record
** which is filled when g_current_font changes
**
** Changes in adler32: The num-value of a hex-byte is no longer calculated by a to_number, but taken from an associative array
** done for preformance. Also there is an additional check for step_size, because this will result in 0 with chunksizes>16383
**
** Changes in put_image_methods: the adler32-value can be provided from outside
***/


/**********************************************
**
** Author: Anton Scheffer
** Date: 11-04-2012
** Website: http://technology.amis.nl
** See also: http://technology.amis.nl/?p=17718
**
** Changelog:
**   Date: 16-04-2012
**     changed code for parse_png
**   Date: 15-04-2012
**     only dbms_lob.freetemporary for temporary blobs
**   Date: 11-04-2012
**     Initial release of as_pdf3
**
******************************************************************************
******************************************************************************
Copyright (C) 2012 by Anton Scheffer

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

******************************************************************************
******************************************** */
--
  c_get_page_width    constant pls_integer := 0;
  c_get_page_height   constant pls_integer := 1;
  c_get_margin_top    constant pls_integer := 2;
  c_get_margin_right  constant pls_integer := 3;
  c_get_margin_bottom constant pls_integer := 4;
  c_get_margin_left   constant pls_integer := 5;
  c_get_x             constant pls_integer := 6;
  c_get_y             constant pls_integer := 7;
  c_get_fontsize      constant pls_integer := 8;
  c_get_current_font  constant pls_integer := 9;

  type tVertices is table of number index by pls_integer;

  PATH_MOVE_TO    CONSTANT NUMBER:=1;
  PATH_LINE_TO    CONSTANT NUMBER:=2;
  PATH_CURVE_TO   CONSTANT NUMBER:=3;
  PATH_CLOSE      CONSTANT NUMBER:=4;

  type tPathElement IS RECORD (
    nType NUMBER,
    nVal1 NUMBER,
    nVal2 NUMBER,
    nVal3 NUMBER,
    nVal4 NUMBER,
    nVal5 NUMBER,
    nVal6 NUMBER
  );

  TYPE tPath IS TABLE OF tPathElement INDEX BY BINARY_INTEGER;
--
  function file2blob( p_dir varchar2, p_file_name varchar2 )
  return blob;
--
  function conv2uu( p_value number, p_unit varchar2 )
  return number;
--
  procedure set_page_size
    ( p_width number
    , p_height number
    , p_unit varchar2 := 'cm'
    );
--
  procedure set_page_format( p_format varchar2 := 'A4' );
--
  procedure set_page_orientation( p_orientation varchar2 := 'PORTRAIT' );
--
  procedure set_margins
    ( p_top number := null
    , p_left number := null
    , p_bottom number := null
    , p_right number := null
    , p_unit varchar2 := 'cm'
    );
--
  procedure set_info
    ( p_title varchar2 := null
    , p_author varchar2 := null
    , p_subject varchar2 := null
    , p_keywords varchar2 := null
    );
--
  procedure init;
--
  function get_pdf
  return blob;
--
  procedure save_pdf
    ( p_dir varchar2 := 'MY_DIR'
    , p_filename varchar2 := 'my.pdf'
    , p_freeblob boolean := true
    );
--
  procedure txt2page( p_txt varchar2 );
--
  procedure put_txt( p_x number, p_y number, p_txt varchar2, p_degrees_rotation number := null );
--
  function str_len( p_txt varchar2 )
  return number;
--
  procedure write
    ( p_txt in varchar2
    , p_x in number := null
    , p_y in number := null
    , p_line_height in number := null
    , p_start in number := null -- left side of the available text box
    , p_width in number := null -- width of the available text box
    , p_alignment in varchar2 := null
    );
--
  procedure set_font
    ( p_index pls_integer
    , p_fontsize_pt number
    , p_output_to_doc boolean := true
    );
--
  function set_font
    ( p_fontname varchar2
    , p_fontsize_pt number
    , p_output_to_doc boolean := true
    )
  return pls_integer;
--
  procedure set_font
    ( p_fontname varchar2
    , p_fontsize_pt number
    , p_output_to_doc boolean := true
    );
--
  function set_font
    ( p_family varchar2
    , p_style varchar2 := 'N'
    , p_fontsize_pt number := null
    , p_output_to_doc boolean := true
    )
  return pls_integer;
--
  procedure set_font
    ( p_family varchar2
    , p_style varchar2 := 'N'
    , p_fontsize_pt number := null
    , p_output_to_doc boolean := true
    );
--
  procedure new_page;
--
  function load_ttf_font
    ( p_font blob
    , p_encoding varchar2 := 'WINDOWS-1252'
    , p_embed boolean := false
    , p_compress boolean := true
    , p_offset number := 1
    )
  return pls_integer;
--
  procedure load_ttf_font
    ( p_font blob
    , p_encoding varchar2 := 'WINDOWS-1252'
    , p_embed boolean := false
    , p_compress boolean := true
    , p_offset number := 1
    );
--
  function load_ttf_font
    ( p_dir varchar2 := 'MY_FONTS'
    , p_filename varchar2 := 'BAUHS93.TTF'
    , p_encoding varchar2 := 'WINDOWS-1252'
    , p_embed boolean := false
    , p_compress boolean := true
    )
  return pls_integer;
--
  procedure load_ttf_font
    ( p_dir varchar2 := 'MY_FONTS'
    , p_filename varchar2 := 'BAUHS93.TTF'
    , p_encoding varchar2 := 'WINDOWS-1252'
    , p_embed boolean := false
    , p_compress boolean := true
    );
--
  procedure load_ttc_fonts
    ( p_ttc blob
    , p_encoding varchar2 := 'WINDOWS-1252'
    , p_embed boolean := false
    , p_compress boolean := true
    );
--
  procedure load_ttc_fonts
    ( p_dir varchar2 := 'MY_FONTS'
    , p_filename varchar2 := 'CAMBRIA.TTC'
    , p_encoding varchar2 := 'WINDOWS-1252'
    , p_embed boolean := false
    , p_compress boolean := true
    );
--
  procedure set_color( p_rgb varchar2 := '000000' );
--
  procedure set_color
    ( p_red number := 0
    , p_green number := 0
    , p_blue number := 0
    );
--
  procedure set_bk_color( p_rgb varchar2 := 'ffffff' );
--
  procedure set_bk_color
    ( p_red number := 0
    , p_green number := 0
    , p_blue number := 0
    );
--
  procedure horizontal_line
    ( p_x in number
    , p_y in number
    , p_width in number
    , p_line_width in number := 0.5
    , p_line_color in varchar2 := '000000'
    );
--
  procedure vertical_line
    ( p_x in number
    , p_y in number
    , p_height in number
    , p_line_width in number := 0.5
    , p_line_color in varchar2 := '000000'
    );
--
  procedure rect
    ( p_x in number
    , p_y in number
    , p_width in number
    , p_height in number
    , p_line_color in varchar2 := null
    , p_fill_color in varchar2 := null
    , p_line_width in number := 0.5
    );
--
  function get( p_what in pls_integer )
  return number;
--
  procedure put_image
    ( p_img blob
    , p_x number
    , p_y number
    , p_width number := null
    , p_height number := null
    , p_align varchar2 := 'center'
    , p_valign varchar2 := 'top'
    , p_adler32 varchar2 := null
    );
--
  procedure put_image
    ( p_dir varchar2
    , p_file_name varchar2
    , p_x number
    , p_y number
    , p_width number := null
    , p_height number := null
    , p_align varchar2 := 'center'
    , p_valign varchar2 := 'top'
    , p_adler32 varchar2 := null
    );
--
  procedure put_image
    ( p_url varchar2
    , p_x number
    , p_y number
    , p_width number := null
    , p_height number := null
    , p_align varchar2 := 'center'
    , p_valign varchar2 := 'top'
    , p_adler32 varchar2 := null
    );
--
  procedure set_page_proc( p_src clob );
--
  type tp_col_widths is table of number;
  type tp_headers is table of varchar2(32767);
--
  procedure query2table
    ( p_query varchar2
    , p_widths tp_col_widths := null
    , p_headers tp_headers := null
    );
--

  PROCEDURE PR_GOTO_PAGE(i_nPage IN NUMBER);

  PROCEDURE PR_GOTO_CURRENT_PAGE;

  PROCEDURE PR_LINE(i_nX1         IN NUMBER,
                    i_nY1         IN NUMBER,
                    i_nX2         IN NUMBER,
                    i_nY2         IN NUMBER,
                    i_vcLineColor IN VARCHAR2 DEFAULT NULL,
                    i_nLineWidth  IN NUMBER DEFAULT 0.5,
                    i_vcStroke    IN VARCHAR2 DEFAULT NULL
                   );

  PROCEDURE PR_POLYGON(i_lXs         IN tVertices,
                       i_lYs         IN tVertices,
                       i_vcLineColor IN VARCHAR2 DEFAULT NULL,
                       i_vcFillColor IN VARCHAR2 DEFAULT NULL,
                       i_nLineWidth  IN NUMBER DEFAULT 0.5
                      );

  PROCEDURE PR_PATH(i_lPath       IN tPath,
                    i_vcLineColor IN VARCHAR2 DEFAULT NULL,
                    i_vcFillColor IN VARCHAR2 DEFAULT NULL,
                    i_nLineWidth  IN NUMBER DEFAULT 0.5
                   );

  function adler32( p_src in blob )
  return varchar2;

$IF not DBMS_DB_VERSION.VER_LE_10 $THEN
  procedure refcursor2table
    ( p_rc sys_refcursor
    , p_widths tp_col_widths := null
    , p_headers tp_headers := null
    );
--
$END
end;

/
--------------------------------------------------------
--  DDL for Package DIALOG_DEMO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."DIALOG_DEMO" as
-- use $0$, $1$ ... for client side value substitutions
function prepare_dialog_url (
    p_url in varchar2 )
    return varchar2;
end dialog_demo;

/
--------------------------------------------------------
--  DDL for Package FUNDAUC_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."FUNDAUC_PKG" 
as
    procedure setSede(sede varchar2);
    procedure setProgAcad(prog number);
end fundauc_pkg;

/
--------------------------------------------------------
--  DDL for Package GLOBAL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."GLOBAL" 
AS
  FUNCTION getVal(pvar varchar2)  RETURN varchar2;
  PROCEDURE setVal (pvar IN VARCHAR2,pval IN VARCHAR2 );
END;

/
--------------------------------------------------------
--  DDL for Package PRETIUS_APEX_NESTED_REPORTS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."PRETIUS_APEX_NESTED_REPORTS" as

  function pretius_row_details (
    p_dynamic_action in apex_plugin.t_dynamic_action,
    p_plugin         in apex_plugin.t_plugin 
  ) return apex_plugin.t_dynamic_action_render_result;

  function pretius_row_details_ajax(
    p_dynamic_action in apex_plugin.t_dynamic_action,
    p_plugin         in apex_plugin.t_plugin 
  ) return apex_plugin.t_dynamic_action_ajax_result;

end;

/
--------------------------------------------------------
--  DDL for Package TAPI_CALENDARIOS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."TAPI_CALENDARIOS" 
IS
   /**
   * TAPI_CALENDARIOS
   * Generated by: tapiGen2 - DO NOT MODIFY!
   * Website: github.com/osalvador/tapiGen2
   * Created On: 24-OCT-2019 11:06
   * Created By: FUNDAUC
   */

   --Scalar/Column types
   SUBTYPE hash_t IS varchar2 (40);
   SUBTYPE id_calendario IS calendarios.id_calendario%TYPE;
   SUBTYPE descripcion IS calendarios.descripcion%TYPE;
   SUBTYPE activo IS calendarios.activo%TYPE;
   SUBTYPE tipo_cal IS calendarios.tipo_cal%TYPE;

   --Record type
   TYPE calendarios_rt
   IS
      RECORD (
            id_calendario calendarios.id_calendario%TYPE,
            descripcion calendarios.descripcion%TYPE,
            activo calendarios.activo%TYPE,
            tipo_cal calendarios.tipo_cal%TYPE,
            hash               hash_t,
            row_id            VARCHAR2(64)
      );
   --Collection types (record)
   TYPE calendarios_tt IS TABLE OF calendarios_rt;

   --Global exceptions
   e_ol_check_failed EXCEPTION; --Optimistic lock check failed
   e_row_missing     EXCEPTION; --The cursor failed to get a row
   e_upd_failed      EXCEPTION; --The update operation failed
   e_del_failed      EXCEPTION; --The delete operation failed

   /**
   * Generates a SHA1 hash for optimistic locking purposes.
   *
   * @param    p_id_calendario        must be NOT NULL
   */
   FUNCTION hash (
                  p_id_calendario IN calendarios.id_calendario%TYPE
                 )
    RETURN VARCHAR2;

   /**
   * This function generates a SHA1 hash for optimistic locking purposes.
   * Access directly to the row by rowid
   *
   * @param  p_rowid  must be NOT NULL
   */
   FUNCTION hash_rowid (p_rowid IN varchar2)
   RETURN varchar2;

   /**
   * This is a table encapsulation function designed to retrieve information from the calendarios table.
   *
   * @param      p_id_calendario      must be NOT NULL
   * @return     calendarios Record Type
   */
   FUNCTION rt (
                p_id_calendario IN calendarios.id_calendario%TYPE 
               )
    RETURN calendarios_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information
   * from the calendarios table while placing a lock on it for a potential
   * update/delete. Do not use this for updates in web based apps, instead use the
   * rt_for_web_update function to get a FOR_WEB_UPDATE_RT record which
   * includes all of the tables columns along with an md5 checksum for use in the
   * web_upd and web_del procedures.
   *
   * @param      p_id_calendario      must be NOT NULL
   * @return     calendarios Record Type
   */
   FUNCTION rt_for_update (
                          p_id_calendario IN calendarios.id_calendario%TYPE 
                          )
    RETURN calendarios_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information from the calendarios table.
   * This function return Record Table as PIPELINED Function
   *
   * @param      p_id_calendario      must be NOT NULL
   * @return     calendarios Table Record Type
   */
   FUNCTION tt (
                p_id_calendario IN calendarios.id_calendario%TYPE DEFAULT NULL
               )
   RETURN calendarios_tt
   PIPELINED;

   /**
   * This is a table encapsulation function designed to insert a row into the calendarios table.
   *
   * @param      p_calendarios_rec       Record Type
   * @return     p_calendarios_rec       Record Type
   */
   PROCEDURE ins (p_calendarios_rec IN OUT calendarios_rt);

   /**
   * This is a table encapsulation function designed to update a row in the calendarios table.
   *
   * @param      p_calendarios_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd (p_calendarios_rec IN calendarios_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row in the calendarios table,
   * access directly to the row by rowid
   *
   * @param      p_calendarios_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd_rowid (p_calendarios_rec IN calendarios_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the calendarios table whith optimistic lock validation
   *
   * @param      p_calendarios_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd (p_calendarios_rec IN calendarios_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the calendarios table whith optimistic lock validation
   * access directly to the row by rowid
   *
   * @param      p_calendarios_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd_rowid (p_calendarios_rec IN calendarios_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to delete a row from the calendarios table.
   *
   * @param    p_id_calendario        must be NOT NULL
   */
   PROCEDURE del (
                  p_id_calendario IN calendarios.id_calendario%TYPE
                );

   /**
   * This is a table encapsulation function designed to delete a row from the calendarios table
   * access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   */
    PROCEDURE del_rowid (p_rowid IN VARCHAR2);

   /**
   * This is a table encapsulation function designed to delete a row from the calendarios table
   * whith optimistic lock validation
   *
   * @param      p_id_calendario      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del (
                      p_id_calendario IN calendarios.id_calendario%TYPE,
                      p_hash IN varchar2
                      );

   /**
   * This is a table encapsulation function designed to delete a row from the calendarios table
   * whith optimistic lock validation, access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del_rowid (p_rowid IN varchar2, p_hash IN varchar2);

END tapi_calendarios;
 

/
--------------------------------------------------------
--  DDL for Package TAPI_CALENDARIOS_DETALLE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."TAPI_CALENDARIOS_DETALLE" 
IS
   /**
   * TAPI_CALENDARIOS_DETALLE
   * Generated by: tapiGen2 - DO NOT MODIFY!
   * Website: github.com/osalvador/tapiGen2
   * Created On: 30-JUL-2019 17:33
   * Created By: FUNDAUC
   */

   --Scalar/Column types
   SUBTYPE hash_t IS varchar2 (40);
   SUBTYPE id_calendario IS calendarios_detalle.id_calendario%TYPE;
   SUBTYPE periodo IS calendarios_detalle.periodo%TYPE;
   SUBTYPE fecha_ini IS calendarios_detalle.fecha_ini%TYPE;
   SUBTYPE fecha_fin IS calendarios_detalle.fecha_fin%TYPE;
   SUBTYPE modalidad IS calendarios_detalle.modalidad%TYPE;
   SUBTYPE periodo_activo IS calendarios_detalle.periodo_activo%TYPE;
   SUBTYPE id IS calendarios_detalle.id%TYPE;

   --Record type
   TYPE calendarios_detalle_rt
   IS
      RECORD (
            id_calendario calendarios_detalle.id_calendario%TYPE,
            periodo calendarios_detalle.periodo%TYPE,
            fecha_ini calendarios_detalle.fecha_ini%TYPE,
            fecha_fin calendarios_detalle.fecha_fin%TYPE,
            modalidad calendarios_detalle.modalidad%TYPE,
            periodo_activo calendarios_detalle.periodo_activo%TYPE,
            id calendarios_detalle.id%TYPE,
            hash               hash_t,
            row_id            VARCHAR2(64)
      );
   --Collection types (record)
   TYPE calendarios_detalle_tt IS TABLE OF calendarios_detalle_rt;

   --Global exceptions
   e_ol_check_failed EXCEPTION; --Optimistic lock check failed
   e_row_missing     EXCEPTION; --The cursor failed to get a row
   e_upd_failed      EXCEPTION; --The update operation failed
   e_del_failed      EXCEPTION; --The delete operation failed

   /**
   * Generates a SHA1 hash for optimistic locking purposes.
   *
   * @param    p_id        must be NOT NULL
   */
   FUNCTION hash (
                  p_id IN calendarios_detalle.id%TYPE
                 )
    RETURN VARCHAR2;

   /**
   * This function generates a SHA1 hash for optimistic locking purposes.
   * Access directly to the row by rowid
   *
   * @param  p_rowid  must be NOT NULL
   */
   FUNCTION hash_rowid (p_rowid IN varchar2)
   RETURN varchar2;

   /**
   * This is a table encapsulation function designed to retrieve information from the calendarios_detalle table.
   *
   * @param      p_id      must be NOT NULL
   * @return     calendarios_detalle Record Type
   */
   FUNCTION rt (
                p_id IN calendarios_detalle.id%TYPE 
               )
    RETURN calendarios_detalle_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information
   * from the calendarios_detalle table while placing a lock on it for a potential
   * update/delete. Do not use this for updates in web based apps, instead use the
   * rt_for_web_update function to get a FOR_WEB_UPDATE_RT record which
   * includes all of the tables columns along with an md5 checksum for use in the
   * web_upd and web_del procedures.
   *
   * @param      p_id      must be NOT NULL
   * @return     calendarios_detalle Record Type
   */
   FUNCTION rt_for_update (
                          p_id IN calendarios_detalle.id%TYPE 
                          )
    RETURN calendarios_detalle_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information from the calendarios_detalle table.
   * This function return Record Table as PIPELINED Function
   *
   * @param      p_id      must be NOT NULL
   * @return     calendarios_detalle Table Record Type
   */
   FUNCTION tt (
                p_id IN calendarios_detalle.id%TYPE DEFAULT NULL
               )
   RETURN calendarios_detalle_tt
   PIPELINED;

   /**
   * This is a table encapsulation function designed to insert a row into the calendarios_detalle table.
   *
   * @param      p_calendarios_detalle_rec       Record Type
   * @return     p_calendarios_detalle_rec       Record Type
   */
   PROCEDURE ins (p_calendarios_detalle_rec IN OUT calendarios_detalle_rt);

   /**
   * This is a table encapsulation function designed to update a row in the calendarios_detalle table.
   *
   * @param      p_calendarios_detalle_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd (p_calendarios_detalle_rec IN calendarios_detalle_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row in the calendarios_detalle table,
   * access directly to the row by rowid
   *
   * @param      p_calendarios_detalle_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd_rowid (p_calendarios_detalle_rec IN calendarios_detalle_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the calendarios_detalle table whith optimistic lock validation
   *
   * @param      p_calendarios_detalle_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd (p_calendarios_detalle_rec IN calendarios_detalle_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the calendarios_detalle table whith optimistic lock validation
   * access directly to the row by rowid
   *
   * @param      p_calendarios_detalle_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd_rowid (p_calendarios_detalle_rec IN calendarios_detalle_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to delete a row from the calendarios_detalle table.
   *
   * @param    p_id        must be NOT NULL
   */
   PROCEDURE del (
                  p_id IN calendarios_detalle.id%TYPE
                );

   /**
   * This is a table encapsulation function designed to delete a row from the calendarios_detalle table
   * access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   */
    PROCEDURE del_rowid (p_rowid IN VARCHAR2);

   /**
   * This is a table encapsulation function designed to delete a row from the calendarios_detalle table
   * whith optimistic lock validation
   *
   * @param      p_id      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del (
                      p_id IN calendarios_detalle.id%TYPE,
                      p_hash IN varchar2
                      );

   /**
   * This is a table encapsulation function designed to delete a row from the calendarios_detalle table
   * whith optimistic lock validation, access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del_rowid (p_rowid IN varchar2, p_hash IN varchar2);

END tapi_calendarios_detalle;


/
--------------------------------------------------------
--  DDL for Package TAPI_COHORTES
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."TAPI_COHORTES" 
IS
   /**
   * TAPI_COHORTES
   * Generated by: tapiGen2 - DO NOT MODIFY!
   * Website: github.com/osalvador/tapiGen2
   * Created On: 25-FEB-2020 18:34
   * Created By: FUNDAUC
   */

   --Scalar/Column types
   SUBTYPE hash_t IS varchar2 (40);
   SUBTYPE codigo IS cohortes.codigo%TYPE;
   SUBTYPE id_horario IS cohortes.id_horario%TYPE;
   SUBTYPE id_modalidad IS cohortes.id_modalidad%TYPE;
   SUBTYPE cohorte IS cohortes.cohorte%TYPE;
   SUBTYPE cupo IS cohortes.cupo%TYPE;
   SUBTYPE costo IS cohortes.costo%TYPE;
   SUBTYPE inicial IS cohortes.inicial%TYPE;
   SUBTYPE costo_cuota IS cohortes.costo_cuota%TYPE;
   SUBTYPE cuotas IS cohortes.cuotas%TYPE;
   SUBTYPE status IS cohortes.status%TYPE;
   SUBTYPE id_ciudad IS cohortes.id_ciudad%TYPE;
   SUBTYPE id IS cohortes.id%TYPE;
   SUBTYPE tipo_diplo IS cohortes.tipo_diplo%TYPE;
   SUBTYPE creado_por IS cohortes.creado_por%TYPE;
   SUBTYPE creado_el IS cohortes.creado_el%TYPE;
   SUBTYPE modificado_por IS cohortes.modificado_por%TYPE;
   SUBTYPE modificado_el IS cohortes.modificado_el%TYPE;
   SUBTYPE diplomado_id IS cohortes.diplomado_id%TYPE;
   SUBTYPE periodo IS cohortes.periodo%TYPE;
   SUBTYPE id_calendario IS cohortes.id_calendario%TYPE;
   SUBTYPE nivel IS cohortes.nivel%TYPE;
   SUBTYPE id_metodo IS cohortes.id_metodo%TYPE;
   SUBTYPE empresa IS cohortes.empresa%TYPE;
   SUBTYPE facilitador IS cohortes.facilitador%TYPE;

   --Record type
   TYPE cohortes_rt
   IS
      RECORD (
            codigo cohortes.codigo%TYPE,
            id_horario cohortes.id_horario%TYPE,
            id_modalidad cohortes.id_modalidad%TYPE,
            cohorte cohortes.cohorte%TYPE,
            cupo cohortes.cupo%TYPE,
            costo cohortes.costo%TYPE,
            inicial cohortes.inicial%TYPE,
            costo_cuota cohortes.costo_cuota%TYPE,
            cuotas cohortes.cuotas%TYPE,
            status cohortes.status%TYPE,
            id_ciudad cohortes.id_ciudad%TYPE,
            id cohortes.id%TYPE,
            tipo_diplo cohortes.tipo_diplo%TYPE,
            creado_por cohortes.creado_por%TYPE,
            creado_el cohortes.creado_el%TYPE,
            modificado_por cohortes.modificado_por%TYPE,
            modificado_el cohortes.modificado_el%TYPE,
            diplomado_id cohortes.diplomado_id%TYPE,
            periodo cohortes.periodo%TYPE,
            id_calendario cohortes.id_calendario%TYPE,
            nivel cohortes.nivel%TYPE,
            id_metodo cohortes.id_metodo%TYPE,
            empresa cohortes.empresa%TYPE,
            facilitador cohortes.facilitador%TYPE,
            hash               hash_t,
            row_id            VARCHAR2(64)
      );
   --Collection types (record)
   TYPE cohortes_tt IS TABLE OF cohortes_rt;

   --Global exceptions
   e_ol_check_failed EXCEPTION; --Optimistic lock check failed
   e_row_missing     EXCEPTION; --The cursor failed to get a row
   e_upd_failed      EXCEPTION; --The update operation failed
   e_del_failed      EXCEPTION; --The delete operation failed

   /**
   * Generates a SHA1 hash for optimistic locking purposes.
   *
   * @param    p_id        must be NOT NULL
   */
   FUNCTION hash (
                  p_id IN cohortes.id%TYPE
                 )
    RETURN VARCHAR2;

   /**
   * This function generates a SHA1 hash for optimistic locking purposes.
   * Access directly to the row by rowid
   *
   * @param  p_rowid  must be NOT NULL
   */
   FUNCTION hash_rowid (p_rowid IN varchar2)
   RETURN varchar2;

   /**
   * This is a table encapsulation function designed to retrieve information from the cohortes table.
   *
   * @param      p_id      must be NOT NULL
   * @return     cohortes Record Type
   */
   FUNCTION rt (
                p_id IN cohortes.id%TYPE 
               )
    RETURN cohortes_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information
   * from the cohortes table while placing a lock on it for a potential
   * update/delete. Do not use this for updates in web based apps, instead use the
   * rt_for_web_update function to get a FOR_WEB_UPDATE_RT record which
   * includes all of the tables columns along with an md5 checksum for use in the
   * web_upd and web_del procedures.
   *
   * @param      p_id      must be NOT NULL
   * @return     cohortes Record Type
   */
   FUNCTION rt_for_update (
                          p_id IN cohortes.id%TYPE 
                          )
    RETURN cohortes_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information from the cohortes table.
   * This function return Record Table as PIPELINED Function
   *
   * @param      p_id      must be NOT NULL
   * @return     cohortes Table Record Type
   */
   FUNCTION tt (
                p_id IN cohortes.id%TYPE DEFAULT NULL
               )
   RETURN cohortes_tt
   PIPELINED;

   /**
   * This is a table encapsulation function designed to insert a row into the cohortes table.
   *
   * @param      p_cohortes_rec       Record Type
   * @return     p_cohortes_rec       Record Type
   */
   PROCEDURE ins (p_cohortes_rec IN OUT cohortes_rt);

   /**
   * This is a table encapsulation function designed to update a row in the cohortes table.
   *
   * @param      p_cohortes_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd (p_cohortes_rec IN cohortes_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row in the cohortes table,
   * access directly to the row by rowid
   *
   * @param      p_cohortes_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd_rowid (p_cohortes_rec IN cohortes_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the cohortes table whith optimistic lock validation
   *
   * @param      p_cohortes_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd (p_cohortes_rec IN cohortes_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the cohortes table whith optimistic lock validation
   * access directly to the row by rowid
   *
   * @param      p_cohortes_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd_rowid (p_cohortes_rec IN cohortes_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to delete a row from the cohortes table.
   *
   * @param    p_id        must be NOT NULL
   */
   PROCEDURE del (
                  p_id IN cohortes.id%TYPE
                );

   /**
   * This is a table encapsulation function designed to delete a row from the cohortes table
   * access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   */
    PROCEDURE del_rowid (p_rowid IN VARCHAR2);

   /**
   * This is a table encapsulation function designed to delete a row from the cohortes table
   * whith optimistic lock validation
   *
   * @param      p_id      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del (
                      p_id IN cohortes.id%TYPE,
                      p_hash IN varchar2
                      );

   /**
   * This is a table encapsulation function designed to delete a row from the cohortes table
   * whith optimistic lock validation, access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del_rowid (p_rowid IN varchar2, p_hash IN varchar2);

END tapi_cohortes;
 

/
--------------------------------------------------------
--  DDL for Package TAPI_CONDICIONES_ESPECIALES
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."TAPI_CONDICIONES_ESPECIALES" 
IS
   /**
   * TAPI_CONDICIONES_ESPECIALES
   * Generated by: tapiGen2 - DO NOT MODIFY!
   * Website: github.com/osalvador/tapiGen2
   * Created On: 11-SEP-2019 08:18
   * Created By: FUNDAUC
   */

   --Scalar/Column types
   SUBTYPE hash_t IS varchar2 (40);
   SUBTYPE id_condicion IS condiciones_especiales.id_condicion%TYPE;
   SUBTYPE descripcion IS condiciones_especiales.descripcion%TYPE;
   SUBTYPE descuento IS condiciones_especiales.descuento%TYPE;
   SUBTYPE porcentaje IS condiciones_especiales.porcentaje%TYPE;

   --Record type
   TYPE condiciones_especiales_rt
   IS
      RECORD (
            id_condicion condiciones_especiales.id_condicion%TYPE,
            descripcion condiciones_especiales.descripcion%TYPE,
            descuento condiciones_especiales.descuento%TYPE,
            porcentaje condiciones_especiales.porcentaje%TYPE,
            hash               hash_t,
            row_id            VARCHAR2(64)
      );
   --Collection types (record)
   TYPE condiciones_especiales_tt IS TABLE OF condiciones_especiales_rt;

   --Global exceptions
   e_ol_check_failed EXCEPTION; --Optimistic lock check failed
   e_row_missing     EXCEPTION; --The cursor failed to get a row
   e_upd_failed      EXCEPTION; --The update operation failed
   e_del_failed      EXCEPTION; --The delete operation failed

   /**
   * Generates a SHA1 hash for optimistic locking purposes.
   *
   * @param    p_id_condicion        must be NOT NULL
   */
   FUNCTION hash (
                  p_id_condicion IN condiciones_especiales.id_condicion%TYPE
                 )
    RETURN VARCHAR2;

   /**
   * This function generates a SHA1 hash for optimistic locking purposes.
   * Access directly to the row by rowid
   *
   * @param  p_rowid  must be NOT NULL
   */
   FUNCTION hash_rowid (p_rowid IN varchar2)
   RETURN varchar2;

   /**
   * This is a table encapsulation function designed to retrieve information from the condiciones_especiales table.
   *
   * @param      p_id_condicion      must be NOT NULL
   * @return     condiciones_especiales Record Type
   */
   FUNCTION rt (
                p_id_condicion IN condiciones_especiales.id_condicion%TYPE 
               )
    RETURN condiciones_especiales_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information
   * from the condiciones_especiales table while placing a lock on it for a potential
   * update/delete. Do not use this for updates in web based apps, instead use the
   * rt_for_web_update function to get a FOR_WEB_UPDATE_RT record which
   * includes all of the tables columns along with an md5 checksum for use in the
   * web_upd and web_del procedures.
   *
   * @param      p_id_condicion      must be NOT NULL
   * @return     condiciones_especiales Record Type
   */
   FUNCTION rt_for_update (
                          p_id_condicion IN condiciones_especiales.id_condicion%TYPE 
                          )
    RETURN condiciones_especiales_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information from the condiciones_especiales table.
   * This function return Record Table as PIPELINED Function
   *
   * @param      p_id_condicion      must be NOT NULL
   * @return     condiciones_especiales Table Record Type
   */
   FUNCTION tt (
                p_id_condicion IN condiciones_especiales.id_condicion%TYPE DEFAULT NULL
               )
   RETURN condiciones_especiales_tt
   PIPELINED;

   /**
   * This is a table encapsulation function designed to insert a row into the condiciones_especiales table.
   *
   * @param      p_condiciones_especiales_rec       Record Type
   * @return     p_condiciones_especiales_rec       Record Type
   */
   PROCEDURE ins (p_condiciones_especiales_rec IN OUT condiciones_especiales_rt);

   /**
   * This is a table encapsulation function designed to update a row in the condiciones_especiales table.
   *
   * @param      p_condiciones_especiales_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd (p_condiciones_especiales_rec IN condiciones_especiales_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row in the condiciones_especiales table,
   * access directly to the row by rowid
   *
   * @param      p_condiciones_especiales_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd_rowid (p_condiciones_especiales_rec IN condiciones_especiales_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the condiciones_especiales table whith optimistic lock validation
   *
   * @param      p_condiciones_especiales_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd (p_condiciones_especiales_rec IN condiciones_especiales_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the condiciones_especiales table whith optimistic lock validation
   * access directly to the row by rowid
   *
   * @param      p_condiciones_especiales_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd_rowid (p_condiciones_especiales_rec IN condiciones_especiales_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to delete a row from the condiciones_especiales table.
   *
   * @param    p_id_condicion        must be NOT NULL
   */
   PROCEDURE del (
                  p_id_condicion IN condiciones_especiales.id_condicion%TYPE
                );

   /**
   * This is a table encapsulation function designed to delete a row from the condiciones_especiales table
   * access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   */
    PROCEDURE del_rowid (p_rowid IN VARCHAR2);

   /**
   * This is a table encapsulation function designed to delete a row from the condiciones_especiales table
   * whith optimistic lock validation
   *
   * @param      p_id_condicion      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del (
                      p_id_condicion IN condiciones_especiales.id_condicion%TYPE,
                      p_hash IN varchar2
                      );

   /**
   * This is a table encapsulation function designed to delete a row from the condiciones_especiales table
   * whith optimistic lock validation, access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del_rowid (p_rowid IN varchar2, p_hash IN varchar2);

END tapi_condiciones_especiales;
 

/
--------------------------------------------------------
--  DDL for Package TAPI_CTAXCOB
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."TAPI_CTAXCOB" 
IS
   /**
   * TAPI_CTAXCOB
   * Generated by: tapiGen2 - DO NOT MODIFY!
   * Website: github.com/osalvador/tapiGen2
   * Created On: 23-OCT-2019 08:56
   * Created By: FUNDAUC
   */

   --Scalar/Column types
   SUBTYPE hash_t IS varchar2 (40);
   SUBTYPE id IS ctaxcob.id%TYPE;
   SUBTYPE cliente_id IS ctaxcob.cliente_id%TYPE;
   SUBTYPE fecha IS ctaxcob.fecha%TYPE;
   SUBTYPE factura_id IS ctaxcob.factura_id%TYPE;
   SUBTYPE deposito_id IS ctaxcob.deposito_id%TYPE;
   SUBTYPE credito IS ctaxcob.credito%TYPE;
   SUBTYPE monto IS ctaxcob.monto%TYPE;

   --Record type
   TYPE ctaxcob_rt
   IS
      RECORD (
            id ctaxcob.id%TYPE,
            cliente_id ctaxcob.cliente_id%TYPE,
            fecha ctaxcob.fecha%TYPE,
            factura_id ctaxcob.factura_id%TYPE,
            deposito_id ctaxcob.deposito_id%TYPE,
            credito ctaxcob.credito%TYPE,
            monto ctaxcob.monto%TYPE,
            hash               hash_t,
            row_id            VARCHAR2(64)
      );
   --Collection types (record)
   TYPE ctaxcob_tt IS TABLE OF ctaxcob_rt;

   --Global exceptions
   e_ol_check_failed EXCEPTION; --Optimistic lock check failed
   e_row_missing     EXCEPTION; --The cursor failed to get a row
   e_upd_failed      EXCEPTION; --The update operation failed
   e_del_failed      EXCEPTION; --The delete operation failed

   /**
   * Generates a SHA1 hash for optimistic locking purposes.
   *
   * @param    p_id        must be NOT NULL
   */
   FUNCTION hash (
                  p_id IN ctaxcob.id%TYPE
                 )
    RETURN VARCHAR2;

   /**
   * This function generates a SHA1 hash for optimistic locking purposes.
   * Access directly to the row by rowid
   *
   * @param  p_rowid  must be NOT NULL
   */
   FUNCTION hash_rowid (p_rowid IN varchar2)
   RETURN varchar2;

   /**
   * This is a table encapsulation function designed to retrieve information from the ctaxcob table.
   *
   * @param      p_id      must be NOT NULL
   * @return     ctaxcob Record Type
   */
   FUNCTION rt (
                p_id IN ctaxcob.id%TYPE 
               )
    RETURN ctaxcob_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information
   * from the ctaxcob table while placing a lock on it for a potential
   * update/delete. Do not use this for updates in web based apps, instead use the
   * rt_for_web_update function to get a FOR_WEB_UPDATE_RT record which
   * includes all of the tables columns along with an md5 checksum for use in the
   * web_upd and web_del procedures.
   *
   * @param      p_id      must be NOT NULL
   * @return     ctaxcob Record Type
   */
   FUNCTION rt_for_update (
                          p_id IN ctaxcob.id%TYPE 
                          )
    RETURN ctaxcob_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information from the ctaxcob table.
   * This function return Record Table as PIPELINED Function
   *
   * @param      p_id      must be NOT NULL
   * @return     ctaxcob Table Record Type
   */
   FUNCTION tt (
                p_id IN ctaxcob.id%TYPE DEFAULT NULL
               )
   RETURN ctaxcob_tt
   PIPELINED;

   /**
   * This is a table encapsulation function designed to insert a row into the ctaxcob table.
   *
   * @param      p_ctaxcob_rec       Record Type
   * @return     p_ctaxcob_rec       Record Type
   */
   PROCEDURE ins (p_ctaxcob_rec IN OUT ctaxcob_rt);

   /**
   * This is a table encapsulation function designed to update a row in the ctaxcob table.
   *
   * @param      p_ctaxcob_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd (p_ctaxcob_rec IN ctaxcob_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row in the ctaxcob table,
   * access directly to the row by rowid
   *
   * @param      p_ctaxcob_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd_rowid (p_ctaxcob_rec IN ctaxcob_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the ctaxcob table whith optimistic lock validation
   *
   * @param      p_ctaxcob_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd (p_ctaxcob_rec IN ctaxcob_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the ctaxcob table whith optimistic lock validation
   * access directly to the row by rowid
   *
   * @param      p_ctaxcob_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd_rowid (p_ctaxcob_rec IN ctaxcob_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to delete a row from the ctaxcob table.
   *
   * @param    p_id        must be NOT NULL
   */
   PROCEDURE del (
                  p_id IN ctaxcob.id%TYPE
                );

   /**
   * This is a table encapsulation function designed to delete a row from the ctaxcob table
   * access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   */
    PROCEDURE del_rowid (p_rowid IN VARCHAR2);

   /**
   * This is a table encapsulation function designed to delete a row from the ctaxcob table
   * whith optimistic lock validation
   *
   * @param      p_id      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del (
                      p_id IN ctaxcob.id%TYPE,
                      p_hash IN varchar2
                      );

   /**
   * This is a table encapsulation function designed to delete a row from the ctaxcob table
   * whith optimistic lock validation, access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del_rowid (p_rowid IN varchar2, p_hash IN varchar2);

END tapi_ctaxcob;
 

/
--------------------------------------------------------
--  DDL for Package TAPI_DEPOSITO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."TAPI_DEPOSITO" 
IS
   /**
   * TAPI_DEPOSITO
   * Generated by: tapiGen2 - DO NOT MODIFY!
   * Website: github.com/osalvador/tapiGen2
   * Created On: 05-OCT-2019 09:51
   * Created By: FUNDAUC
   */

   --Scalar/Column types
   SUBTYPE hash_t IS varchar2 (40);
   SUBTYPE referencia IS deposito.referencia%TYPE;
   SUBTYPE fecha_emi IS deposito.fecha_emi%TYPE;
   SUBTYPE id_banco IS deposito.id_banco%TYPE;
   SUBTYPE monto IS deposito.monto%TYPE;
   SUBTYPE sede IS deposito.sede%TYPE;
   SUBTYPE usuario IS deposito.usuario%TYPE;
   SUBTYPE status IS deposito.status%TYPE;
   SUBTYPE forma_pago IS deposito.forma_pago%TYPE;
   SUBTYPE id IS deposito.id%TYPE;

   --Record type
   TYPE deposito_rt
   IS
      RECORD (
            referencia deposito.referencia%TYPE,
            fecha_emi deposito.fecha_emi%TYPE,
            id_banco deposito.id_banco%TYPE,
            monto deposito.monto%TYPE,
            sede deposito.sede%TYPE,
            usuario deposito.usuario%TYPE,
            status deposito.status%TYPE,
            forma_pago deposito.forma_pago%TYPE,
            id deposito.id%TYPE,
            hash               hash_t,
            row_id            VARCHAR2(64)
      );
   --Collection types (record)
   TYPE deposito_tt IS TABLE OF deposito_rt;

   --Global exceptions
   e_ol_check_failed EXCEPTION; --Optimistic lock check failed
   e_row_missing     EXCEPTION; --The cursor failed to get a row
   e_upd_failed      EXCEPTION; --The update operation failed
   e_del_failed      EXCEPTION; --The delete operation failed

   /**
   * Generates a SHA1 hash for optimistic locking purposes.
   *
   * @param    p_id        must be NOT NULL
   */
   FUNCTION hash (
                  p_id IN deposito.id%TYPE
                 )
    RETURN VARCHAR2;

   /**
   * This function generates a SHA1 hash for optimistic locking purposes.
   * Access directly to the row by rowid
   *
   * @param  p_rowid  must be NOT NULL
   */
   FUNCTION hash_rowid (p_rowid IN varchar2)
   RETURN varchar2;

   /**
   * This is a table encapsulation function designed to retrieve information from the deposito table.
   *
   * @param      p_id      must be NOT NULL
   * @return     deposito Record Type
   */
   FUNCTION rt (
                p_id IN deposito.id%TYPE 
               )
    RETURN deposito_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information
   * from the deposito table while placing a lock on it for a potential
   * update/delete. Do not use this for updates in web based apps, instead use the
   * rt_for_web_update function to get a FOR_WEB_UPDATE_RT record which
   * includes all of the tables columns along with an md5 checksum for use in the
   * web_upd and web_del procedures.
   *
   * @param      p_id      must be NOT NULL
   * @return     deposito Record Type
   */
   FUNCTION rt_for_update (
                          p_id IN deposito.id%TYPE 
                          )
    RETURN deposito_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information from the deposito table.
   * This function return Record Table as PIPELINED Function
   *
   * @param      p_id      must be NOT NULL
   * @return     deposito Table Record Type
   */
   FUNCTION tt (
                p_id IN deposito.id%TYPE DEFAULT NULL
               )
   RETURN deposito_tt
   PIPELINED;

   /**
   * This is a table encapsulation function designed to insert a row into the deposito table.
   *
   * @param      p_deposito_rec       Record Type
   * @return     p_deposito_rec       Record Type
   */
   PROCEDURE ins (p_deposito_rec IN OUT deposito_rt);

   /**
   * This is a table encapsulation function designed to update a row in the deposito table.
   *
   * @param      p_deposito_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd (p_deposito_rec IN deposito_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row in the deposito table,
   * access directly to the row by rowid
   *
   * @param      p_deposito_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd_rowid (p_deposito_rec IN deposito_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the deposito table whith optimistic lock validation
   *
   * @param      p_deposito_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd (p_deposito_rec IN deposito_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the deposito table whith optimistic lock validation
   * access directly to the row by rowid
   *
   * @param      p_deposito_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd_rowid (p_deposito_rec IN deposito_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to delete a row from the deposito table.
   *
   * @param    p_id        must be NOT NULL
   */
   PROCEDURE del (
                  p_id IN deposito.id%TYPE
                );

   /**
   * This is a table encapsulation function designed to delete a row from the deposito table
   * access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   */
    PROCEDURE del_rowid (p_rowid IN VARCHAR2);

   /**
   * This is a table encapsulation function designed to delete a row from the deposito table
   * whith optimistic lock validation
   *
   * @param      p_id      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del (
                      p_id IN deposito.id%TYPE,
                      p_hash IN varchar2
                      );

   /**
   * This is a table encapsulation function designed to delete a row from the deposito table
   * whith optimistic lock validation, access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del_rowid (p_rowid IN varchar2, p_hash IN varchar2);

END tapi_deposito;
 

/
--------------------------------------------------------
--  DDL for Package TAPI_DETALLE_FACTURA
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."TAPI_DETALLE_FACTURA" 
IS
   /**
   * TAPI_DETALLE_FACTURA
   * Generated by: tapiGen2 - DO NOT MODIFY!
   * Website: github.com/osalvador/tapiGen2
   * Created On: 25-FEB-2020 18:39
   * Created By: FUNDAUC
   */

   --Scalar/Column types
   SUBTYPE hash_t IS varchar2 (40);
   SUBTYPE renglon IS detalle_factura.renglon%TYPE;
   SUBTYPE tipo_item IS detalle_factura.tipo_item%TYPE;
   SUBTYPE item IS detalle_factura.item%TYPE;
   SUBTYPE descripcion IS detalle_factura.descripcion%TYPE;
   SUBTYPE cantidad IS detalle_factura.cantidad%TYPE;
   SUBTYPE p_unidad IS detalle_factura.p_unidad%TYPE;
   SUBTYPE bs_descuento IS detalle_factura.bs_descuento%TYPE;
   SUBTYPE subtotal IS detalle_factura.subtotal%TYPE;
   SUBTYPE materiales_id IS detalle_factura.materiales_id%TYPE;
   SUBTYPE factura_id IS detalle_factura.factura_id%TYPE;

   --Record type
   TYPE detalle_factura_rt
   IS
      RECORD (
            renglon detalle_factura.renglon%TYPE,
            tipo_item detalle_factura.tipo_item%TYPE,
            item detalle_factura.item%TYPE,
            descripcion detalle_factura.descripcion%TYPE,
            cantidad detalle_factura.cantidad%TYPE,
            p_unidad detalle_factura.p_unidad%TYPE,
            bs_descuento detalle_factura.bs_descuento%TYPE,
            subtotal detalle_factura.subtotal%TYPE,
            materiales_id detalle_factura.materiales_id%TYPE,
            factura_id detalle_factura.factura_id%TYPE,
            hash               hash_t,
            row_id            VARCHAR2(64)
      );
   --Collection types (record)
   TYPE detalle_factura_tt IS TABLE OF detalle_factura_rt;

   --Global exceptions
   e_ol_check_failed EXCEPTION; --Optimistic lock check failed
   e_row_missing     EXCEPTION; --The cursor failed to get a row
   e_upd_failed      EXCEPTION; --The update operation failed
   e_del_failed      EXCEPTION; --The delete operation failed

   /**
   * Generates a SHA1 hash for optimistic locking purposes.
   *
   * @param    p_renglon        must be NOT NULL
   */
   FUNCTION hash (
                  p_renglon IN detalle_factura.renglon%TYPE
                 )
    RETURN VARCHAR2;

   /**
   * This function generates a SHA1 hash for optimistic locking purposes.
   * Access directly to the row by rowid
   *
   * @param  p_rowid  must be NOT NULL
   */
   FUNCTION hash_rowid (p_rowid IN varchar2)
   RETURN varchar2;

   /**
   * This is a table encapsulation function designed to retrieve information from the detalle_factura table.
   *
   * @param      p_renglon      must be NOT NULL
   * @return     detalle_factura Record Type
   */
   FUNCTION rt (
                p_renglon IN detalle_factura.renglon%TYPE 
               )
    RETURN detalle_factura_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information
   * from the detalle_factura table while placing a lock on it for a potential
   * update/delete. Do not use this for updates in web based apps, instead use the
   * rt_for_web_update function to get a FOR_WEB_UPDATE_RT record which
   * includes all of the tables columns along with an md5 checksum for use in the
   * web_upd and web_del procedures.
   *
   * @param      p_renglon      must be NOT NULL
   * @return     detalle_factura Record Type
   */
   FUNCTION rt_for_update (
                          p_renglon IN detalle_factura.renglon%TYPE 
                          )
    RETURN detalle_factura_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information from the detalle_factura table.
   * This function return Record Table as PIPELINED Function
   *
   * @param      p_renglon      must be NOT NULL
   * @return     detalle_factura Table Record Type
   */
   FUNCTION tt (
                p_renglon IN detalle_factura.renglon%TYPE DEFAULT NULL
               )
   RETURN detalle_factura_tt
   PIPELINED;

   /**
   * This is a table encapsulation function designed to insert a row into the detalle_factura table.
   *
   * @param      p_detalle_factura_rec       Record Type
   * @return     p_detalle_factura_rec       Record Type
   */
   PROCEDURE ins (p_detalle_factura_rec IN OUT detalle_factura_rt);

   /**
   * This is a table encapsulation function designed to update a row in the detalle_factura table.
   *
   * @param      p_detalle_factura_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd (p_detalle_factura_rec IN detalle_factura_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row in the detalle_factura table,
   * access directly to the row by rowid
   *
   * @param      p_detalle_factura_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd_rowid (p_detalle_factura_rec IN detalle_factura_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the detalle_factura table whith optimistic lock validation
   *
   * @param      p_detalle_factura_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd (p_detalle_factura_rec IN detalle_factura_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the detalle_factura table whith optimistic lock validation
   * access directly to the row by rowid
   *
   * @param      p_detalle_factura_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd_rowid (p_detalle_factura_rec IN detalle_factura_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to delete a row from the detalle_factura table.
   *
   * @param    p_renglon        must be NOT NULL
   */
   PROCEDURE del (
                  p_renglon IN detalle_factura.renglon%TYPE
                );

   /**
   * This is a table encapsulation function designed to delete a row from the detalle_factura table
   * access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   */
    PROCEDURE del_rowid (p_rowid IN VARCHAR2);

   /**
   * This is a table encapsulation function designed to delete a row from the detalle_factura table
   * whith optimistic lock validation
   *
   * @param      p_renglon      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del (
                      p_renglon IN detalle_factura.renglon%TYPE,
                      p_hash IN varchar2
                      );

   /**
   * This is a table encapsulation function designed to delete a row from the detalle_factura table
   * whith optimistic lock validation, access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del_rowid (p_rowid IN varchar2, p_hash IN varchar2);

END tapi_detalle_factura;
 

/
--------------------------------------------------------
--  DDL for Package TAPI_ESTUDIANTE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."TAPI_ESTUDIANTE" 
IS
   /**
   * TAPI_ESTUDIANTE
   * Generated by: tapiGen2 - DO NOT MODIFY!
   * Website: github.com/osalvador/tapiGen2
   * Created On: 13-SEP-2019 10:24
   * Created By: FUNDAUC
   */

   --Scalar/Column types
   SUBTYPE hash_t IS varchar2 (40);
   SUBTYPE cedula_est IS estudiante.cedula_est%TYPE;
   SUBTYPE nacionalidad IS estudiante.nacionalidad%TYPE;
   SUBTYPE nombre IS estudiante.nombre%TYPE;
   SUBTYPE telf_hab IS estudiante.telf_hab%TYPE;
   SUBTYPE telf_cel IS estudiante.telf_cel%TYPE;
   SUBTYPE ciudad IS estudiante.ciudad%TYPE;
   SUBTYPE estado IS estudiante.estado%TYPE;
   SUBTYPE email IS estudiante.email%TYPE;
   SUBTYPE sexo IS estudiante.sexo%TYPE;
   SUBTYPE edo_civil IS estudiante.edo_civil%TYPE;
   SUBTYPE grado_ins IS estudiante.grado_ins%TYPE;
   SUBTYPE profesion IS estudiante.profesion%TYPE;
   SUBTYPE fecha_nac IS estudiante.fecha_nac%TYPE;
   SUBTYPE status IS estudiante.status%TYPE;
   SUBTYPE id_tipo_est IS estudiante.id_tipo_est%TYPE;
   SUBTYPE rif IS estudiante.rif%TYPE;
   SUBTYPE matricula IS estudiante.matricula%TYPE;
   SUBTYPE sede IS estudiante.sede%TYPE;
   SUBTYPE condicion_especial IS estudiante.condicion_especial%TYPE;
   SUBTYPE apellido IS estudiante.apellido%TYPE;
   SUBTYPE zona IS estudiante.zona%TYPE;
   SUBTYPE cedula_rep IS estudiante.cedula_rep%TYPE;
   SUBTYPE direccion IS estudiante.direccion%TYPE;
   SUBTYPE creado_por IS estudiante.creado_por%TYPE;
   SUBTYPE creado_el IS estudiante.creado_el%TYPE;
   SUBTYPE modificado_por IS estudiante.modificado_por%TYPE;
   SUBTYPE modificado_el IS estudiante.modificado_el%TYPE;

   --Record type
   TYPE estudiante_rt
   IS
      RECORD (
            cedula_est estudiante.cedula_est%TYPE,
            nacionalidad estudiante.nacionalidad%TYPE,
            nombre estudiante.nombre%TYPE,
            telf_hab estudiante.telf_hab%TYPE,
            telf_cel estudiante.telf_cel%TYPE,
            ciudad estudiante.ciudad%TYPE,
            estado estudiante.estado%TYPE,
            email estudiante.email%TYPE,
            sexo estudiante.sexo%TYPE,
            edo_civil estudiante.edo_civil%TYPE,
            grado_ins estudiante.grado_ins%TYPE,
            profesion estudiante.profesion%TYPE,
            fecha_nac estudiante.fecha_nac%TYPE,
            status estudiante.status%TYPE,
            id_tipo_est estudiante.id_tipo_est%TYPE,
            rif estudiante.rif%TYPE,
            matricula estudiante.matricula%TYPE,
            sede estudiante.sede%TYPE,
            condicion_especial estudiante.condicion_especial%TYPE,
            apellido estudiante.apellido%TYPE,
            zona estudiante.zona%TYPE,
            cedula_rep estudiante.cedula_rep%TYPE,
            direccion estudiante.direccion%TYPE,
            creado_por estudiante.creado_por%TYPE,
            creado_el estudiante.creado_el%TYPE,
            modificado_por estudiante.modificado_por%TYPE,
            modificado_el estudiante.modificado_el%TYPE,
            hash               hash_t,
            row_id            VARCHAR2(64)
      );
   --Collection types (record)
   TYPE estudiante_tt IS TABLE OF estudiante_rt;

   --Global exceptions
   e_ol_check_failed EXCEPTION; --Optimistic lock check failed
   e_row_missing     EXCEPTION; --The cursor failed to get a row
   e_upd_failed      EXCEPTION; --The update operation failed
   e_del_failed      EXCEPTION; --The delete operation failed

   /**
   * Generates a SHA1 hash for optimistic locking purposes.
   *
   * @param    p_matricula        must be NOT NULL
   */
   FUNCTION hash (
                  p_matricula IN estudiante.matricula%TYPE
                 )
    RETURN VARCHAR2;

   /**
   * This function generates a SHA1 hash for optimistic locking purposes.
   * Access directly to the row by rowid
   *
   * @param  p_rowid  must be NOT NULL
   */
   FUNCTION hash_rowid (p_rowid IN varchar2)
   RETURN varchar2;

   /**
   * This is a table encapsulation function designed to retrieve information from the estudiante table.
   *
   * @param      p_matricula      must be NOT NULL
   * @return     estudiante Record Type
   */
   FUNCTION rt (
                p_matricula IN estudiante.matricula%TYPE 
               )
    RETURN estudiante_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information
   * from the estudiante table while placing a lock on it for a potential
   * update/delete. Do not use this for updates in web based apps, instead use the
   * rt_for_web_update function to get a FOR_WEB_UPDATE_RT record which
   * includes all of the tables columns along with an md5 checksum for use in the
   * web_upd and web_del procedures.
   *
   * @param      p_matricula      must be NOT NULL
   * @return     estudiante Record Type
   */
   FUNCTION rt_for_update (
                          p_matricula IN estudiante.matricula%TYPE 
                          )
    RETURN estudiante_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information from the estudiante table.
   * This function return Record Table as PIPELINED Function
   *
   * @param      p_matricula      must be NOT NULL
   * @return     estudiante Table Record Type
   */
   FUNCTION tt (
                p_matricula IN estudiante.matricula%TYPE DEFAULT NULL
               )
   RETURN estudiante_tt
   PIPELINED;

   /**
   * This is a table encapsulation function designed to insert a row into the estudiante table.
   *
   * @param      p_estudiante_rec       Record Type
   * @return     p_estudiante_rec       Record Type
   */
   PROCEDURE ins (p_estudiante_rec IN OUT estudiante_rt);

   /**
   * This is a table encapsulation function designed to update a row in the estudiante table.
   *
   * @param      p_estudiante_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd (p_estudiante_rec IN estudiante_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row in the estudiante table,
   * access directly to the row by rowid
   *
   * @param      p_estudiante_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd_rowid (p_estudiante_rec IN estudiante_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the estudiante table whith optimistic lock validation
   *
   * @param      p_estudiante_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd (p_estudiante_rec IN estudiante_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the estudiante table whith optimistic lock validation
   * access directly to the row by rowid
   *
   * @param      p_estudiante_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd_rowid (p_estudiante_rec IN estudiante_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to delete a row from the estudiante table.
   *
   * @param    p_matricula        must be NOT NULL
   */
   PROCEDURE del (
                  p_matricula IN estudiante.matricula%TYPE
                );

   /**
   * This is a table encapsulation function designed to delete a row from the estudiante table
   * access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   */
    PROCEDURE del_rowid (p_rowid IN VARCHAR2);

   /**
   * This is a table encapsulation function designed to delete a row from the estudiante table
   * whith optimistic lock validation
   *
   * @param      p_matricula      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del (
                      p_matricula IN estudiante.matricula%TYPE,
                      p_hash IN varchar2
                      );

   /**
   * This is a table encapsulation function designed to delete a row from the estudiante table
   * whith optimistic lock validation, access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del_rowid (p_rowid IN varchar2, p_hash IN varchar2);

END tapi_estudiante;
 

/
--------------------------------------------------------
--  DDL for Package TAPI_FACTURA
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."TAPI_FACTURA" 
IS
   /**
   * TAPI_FACTURA
   * Generated by: tapiGen2 - DO NOT MODIFY!
   * Website: github.com/osalvador/tapiGen2
   * Created On: 25-SEP-2019 08:27
   * Created By: FUNDAUC
   */

   --Scalar/Column types
   SUBTYPE hash_t IS varchar2 (40);
   SUBTYPE id_fact IS factura.id_fact%TYPE;
   SUBTYPE tipo IS factura.tipo%TYPE;
   SUBTYPE cedula_est IS factura.cedula_est%TYPE;
   SUBTYPE nombre_cliente IS factura.nombre_cliente%TYPE;
   SUBTYPE fecha_emi IS factura.fecha_emi%TYPE;
   SUBTYPE monto IS factura.monto%TYPE;
   SUBTYPE p_iva IS factura.p_iva%TYPE;
   SUBTYPE monto_iva IS factura.monto_iva%TYPE;
   SUBTYPE flete IS factura.flete%TYPE;
   SUBTYPE bs_descuento IS factura.bs_descuento%TYPE;
   SUBTYPE dir_fiscal IS factura.dir_fiscal%TYPE;
   SUBTYPE rif IS factura.rif%TYPE;
   SUBTYPE status IS factura.status%TYPE;
   SUBTYPE programa IS factura.programa%TYPE;
   SUBTYPE prog_academico IS factura.prog_academico%TYPE;
   SUBTYPE creado_por IS factura.creado_por%TYPE;
   SUBTYPE monto_exento IS factura.monto_exento%TYPE;
   SUBTYPE base_imponible IS factura.base_imponible%TYPE;
   SUBTYPE id IS factura.id%TYPE;
   SUBTYPE creado_el IS factura.creado_el%TYPE;
   SUBTYPE facturado_por IS factura.facturado_por%TYPE;
   SUBTYPE observaciones IS factura.observaciones%TYPE;
   SUBTYPE escredito IS factura.escredito%TYPE;

   --Record type
   TYPE factura_rt
   IS
      RECORD (
            id_fact factura.id_fact%TYPE,
            tipo factura.tipo%TYPE,
            cedula_est factura.cedula_est%TYPE,
            nombre_cliente factura.nombre_cliente%TYPE,
            fecha_emi factura.fecha_emi%TYPE,
            monto factura.monto%TYPE,
            p_iva factura.p_iva%TYPE,
            monto_iva factura.monto_iva%TYPE,
            flete factura.flete%TYPE,
            bs_descuento factura.bs_descuento%TYPE,
            dir_fiscal factura.dir_fiscal%TYPE,
            rif factura.rif%TYPE,
            status factura.status%TYPE,
            programa factura.programa%TYPE,
            prog_academico factura.prog_academico%TYPE,
            creado_por factura.creado_por%TYPE,
            monto_exento factura.monto_exento%TYPE,
            base_imponible factura.base_imponible%TYPE,
            id factura.id%TYPE,
            creado_el factura.creado_el%TYPE,
            facturado_por factura.facturado_por%TYPE,
            observaciones factura.observaciones%TYPE,
            escredito factura.escredito%TYPE,
            hash               hash_t,
            row_id            VARCHAR2(64)
      );
   --Collection types (record)
   TYPE factura_tt IS TABLE OF factura_rt;

   --Global exceptions
   e_ol_check_failed EXCEPTION; --Optimistic lock check failed
   e_row_missing     EXCEPTION; --The cursor failed to get a row
   e_upd_failed      EXCEPTION; --The update operation failed
   e_del_failed      EXCEPTION; --The delete operation failed

   /**
   * Generates a SHA1 hash for optimistic locking purposes.
   *
   * @param    p_id        must be NOT NULL
   */
   FUNCTION hash (
                  p_id IN factura.id%TYPE
                 )
    RETURN VARCHAR2;

   /**
   * This function generates a SHA1 hash for optimistic locking purposes.
   * Access directly to the row by rowid
   *
   * @param  p_rowid  must be NOT NULL
   */
   FUNCTION hash_rowid (p_rowid IN varchar2)
   RETURN varchar2;

   /**
   * This is a table encapsulation function designed to retrieve information from the factura table.
   *
   * @param      p_id      must be NOT NULL
   * @return     factura Record Type
   */
   FUNCTION rt (
                p_id IN factura.id%TYPE 
               )
    RETURN factura_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information
   * from the factura table while placing a lock on it for a potential
   * update/delete. Do not use this for updates in web based apps, instead use the
   * rt_for_web_update function to get a FOR_WEB_UPDATE_RT record which
   * includes all of the tables columns along with an md5 checksum for use in the
   * web_upd and web_del procedures.
   *
   * @param      p_id      must be NOT NULL
   * @return     factura Record Type
   */
   FUNCTION rt_for_update (
                          p_id IN factura.id%TYPE 
                          )
    RETURN factura_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information from the factura table.
   * This function return Record Table as PIPELINED Function
   *
   * @param      p_id      must be NOT NULL
   * @return     factura Table Record Type
   */
   FUNCTION tt (
                p_id IN factura.id%TYPE DEFAULT NULL
               )
   RETURN factura_tt
   PIPELINED;

   /**
   * This is a table encapsulation function designed to insert a row into the factura table.
   *
   * @param      p_factura_rec       Record Type
   * @return     p_factura_rec       Record Type
   */
   PROCEDURE ins (p_factura_rec IN OUT factura_rt);

   /**
   * This is a table encapsulation function designed to update a row in the factura table.
   *
   * @param      p_factura_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd (p_factura_rec IN factura_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row in the factura table,
   * access directly to the row by rowid
   *
   * @param      p_factura_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd_rowid (p_factura_rec IN factura_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the factura table whith optimistic lock validation
   *
   * @param      p_factura_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd (p_factura_rec IN factura_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the factura table whith optimistic lock validation
   * access directly to the row by rowid
   *
   * @param      p_factura_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd_rowid (p_factura_rec IN factura_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to delete a row from the factura table.
   *
   * @param    p_id        must be NOT NULL
   */
   PROCEDURE del (
                  p_id IN factura.id%TYPE
                );

   /**
   * This is a table encapsulation function designed to delete a row from the factura table
   * access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   */
    PROCEDURE del_rowid (p_rowid IN VARCHAR2);

   /**
   * This is a table encapsulation function designed to delete a row from the factura table
   * whith optimistic lock validation
   *
   * @param      p_id      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del (
                      p_id IN factura.id%TYPE,
                      p_hash IN varchar2
                      );

   /**
   * This is a table encapsulation function designed to delete a row from the factura table
   * whith optimistic lock validation, access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del_rowid (p_rowid IN varchar2, p_hash IN varchar2);

END tapi_factura;
 

/
--------------------------------------------------------
--  DDL for Package TAPI_FACTURA_DEPOSITO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."TAPI_FACTURA_DEPOSITO" 
IS
   /**
   * TAPI_FACTURA_DEPOSITO
   * Generated by: tapiGen2 - DO NOT MODIFY!
   * Website: github.com/osalvador/tapiGen2
   * Created On: 04-AGO-2019 21:41
   * Created By: FUNDAUC
   */

   --Scalar/Column types
   SUBTYPE hash_t IS varchar2 (40);
   SUBTYPE deposito_id IS factura_deposito.deposito_id%TYPE;
   SUBTYPE factura_id IS factura_deposito.factura_id%TYPE;

   --Record type
   TYPE factura_deposito_rt
   IS
      RECORD (
            deposito_id factura_deposito.deposito_id%TYPE,
            factura_id factura_deposito.factura_id%TYPE,
            hash               hash_t,
            row_id            VARCHAR2(64)
      );
   --Collection types (record)
   TYPE factura_deposito_tt IS TABLE OF factura_deposito_rt;

   --Global exceptions
   e_ol_check_failed EXCEPTION; --Optimistic lock check failed
   e_row_missing     EXCEPTION; --The cursor failed to get a row
   e_upd_failed      EXCEPTION; --The update operation failed
   e_del_failed      EXCEPTION; --The delete operation failed

   /**
   * Generates a SHA1 hash for optimistic locking purposes.
   *
   * @param    p_deposito_id        must be NOT NULL
   * @param    p_factura_id        must be NOT NULL
   */
   FUNCTION hash (
                  p_deposito_id IN factura_deposito.deposito_id%TYPE,
                  p_factura_id IN factura_deposito.factura_id%TYPE
                 )
    RETURN VARCHAR2;

   /**
   * This function generates a SHA1 hash for optimistic locking purposes.
   * Access directly to the row by rowid
   *
   * @param  p_rowid  must be NOT NULL
   */
   FUNCTION hash_rowid (p_rowid IN varchar2)
   RETURN varchar2;

   /**
   * This is a table encapsulation function designed to retrieve information from the factura_deposito table.
   *
   * @param      p_deposito_id      must be NOT NULL
   * @param      p_factura_id      must be NOT NULL
   * @return     factura_deposito Record Type
   */
   FUNCTION rt (
                p_deposito_id IN factura_deposito.deposito_id%TYPE ,
                p_factura_id IN factura_deposito.factura_id%TYPE 
               )
    RETURN factura_deposito_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information
   * from the factura_deposito table while placing a lock on it for a potential
   * update/delete. Do not use this for updates in web based apps, instead use the
   * rt_for_web_update function to get a FOR_WEB_UPDATE_RT record which
   * includes all of the tables columns along with an md5 checksum for use in the
   * web_upd and web_del procedures.
   *
   * @param      p_deposito_id      must be NOT NULL
   * @param      p_factura_id      must be NOT NULL
   * @return     factura_deposito Record Type
   */
   FUNCTION rt_for_update (
                          p_deposito_id IN factura_deposito.deposito_id%TYPE ,
                          p_factura_id IN factura_deposito.factura_id%TYPE 
                          )
    RETURN factura_deposito_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information from the factura_deposito table.
   * This function return Record Table as PIPELINED Function
   *
   * @param      p_deposito_id      must be NOT NULL
   * @param      p_factura_id      must be NOT NULL
   * @return     factura_deposito Table Record Type
   */
   FUNCTION tt (
                p_deposito_id IN factura_deposito.deposito_id%TYPE DEFAULT NULL,
                p_factura_id IN factura_deposito.factura_id%TYPE DEFAULT NULL
               )
   RETURN factura_deposito_tt
   PIPELINED;

   /**
   * This is a table encapsulation function designed to insert a row into the factura_deposito table.
   *
   * @param      p_factura_deposito_rec       Record Type
   * @return     p_factura_deposito_rec       Record Type
   */
   PROCEDURE ins (p_factura_deposito_rec IN OUT factura_deposito_rt);

   /**
   * This is a table encapsulation function designed to update a row in the factura_deposito table.
   *
   * @param      p_factura_deposito_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd (p_factura_deposito_rec IN factura_deposito_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row in the factura_deposito table,
   * access directly to the row by rowid
   *
   * @param      p_factura_deposito_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd_rowid (p_factura_deposito_rec IN factura_deposito_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the factura_deposito table whith optimistic lock validation
   *
   * @param      p_factura_deposito_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd (p_factura_deposito_rec IN factura_deposito_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the factura_deposito table whith optimistic lock validation
   * access directly to the row by rowid
   *
   * @param      p_factura_deposito_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd_rowid (p_factura_deposito_rec IN factura_deposito_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to delete a row from the factura_deposito table.
   *
   * @param    p_deposito_id        must be NOT NULL
   * @param    p_factura_id        must be NOT NULL
   */
   PROCEDURE del (
                  p_deposito_id IN factura_deposito.deposito_id%TYPE,
                  p_factura_id IN factura_deposito.factura_id%TYPE
                );

   /**
   * This is a table encapsulation function designed to delete a row from the factura_deposito table
   * access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   */
    PROCEDURE del_rowid (p_rowid IN VARCHAR2);

   /**
   * This is a table encapsulation function designed to delete a row from the factura_deposito table
   * whith optimistic lock validation
   *
   * @param      p_deposito_id      must be NOT NULL
   * @param      p_factura_id      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del (
                      p_deposito_id IN factura_deposito.deposito_id%TYPE,
                      p_factura_id IN factura_deposito.factura_id%TYPE,
                      p_hash IN varchar2
                      );

   /**
   * This is a table encapsulation function designed to delete a row from the factura_deposito table
   * whith optimistic lock validation, access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del_rowid (p_rowid IN varchar2, p_hash IN varchar2);

END tapi_factura_deposito;


/
--------------------------------------------------------
--  DDL for Package TAPI_GEN2
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."TAPI_GEN2" authid current_user
AS

   /**
   * TAPI_GEN2
   * Generated by: Oscar Salvador Magallanes
   * Website: github.com/osalvador/tapiGen2
   * Created On: 16-JUL-2015
   */

   --Global public data structures
   SUBTYPE dbo_name_t IS VARCHAR2 (30); -- Max size for a DB object name

   TYPE dbo_name_aat IS TABLE OF dbo_name_t;

    TYPE column_rt
    IS
      RECORD (
         table_name        user_tab_columns.table_name%TYPE
       , column_name       user_tab_columns.column_name%TYPE
       , nullable          user_tab_columns.nullable%TYPE
       , constraint_type   user_constraints.constraint_type%TYPE
      );

   --Collection types (record)
   TYPE column_tt IS TABLE OF column_rt;

   TYPE constraint_tt IS TABLE OF user_constraints%ROWTYPE;

   /**
   * Create PL/SQL Table API
   *
   * @param     p_table_name              must be NOT NULL
   * @param     p_compile_table_api       TRUE for compile generated package, FALSE to DBMS_OUTPUT the source
   * @param     p_unique_key              If the table has no primary key, it indicates the column that will be used as a unique key
   * @param     p_created_by_col_name     Custom audit column
   * @param     p_created_date_col_name   Custom audit column
   * @param     p_modified_by_col_name    Custom audit column
   * @param     p_modified_date_col_name  Custom audit column
   * @param     p_raise_exceptions        TRUE to use logger for exception handling
   */
   PROCEDURE create_tapi_package (p_table_name               IN VARCHAR2
                                , p_compile_table_api        IN BOOLEAN DEFAULT TRUE
                                , p_unique_key               IN VARCHAR2 DEFAULT NULL
                                , p_created_by_col_name      IN VARCHAR2 DEFAULT NULL
                                , p_created_date_col_name    IN VARCHAR2 DEFAULT NULL
                                , p_modified_by_col_name     IN VARCHAR2 DEFAULT NULL
                                , p_modified_date_col_name   IN VARCHAR2 DEFAULT NULL
                                , p_raise_exceptions         IN BOOLEAN DEFAULT FALSE);

   --Public functions but for internal use.
   FUNCTION get_all_columns (p_tab_name VARCHAR2)
      RETURN column_tt;

   FUNCTION get_pk_columns (p_tab_name VARCHAR2)
      RETURN column_tt;

   FUNCTION get_noblob_columns (p_tab_name VARCHAR2)
      RETURN column_tt;

--Spec Template
$if false $then
<%@ template
    name=spec
%>
<%! col      tapi_gen2.column_tt := tapi_gen2.get_all_columns ('${table_name}'); %>
<%! pk       tapi_gen2.column_tt := tapi_gen2.get_pk_columns ('${table_name}'); %>
<%! c pls_integer; %>
<%! /* Separator procedure */
    procedure sep (p_cont in pls_integer, p_delimiter in varchar2)
    as
    begin
         if p_cont > 1
         then
               teplsql.p(p_delimiter);
         end if;
    end; %>
CREATE OR REPLACE PACKAGE tapi_${table_name}
IS
   /**
   * TAPI_<%= upper('${table_name}') %>\\n
   * Generated by: tapiGen2 - DO NOT MODIFY!
   * Website: github.com/osalvador/tapiGen2
   * Created On: ${date}
   * Created By: ${user}
   */

   --Scalar/Column types
   SUBTYPE hash_t IS varchar2 (40);
   <% for i in 1 .. col.last loop %>
   SUBTYPE <%= col(i).COLUMN_NAME%> IS ${table_name}.<%= col(i).COLUMN_NAME%>%TYPE;
   <% end loop; %>

   --Record type
   TYPE ${table_name}_rt
   IS
      RECORD (
           <% c := col.last+1;
           for i in 1 .. col.last loop %>
            <%=  col(i).COLUMN_NAME%> ${table_name}.<%=col(i).COLUMN_NAME %>%TYPE,
           <% end loop; %>
            hash               hash_t,
            row_id            VARCHAR2(64)
      );
   --Collection types (record)
   TYPE ${table_name}_tt IS TABLE OF ${table_name}_rt;

   --Global exceptions
   e_ol_check_failed EXCEPTION; --Optimistic lock check failed
   e_row_missing     EXCEPTION; --The cursor failed to get a row
   e_upd_failed      EXCEPTION; --The update operation failed
   e_del_failed      EXCEPTION; --The delete operation failed

   /**
   * Generates a SHA1 hash for optimistic locking purposes.
   *
   <% c := pk.last+1; for i in 1 .. pk.last loop %>
   * @param    p_<%=  pk(i).COLUMN_NAME %>        must be NOT NULL
   <% end loop; %>
   */
   FUNCTION hash (
              <% c := pk.last+1;
                for i in 1 .. pk.last loop %>
                  p_<%=  pk(i).COLUMN_NAME%> IN ${table_name}.<%=pk(i).COLUMN_NAME %>%TYPE<%sep(c-i,',');%>\\n
              <% end loop; %>
                 )
    RETURN VARCHAR2;

   /**
   * This function generates a SHA1 hash for optimistic locking purposes.
   * Access directly to the row by rowid
   *
   * @param  p_rowid  must be NOT NULL
   */
   FUNCTION hash_rowid (p_rowid IN varchar2)
   RETURN varchar2;

   /**
   * This is a table encapsulation function designed to retrieve information from the ${table_name} table.
   *
   <% c := pk.last+1; for i in 1 .. pk.last loop %>
   * @param      p_<%=  pk(i).COLUMN_NAME %>      must be NOT NULL
   <% end loop; %>
   * @return     ${table_name} Record Type
   */
   FUNCTION rt (
             <% c := pk.last+1; for i in 1 .. pk.last loop %>
                p_<%=  pk(i).COLUMN_NAME%> IN ${table_name}.<%=pk(i).COLUMN_NAME %>%TYPE <%sep(c-i,',');%>\\n
             <% end loop; %>
               )
    RETURN ${table_name}_rt ${result_cache};

   /**
   * This is a table encapsulation function designed to retrieve information
   * from the ${table_name} table while placing a lock on it for a potential
   * update/delete. Do not use this for updates in web based apps, instead use the
   * rt_for_web_update function to get a FOR_WEB_UPDATE_RT record which
   * includes all of the tables columns along with an md5 checksum for use in the
   * web_upd and web_del procedures.
   *
   <% c := pk.last+1; for i in 1 .. pk.last loop %>
   * @param      p_<%=  pk(i).COLUMN_NAME %>      must be NOT NULL
   <% end loop; %>
   * @return     ${table_name} Record Type
   */
   FUNCTION rt_for_update (
                      <% c := pk.last+1; for i in 1 .. pk.last loop %>
                          p_<%=  pk(i).COLUMN_NAME%> IN ${table_name}.<%=pk(i).COLUMN_NAME %>%TYPE <%sep(c-i,',');%>\\n
                      <% end loop; %>
                          )
    RETURN ${table_name}_rt ${result_cache};

   /**
   * This is a table encapsulation function designed to retrieve information from the ${table_name} table.
   * This function return Record Table as PIPELINED Function
   *
   <% c := pk.last+1; for i in 1 .. pk.last loop %>
   * @param      p_<%=  pk(i).COLUMN_NAME %>      must be NOT NULL
   <% end loop; %>
   * @return     ${table_name} Table Record Type
   */
   FUNCTION tt (
             <% c := pk.last+1; for i in 1 .. pk.last loop %>
                p_<%=  pk(i).COLUMN_NAME%> IN ${table_name}.<%=pk(i).COLUMN_NAME %>%TYPE DEFAULT NULL<%sep(c-i,',');%>\\n
             <% end loop; %>
               )
   RETURN ${table_name}_tt
   PIPELINED;

   /**
   * This is a table encapsulation function designed to insert a row into the ${table_name} table.
   *
   * @param      p_${table_name}_rec       Record Type
   * @return     p_${table_name}_rec       Record Type
   */
   PROCEDURE ins (p_${table_name}_rec IN OUT ${table_name}_rt);

   /**
   * This is a table encapsulation function designed to update a row in the ${table_name} table.
   *
   * @param      p_${table_name}_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd (p_${table_name}_rec IN ${table_name}_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row in the ${table_name} table,
   * access directly to the row by rowid
   *
   * @param      p_${table_name}_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd_rowid (p_${table_name}_rec IN ${table_name}_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the ${table_name} table whith optimistic lock validation
   *
   * @param      p_${table_name}_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd (p_${table_name}_rec IN ${table_name}_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the ${table_name} table whith optimistic lock validation
   * access directly to the row by rowid
   *
   * @param      p_${table_name}_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd_rowid (p_${table_name}_rec IN ${table_name}_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to delete a row from the ${table_name} table.
   *
   <% c := pk.last+1; for i in 1 .. pk.last loop %>
   * @param    p_<%=  pk(i).COLUMN_NAME %>        must be NOT NULL
   <% end loop; %>
   */
   PROCEDURE del (
              <% c := pk.last+1; for i in 1 .. pk.last loop %>
                  p_<%=pk(i).COLUMN_NAME%> IN ${table_name}.<%=pk(i).COLUMN_NAME %>%TYPE<%sep(c-i,',');%>\\n
              <% end loop; %>
                );

   /**
   * This is a table encapsulation function designed to delete a row from the ${table_name} table
   * access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   */
    PROCEDURE del_rowid (p_rowid IN VARCHAR2);

   /**
   * This is a table encapsulation function designed to delete a row from the ${table_name} table
   * whith optimistic lock validation
   *
   <% c := pk.last+1; for i in 1 .. pk.last loop %>
   * @param      p_<%=  pk(i).COLUMN_NAME %>      must be NOT NULL
   <% end loop; %>
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del (
                   <% c := pk.last+1; for i in 1 .. pk.last loop %>
                      p_<%=pk(i).column_name%> IN ${table_name}.<%=pk(i).column_name %>%TYPE,
                   <% end loop; %>
                      p_hash IN varchar2
                      );

   /**
   * This is a table encapsulation function designed to delete a row from the ${table_name} table
   * whith optimistic lock validation, access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del_rowid (p_rowid IN varchar2, p_hash IN varchar2);

END tapi_${table_name};
$end


--Body Template
$if false $then
<%@ template
    name=body
%>
<%! col      tapi_gen2.column_tt := tapi_gen2.get_all_columns ('${table_name}'); %>
<%! pk       tapi_gen2.column_tt := tapi_gen2.get_pk_columns ('${table_name}'); %>
<%! noblob   tapi_gen2.column_tt := tapi_gen2.get_noblob_columns ('${table_name}'); %>
<%! c pls_integer; %>
<%! /* Separator procedure */
    procedure sep (p_index in pls_integer, p_delimiter in varchar2)
    as
    begin
         if p_index > 1
         then
            teplsql.p(p_delimiter);
         end if;
    end; %>
<%! /*  User column for update */
   procedure column_for_update(p_column_name in varchar2,
                               p_ignore_nulls in boolean,
                               p_index in pls_integer,
                               p_blanks in pls_integer default 16)
   as
    l_blanks varchar2(256);
   begin
     for i in 1 .. p_blanks
     loop
        l_blanks := l_blanks ||' ';
     end loop;

      if ('${created_by_col_name}' <> p_column_name or '${created_by_col_name}' is null)
        and ('${created_date_col_name}' <> p_column_name or '${created_date_col_name}' is null)
     then
        if '${modified_by_col_name}' = p_column_name
        then
           teplsql.p(p_column_name || ' = USER /*dbax_core.g$username or apex_application.g_user*/');
        elsif '${modified_date_col_name}' = p_column_name
        then
           teplsql.p(p_column_name || ' = SYSDATE');
        else
           if p_ignore_nulls
           then
            teplsql.p(p_column_name || ' = ' || 'NVL(p_${table_name}_rec.'|| p_column_name ||','|| p_column_name ||')');
           else
            teplsql.p(p_column_name || ' = p_${table_name}_rec.' || p_column_name);
           end if;
        end if;

        sep(p_index,',\\n' || l_blanks);

     end if;
   end; %>
CREATE OR REPLACE PACKAGE BODY tapi_${table_name} IS

   /**
   * TAPI_<%= upper('${table_name}') %>\\n
   * Generated by: tapiGen2 - DO NOT MODIFY!
   * Website: github.com/osalvador/tapiGen2
   * Created On: ${date}
   * Created By: ${user}
   */

  <% if '${raise_exceptions}' is not null then %>
    --Global logger scope
    gc_scope_prefix CONSTANT varchar2(31) := LOWER($$plsql_unit)||'.';
  <% end if; %>

   --GLOBAL_PRIVATE_CURSORS
   --By PK
   CURSOR ${table_name}_cur (
                    <% c := pk.last+1; for i in 1 .. pk.last loop %>
                       p_<%=pk(i).column_name%> IN ${table_name}.<%=pk(i).column_name %>%TYPE<%sep(c-i,',');%>\\n
                    <% end loop; %>
                       )
   IS
      SELECT
        <% c := col.last+1; for i in 1 .. col.last loop %>
            <%=col(i).column_name%>,
        <% end loop; %>
            tapi_${table_name}.hash(<% c := pk.last+1; for i in 1 .. pk.last loop %><%=pk(i).column_name%><%sep(c-i,','); end loop; %>),
            ROWID
      FROM ${table_name}
      WHERE
        <% c := pk.last+1; for i in 1 .. pk.last loop %>
           <%=pk(i).column_name%> = ${table_name}_cur.p_<%=pk(i).column_name%><%sep(c-i,' AND ');%>\\n
        <% end loop; %>
      FOR UPDATE;

    --By Rowid
    CURSOR ${table_name}_rowid_cur (p_rowid IN VARCHAR2)
    IS
      SELECT
        <% c := col.last+1; for i in 1 .. col.last loop %>
             <%=col(i).column_name%>,
        <% end loop; %>
             tapi_${table_name}.hash(<% c := pk.last+1; for i in 1 .. pk.last loop %><%=pk(i).column_name%><%sep(c-i,','); end loop; %>),
             ROWID
      FROM ${table_name}
      WHERE ROWID = p_rowid
      FOR UPDATE;


    FUNCTION hash (
                <% c := pk.last+1; for i in 1 .. pk.last loop %>
                  p_<%=pk(i).column_name%> IN ${table_name}.<%=pk(i).column_name %>%TYPE<%sep(c-i,',');%>\\n
                <% end loop; %>
                  )
      RETURN varchar2
   IS
    <% if '${raise_exceptions}' is not null then %>
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'hash';
      l_params logger.tab_param;
    <% end if; %>
      l_retval hash_t;
      l_string CLOB;
      l_date_format VARCHAR2(64);
   BEGIN

     <% if '${raise_exceptions}' is not null then
      c := pk.last+1; for i in 1 .. pk.last loop %>
      logger.append_param(l_params, 'p_<%=pk(i).column_name%>', p_<%=pk(i).column_name%>);
      <% end loop; %>
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Getting row data into one string', l_scope);
     <% end if; %>

     --Get actual NLS_DATE_FORMAT
     SELECT   VALUE
       INTO   l_date_format
       FROM   v$nls_parameters
      WHERE   parameter = 'NLS_DATE_FORMAT';

      --Alter session for date columns
      EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT=''YYYY/MM/DD hh24:mi:ss''';

      SELECT
         <% c := noblob.last+1; for i in 1 .. noblob.last loop %>
            <%=noblob(i).column_name%><%sep(c-i,'||');%>\\n
         <% end loop; %>
      INTO l_string
      FROM ${table_name}
      WHERE
        <% c := pk.last+1; for i in 1 .. pk.last loop %>
           <%=pk(i).column_name%> = hash.p_<%=pk(i).column_name%><%sep(c-i,' AND ');%>\\n
        <% end loop; %>
           ;

      --Restore NLS_DATE_FORMAT to default
      EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT=''' || l_date_format|| '''';

      <% if '${raise_exceptions}' is not null then %>
      logger.LOG('Converting into SHA1 hash', l_scope);
      <%end if; %>
      l_retval := DBMS_CRYPTO.hash(l_string, DBMS_CRYPTO.hash_sh1);
      <% if '${raise_exceptions}' is not null then %>
      logger.LOG('END', l_scope);
      <%end if; %>

      RETURN l_retval;

   <% if '${raise_exceptions}' is not null then %>
   EXCEPTION
     WHEN OTHERS
     THEN
        logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
        RAISE;
   <%end if; %>
   END hash;

    FUNCTION hash_rowid (p_rowid IN varchar2)
      RETURN varchar2
   IS
    <% if '${raise_exceptions}' is not null then %>
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'hash_rowid';
      l_params logger.tab_param;
    <% end if; %>
      l_retval hash_t;
      l_string CLOB;
      l_date_format varchar2(64);
   BEGIN
      <% if '${raise_exceptions}' is not null then %>
      logger.append_param(l_params, 'p_rowid', p_rowid);
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Getting row data into one string', l_scope);
      <% end if; %>

      --Get actual NLS_DATE_FORMAT
      SELECT VALUE INTO l_date_format  FROM v$nls_parameters WHERE parameter ='NLS_DATE_FORMAT';

      --Alter session for date columns
      EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT=''YYYY/MM/DD hh24:mi:ss''';

      SELECT
          <% c := noblob.last+1; for i in 1 .. noblob.last loop %>
            <%=noblob(i).column_name%><%sep(c-i,'||');%>\\n
         <% end loop; %>
      INTO l_string
      FROM ${table_name}
      WHERE  ROWID = hash_rowid.p_rowid;

      --Restore NLS_DATE_FORMAT to default
      EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT=''' || l_date_format|| '''';

      <% if '${raise_exceptions}' is not null then %>
      logger.LOG('Converting into SHA1 hash', l_scope);
      <% end if; %>
      l_retval := DBMS_CRYPTO.hash(l_string, DBMS_CRYPTO.hash_sh1);

      <% if '${raise_exceptions}' is not null then %>
      logger.LOG('END', l_scope);
      <% end if; %>
      RETURN l_retval;

   <% if '${raise_exceptions}' is not null then %>
   EXCEPTION
     WHEN OTHERS
     THEN
        logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
        RAISE;
   <% end if; %>
   END hash_rowid;

   FUNCTION rt (
            <% c := pk.last+1; for i in 1 .. pk.last loop %>
               p_<%=pk(i).column_name%> IN ${table_name}.<%=pk(i).column_name %>%TYPE<%sep(c-i,',');%>\\n
            <% end loop; %>
               )
      RETURN ${table_name}_rt ${result_cache}
   IS
    <% if '${raise_exceptions}' is not null then %>
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'rt';
      l_params logger.tab_param;
    <% end if; %>
      l_${table_name}_rec ${table_name}_rt;
   BEGIN
      <% if '${raise_exceptions}' is not null then
      c := pk.last+1; for i in 1 .. pk.last loop %>
      logger.append_param(l_params, 'p_<%=pk(i).column_name%>', p_<%=pk(i).column_name%>);
      <% end loop; %>
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Populating record type from DB', l_scope);
      <% end if; %>

      SELECT a.*,
             tapi_${table_name}.hash(<% c := pk.last+1; for i in 1 .. pk.last loop %><%=pk(i).column_name%><%sep(c-i,','); end loop; %>),
             rowid
      INTO l_${table_name}_rec
      FROM ${table_name} a
      WHERE
        <% c := pk.last+1; for i in 1 .. pk.last loop %>
           <%=pk(i).column_name%> = rt.p_<%=pk(i).column_name%><%sep(c-i,' AND ' );%>\\n
        <% end loop; %>
           ;

      <% if '${raise_exceptions}' is not null then %>
      logger.LOG('END', l_scope);
      <% end if; %>

      RETURN l_${table_name}_rec;

   <% if '${raise_exceptions}' is not null then %>
   EXCEPTION
     WHEN OTHERS
     THEN
        logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
        RAISE;
   <% end if; %>
   END rt;

   FUNCTION rt_for_update (
                        <% c := pk.last+1; for i in 1 .. pk.last loop %>
                          p_<%=pk(i).column_name%> IN ${table_name}.<%=pk(i).column_name %>%TYPE<%sep(c-i,',');%>\\n
                        <% end loop; %>
                          )
      RETURN ${table_name}_rt ${result_cache}
   IS
    <% if '${raise_exceptions}' is not null then %>
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'rt_for_update';
      l_params logger.tab_param;
    <% end if; %>
      l_${table_name}_rec ${table_name}_rt;
   BEGIN

      <% if '${raise_exceptions}' is not null then
       c := pk.last+1; for i in 1 .. pk.last loop %>
      logger.append_param(l_params, 'p_<%=pk(i).column_name%>', p_<%=pk(i).column_name%>);
      <% end loop; %>
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Populating record type from DB', l_scope);
      <% end if; %>

      SELECT a.*,
             tapi_${table_name}.hash(<% c := pk.last+1; for i in 1 .. pk.last loop %><%=pk(i).column_name%><%sep(c-i,','); end loop; %>),
             rowid
      INTO l_${table_name}_rec
      FROM ${table_name} a
      WHERE
        <% c := pk.last+1; for i in 1 .. pk.last loop %>
           <%=pk(i).column_name%> = rt_for_update.p_<%=pk(i).column_name%><%sep(c-i,' AND ');%>\\n
        <% end loop; %>
      FOR UPDATE;

      <% if '${raise_exceptions}' is not null then %>
      logger.LOG('END', l_scope);
      <% end if; %>

      RETURN l_${table_name}_rec;

   <% if '${raise_exceptions}' is not null then %>
   EXCEPTION
     WHEN OTHERS
     THEN
        logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
        RAISE;
   <% end if; %>
   END rt_for_update;

    FUNCTION tt (
             <% c := pk.last+1; for i in 1 .. pk.last loop %>
                p_<%=pk(i).column_name%> IN ${table_name}.<%=pk(i).column_name %>%TYPE DEFAULT NULL<%sep(c-i,',');%>\\n
             <% end loop; %>
                )
       RETURN ${table_name}_tt
       PIPELINED
    IS
       <% if '${raise_exceptions}' is not null then %>
       l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'tt';
       l_params logger.tab_param;
       <% end if; %>
       l_${table_name}_rec   ${table_name}_rt;
    BEGIN
      <% if '${raise_exceptions}' is not null then
       c := pk.last+1; for i in 1 .. pk.last loop %>
      logger.append_param(l_params, 'p_<%=pk(i).column_name%>', tt.p_<%=pk(i).column_name%>);
      <% end loop; %>
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Populating record type from DB', l_scope);
      <% end if; %>

       FOR c1 IN (SELECT   a.*, ROWID
                    FROM   ${table_name} a
                   WHERE
                      <% c := pk.last+1; for i in 1 .. pk.last loop %>
                        <%=pk(i).column_name%> = NVL(tt.p_<%=pk(i).column_name%>,<%=pk(i).column_name%>)<%sep(c-i,' AND ');%>\\n
                      <% end loop; %>
                        )
       LOOP
            <% for i in 1 .. col.last loop %>
              l_${table_name}_rec.<%=col(i).column_name%> := c1.<%=col(i).column_name%>;
            <% end loop; %>
              l_${table_name}_rec.hash := tapi_${table_name}.hash(<% c := pk.last+1; for i in 1 .. pk.last loop %> c1.<%=pk(i).column_name%><%sep(c-i,',');%><% end loop; %>);
              l_${table_name}_rec.row_id := c1.ROWID;
              PIPE ROW (l_${table_name}_rec);
       END LOOP;
       <% if '${raise_exceptions}' is not null then %>

       logger.LOG('END', l_scope);
       <% end if; %>

       RETURN;

    <% if '${raise_exceptions}' is not null then %>
    EXCEPTION
     WHEN OTHERS
     THEN
        logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
        RAISE;
    <% end if; %>
    END tt;


    PROCEDURE ins (p_${table_name}_rec IN OUT ${table_name}_rt)
    IS
        <% if '${raise_exceptions}' is not null then %>
        l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'ins';
        l_params logger.tab_param;
       <% end if; %>
        l_rowtype     ${table_name}%ROWTYPE;
       <% if '${created_by_col_name}' is not null
        or   '${modified_by_col_name}' is not null
       then
            if '${created_by_col_name}' is not null
            then%>
        l_user_name   ${table_name}.${created_by_col_name}%TYPE := USER;/*dbax_core.g$username or apex_application.g_user*/
            <%else%>
        l_user_name   ${table_name}.${modified_by_col_name}%TYPE := USER;/*dbax_core.g$username or apex_application.g_user*/
            <% end if;
       end if;
       if '${created_date_col_name}' is not null
       or '${modified_date_col_name}' is not null
       then
            if '${created_date_col_name}' is not null
            then %>
        l_date        ${table_name}.${created_date_col_name}%TYPE := SYSDATE;
            <%else%>
        l_date        ${table_name}.${modified_date_col_name}%TYPE := SYSDATE;
            <% end if;
       end if; %>

    BEGIN
        <% if '${raise_exceptions}' is not null then
          for i in 1 .. col.last loop %>
        logger.append_param(l_params, 'p_${table_name}_rec.<%=col(i).column_name%>', ins.p_${table_name}_rec.<%=col(i).column_name%>);
        <% end loop; %>
        logger.LOG('START', l_scope, NULL, l_params);
        logger.LOG('Inserting data', l_scope);
        <% end if;%>

        <% if '${created_by_col_name}'Is not null then%>
        p_${table_name}_rec.${created_by_col_name} := l_user_name;
        <% end if; %>!\n
        <% if '${created_date_col_name}' is not null then %>
        p_${table_name}_rec.${created_date_col_name} := l_date;
        <% end if; %>!\n
        <% if '${modified_by_col_name}' is not null then %>
        p_${table_name}_rec.${modified_by_col_name} := l_user_name;
        <% end if;%>!\n
        <% if '${modified_date_col_name}' is not null then %>
        p_${table_name}_rec.${modified_date_col_name} := l_date;
        <% end if; %>

        <% for i in 1 .. col.last loop %>
        l_rowtype.<%=col(i).column_name%> := ins.p_${table_name}_rec.<%=col(i).column_name%>;
        <% end loop; %>

       INSERT INTO ${table_name}
          VALUES   l_rowtype
       RETURNING
                   <%  c := col.last+1; for i in 1 .. col.last loop %>
                   <%=col(i).column_name%> <%sep(c-i,',');%>\\n
                   <% end loop; %>
            INTO   l_rowtype;

        <% for i in 1 .. col.last loop %>
         ins.p_${table_name}_rec.<%=col(i).column_name%> := l_rowtype.<%=col(i).column_name%>;
        <% end loop; %>


      <% if '${raise_exceptions}' is not null then %>
       logger.LOG('END', l_scope);
      <%end if; %>

    <% if '${raise_exceptions}' is not null then %>
    EXCEPTION
      WHEN OTHERS
      THEN
         logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
         RAISE;
    <% end if; %>
    END ins;

    PROCEDURE upd (
                  p_${table_name}_rec         IN ${table_name}_rt,
                  p_ignore_nulls         IN boolean := FALSE
                  )
    IS
    <% if '${raise_exceptions}' is not null then %>
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'upd';
      l_params logger.tab_param;
    <% end if; %>
    BEGIN
      <% if '${raise_exceptions}' is not null then
        for i in 1 .. col.last loop %>
       logger.append_param(l_params, 'p_${table_name}_rec.<%=col(i).column_name%>', upd.p_${table_name}_rec.<%=col(i).column_name%>);
      <% end loop; %>
       logger.LOG('START', l_scope, NULL, l_params);
       logger.LOG('Updating table', l_scope);
      <% end if; %>

       IF NVL (p_ignore_nulls, FALSE)
       THEN
          UPDATE   ${table_name}
             SET <% c := col.last+1; for i in 1 .. col.last loop
                    column_for_update(col(i).column_name,true,c-i);
                  end loop; %>\\n
           WHERE
                <% c := pk.last+1; for i in 1 .. pk.last loop %>
                <%=pk(i).column_name%> = upd.p_${table_name}_rec.<%=pk(i).column_name%><%sep(c-i,' AND ');%>\\n
                <% end loop; %>
                ;
       ELSE
          UPDATE   ${table_name}
             SET <% c := col.last+1; for i in 1 .. col.last loop
                    column_for_update(col(i).column_name,false,c-i);
                 end loop; %>\\n
           WHERE
                <% c := pk.last+1; for i in 1 .. pk.last loop %>
                <%=pk(i).column_name%> = upd.p_${table_name}_rec.<%=pk(i).column_name%><%sep(c-i,' AND ');%>\\n
                <% end loop; %>
                ;
       END IF;

       IF SQL%ROWCOUNT != 1 THEN RAISE e_upd_failed; END IF;
      <% if '${raise_exceptions}' is not null then %>
       logger.LOG('END', l_scope);
      <%end if; %>

    EXCEPTION
       WHEN e_upd_failed
       THEN
          raise_application_error (-20000, 'No rows were updated. The update failed.');
      <% if '${raise_exceptions}' is not null then %>
       WHEN OTHERS
       THEN
        logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
        RAISE;
      <% end if; %>
    END upd;


    PROCEDURE upd_rowid (
                         p_${table_name}_rec         IN ${table_name}_rt,
                         p_ignore_nulls         IN boolean := FALSE
                        )
    IS
    <% if '${raise_exceptions}' is not null then %>
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'upd_rowid';
      l_params logger.tab_param;
    <% end if; %>
    BEGIN
      <% if '${raise_exceptions}' is not null then
        for i in 1 .. col.last loop %>
       logger.append_param(l_params, 'p_${table_name}_rec.<%=col(i).column_name%>', upd_rowid.p_${table_name}_rec.<%=col(i).column_name%>);
      <% end loop; %>
       logger.LOG('START', l_scope, NULL, l_params);
       logger.LOG('Updating table', l_scope);
      <% end if; %>

       IF NVL (p_ignore_nulls, FALSE)
       THEN
          UPDATE   ${table_name}
             SET <% c := col.last+1; for i in 1 .. col.last loop
                     column_for_update(col(i).column_name,true,c-i);
                  end loop; %>\\n
           WHERE  ROWID = p_${table_name}_rec.row_id;
       ELSE
          UPDATE   ${table_name}
             SET <% c := col.last+1; for i in 1 .. col.last loop
                     column_for_update(col(i).column_name,false,c-i);
                  end loop; %>\\n
           WHERE  ROWID = p_${table_name}_rec.row_id;
       END IF;

       IF SQL%ROWCOUNT != 1 THEN RAISE e_upd_failed; END IF;
      <% if '${raise_exceptions}' is not null then %>
       logger.LOG('END', l_scope);
      <%end if; %>

    EXCEPTION
       WHEN e_upd_failed
       THEN
          raise_application_error (-20000, 'No rows were updated. The update failed.');
       <% if '${raise_exceptions}' is not null then %>
       WHEN OTHERS
       THEN
          logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
          RAISE;
       <% end if; %>
    END upd_rowid;

   PROCEDURE web_upd (
                  p_${table_name}_rec         IN ${table_name}_rt,
                  p_ignore_nulls         IN boolean := FALSE
                )
   IS
    <% if '${raise_exceptions}' is not null then %>
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'web_upd';
      l_params logger.tab_param;
    <% end if; %>
      l_${table_name}_rec ${table_name}_rt;
   BEGIN
      <% if '${raise_exceptions}' is not null then
        for i in 1 .. col.last loop %>
       logger.append_param(l_params, 'p_${table_name}_rec.<%=col(i).column_name%>', web_upd.p_${table_name}_rec.<%=col(i).column_name%>);
      <% end loop; %>
       logger.LOG('START', l_scope, NULL, l_params);
       logger.LOG('Updating table', l_scope);
      <% end if; %>

      OPEN ${table_name}_cur(
                        <% c := pk.last+1; for i in 1 .. pk.last loop %>
                             web_upd.p_${table_name}_rec.<%=pk(i).column_name%><%sep(c-i,',');%>\\n
                        <% end loop; %>
                        );

      FETCH ${table_name}_cur INTO l_${table_name}_rec;

      IF ${table_name}_cur%NOTFOUND THEN
         CLOSE ${table_name}_cur;
         RAISE e_row_missing;
      ELSE
         IF p_${table_name}_rec.hash != l_${table_name}_rec.hash THEN
            CLOSE ${table_name}_cur;
            RAISE e_ol_check_failed;
         ELSE
            IF NVL(p_ignore_nulls, FALSE)
            THEN

                UPDATE   ${table_name}
                   SET <% c := col.last+1; for i in 1 .. col.last loop
                            column_for_update(col(i).column_name,true,c-i, 23);
                       end loop; %>\\n
               WHERE CURRENT OF ${table_name}_cur;
            ELSE
                UPDATE   ${table_name}
                   SET <% c := col.last+1; for i in 1 .. col.last loop
                            column_for_update(col(i).column_name,false,c-i,23);
                       end loop; %>\\n
               WHERE CURRENT OF ${table_name}_cur;
            END IF;

            CLOSE ${table_name}_cur;
         END IF;
      END IF;

      <% if '${raise_exceptions}' is not null then %>
      logger.LOG('END', l_scope);
      <%end if; %>

   EXCEPTION
     WHEN e_ol_check_failed
     THEN
        raise_application_error (-20000 , 'Current version of data in database has changed since last page refresh.');
     WHEN e_row_missing
     THEN
        raise_application_error (-20000 , 'Update operation failed because the row is no longer in the database.');
     <% if '${raise_exceptions}' is not null then %>
     WHEN OTHERS
     THEN
        logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
        RAISE;
     <% end if; %>
   END web_upd;

   PROCEDURE web_upd_rowid (
                            p_${table_name}_rec    IN ${table_name}_rt,
                            p_ignore_nulls         IN boolean := FALSE
                           )
   IS
    <% if '${raise_exceptions}' is not null then %>
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'web_upd_rowid';
      l_params logger.tab_param;
    <% end if; %>
      l_${table_name}_rec ${table_name}_rt;
   BEGIN
      <% if '${raise_exceptions}' is not null then
        for i in 1 .. col.last loop %>
       logger.append_param(l_params, 'p_${table_name}_rec.<%=col(i).column_name%>', web_upd_rowid.p_${table_name}_rec.<%=col(i).column_name%>);
      <% end loop; %>
       logger.LOG('START', l_scope, NULL, l_params);
       logger.LOG('Updating table', l_scope);
      <% end if; %>

      OPEN ${table_name}_rowid_cur(web_upd_rowid.p_${table_name}_rec.row_id);

      FETCH ${table_name}_rowid_cur INTO l_${table_name}_rec;

      IF ${table_name}_rowid_cur%NOTFOUND THEN
         CLOSE ${table_name}_rowid_cur;
         RAISE e_row_missing;
      ELSE
         IF web_upd_rowid.p_${table_name}_rec.hash != l_${table_name}_rec.hash THEN
            CLOSE ${table_name}_rowid_cur;
            RAISE e_ol_check_failed;
         ELSE
            IF NVL(web_upd_rowid.p_ignore_nulls, FALSE)
            THEN
                UPDATE   ${table_name}
                   SET <% c := col.last+1; for i in 1 .. col.last loop
                         column_for_update(col(i).column_name,true,c-i,23);
                       end loop; %>\\n
               WHERE CURRENT OF ${table_name}_rowid_cur;
            ELSE
                UPDATE   ${table_name}
                   SET <% c := col.last+1; for i in 1 .. col.last loop
                         column_for_update(col(i).column_name,false,c-i,23);
                       end loop; %>\\n
               WHERE CURRENT OF ${table_name}_rowid_cur;
            END IF;

            CLOSE ${table_name}_rowid_cur;
         END IF;
      END IF;

      <% if '${raise_exceptions}' is not null then %>
      logger.LOG('END', l_scope);
      <%end if; %>

   EXCEPTION
     WHEN e_ol_check_failed
     THEN
        raise_application_error (-20000 , 'Current version of data in database has changed since last page refresh.');
     WHEN e_row_missing
     THEN
        raise_application_error (-20000 , 'Update operation failed because the row is no longer in the database.');
     <% if '${raise_exceptions}' is not null then %>
     WHEN OTHERS
     THEN
        logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
        RAISE;
     <% end if; %>
   END web_upd_rowid;

    PROCEDURE del (
               <% c := pk.last+1; for i in 1 .. pk.last loop %>
                  p_<%=pk(i).column_name%> IN ${table_name}.<%=pk(i).column_name %>%TYPE<%sep(c-i,',');%>\\n
               <% end loop; %>
                  )
    IS
    <% if '${raise_exceptions}' is not null then %>
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'del';
      l_params logger.tab_param;
    <% end if; %>
    BEGIN
      <% if '${raise_exceptions}' is not null then
       c := pk.last+1; for i in 1 .. pk.last loop %>
      logger.append_param(l_params, 'p_<%=pk(i).column_name%>', del.p_<%=pk(i).column_name%>);
      <% end loop; %>
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Deleting record', l_scope);
      <% end if; %>

       DELETE FROM   ${table_name}
             WHERE
                <% c := pk.last+1; for i in 1 .. pk.last loop %>
                  <%=pk(i).column_name%> = del.p_<%=pk(i).column_name%><%sep(c-i,' AND ');%>\\n
                <% end loop; %>
                   ;

       IF sql%ROWCOUNT != 1
       THEN
          RAISE e_del_failed;
       END IF;

      <% if '${raise_exceptions}' is not null then %>
       logger.LOG('END', l_scope);
      <%end if; %>

    EXCEPTION
       WHEN e_del_failed
       THEN
          raise_application_error (-20000, 'No rows were deleted. The delete failed.');
       <% if '${raise_exceptions}' is not null then %>
       WHEN OTHERS
       THEN
          logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
          RAISE;
       <% end if; %>
    END del;

    PROCEDURE del_rowid (p_rowid IN varchar2)
    IS
    <% if '${raise_exceptions}' is not null then %>
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'del_rowid';
      l_params logger.tab_param;
    <% end if; %>
    BEGIN
       <% if '${raise_exceptions}' is not null then %>
       logger.append_param(l_params, 'p_rowid', del_rowid.p_rowid);
       logger.LOG('START', l_scope, NULL, l_params);
       logger.LOG('Deleting record', l_scope);
       <% end if; %>

       DELETE FROM   ${table_name}
             WHERE   ROWID = del_rowid.p_rowid;

       IF sql%ROWCOUNT != 1
       THEN
          RAISE e_del_failed;
       END IF;

      <% if '${raise_exceptions}' is not null then %>
       logger.LOG('END', l_scope);
      <%end if; %>

    EXCEPTION
       WHEN e_del_failed
       THEN
          raise_application_error (-20000, 'No rows were deleted. The delete failed.');
       <% if '${raise_exceptions}' is not null then %>
       WHEN OTHERS
       THEN
          logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
          RAISE;
       <% end if; %>
    END del_rowid;

    PROCEDURE web_del (
                   <% c := pk.last+1; for i in 1 .. pk.last loop %>
                      p_<%=pk(i).column_name%> IN ${table_name}.<%=pk(i).column_name %>%TYPE,
                   <% end loop; %>
                      p_hash IN varchar2
                      )
   IS
    <% if '${raise_exceptions}' is not null then %>
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'web_del';
      l_params logger.tab_param;
    <% end if; %>
      l_${table_name}_rec ${table_name}_rt;
   BEGIN

      <% if '${raise_exceptions}' is not null then
       c := pk.last+1; for i in 1 .. pk.last loop %>
      logger.append_param(l_params, 'p_<%=pk(i).column_name%>', web_del.p_<%=pk(i).column_name%>);
      <% end loop; %>
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Deleting record', l_scope);
      <% end if; %>

      OPEN ${table_name}_cur(
                          <% c := pk.last+1; for i in 1 .. pk.last loop %>
                            web_del.p_<%=pk(i).column_name%><%sep(c-i,',');%>\\n
                          <% end loop; %>
                            );

      FETCH ${table_name}_cur INTO l_${table_name}_rec;

      IF ${table_name}_cur%NOTFOUND THEN
         CLOSE ${table_name}_cur;
         RAISE e_row_missing;
      ELSE
         IF web_del.p_hash != l_${table_name}_rec.hash THEN
            CLOSE ${table_name}_cur;
            RAISE e_ol_check_failed;
         ELSE
            DELETE FROM ${table_name}
            WHERE CURRENT OF ${table_name}_cur;

            CLOSE ${table_name}_cur;
         END IF;
      END IF;


      <% if '${raise_exceptions}' is not null then %>
      logger.LOG('END', l_scope);
      <%end if; %>

   EXCEPTION
     WHEN e_ol_check_failed
     THEN
        raise_application_error (-20000 , 'Current version of data in database has changed since last page refresh.');
     WHEN e_row_missing
     THEN
        raise_application_error (-20000 , 'Delete operation failed because the row is no longer in the database.');
     <% if '${raise_exceptions}' is not null then %>
     WHEN OTHERS
     THEN
        logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
        RAISE;
     <% end if; %>
   END web_del;

   PROCEDURE web_del_rowid (p_rowid IN varchar2, p_hash IN varchar2)
   IS
    <% if '${raise_exceptions}' is not null then %>
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'web_del_rowid';
      l_params logger.tab_param;
    <% end if; %>
      l_${table_name}_rec ${table_name}_rt;
   BEGIN

      <% if '${raise_exceptions}' is not null then %>
      logger.append_param(l_params, 'p_rowid', web_del_rowid.p_rowid);
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Deleting record', l_scope);
      <% end if; %>

      OPEN ${table_name}_rowid_cur(web_del_rowid.p_rowid);

      FETCH ${table_name}_rowid_cur INTO l_${table_name}_rec;

      IF ${table_name}_rowid_cur%NOTFOUND THEN
         CLOSE ${table_name}_rowid_cur;
         RAISE e_row_missing;
      ELSE
         IF web_del_rowid.p_hash != l_${table_name}_rec.hash THEN
            CLOSE ${table_name}_rowid_cur;
            RAISE e_ol_check_failed;
         ELSE
            DELETE FROM ${table_name}
            WHERE CURRENT OF ${table_name}_rowid_cur;

            CLOSE ${table_name}_rowid_cur;
         END IF;
      END IF;

     <% if '${raise_exceptions}' is not null then %>
      logger.LOG('END', l_scope);
     <%end if; %>
   EXCEPTION
     WHEN e_ol_check_failed
     THEN
        raise_application_error (-20000 , 'Current version of data in database has changed since last page refresh.');
     WHEN e_row_missing
     THEN
        raise_application_error (-20000 , 'Delete operation failed because the row is no longer in the database.');
     <% if '${raise_exceptions}' is not null then %>
     WHEN OTHERS
     THEN
        logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
        RAISE;
     <% end if; %>
   END web_del_rowid;

END tapi_${table_name};

$end

END tapi_gen2;

/
--------------------------------------------------------
--  DDL for Package TAPI_HOJA_VIDA_EST
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."TAPI_HOJA_VIDA_EST" 
IS
   /**
   * TAPI_HOJA_VIDA_EST
   * Generated by: tapiGen2 - DO NOT MODIFY!
   * Website: github.com/osalvador/tapiGen2
   * Created On: 16-SEP-2019 13:22
   * Created By: FUNDAUC
   */

   --Scalar/Column types
   SUBTYPE hash_t IS varchar2 (40);
   SUBTYPE id IS hoja_vida_est.id%TYPE;
   SUBTYPE matricula IS hoja_vida_est.matricula%TYPE;
   SUBTYPE evento_id IS hoja_vida_est.evento_id%TYPE;
   SUBTYPE fecha IS hoja_vida_est.fecha%TYPE;
   SUBTYPE metadata IS hoja_vida_est.metadata%TYPE;
   SUBTYPE observacion IS hoja_vida_est.observacion%TYPE;

   --Record type
   TYPE hoja_vida_est_rt
   IS
      RECORD (
            id hoja_vida_est.id%TYPE,
            matricula hoja_vida_est.matricula%TYPE,
            evento_id hoja_vida_est.evento_id%TYPE,
            fecha hoja_vida_est.fecha%TYPE,
            metadata hoja_vida_est.metadata%TYPE,
            observacion hoja_vida_est.observacion%TYPE,
            hash               hash_t,
            row_id            VARCHAR2(64)
      );
   --Collection types (record)
   TYPE hoja_vida_est_tt IS TABLE OF hoja_vida_est_rt;

   --Global exceptions
   e_ol_check_failed EXCEPTION; --Optimistic lock check failed
   e_row_missing     EXCEPTION; --The cursor failed to get a row
   e_upd_failed      EXCEPTION; --The update operation failed
   e_del_failed      EXCEPTION; --The delete operation failed

   /**
   * Generates a SHA1 hash for optimistic locking purposes.
   *
   * @param    p_id        must be NOT NULL
   */
   FUNCTION hash (
                  p_id IN hoja_vida_est.id%TYPE
                 )
    RETURN VARCHAR2;

   /**
   * This function generates a SHA1 hash for optimistic locking purposes.
   * Access directly to the row by rowid
   *
   * @param  p_rowid  must be NOT NULL
   */
   FUNCTION hash_rowid (p_rowid IN varchar2)
   RETURN varchar2;

   /**
   * This is a table encapsulation function designed to retrieve information from the hoja_vida_est table.
   *
   * @param      p_id      must be NOT NULL
   * @return     hoja_vida_est Record Type
   */
   FUNCTION rt (
                p_id IN hoja_vida_est.id%TYPE 
               )
    RETURN hoja_vida_est_rt ;

   /**
   * This is a table encapsulation function designed to retrieve information
   * from the hoja_vida_est table while placing a lock on it for a potential
   * update/delete. Do not use this for updates in web based apps, instead use the
   * rt_for_web_update function to get a FOR_WEB_UPDATE_RT record which
   * includes all of the tables columns along with an md5 checksum for use in the
   * web_upd and web_del procedures.
   *
   * @param      p_id      must be NOT NULL
   * @return     hoja_vida_est Record Type
   */
   FUNCTION rt_for_update (
                          p_id IN hoja_vida_est.id%TYPE 
                          )
    RETURN hoja_vida_est_rt ;

   /**
   * This is a table encapsulation function designed to retrieve information from the hoja_vida_est table.
   * This function return Record Table as PIPELINED Function
   *
   * @param      p_id      must be NOT NULL
   * @return     hoja_vida_est Table Record Type
   */
   FUNCTION tt (
                p_id IN hoja_vida_est.id%TYPE DEFAULT NULL
               )
   RETURN hoja_vida_est_tt
   PIPELINED;

   /**
   * This is a table encapsulation function designed to insert a row into the hoja_vida_est table.
   *
   * @param      p_hoja_vida_est_rec       Record Type
   * @return     p_hoja_vida_est_rec       Record Type
   */
   PROCEDURE ins (p_hoja_vida_est_rec IN OUT hoja_vida_est_rt);

   /**
   * This is a table encapsulation function designed to update a row in the hoja_vida_est table.
   *
   * @param      p_hoja_vida_est_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd (p_hoja_vida_est_rec IN hoja_vida_est_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row in the hoja_vida_est table,
   * access directly to the row by rowid
   *
   * @param      p_hoja_vida_est_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd_rowid (p_hoja_vida_est_rec IN hoja_vida_est_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the hoja_vida_est table whith optimistic lock validation
   *
   * @param      p_hoja_vida_est_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd (p_hoja_vida_est_rec IN hoja_vida_est_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the hoja_vida_est table whith optimistic lock validation
   * access directly to the row by rowid
   *
   * @param      p_hoja_vida_est_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd_rowid (p_hoja_vida_est_rec IN hoja_vida_est_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to delete a row from the hoja_vida_est table.
   *
   * @param    p_id        must be NOT NULL
   */
   PROCEDURE del (
                  p_id IN hoja_vida_est.id%TYPE
                );

   /**
   * This is a table encapsulation function designed to delete a row from the hoja_vida_est table
   * access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   */
    PROCEDURE del_rowid (p_rowid IN VARCHAR2);

   /**
   * This is a table encapsulation function designed to delete a row from the hoja_vida_est table
   * whith optimistic lock validation
   *
   * @param      p_id      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del (
                      p_id IN hoja_vida_est.id%TYPE,
                      p_hash IN varchar2
                      );

   /**
   * This is a table encapsulation function designed to delete a row from the hoja_vida_est table
   * whith optimistic lock validation, access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del_rowid (p_rowid IN varchar2, p_hash IN varchar2);

END tapi_hoja_vida_est;

/
--------------------------------------------------------
--  DDL for Package TAPI_INSCRIPCIONES
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."TAPI_INSCRIPCIONES" 
IS
   /**
   * TAPI_INSCRIPCIONES
   * Generated by: tapiGen2 - DO NOT MODIFY!
   * Website: github.com/osalvador/tapiGen2
   * Created On: 22-FEB-2020 03:12
   * Created By: FUNDAUC
   */

   --Scalar/Column types
   SUBTYPE hash_t IS varchar2 (40);
   SUBTYPE id IS inscripciones.id%TYPE;
   SUBTYPE fecha_ins IS inscripciones.fecha_ins%TYPE;
   SUBTYPE est_matricula IS inscripciones.est_matricula%TYPE;
   SUBTYPE fecha_pago IS inscripciones.fecha_pago%TYPE;
   SUBTYPE estatus IS inscripciones.estatus%TYPE;
   SUBTYPE seccion_id IS inscripciones.seccion_id%TYPE;
   SUBTYPE periodo_id IS inscripciones.periodo_id%TYPE;
   SUBTYPE creado_por IS inscripciones.creado_por%TYPE;
   SUBTYPE es_exonerado IS inscripciones.es_exonerado%TYPE;
   SUBTYPE prog_academico IS inscripciones.prog_academico%TYPE;
   SUBTYPE es_suspendido IS inscripciones.es_suspendido%TYPE;
   SUBTYPE cohorte_id IS inscripciones.cohorte_id%TYPE;
   SUBTYPE horario_id IS inscripciones.horario_id%TYPE;
   SUBTYPE modificado_por IS inscripciones.modificado_por%TYPE;
   SUBTYPE modificado_el IS inscripciones.modificado_el%TYPE;

   --Record type
   TYPE inscripciones_rt
   IS
      RECORD (
            id inscripciones.id%TYPE,
            fecha_ins inscripciones.fecha_ins%TYPE,
            est_matricula inscripciones.est_matricula%TYPE,
            fecha_pago inscripciones.fecha_pago%TYPE,
            estatus inscripciones.estatus%TYPE,
            seccion_id inscripciones.seccion_id%TYPE,
            periodo_id inscripciones.periodo_id%TYPE,
            creado_por inscripciones.creado_por%TYPE,
            es_exonerado inscripciones.es_exonerado%TYPE,
            prog_academico inscripciones.prog_academico%TYPE,
            es_suspendido inscripciones.es_suspendido%TYPE,
            cohorte_id inscripciones.cohorte_id%TYPE,
            horario_id inscripciones.horario_id%TYPE,
            modificado_por inscripciones.modificado_por%TYPE,
            modificado_el inscripciones.modificado_el%TYPE,
            hash               hash_t,
            row_id            VARCHAR2(64)
      );
   --Collection types (record)
   TYPE inscripciones_tt IS TABLE OF inscripciones_rt;

   --Global exceptions
   e_ol_check_failed EXCEPTION; --Optimistic lock check failed
   e_row_missing     EXCEPTION; --The cursor failed to get a row
   e_upd_failed      EXCEPTION; --The update operation failed
   e_del_failed      EXCEPTION; --The delete operation failed

   /**
   * Generates a SHA1 hash for optimistic locking purposes.
   *
   * @param    p_id        must be NOT NULL
   */
   FUNCTION hash (
                  p_id IN inscripciones.id%TYPE
                 )
    RETURN VARCHAR2;

   /**
   * This function generates a SHA1 hash for optimistic locking purposes.
   * Access directly to the row by rowid
   *
   * @param  p_rowid  must be NOT NULL
   */
   FUNCTION hash_rowid (p_rowid IN varchar2)
   RETURN varchar2;

   /**
   * This is a table encapsulation function designed to retrieve information from the inscripciones table.
   *
   * @param      p_id      must be NOT NULL
   * @return     inscripciones Record Type
   */
   FUNCTION rt (
                p_id IN inscripciones.id%TYPE 
               )
    RETURN inscripciones_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information
   * from the inscripciones table while placing a lock on it for a potential
   * update/delete. Do not use this for updates in web based apps, instead use the
   * rt_for_web_update function to get a FOR_WEB_UPDATE_RT record which
   * includes all of the tables columns along with an md5 checksum for use in the
   * web_upd and web_del procedures.
   *
   * @param      p_id      must be NOT NULL
   * @return     inscripciones Record Type
   */
   FUNCTION rt_for_update (
                          p_id IN inscripciones.id%TYPE 
                          )
    RETURN inscripciones_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information from the inscripciones table.
   * This function return Record Table as PIPELINED Function
   *
   * @param      p_id      must be NOT NULL
   * @return     inscripciones Table Record Type
   */
   FUNCTION tt (
                p_id IN inscripciones.id%TYPE DEFAULT NULL
               )
   RETURN inscripciones_tt
   PIPELINED;

   /**
   * This is a table encapsulation function designed to insert a row into the inscripciones table.
   *
   * @param      p_inscripciones_rec       Record Type
   * @return     p_inscripciones_rec       Record Type
   */
   PROCEDURE ins (p_inscripciones_rec IN OUT inscripciones_rt);

   /**
   * This is a table encapsulation function designed to update a row in the inscripciones table.
   *
   * @param      p_inscripciones_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd (p_inscripciones_rec IN inscripciones_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row in the inscripciones table,
   * access directly to the row by rowid
   *
   * @param      p_inscripciones_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd_rowid (p_inscripciones_rec IN inscripciones_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the inscripciones table whith optimistic lock validation
   *
   * @param      p_inscripciones_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd (p_inscripciones_rec IN inscripciones_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the inscripciones table whith optimistic lock validation
   * access directly to the row by rowid
   *
   * @param      p_inscripciones_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd_rowid (p_inscripciones_rec IN inscripciones_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to delete a row from the inscripciones table.
   *
   * @param    p_id        must be NOT NULL
   */
   PROCEDURE del (
                  p_id IN inscripciones.id%TYPE
                );

   /**
   * This is a table encapsulation function designed to delete a row from the inscripciones table
   * access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   */
    PROCEDURE del_rowid (p_rowid IN VARCHAR2);

   /**
   * This is a table encapsulation function designed to delete a row from the inscripciones table
   * whith optimistic lock validation
   *
   * @param      p_id      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del (
                      p_id IN inscripciones.id%TYPE,
                      p_hash IN varchar2
                      );

   /**
   * This is a table encapsulation function designed to delete a row from the inscripciones table
   * whith optimistic lock validation, access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del_rowid (p_rowid IN varchar2, p_hash IN varchar2);

END tapi_inscripciones;
 

/
--------------------------------------------------------
--  DDL for Package TAPI_INSTANCIAS_SECCIONES
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."TAPI_INSTANCIAS_SECCIONES" 
IS
   /**
   * TAPI_INSTANCIAS_SECCIONES
   * Generated by: tapiGen2 - DO NOT MODIFY!
   * Website: github.com/osalvador/tapiGen2
   * Created On: 25-FEB-2020 23:11
   * Created By: FUNDAUC
   */

   --Scalar/Column types
   SUBTYPE hash_t IS varchar2 (40);
   SUBTYPE id IS instancias_secciones.id%TYPE;
   SUBTYPE seccion_id IS instancias_secciones.seccion_id%TYPE;
   SUBTYPE codigo_sec IS instancias_secciones.codigo_sec%TYPE;
   SUBTYPE metodo_id IS instancias_secciones.metodo_id%TYPE;
   SUBTYPE nivel IS instancias_secciones.nivel%TYPE;
   SUBTYPE periodo_id IS instancias_secciones.periodo_id%TYPE;
   SUBTYPE horario_id IS instancias_secciones.horario_id%TYPE;
   SUBTYPE modalidad_id IS instancias_secciones.modalidad_id%TYPE;
   SUBTYPE cedula_prof IS instancias_secciones.cedula_prof%TYPE;
   SUBTYPE f_inicio IS instancias_secciones.f_inicio%TYPE;
   SUBTYPE f_fin IS instancias_secciones.f_fin%TYPE;
   SUBTYPE estatus IS instancias_secciones.estatus%TYPE;

   --Record type
   TYPE instancias_secciones_rt
   IS
      RECORD (
            id instancias_secciones.id%TYPE,
            seccion_id instancias_secciones.seccion_id%TYPE,
            codigo_sec instancias_secciones.codigo_sec%TYPE,
            metodo_id instancias_secciones.metodo_id%TYPE,
            nivel instancias_secciones.nivel%TYPE,
            periodo_id instancias_secciones.periodo_id%TYPE,
            horario_id instancias_secciones.horario_id%TYPE,
            modalidad_id instancias_secciones.modalidad_id%TYPE,
            cedula_prof instancias_secciones.cedula_prof%TYPE,
            f_inicio instancias_secciones.f_inicio%TYPE,
            f_fin instancias_secciones.f_fin%TYPE,
            estatus instancias_secciones.estatus%TYPE,
            hash               hash_t,
            row_id            VARCHAR2(64)
      );
   --Collection types (record)
   TYPE instancias_secciones_tt IS TABLE OF instancias_secciones_rt;

   --Global exceptions
   e_ol_check_failed EXCEPTION; --Optimistic lock check failed
   e_row_missing     EXCEPTION; --The cursor failed to get a row
   e_upd_failed      EXCEPTION; --The update operation failed
   e_del_failed      EXCEPTION; --The delete operation failed

   /**
   * Generates a SHA1 hash for optimistic locking purposes.
   *
   * @param    p_id        must be NOT NULL
   */
   FUNCTION hash (
                  p_id IN instancias_secciones.id%TYPE
                 )
    RETURN VARCHAR2;

   /**
   * This function generates a SHA1 hash for optimistic locking purposes.
   * Access directly to the row by rowid
   *
   * @param  p_rowid  must be NOT NULL
   */
   FUNCTION hash_rowid (p_rowid IN varchar2)
   RETURN varchar2;

   /**
   * This is a table encapsulation function designed to retrieve information from the instancias_secciones table.
   *
   * @param      p_id      must be NOT NULL
   * @return     instancias_secciones Record Type
   */
   FUNCTION rt (
                p_id IN instancias_secciones.id%TYPE 
               )
    RETURN instancias_secciones_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information
   * from the instancias_secciones table while placing a lock on it for a potential
   * update/delete. Do not use this for updates in web based apps, instead use the
   * rt_for_web_update function to get a FOR_WEB_UPDATE_RT record which
   * includes all of the tables columns along with an md5 checksum for use in the
   * web_upd and web_del procedures.
   *
   * @param      p_id      must be NOT NULL
   * @return     instancias_secciones Record Type
   */
   FUNCTION rt_for_update (
                          p_id IN instancias_secciones.id%TYPE 
                          )
    RETURN instancias_secciones_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information from the instancias_secciones table.
   * This function return Record Table as PIPELINED Function
   *
   * @param      p_id      must be NOT NULL
   * @return     instancias_secciones Table Record Type
   */
   FUNCTION tt (
                p_id IN instancias_secciones.id%TYPE DEFAULT NULL
               )
   RETURN instancias_secciones_tt
   PIPELINED;

   /**
   * This is a table encapsulation function designed to insert a row into the instancias_secciones table.
   *
   * @param      p_instancias_secciones_rec       Record Type
   * @return     p_instancias_secciones_rec       Record Type
   */
   PROCEDURE ins (p_instancias_secciones_rec IN OUT instancias_secciones_rt);

   /**
   * This is a table encapsulation function designed to update a row in the instancias_secciones table.
   *
   * @param      p_instancias_secciones_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd (p_instancias_secciones_rec IN instancias_secciones_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row in the instancias_secciones table,
   * access directly to the row by rowid
   *
   * @param      p_instancias_secciones_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd_rowid (p_instancias_secciones_rec IN instancias_secciones_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the instancias_secciones table whith optimistic lock validation
   *
   * @param      p_instancias_secciones_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd (p_instancias_secciones_rec IN instancias_secciones_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the instancias_secciones table whith optimistic lock validation
   * access directly to the row by rowid
   *
   * @param      p_instancias_secciones_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd_rowid (p_instancias_secciones_rec IN instancias_secciones_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to delete a row from the instancias_secciones table.
   *
   * @param    p_id        must be NOT NULL
   */
   PROCEDURE del (
                  p_id IN instancias_secciones.id%TYPE
                );

   /**
   * This is a table encapsulation function designed to delete a row from the instancias_secciones table
   * access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   */
    PROCEDURE del_rowid (p_rowid IN VARCHAR2);

   /**
   * This is a table encapsulation function designed to delete a row from the instancias_secciones table
   * whith optimistic lock validation
   *
   * @param      p_id      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del (
                      p_id IN instancias_secciones.id%TYPE,
                      p_hash IN varchar2
                      );

   /**
   * This is a table encapsulation function designed to delete a row from the instancias_secciones table
   * whith optimistic lock validation, access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del_rowid (p_rowid IN varchar2, p_hash IN varchar2);

END tapi_instancias_secciones;
 

/
--------------------------------------------------------
--  DDL for Package TAPI_MATERIALES
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."TAPI_MATERIALES" 
IS
   /**
   * TAPI_MATERIALES
   * Generated by: tapiGen2 - DO NOT MODIFY!
   * Website: github.com/osalvador/tapiGen2
   * Created On: 01-OCT-2019 12:25
   * Created By: FUNDAUC
   */

   --Scalar/Column types
   SUBTYPE hash_t IS varchar2 (40);
   SUBTYPE id_mat IS materiales.id_mat%TYPE;
   SUBTYPE tipo IS materiales.tipo%TYPE;
   SUBTYPE descripcion IS materiales.descripcion%TYPE;
   SUBTYPE id_curso IS materiales.id_curso%TYPE;
   SUBTYPE evento IS materiales.evento%TYPE;
   SUBTYPE nivel IS materiales.nivel%TYPE;
   SUBTYPE iva_exento IS materiales.iva_exento%TYPE;
   SUBTYPE activo IS materiales.activo%TYPE;
   SUBTYPE id IS materiales.id%TYPE;
   SUBTYPE seccion_id IS materiales.seccion_id%TYPE;
   SUBTYPE creado_por IS materiales.creado_por%TYPE;
   SUBTYPE creado_el IS materiales.creado_el%TYPE;
   SUBTYPE modificado_por IS materiales.modificado_por%TYPE;
   SUBTYPE modificado_el IS materiales.modificado_el%TYPE;
   SUBTYPE cohorte_id IS materiales.cohorte_id%TYPE;

   --Record type
   TYPE materiales_rt
   IS
      RECORD (
            id_mat materiales.id_mat%TYPE,
            tipo materiales.tipo%TYPE,
            descripcion materiales.descripcion%TYPE,
            id_curso materiales.id_curso%TYPE,
            evento materiales.evento%TYPE,
            nivel materiales.nivel%TYPE,
            iva_exento materiales.iva_exento%TYPE,
            activo materiales.activo%TYPE,
            id materiales.id%TYPE,
            seccion_id materiales.seccion_id%TYPE,
            creado_por materiales.creado_por%TYPE,
            creado_el materiales.creado_el%TYPE,
            modificado_por materiales.modificado_por%TYPE,
            modificado_el materiales.modificado_el%TYPE,
            cohorte_id materiales.cohorte_id%TYPE,
            hash               hash_t,
            row_id            VARCHAR2(64)
      );
   --Collection types (record)
   TYPE materiales_tt IS TABLE OF materiales_rt;

   --Global exceptions
   e_ol_check_failed EXCEPTION; --Optimistic lock check failed
   e_row_missing     EXCEPTION; --The cursor failed to get a row
   e_upd_failed      EXCEPTION; --The update operation failed
   e_del_failed      EXCEPTION; --The delete operation failed

   /**
   * Generates a SHA1 hash for optimistic locking purposes.
   *
   * @param    p_id        must be NOT NULL
   */
   FUNCTION hash (
                  p_id IN materiales.id%TYPE
                 )
    RETURN VARCHAR2;

   /**
   * This function generates a SHA1 hash for optimistic locking purposes.
   * Access directly to the row by rowid
   *
   * @param  p_rowid  must be NOT NULL
   */
   FUNCTION hash_rowid (p_rowid IN varchar2)
   RETURN varchar2;

   /**
   * This is a table encapsulation function designed to retrieve information from the materiales table.
   *
   * @param      p_id      must be NOT NULL
   * @return     materiales Record Type
   */
   FUNCTION rt (
                p_id IN materiales.id%TYPE 
               )
    RETURN materiales_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information
   * from the materiales table while placing a lock on it for a potential
   * update/delete. Do not use this for updates in web based apps, instead use the
   * rt_for_web_update function to get a FOR_WEB_UPDATE_RT record which
   * includes all of the tables columns along with an md5 checksum for use in the
   * web_upd and web_del procedures.
   *
   * @param      p_id      must be NOT NULL
   * @return     materiales Record Type
   */
   FUNCTION rt_for_update (
                          p_id IN materiales.id%TYPE 
                          )
    RETURN materiales_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information from the materiales table.
   * This function return Record Table as PIPELINED Function
   *
   * @param      p_id      must be NOT NULL
   * @return     materiales Table Record Type
   */
   FUNCTION tt (
                p_id IN materiales.id%TYPE DEFAULT NULL
               )
   RETURN materiales_tt
   PIPELINED;

   /**
   * This is a table encapsulation function designed to insert a row into the materiales table.
   *
   * @param      p_materiales_rec       Record Type
   * @return     p_materiales_rec       Record Type
   */
   PROCEDURE ins (p_materiales_rec IN OUT materiales_rt);

   /**
   * This is a table encapsulation function designed to update a row in the materiales table.
   *
   * @param      p_materiales_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd (p_materiales_rec IN materiales_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row in the materiales table,
   * access directly to the row by rowid
   *
   * @param      p_materiales_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd_rowid (p_materiales_rec IN materiales_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the materiales table whith optimistic lock validation
   *
   * @param      p_materiales_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd (p_materiales_rec IN materiales_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the materiales table whith optimistic lock validation
   * access directly to the row by rowid
   *
   * @param      p_materiales_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd_rowid (p_materiales_rec IN materiales_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to delete a row from the materiales table.
   *
   * @param    p_id        must be NOT NULL
   */
   PROCEDURE del (
                  p_id IN materiales.id%TYPE
                );

   /**
   * This is a table encapsulation function designed to delete a row from the materiales table
   * access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   */
    PROCEDURE del_rowid (p_rowid IN VARCHAR2);

   /**
   * This is a table encapsulation function designed to delete a row from the materiales table
   * whith optimistic lock validation
   *
   * @param      p_id      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del (
                      p_id IN materiales.id%TYPE,
                      p_hash IN varchar2
                      );

   /**
   * This is a table encapsulation function designed to delete a row from the materiales table
   * whith optimistic lock validation, access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del_rowid (p_rowid IN varchar2, p_hash IN varchar2);

END tapi_materiales;

/
--------------------------------------------------------
--  DDL for Package TAPI_PRECIOS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."TAPI_PRECIOS" 
IS
   /**
   * TAPI_PRECIOS
   * Generated by: tapiGen2 - DO NOT MODIFY!
   * Website: github.com/osalvador/tapiGen2
   * Created On: 25-FEB-2020 17:08
   * Created By: FUNDAUC
   */

   --Scalar/Column types
   SUBTYPE hash_t IS varchar2 (40);
   SUBTYPE tipo_item IS precios.tipo_item%TYPE;
   SUBTYPE fecha IS precios.fecha%TYPE;
   SUBTYPE precio1 IS precios.precio1%TYPE;
   SUBTYPE precio2 IS precios.precio2%TYPE;
   SUBTYPE precio3 IS precios.precio3%TYPE;
   SUBTYPE status IS precios.status%TYPE;
   SUBTYPE precio4 IS precios.precio4%TYPE;
   SUBTYPE precio5 IS precios.precio5%TYPE;
   SUBTYPE id IS precios.id%TYPE;

   --Record type
   TYPE precios_rt
   IS
      RECORD (
            tipo_item precios.tipo_item%TYPE,
            fecha precios.fecha%TYPE,
            precio1 precios.precio1%TYPE,
            precio2 precios.precio2%TYPE,
            precio3 precios.precio3%TYPE,
            status precios.status%TYPE,
            precio4 precios.precio4%TYPE,
            precio5 precios.precio5%TYPE,
            id precios.id%TYPE,
            hash               hash_t,
            row_id            VARCHAR2(64)
      );
   --Collection types (record)
   TYPE precios_tt IS TABLE OF precios_rt;

   --Global exceptions
   e_ol_check_failed EXCEPTION; --Optimistic lock check failed
   e_row_missing     EXCEPTION; --The cursor failed to get a row
   e_upd_failed      EXCEPTION; --The update operation failed
   e_del_failed      EXCEPTION; --The delete operation failed

   /**
   * Generates a SHA1 hash for optimistic locking purposes.
   *
   * @param    p_id        must be NOT NULL
   */
   FUNCTION hash (
                  p_id IN precios.id%TYPE
                 )
    RETURN VARCHAR2;

   /**
   * This function generates a SHA1 hash for optimistic locking purposes.
   * Access directly to the row by rowid
   *
   * @param  p_rowid  must be NOT NULL
   */
   FUNCTION hash_rowid (p_rowid IN varchar2)
   RETURN varchar2;

   /**
   * This is a table encapsulation function designed to retrieve information from the precios table.
   *
   * @param      p_id      must be NOT NULL
   * @return     precios Record Type
   */
   FUNCTION rt (
                p_id IN precios.id%TYPE 
               )
    RETURN precios_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information
   * from the precios table while placing a lock on it for a potential
   * update/delete. Do not use this for updates in web based apps, instead use the
   * rt_for_web_update function to get a FOR_WEB_UPDATE_RT record which
   * includes all of the tables columns along with an md5 checksum for use in the
   * web_upd and web_del procedures.
   *
   * @param      p_id      must be NOT NULL
   * @return     precios Record Type
   */
   FUNCTION rt_for_update (
                          p_id IN precios.id%TYPE 
                          )
    RETURN precios_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information from the precios table.
   * This function return Record Table as PIPELINED Function
   *
   * @param      p_id      must be NOT NULL
   * @return     precios Table Record Type
   */
   FUNCTION tt (
                p_id IN precios.id%TYPE DEFAULT NULL
               )
   RETURN precios_tt
   PIPELINED;

   /**
   * This is a table encapsulation function designed to insert a row into the precios table.
   *
   * @param      p_precios_rec       Record Type
   * @return     p_precios_rec       Record Type
   */
   PROCEDURE ins (p_precios_rec IN OUT precios_rt);

   /**
   * This is a table encapsulation function designed to update a row in the precios table.
   *
   * @param      p_precios_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd (p_precios_rec IN precios_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row in the precios table,
   * access directly to the row by rowid
   *
   * @param      p_precios_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd_rowid (p_precios_rec IN precios_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the precios table whith optimistic lock validation
   *
   * @param      p_precios_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd (p_precios_rec IN precios_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the precios table whith optimistic lock validation
   * access directly to the row by rowid
   *
   * @param      p_precios_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd_rowid (p_precios_rec IN precios_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to delete a row from the precios table.
   *
   * @param    p_id        must be NOT NULL
   */
   PROCEDURE del (
                  p_id IN precios.id%TYPE
                );

   /**
   * This is a table encapsulation function designed to delete a row from the precios table
   * access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   */
    PROCEDURE del_rowid (p_rowid IN VARCHAR2);

   /**
   * This is a table encapsulation function designed to delete a row from the precios table
   * whith optimistic lock validation
   *
   * @param      p_id      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del (
                      p_id IN precios.id%TYPE,
                      p_hash IN varchar2
                      );

   /**
   * This is a table encapsulation function designed to delete a row from the precios table
   * whith optimistic lock validation, access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del_rowid (p_rowid IN varchar2, p_hash IN varchar2);

END tapi_precios;

/
--------------------------------------------------------
--  DDL for Package TAPI_SECCIONES
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."TAPI_SECCIONES" 
IS
   /**
   * TAPI_SECCIONES
   * Generated by: tapiGen2 - DO NOT MODIFY!
   * Website: github.com/osalvador/tapiGen2
   * Created On: 01-OCT-2019 11:06
   * Created By: FUNDAUC
   */

   --Scalar/Column types
   SUBTYPE hash_t IS varchar2 (40);
   SUBTYPE id_seccion IS secciones.id_seccion%TYPE;
   SUBTYPE id_metodo IS secciones.id_metodo%TYPE;
   SUBTYPE nivel IS secciones.nivel%TYPE;
   SUBTYPE id_salon IS secciones.id_salon%TYPE;
   SUBTYPE tope IS secciones.tope%TYPE;
   SUBTYPE status IS secciones.status%TYPE;
   SUBTYPE id_edif IS secciones.id_edif%TYPE;
   SUBTYPE horario IS secciones.horario%TYPE;
   SUBTYPE cedula_prof IS secciones.cedula_prof%TYPE;
   SUBTYPE modalidad IS secciones.modalidad%TYPE;
   SUBTYPE fec_inicio IS secciones.fec_inicio%TYPE;
   SUBTYPE periodo IS secciones.periodo%TYPE;
   SUBTYPE id_horario IS secciones.id_horario%TYPE;
   SUBTYPE id_calendario IS secciones.id_calendario%TYPE;
   SUBTYPE id IS secciones.id%TYPE;
   SUBTYPE creado_por IS secciones.creado_por%TYPE;
   SUBTYPE creado_el IS secciones.creado_el%TYPE;
   SUBTYPE modificado_por IS secciones.modificado_por%TYPE;
   SUBTYPE modificado_el IS secciones.modificado_el%TYPE;

   --Record type
   TYPE secciones_rt
   IS
      RECORD (
            id_seccion secciones.id_seccion%TYPE,
            id_metodo secciones.id_metodo%TYPE,
            nivel secciones.nivel%TYPE,
            id_salon secciones.id_salon%TYPE,
            tope secciones.tope%TYPE,
            status secciones.status%TYPE,
            id_edif secciones.id_edif%TYPE,
            horario secciones.horario%TYPE,
            cedula_prof secciones.cedula_prof%TYPE,
            modalidad secciones.modalidad%TYPE,
            fec_inicio secciones.fec_inicio%TYPE,
            periodo secciones.periodo%TYPE,
            id_horario secciones.id_horario%TYPE,
            id_calendario secciones.id_calendario%TYPE,
            id secciones.id%TYPE,
            creado_por secciones.creado_por%TYPE,
            creado_el secciones.creado_el%TYPE,
            modificado_por secciones.modificado_por%TYPE,
            modificado_el secciones.modificado_el%TYPE,
            hash               hash_t,
            row_id            VARCHAR2(64)
      );
   --Collection types (record)
   TYPE secciones_tt IS TABLE OF secciones_rt;

   --Global exceptions
   e_ol_check_failed EXCEPTION; --Optimistic lock check failed
   e_row_missing     EXCEPTION; --The cursor failed to get a row
   e_upd_failed      EXCEPTION; --The update operation failed
   e_del_failed      EXCEPTION; --The delete operation failed

   /**
   * Generates a SHA1 hash for optimistic locking purposes.
   *
   * @param    p_id        must be NOT NULL
   */
   FUNCTION hash (
                  p_id IN secciones.id%TYPE
                 )
    RETURN VARCHAR2;

   /**
   * This function generates a SHA1 hash for optimistic locking purposes.
   * Access directly to the row by rowid
   *
   * @param  p_rowid  must be NOT NULL
   */
   FUNCTION hash_rowid (p_rowid IN varchar2)
   RETURN varchar2;

   /**
   * This is a table encapsulation function designed to retrieve information from the secciones table.
   *
   * @param      p_id      must be NOT NULL
   * @return     secciones Record Type
   */
   FUNCTION rt (
                p_id IN secciones.id%TYPE 
               )
    RETURN secciones_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information
   * from the secciones table while placing a lock on it for a potential
   * update/delete. Do not use this for updates in web based apps, instead use the
   * rt_for_web_update function to get a FOR_WEB_UPDATE_RT record which
   * includes all of the tables columns along with an md5 checksum for use in the
   * web_upd and web_del procedures.
   *
   * @param      p_id      must be NOT NULL
   * @return     secciones Record Type
   */
   FUNCTION rt_for_update (
                          p_id IN secciones.id%TYPE 
                          )
    RETURN secciones_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information from the secciones table.
   * This function return Record Table as PIPELINED Function
   *
   * @param      p_id      must be NOT NULL
   * @return     secciones Table Record Type
   */
   FUNCTION tt (
                p_id IN secciones.id%TYPE DEFAULT NULL
               )
   RETURN secciones_tt
   PIPELINED;

   /**
   * This is a table encapsulation function designed to insert a row into the secciones table.
   *
   * @param      p_secciones_rec       Record Type
   * @return     p_secciones_rec       Record Type
   */
   PROCEDURE ins (p_secciones_rec IN OUT secciones_rt);

   /**
   * This is a table encapsulation function designed to update a row in the secciones table.
   *
   * @param      p_secciones_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd (p_secciones_rec IN secciones_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row in the secciones table,
   * access directly to the row by rowid
   *
   * @param      p_secciones_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd_rowid (p_secciones_rec IN secciones_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the secciones table whith optimistic lock validation
   *
   * @param      p_secciones_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd (p_secciones_rec IN secciones_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the secciones table whith optimistic lock validation
   * access directly to the row by rowid
   *
   * @param      p_secciones_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd_rowid (p_secciones_rec IN secciones_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to delete a row from the secciones table.
   *
   * @param    p_id        must be NOT NULL
   */
   PROCEDURE del (
                  p_id IN secciones.id%TYPE
                );

   /**
   * This is a table encapsulation function designed to delete a row from the secciones table
   * access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   */
    PROCEDURE del_rowid (p_rowid IN VARCHAR2);

   /**
   * This is a table encapsulation function designed to delete a row from the secciones table
   * whith optimistic lock validation
   *
   * @param      p_id      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del (
                      p_id IN secciones.id%TYPE,
                      p_hash IN varchar2
                      );

   /**
   * This is a table encapsulation function designed to delete a row from the secciones table
   * whith optimistic lock validation, access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del_rowid (p_rowid IN varchar2, p_hash IN varchar2);

END tapi_secciones;

/
--------------------------------------------------------
--  DDL for Package TAPI_USUARIOS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."TAPI_USUARIOS" 
IS
   /**
   * TAPI_USUARIOS
   * Generated by: tapiGen2 - DO NOT MODIFY!
   * Website: github.com/osalvador/tapiGen2
   * Created On: 18-AGO-2019 18:18
   * Created By: FUNDAUC
   */

   --Scalar/Column types
   SUBTYPE hash_t IS varchar2 (40);
   SUBTYPE cedula IS usuarios.cedula%TYPE;
   SUBTYPE nombre_usuario IS usuarios.nombre_usuario%TYPE;
   SUBTYPE contrasena IS usuarios.contrasena%TYPE;
   SUBTYPE id_rol IS usuarios.id_rol%TYPE;
   SUBTYPE email IS usuarios.email%TYPE;
   SUBTYPE nombre IS usuarios.nombre%TYPE;
   SUBTYPE cia IS usuarios.cia%TYPE;
   SUBTYPE prog_academico IS usuarios.prog_academico%TYPE;
   SUBTYPE activo IS usuarios.activo%TYPE;
   SUBTYPE bloqueado IS usuarios.bloqueado%TYPE;
   SUBTYPE creado_por IS usuarios.creado_por%TYPE;
   SUBTYPE creado_el IS usuarios.creado_el%TYPE;
   SUBTYPE modificado_por IS usuarios.modificado_por%TYPE;
   SUBTYPE modificado_el IS usuarios.modificado_el%TYPE;

   --Record type
   TYPE usuarios_rt
   IS
      RECORD (
            cedula usuarios.cedula%TYPE,
            nombre_usuario usuarios.nombre_usuario%TYPE,
            contrasena usuarios.contrasena%TYPE,
            id_rol usuarios.id_rol%TYPE,
            email usuarios.email%TYPE,
            nombre usuarios.nombre%TYPE,
            cia usuarios.cia%TYPE,
            prog_academico usuarios.prog_academico%TYPE,
            activo usuarios.activo%TYPE,
            bloqueado usuarios.bloqueado%TYPE,
            creado_por usuarios.creado_por%TYPE,
            creado_el usuarios.creado_el%TYPE,
            modificado_por usuarios.modificado_por%TYPE,
            modificado_el usuarios.modificado_el%TYPE,
            hash               hash_t,
            row_id            VARCHAR2(64)
      );
   --Collection types (record)
   TYPE usuarios_tt IS TABLE OF usuarios_rt;

   --Global exceptions
   e_ol_check_failed EXCEPTION; --Optimistic lock check failed
   e_row_missing     EXCEPTION; --The cursor failed to get a row
   e_upd_failed      EXCEPTION; --The update operation failed
   e_del_failed      EXCEPTION; --The delete operation failed

   /**
   * Generates a SHA1 hash for optimistic locking purposes.
   *
   * @param    p_cedula        must be NOT NULL
   */
   FUNCTION hash (
                  p_cedula IN usuarios.cedula%TYPE
                 )
    RETURN VARCHAR2;

   /**
   * This function generates a SHA1 hash for optimistic locking purposes.
   * Access directly to the row by rowid
   *
   * @param  p_rowid  must be NOT NULL
   */
   FUNCTION hash_rowid (p_rowid IN varchar2)
   RETURN varchar2;

   /**
   * This is a table encapsulation function designed to retrieve information from the usuarios table.
   *
   * @param      p_cedula      must be NOT NULL
   * @return     usuarios Record Type
   */
   FUNCTION rt (
                p_cedula IN usuarios.cedula%TYPE 
               )
    RETURN usuarios_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information
   * from the usuarios table while placing a lock on it for a potential
   * update/delete. Do not use this for updates in web based apps, instead use the
   * rt_for_web_update function to get a FOR_WEB_UPDATE_RT record which
   * includes all of the tables columns along with an md5 checksum for use in the
   * web_upd and web_del procedures.
   *
   * @param      p_cedula      must be NOT NULL
   * @return     usuarios Record Type
   */
   FUNCTION rt_for_update (
                          p_cedula IN usuarios.cedula%TYPE 
                          )
    RETURN usuarios_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information from the usuarios table.
   * This function return Record Table as PIPELINED Function
   *
   * @param      p_cedula      must be NOT NULL
   * @return     usuarios Table Record Type
   */
   FUNCTION tt (
                p_cedula IN usuarios.cedula%TYPE DEFAULT NULL
               )
   RETURN usuarios_tt
   PIPELINED;

   /**
   * This is a table encapsulation function designed to insert a row into the usuarios table.
   *
   * @param      p_usuarios_rec       Record Type
   * @return     p_usuarios_rec       Record Type
   */
   PROCEDURE ins (p_usuarios_rec IN OUT usuarios_rt);

   /**
   * This is a table encapsulation function designed to update a row in the usuarios table.
   *
   * @param      p_usuarios_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd (p_usuarios_rec IN usuarios_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row in the usuarios table,
   * access directly to the row by rowid
   *
   * @param      p_usuarios_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd_rowid (p_usuarios_rec IN usuarios_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the usuarios table whith optimistic lock validation
   *
   * @param      p_usuarios_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd (p_usuarios_rec IN usuarios_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the usuarios table whith optimistic lock validation
   * access directly to the row by rowid
   *
   * @param      p_usuarios_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd_rowid (p_usuarios_rec IN usuarios_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to delete a row from the usuarios table.
   *
   * @param    p_cedula        must be NOT NULL
   */
   PROCEDURE del (
                  p_cedula IN usuarios.cedula%TYPE
                );

   /**
   * This is a table encapsulation function designed to delete a row from the usuarios table
   * access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   */
    PROCEDURE del_rowid (p_rowid IN VARCHAR2);

   /**
   * This is a table encapsulation function designed to delete a row from the usuarios table
   * whith optimistic lock validation
   *
   * @param      p_cedula      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del (
                      p_cedula IN usuarios.cedula%TYPE,
                      p_hash IN varchar2
                      );

   /**
   * This is a table encapsulation function designed to delete a row from the usuarios table
   * whith optimistic lock validation, access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del_rowid (p_rowid IN varchar2, p_hash IN varchar2);

END tapi_usuarios;


/
--------------------------------------------------------
--  DDL for Package TEPLSQL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."TEPLSQL" 
AS
   --Define Associative Array
   TYPE t_assoc_array
   IS
      TABLE OF VARCHAR2 (32767)
         INDEX BY VARCHAR2 (255);

   null_assoc_array   t_assoc_array;

   /**
   * Output CLOB data to the DBMS_OUTPUT.PUT_LINE
   *
   * @param  p_clob     the CLOB to print to the DBMS_OUTPUT
   */
   PROCEDURE output_clob(p_clob in CLOB);

   /**
   * Prints received data into the buffer
   *
   * @param  p_data     the data to print into buffer
   */
   PROCEDURE PRINT (p_data IN CLOB);

   PROCEDURE p (p_data IN CLOB);

   PROCEDURE PRINT (p_data IN VARCHAR2);

   PROCEDURE p (p_data IN VARCHAR2);

   PROCEDURE PRINT (p_data IN NUMBER);

   PROCEDURE p (p_data IN NUMBER);

   /**
   * Renders the template received as parameter.
   *
   * @param  p_vars      the template's arguments.
   * @param  p_template  the template's body.
   * @return             the processed template.
   */
   FUNCTION render (p_vars IN t_assoc_array DEFAULT null_assoc_array, p_template IN CLOB)
      RETURN CLOB;

   /**
   * Receives the name of the object, usually a package,
   * which contains an embedded template.
   * The template is extracted and is rendered with `render` function
   *
   * @param  p_vars             the template's arguments.
   * @param  p_template_name    the name of the template
   * @param  p_object_name      the name of the object (usually the name of the package)
   * @param  p_object_type      the type of the object (PACKAGE, PROCEDURE, FUNCTION...)
   * @param  p_schema           the object's schema name.
   * @return                    the processed template.
   */
   FUNCTION process (p_vars            IN t_assoc_array DEFAULT null_assoc_array
                   , p_template_name   IN VARCHAR2 DEFAULT NULL
                   , p_object_name     IN VARCHAR2 DEFAULT 'TE_TEMPLATES'
                   , p_object_type     IN VARCHAR2 DEFAULT 'PACKAGE'
                   , p_schema          IN VARCHAR2 DEFAULT NULL )
      RETURN CLOB;
END teplsql;

/
--------------------------------------------------------
--  DDL for Package TOOLKIT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."TOOLKIT" AS

  FUNCTION encrypt (p_text  IN  VARCHAR2) RETURN RAW;

  FUNCTION decrypt (p_raw  IN  RAW) RETURN VARCHAR2;

  FUNCTION LOGIN (p_username IN VARCHAR2, p_password VARCHAR2) RETURN BOOLEAN;

  FUNCTION get_tipo_acceso (p_usr IN VARCHAR2, p_app VARCHAR2) RETURN CHAR;

END toolkit;

/
--------------------------------------------------------
--  DDL for Package UTL_CALENDARIOS_DETALLES
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."UTL_CALENDARIOS_DETALLES" AS 

    FUNCTION getTotalPeriodosCal (
        vid_calendario NUMBER
    ) RETURN NUMBER;

    FUNCTION getTotalPeriodosCalMod (
        vid_calendario NUMBER,
        vid_modalidad NUMBER
    ) RETURN NUMBER;

    FUNCTION getSiguentePeriodoMod (
        vid_calendario NUMBER,
        vid_modalidad NUMBER
    ) RETURN NUMBER;
    
    FUNCTION getCalendario (
        vid_calendario NUMBER
    ) RETURN VARCHAR2;

END UTL_CALENDARIOS_DETALLES;

/
--------------------------------------------------------
--  DDL for Package UTL_CONFIGURACION
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."UTL_CONFIGURACION" AS 

    FUNCTION getConfIva RETURN NUMBER;

    FUNCTION getConfUltFactura RETURN NUMBER;

    PROCEDURE actConfUltFactura(numero IN number);

    FUNCTION getConfPorTDC RETURN NUMBER;

    FUNCTION getConfPorTDB RETURN NUMBER;

END UTL_CONFIGURACION;

/
--------------------------------------------------------
--  DDL for Package UTL_ESTUDIANTES
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."UTL_ESTUDIANTES" AS 
    
    FUNCTION getTipoEstudiante (
        vid_tipoest NUMBER
    ) RETURN VARCHAR2;

END UTL_ESTUDIANTES;

/
--------------------------------------------------------
--  DDL for Package UTL_FACTURA
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."UTL_FACTURA" AS 
    
    FUNCTION getTotal (
        vid IN NUMBER
    ) RETURN NUMBER;

    PROCEDURE insIngDiferido (
        vfid IN NUMBER, 
        vmonto IN NUMBER,
        vresp OUT NUMBER);

END UTL_FACTURA;

/
--------------------------------------------------------
--  DDL for Package UTL_FACTURA_DEPOSITO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."UTL_FACTURA_DEPOSITO" AS 
    
    PROCEDURE ins_multi (
        v_jsonfac IN varchar2,
        vid_deposito IN number
    );

END UTL_FACTURA_DEPOSITO;

/
--------------------------------------------------------
--  DDL for Package UTL_HORARIOS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."UTL_HORARIOS" AS 

    FUNCTION getTotalHorarios (
        vid_modalidad NUMBER
    ) RETURN NUMBER;

    FUNCTION getHorario (
        vid_horario NUMBER
    ) RETURN VARCHAR2;
    
    FUNCTION getHorarioMin (
        vid_horario NUMBER
    ) RETURN VARCHAR2;

    FUNCTION getIdHorario (
        vdes_horario VARCHAR2,
        vid_modalidad NUMBER
    ) RETURN NUMBER;

END UTL_HORARIOS;

/
--------------------------------------------------------
--  DDL for Package UTL_INSCRIPCIONES
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."UTL_INSCRIPCIONES" AS 
    --Record type
    TYPE seccion_rt IS RECORD ( seccion_id secciones.id_seccion%TYPE,
    id_metodo secciones.id_metodo%TYPE,
    nivel secciones.nivel%TYPE,
    id_horario secciones.id_horario%TYPE,
    id_modalidad secciones.modalidad%TYPE,
    id_periodo secciones.periodo%TYPE );
   --Collection types (record)
    TYPE seccion_tt IS
        TABLE OF seccion_rt;
    FUNCTION getinscripcionesseccion (
        vid_seccion NUMBER,
        vid_periodo NUMBER
    ) RETURN NUMBER;

    FUNCTION getinscripcionescohorte (
        vid_cohorte NUMBER,
        vid_periodo NUMBER
    ) RETURN NUMBER;

    FUNCTION getdesstatus (
        v_status VARCHAR2
    ) RETURN VARCHAR2;

    FUNCTION getstatusfac (
        vid_insc NUMBER
    ) RETURN VARCHAR2;

    PROCEDURE elimina_inscripciones;

    PROCEDURE actualiza_estatus;

    PROCEDURE actualiza_est_ins (
        facturas IN VARCHAR2
    );

    FUNCTION log_message (
        message IN VARCHAR2
    ) RETURN NUMBER;

    FUNCTION getseccionrec (
        p_renglon   IN detalle_factura.renglon%TYPE
    ) RETURN seccion_rt
        RESULT_CACHE;

    FUNCTION getsecciondes (
        p_id_seccion   IN secciones.id%TYPE
    ) RETURN VARCHAR2;

    FUNCTION getseccioncod (
        p_id_secc   IN secciones.id%TYPE
    ) RETURN VARCHAR2;

    FUNCTION getcohortedes (
        p_id_cohorte   IN cohortes.id%TYPE
    ) RETURN VARCHAR2;

    FUNCTION getcodigoseccion (
        metodo_id     IN VARCHAR2,
        nivel         IN NUMBER,
        periodo_id    IN NUMBER,
        modalidad_id  IN NUMBER,
        horario_id    IN NUMBER
    ) RETURN VARCHAR2;

END utl_inscripciones;

/
--------------------------------------------------------
--  DDL for Package UTL_MATERIALES
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."UTL_MATERIALES" AS 

    --Record type
   TYPE detalle_factura_rt
   IS
      RECORD (
            renglon detalle_factura.renglon%TYPE,
            tipo_item detalle_factura.tipo_item%TYPE,
            item detalle_factura.item%TYPE,
            descripcion detalle_factura.descripcion%TYPE,
            cantidad detalle_factura.cantidad%TYPE,
            p_unidad detalle_factura.p_unidad%TYPE,
            bs_descuento detalle_factura.bs_descuento%TYPE,
            subtotal detalle_factura.subtotal%TYPE,
            materiales_id detalle_factura.materiales_id%TYPE,
            factura_id detalle_factura.factura_id%TYPE
      );

    FUNCTION getRecDetalleFac (
        vid_material NUMBER,
        vtipo_mat    VARCHAR2
    ) RETURN detalle_factura_rt RESULT_CACHE;

    FUNCTION getRecDetalleFac (
        vcod_mat    VARCHAR2
    ) RETURN detalle_factura_rt RESULT_CACHE;

    FUNCTION getExentoIva (
        vid_material NUMBER
    ) RETURN CHAR;

END UTL_MATERIALES;


/
--------------------------------------------------------
--  DDL for Package UTL_MODALIDADES
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."UTL_MODALIDADES" AS 
    
    FUNCTION getModalidad (
        vid_modalidad NUMBER
    ) RETURN VARCHAR2;
    
    FUNCTION getSiglas (
        vid_modalidad NUMBER
    ) RETURN VARCHAR2;

    FUNCTION getIdModalidad (
        vdes_modalidad VARCHAR2
    ) RETURN NUMBER;

END UTL_MODALIDADES;

/
--------------------------------------------------------
--  DDL for Package UTL_PERIODOS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FUNDAUC"."UTL_PERIODOS" AS 

    FUNCTION getTotalperiodos (
        vid_calendario NUMBER
    ) RETURN NUMBER;

    FUNCTION getPeriodo (
        vid_periodo NUMBER
    ) RETURN VARCHAR2;

    FUNCTION getPeriodoFInicio (
        vid_periodo NUMBER
    ) RETURN DATE;
    
    FUNCTION getPeriodoFFin (
        vid_periodo NUMBER
    ) RETURN DATE;

     FUNCTION getPeriodoSec (
        vid_seccion NUMBER
    ) RETURN VARCHAR2;

     FUNCTION getPeriodoCor (
        vid_cohorte NUMBER
    ) RETURN VARCHAR2;

    FUNCTION getStatusPeriodo (
        vid_periodo NUMBER
    ) RETURN VARCHAR2;

    FUNCTION getStatusPeriodoSec (
        vid_seccion NUMBER
    ) RETURN VARCHAR2;
    
    FUNCTION getPeriodoFecIniSec (
        vid_seccion NUMBER
    ) RETURN DATE;

    FUNCTION getPeriodoFecFinSec (
        vid_seccion NUMBER
    ) RETURN DATE;

    FUNCTION getStatusPeriodoCor (
        vid_cohorte NUMBER
    ) RETURN VARCHAR2;
    
    FUNCTION getPeriodoFecIniCor (
        vid_cohorte NUMBER
    ) RETURN DATE;

END UTL_PERIODOS;

/
