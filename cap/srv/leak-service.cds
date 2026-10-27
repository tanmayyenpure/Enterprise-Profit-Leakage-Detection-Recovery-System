using { enterprise.profit.leak as db } from '../db/schema';

service LeakService {
  entity ProfitLeaks as projection on db.ProfitLeaks actions {
    action flagForRecovery();
    action markRecovered();
  };
  entity LeakLogs as projection on db.LeakLogs;
  @readonly entity LeakageSummary as select from db.ProfitLeaks {
    key rootCause,
    key sourceModule,
    key currency,
    sum(leakageAmount) as totalLeakage : Decimal(15,2)
  } group by rootCause, sourceModule, currency;
}
