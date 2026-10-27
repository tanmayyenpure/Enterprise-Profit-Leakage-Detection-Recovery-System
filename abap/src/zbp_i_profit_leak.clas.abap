CLASS zbp_i_profit_leak DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zi_profit_leak.
ENDCLASS.
CLASS zbp_i_profit_leak IMPLEMENTATION.
ENDCLASS.

CLASS lhc_ProfitLeak DEFINITION INHERITING FROM cl_abap_behavior_handler.
 PRIVATE SECTION.
  METHODS calcLeakage FOR DETERMINE ON MODIFY IMPORTING keys FOR ProfitLeak~calcLeakage.
  METHODS setRootCause FOR DETERMINE ON MODIFY IMPORTING keys FOR ProfitLeak~setRootCause.
  METHODS setDefaultStatus FOR DETERMINE ON MODIFY IMPORTING keys FOR ProfitLeak~setDefaultStatus.
  METHODS validateQuantity FOR VALIDATE ON SAVE IMPORTING keys FOR ProfitLeak~validateQuantity.
  METHODS validatePrices FOR VALIDATE ON SAVE IMPORTING keys FOR ProfitLeak~validatePrices.
  METHODS flagForRecovery FOR MODIFY IMPORTING keys FOR ACTION ProfitLeak~flagForRecovery RESULT result.
  METHODS markRecovered FOR MODIFY IMPORTING keys FOR ACTION ProfitLeak~markRecovered RESULT result.
  METHODS get_instance_features FOR INSTANCE FEATURES IMPORTING keys REQUEST requested_features FOR ProfitLeak RESULT result.
  METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION IMPORTING keys REQUEST requested_authorizations FOR ProfitLeak RESULT result.
ENDCLASS.

