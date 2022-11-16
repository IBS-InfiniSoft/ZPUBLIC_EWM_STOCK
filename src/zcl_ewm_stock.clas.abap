class ZCL_EWM_STOCK definition
  public
  final
  create public .

public section.

  class-methods READ_BIN_STOCK
    importing
      !IV_LGNUM type /SCWM/LGNUM
      !IV_LGPLA type /SCWM/LGPLA
      !IV_LGTYP type /SCWM/LGTYP
      !IV_MATNR type /SCWM/DE_MATNR optional
      !IV_CHARG type /SCWM/DE_CHARG optional
      !IV_CAT type /SCDL/DL_STOCK_CATEGORY optional
      !IV_OWNER type /SCWM/DE_OWNER optional
      !IV_NOT_ON_HU type ABAP_BOOL optional
    exporting
      !ET_STOCK_MON type /SCWM/TT_STOCK_MON .
protected section.
private section.
ENDCLASS.



CLASS ZCL_EWM_STOCK IMPLEMENTATION.


METHOD read_bin_stock.
* Read the Stock on the Bin

  DATA: lr_lgpla   TYPE /scwm/tt_lgpla_r,
        lr_lgtyp   TYPE /scwm/tt_lgtyp_r,
        lr_matnr   TYPE /scwm/tt_matnr_r,
        lr_charg   TYPE /scwm/tt_charg_r,
        lr_huident TYPE /scwm/tt_huident_r,
        lr_cat     TYPE /scwm/tt_cat_r,
        lr_owner   TYPE /scwm/tt_owner_r.

  CLEAR:  et_stock_mon[].

* check input data
  IF iv_lgnum IS INITIAL.
    RETURN.
  ENDIF.

  DATA(ls_read_options) = VALUE /scwm/s_read_opt_stock( exclude_outcon = abap_true
                                                        exclude_texts  = abap_true ).

  DATA(lo_mon_stock) = NEW /scwm/cl_mon_stock( iv_lgnum        = iv_lgnum
                                               is_read_options = ls_read_options ).

  IF lo_mon_stock IS NOT BOUND.
    RETURN.
  ENDIF.

* set options for data reading
  INSERT VALUE #( option = wmegc_option_eq
                  sign   = wmegc_sign_inclusive
                  low    = iv_lgtyp
                  ) INTO TABLE lr_lgtyp[].

  INSERT VALUE #( option = wmegc_option_eq
                  sign   = wmegc_sign_inclusive
                  low    = iv_lgpla
                  ) INTO TABLE lr_lgpla[].

* optional parameters
  IF iv_matnr IS NOT INITIAL.
    INSERT VALUE #( option = wmegc_option_eq
                    sign   = wmegc_sign_inclusive
                    low    = iv_matnr
                    ) INTO TABLE lr_matnr[].
  ENDIF.

  IF iv_charg IS NOT INITIAL.
    INSERT VALUE #( option = wmegc_option_eq
                    sign   = wmegc_sign_inclusive
                    low    = iv_charg
                    ) INTO TABLE lr_charg[].
  ENDIF.

  IF iv_cat IS NOT INITIAL.
    INSERT VALUE #( option = wmegc_option_eq
                    sign   = wmegc_sign_inclusive
                    low    = iv_cat
                    ) INTO TABLE lr_cat[].
  ENDIF.

  IF iv_owner IS NOT INITIAL.
    INSERT VALUE #( option = wmegc_option_eq
                    sign   = wmegc_sign_inclusive
                    low    = iv_owner
                    ) INTO TABLE lr_owner[].
  ENDIF.

  " Only consider stock that is not on a HU
  IF iv_not_on_hu = abap_true.
    INSERT VALUE #( option = wmegc_option_eq
                    sign   = wmegc_sign_inclusive
                    low    = space
                    ) INTO TABLE lr_huident[].
  ENDIF.

* get physical stock data
  lo_mon_stock->get_physical_stock(
      EXPORTING
        iv_skip_resource = abap_true
        iv_skip_tu       = abap_true
        it_huident_r     = lr_huident[]
        it_lgtyp_r       = lr_lgtyp[]
        it_lgpla_r       = lr_lgpla[]
        it_matnr_r       = lr_matnr[]
        it_charg_r       = lr_charg[]
        it_cat_r         = lr_cat[]
        it_owner_r       = lr_owner[]
      IMPORTING
        et_stock_mon     = DATA(lt_stock_mon)
        ev_error         = DATA(lv_error)     ).

  IF lv_error = abap_true.
    RETURN.
  ENDIF.

  et_stock_mon[] = lt_stock_mon[].

ENDMETHOD.
ENDCLASS.
