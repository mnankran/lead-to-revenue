# Data context — read this before analysing anything

**Who this is for:** anyone who joins this project, technical or not. After reading it you should know
what data we have, what period it covers, how big it is, where the traffic comes from, how many purchases
happened, and what every metric in the dashboard means.

**Status:** structure ready, results pending (the queries run in the execution phase).
Every `—` below is a number that will come from a query.

| Section | What you'll find |
|---|---|
| [1. The dataset in one minute](#1-the-dataset-in-one-minute) | What the data is and where it comes from |
| [2. At a glance](#2-at-a-glance) | The key numbers on one table |
| [3. Concepts](#3-concepts-the-vocabulary-of-this-project) | Event, user, session, source, channel… in plain words |
| [4. Metrics](#4-metrics-what-we-measure-and-why) | Each metric: formula, why we use it, which question it answers |
| [5. Results](#5-results-what-the-data-looks-like) | The tables behind the numbers: period, traffic, funnel, purchases, products |
| [6. Limitations](#6-limitations-what-this-data-cannot-tell-us) | What this data cannot tell us |
| [7. Surprises](#7-surprises) | What contradicted what we expected. Those that changed a decision are in [dataset-findings.md](architecture/dataset-findings.md) |

---

## 1. The dataset in one minute

- **What it is:** the event data that Google Analytics 4 (GA4) collected from the **Google Merchandise Store**,
  an online shop that sells Google-branded products (t-shirts, mugs, bags).
- **Where it lives:** `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`, a public dataset
  anyone can query for free in BigQuery Sandbox.
- **"Obfuscated":** Google masked part of the values to protect the store's data. Some fields show
  placeholders like `(data deleted)` or `<Other>`. See [Concepts](#placeholders-not-set-data-deleted-other).
- **Shape:** one table per day (`events_20201101`, `events_20201102`…). Each row is one **event**.
- **Plus, in a later phase (December 2026):** a synthetic CRM leads table I generate in Python, dirty on purpose, to simulate the
  leads a marketing team collects in forms (GA4 has no leads).

## 2. At a glance

| Item | Value | Details |
|---|---|---|
| Period covered | 2020-11-01 to 2021-01-31 | [5.1 Scope](#51-scope) |
| Days covered | 92 (every calendar day, no gaps) | [5.1 Scope](#51-scope) |
| Users | 270,154 | [5.1 Scope](#51-scope) |
| Sessions | 360,129 (1.33 per user) | [5.1 Scope](#51-scope) |
| Orders (distinct transactions) | — | [5.4 Purchases](#54-purchases) |
| Revenue (USD) | — | [5.4 Purchases](#54-purchases) |
| Buyers | — | [5.4 Purchases](#54-purchases) |
| Repeat buyers (2+ orders) | — | [5.4 Purchases](#54-purchases) |
| Products / categories | — / — | [5.5 Products](#55-products) |
| Countries | — | [5.2 Traffic](#52-traffic) |

---

## 3. Concepts: the vocabulary of this project

Short definitions, in the order you meet them. "In the data" says where the concept lives in the GA4 tables.

### Event
Any interaction GA4 records: a page view, a product view, an add to cart, a purchase.
- **In the data:** one row = one event. `event_name` says which one, `event_timestamp` says when.
- **Why it matters:** everything else (sessions, funnels, purchases) is built by grouping events.

### User
A browser or device that visited the store, identified by an anonymous cookie.
- **In the data:** `user_pseudo_id`.
- **Careful:** a user is not a person. The same person on a phone and on a laptop counts as two users.
  Clearing cookies also creates a new user.

### Session
One visit to the store: the group of events of the same user until they stop interacting for
30 minutes (or the day changes).
- **In the data:** there is no session table. A session is the pair `user_pseudo_id` + `ga_session_id`
  (the second one is hidden inside `event_params`).
- **Why it matters:** it's the base of the funnel (Q1). "Of 100 visits, how many reached checkout?"

### First visit
The first time a user appears on the site.
- **In the data:** the `first_visit` event.
- **Why it matters:** it's the starting point of "how long until the first purchase" (Q3).

### Source, medium and campaign
Three labels that say where a visit came from:
- **Source:** the specific origin, e.g. `google`, `newsletter`, `instagram`.
- **Medium:** the type of traffic, e.g. `organic` (unpaid search), `cpc` (paid ads), `referral` (a link on
  another site), `email`, `(none)` (typed the address directly).
- **Campaign:** the name of the marketing action, e.g. `black_friday_2020`.

They usually come from **UTM parameters** in the link (`?utm_source=…&utm_medium=…&utm_campaign=…`).
- **In the data:** two levels, and they are not the same thing:
  - `traffic_source.*` = how the **user** arrived the very first time (first touch). Never changes.
  - `source` / `medium` / `campaign` inside `event_params` = how **this session** arrived. *(To confirm in [5.2 Traffic](#52-traffic).)*

### Channel
A bucket that groups source and medium into something a marketing team talks about:
Organic Search, Paid Search, Direct, Referral, Email, Social…
- **In the data:** it doesn't exist as a column. We build it with rules.
- **Why it matters:** it's the main cut of all six questions. **The exact rule is still open** (Decision Log).

### Funnel and funnel step
The ordered path to a purchase. In this project:
`session_start → view_item → add_to_cart → begin_checkout → add_shipping_info → add_payment_info → purchase`.
- **Why it matters:** comparing how many sessions reach each step shows where people give up (Q1).

### Transaction (order)
One completed purchase.
- **In the data:** a `purchase` event with an `ecommerce.transaction_id`.
- **Careful:** the same transaction can be recorded twice, and some ids are `(not set)` (see [5.4 Purchases](#54-purchases)).

### Item (product)
A product inside an event. One order can have several items.
- **In the data:** the `items` array (`item_id`, `item_name`, `item_category`, `price`, `quantity`).
- **Why it matters:** product questions (Q6) need one row per item bought, not per order.

### Buyer, first purchase and entry product
- **Buyer:** a user with at least one transaction.
- **First purchase:** a buyer's earliest transaction.
- **Entry product:** a product bought in that first purchase. "What brings people in?" (Q6)

### Lead
A person who left their contact (email, phone) in a form. Leads live in the **CRM**, not in GA4.
- **In the data:** the synthetic leads table (later phase).
- **Identity match:** linking a lead to a GA4 user. GA4 has no email, so this link is designed
  (Decision Log, decided when the leads table is built).

### Placeholders: `(not set)`, `(data deleted)`, `<Other>`
- `(not set)`: GA4 didn't receive the value (e.g. a link without UTM).
- `(data deleted)` and `<Other>`: values Google masked in this public sample.
- **Why it matters:** they are not channels or products. They are measured, never hidden (Q5).

### Project vocabulary
- **Grain:** what one row of a table means ("one row = one order"). The first question about any table.
- **Bronze / silver / gold:** the three layers of the warehouse. Bronze = raw, as received.
  Silver = clean and deduplicated. Gold = ready for analysis, in a star schema.
- **Fact table vs. this document:** a *fact table* (`fct_*`) is a gold-layer table of measurable events,
  like orders. This document is something else: a guide to the raw data.

---

## 4. Metrics: what we measure and why

| Metric | Formula | Why we use it | Question |
|---|---|---|---|
| Sessions | Count of distinct `user_pseudo_id` + `ga_session_id` | The volume of visits; denominator of most rates | Q1, Q2 |
| Step conversion rate | Sessions that reached step N ÷ sessions that reached step N−1 | Shows exactly where people give up | Q1 |
| Session conversion rate | Sessions with a purchase ÷ all sessions | One number to compare channels | Q1 |
| Revenue | Sum of `purchase_revenue_in_usd` over distinct transactions | What the channel brings in money | Q2 |
| Orders | Count of distinct `transaction_id` | Volume of purchases, without duplicates | Q2 |
| Average order value (AOV) | Revenue ÷ orders | A small channel with a high AOV can be worth more than a big one | Q2 |
| Revenue per session | Revenue ÷ sessions | Joins volume and value in one number | Q2 |
| Items per order | Items bought ÷ orders | Shows whether people buy one thing or a basket | Q2 |
| Time to first purchase | Days between `first_visit` and first purchase. We report the **median** | How long nurturing should last. Median because a few very slow buyers would distort the average | Q3 |
| Lead-to-buyer rate | Leads that became buyers ÷ all leads | The central question: channels that bring buyers, not just leads | Q4 |
| Days from lead to purchase | Days between lead creation and first purchase (median) | Same logic as Q3, starting from the lead | Q4 |
| Unknown source share | Sessions with `(not set)`, `(data deleted)` or `<Other>` source ÷ all sessions | How much of the traffic we can't attribute | Q5 |
| Incomplete purchase share | Purchases missing `transaction_id`, value, currency or items ÷ all purchases | How much of the revenue we can trust | Q5 |
| Duplicate transactions | Transaction ids recorded in more than one purchase event | Duplicates inflate revenue | Q5 |
| Identity match rate | Leads matched to a GA4 user ÷ all leads | Below a threshold, Q4 isn't reliable | Q4, Q5 |
| Entry product share | First purchases containing product X ÷ all first purchases | Which products bring people in | Q6 |
| Repeat purchase rate | Buyers with 2+ orders ÷ all buyers | Whether customers come back. **If too low, Q6 reports "not enough data"** | Q6 |
| View-to-purchase rate | Times a product was bought ÷ times it was viewed | Builds the product matrix (much viewed and little bought, and so on) | Q6 |

---

## 5. Results: what the data looks like

Each block shows the result table, a one-line reading, and the SQL file that produced it.
Result tables are filled in the execution phase.

> **What are F01, F02…?** A short code for each number, like a label. The same code appears in the SQL file,
> so if you doubt a number you can find the exact query behind it. Example: F01 here = the query marked
> `F01` in `sql/exploration/facts_01_scope.sql`.
> Codes are never renumbered: a dropped fact leaves a gap (F03, total events, was dropped as not needed).

### 5.1 Scope

Query: `sql/exploration/facts_01_scope.sql`

| Fact | Question | Result |
|---|---|---|
| F01 | First and last day | 2020-11-01 to 2021-01-31 |
| F02 | Days covered | 92 |
| F04 | Distinct users | 270,154 |
| F05 | Distinct sessions | 360,129 |
| F05 | Sessions per user (sessions ÷ users) | 1.33 |
| F05 | Users with no `session_start` event | 3,038 (1.1% of users) |

**Reading (F04, F05):** most users visit once: 1.33 sessions per user on average. About 1% of users never fired
`session_start`, so sessions are counted by the key (`user_pseudo_id` + `ga_session_id`), not by `session_start` events.


**F06 · Event names (17)**

| Group | event_name | What it means |
|---|---|---|
| Automatic | `first_visit` | The user's first visit ever to the site |
| Automatic | `session_start` | A new session started |
| Automatic | `page_view` | A page was loaded |
| Automatic | `user_engagement` | The page stayed in focus for a while (used to measure engaged time) |
| Automatic | `scroll` | The user scrolled to the bottom of a page (90% depth) |
| Automatic | `click` | The user clicked a link that leaves the site |
| Discovery | `view_search_results` | The user searched the store and saw results |
| Discovery | `view_promotion` | A promotion banner was shown |
| Discovery | `select_promotion` | The user clicked a promotion banner |
| Funnel 1 | `view_item_list` | A list of products was shown (category page, search results) |
| Funnel 2 | `select_item` | The user clicked a product in a list |
| Funnel 3 | `view_item` | The user opened a product page |
| Funnel 4 | `add_to_cart` | A product was added to the cart |
| Funnel 5 | `begin_checkout` | The user started checkout |
| Funnel 6 | `add_shipping_info` | The user filled in shipping |
| Funnel 7 | `add_payment_info` | The user filled in payment |
| Funnel 8 | `purchase` | The order was completed |

**Reading:** every step of the purchase funnel is tracked, including shipping and payment, so Q1 can show
exactly where people drop off. There is no lead event (`generate_lead`, `sign_up`, `login`): GA4 here has no leads,
which is why the project adds a CRM leads table. There is no `refund` or `remove_from_cart`, so revenue is gross
and cart abandonment can only be seen as "added but never bought". Event counts are in [5.3 Funnel](#53-funnel).

### 5.2 Traffic

Query: `sql/exploration/facts_02_traffic.sql`

**F07 · Where users first came from (first touch)**

| medium | source | Users | % of users |
|---|---|---|---|
| — | — | — | — |

**F08 · Is there a session-level source?** — (yes/no, on which events)

**F09 · Devices**

| device.category | Users | % of users |
|---|---|---|
| — | — | — |

**F10 · Top 5 countries**

| Country | Users | % of users |
|---|---|---|
| — | — | — |

**Reading:** —

### 5.3 Funnel

Query: `sql/exploration/facts_03_funnel.sql`

**F11 · Events per funnel step**

| Step | event_name | Events | Sessions |
|---|---|---|---|
| 1 | session_start | — | — |
| 2 | view_item | — | — |
| 3 | add_to_cart | — | — |
| 4 | begin_checkout | — | — |
| 5 | add_shipping_info | — | — |
| 6 | add_payment_info | — | — |
| 7 | purchase | — | — |

| Fact | Question | Result |
|---|---|---|
| F12 | Events with no `ga_session_id` | — % |

**F22 · Users per funnel step (whole period)**

Counts distinct users who did the step **at any time in the 92 days**, not necessarily in the same visit.
Query: `sql/exploration/facts_01_scope.sql` (F05 block).

| Step | event_name | Users | % of previous step | % of all users |
|---|---|---|---|---|
| 1 | view_item_list | 44 | — | 0.02% |
| 2 | select_item | 13,180 | n/a | 4.9% |
| 3 | view_item | 61,252 | n/a | 22.7% |
| 4 | add_to_cart | 12,545 | 20.5% | 4.6% |
| 5 | begin_checkout | 9,715 | 77.4% | 3.6% |
| 6 | add_shipping_info | 9,714 | 100.0% | 3.6% |
| 7 | add_payment_info | 5,751 | 59.2% | 2.1% |
| 8 | purchase | 4,419 | 76.8% | 1.6% |

**Reading:** 1.6% of users bought something. The biggest loss is from product page to cart: about 4 in 5 users who
viewed a product never added it. The second is at payment: 41% of users who filled shipping did not fill payment.
Steps 1 to 3 don't nest (each has more users than the one before), so the funnel for analysis starts at `view_item`.
`add_shipping_info` matches `begin_checkout` almost exactly (9,714 vs. 9,715): the two may fire together. To check.

**Reading (F11, F12):** —

### 5.4 Purchases

Query: `sql/exploration/facts_04_purchases.sql`

| Fact | Question | Result |
|---|---|---|
| F13 | `purchase` events | — |
| F14 | Distinct transactions / `(not set)` | — / — |
| F15 | Duplicated transaction ids | — |
| F16 | Revenue and currency | — USD |
| F17 | Buyers | — |
| F18 | Buyers with 2+ orders | — (— % of buyers) |

**Orders per month**

| Month | Orders | Revenue (USD) | Buyers |
|---|---|---|---|
| — | — | — | — |

**Reading:** —

### 5.5 Products

Query: `sql/exploration/facts_05_products.sql`

| Fact | Question | Result |
|---|---|---|
| F19 | Distinct products / categories | — / — |
| F20 | Items bought with no category | — % |
| F21 | Distinct products in first purchases | — |

**Top 10 products by revenue**

| Product | Category | Units | Revenue (USD) |
|---|---|---|---|
| — | — | — | — |

**Reading:** —

### 5.6 CRM leads (later phase)

Query: `sql/exploration/facts_06_leads.sql`

| Fact | Question | Result |
|---|---|---|
| F30 | Rows in the raw leads table | — |
| F31 | Duplicated leads (same normalized email) | — |
| F32 | Leads with no match to a GA4 user | — |

**Reading:** —

---

## 6. Limitations: what this data cannot tell us

- **No cost data:** no CAC, no ROAS.
- **92 days only:** time to purchase is biased for users who arrived late; repeat purchase may be too rare (Q6).
- **Obfuscated values:** part of sources, campaigns and products are masked.
- **Users are not people:** cross-device journeys are split into different users.
- **Leads are synthetic:** Q4 tests the pipeline, not a real market.
- **List views barely tracked:** only 44 users have `view_item_list`, so the funnel can't start at the category page.
- **Where, not why:** the funnel shows where people give up, not the reason (no shipping or payment data).

## 7. Surprises

When a surprise changes a decision, it also becomes a numbered finding in
[architecture/dataset-findings.md](architecture/dataset-findings.md), with what changed.

<!-- Date + fact + one line. Example:
     2026-11-28 · F14 · 40% of purchases have transaction_id "(not set)". Q2 needs a rule for that. -->

- 2026-11-23 · F05 · 3,038 users (1.1%) never fired `session_start`. Sessions must be counted by the key, not by that event.
  Cause not known yet. Hypotheses: (a) their session started on 2020-10-31, before the sample begins;
  (b) the event was lost in collection or in the obfuscation of the sample. To check: date of their first event
  and which events they have.
- 2026-11-23 · F22 · Only 44 users have `view_item_list`, but 13,180 have `select_item`. The list step is barely tracked.
- 2026-11-23 · F22 · `add_shipping_info` (9,714 users) ≈ `begin_checkout` (9,715). They may fire together; check with events per session.

---

### How to update this document

1. Run the query in `sql/exploration/facts_*.sql` and write the finding, bytes processed and date in its header.
2. Fill the result table here and write one line of **Reading** (what it means, in plain words).
3. If something surprised you, add it to Surprises. If it changed a decision, add a finding to `architecture/dataset-findings.md`.
4. If a number changes later, update it and note the date. Don't silently overwrite.
