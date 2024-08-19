*&---------------------------------------------------------------------*
*& Report ZAE_IFMOD1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zae_ifmod1.

data: gv_num type int1.

start-of-selection.

  do 101 times. " 100 sayısını da dahil etmesi için 101 defa döndürdük
    if gv_num mod 2 eq 0. " eğer num sayısının 2 ye bölümünden kalan 0 ise çittir.
      write: / 'Çift Sayı:', gv_num.
    else. " değilse tektir
      write: / 'Tek Sayı :', gv_num.
    endif.
    gv_num = gv_num + 1.
  enddo.