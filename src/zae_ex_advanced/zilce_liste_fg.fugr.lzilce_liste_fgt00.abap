*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZILCE_LISTE.....................................*
DATA:  BEGIN OF STATUS_ZILCE_LISTE                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZILCE_LISTE                   .
CONTROLS: TCTRL_ZILCE_LISTE
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZILCE_LISTE                   .
TABLES: ZILCE_LISTE                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
