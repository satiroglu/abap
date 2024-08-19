*&---------------------------------------------------------------------*
*& Report ZAE_RBUTTON
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zae_rbutton.

data gv_result type i.

selection-screen begin of block numbers with frame title text-001.
parameters: gv_num1 type i,
            gv_num2 type i.
selection-screen end of block numbers.

selection-screen begin of block islemler with frame title text-002.
parameters: p_add  radiobutton group rad,
            p_sub  radiobutton group rad,
            p_mult radiobutton group rad,
            p_div  radiobutton group rad.
selection-screen end of block islemler.

initialization.
  " ekrana girilen user-input dan önce çalışan bir alan

at selection-screen.
  " ekranda kullanılan input parametlerini özelleştirmek için kullanılır.

start-of-selection.
  " programın run edildiğinde kullanıcının göreceği kısım. ikinci ekran gibi bir şey yani yapılan işlemi sonucunun göründüğü yer.

  if p_add eq 'X'.
    gv_result = gv_num1 + gv_num2.
    write: gv_result.
  elseif p_sub eq 'X'.
    gv_result = gv_num1 - gv_num2.
    write: gv_result.
  elseif p_mult eq 'X'.
    gv_result = gv_num1 * gv_num2.
    write: gv_result.
  elseif p_div eq 'X'.
    gv_result = gv_num1 / gv_num2.
    write: gv_result.
  endif.

end-of-selection.
  " formların olduğu kısımlar.
