*&---------------------------------------------------------------------*
*& Report ZAE_SEARCH_HELP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zae_search_help.

tables: zae_personel.

selection-screen begin of block b1 with frame title text-100.
select-options: s_persid for zae_personel-personel_id . " no intervals no-extension
selection-screen end of block b1.

start-of-selection.
