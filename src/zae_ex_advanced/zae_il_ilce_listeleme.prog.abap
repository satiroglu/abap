*&---------------------------------------------------------------------*
*& Report ZAE_IL_ILCE_LISTELEME
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zae_il_ilce_listeleme.


include zae_il_ilce_listeleme_top.
include zae_il_ilce_listeleme_frm.


start-of-selection.

  perform  get_data.
  perform  set_fcat.
  perform  set_layout.
  perform  display_alv.
