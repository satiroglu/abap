*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZIL_LISTE.......................................*
DATA:  BEGIN OF STATUS_ZIL_LISTE                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZIL_LISTE                     .
CONTROLS: TCTRL_ZIL_LISTE
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZIL_LISTE                     .
TABLES: ZIL_LISTE                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
