*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZAE_ENVANTER_KOD................................*
DATA:  BEGIN OF STATUS_ZAE_ENVANTER_KOD              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZAE_ENVANTER_KOD              .
CONTROLS: TCTRL_ZAE_ENVANTER_KOD
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZAE_ENVANTER_KOD              .
TABLES: ZAE_ENVANTER_KOD               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
