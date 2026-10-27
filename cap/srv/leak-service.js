const cds = require('@sap/cds');

const leakageFor = row => Math.max((Number(row.expectedPrice) - Number(row.actualPrice)) * Number(row.quantity), 0);
const rootCauseFor = (module, amount) => amount <= 0 ? 'NONE' : ({
  SD: 'DISCOUNT_OVERRIDE',
  MM: 'PRICE_VARIANCE',
  FI_CO: 'REBATE_ERROR'
}[module] || 'NONE');

module.exports = cds.service.impl(function () {
  const { ProfitLeaks, LeakLogs } = this.entities;

  const derive = row => {
    const amount = leakageFor(row);
    row.leakageAmount = amount;
    row.leakagePercent = Number(row.expectedPrice) > 0
      ? Math.max(Number(row.expectedPrice) - Number(row.actualPrice), 0) / Number(row.expectedPrice) * 100
      : 0;
    row.rootCause = rootCauseFor(row.sourceModule, amount);
  };

  this.before(['CREATE', 'UPDATE'], ProfitLeaks, req => {
    const entries = Array.isArray(req.data) ? req.data : [req.data];
    for (const row of entries) {
      const quantity = Number(row.quantity);
      const expected = Number(row.expectedPrice);
      const actual = Number(row.actualPrice);
      if (row.quantity !== undefined && (!Number.isFinite(quantity) || quantity <= 0)) {
        req.error(400, 'Quantity must be greater than zero.', 'quantity');
      }
      if ((row.expectedPrice !== undefined && (!Number.isFinite(expected) || expected < 0)) ||
          (row.actualPrice !== undefined && (!Number.isFinite(actual) || actual < 0))) {
        req.error(400, 'Prices must be zero or greater.');
      }
      if (['expectedPrice', 'actualPrice', 'quantity', 'sourceModule'].some(key => row[key] !== undefined)) derive(row);
      if (req.event === 'CREATE' && !row.status) row.status = 'N';
    }
  });

  const transition = async (req, from, to, text) => {
    const tx = cds.tx(req);
    const id = req.params[0].ID;
    const row = await tx.run(SELECT.one.from(ProfitLeaks).where({ ID: id }));
    if (!row) return req.reject(404, 'Leak record not found.');
    if (row.status !== from) return req.reject(409, 'Action is not valid for the current status.');
    await tx.run(UPDATE(ProfitLeaks).set({ status: to }).where({ ID: id }));
    await tx.run(INSERT.into(LeakLogs).entries({
      parent_ID: id, actionText: text, actionBy: req.user.id, actionAt: new Date()
    }));
    return { ...row, status: to };
  };

  this.on('flagForRecovery', ProfitLeaks, req => transition(req, 'N', 'F', 'Flagged for recovery'));
  this.on('markRecovered', ProfitLeaks, req => transition(req, 'F', 'R', 'Marked recovered'));

  this.on('READ', ProfitLeaks, async (req, next) => {
    const result = await next();
    const rows = Array.isArray(result) ? result : (result ? [result] : []);
    const values = rows.map(row => Number(row.leakagePercent || 0));
    const mean = values.length ? values.reduce((sum, value) => sum + value, 0) / values.length : 0;
    const deviation = Math.sqrt(values.length
      ? values.reduce((sum, value) => sum + (value - mean) ** 2, 0) / values.length
      : 0);
    for (const row of rows) {
      const z = deviation ? (Number(row.leakagePercent || 0) - mean) / deviation : 0;
      row.anomalyFlag = Math.abs(z) >= 2;
      row.anomalyLabel = 'statistical anomaly flag, AI/ML-ready';
    }
    return result;
  });
});
