*&---------------------------------------------------------------------*
*& Report ZAE_SMF_SERVIS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zae_smf_servis.

tables: zae_sastab.

types: begin of ty_list,
         ebeln type zae_sastab-ebeln,
         mblnr type zae_maltab-mblnr,
         mjahr type zae_maltab-mjahr,
         belnr type zae_fattab-belnr,
         gjahr type zae_fattab-gjahr,
         durum type char200,
       end of ty_list.

data: gs_out   type ty_list,
      gt_out   type standard table of ty_list,
      gv_durum type string.


data: gt_outtab type table of mara.
data: salv_table type ref to   cl_salv_table.

" ALV kolonları
data lr_columns type ref to cl_salv_columns_table.

" malzeme numarası seç
selection-screen begin of block b1 with frame title text-100.
select-options: s_ebeln for zae_sastab-ebeln no intervals.
selection-screen end of block b1.

start-of-selection.


  call function 'ZAE_SMF_FM'
    exporting
      i_ebeln = s_ebeln.
*    importing
*      e_ebeln = s_ebeln
*      e_mblnr = ''
*      e_mjahr = ''
*      e_belnr = ''
*      e_gjahr = ''
*      durum   = ''.


* ALV'yi oluştur
  call method cl_salv_table=>factory
    exporting
      list_display = if_salv_c_bool_sap=>false
    importing
      r_salv_table = salv_table
    changing
      t_table      = gt_outtab.

end-of-selection.
  lr_columns = salv_table->get_columns( ).
  lr_columns->set_optimize( 'X' ).
  salv_table->display( ).
