*&---------------------------------------------------------------------*
*& Report ZAE_MALZEME_DETAY_RAPOR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*& Creation Date: 28.07.2022 12:23:22
*&---------------------------------------------------------------------*

report zae_malzeme_detay_rapor.

tables: mara.

" verilerin toplanacağı datalar
data: gt_outtab       type table of mara, " SELECT ile çekiler verilerin toplantığı itab.
      gs_general_data type bapimatdoa, " BAPI'ye gönderilen internal table'ın structure'ı
      gt_out_data     type table of bapimatdoa with header line. " BAPI'ye gönderilen internal table
*      gs_matnr        type range_matnr.

data: gt_fieldcatalog type slis_t_fieldcat_alv,
      gs_fieldcatalog type slis_fieldcat_alv,
      gs_layout       type slis_layout_alv.

" malzeme numarası gir
selection-screen begin of block b1 with frame title text-100.
select-options: s_matnr for mara-matnr no intervals .
selection-screen end of block b1.

start-of-selection.

  " mara'dan verileri çek
  select m~matnr
         m~normt
         m~mtart
         m~meins
         m~ersda
         m~ernam
  from mara as m
  into corresponding fields of table gt_outtab
  where matnr in s_matnr.

  loop at gt_outtab into data(ls_outtab).

    data: lv_matnr type bapimatdet-material.
    lv_matnr = ls_outtab-matnr.

    call function 'BAPI_MATERIAL_GET_DETAIL'
      exporting
        material              = lv_matnr
      importing
        material_general_data = gs_general_data.
*        material_general_data = ls_outtab.

*    gt_out_data-old_mat_no = lv_matnr.
    gs_general_data-old_mat_no = lv_matnr.

    append gs_general_data to gt_out_data.

    clear gs_general_data.

  endloop.

  perform: set_fc using 'OLD_MAT_NO' 'Mal Num' 'Malze. Num.' 'Malzeme Numarası',
           set_fc using 'MATL_DESC' 'Mal Tan' 'Malze. Tan.' 'Malzeme Tanımı',
           set_fc using 'MATL_TYPE' 'Mal Tür' 'Malze. Tür.' 'Malzeme Türü',
           set_fc using 'BASE_UOM' 'T. Ölç. Br.' 'Tem. Ölç. Br..' 'Temel Ölçü Birimi',
           set_fc using 'CREATED_ON' 'Ol. Tah.' 'Oluş. Tah.' 'Oluşturma Tarihi',
           set_fc using 'CREATED_BY' 'Oluş. Ki.' 'Oluş. Kiş.' 'Oluşturan Kişi'.

  " ALV layout özellik tanımlamaları
  gs_layout-colwidth_optimize = abap_true.
  gs_layout-zebra             = abap_true.
  gs_layout-expand_all        = abap_true.

  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
      it_fieldcat = gt_fieldcatalog
      is_layout   = gs_layout
    tables
      t_outtab    = gt_out_data.

*&---------------------------------------------------------------------*
*& Form SET_FC
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form set_fc using
      p_fieldname
      p_seltext_s
      p_seltext_m
      p_seltext_l.

  clear gs_fieldcatalog.
  gs_fieldcatalog-fieldname = p_fieldname.
  gs_fieldcatalog-seltext_s = p_seltext_s.
  gs_fieldcatalog-seltext_m = p_seltext_m.
  gs_fieldcatalog-seltext_l = p_seltext_l.
  append gs_fieldcatalog to gt_fieldcatalog.
endform.
