*&---------------------------------------------------------------------*
*& Include          ZAE_CL_ILILCE_TOP
*&---------------------------------------------------------------------*

class lcl_main definition.

  public section.

    data go_alv type ref to cl_salv_table.

    types: begin of ty_eslesme,
             ilkodu    type zil_kodu,
             iltanim   type zil_tanim,
             ilcekodu  type zilce_kodu,
             ilcetanim type zilce_tanim,
           end of ty_eslesme.

    data: gt_eslesme type table of ty_eslesme,
          gs_eslesme type ty_eslesme.

    types: begin of ty_il,
             ilkodu  type zil_kodu,
             iltanim type zil_tanim,
           end of ty_il.

    data: gt_il type table of ty_il,
          gs_il type ty_il.

    types: begin of ty_ilce,
             ilcekodu  type zilce_kodu,
             ilcetanim type zilce_tanim,
           end of ty_ilce.

    data: gt_ilce type table of ty_ilce,
          gs_ilce type ty_ilce.

    types: begin of ty_eslestir,
             ilkodu   type zil_kodu,
             ilcekodu type zilce_kodu,
           end of ty_eslestir.

    data: gt_eslestir type table of ty_eslestir,
          gs_eslestir type ty_eslestir.

    data : dyn_table_ref type ref to data.

    data: lv_max_ilce_sayisi type i.

    methods get_data.
    methods set_dtable.
    methods display_data.


  private section.

    methods set_column_title
      importing
        !name  type lvc_fname
        !title type scrtext_l
      raising
        cx_salv_not_found.

endclass.

data gr_main type ref to lcl_main.
