# Exploration queries

Queries used to understand the GA4 sample before designing the layers. Not part of the pipeline.

Naming: `NN_short_description.sql` (e.g. `01_events_per_day.sql`, `02_sessions_by_channel.sql`).

Every file starts with a header:

```sql
-- Question: what I wanted to find out
-- Finding: what I found (fill in after running)
-- Bytes processed: X MB
```

Two kinds of files live here:

- `facts_NN_<group>.sql` — small queries that answer the questions in [docs/data-context.md](../../docs/data-context.md).
  `facts_01_scope.sql` has a worked example (F01–F02) to use as a model.
- `NN_short_description.sql` — analysis queries. The first funnel-by-channel query (S6) is `10_funnel_by_channel.sql`.
