@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Cause Value Help'
@ObjectModel.dataCategory: #VALUE_HELP
define view entity ZI_Leak_Root_Cause_VH as select from zprofit_leak
{
 key root_cause as RootCause
}
where root_cause <> ''
group by root_cause
