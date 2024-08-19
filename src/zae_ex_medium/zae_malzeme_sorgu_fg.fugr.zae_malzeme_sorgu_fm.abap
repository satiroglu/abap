function zae_malzeme_sorgu_fm.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_MATNR) TYPE  MARA-MATNR
*"  TABLES
*"      ET_DATA STRUCTURE  ZAEMG_MATNR
*"----------------------------------------------------------------------

*    into corresponding fields of table @et_data

  data: ls_data like line of et_data, " like line of: structure,
        it_data like table of et_data. " like table of: internal table

  select matnr
    from mara
    into corresponding fields of table @it_data
    where matnr eq @iv_matnr.

*  if sy-subrc eq 0.
  if it_data is not initial.
    " girilen matnr mara tablosunda varsa
    ls_data-matnr = iv_matnr.
    ls_data-durum = 'VAR'.

  else.
    " girilen matnr mara tablosunda yoksa
    ls_data-matnr = iv_matnr.
    ls_data-durum = 'YOK'.

  endif.

  append ls_data to et_data.
  clear: ls_data.

endfunction.
