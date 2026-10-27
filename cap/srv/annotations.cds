using LeakService as service from './leak-service';

annotate service.ProfitLeaks with @(
  UI.HeaderInfo: {
    TypeName: 'Profit Leak',
    TypeNamePlural: 'Profit Leaks',
    Title: { Value: leakID },
    Description: { Value: rootCause }
  },
  UI.SelectionFields: [sourceModule, status, rootCause],
  UI.LineItem: [
    { Value: leakID },
    { Value: sourceModule },
    { Value: customerOrVendor },
    { Value: leakageAmount },
    { Value: status }
  ],
  UI.FieldGroup #Pricing: {
    Data: [{ Value: expectedPrice }, { Value: actualPrice }, { Value: quantity }]
  }
);
