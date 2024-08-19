function zae_smf_fm.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_EBELN) TYPE  EBELN OPTIONAL
*"  EXPORTING
*"     VALUE(E_EBELN) TYPE  EBELN
*"     VALUE(E_MBLNR) TYPE  MBLNR
*"     VALUE(E_MJAHR) TYPE  MJAHR
*"     VALUE(E_BELNR) TYPE  BELNR_D
*"     VALUE(E_GJAHR) TYPE  GJAHR
*"     VALUE(DURUM) TYPE  CHAR200
*"  TABLES
*"      ET_OUT STRUCTURE  ZAE_SMF_S OPTIONAL
*"----------------------------------------------------------------------

  types: begin of ty_list,
           ebeln type zae_sastab-ebeln,
           mblnr type zae_maltab-mblnr,
           mjahr type zae_maltab-mjahr,
           belnr type zae_fattab-belnr,
           gjahr type zae_fattab-gjahr,
           durum type char200,
         end of ty_list.

  data: gt_out type standard table of ty_list,
        gs_out type ty_list.

  data: gv_durum type string,
        gv_sasd  type string,
        gv_mald  type string,
        gv_fatd  type string.


  gv_sasd = 'SAS'.
  gv_mald = 'Mal Girişi'.
  gv_fatd = 'Fatura'.




*  select s~ebeln m~mblnr m~mjahr f~belnr f~gjahr
  select s~ebeln, m~mblnr, m~mjahr, f~belnr, f~gjahr
    from zae_sastab as s
    inner join zae_maltab as m on m~ebeln eq s~ebeln
    inner join zae_fattab as f on f~mblnr eq m~mblnr
*    right join zae_maltab as m on m~ebeln eq s~ebeln
*    right join zae_fattab as f on f~mblnr eq m~mblnr and f~mjahr eq m~mjahr
    into table @gt_out
    where s~ebeln eq @i_ebeln.

  break-point.

*  if gt_out-ebeln is initial.
*    durum = 'bişe yok'.
*  else.
    loop at gt_out into gs_out.
      if gs_out-ebeln is not initial.
        et_out-ebeln = gs_out-ebeln.
        concatenate gv_sasd ' mevcut. '
              into gv_durum.
        if gs_out-mblnr is not initial.
          et_out-mblnr = gs_out-mblnr.
          et_out-mjahr = gs_out-mjahr.
          concatenate gv_sasd ', ' gv_mald ' mevcut.'
              into gv_durum.
          if gs_out-belnr is not initial.
            et_out-belnr =  gs_out-belnr.
            et_out-gjahr = gs_out-gjahr.
            concatenate gv_sasd ', ' gv_mald ', ' gv_fatd ' mevcut.'
              into gv_durum.
          endif.
        endif.
        et_out-durum = gv_durum.
      else.
        et_out-durum = 'SAS Bulunamadı.'.
      endif.
      append gs_out to et_out.
      clear gs_out.
    endloop.
*  endif.


  break-point.







*  data: mesajdur type string.


*  select s~ebeln m~mblnr m~mjahr f~belnr f~gjahr
*  select  s~ebeln, m~mblnr, m~mjahr, f~belnr, f~gjahr
*    from zae_sastab as s
**    inner join zae_maltab as m on m~ebeln eq s~ebeln
**    inner join zae_fattab as f on f~mblnr eq m~mblnr
*    right join zae_maltab as m on m~ebeln eq s~ebeln
*    right join zae_fattab as f on f~mblnr eq m~mblnr and f~mjahr eq m~mjahr
*    into corresponding fields of table @gtout
*    where s~ebeln eq @it_ebeln.

*  loop at it_ebeln.
*    break-point.
*    select  s~ebeln, m~mblnr, m~mjahr, f~belnr, f~gjahr
*      from zae_sastab as s
**          inner join zae_maltab as m on m~ebeln eq s~ebeln
**          inner join zae_fattab as f on f~mblnr eq m~mblnr
*      inner join zae_maltab as m on m~ebeln eq s~ebeln
*      inner join zae_fattab as f on f~mblnr eq m~mblnr
*      into corresponding fields of table @gtout
*      where s~ebeln eq @it_ebeln-ebeln.
*
*
*  endloop.






*  loop at gtout into gsout.
*
*    if gsout-ebeln is not initial.
*      e_ebeln = gsout-ebeln.
*      mesajdur = 'SAS'.
*      if gsout-mblnr is not initial.
*        e_mblnr = gsout-mblnr.
*        e_mjahr = gsout-mjahr.
*        mesajdur = 'Mal Girişi'.
*        if gsout-belnr is not initial.
*          e_belnr =  gsout-belnr.
*          e_gjahr = gsout-gjahr.
*          mesajdur = 'Fatura'.
*          durum = mesajdur.
*        endif.
*      endif.
*    endif.
*
*
*  endloop.
*
*  break-point.




* elseif gsout-mblnr is not initial.
*      e_mblnr = gsout-mblnr.
*      mesajdur = 'Mal Girişi'.
*    elseif gsout-belnr is not initial.
*      e_belnr =  gsout-belnr.
*      mesajdur = 'Fatura'.
*    else.
*      e_ebeln = gsout-ebeln.
*      e_mblnr = gsout-mblnr.
*      e_mjahr = gsout-mjahr.
*      e_belnr = gsout-belnr.
*      e_gjahr = gsout-gjahr.
*      durum = mesajdur.
*

endfunction.
