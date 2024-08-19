*&---------------------------------------------------------------------*
*& Report ZAE_IFPARAM1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zae_ifparam1.

start-of-selection.

  parameters p_num type i length 2.

  if p_num > 0 and p_num <= 25.
    write: / 'Girilen sayı:', p_num.
    write: / '0 ile 25 arasındadır!'.
  elseif p_num > 25 and p_num <= 50.
    write: / 'Girilen sayı:', p_num.
    write: / '26 ile 50 arasındadır!'.
  elseif p_num > 50 and p_num <= 75.
    write: / 'Girilen sayı:', p_num.
    write: / '51 ile 75 arasındadır!'.
  elseif p_num > 75 and p_num <= 100.
    write: / 'Girilen sayı:', p_num.
    write: / '76 ile 100 arasındadır!'.
  else.
    write: / 'Girilen sayı:', p_num.
    write: / '100 den büyüktür! '.
  endif.
