CLASS zcl_leak_seed_data DEFINITION PUBLIC FINAL CREATE PUBLIC.
 PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.
ENDCLASS.
CLASS zcl_leak_seed_data IMPLEMENTATION.
 "Clear the demo table and insert twelve hypothetical INR examples.
 METHOD if_oo_adt_classrun~main.
  DELETE FROM zprofit_leak.
  DATA rows TYPE TABLE OF zprofit_leak.
  rows = VALUE #(
   ( leak_uuid = cl_system_uuid=>create_uuid_x16_static( ) leak_id = 'PL-2026-001' source_module = 'SD' customer_or_vendor = 'Customer A' product = 'P-100' quantity = 50 expected_price = 1000 actual_price = 900 currency = 'INR' leakage_amount = 5000 leakage_percent = 10 root_cause = 'DISCOUNT_OVERRIDE' status = 'N' )
   ( leak_uuid = cl_system_uuid=>create_uuid_x16_static( ) leak_id = 'PL-2026-002' source_module = 'SD' customer_or_vendor = 'Customer B' product = 'P-110' quantity = 20 expected_price = 500 actual_price = 500 currency = 'INR' leakage_amount = 0 leakage_percent = 0 root_cause = 'NONE' status = 'N' )
   ( leak_uuid = cl_system_uuid=>create_uuid_x16_static( ) leak_id = 'PL-2026-003' source_module = 'SD' customer_or_vendor = 'Customer C' product = 'P-120' quantity = 15 expected_price = 800 actual_price = 760 currency = 'INR' leakage_amount = 600 leakage_percent = 5 root_cause = 'DISCOUNT_OVERRIDE' status = 'F' )
   ( leak_uuid = cl_system_uuid=>create_uuid_x16_static( ) leak_id = 'PL-2026-004' source_module = 'SD' customer_or_vendor = 'Customer D' product = 'P-130' quantity = 40 expected_price = 250 actual_price = 220 currency = 'INR' leakage_amount = 1200 leakage_percent = 12 root_cause = 'DISCOUNT_OVERRIDE' status = 'R' )
   ( leak_uuid = cl_system_uuid=>create_uuid_x16_static( ) leak_id = 'PL-2026-005' source_module = 'MM' customer_or_vendor = 'Vendor A' product = 'RM-200' quantity = 100 expected_price = 150 actual_price = 140 currency = 'INR' leakage_amount = 1000 leakage_percent = 6.6667 root_cause = 'PRICE_VARIANCE' status = 'N' )
   ( leak_uuid = cl_system_uuid=>create_uuid_x16_static( ) leak_id = 'PL-2026-006' source_module = 'MM' customer_or_vendor = 'Vendor B' product = 'RM-210' quantity = 25 expected_price = 200 actual_price = 205 currency = 'INR' leakage_amount = 0 leakage_percent = 0 root_cause = 'NONE' status = 'N' )
   ( leak_uuid = cl_system_uuid=>create_uuid_x16_static( ) leak_id = 'PL-2026-007' source_module = 'MM' customer_or_vendor = 'Vendor C' product = 'RM-220' quantity = 60 expected_price = 75 actual_price = 70 currency = 'INR' leakage_amount = 300 leakage_percent = 6.6667 root_cause = 'PRICE_VARIANCE' status = 'F' )
   ( leak_uuid = cl_system_uuid=>create_uuid_x16_static( ) leak_id = 'PL-2026-008' source_module = 'MM' customer_or_vendor = 'Vendor D' product = 'RM-230' quantity = 12 expected_price = 1200 actual_price = 1100 currency = 'INR' leakage_amount = 1200 leakage_percent = 8.3333 root_cause = 'PRICE_VARIANCE' status = 'R' )
   ( leak_uuid = cl_system_uuid=>create_uuid_x16_static( ) leak_id = 'PL-2026-009' source_module = 'FI_CO' customer_or_vendor = 'Customer E' product = 'REB-300' quantity = 30 expected_price = 300 actual_price = 270 currency = 'INR' leakage_amount = 900 leakage_percent = 10 root_cause = 'REBATE_ERROR' status = 'N' )
   ( leak_uuid = cl_system_uuid=>create_uuid_x16_static( ) leak_id = 'PL-2026-010' source_module = 'FI_CO' customer_or_vendor = 'Customer F' product = 'REB-310' quantity = 10 expected_price = 100 actual_price = 100 currency = 'INR' leakage_amount = 0 leakage_percent = 0 root_cause = 'NONE' status = 'N' )
   ( leak_uuid = cl_system_uuid=>create_uuid_x16_static( ) leak_id = 'PL-2026-011' source_module = 'FI_CO' customer_or_vendor = 'Customer G' product = 'REB-320' quantity = 80 expected_price = 60 actual_price = 55 currency = 'INR' leakage_amount = 400 leakage_percent = 8.3333 root_cause = 'REBATE_ERROR' status = 'F' )
   ( leak_uuid = cl_system_uuid=>create_uuid_x16_static( ) leak_id = 'PL-2026-012' source_module = 'FI_CO' customer_or_vendor = 'Customer H' product = 'REB-330' quantity = 5 expected_price = 2500 actual_price = 2400 currency = 'INR' leakage_amount = 500 leakage_percent = 4 root_cause = 'REBATE_ERROR' status = 'R' ) ).
  INSERT zprofit_leak FROM TABLE @rows.
  out->write( |Inserted { lines( rows ) } hypothetical INR rows.| ).
 ENDMETHOD.
ENDCLASS.
