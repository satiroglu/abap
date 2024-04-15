*&---------------------------------------------------------------------*
*& Report ZAE_BADI_EXIT_FIND
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zae_badi_exit_find.

tables: tstc,tadir,modsapt,modact,
        trdir,tfdir,enlfdir,sxs_attrt,tstct.

data : jtab       like tadir occurs 0 with header line,
       field1(30),
       v_devclass like tadir-devclass,
       wa_tadir   type tadir.

parameters : p_tcode like tstc-tcode,
             p_pgmna like tstc-pgmna.

start-of-selection.

  if not p_tcode is initial.
    select single *
      from tstc
      where tcode eq p_tcode.
  elseif not p_pgmna is initial.
    tstc-pgmna = p_pgmna.
  endif.

  if sy-subrc eq 0.
    select single *
      from tadir
     where pgmid = 'R3TR'
       and object = 'PROG'
       and obj_name = tstc-pgmna.

    move: tadir-devclass to v_devclass.

    if sy-subrc ne 0.
      select single *
        from trdir
       where name = tstc-pgmna.
      if trdir-subc eq 'F'.
        select single *
          from tfdir
         where pname = tstc-pgmna.
        select single *
          from enlfdir
         where funcname = tfdir-funcname.
        select single *
          from tadir
         where pgmid = 'R3TR'
           and object = 'FUGR'
           and obj_name eq enlfdir-area.

        move: tadir-devclass to v_devclass.
      endif.
    endif.
    select *
      from tadir
      into table jtab
     where pgmid = 'R3TR'
       and object in ('SMOD', 'SXSD')
       and devclass = v_devclass.
    select single *
      from tstct
     where sprsl eq sy-langu
       and tcode eq p_tcode.
    format color col_positive intensified off.
    write:/(19) 'Transaction Code - ',
    20(20) p_tcode,
    45(50) tstct-ttext.
    skip.
    if not jtab[] is initial.
      write:/(105) sy-uline.
      format color col_heading intensified on.
* SORTING THE INTERNAL TABLE
      sort jtab by object.
      data : wf_txt(60)     type c,
             wf_smod        type i,
             wf_badi        type i,
             wf_object2(30) type c.
      clear : wf_smod, wf_badi , wf_object2.
*GET THE TOTAL SMOD.
      loop at jtab into wa_tadir.
        at first.
          format color col_heading intensified on.
          write:/1 sy-vline,
          2 'Enhancement/ Business Add-in',
          41 sy-vline ,
          42 'Description',
          105 sy-vline.
          write:/(105) sy-uline.
        endat.
        clear wf_txt.
        at new object.
          if wa_tadir-object = 'SMOD'.
            wf_object2 = 'Enhancement' .
          elseif wa_tadir-object = 'SXSD'.
            wf_object2 = ' Business Add-in'.
          endif.
          format color col_group intensified on.
          write:/1 sy-vline,
          2 wf_object2,
          105 sy-vline.
        endat.
        case wa_tadir-object.
          when 'SMOD'.
            wf_smod = wf_smod + 1.
            select single modtext into wf_txt
            from modsapt
            where sprsl = sy-langu
            and name = wa_tadir-obj_name.
            format color col_normal intensified off.
          when 'SXSD'.
* FOR BADIS
            wf_badi = wf_badi + 1 .
            select single text into wf_txt
            from sxs_attrt
            where sprsl = sy-langu
            and exit_name = wa_tadir-obj_name.
            format color col_normal intensified on.
        endcase.
        write:/1 sy-vline,
        2 wa_tadir-obj_name hotspot on,
        41 sy-vline ,
        42 wf_txt,
        105 sy-vline.
        at end of object.
          write : /(105) sy-uline.
        endat.
      endloop.
      write:/(105) sy-uline.
      skip.
      format color col_total intensified on.
      write:/ 'No.of Exits:' , wf_smod.
      write:/ 'No.of BADis:' , wf_badi.
    else.
      format color col_negative intensified on.
      write:/(105) 'No userexits or BADis exist'.
    endif.
  else.
    format color col_negative intensified on.
    write:/(105) 'Transaction does not exist'.
  endif.

at line-selection.
  data : wf_object type tadir-object.
  clear wf_object.
  get cursor field field1.
  check field1(8) eq 'WA_TADIR'.
  read table jtab with key obj_name = sy-lisel+1(20).
  move jtab-object to wf_object.
  case wf_object.
    when 'SMOD'.
      set parameter id 'MON' field sy-lisel+1(10).
      call transaction 'SMOD' and skip first screen.
    when 'SXSD'.
      set parameter id 'EXN' field sy-lisel+1(20).
      call transaction 'SE18' and skip first screen.
  endcase.