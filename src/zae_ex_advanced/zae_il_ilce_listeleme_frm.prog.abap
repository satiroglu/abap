*&---------------------------------------------------------------------*
*& Include          ZAE_IL_ILCE_LISTELEME_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form get_data .
  select
    es~il_kodu_e
    il~il_tanim
    es~ilce_kodu_e
    ilce~ilce_tanim
    from zililce_eslestir as es
    inner join zil_liste as il on il~il_kodu eq es~il_kodu_e
    inner join zilce_liste as ilce on ilce~ilce_kodu eq es~ilce_kodu_e
    into table gt_list.

  describe table gt_list lines gv_col_count kind gs_list-ilce_kodu.

*  gv_col_count = lines( gt_list ). " gt_list içindeki satıları sayıp gv_count a yolla
  sort gt_list by il_kodu ascending. "gt_list 'i il koduna göre artan şekilde sırala
  delete adjacent duplicates from gt_list comparing il_kodu. " gt_list de il koduna göre duplicate olanları sil
endform.
*&---------------------------------------------------------------------*
*& Form SET_FCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form set_fcat .


  perform: set_fcat_field using 'IL_KODU' 'İlçe Kodu' 'İlçe Kodu' 'İlçe Kodu' abap_true '0',
           set_fcat_field using 'IL_TANIM' 'İlçe Tanım' 'İlçe Tanım' 'İlçe Tanım' '' '1'.

endform.
*&---------------------------------------------------------------------*
*& Form SET_FCAT_FIELD
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> ABAP_TRUE
*&      --> P_
*&---------------------------------------------------------------------*
form set_fcat_field  using p_fieldname
                           p_seltext_s
                           p_seltext_m
                           p_seltext_l
                           p_key
                           p_col_pos.
  clear: gs_fieldcatalog.
  gs_fieldcatalog-fieldname = p_fieldname.
  gs_fieldcatalog-seltext_s = p_seltext_s.
  gs_fieldcatalog-seltext_m = p_seltext_m.
  gs_fieldcatalog-seltext_l = p_seltext_l.
  gs_fieldcatalog-key       = p_key.
  gs_fieldcatalog-col_pos   = p_col_pos.
  append gs_fieldcatalog to gt_fieldcatalog.







endform.
*&---------------------------------------------------------------------*
*& Form SET_LAYOUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form set_layout .
  " Layout(alv başlık, tablo zebra hali vs) ayarları
  gs_layout-window_titlebar   = 'İl/İlçe Eşleştirme Listesi'. " başlığı günceller. normalde programın açıklaması yazar
  gs_layout-zebra             = abap_true. " zebra görüntüsü
  gs_layout-expand_all        = abap_true. " bütün alanları geniş gösterir.
endform.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form display_alv .


*  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
*    EXPORTING
*      i_buffer_active        = 'X'
*      i_structure_name       = 'ZMM_S_KRITIGE_DUSEN_V3'
*      i_client_never_display = 'X'
*      i_bypassing_buffer     = 'X'
*    CHANGING
*      ct_fieldcat            = gt_dyn_itab_fcat.


*call function 'LVC_FIELDCATALOG_MERGE'
* EXPORTING
*   I_BUFFER_ACTIVE              = 'X'
*   I_STRUCTURE_NAME             = 'GS_LIST'
*   I_CLIENT_NEVER_DISPLAY       = 'X'
*   I_BYPASSING_BUFFER           = 'X'
*   I_INTERNAL_TABNAME           = gt_list
*  changing
*    ct_fieldcat                  = gt_fieldcatalog.

if sy-subrc <> 0.
* Implement suitable error handling here
endif.



  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
      is_layout   = gs_layout
      it_fieldcat = gt_fieldcatalog
    tables
      t_outtab    = gt_list.
endform.
