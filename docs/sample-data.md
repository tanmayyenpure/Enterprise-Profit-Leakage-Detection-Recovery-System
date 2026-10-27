# Hypothetical sample data

All twelve rows are hypothetical demo values in INR. Leakage is max((expected - actual) × quantity, 0). Leakage percent is the positive per-unit price difference divided by expected price, multiplied by 100.

| Leak ID | Module | Party | Product | Qty | Expected INR | Actual INR | Leakage INR | Root cause | Status |
|---|---|---|---|---:|---:|---:|---:|---|---|
| PL-2026-001 | SD | Customer A | P-100 | 50 | 1000 | 900 | 5000 | DISCOUNT_OVERRIDE | N |
| PL-2026-002 | SD | Customer B | P-110 | 20 | 500 | 500 | 0 | NONE | N |
| PL-2026-003 | SD | Customer C | P-120 | 15 | 800 | 760 | 600 | DISCOUNT_OVERRIDE | F |
| PL-2026-004 | SD | Customer D | P-130 | 40 | 250 | 220 | 1200 | DISCOUNT_OVERRIDE | R |
| PL-2026-005 | MM | Vendor A | RM-200 | 100 | 150 | 140 | 1000 | PRICE_VARIANCE | N |
| PL-2026-006 | MM | Vendor B | RM-210 | 25 | 200 | 205 | 0 | NONE | N |
| PL-2026-007 | MM | Vendor C | RM-220 | 60 | 75 | 70 | 300 | PRICE_VARIANCE | F |
| PL-2026-008 | MM | Vendor D | RM-230 | 12 | 1200 | 1100 | 1200 | PRICE_VARIANCE | R |
| PL-2026-009 | FI_CO | Customer E | REB-300 | 30 | 300 | 270 | 900 | REBATE_ERROR | N |
| PL-2026-010 | FI_CO | Customer F | REB-310 | 10 | 100 | 100 | 0 | NONE | N |
| PL-2026-011 | FI_CO | Customer G | REB-320 | 80 | 60 | 55 | 400 | REBATE_ERROR | F |
| PL-2026-012 | FI_CO | Customer H | REB-330 | 5 | 2500 | 2400 | 500 | REBATE_ERROR | R |

CSV fixture and ABAP seed-data source carry these sample transaction values. They are not actual company, customer or vendor records.
