# Decision log

Chronological and append-only. One entry each time the plan changed, with what forced the change.
Contested decisions get a full record in [adr/](adr/); this log records **when** and **why** things moved.

Entry format:

```
### YYYY-MM-DD — <the outcome, as a sentence>

**Forced by:** <one line: the evidence or event that triggered it>

<2–5 short paragraphs: what happened, what was rejected and why, numbers if any.>

See: <ADR or finding link>
```

Prefixes in the title when they apply: **Reversal:** · **Correction:** · **Deferred:**.
Corrections never overwrite: the original entry stays, and a new one explains what changed.

---

The first decision of the project, the data source, is recorded in
[ADR-0001](adr/ADR-0001-dataset-ga4-plus-synthetic-leads.md).

<!-- Entries to write (in first person, in English). The title and "Forced by" are drafted; the reasoning is yours.

### 2026-11-22 — The product question (Q6) is core, with a fallback if repeat purchase is too rare
**Forced by:** the brainstorm of business questions; entry products matter for ad offers.

### 2026-11-23 — Total events and calendar months dropped from the dataset profile
**Forced by:** running F01–F03; no business question uses those numbers.

### 2026-11-23 — Sessions are counted by user_pseudo_id + ga_session_id, not by session_start
**Forced by:** Finding 1 — 3,038 users (1.1%) never fired session_start.
See: architecture/dataset-findings.md#finding-1

### 2026-11-23 — The dataset overview is by user; the session funnel waits for Q1
**Forced by:** wanting general numbers first; the funnel unit is still an open decision.

-->
