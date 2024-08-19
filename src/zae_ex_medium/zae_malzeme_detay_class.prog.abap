*&---------------------------------------------------------------------*
*& Report zae_malzeme_detay_class
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zae_malzeme_detay_class.

TYPES: BEGIN OF ty_outtab,
         matnr TYPE mara-matnr,
         norm  TYPE mara-normt,
         mtart TYPE mara-mtart,
         meins TYPE mara-meins,
         ersda TYPE mara-ersda,
         ernam TYPE mara-ernam,
       END OF ty_outtab.

DATA: gt_outtab       TYPE HASHED TABLE OF ty_outtab WITH UNIQUE KEY matnr,
      gs_general_data TYPE bapimatdoa,
      gt_out_data     TYPE TABLE OF bapimatdoa WITH HEADER LINE.

DATA: gt_fieldcatalog TYPE slis_t_fieldcat_alv,
      gs_fieldcatalog TYPE slis_fieldcat_alv,
      gs_layout       TYPE slis_layout_alv.

INITIALIZATION.

  SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-100.
  PARAMETERS: s_matnr TYPE mara-matnr.
  SELECTION-SCREEN END OF BLOCK b1.

CLASS malzeme DEFINITION.

  PUBLIC SECTION.
    CLASS-METHODS getdata.
    "METHODS getdata.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.

CLASS malzeme IMPLEMENTATION.
  METHOD getdata.

    SELECT m~matnr,
           m~normt,
           m~mtart,
           m~meins,
           m~ersda,
           m~ernam
      FROM mara AS m
      "WHERE matnr IN s_matnr
      INTO TABLE @gt_outtab.

  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  malzeme=>getdata(  ).

  LOOP AT gt_outtab INTO DATA(ls_outtab).

    DATA: lv_matnr TYPE bapimatdet-material.
    lv_matnr = ls_outtab-matnr.

    CALL FUNCTION 'BAPI_MATERIAL_GET_DETAIL'
      EXPORTING
        material              = lv_matnr
      IMPORTING
        material_general_data = gs_general_data.
*        material_general_data = ls_outtab.

*    gt_out_data-old_mat_no = lv_matnr.
    gs_general_data-old_mat_no = lv_matnr.

    APPEND gs_general_data TO gt_out_data.

    CLEAR gs_general_data.

  ENDLOOP.


  PERFORM: set_fc USING 'OLD_MAT_NO' 'Mal Num' 'Malze. Num.' 'Malzeme Numarası',
            set_fc USING 'MATL_DESC' 'Mal Tan' 'Malze. Tan.' 'Malzeme Tanımı',
            set_fc USING 'MATL_TYPE' 'Mal Tür' 'Malze. Tür.' 'Malzeme Türü',
            set_fc USING 'BASE_UOM' 'T. Ölç. Br.' 'Tem. Ölç. Br..' 'Temel Ölçü Birimi',
            set_fc USING 'CREATED_ON' 'Ol. Tah.' 'Oluş. Tah.' 'Oluşturma Tarihi',
            set_fc USING 'CREATED_BY' 'Oluş. Ki.' 'Oluş. Kiş.' 'Oluşturan Kişi'.

  gs_layout-colwidth_optimize = abap_true.
  gs_layout-zebra             = abap_true.
  gs_layout-expand_all        = abap_true.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      it_fieldcat = gt_fieldcatalog
      is_layout   = gs_layout
    TABLES
      t_outtab    = gt_out_data.

FORM set_fc USING
      p_fieldname
      p_seltext_s
      p_seltext_m
      p_seltext_l.

  CLEAR gs_fieldcatalog.
  gs_fieldcatalog-fieldname = p_fieldname.
  gs_fieldcatalog-seltext_s = p_seltext_s.
  gs_fieldcatalog-seltext_m = p_seltext_m.
  gs_fieldcatalog-seltext_l = p_seltext_l.
  APPEND gs_fieldcatalog TO gt_fieldcatalog.
ENDFORM.
