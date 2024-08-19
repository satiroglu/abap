*&---------------------------------------------------------------------*
*& Report ZAE_CASEWHEN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zae_casewhen.

start-of-selection.

  data: gv_result type i.

  parameters: gv_num1 type i,
              gv_num2 type i,
              gv_opti type c.

  case gv_opti.
    when '+'.
      gv_result = gv_num1 + gv_num2.
    when '-'.
      gv_result = gv_num1 - gv_num2.
    when '*'.
      gv_result = gv_num1 * gv_num2.
    when '/'.
      gv_result = gv_num1 / gv_num2.
    when others.
  endcase.

  write: 'Sonuç:', gv_result.
