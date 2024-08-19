*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZAE_FATTAB......................................*
DATA:  BEGIN OF STATUS_ZAE_FATTAB                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZAE_FATTAB                    .
CONTROLS: TCTRL_ZAE_FATTAB
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZAE_FATTAB                    .
TABLES: ZAE_FATTAB                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
