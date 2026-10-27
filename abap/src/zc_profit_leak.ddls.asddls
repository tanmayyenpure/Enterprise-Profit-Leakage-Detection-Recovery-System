@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Profit Leakage'
define root view entity ZC_Profit_Leak provider contract transactional_query
  as projection on ZI_Profit_Leak
{
 key LeakUUID, LeakID, SourceModule, CustomerOrVendor, Product, Quantity,
 ExpectedPrice, ActualPrice, Currency, LeakageAmount, LeakagePercent, RootCause,
 Status, StatusCriticality, CreatedBy, CreatedAt, LastChangedAt, LocalLastChangedAt,
 _RecoveryLog : redirected to composition child ZC_Leak_Log
}
