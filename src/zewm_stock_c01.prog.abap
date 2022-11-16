*&---------------------------------------------------------------------*
*& Include          ZEWM_STOCK_C01
*&---------------------------------------------------------------------*
CLASS lcl_demo DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      main
        IMPORTING IV_LGNUM  TYPE /SCWM/LGNUM
                  IV_LGPLA  TYPE /SCWM/LGPLA
                  IV_LGTYP  TYPE /SCWM/LGTYP.

ENDCLASS.

CLASS lcl_demo IMPLEMENTATION.
  METHOD main.

    zcl_ewm_stock=>read_bin_stock(
      EXPORTING
        iv_lgnum     = iv_lgnum
        iv_lgpla     = iv_lgpla
        iv_lgtyp     = iv_lgtyp
*        iv_matnr     =
*        iv_charg     =
*        iv_cat       =
*        iv_owner     =
*        iv_not_on_hu =
      IMPORTING
        et_stock_mon = data(lt_stock_mon) ).

    cl_demo_output=>display_data( lt_stock_mon[] ).

  ENDMETHOD.

ENDCLASS.
