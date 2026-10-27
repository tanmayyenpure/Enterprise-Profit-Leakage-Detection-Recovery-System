@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Profit Leakage'
define root view entity ZI_Profit_Leak as select from zprofit_leak as Leak
  composition [0..*] of ZI_Leak_Log as _RecoveryLog
{
 key leak_uuid as LeakUUID,
 leak_id as LeakID,
 source_module as SourceModule,
 customer_or_vendor as CustomerOrVendor,
 product as Product,
 quantity as Quantity,
 @Semantics.amount.currencyCode: 'Currency'
 expected_price as ExpectedPrice,
 @Semantics.amount.currencyCode: 'Currency'
 actual_price as ActualPrice,
 @Semantics.currencyCode: true
 currency as Currency,
 @Semantics.amount.currencyCode: 'Currency'
 leakage_amount as LeakageAmount,
 leakage_percent as LeakagePercent,
 root_cause as RootCause,
 status as Status,
 created_by as CreatedBy,
 created_at as CreatedAt,
 last_changed_at as LastChangedAt,
 local_last_changed_at as LocalLastChangedAt,
 case status when 'N' then 2 when 'F' then 1 when 'R' then 3 else 0 end as StatusCriticality,
 _RecoveryLog
}
