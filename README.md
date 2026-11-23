# Lead-to-revenue — a marketing funnel warehouse on GA4 data in BigQuery

A marketing analytics warehouse built spec first: business questions before SQL, every number traced
to the query that produced it, and every decision recorded with the alternatives that were rejected.

> **The claim this repository makes:** a marketing dashboard is only as good as the definitions under it.
> This project shows the definitions (what a session, a channel and a buyer are), the evidence behind
> each one, and where the data cannot support a conclusion.

<!-- Write 2–3 lines in your own words: why this question matters to a marketing team.
     Use your real experience: the spreadsheets with VLOOKUP, the launches, the leads that never bought. -->

## The question

**Which channels and campaigns bring buyers, not just leads, and how long do they take to convert?**

1. Where does the purchase funnel leak, by channel?
2. Which channels and campaigns bring revenue, and at what order value?
3. How long from first visit to first purchase, by channel?
4. Which channels bring leads that become buyers, and how much revenue per lead?
5. Can we trust these numbers?
6. Which products bring first-time buyers, and do some entry products bring buyers who come back?

Each question is stated as the decision it supports in the [north star](docs/00-north-star.md).

## Architecture

<!-- Paste the photo/diagram of the bronze → silver → gold design here (docs/architecture/img/). -->

```
GA4 sample (BigQuery public) ──┐
                               ├─> bronze (raw) ─> silver (one row per entity) ─> gold (star schema) ─> dashboard
CRM leads (synthetic, Python) ─┘
```

Planned, not built. Table by table, with the grain of each: [layer-design.md](docs/architecture/layer-design.md).

---

## What is actually built, and what is not

This project is in its first phase. The table is split so that what is planned is never read as done.

**Built and measured:**

| Area | What it demonstrates | Evidence |
|---|---|---|
| **Dataset profile** | Period, users, sessions, event names and the funnel by user, each number traced to a query with its bytes processed: 92 days, 270,154 users, 360,129 sessions | [data-context.md](docs/data-context.md) |
| **Data findings** | Three findings that changed the design, e.g. 1.1% of users never fired `session_start`, so sessions are counted by key | [dataset-findings.md](docs/architecture/dataset-findings.md) |
| **Spec** | Six business questions and the requirements of the current phase (exploration) | [north star](docs/00-north-star.md) · [requirements](specs/REQUIREMENTS.md) |

**Not built.** Named rather than implied:

| Area | Status |
|---|---|
| Bronze, silver and gold layers | Designed on paper next ([layer-design.md](docs/architecture/layer-design.md)) |
| Channel definition | Open decision: user-level first source vs. session-level source |
| Synthetic CRM leads (Q4) | Planned for December 2026, generated in Python |
| dbt models and data tests | Planned from February 2027 |
| Looker Studio dashboard | Planned |
| CI (GitHub Actions) | Planned |

[`specs/traceability.md`](specs/traceability.md) is the authoritative count: **1 of 5 requirements proven.** Requirements for later phases are written when each phase starts.

---

## Leitura em português

🇧🇷 **[README.pt-BR.md](README.pt-BR.md)** — resumo executivo em português.

## Start here

Read in this order.

1. **[docs/00-north-star.md](docs/00-north-star.md)** — the six business questions, stated as the decisions they support,
   with caveats and non-goals.
2. **[docs/data-context.md](docs/data-context.md)** — the dataset in plain words: every concept and metric explained,
   and the measured numbers. Start here if you are new to GA4.
3. **[docs/architecture/dataset-findings.md](docs/architecture/dataset-findings.md)** — what the data showed that changed the plan.
4. **[specs/REQUIREMENTS.md](specs/REQUIREMENTS.md)** — numbered, checkable requirements.
5. **[specs/traceability.md](specs/traceability.md)** — requirement → evidence, with status.
6. **[docs/adr/](docs/adr/)** and **[docs/decision-log.md](docs/decision-log.md)** — contested decisions,
   and the chronological record of what changed and why.

---

## The dataset

**[GA4 obfuscated sample ecommerce](https://developers.google.com/analytics/bigquery/web-ecommerce-demo-dataset)**
(`bigquery-public-data.ga4_obfuscated_sample_ecommerce`): events from the Google Merchandise Store,
2020-11-01 to 2021-01-31, one table per day. Public, and it runs free on the BigQuery Sandbox.

Part of the values are obfuscated by Google (sources, campaigns, products), so some findings describe the sample,
not the real store.

GA4 has no leads. Q4 (leads that become buyers) uses a **synthetic CRM leads table**, dirty on purpose,
generated in Python. Its findings test the pipeline (deduplication, identity matching), not a real market.

Limits stated up front:

- **No cost data:** no CAC, no ROAS.
- **92 days only:** time to purchase is biased for users who arrived late, and repeat purchase may be too rare (Q6).
- **Users are not people:** `user_pseudo_id` is a browser cookie, so cross-device journeys split into several users.

---

## Reproduce

No setup beyond a Google account:

1. Open the [BigQuery console](https://console.cloud.google.com/bigquery) (Sandbox is enough).
2. Run any file in `sql/exploration/`. Each block's header records the finding, the bytes processed and the run date,
   so results can be compared.

---

## Repository layout

```
docs/
  00-north-star.md          business questions as decisions, caveats, NFRs, non-goals
  data-context.md           dataset guide: concepts, metrics, measured numbers
  decision-log.md           chronological, including every reversal
  adr/                      architecture decision records
  architecture/             dataset findings, layer design
specs/
  REQUIREMENTS.md           numbered, checkable requirements
  traceability.md           requirement -> evidence, with status
sql/
  exploration/              profiling queries; each fact ID (F01…) maps to a block here
data/                       nothing committed; source and terms in data/README.md
```

---

## Status

Built in phases. A phase closes only when its requirements move from `PLANNED` to `PASSING` in the traceability matrix.

As of 2026-11-23: **1 of 5 `PASSING`, 0 `WAIVED`, 4 `PLANNED`.** The dataset profile for scope and events is done;
traffic, purchases and products are next, then the layer design.

## Licence

Code: MIT ([LICENSE](LICENSE)). Data: GA4 obfuscated sample ecommerce, published by Google; source and terms in
[data/README.md](data/README.md).
