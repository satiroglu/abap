*&---------------------------------------------------------------------*
*& Report ZAE_ENVANTER_EXCEL_YUKLEME
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zae_envanter_excel_yukleme.

TABLES: sscrfields, zae_envanter_kod, zae_envanter_ls.

DATA: BEGIN OF ty_file,
        mandt       TYPE sy-mandt,
        envanter_id TYPE zae_envanter_ls-envanter_id,
        adet        TYPE zae_envanter_ls-adet,
        cname       TYPE zae_envanter_ls-cname,
        cdate       TYPE zae_envanter_ls-cdate,
        ctime       TYPE zae_envanter_ls-ctime,
      END OF ty_file.

DATA : ls_data LIKE ty_file,
       lt_data LIKE TABLE OF ty_file.

DATA: h_excel TYPE ole2_object, " Excel object
      h_mapl  TYPE ole2_object, " list of workbooks
      h_map   TYPE ole2_object, " workbook
      h_zl    TYPE ole2_object, " cell
      h_wt    TYPE ole2_object, " width
      h_f     TYPE ole2_object. " font
DATA : lt_envanter TYPE TABLE OF zae_envanter_ls.

*********************************************************
DATA: gt_added_data TYPE TABLE OF zae_envanter_ls.

*********************************************************


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-100.
PARAMETERS: p_disply RADIOBUTTON GROUP r1 USER-COMMAND c1,
            p_maintn RADIOBUTTON GROUP r1.
SELECTION-SCREEN   END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-101.
PARAMETERS : p_file TYPE localfile.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-102.

SELECTION-SCREEN PUSHBUTTON 1(19) but1 USER-COMMAND def .

SELECTION-SCREEN END OF BLOCK b3.

*********************************************************
AT SELECTION-SCREEN OUTPUT.
  but1 = 'Örnek excel şablonunu indir'.
  LOOP AT SCREEN.
    IF screen-name EQ 'P_FILE'.
      screen-input = SWITCH #( p_maintn WHEN abap_true THEN 1 ELSE 0 ).
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.
*********************************************************
AT SELECTION-SCREEN.
  CASE sscrfields.
    WHEN 'DEF'.
      PERFORM file_template.
  ENDCASE.
*********************************************************
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM get_filename.
*********************************************************
START-OF-SELECTION.
  CASE abap_true.
    WHEN p_disply.
      PERFORM display_table_content.
      PERFORM display.
    WHEN p_maintn.
      IF p_file IS INITIAL.
        MESSAGE i216(fz).
      ELSE.
        PERFORM upload_data_from_file.
      ENDIF.
  ENDCASE.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_TABLE_CONTENT
*&---------------------------------------------------------------------*
FORM display_table_content.

  SELECT * FROM zae_envanter_ls INTO TABLE lt_envanter.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UPLOAD_DATA_FROM_FILE
*&---------------------------------------------------------------------*
FORM upload_data_from_file .

*  data: gt_excel_data like table of alsmex_tabline.

  DATA:
    BEGIN OF gt_excel_data OCCURS 1,
      envanter_id LIKE zae_envanter_ls-envanter_id,
      adet        LIKE zae_envanter_ls-adet,
      cname       LIKE sy-uname,
      cdate       LIKE sy-datum,
      ctime       LIKE sy-uzeit,
    END OF gt_excel_data.

* yüklenen veri doyasındaki veriler okunup gt_excel_data'ya aktarılır.
  CALL FUNCTION 'FILE_READ_AND_CONVERT_SAP_DATA'
    EXPORTING
      i_filename           = CONV fileintern( p_file )
      i_servertyp          = 'OLE2'
      i_fileformat         = 'XLS'
*     i_field_seperator    = ';'
      i_line_header        = 'X'
*    importing
*     e_bin_filelength     = e_bin_filelength
    TABLES
      i_tab_receiver       = gt_excel_data[]
    EXCEPTIONS
      file_not_found       = 1
      close_failed         = 2
      authorization_failed = 3
      open_failed          = 4
      conversion_failed    = 5
      OTHERS               = 6.

