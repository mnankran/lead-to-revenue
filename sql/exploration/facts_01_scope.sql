-- =============================================================================
-- facts_01_scope.sql · A · Scope of the data
-- Answers F01 to F06 in docs/data-context.md
-- Source: bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*
-- =============================================================================


-- -----------------------------------------------------------------------------
-- F01, F02 · Period covered
-- Question: which dates does the sample cover, and how many days?
-- Finding:  2020-11-01 to 2021-01-31, 92 days. Nov (30) + Dec (31) + Jan (31) = 92,
--           so there is one table for every calendar day: no missing days.
-- Bytes processed: 40.97 MB
-- Run on:   2026-11-23
--
-- Why no _TABLE_SUFFIX filter here: we need every day, and BigQuery stores data by column.
-- Selecting only event_date scans one small column, not the whole table.
-- Dropped: total events and calendar months (F03). Not needed for any business question.
-- -----------------------------------------------------------------------------
SELECT
  MIN(PARSE_DATE('%Y%m%d', event_date)) AS first_day   -- F01
  , MAX(PARSE_DATE('%Y%m%d', event_date)) AS last_day  -- F01
  , COUNT(DISTINCT event_date) AS total_days           -- F02
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;


-- -----------------------------------------------------------------------------
-- F04 · Distinct users
-- Question: how many distinct user_pseudo_id are there?
-- Finding:  270,154 users. A user_pseudo_id is a browser/device, not a person:
--           the same person on phone and laptop counts as 2 users.
-- Bytes processed: 84.69 MB
-- Run on:   2026-11-23
-- -----------------------------------------------------------------------------
SELECT COUNT(DISTINCT user_pseudo_id) AS total_users  -- F04
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;


-- -----------------------------------------------------------------------------
-- F05 · Distinct sessions   (+ F22 · users per funnel step, same query)
-- Question: how many sessions (user_pseudo_id + ga_session_id) are there?
--           And how many distinct users reached each funnel step, at any time in the 92 days?
-- Finding:  360,129 sessions, 1.33 sessions per user.
--           267,116 users have a session_start: 3,038 users (1.1%) never fired one,
--           so counting session_start alone would miss sessions. The key is the safer definition.
--           Funnel by user: see F22 in data-context.md. view_item_list has only 44 users,
--           fewer than select_item (13,180): the list step is barely tracked in this sample.
-- Bytes processed: 949.09 MB (event_params is the heaviest column: the session key reads it)
-- Run on:   2026-11-23
--
-- Why one query: every column reads the same rows, so conditional counts (IF inside COUNT)
-- answer several facts in one scan instead of one query (and one scan) per fact.
-- Why the space in CONCAT: without a separator, user "12" + session "345" and
-- user "123" + session "45" would both become "12345".
-- -----------------------------------------------------------------------------
SELECT
  COUNT(DISTINCT user_pseudo_id) AS total_users,                                       -- F04
  COUNT(DISTINCT
    CONCAT(user_pseudo_id, ' ', CAST((SELECT value.int_value FROM UNNEST(event_params)
                                      WHERE key = 'ga_session_id') AS STRING))
  ) AS total_sessions,                                                                 -- F05
  COUNT(DISTINCT IF(event_name = 'session_start', user_pseudo_id, NULL)) AS users_session_start,          -- F05 check
  COUNT(DISTINCT IF(event_name = 'view_item_list', user_pseudo_id, NULL)) AS users_view_item_list,        -- F22
  COUNT(DISTINCT IF(event_name = 'select_item', user_pseudo_id, NULL)) AS users_select_item,              -- F22
  COUNT(DISTINCT IF(event_name = 'view_item', user_pseudo_id, NULL)) AS users_view_item,                  -- F22
  COUNT(DISTINCT IF(event_name = 'add_to_cart', user_pseudo_id, NULL)) AS users_add_to_cart,              -- F22
  COUNT(DISTINCT IF(event_name = 'begin_checkout', user_pseudo_id, NULL)) AS users_begin_checkout,        -- F22
  COUNT(DISTINCT IF(event_name = 'add_shipping_info', user_pseudo_id, NULL)) AS users_add_shipping_info,  -- F22
  COUNT(DISTINCT IF(event_name = 'add_payment_info', user_pseudo_id, NULL)) AS users_add_payment_info,    -- F22
  COUNT(DISTINCT IF(event_name = 'purchase', user_pseudo_id, NULL)) AS users_purchase                     -- F22
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;


-- -----------------------------------------------------------------------------
-- F06 · Event names
-- Question: which event_name values exist in the period?
-- Finding:  17 event names. The full purchase funnel is there, including shipping and payment steps
--           (view_item_list → select_item → view_item → add_to_cart → begin_checkout →
--           add_shipping_info → add_payment_info → purchase).
--           No lead event (no generate_lead, sign_up or login): confirms GA4 has no leads,
--           so the CRM leads table is needed. No refund or remove_from_cart either.
--           Counts per event are left to F11 (funnel steps).
-- Bytes processed: 53.36 MB
-- Run on:   2026-11-23
-- -----------------------------------------------------------------------------
SELECT DISTINCT event_name
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;
