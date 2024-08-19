report zae_ifmod2.

data: gv_num    type i,
      gv_result(3) type c.

start-of-selection.

  gv_num = 0.
  write: '2`e bölünebilien sayılar: '.
  do 101 times.
    if gv_num mod 2 eq 0.
      move gv_num to gv_result.
      condense gv_result.
      if gv_num eq 100.
        write: gv_result.
      else.
        write: gv_result, ','.
      endif.
    endif.
    gv_num = gv_num + 1.
  enddo.

  gv_num = 0.
  write: / '3`e bölünebilien sayılar: '.
  do 101 times.
    if gv_num mod 3 eq 0.
      write gv_num to gv_result.
      condense gv_result.
      if gv_num eq 99.
        write: gv_result.
      else.
        write: gv_result, ','.
      endif.
    endif.
    gv_num = gv_num + 1.
  enddo.

  gv_num = 0.
  write: / '5`e bölünebilien sayılar: '.
  do 101 times.
    if gv_num mod 5 eq 0.
      write gv_num to gv_result. " gv_num bir integer. string yapmak için gv_result a yazdırdık.
      condense gv_result. " gv_result stringi içindeki soşlukları sildik
      if gv_num eq 100. " eğer gv_num 100 ise direkt yaz
        write: gv_result.
      else. " eğer gv_num 100 değil ise gv_result ı yazarken sonuna , ekle
        write: gv_result, ','.
      endif.

    endif.
    gv_num = gv_num + 1. " gv_num ı 1 arttır
  enddo.