* Kontrol koşulları
*  if sy-subrc eq 0.
*    message 'Veriler başarıyla yüklendi' type 'I'.
*  elseif sy-subrc eq 1.
*    message 'file_not_found' type 'I'.
*  elseif sy-subrc eq 2.
*    message 'close_failed' type 'E'.
*  elseif sy-subrc eq 3.
*    message 'authorization_failed' type 'E'.
*  elseif sy-subrc eq 4.
*    message 'open_failed' type 'E'.
*  elseif sy-subrc eq 5.
*    message 'conversion_failed' type 'E'.
*  else.
*    message 'Bilinmeyen hata!' type 'E'.
*  endif.

  IF lines( gt_excel_data[] ) > 10000 .
    MESSAGE '10,000 satırdan fazla veri alınamaz.' TYPE 'E'.
  ENDIF.


  IF gt_excel_data[] IS INITIAL.
    MESSAGE 'Dosya Okunamadı !' TYPE 'I'.
  ELSE.
    LOOP AT gt_excel_data.
      ls_data-mandt = sy-mandt.
      ls_data-envanter_id = gt_excel_data-envanter_id.
      ls_data-adet = gt_excel_data-adet.
      ls_data-cname = sy-uname.
      ls_data-cdate = sy-datum.
      ls_data-ctime = sy-uzeit.
      APPEND ls_data TO lt_data.
      CLEAR ls_data.
    ENDLOOP.
  ENDIF.

  IF lt_data[] IS NOT INITIAL.

    SELECT envanter_id
      FROM zae_envanter_kod
      INTO TABLE @DATA(lt_env_id).

*  loop at gt_excel_data.
*    if gt_excel_data-envanter_id eq lt_env_id-.
*      message 'envanter tablosunda var.' type 'I'.
*    elseif gt_excel_data-envanter_id ne zae_table_env_id.
*      message 'yok' type 'I'.
*    endif.
*  endloop.

    gt_added_data[] = CORRESPONDING #( lt_data ).
    DELETE FROM zae_envanter_ls.
    MODIFY zae_envanter_ls FROM TABLE gt_added_data.
    COMMIT WORK.
    MESSAGE s008(trc0).
  ELSE.
    MESSAGE 'Dosyada Data Bulunamadı!' TYPE 'I'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FILENAME
*&---------------------------------------------------------------------*
FORM get_filename .
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      field_name = 'P_FILE'
    IMPORTING
      file_name  = p_file.
ENDFORM.                    " GET_FILENAME
*&---------------------------------------------------------------------*
*& Form file_template
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM file_template.
  DATA: lfd_col TYPE i,
        lfd_row TYPE i.
* start Excel
  CREATE OBJECT h_excel 'EXCEL.APPLICATION'.
  SET PROPERTY OF h_excel  'Visible' = 1.
  CALL METHOD OF
    h_excel
      'Workbooks' = h_mapl.
  CALL METHOD OF
    h_mapl
      'Add' = h_map.

  lfd_col = 2 - 1.
  lfd_row = 2 - 1.
  PERFORM fill_cell USING lfd_row 1 12 'Envanter ID'.
  PERFORM fill_cell USING lfd_row 2 6 'Adet'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FILL_CELL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LFD_ROW
*&      --> P_1
*&      --> P_21
*&      --> P_
*&---------------------------------------------------------------------*
FORM fill_cell  USING   i j bold val.
  CALL METHOD OF h_excel
      'Cells' = h_zl
    EXPORTING
      #1      = i
      #2      = j.
  SET PROPERTY OF h_zl 'Value' = val .
  GET PROPERTY OF h_zl 'Font' = h_f.
  SET PROPERTY OF h_zl 'ColumnWidth' = 12 .
  SET PROPERTY OF h_f  'Bold' = bold .
  SET PROPERTY OF h_f  'Size' = 10 .
  SET PROPERTY OF h_f  'ColorIndex' =  5 .
*  set property of h_f 'Name' = 'naber'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display .

  DATA: lr_alv        TYPE REF TO cl_salv_table,
        lr_column     TYPE REF TO cl_salv_column_table,
        lv_date2      TYPE sy-datum,
        lv_date1      TYPE sy-datum,
        lo_selections TYPE REF TO cl_salv_selections.

  CALL METHOD cl_salv_table=>factory
    IMPORTING
      r_salv_table = lr_alv
    CHANGING
      t_table      = lt_envanter.


  DATA(lr_columns) = lr_alv->get_columns( ).
  lr_columns->set_optimize( 'X' ).


*Satır seçimi objesi
  lo_selections = lr_alv->get_selections( ).
  lo_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ) .


*Manuel Rapor başlığı verme
  DATA(lr_display) = lr_alv->get_display_settings( ).
  lr_display->set_striped_pattern( if_salv_c_bool_sap=>true ).
  lr_display->set_list_header( 'Envanter Raporu' ).


*Display edilir
  lr_alv->display( ).


ENDFORM.
