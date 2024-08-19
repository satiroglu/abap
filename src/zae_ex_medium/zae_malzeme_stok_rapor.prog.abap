*&---------------------------------------------------------------------*
*& Report ZAE_MALZEME_STOK_RAPOR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zae_malzeme_stok_rapor.

tables: mara, makt.

types: begin of ty,
         matnr type mara-matnr,
         spras type makt-spras,
         maktx type makt-maktx,
         labst type mard-labst,
         werks type mard-werks,
         name1 type t001w-name1,
         lgort type mard-lgort,
         lgobe type t001l-lgobe,
       end of ty.

data: gs_out          type ty,
      gt_out          type table of ty,
      gt_fieldcatalog type slis_t_fieldcat_alv,
      gs_fieldcatalog type slis_fieldcat_alv,
      gs_layout       type slis_layout_alv.


data: go_salv  type ref to cl_salv_table. " salv için oluşturduğumuz obje

selection-screen begin of block b1 with frame title text-101.
select-options: s_matnr for mara-matnr modif id g1 no intervals,
                s_spras for makt-spras modif id g1 no-extension no intervals default 'TR'.
selection-screen end of block b1.

start-of-selection.

  select m1~matnr m2~spras m2~maktx m3~labst m3~werks t1~name1 m3~lgort t2~lgobe
    from mara as m1
    inner join makt as m2 on m2~matnr eq m1~matnr
    inner join mard as m3 on m3~matnr eq m1~matnr
    inner join t001w as t1 on t1~werks eq m3~werks
    inner join t001l as t2 on t2~lgort eq m3~lgort and t2~werks eq m3~werks
    into corresponding fields of table gt_out
    where m1~matnr in s_matnr
      and m2~spras in s_spras.

  " salv class ını çağırıyoruz.
  cl_salv_table=>factory(
    importing
      r_salv_table   = go_salv " salv için oluşturduğumuz objeyi yazıyoruz
    changing
      t_table        = gt_out " alv ye gönderilecek olan itab
  ).


  " görüntüleme özelleştirmeleri
  " ALV özelleştirme dataları
  data: lo_display type ref to cl_salv_display_settings,
        lo_cols    type ref to cl_salv_columns,
        lo_col     type ref to cl_salv_column,
        lo_func    type ref to cl_salv_functions, " tool bar ekleme

        " ALV başlık kısımları
        lo_header  type ref to cl_salv_form_layout_grid,
        lo_h_label type ref to cl_salv_form_label,
        lo_h_flow  type ref to cl_salv_form_layout_flow.



  lo_display = go_salv->get_display_settings( ).

  lo_display->set_list_header( value = 'SALV Basit Başlığı' ). " ALV başlığı güncelleme
  lo_display->set_striped_pattern( value = 'X' ). " ALV'nin zebra gibi olmasını sağlar

  " ALV kolonlarının boyutlarının optimize edilmesi.
  lo_cols = go_salv->get_columns( ).
  lo_cols->set_optimize( value = abap_true ).


*  try.
*      " ALV'de özel bir kolonu seçip başlıklarını düzenlemek
*      lo_col = lo_cols->get_column( columnname = 'SPRAS' ).
*      lo_col->set_long_text( value = 'Yeni Fatura Düzenleyici' ).
*      lo_col->set_medium_text( value = 'Yeni Fatura D.' ).
*      lo_col->set_short_text( value = 'Yeni Fat' ).
*
*    catch cx_salv_not_found.
*
*  endtry.

  try.
      " ALV'de bir kolon gizleme. bu örnekte MANDT(üst birim) gizleniyor
      lo_col = lo_cols->get_column( columnname = 'SPRAS' ).
      lo_col->set_visible( value = if_salv_c_bool_sap=>false ).

    catch cx_salv_not_found.

  endtry.

  " ALV ye üstteki toolbar eklendi.
  lo_func = go_salv->get_functions( ).
  lo_func->set_all(
      value = if_salv_c_bool_sap=>true
  ).




  " ALV'yi göster
  go_salv->display( ).












































*  perform: set_fc using 'MATNR' 'Mal Num' 'Malze. Num.' 'Malzeme Numarası',
*             set_fc using 'MAKTX' 'T. Ölç. Br.' 'Temel Ölç.' 'Temel Ölçü Birimi',
*             set_fc using 'LABST' 'Mal Tan' 'Malze. Tan.' 'Malzeme Tanımı',
*             set_fc using 'WERKS' 'Mal Tür' 'Malze. Tür.' 'Malzeme Türü',
*             set_fc using 'NAME1' 'Oluş. T.' 'Oluş. Tah.' 'Oluş. Tarihi.',
*             set_fc using 'LGORT' 'Depo Y.' 'Depo Yeri' 'Depo Yeri',
*             set_fc using 'LGOBE' 'Depot YT' 'Depo Yeri T.' 'Depo Yeri Tanımı'.

*  perform display_alv.

*form display_alv.
*  " ALV layout özellik tanımlamaları
*  gs_layout-colwidth_optimize = abap_true.
*  gs_layout-zebra = abap_true.
*
*  call function 'REUSE_ALV_GRID_DISPLAY'
*    exporting
*      it_fieldcat = gt_fieldcatalog
*      is_layout   = gs_layout
*    tables
*      t_outtab    = gt_out.
*endform.
*
*form get_data.
*
*  select m1~matnr m2~spras m2~maktx m3~labst m3~werks t1~name1 m3~lgort t2~lgobe
*      from mara as m1
*      inner join makt as m2 on m2~matnr eq m1~matnr
*      inner join mard as m3 on m3~matnr eq m1~matnr
*      inner join t001w as t1 on t1~werks eq m3~werks
*      inner join t001l as t2 on t2~lgort eq m3~lgort and t2~werks eq m3~werks
*      into corresponding fields of table gt_out
*      where m1~matnr in s_matnr
*        and m2~spras in s_spras.
*
*endform.
*
*form set_fc using p_fieldname
*                  p_seltext_s
*                  p_seltext_m
*                  p_seltext_l.
*
*  clear: gs_fieldcatalog.
*  gs_fieldcatalog-fieldname = p_fieldname.
*  gs_fieldcatalog-seltext_s = p_seltext_s.
*  gs_fieldcatalog-seltext_m = p_seltext_m.
*  gs_fieldcatalog-seltext_l = p_seltext_l.
*  append gs_fieldcatalog to gt_fieldcatalog.
*
*endform.
