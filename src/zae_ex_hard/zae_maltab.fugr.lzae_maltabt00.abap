*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZAE_MALTAB......................................*
DATA:  BEGIN OF STATUS_ZAE_MALTAB                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZAE_MALTAB                    .
CONTROLS: TCTRL_ZAE_MALTAB
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZAE_MALTAB                    .
TABLES: ZAE_MALTAB                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
