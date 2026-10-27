using { cuid, managed } from '@sap/cds/common';

namespace enterprise.profit.leak;

entity ProfitLeaks : cuid, managed {
  leakID            : String(12) not null;
  sourceModule      : String(5) not null;
  customerOrVendor  : String(40);
  product           : String(40);
  quantity          : Decimal(13,3) not null;
  expectedPrice     : Decimal(15,2) not null;
  actualPrice       : Decimal(15,2) not null;
  currency          : String(3) default 'INR';
  leakageAmount     : Decimal(15,2);
  leakagePercent    : Decimal(9,4);
  rootCause         : String(30);
  status            : String(1) default 'N';
  anomalyFlag       : Boolean default false;
  logs              : Composition of many LeakLogs on logs.parent = $self;
}

entity LeakLogs : cuid, managed {
  parent     : Association to ProfitLeaks not null;
  actionText : String(80);
  actionBy   : String(80);
  actionAt   : Timestamp;
}
