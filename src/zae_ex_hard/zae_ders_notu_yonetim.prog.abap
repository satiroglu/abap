*&---------------------------------------------------------------------*
*& Report ZAE_DERS_NOTU_YONETIM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zae_ders_notu_yonetim.

" işlem seçme ekranı
SELECTION-SCREEN BEGIN OF BLOCK b1.
PARAMETERS: r_select RADIOBUTTON GROUP g1,
            r_insert RADIOBUTTON GROUP g1,
            r_update RADIOBUTTON GROUP g1,
            r_delete RADIOBUTTON GROUP g1.
SELECTION-SCREEN END OF BLOCK b1.

" screen'de görüntülenecek objeler
DATA: ogrenci_id TYPE zae_ogrid_de,
      ogrenci_ad TYPE zae_ograd_de,
      ogrenci_sa TYPE zae_ogrsad_de,
      ders_id    TYPE zae_dersid_de,
      ders_ad    TYPE zae_dersad_de,
      ders_kredi TYPE zae_derskredi_de,
      puan       TYPE zae_puan_de.

*data: gt_ders type table of zae_ders_detay,
*      gs_ders type zae_ders_detay.

*data: gt_ders type vrm_values with header line,
*      gs_ders type vrm_value.

*select-options ders_id for zae_ders_detay-ders_id.
" işlem adı
DATA: islem_ad TYPE string.

" AVL
TYPES: BEGIN OF gty_list,
         ogrenci_id    TYPE zae_ogrnotlist-ogrenci_id,
         ogrenci_ad    TYPE zae_ogrnotlist-ogrenci_ad,
         ogrenci_soyad TYPE zae_ogrnotlist-ogrenci_soyad,
         ders_ad       TYPE zae_ders_detay-ders_ad,
         ders_kredi    TYPE zae_ders_detay-ders_kredi,
         puan          TYPE zae_ogrnotlist-puan,
       END OF gty_list.

DATA: gt_list TYPE TABLE OF gty_list,
      gs_list TYPE gty_list.

" field catalog tanımı
DATA: gt_fieldcatalog TYPE slis_t_fieldcat_alv,
      gs_fieldcatalog TYPE slis_fieldcat_alv.

" Layout tanımlaması
DATA: gs_layout TYPE slis_layout_alv.

