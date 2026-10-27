# Architecture

## Layers
- SAP ERP source transactions contribute expected/actual prices and quantities from SD, MM and FI/CO.
- The ABAP RAP business object persists leakage records, computes amount/percentage/cause, and owns a child recovery log.
- The CAP service is a Node.js side-by-side implementation for local SQLite or BTP HANA deployment.
- Fiori Elements consumes the OData V4 UI service; metadata extensions define list report and object page content.

## RAP business object
ZI_Profit_Leak is the root entity and composes ZI_Leak_Log. The managed behavior uses draft persistence, save validations, modify determinations and status-aware actions. ZC_Profit_Leak is the transactional projection. The service exposes the root, child and summary entity.

## BTP side-by-side
CAP can run independently beside SAP ERP on BTP. Configure destinations, XSUAA roles and connectivity in the target account; this repository does not include a deployed application or live ERP integration.

    ERP SD / MM / FI_CO facts
                 |
        expected vs actual
                 v
        leakage calculation
           /          \
      ABAP RAP        CAP
           \          /
            Fiori Elements
                  |
        recovery log / actions

Anomaly flag uses a simple z-score demonstration. It is statistical and AI/ML-ready by design wording only; it is not a trained model. All records are hypothetical.
