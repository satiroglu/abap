*&---------------------------------------------------------------------*
*& Report ZAE_FORM1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zae_form1.

start-of-selection.

  data: gv_result type p decimals 2.

  parameters: gv_num1 type i,
              gv_num2 type i.

  if ( gv_num1 eq 0 ) or ( gv_num2 eq 0 ) .
    message 'Sayılardan hiçbiri sıfır (0) olamaz!' type 'I'.
  elseif ( gv_num1 > gv_num2 ) or ( gv_num2 > gv_num1 ).
    perform  iki_sayinin_orani.
  elseif gv_num1 eq gv_num2.
    message 'Sayılar birbirine eşit olamaz!' type 'I'.
  else.
    message 'ne yapmaya çalıştığınız anlayamadık!' type 'I'.
  endif.

*&---------------------------------------------------------------------*
*& Form IKI_SAYININ_ORANI
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form iki_sayinin_orani.
  if gv_num1 > gv_num2.
    gv_result = gv_num1 / gv_num2.
    write: gv_num1, '/', gv_num2, '=', gv_result.
  elseif gv_num2 > gv_num1.
    gv_result = gv_num2 / gv_num1.
    write: gv_num2, '/', gv_num1, '=', gv_result.
  endif.
endform.
