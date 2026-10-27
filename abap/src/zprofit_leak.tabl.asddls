@EndUserText.label: 'Profit Leakage'
@AbapCatalog.enhancement.category: #NOT_EXTENSIBLE
define table zprofit_leak {
 key leak_uuid : sysuuid_x16 not null;
 leak_id : abap.char(12);
 source_module : abap.char(5);
 customer_or_vendor : abap.char(40);
 product : abap.char(40);
 quantity : abap.dec(13,3);
 expected_price : abap.curr(15,2);
 actual_price : abap.curr(15,2);
 currency : abap.cuky;
 leakage_amount : abap.curr(15,2);
 leakage_percent : abap.dec(9,4);
 root_cause : abap.char(30);
 status : abap.char(1);
 created_by : abap.char(12);
 created_at : timestampl;
 last_changed_at : timestampl;
 local_last_changed_at : timestampl;
}
