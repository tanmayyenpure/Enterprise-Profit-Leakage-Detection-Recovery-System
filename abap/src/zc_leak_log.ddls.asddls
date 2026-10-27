@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Recovery Log'
define view entity ZC_Leak_Log as projection on ZI_Leak_Log
{
 key LogUUID, ParentUUID, ActionText, ActionBy, ActionAt,
 _Leak : redirected to parent ZC_Profit_Leak
}
