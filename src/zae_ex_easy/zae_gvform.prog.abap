**&---------------------------------------------------------------------*
**& Report ZAE_GVFORM
**&---------------------------------------------------------------------*
**&
**&---------------------------------------------------------------------*

report zae_gvform.

data: gv_num     type i,
      gv_result  type i.

gv_num     = 10.

start-of-selection.

  perform f_3lecarp.
  perform f_3lecarp.
  perform f_7ekle.
  perform f_7ekle.
  perform f_4cikar.
  perform f_2yebol.
  perform f_4cikar.
  perform f_4cikar.

  gv_result = gv_num.

  write: gv_result.

*&---------------------------------------------------------------------*
*& Form F_7EKLE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form f_7ekle.
  gv_num = gv_num + 7.
endform.
*&---------------------------------------------------------------------*
*& Form F_4CIKAR
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form f_4cikar .
  gv_num = gv_num - 4.
endform.
*&---------------------------------------------------------------------*
*& Form F_2YEBOL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form f_2yebol .
  gv_num = gv_num / 2.
endform.
*&---------------------------------------------------------------------*
*& Form F_3LECARP
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form f_3lecarp .
  gv_num = gv_num * 3.
endform.
