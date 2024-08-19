*&---------------------------------------------------------------------*
*& Report ZAE_DERS_NOTU_YONETIM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zae_ders_notu_yonetim.

" işlem seçme ekranı
selection-screen begin of block b1.
parameters: r_select radiobutton group g1,
            r_insert radiobutton group g1,
            r_update radiobutton group g1,
            r_delete radiobutton group g1.
selection-screen end of block b1.

" screen'de görüntülenecek objeler
data: ogrenci_id type zae_ogrid_de,
      ogrenci_ad type zae_ograd_de,
      ogrenci_sa type zae_ogrsad_de,
      ders_id    type zae_dersid_de,
      ders_ad    type zae_dersad_de,
      ders_kredi type zae_derskredi_de,
      puan       type zae_puan_de.

*data: gt_ders type table of zae_ders_detay,
*      gs_ders type zae_ders_detay.

*data: gt_ders type vrm_values with header line,
*      gs_ders type vrm_value.

*select-options ders_id for zae_ders_detay-ders_id.
" işlem adı
data: islem_ad type string.

" AVL
types: begin of gty_list,
         ogrenci_id    type zae_ogrnotlist-ogrenci_id,
         ogrenci_ad    type zae_ogrnotlist-ogrenci_ad,
         ogrenci_soyad type zae_ogrnotlist-ogrenci_soyad,
         ders_ad       type zae_ders_detay-ders_ad,
         ders_kredi    type zae_ders_detay-ders_kredi,
         puan          type zae_ogrnotlist-puan,
       end of gty_list.

data: gt_list type table of gty_list,
      gs_list type gty_list.

" field catalog tanımı
data: gt_fieldcatalog type slis_t_fieldcat_alv,
      gs_fieldcatalog type slis_fieldcat_alv.

" Layout tanımlaması
data: gs_layout type slis_layout_alv.

start-of-selection.
  " screen çağır
  call screen 0100.

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
module status_0100 output.
  set pf-status '100'.
  set titlebar '100'.
  loop at screen.
    if r_select eq 'X'. " select
      if screen-name eq 'OGRENCI_ID' or screen-name eq 'T_OGRENCI_ID'
        or screen-name eq 'OGRENCI_AD' or screen-name eq 'T_OGRENCI_AD'
        or screen-name eq 'OGRENCI_SA' or screen-name eq 'T_OGRENCI_SA'
        or screen-name eq 'DERS_ID' or screen-name eq 'T_DERS_ID'.
        screen-active = 0.
        islem_ad = 'Select'.
        modify screen.
      endif.
    elseif r_insert eq 'X'. " insert
      islem_ad = 'Insert'.
      modify screen.
    elseif r_update eq 'X'. " update
      if screen-name eq 'PUAN' or screen-name eq 'T_PUAN'
        or screen-name eq 'DERS_ID' or screen-name eq 'T_DERS_ID'.
        screen-active = 0.
        islem_ad = 'Update'.
        modify screen.
      endif.
    elseif r_delete eq 'X'. " delete
      if screen-name eq 'OGRENCI_AD' or screen-name eq 'T_OGRENCI_AD'
        or screen-name eq 'OGRENCI_SA' or screen-name eq 'T_OGRENCI_SA'
        or screen-name eq 'DERS_ID' or screen-name eq 'T_DERS_ID'
        or screen-name eq 'PUAN' or screen-name eq 'T_PUAN'.
        screen-active = 0.
        islem_ad = 'Delete'.
        modify screen.
      endif.
    endif.
  endloop.
endmodule.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_0100 input.
  case sy-ucomm.
    when '&BACK'.
      set screen 0.
    when 'FCBTN'.
      if r_select eq 'X'.
        clear gt_list.
        clear gt_fieldcatalog.
        perform frm_select using puan.
      elseif r_insert eq 'X'.
        perform frm_insert using ogrenci_id
                                 ogrenci_ad
                                 ogrenci_sa
                                 ders_id
                                 puan.
      elseif r_update eq 'X'.
        perform frm_update using ogrenci_id
                                 ogrenci_ad
                                 ogrenci_sa.
      elseif r_delete eq 'X'.
        perform frm_delete using ogrenci_id.
      endif.
  endcase.
endmodule.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form frm_select using puan.
  select
    ogr~ogrenci_id
    ogr~ogrenci_ad
    ogr~ogrenci_soyad
    ders~ders_ad
    ders~ders_kredi
    ogr~puan
    from zae_ogrnotlist as ogr
    left join zae_ders_detay as ders on ders~ders_id eq ogr~ders_id
    into table gt_list
    where ogr~puan gt puan.
  if gt_list is initial.
    message 'Seçtiğiniz kriterlerde kayıt bulunamadı.' type 'I'.
  else.
    " Layout özelliklerinin belirlenmesi.
    gs_layout-window_titlebar   = 'Öğrenci Raporu'. " başlığı günceller. normalde programın açıklaması yazar
    gs_layout-zebra             = abap_true. " zebra görüntüsü
    gs_layout-expand_all = abap_true. " bütün kolonları en geniş şekilde gösterir.
