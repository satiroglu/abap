*&---------------------------------------------------------------------*
*& Report ZAE_CL_ILILCE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zae_cl_ililce.

include zae_cl_ililce_top.
include zae_cl_ililce_cls.

initialization.
  gr_main = new #( ).

start-of-selection.

  gr_main->get_data( ).
  gr_main->set_dtable( ).
  gr_main->display_data( ).
