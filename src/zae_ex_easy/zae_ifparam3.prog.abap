*&---------------------------------------------------------------------*
*& Report ZAE_IFPARAM3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zae_ifparam3.


data: gv_username(8) type c,
      gv_password(8) type c.

start-of-selection.
  parameters: p_user(10) type c lower case, " 10 karakterli username parametre tanımı
              p_pass(10) type c lower case. " 10 karakterli password parametre tanımı

  gv_username = 'sapuser'.
  gv_password = '12345678'.

  if p_user eq gv_username and p_pass eq gv_password.
    message: 'Başarılı bir şekilde sisteme bağlandınız.' type  'I'.
    write: 'Hoş geldiniz'.
  elseif p_user eq '' or p_pass eq ''.
    message: 'User veya Password boş olamaz' type  'I'.
  else.
    message: 'User veya Password hatalı. Tekrar deneyin.' type  'I'.
  endif.

at selection-screen output.
  " ekrandaki password alanının gizlenmesi
  loop at screen.
    if screen-name = 'P_PASS'.
      screen-invisible = '1'.
      modify screen.
    endif.
  endloop.
