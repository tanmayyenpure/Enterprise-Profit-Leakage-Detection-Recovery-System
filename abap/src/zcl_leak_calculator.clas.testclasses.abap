CLASS ltc_leak_calculator DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
 PRIVATE SECTION.
  METHODS leak_amount FOR TESTING.
  METHODS no_leak FOR TESTING.
  METHODS zero_quantity FOR TESTING.
  METHODS sd_cause FOR TESTING.
  METHODS mm_cause FOR TESTING.
  METHODS fi_co_cause FOR TESTING.
  METHODS negative_price_edge FOR TESTING.
ENDCLASS.
CLASS ltc_leak_calculator IMPLEMENTATION.
 "Given a gap, when quantity is applied, then expected leakage is returned.
 METHOD leak_amount.
  cl_abap_unit_assert=>assert_equals( exp = CONV decfloat34( 5000 ) act = zcl_leak_calculator=>calculate_leakage( iv_expected = 1000 iv_actual = 900 iv_quantity = 50 ) ).
 ENDMETHOD.
 "Given actual exceeds expected, then leakage is zero.
 METHOD no_leak.
  cl_abap_unit_assert=>assert_equals( exp = CONV decfloat34( 0 ) act = zcl_leak_calculator=>calculate_leakage( iv_expected = 900 iv_actual = 1000 iv_quantity = 2 ) ).
 ENDMETHOD.
 "Given zero quantity, then leakage is zero.
 METHOD zero_quantity.
  cl_abap_unit_assert=>assert_equals( exp = CONV decfloat34( 0 ) act = zcl_leak_calculator=>calculate_leakage( iv_expected = 1000 iv_actual = 900 iv_quantity = 0 ) ).
 ENDMETHOD.
 "Given an SD leak, then discount override is derived.
 METHOD sd_cause.
  cl_abap_unit_assert=>assert_equals( exp = 'DISCOUNT_OVERRIDE' act = zcl_leak_calculator=>derive_root_cause( iv_source_module = 'SD' iv_expected = 10 iv_actual = 9 iv_quantity = 1 ) ).
 ENDMETHOD.
 "Given an MM leak, then price variance is derived.
 METHOD mm_cause.
  cl_abap_unit_assert=>assert_equals( exp = 'PRICE_VARIANCE' act = zcl_leak_calculator=>derive_root_cause( iv_source_module = 'MM' iv_expected = 10 iv_actual = 9 iv_quantity = 1 ) ).
 ENDMETHOD.
 "Given an FI/CO leak, then rebate error is derived.
 METHOD fi_co_cause.
  cl_abap_unit_assert=>assert_equals( exp = 'REBATE_ERROR' act = zcl_leak_calculator=>derive_root_cause( iv_source_module = 'FI_CO' iv_expected = 10 iv_actual = 9 iv_quantity = 1 ) ).
 ENDMETHOD.
 "Given negative prices and no positive gap, then the cause is NONE.
 METHOD negative_price_edge.
  cl_abap_unit_assert=>assert_equals( exp = 'NONE' act = zcl_leak_calculator=>derive_root_cause( iv_source_module = 'SD' iv_expected = -1 iv_actual = -2 iv_quantity = 1 ) ).
 ENDMETHOD.
ENDCLASS.
