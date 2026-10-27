# Functional mapping

| Source module | Example process meaning | Root cause when leakage is positive |
|---|---|---|
| SD | Sales actual price is below expected, such as an unauthorized discount | DISCOUNT_OVERRIDE |
| MM | Purchase price differs from the expected comparison price | PRICE_VARIANCE |
| FI/CO (FI_CO) | Rebate or settlement price is below the expected reference | REBATE_ERROR |

All modules use the same arithmetic: max((expected - actual) × quantity, 0). When leakage is zero, root cause is NONE. The model is a portfolio illustration and does not read source documents or claim actual business loss.
