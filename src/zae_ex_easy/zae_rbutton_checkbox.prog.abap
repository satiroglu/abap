*&---------------------------------------------------------------------*
*& Report ZAE_RBUTTON_CHECKBOX
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zae_rbutton_checkbox.

data gv_result type i.

selection-screen begin of block numbers with frame title text-100.
parameters: p_num1 type i,
            p_num2 type i.
selection-screen end of block numbers.

selection-screen begin of block options1 with frame title text-101.
parameters: p_add  radiobutton group rad,
            p_sub  radiobutton group rad,
            p_mult radiobutton group rad,
            p_div  radiobutton group rad.
selection-screen end of block options1.

selection-screen begin of block options2 with frame title text-102.
parameters: p_mult10 as checkbox,
            p_div2   as checkbox.
selection-screen end of block options2.

SELECTION-SCREEN BEGIN OF BLOCK options3 WITH FRAME TITLE text-103.
PARAMETERS: p_albeni as CHECKBOX.
SELECTION-SCREEN END OF BLOCK options3.

start-of-selection.

  if p_mult10 eq 'X' and p_div2 eq space.
    if p_add eq 'X'.
      perform f_add.
    elseif p_sub eq 'X'.
      perform f_sub.
    elseif p_mult eq 'X'.
      perform f_mult.
    elseif p_div eq 'X'.
      perform f_div.
    endif.
    gv_result = gv_result * 10.
  elseif p_div2 eq 'X' and p_mult10 eq space.
    if p_add eq 'X'.
      perform f_add.
    elseif p_sub eq 'X'.
      perform f_sub.
    elseif p_mult eq 'X'.
      perform f_mult.
    elseif p_div eq 'X'.
      perform f_div.
    endif.
    gv_result = gv_result / 2.
  elseif p_mult10 eq 'X' and p_div2 eq 'X'.
    if p_add eq 'X'.
      perform f_add.
    elseif p_sub eq 'X'.
      perform f_sub.
    elseif p_mult eq 'X'.
      perform f_mult.
    elseif p_div eq 'X'.
      perform f_div.
    endif.
    gv_result = ( gv_result * 10 ) / 2.
  elseif p_div2 eq space and p_mult10 eq space.
    if p_add eq 'X'.
      perform f_add.
    elseif p_sub eq 'X'.
      perform f_sub.
    elseif p_mult eq 'X'.
      perform f_mult.
    elseif p_div eq 'X'.
      perform f_div.
    endif.
  endif.

  write: gv_result.

*&---------------------------------------------------------------------*
*& Form F_ADD
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form f_add .
  gv_result = p_num1 + p_num2.
endform.
*&---------------------------------------------------------------------*
*& Form F_SUB
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form f_sub .
  gv_result = p_num1 - p_num2.
endform.
*&---------------------------------------------------------------------*
*& Form F_MULT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form f_mult .
  gv_result = p_num1 * p_num2.
endform.
*&---------------------------------------------------------------------*
*& Form F_DIV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form f_div .
  gv_result = p_num1 / p_num2.
endform.