*    gs_layout-colwidth_optimize = abap_true. " kolonları optimize edilmiş şekilde gösterir
    " field catalog hazırla
    perform: set_fc using 'OGRENCI_ID' 'Öğr. ID' 'Öğrenci ID' 'Öğrenci ID' abap_true,
             set_fc using 'OGRENCI_AD' 'Öğr. Ad' 'Öğrenci Ad' 'Öğrenci Ad' abap_false,
             set_fc using 'OGRENCI_SOYAD' 'Öğr. S.Ad' 'Öğrenci Soyad' 'Öğrenci Soyad' abap_false,
             set_fc using 'DERS_AD' 'Ders Ad' 'Ders Ad' 'Ders Ad' abap_false,
             set_fc using 'DERS_KREDI' 'Ders Kredi' 'Ders Kredi' 'Ders Kredi' abap_false,
             set_fc using 'PUAN' 'Puan' 'Puan' 'Puan' abap_false.
    " ALV'yi göster
    call function 'REUSE_ALV_GRID_DISPLAY'
      exporting
        is_layout   = gs_layout
        it_fieldcat = gt_fieldcatalog
      tables
        t_outtab    = gt_list.
  endif.
endform.
*&---------------------------------------------------------------------*
*& Form FRM_INSERT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form frm_insert
  using p_ogrenci_id
        p_ogrenci_ad
        p_ogrenci_sa
        p_ders_id
        p_puan.
  " bütün alanlar boş mu dolu mu? boş ise uyarı ver.
  if p_ogrenci_id eq ''
    or p_ogrenci_ad eq ''
    or p_ogrenci_sa eq ''
    or p_ders_id eq ''
    or p_puan eq ''.
    message 'Lütfen Öğrenci ID, Öğrenci Ad, Öğrenci Soyad, Ders ID ve Puan alanlarınız doldurunuz.' type 'I'.
  else.
    " alanlar boş değilse insert işlemini yap.
    " girilen ID'ye ait öğrenci var mı?
    select ogrenci_id
      from zae_ogrnotlist
      into table @data(itabin)
      where ogrenci_id eq @p_ogrenci_id.
    if itabin is not initial.
      message 'Belirttiğiniz IDye ait öğrenci bulunuyor. Lütfen yeni ID belirleyiniz.' type 'I'.
      clear p_ogrenci_id.
    else.
      " eğer he şey ok ise ekleme işlemini gerçekleştir.
      insert zae_ogrnotlist from @( value #(  ogrenci_id    = p_ogrenci_id
                                              ogrenci_ad    = p_ogrenci_ad
                                              ogrenci_soyad = p_ogrenci_sa
                                              ders_id       = p_ders_id
                                              puan          = p_puan
                                          ) ).
      if sy-subrc eq 0.
        message 'Insert işlemi başarılı.' type 'I'.
        set screen 0.
      elseif sy-subrc ne 0.
        message 'Insert işlemi sırasında hata!' type 'I'.
      endif.
    endif.
  endif.
endform.
*&---------------------------------------------------------------------*
*& Form FRM_UPDATE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form frm_update
  using p_ogrenci_id
        p_ogrenci_ad
        p_ogrenci_sa.
  if p_ogrenci_id eq '' or p_ogrenci_ad eq '' or p_ogrenci_sa eq ''.
    message 'Lütfen Öğrenci ID, Öğrenci Ad ve Öğrenci Soyad alanlarınız doldurunuz.' type 'I'.
  else.
    select *
     from zae_ogrnotlist
     into table @data(itabupt)
     where ogrenci_id eq @p_ogrenci_id.
    if itabupt is initial.
      message 'Belirttiğiniz IDye ait öğrenci bulunuyor. Lütfen yeni ID belirleyiniz.' type 'I'.
      clear p_ogrenci_id.
    else.
      update zae_ogrnotlist set ogrenci_ad = p_ogrenci_ad
                             ogrenci_soyad = p_ogrenci_sa
                             where ogrenci_id = ogrenci_id.
      if sy-subrc eq 0.
        message 'Update işlemi başarılı.' type 'I'.
        set screen 0.
      elseif sy-subrc ne 0.
        message 'Update işlemi sırasında hata!' type 'I'.
      endif.
    endif.
  endif.
endform.
*&---------------------------------------------------------------------*
*& Form FRM_DELETE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form frm_delete using p_ogrenci_id.
  if p_ogrenci_id is initial.
    message 'Öğrenci ID alanını doldurmadan işlem yapamazsınız.' type 'I'.
  else.
    " girilen ID'ye ait öğrenci var mı?
    select ogrenci_id
      from zae_ogrnotlist
      into table @data(itabde)
      where ogrenci_id eq @p_ogrenci_id.
    if itabde is initial.
      message 'Yazdığınız IDye ait öğrenci bulunamadı!' type 'I'.
    else.
      " delete işlemi
      delete from zae_ogrnotlist where ogrenci_id eq p_ogrenci_id.
      if sy-subrc eq 0.
        message 'Silme işlemi başarılı.' type 'I'.
        set screen 0.
      elseif sy-subrc ne 0.
        message 'Silme işlemi sırasında hata!' type 'I'.
      endif.
    endif.
  endif.
endform.
*&---------------------------------------------------------------------*
*& Form SET_FC
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form set_fc
using p_fieldname
      p_seltext_s
      p_seltext_m
      p_seltext_l
      p_key.

  clear: gs_fieldcatalog.
  gs_fieldcatalog-fieldname = p_fieldname.
  gs_fieldcatalog-seltext_s = p_seltext_s.
  gs_fieldcatalog-seltext_m = p_seltext_m.
  gs_fieldcatalog-seltext_l = p_seltext_l.
  gs_fieldcatalog-key       = p_key.
  append gs_fieldcatalog to gt_fieldcatalog.
endform.