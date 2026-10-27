@EndUserText.label: 'Recovery Log'
@AbapCatalog.enhancement.category: #NOT_EXTENSIBLE
define table zleak_log {
 key log_uuid : sysuuid_x16 not null;
 parent_uuid : sysuuid_x16;
 action_text : abap.char(80);
 action_by : abap.char(12);
 action_at : timestampl;
}
