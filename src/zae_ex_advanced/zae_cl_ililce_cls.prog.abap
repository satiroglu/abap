*&---------------------------------------------------------------------*
*& Include          ZAE_CL_ILILCE_CLS
*&---------------------------------------------------------------------*

class lcl_main implementation.

  method get_data.

    select
      il_kodu
      il_tanim
      from zil_liste
      into table gt_il.

    select
      eslestir~il_kodu_e
      il~il_tanim
      eslestir~ilce_kodu_e
      ilce~ilce_tanim
      from zililce_eslestir as eslestir
      inner join zil_liste as il on il~il_kodu eq eslestir~il_kodu_e
      inner join zilce_liste as ilce on ilce~ilce_kodu eq eslestir~ilce_kodu_e
      into table gt_eslesme.

    types: begin of ty_itab,
             ilkodu    type char2,
             iltanim   type char30,
             ilcekkodu type char4,
             ilcetanim type char30,
           end of ty_itab.

    types: begin of ty_count,
             iltanim type char30,
             count   type i,
           end of ty_count.

    data lt_count type table of ty_count with key iltanim.
    data ls_count type ty_count.

    loop at gt_eslesme assigning field-symbol(<ls_itab>).
      ls_count-iltanim   = <ls_itab>-iltanim.
      ls_count-count     = 1.
      collect ls_count into lt_count.
    endloop.

    sort lt_count by count descending.
    lv_max_ilce_sayisi = lt_count[ 1 ]-count.

  endmethod.

  method set_dtable.

    data: it_fldcat type lvc_t_fcat,
          wa_fldcat type lvc_s_fcat.

    try.
        cl_salv_table=>factory(
          importing
            r_salv_table   = data(lo_temp_alv)
          changing
            t_table        = gt_il
        ).
      catch cx_root.
    endtry.

    it_fldcat = cl_salv_controller_metadata=>get_lvc_fieldcatalog(
        r_columns            = lo_temp_alv->get_columns( )
        r_aggregations       = lo_temp_alv->get_aggregations( ) ).

    data(lv_noc) = 2.
    data: lvcon type i.

    do lv_max_ilce_sayisi times.

      clear :  wa_fldcat-datatype, wa_fldcat-fieldname.

      wa_fldcat-col_pos = lv_noc + 1.
      lvcon = lvcon + 1.
      wa_fldcat-fieldname = 'ILCE' && lvcon. " && sy-tabix.
*      concatenate 'ILCE' gs_ilce-ilcekodu into wa_fldcat-fieldname.
      wa_fldcat-datatype  = 'CHAR30'.
      append wa_fldcat to it_fldcat .

    enddo.

    call method cl_alv_table_create=>create_dynamic_table
      exporting
        it_fieldcatalog = it_fldcat
      importing
        ep_table        = dyn_table_ref.

    field-symbols: <dyn_table> type standard table,
                   <dyn_line>  type data,
                   <fs_ilkodu> type zil_kodu,
                   <ilce>      type char30.

    assign dyn_table_ref->* to <dyn_table>.

    move-corresponding gt_il to <dyn_table>.
    data: gv_count type i.
    loop at <dyn_table> assigning <dyn_line>.

      assign component 'ILKODU' of structure <dyn_line> to <fs_ilkodu>.
      gv_count = 0.
      loop at gt_eslesme into gs_eslesme where ilkodu eq <fs_ilkodu>.

        gv_count = gv_count + 1.
        data(lv_fieldname) =  'ILCE' && gv_count. "&&
        assign component lv_fieldname of structure <dyn_line> to <ilce>.
        <ilce> = gs_eslesme-ilcetanim.

      endloop.

    endloop.

  endmethod.


  method display_data.

    field-symbols: <dyn_table> type standard table.
    assign dyn_table_ref->* to <dyn_table>.
    "ALV çoklu seçim
    data: lr_selections type ref to cl_salv_selections.

    try.
        cl_salv_table=>factory( exporting r_container  = cl_gui_container=>screen0
                                importing r_salv_table = go_alv
                                changing  t_table      = <dyn_table> ).

        "Tüm butonları aktifleştir
        go_alv->get_functions( )->set_all( ).

        "Çizgili görünüm
        go_alv->get_display_settings( )->set_striped_pattern( abap_true ).

        "Düzen ayarları
        data(lo_layout) = go_alv->get_layout( ).
        lo_layout->set_key( value #( report = sy-repid ) ).
        lo_layout->set_save_restriction( if_salv_c_layout=>restrict_none ).
        lo_layout->set_default( abap_true ).

        "Sıralamalar
        data(lo_sorts) = go_alv->get_sorts( ).
        lo_sorts->add_sort( columnname = 'ILKODU'
                            sequence   = if_salv_c_sort=>sort_up ).

        "Sütun ayarları
        data(lo_columns) = go_alv->get_columns( ).
        lo_columns->set_optimize( ).
        lo_columns->set_key_fixation( ).

        " ALV'de çoklu seçim
        lr_selections = go_alv->get_selections( ).
        lr_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).

        "Sütun başlıklarını değiştir
        set_column_title( name = 'ILKODU'   title = 'İl Kodu' ).
        set_column_title( name = 'ILTANIM'   title = 'İl Tanım' ).

        "   ALV'de kolon  başlıkları ekleme
        data: gvlcon type i.
        do lv_max_ilce_sayisi times.
          gvlcon = gvlcon + 1.
          data(lv_fname) =  'ILCE' && gvlcon.
          concatenate 'İlçe' ' Tanım' into data(lv_ftitle).
          set_column_title( name = conv #( lv_fname )   title = conv #( lv_ftitle ) ).
        enddo.


        loop at lo_columns->get( ) reference into data(ls_columns).
          data(lo_column) = cast cl_salv_column_table( ls_columns->r_column ).

          " ALV'de sıfır(0) olan değerleri göstermeme.
          lo_column->set_zero( abap_false ).

        endloop.

        "Görüntüle
        go_alv->display( ).

        cl_abap_list_layout=>suppress_toolbar( ).
        write space.

      catch cx_salv_error into data(lx_salv).
        message lx_salv type 'I' display like 'E'.
    endtry.

  endmethod.

  method set_column_title.

    "Sütunun başlığını değiştir
    data(lo_column) = go_alv->get_columns( )->get_column( name ).
    lo_column->set_short_text(  conv #( title ) ).
    lo_column->set_medium_text( conv #( title ) ).
    lo_column->set_long_text( title ).
    lo_column->set_fixed_header_text( 'L' ). " S, M ya da L yazılabilir.

  endmethod.


endclass.
