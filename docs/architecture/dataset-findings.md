# Dataset findings

What profiling the GA4 sample showed that **changed a decision**. Numbers that only describe the data live in
[data-context.md](../data-context.md); a finding is recorded here only when it changed the plan.

Each finding has three parts: **Measured** (exact numbers and the query), **Interpretation** (what it means, including
what is not yet known) and **What changed** (the requirement, definition or decision it affects).
A finding that turns out wrong is corrected in a dated note, never silently rewritten.

---

<a id="finding-1"></a>
## Finding 1 — 1.1% of users never fired `session_start`, so sessions are counted by key

**Measured.** One scan of all 92 days (`sql/exploration/facts_01_scope.sql`, F05 block, 949.09 MB, run 2026-11-23):

| | Users |
|---|---:|
| Distinct `user_pseudo_id` | 270,154 |
| … with at least one `session_start` | 267,116 |
| … with none | **3,038 (1.1%)** |

Distinct `user_pseudo_id` + `ga_session_id` pairs: **360,129 sessions**.

**Interpretation.** These users have other events, so they did visit. Only the event marking the start of the visit is
missing. The cause is not known yet. Two hypotheses:

- their session started on 2020-10-31, before the sample begins, so the `session_start` sits outside the data;
- the event was lost in collection or in Google's obfuscation of the sample.

The first predicts that their first event falls on 2020-11-01; the second predicts dates spread across the period.
Not yet checked.

**What changed.** A session is defined as a distinct `user_pseudo_id` + `ga_session_id` pair, not as a
`session_start` event ([north star §8](../00-north-star.md#8-definitions-filled-as-decisions-are-made)).
The gap itself is a data-quality fact for Q5.

---

<a id="finding-2"></a>
## Finding 2 — `view_item_list` is barely tracked, so the funnel cannot start at the list page

**Measured.** Same query, users per step over 92 days (F22):

| Step | Users |
|---|---:|
| `view_item_list` | **44** |
| `select_item` | 13,180 |
| `view_item` | 61,252 |

**Interpretation.** A user cannot click a product in a list (`select_item`) without seeing the list. Each of the first
three steps has more users than the one before, so they do not nest: the list step is almost never recorded in this sample.
`select_item` is also below `view_item`, because users reach product pages without a list (search, direct links, ads).

**What changed.** Opened a decision: where the analysis funnel starts
([north star §11](../00-north-star.md#11-open-decisions)). Not decided yet.

---

<a id="finding-3"></a>
## Finding 3 — GA4 has no lead event, so leads must come from a separate source

**Measured.** All 17 event names in the sample (`sql/exploration/facts_01_scope.sql`, F06, 53.36 MB, run 2026-11-23).
None of `generate_lead`, `sign_up` or `login` is among them.

**Interpretation.** In this store, a visitor goes straight from browsing to buying. There is no step where a visitor
becomes a known contact, so "leads that become buyers" cannot be measured from GA4 alone.

**What changed.** Confirms with data why the project needs a separate leads table
([ADR-0001](../adr/ADR-0001-dataset-ga4-plus-synthetic-leads.md), still to be written).

---

## Net effect on the plan

| Original plan | Revised |
|---|---|
| Count sessions by `session_start` or by key, either way | By key only (Finding 1) |
| Funnel from `view_item_list` to `purchase` | Open decision: where the funnel starts (Finding 2) |
| Leads table planned in the study plan | Confirmed by data: GA4 has no lead step (Finding 3) |