CLASS lhc_ProfitLeak IMPLEMENTATION.
 "Calculate positive leakage amount and percentage for changed records.
 METHOD calcLeakage.
  READ ENTITIES OF zi_profit_leak IN LOCAL MODE ENTITY ProfitLeak FIELDS ( ExpectedPrice ActualPrice Quantity )
   WITH CORRESPONDING #( keys ) RESULT DATA(rows).
  MODIFY ENTITIES OF zi_profit_leak IN LOCAL MODE ENTITY ProfitLeak UPDATE FIELDS ( LeakageAmount LeakagePercent )
   WITH VALUE #( FOR row IN rows ( %tky = row-%tky
    LeakageAmount = zcl_leak_calculator=>calculate_leakage( iv_expected = row-ExpectedPrice iv_actual = row-ActualPrice iv_quantity = row-Quantity )
    LeakagePercent = COND #( WHEN row-ExpectedPrice > 0
     THEN COND decfloat34( WHEN row-ExpectedPrice > row-ActualPrice
       THEN ( row-ExpectedPrice - row-ActualPrice ) / row-ExpectedPrice * 100 ELSE 0 )
     ELSE 0 ) ) ).
 ENDMETHOD.

 "Derive the cause from source module and positive price difference.
 METHOD setRootCause.
  READ ENTITIES OF zi_profit_leak IN LOCAL MODE ENTITY ProfitLeak FIELDS ( SourceModule ExpectedPrice ActualPrice Quantity )
   WITH CORRESPONDING #( keys ) RESULT DATA(rows).
  MODIFY ENTITIES OF zi_profit_leak IN LOCAL MODE ENTITY ProfitLeak UPDATE FIELDS ( RootCause )
   WITH VALUE #( FOR row IN rows ( %tky = row-%tky
    RootCause = zcl_leak_calculator=>derive_root_cause( iv_source_module = row-SourceModule
     iv_expected = row-ExpectedPrice iv_actual = row-ActualPrice iv_quantity = row-Quantity ) ) ).
 ENDMETHOD.

 "Assign the initial New status to new records.
 METHOD setDefaultStatus.
  MODIFY ENTITIES OF zi_profit_leak IN LOCAL MODE ENTITY ProfitLeak UPDATE FIELDS ( Status )
   WITH VALUE #( FOR key IN keys ( %tky = key-%tky Status = 'N' ) ).
 ENDMETHOD.

 "Reject quantities that are zero or negative and report an actionable message.
 METHOD validateQuantity.
  READ ENTITIES OF zi_profit_leak IN LOCAL MODE ENTITY ProfitLeak FIELDS ( Quantity )
   WITH CORRESPONDING #( keys ) RESULT DATA(rows).
  LOOP AT rows INTO DATA(row) WHERE Quantity <= 0.
   APPEND VALUE #( %tky = row-%tky ) TO failed-profitleak.
   APPEND VALUE #( %tky = row-%tky %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error text = 'Quantity must be greater than zero.' ) ) TO reported-profitleak.
  ENDLOOP.
 ENDMETHOD.

 "Reject negative expected or actual prices and report the input error.
 METHOD validatePrices.
  READ ENTITIES OF zi_profit_leak IN LOCAL MODE ENTITY ProfitLeak FIELDS ( ExpectedPrice ActualPrice )
   WITH CORRESPONDING #( keys ) RESULT DATA(rows).
  LOOP AT rows INTO DATA(row) WHERE ExpectedPrice < 0 OR ActualPrice < 0.
   APPEND VALUE #( %tky = row-%tky ) TO failed-profitleak.
   APPEND VALUE #( %tky = row-%tky %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error text = 'Prices must be zero or greater.' ) ) TO reported-profitleak.
  ENDLOOP.
 ENDMETHOD.

 "Move new records to Flagged and add an audit log row.
 METHOD flagForRecovery.
  READ ENTITIES OF zi_profit_leak IN LOCAL MODE ENTITY ProfitLeak ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(rows).
  MODIFY ENTITIES OF zi_profit_leak IN LOCAL MODE ENTITY ProfitLeak UPDATE FIELDS ( Status )
   WITH VALUE #( FOR row IN rows ( %tky = row-%tky Status = 'F' ) ).
  LOOP AT rows INTO DATA(row).
   MODIFY ENTITIES OF zi_profit_leak IN LOCAL MODE ENTITY ProfitLeak CREATE BY _RecoveryLog
    FROM VALUE #( ( %tky = row-%tky %target = VALUE #( ( ActionText = 'Flagged for recovery' ActionBy = sy-uname ) ) ) ).
   APPEND VALUE #( %tky = row-%tky %param = row ) TO result.
  ENDLOOP.
 ENDMETHOD.

 "Move flagged records to Recovered and add an audit log row.
 METHOD markRecovered.
  READ ENTITIES OF zi_profit_leak IN LOCAL MODE ENTITY ProfitLeak ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(rows).
  MODIFY ENTITIES OF zi_profit_leak IN LOCAL MODE ENTITY ProfitLeak UPDATE FIELDS ( Status )
   WITH VALUE #( FOR row IN rows ( %tky = row-%tky Status = 'R' ) ).
  LOOP AT rows INTO DATA(row).
   MODIFY ENTITIES OF zi_profit_leak IN LOCAL MODE ENTITY ProfitLeak CREATE BY _RecoveryLog
    FROM VALUE #( ( %tky = row-%tky %target = VALUE #( ( ActionText = 'Marked recovered' ActionBy = sy-uname ) ) ) ).
   APPEND VALUE #( %tky = row-%tky %param = row ) TO result.
  ENDLOOP.
 ENDMETHOD.

 "Enable flag and recovery actions only for their appropriate statuses.
 METHOD get_instance_features.
  READ ENTITIES OF zi_profit_leak IN LOCAL MODE ENTITY ProfitLeak FIELDS ( Status )
   WITH CORRESPONDING #( keys ) RESULT DATA(rows).
  result = VALUE #( FOR row IN rows ( %tky = row-%tky
   %features-%action-flagForRecovery = COND #( WHEN row-Status = 'N' THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled )
   %features-%action-markRecovered = COND #( WHEN row-Status = 'F' THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled ) ) ).
 ENDMETHOD.

 "Allow authenticated users to update and call workflow actions; deny deletion.
 METHOD get_instance_authorizations.
  result = VALUE #( FOR key IN keys ( %tky = key-%tky
   %update = if_abap_behv=>auth-allowed
   %delete = if_abap_behv=>auth-unauthorized
   %action-flagForRecovery = if_abap_behv=>auth-allowed
   %action-markRecovered = if_abap_behv=>auth-allowed ) ).
 ENDMETHOD.
ENDCLASS.
