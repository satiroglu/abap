*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZAE_SASTAB......................................*
DATA:  BEGIN OF STATUS_ZAE_SASTAB                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZAE_SASTAB                    .
CONTROLS: TCTRL_ZAE_SASTAB
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZAE_SASTAB                    .
TABLES: ZAE_SASTAB                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
