CLASS zcl_leak_calculator DEFINITION PUBLIC FINAL CREATE PRIVATE.
 PUBLIC SECTION.
  CLASS-METHODS calculate_leakage IMPORTING iv_expected TYPE decfloat34 iv_actual TYPE decfloat34 iv_quantity TYPE decfloat34 RETURNING VALUE(rv_amount) TYPE decfloat34.
  CLASS-METHODS derive_root_cause IMPORTING iv_source_module TYPE string iv_expected TYPE decfloat34 iv_actual TYPE decfloat34 iv_quantity TYPE decfloat34 RETURNING VALUE(rv_root_cause) TYPE string.
ENDCLASS.
CLASS zcl_leak_calculator IMPLEMENTATION.
 "Calculate a positive expected-to-actual price gap times quantity.
 METHOD calculate_leakage.
  rv_amount = COND #( WHEN iv_expected > iv_actual THEN ( iv_expected - iv_actual ) * iv_quantity ELSE 0 ).
 ENDMETHOD.
 "Map positive leakage to the module root cause.
 METHOD derive_root_cause.
  rv_root_cause = COND #( WHEN calculate_leakage( iv_expected = iv_expected iv_actual = iv_actual iv_quantity = iv_quantity ) <= 0 THEN 'NONE'
   WHEN iv_source_module = 'SD' THEN 'DISCOUNT_OVERRIDE'
   WHEN iv_source_module = 'MM' THEN 'PRICE_VARIANCE'
   WHEN iv_source_module = 'FI_CO' THEN 'REBATE_ERROR'
   ELSE 'NONE' ).
 ENDMETHOD.
ENDCLASS.
