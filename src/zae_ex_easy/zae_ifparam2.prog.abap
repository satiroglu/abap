*&---------------------------------------------------------------------*
*& Report ZAE_IFPARAM2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zae_ifparam2.



start-of-selection.

  parameters p_not type n length 3.

  if p_not => 0 and p_not <= 100.
    if p_not => 0 and p_not <= 20.
      message 'Harf notunuz FF' type 'I'.
    elseif p_not > 20 and p_not <= 40.
      message 'Harf notunuz DD' type 'I'.
    elseif p_not > 40 and p_not <= 60.
      message 'Harf notunuz CC' type 'I'.
    elseif p_not > 60 and p_not <= 80.
      message 'Harf notunuz BB' type 'I'.
    elseif p_not > 80 and p_not <= 100.
      message 'Harf notunuz AA' type 'I'.
    endif.
  else.
    message 'Notunuz 100den büyük olamaz!' type 'I'.
  endif.