START-OF-SELECTION.
  " screen çağır
  CALL SCREEN 0100.

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '100'.
  SET TITLEBAR '100'.
  LOOP AT SCREEN.
    IF r_select EQ 'X'. " select
      IF screen-name EQ 'OGRENCI_ID' OR screen-name EQ 'T_OGRENCI_ID'
        OR screen-name EQ 'OGRENCI_AD' OR screen-name EQ 'T_OGRENCI_AD'
        OR screen-name EQ 'OGRENCI_SA' OR screen-name EQ 'T_OGRENCI_SA'
        OR screen-name EQ 'DERS_ID' OR screen-name EQ 'T_DERS_ID'.
        screen-active = 0.
        islem_ad = 'Select'.
        MODIFY SCREEN.
      ENDIF.
    ELSEIF r_insert EQ 'X'. " insert
      islem_ad = 'Insert'.
      MODIFY SCREEN.
    ELSEIF r_update EQ 'X'. " update
      IF screen-name EQ 'PUAN' OR screen-name EQ 'T_PUAN'
        OR screen-name EQ 'DERS_ID' OR screen-name EQ 'T_DERS_ID'.
        screen-active = 0.
        islem_ad = 'Update'.
        MODIFY SCREEN.
      ENDIF.
    ELSEIF r_delete EQ 'X'. " delete
      IF screen-name EQ 'OGRENCI_AD' OR screen-name EQ 'T_OGRENCI_AD'
        OR screen-name EQ 'OGRENCI_SA' OR screen-name EQ 'T_OGRENCI_SA'
        OR screen-name EQ 'DERS_ID' OR screen-name EQ 'T_DERS_ID'
        OR screen-name EQ 'PUAN' OR screen-name EQ 'T_PUAN'.
        screen-active = 0.
        islem_ad = 'Delete'.
        MODIFY SCREEN.
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN '&BACK'.
      SET SCREEN 0.
    WHEN 'FCBTN'.
      IF r_select EQ 'X'.
        CLEAR gt_list.
        CLEAR gt_fieldcatalog.
        PERFORM frm_select USING puan.
      ELSEIF r_insert EQ 'X'.
        PERFORM frm_insert USING ogrenci_id
                                 ogrenci_ad
                                 ogrenci_sa
                                 ders_id
                                 puan.
      ELSEIF r_update EQ 'X'.
        PERFORM frm_update USING ogrenci_id
                                 ogrenci_ad
                                 ogrenci_sa.
      ELSEIF r_delete EQ 'X'.
        PERFORM frm_delete USING ogrenci_id.
      ENDIF.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM frm_select USING puan.
  SELECT
    ogr~ogrenci_id
    ogr~ogrenci_ad
    ogr~ogrenci_soyad
    ders~ders_ad
    ders~ders_kredi
    ogr~puan
    FROM zae_ogrnotlist AS ogr
    LEFT JOIN zae_ders_detay AS ders ON ders~ders_id EQ ogr~ders_id
    INTO TABLE gt_list
    WHERE ogr~puan GT puan.
  IF gt_list IS INITIAL.
    MESSAGE 'Seçtiğiniz kriterlerde kayıt bulunamadı.' TYPE 'I'.
  ELSE.
    " Layout özelliklerinin belirlenmesi.
    gs_layout-window_titlebar   = 'Öğrenci Raporu'. " başlığı günceller. normalde programın açıklaması yazar
    gs_layout-zebra             = abap_true. " zebra görüntüsü
    gs_layout-expand_all = abap_true. " bütün kolonları en geniş şekilde gösterir.
