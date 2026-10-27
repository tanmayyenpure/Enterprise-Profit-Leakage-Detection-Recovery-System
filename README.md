# Enterprise Profit Leakage Detection & Recovery System

## Business problem
Organizations can silently lose margin through unauthorized sales discounts (SD), purchase price variance (MM), and rebate errors (FI/CO). The prototype compares expected and actual transaction prices, calculates positive leakage, assigns a module-based cause, and records recovery actions. All supplied records are hypothetical and use INR.

## What the app does
Leakage = max((expected price - actual price) × quantity, 0). The CAP and ABAP examples apply the same rule. A recovery flow moves records from New (N) to Flagged (F) to Recovered (R), with log entries.

## Features
### ABAP/RAP
- Managed RAP root business object with draft, child recovery log, validations, determinations and actions.
- CDS summary and value help, Fiori Elements metadata, OData V4 service.
- OO calculator, ABAP Unit examples and 12-row hypothetical seed-data source.

### CAP
- Node.js service with matching calculations and root-cause mapping.
- Input validation, recovery actions/logs, summary view and statistical anomaly flag.
- SQLite local profile, CSV data and cds.test examples.

## Tech stack
ABAP Cloud, OO ABAP, CDS, RAP with draft, ABAP Unit, ADT, ATC, Fiori Elements, OData V4, CAP, JavaScript, SAP BTP.

## Folder tree
enterprise-profit-leakage-system/
  README.md
  abap/src/
  cap/
  docs/

## Import ABAP and open Fiori preview
In ADT, connect to a compatible ABAP Cloud system and import objects under abap/src into a package, adapting the example package namespace if required. Activate in dependency order: tables, interface views, behaviors and implementation, projections/metadata, then service definition and binding. Run ATC with ABAP_CLOUD_DEVELOPMENT_DEFAULT. Publish the OData V4 UI binding and open its Fiori Elements preview from ADT. RAP syntax and service-binding serialization can vary by ABAP release, so review target-system activation messages.

## Run CAP locally
From cap/ run:
npm install
npx cds watch
npm test

SQLite is configured for local use. BTP deployment uses HANA HDI and XSUAA configuration described in docs/btp-deployment.md.

## Worked example
Expected ₹1,000; actual ₹900; quantity 50. Leakage = (1000 - 900) × 50 = ₹5,000. If expected is not greater than actual, leakage is zero.

## Status
Prototype. All included data is hypothetical.

Verification checklist (unchecked until performed in the target environment):
- [ ] ABAP objects imported and activated in ADT
- [ ] ATC run with ABAP_CLOUD_DEVELOPMENT_DEFAULT
- [ ] ABAP Unit run
- [ ] Fiori Elements preview opened
- [ ] CAP dependencies installed and service started locally
- [ ] CAP tests executed
- [ ] BTP deployment completed
