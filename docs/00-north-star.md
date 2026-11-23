# North Star — what this warehouse exists to answer

> **Status:** Draft, grows phase by phase · **Phase:** Onda 0 · **Last updated:** 2026-11-23
>
> Every table, query and chart in this repository must trace back to a question in this document.
> A query that answers no question here is out of scope. A question with no requirement in
> [specs/REQUIREMENTS.md](../specs/REQUIREMENTS.md) is still a wish.

---

## 1. Why this document comes first

| Prompt-driven | Spec-driven (this project) |
|---|---|
| Start from the data and see what comes out | Start from the decisions a marketing team has to make |
| Metrics defined by whatever the first query returned | Metrics defined before the query, then checked against the data |
| "The funnel converts at 1.6%" | "1.6% of **users** bought, counted by `user_pseudo_id`, over 92 days" |

## 2. The main question

**Which channels and campaigns bring buyers, not just leads, and how long do they take to convert?**

## 3. The business, stated as decisions

Each question exists because someone has to decide something with the answer.

<!-- Q1 to Q5 follow the order of the Onda 0 card (2026-11-23). -->
<!-- "Cost of being wrong": fill in, in your own words, what goes wrong for the business if the answer is wrong. -->

| # | Question | Who asks | Decision it supports | Cost of being wrong |
|---|---|---|---|---|
| Q1 | Which channels bring buyers, not just visitors? | Head of marketing / paid media manager | Which channels to scale or cut by the buyers they bring, not by their traffic volume |  |
| Q2 | Where does the purchase funnel leak, by channel? | Growth / CRO manager | Fix the product page, the checkout or the payment step |  |
| Q3 | How long from first visit to first purchase, by channel? | CRM / lifecycle team | How long nurturing should last; which attribution window to use |  |
| Q4 | Which campaigns bring leads that never buy? | Performance marketing / CRM manager | Which campaigns to pause or rework because they fill the CRM but not the sales |  |
| Q5 | How much revenue per lead, per source? | Head of marketing and sales | How to split the budget across channels; cut channels that only bring cheap leads |  |
| Extra | Can we trust these numbers? | Analytics lead | Which numbers go to leadership with a caveat |  |

Metrics and data needed for each question:

| # | Metric | Data needed |
|---|---|---|
| Q1 | Buyer rate by channel: users who purchased ÷ users who arrived through the channel; share of buyers vs. share of visitors per channel (channel = the user's first source; the grouping rule is still open, §11) | GA4 traffic source + purchase events |
| Q2 | Step-to-step conversion (sessions): session_start → view_item → add_to_cart → begin_checkout → add_shipping_info → add_payment_info → purchase. Cuts: device, new vs. returning | GA4 events |
| Q3 | Median and distribution of days from first visit to first purchase | GA4 first_visit + purchase |
| Q4 | Leads per campaign; never-buy rate by campaign: leads with no purchase within the data window ÷ all leads of the campaign | Synthetic CRM leads (campaign) + identity map + GA4 purchases |
| Q5 | Revenue, orders, average order value, items per order, revenue per session. Cut: product category. Lead-to-buyer conversion rate; revenue per lead, by source; days from lead to purchase | GA4 purchase events + `items`; synthetic CRM leads + identity map |
| Extra | % sessions with unknown source; % purchases missing transaction_id, value, currency or items; duplicated transaction_ids; % leads with no match to a GA4 user | GA4 events + CRM leads |

## 4. Capability map

```
GA4 sample (BigQuery public) ──┐
                               ├─> bronze (raw) ─> silver (one row per entity) ─> gold (star schema) ─> dashboard
CRM leads (synthetic, Python) ─┘                         └─ lead ↔ user identity
```

## 5. Problems found in the data so far

Grows as profiling goes on. How each one is handled is decided when we reach it.

| Problem | Evidence |
|---|---|
| Only 92 days of data | F02 in [data-context.md](data-context.md) |
| Users with no `session_start` (1.1%) | [Finding 1](architecture/dataset-findings.md#finding-1) |
| Funnel steps that don't nest (`view_item_list`) | [Finding 2](architecture/dataset-findings.md#finding-2) |
| No lead event in GA4 | [Finding 3](architecture/dataset-findings.md#finding-3) |

## 6. Non-functional requirements

Only the rules already in practice. More are added when the layers are designed.

| ID | NFR | Target | How it is enforced |
|---|---|---|---|
| NFR-1 | Cost | Stay inside the BigQuery Sandbox free tier (1 TB/month) | No `SELECT *`; filter `_TABLE_SUFFIX` when the question allows; bytes processed recorded in every query header |
| NFR-2 | Traceability | Every number in a document points to the query that produced it | Fact IDs (F01…) shared by `docs/data-context.md` and `sql/exploration/` |
| NFR-3 | Language | One language for the public repository | English; the pt-BR summary is the only exception |

## 7. Known caveats

- **Q3, right censoring:** users who first visited in January had less time to buy, so time to purchase is biased
  downwards for late cohorts.
- **Q4, Q5 and part of the extra question, synthetic data:** the value of these questions is the pipeline (deduplication, identity),
  not the finding itself.
- **Q2, causes are out of reach:** the data shows *where* the funnel leaks, not *why* (no shipping cost or payment method data).

## 8. Definitions (filled as decisions are made)

| Term | Definition in this project | Decided in |
|---|---|---|
| Session | One distinct `user_pseudo_id` + `ga_session_id` pair | [Finding 1](architecture/dataset-findings.md#finding-1) |
| Channel | The user's first source (first touch), grouped into channels. The grouping rule (source / medium → channel) is written after F07–F10 | Decision log, 2026-11-23 |
| Campaign | | |
| Lead | | |
| Buyer | | |
| New vs. returning | | |
| Conversion window | | |

## 9. What "done" means

1. Every question (Q1–Q5 and the extra one) has a gold table and a chart, or a written reason why the data cannot answer it.
2. Every requirement in `specs/REQUIREMENTS.md` is `PASSING` or `WAIVED` with its reason.
3. Every contested decision has an ADR, and every change of plan has a decision-log entry.
4. Someone new to GA4 can read `docs/data-context.md` and explain the funnel numbers.

## 10. Non-goals

- **CAC / ROAS:** the sample has no cost data.
- **Data-driven attribution and conversion paths:** only exist in the GA4 interface, not in the export.
  Rule-based attribution (first / last / linear) is a later phase.
- **Internal search, promotions, coupons, margin, refunds:** off the lead-to-revenue thesis or not in the data.
- **GA4 vs. ecommerce platform revenue reconciliation:** no platform data available.
- **Day, hour and region:** not questions; they become dashboard filters.

## 11. Open decisions

- [x] Channel: user-level first source (first touch), not session-level source. Decided 2026-11-23 (decision log)
- [ ] Channel grouping rule: which source / medium pairs go into each channel (after F07–F10)
- [ ] Where the analysis funnel starts, given that `view_item_list` is barely tracked ([Finding 2](architecture/dataset-findings.md#finding-2))
- [ ] Funnel unit: user vs. session. The dataset overview uses users (did the user ever reach the step in 92 days).
      The Q2 funnel also needs a session version (did this visit reach the step). Compare both before choosing the main one.
- [ ] Lead ↔ GA4 user identity strategy
- [ ] Order grain vs. order-item grain in gold

## 12. Reading order for a reviewer

This document → [data-context.md](data-context.md) → [dataset-findings.md](architecture/dataset-findings.md) →
[REQUIREMENTS.md](../specs/REQUIREMENTS.md) → [traceability.md](../specs/traceability.md) → [adr/](adr/).
