# Architecture Decision Records

A record exists when a decision was **contested**: a competent analyst could reasonably have chosen differently.
Choices with no real alternative get a line in the code, not an ADR. Smaller changes of plan go to
[decision-log.md](../decision-log.md).

## Format

Each ADR states: **Context → Options considered → Decision → Consequences → Reversal cost → Revisit trigger**.

"Reversal cost" asks how expensive it is to undo the decision. It sets how much analysis the decision deserves.

The fields match the decision format of the DNG study plan:

| Study plan field | ADR section |
|---|---|
| Question | Context |
| Options | Options considered |
| Choice | Decision |
| What I gave up | Consequences → Negative |
| How I would know I was wrong | Revisit trigger |

An ADR is written **when the decision is made**, in first person, by me. A superseded ADR is kept and marked
`Superseded by ADR-000N`, never deleted.

## Index

| ADR | Title | Status | Reversal cost |
|---|---|---|---|
| [0001](ADR-0001-dataset-ga4-plus-synthetic-leads.md) | Public GA4 sample plus a synthetic CRM leads table | Draft | — |
| [0002](ADR-0002-warehouse-bigquery.md) | BigQuery, not Databricks, for Project 1 | Draft | — |
