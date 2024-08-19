*&---------------------------------------------------------------------*
*& Report ZAE_CHECKBOX
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zae_checkbox.

data: gv_num    type i value 10,
      gv_result  type i,
      gv_result1 type i,
      gv_result2 type i,
      gv_result3 type i.
*num = 10.

*parameters: number type i.

selection-screen begin of block add_options with frame title text-001.
parameters: p_2 as checkbox,
            p_3  as checkbox,
            p_5 as checkbox.
selection-screen end of block add_options.


initialization.
  " ekrana girilen user-input dan önce çalışan bir alan

at selection-screen.
  " ekranda kullanılan input parametlerini özelleştirmek için kullanılır.

start-of-selection.
  " programın run edildiğinde kullanıcının göreceği kısım. ikinci ekran gibi bir şey yani yapılan işlemi sonucunun göründüğü yer.
  if p_2 eq 'X'.
    gv_result1 = gv_result1 + 2.
  endif.

  if p_3 eq 'X'.
    gv_result2 = gv_result2 + 3.
  endif.

  if p_5 eq 'X'.
    gv_result3 = gv_result3 + 5.
  endif.

  gv_result = gv_result1 + gv_result2 + gv_result3 + gv_num.
  write: gv_result.

end-of-selection.
  " formların olduğu kısımlar.
