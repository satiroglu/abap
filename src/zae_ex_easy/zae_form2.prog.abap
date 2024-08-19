*&---------------------------------------------------------------------*
*& Report ZAE_FORM2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zae_form2.

start-of-selection.
  " Burak abap yazılım biraz zorlanıyor ama yazılım dillerinden abap Burak için hiç zor değil
  perform burak.
  perform abap.
  perform yazilim.
  perform biraz.
  perform zorlaniyor.
  perform ama.
  perform yazilim.
  perform dillerinden.
  perform abap.
  perform burak.
  perform icin.
  perform hic.
  perform zor.
  perform degil.
  write: / .

  " Burak biraz isterse yapar
  perform burak.
  perform biraz.
  perform isterse.
  perform yapar.
  write: / .

  " Burak yazılım dillerinden abap yazılım zor değil
  perform burak.
  perform yazilim.
  perform dillerinden.
  perform abap.
  perform yazilim.
  perform zor.
  perform degil.


form burak .
  write: 'Burak'.
endform.

form yapar .
  write: 'yapar'.
endform.

form yazilim .
  write: 'yazılım'.
endform.

form hic .
  write: 'hiç'.
endform.

form ama .
  write: 'ama'.
endform.

form zorlaniyor .
  write: 'zorlanıyor'.
endform.

form dillerinden .
  write: 'dillerinden'.
endform.

form icin .
  write: 'için'.
endform.

form zor .
  write: 'zor'.
endform.

form biraz .
  write: 'biraz'.
endform.

form degil .
  write: 'değil'.
endform.

form isterse .
  write: 'isterse'.
endform.

form abap .
  write: 'abap'.
endform.
