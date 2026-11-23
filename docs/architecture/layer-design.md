# Layer design (bronze → silver → gold)

**Status:** Draft · **Owner:** Marco · **Phase:** Onda 0

## Goal

Draw, on paper first, which tables exist in each layer, the **grain** of each table (what one row means)
and how the layers connect. Take a photo of the drawing and save it in `docs/architecture/img/`.

## Sources

| Source | Where | Notes |
|---|---|---|
| GA4 events | `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` | Nested schema, one table per day, 2020-11-01 to 2021-01-31 |
| CRM leads | Synthetic, generated in Python (December 2026) | Dirty on purpose: emails, phones, duplicates |

## Bronze — raw, untouched

| Table | Grain (1 row = ...) | Notes |
|---|---|---|
| | | |

## Silver — clean, typed, deduplicated

| Table | Grain (1 row = ...) | Main transformations |
|---|---|---|
| | | |

## Gold — star schema for the funnel

| Table | Type (fact / dimension) | Grain (1 row = ...) | Answers which question (Q1–Q5, Extra) |
|---|---|---|---|
| | | | |

## The hard part: lead ↔ user identity

GA4 has `user_pseudo_id` and no email. The CRM has email and phone. How will a lead be linked to a GA4 user?
Write the options here and open an ADR ([docs/adr/](../adr/)).

## Open decisions

- [ ] Bronze as a view over the public dataset vs. a copy in my own dataset
- [ ] Date window: all 92 days vs. a smaller window (cost)
- [ ] Channel, lead ↔ user identity and order vs. order-item grain: see [north star §11](../00-north-star.md#11-open-decisions)
