*&---------------------------------------------------------------------*
*& Report ZAE_RANDOM_NUMBER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zae_random_number.

data gv_randnum type i.

start-of-selection.

  call function 'QF05_RANDOM_INTEGER'
    exporting
      ran_int_max = 150
      ran_int_min = 1
    importing
      ran_int     = gv_randnum.

  if gv_randnum > 0 and gv_randnum <= 25.
    write: gv_randnum, '0-25 arasında'.
  elseif gv_randnum > 25 and gv_randnum <= 50.
    write: gv_randnum, '25-50 arasında'.
  elseif gv_randnum > 50 and gv_randnum <= 75.
    write: gv_randnum, '50-75 arasında'.
  elseif gv_randnum > 75 and gv_randnum <= 100.
    write: gv_randnum, '75-100 arasında'.
  elseif gv_randnum > 100.
    write: gv_randnum, '100 den büyük'.
  endif.
