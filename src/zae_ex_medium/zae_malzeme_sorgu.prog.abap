*&---------------------------------------------------------------------*
*& Report ZAE_MALZEME_SORGU
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zae_malzeme_sorgu.

types: begin of ty_out,
         matnr type zaemg_matnr-matnr,
         durum type zaemg_matnr-durum,
       end of ty_out.

data: lt_data   type table of ty_out,
      lt_return type table of ty_out,
      ls_data   type ty_out,
      lo_salv   type ref to cl_salv_table. "for CL_SALV

data: begin of so,
        matnr type mara-matnr,
      end of so.

selection-screen begin of block b1 with frame title text-101.

select-options: s_matnr for so-matnr.

selection-screen end of block b1.

start-of-selection.

  loop at s_matnr into data(ls_smatnr).

    call function 'ZAE_MALZEME_SORGU_FM'
      exporting
        iv_matnr = ls_smatnr-low
      tables
        et_data  = lt_return.

    move-corresponding lt_return to lt_data.

  endloop.

  try.
      call method cl_salv_table=>factory
        importing
          r_salv_table = lo_salv
        changing
          t_table      = lt_data.
    catch cx_salv_msg.
  endtry.

  " column optimize
  data: lo_columns type ref to cl_salv_columns_table.
  lo_columns = lo_salv->get_columns( ).
  lo_columns->set_optimize( 'X' ).

  lo_salv->display( ).
