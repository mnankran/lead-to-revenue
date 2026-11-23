# Traceability matrix

> Every requirement in [REQUIREMENTS.md](REQUIREMENTS.md) has exactly one row here.
> "I ran some queries" and "each requirement has evidence" are different claims. Only the second one is worth anything.

**Status legend:** `PASSING` (evidence exists and meets the acceptance criterion) · `PLANNED` (row registered,
evidence not yet produced) · `WAIVED` (not possible with this data; the reason is written down).

**Evidence** points to a query block (`file::fact`) or a document section.

| Requirement | Evidence | Kind | Status |
|---|---|---|---|
| EXP-001 | `sql/exploration/facts_01_scope.sql::F01,F02,F04,F05,F06` | exploration | PASSING |
| EXP-002 | `sql/exploration/facts_02_traffic.sql::F07-F10` | exploration | PLANNED |
| EXP-003 | `sql/exploration/facts_03_funnel.sql::F11,F12,F22` | exploration | PLANNED |
| EXP-004 | `sql/exploration/facts_04_purchases.sql::F13-F18` | exploration | PLANNED |
| EXP-005 | `sql/exploration/facts_05_products.sql::F19-F21` | exploration | PLANNED |

## Notes

- **EXP-003 is partly done:** F22 (users per funnel step) is measured; F11 and F12 are not. It stays `PLANNED` until all three are.
- **Rows for later phases** are added when their requirements are written (see "Domains still to be written" in REQUIREMENTS.md).
