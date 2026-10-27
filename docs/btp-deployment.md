# BTP deployment

1. Create a BTP trial subaccount with Cloud Foundry enabled. Install the Cloud Foundry CLI and MBT build tool from their official sources.
2. From cap/, authenticate with cf login -a <api-endpoint>, then select the intended org and space.
3. Configure HANA Cloud and make an HDI service plan available. The local CAP profile uses SQLite; the MTA resource declares HANA HDI.
4. Review MTA packaging for your landscape, then run mbt build and cf deploy mta_archives/enterprise-profit-leakage-system_1.0.0.mtar.
5. Verify the deployed CAP route and XSUAA binding. Create a role collection from the ProfitLeakUser role template and assign it to intended test users.
6. For a separate Fiori app, configure a destination pointing to the CAP HTTPS route, with authentication consistent with XSUAA and any launchpad-specific destination properties required by your architecture.
7. Verify authorization, service reads and recovery actions in the target space.

No BTP deployment has been performed. Adapt the MTA module packaging, database build configuration and service bindings for the target landscape before deployment.
