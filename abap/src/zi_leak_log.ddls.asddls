@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Leak Recovery Log'
define view entity ZI_Leak_Log as select from zleak_log as Log
  association to parent ZI_Profit_Leak as _Leak on $projection.ParentUUID = _Leak.LeakUUID
{
 key log_uuid as LogUUID,
 parent_uuid as ParentUUID,
 action_text as ActionText,
 action_by as ActionBy,
 action_at as ActionAt,
 _Leak
}
