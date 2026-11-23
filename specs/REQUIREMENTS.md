# Requirements

> **Last updated:** 2026-11-23
>
> Requirements are written **phase by phase**, when the phase starts and its spec is approved, not all up front.
> Each one traces to a question in [docs/00-north-star.md](../docs/00-north-star.md) and has a row in
> [traceability.md](traceability.md). Each acceptance criterion is one observable check.

**Priority:** `MUST` (the project is wrong without it) · `SHOULD` (weaker without it) · `MAY` (stretch, cut first).

**ID scheme:** three-letter domain + number.

---

## EXP — Exploration (dataset profile) · current phase

| ID | Pri | Requirement | Acceptance criterion |
|---|---|---|---|
| EXP-001 | MUST | Profile the scope of the sample: period, days, users, sessions, event names | Facts F01, F02, F04, F05, F06 filled in `docs/data-context.md` §5.1, each with a query block holding Finding, Bytes processed and Run on |
| EXP-002 | MUST | Profile traffic sources | Facts F07–F10 filled, same rule |
| EXP-003 | MUST | Profile the funnel | Facts F11, F12, F22 filled, same rule |
| EXP-004 | MUST | Profile purchases | Facts F13–F18 filled, same rule |
| EXP-005 | SHOULD | Profile products | Facts F19–F20 filled, same rule |

---

## Domains still to be written

The shape of the project is known; the requirements are not written yet. Each domain gets its requirements
when its phase starts.

| Domain | What it will cover | Serves | Phase |
|---|---|---|---|
| MOD — Modelling | Tables of the bronze, silver and gold layers, with their grain | Q1–Q5, Extra | After the layer design ([layer-design.md](../docs/architecture/layer-design.md)) |
| MET — Metrics | One deliverable per business question | Q1–Q5 | After the modelling |
| QLT — Quality | The trust checks | Extra (data trust) | Alongside the modelling |
| CRM — Leads | The synthetic CRM leads table | Q4, Q5 | December 2026 |
| DSH — Dashboard | The Looker Studio dashboard | Q1–Q5, Extra | After the metrics |

---

## Change protocol

- Adding a requirement: add its row to `traceability.md` in the same commit.
- Removing or changing one: add a `docs/decision-log.md` entry saying why.
