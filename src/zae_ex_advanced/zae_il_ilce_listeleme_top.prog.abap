*&---------------------------------------------------------------------*
*& Include          ZAE_IL_ILCE_LISTELEME_TOP
*&---------------------------------------------------------------------*
" types
types: begin of gty_list,
         "bu bir structure ve type alanlarında data elementler yazılıyor.
         il_kodu     type zil_kodu,
         il_tanim    type zil_tanim,
         ilce_kodu   type zilce_kodu,
         ilce_tanim  type zilce_tanim,
         il_kodu_e   type zil_kodu,
         ilce_kodu_e type zilce_kodu,
       end of gty_list.

" itab ve structure tanımları
data: gt_list type table of gty_list, " itab tanımı
      gs_list type gty_list. " structuve for itab

" ALV tanımları
data: gt_fieldcatalog type slis_t_fieldcat_alv, " fcat tanımı
      gs_fieldcatalog type slis_fieldcat_alv, " structure for fcat
      gs_layout       type slis_layout_alv. " layout for alv

data: gv_col_count type i. " data for counting ilceler
