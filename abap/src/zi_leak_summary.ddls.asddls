@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Leakage Summary'
define view entity ZI_Leak_Summary as select from zprofit_leak
{
 key root_cause as RootCause,
 key source_module as SourceModule,
 key currency as Currency,
 @Semantics.amount.currencyCode: 'Currency'
 sum( leakage_amount ) as TotalLeakage
}
group by root_cause, source_module, currency
