const cds = require('@sap/cds');
const { expect } = require('chai');

describe('Profit leakage service', () => {
  const { POST } = cds.test(__dirname + '/..');

  it('calculates amount, percentage, and cause on create', async () => {
    const response = await POST('/leak/ProfitLeaks', {
      leakID: 'TEST-001', sourceModule: 'SD', quantity: 50,
      expectedPrice: 1000, actualPrice: 900, currency: 'INR'
    });
    expect(Number(response.data.leakageAmount)).to.equal(5000);
    expect(Number(response.data.leakagePercent)).to.equal(10);
    expect(response.data.rootCause).to.equal('DISCOUNT_OVERRIDE');
  });

  it('rejects non-positive quantity', async () => {
    try {
      await POST('/leak/ProfitLeaks', {
        leakID: 'TEST-002', sourceModule: 'MM', quantity: 0,
        expectedPrice: 10, actualPrice: 9
      });
      throw new Error('Expected quantity validation error');
    } catch (error) {
      expect(error.response.status).to.equal(400);
    }
  });

  it('moves a new record through flagged to recovered', async () => {
    const created = await POST('/leak/ProfitLeaks', {
      leakID: 'TEST-003', sourceModule: 'FI_CO', quantity: 2,
      expectedPrice: 20, actualPrice: 10
    });
    const flagged = await POST('/leak/ProfitLeaks(' + created.data.ID + ')/LeakService.flagForRecovery');
    expect(flagged.data.status).to.equal('F');
    const recovered = await POST('/leak/ProfitLeaks(' + created.data.ID + ')/LeakService.markRecovered');
    expect(recovered.data.status).to.equal('R');
  });
});