*    gs_layout-colwidth_optimize = abap_true. " kolonları optimize edilmiş şekilde gösterir
    " field catalog hazırla
    PERFORM: set_fc USING 'OGRENCI_ID' 'Öğr. ID' 'Öğrenci ID' 'Öğrenci ID' abap_true,
             set_fc USING 'OGRENCI_AD' 'Öğr. Ad' 'Öğrenci Ad' 'Öğrenci Ad' abap_false,
             set_fc USING 'OGRENCI_SOYAD' 'Öğr. S.Ad' 'Öğrenci Soyad' 'Öğrenci Soyad' abap_false,
             set_fc USING 'DERS_AD' 'Ders Ad' 'Ders Ad' 'Ders Ad' abap_false,
             set_fc USING 'DERS_KREDI' 'Ders Kredi' 'Ders Kredi' 'Ders Kredi' abap_false,
             set_fc USING 'PUAN' 'Puan' 'Puan' 'Puan' abap_false.
    " ALV'yi göster
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        is_layout   = gs_layout
        it_fieldcat = gt_fieldcatalog
      TABLES
        t_outtab    = gt_list.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_INSERT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM frm_insert
  USING p_ogrenci_id
        p_ogrenci_ad
        p_ogrenci_sa
        p_ders_id
        p_puan.
  " bütün alanlar boş mu dolu mu? boş ise uyarı ver.
  IF p_ogrenci_id EQ ''
    OR p_ogrenci_ad EQ ''
    OR p_ogrenci_sa EQ ''
    OR p_ders_id EQ ''
    OR p_puan EQ ''.
    MESSAGE 'Lütfen Öğrenci ID, Öğrenci Ad, Öğrenci Soyad, Ders ID ve Puan alanlarınız doldurunuz.' TYPE 'I'.
  ELSE.
    " alanlar boş değilse insert işlemini yap.
    " girilen ID'ye ait öğrenci var mı?
    SELECT ogrenci_id
      FROM zae_ogrnotlist
      INTO TABLE @DATA(itabin)
      WHERE ogrenci_id EQ @p_ogrenci_id.
    IF itabin IS NOT INITIAL.
      MESSAGE 'Belirttiğiniz IDye ait öğrenci bulunuyor. Lütfen yeni ID belirleyiniz.' TYPE 'I'.
      CLEAR p_ogrenci_id.
    ELSE.
      " eğer he şey ok ise ekleme işlemini gerçekleştir.
      INSERT zae_ogrnotlist FROM @( VALUE #(  ogrenci_id    = p_ogrenci_id
                                              ogrenci_ad    = p_ogrenci_ad
                                              ogrenci_soyad = p_ogrenci_sa
                                              ders_id       = p_ders_id
                                              puan          = p_puan
                                          ) ).
      IF sy-subrc EQ 0.
        MESSAGE 'Insert işlemi başarılı.' TYPE 'I'.
        SET SCREEN 0.
      ELSEIF sy-subrc NE 0.
        MESSAGE 'Insert işlemi sırasında hata!' TYPE 'I'.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_UPDATE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM frm_update
  USING p_ogrenci_id
        p_ogrenci_ad
        p_ogrenci_sa.
  IF p_ogrenci_id EQ '' OR p_ogrenci_ad EQ '' OR p_ogrenci_sa EQ ''.
    MESSAGE 'Lütfen Öğrenci ID, Öğrenci Ad ve Öğrenci Soyad alanlarınız doldurunuz.' TYPE 'I'.
  ELSE.
    SELECT *
     FROM zae_ogrnotlist
     INTO TABLE @DATA(itabupt)
     WHERE ogrenci_id EQ @p_ogrenci_id.
    IF itabupt IS INITIAL.
      MESSAGE 'Belirttiğiniz IDye ait öğrenci bulunuyor. Lütfen yeni ID belirleyiniz.' TYPE 'I'.
      CLEAR p_ogrenci_id.
    ELSE.
      UPDATE zae_ogrnotlist SET ogrenci_ad = p_ogrenci_ad
                             ogrenci_soyad = p_ogrenci_sa
                             WHERE ogrenci_id = ogrenci_id.
      IF sy-subrc EQ 0.
        MESSAGE 'Update işlemi başarılı.' TYPE 'I'.
        SET SCREEN 0.
      ELSEIF sy-subrc NE 0.
        MESSAGE 'Update işlemi sırasında hata!' TYPE 'I'.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_DELETE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM frm_delete USING p_ogrenci_id.
  IF p_ogrenci_id IS INITIAL.
    MESSAGE 'Öğrenci ID alanını doldurmadan işlem yapamazsınız.' TYPE 'I'.
  ELSE.
    " girilen ID'ye ait öğrenci var mı?
    SELECT ogrenci_id
      FROM zae_ogrnotlist
      INTO TABLE @DATA(itabde)
      WHERE ogrenci_id EQ @p_ogrenci_id.
    IF itabde IS INITIAL.
      MESSAGE 'Yazdığınız IDye ait öğrenci bulunamadı!' TYPE 'I'.
    ELSE.
      " delete işlemi
      DELETE FROM zae_ogrnotlist WHERE ogrenci_id EQ p_ogrenci_id.
      IF sy-subrc EQ 0.
        MESSAGE 'Silme işlemi başarılı.' TYPE 'I'.
        SET SCREEN 0.
      ELSEIF sy-subrc NE 0.
        MESSAGE 'Silme işlemi sırasında hata!' TYPE 'I'.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FC
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fc
USING p_fieldname
      p_seltext_s
      p_seltext_m
      p_seltext_l
      p_key.

  CLEAR: gs_fieldcatalog.
  gs_fieldcatalog-fieldname = p_fieldname.
  gs_fieldcatalog-seltext_s = p_seltext_s.
  gs_fieldcatalog-seltext_m = p_seltext_m.
  gs_fieldcatalog-seltext_l = p_seltext_l.
  gs_fieldcatalog-key       = p_key.
  APPEND gs_fieldcatalog TO gt_fieldcatalog.
ENDFORM.
