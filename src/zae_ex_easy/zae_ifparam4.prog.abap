*&---------------------------------------------------------------------*
*& Report ZAE_IFPARAM4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zae_ifparam4.

start-of-selection.

  parameters: gv_num1 type i,
              gv_num2 type i,
              gv_num3 type i.

  if ( gv_num1 > gv_num2 and gv_num1 < gv_num3 ) or ( gv_num1 > gv_num3 and gv_num1 < gv_num2 ).
    write: 'Birinci sayı diğer iki sayının ortasındadır.'.
  elseif ( gv_num2 > gv_num1 and gv_num2 < gv_num3 ) or ( gv_num2 > gv_num3 and gv_num2 < gv_num1 ).
    write: 'İkinci sayı diğer iki sayının ortasındadır.'.
  elseif ( gv_num3 > gv_num1 and gv_num3 < gv_num2 ) or ( gv_num3 < gv_num1 and gv_num3 > gv_num2 ).
    write: 'Üçüncü sayı diğer iki sayının ortasındadır.'.
  elseif gv_num1 = gv_num2 or gv_num1 = gv_num3 or gv_num2 = gv_num3.
    message 'sayılar birbirine eşit olmamalı' type 'I'.
  else.
    message 'ne yapmaya çalıştığını çözemedik' type 'I'.
  endif.
