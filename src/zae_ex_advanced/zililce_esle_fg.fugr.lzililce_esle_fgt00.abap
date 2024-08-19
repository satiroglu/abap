*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZILILCE_ESLESTIR................................*
DATA:  BEGIN OF STATUS_ZILILCE_ESLESTIR              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZILILCE_ESLESTIR              .
CONTROLS: TCTRL_ZILILCE_ESLESTIR
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZILILCE_ESLESTIR              .
TABLES: ZILILCE_ESLESTIR               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
