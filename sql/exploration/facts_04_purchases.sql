-- =============================================================================
-- facts_04_purchases.sql · D · Purchases
-- Answers F13 to F18 in docs/data-context.md
-- Source: bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*
-- Model: see facts_01_scope.sql (F01–F02)
-- =============================================================================


-- -----------------------------------------------------------------------------
-- F13 · Purchase events
-- Question: How many purchase events?
-- Finding:
-- Bytes processed:
-- Run on:
-- -----------------------------------------------------------------------------
-- your query here


-- -----------------------------------------------------------------------------
-- F14 · Transaction ids
-- Question: How many distinct ecommerce.transaction_id, and how many are "(not set)"?
-- Finding:
-- Bytes processed:
-- Run on:
-- -----------------------------------------------------------------------------
-- your query here


-- -----------------------------------------------------------------------------
-- F15 · Duplicated transactions
-- Question: Which transaction_id appear in more than one purchase event?
-- Hint: GROUP BY + HAVING.
-- Finding:
-- Bytes processed:
-- Run on:
-- -----------------------------------------------------------------------------
-- your query here


-- -----------------------------------------------------------------------------
-- F16 · Revenue
-- Question: Total revenue (ecommerce.purchase_revenue_in_usd) and currency values?
-- Finding:
-- Bytes processed:
-- Run on:
-- -----------------------------------------------------------------------------
-- your query here


-- -----------------------------------------------------------------------------
-- F17 · Buyers
-- Question: How many distinct users made at least one purchase?
-- Finding:
-- Bytes processed:
-- Run on:
-- -----------------------------------------------------------------------------
-- your query here


-- -----------------------------------------------------------------------------
-- F18 · Repeat buyers
-- Question: How many users have 2 or more distinct transactions?
-- Decide what to do with "(not set)" transaction ids before counting. That choice is a Decision Log entry.
-- Finding:
-- Bytes processed:
-- Run on:
-- -----------------------------------------------------------------------------
-- your query here

-- -----------------------------------------------------------------------------
-- Orders per month (table in data-context.md, section 5.4)
-- Question: orders, revenue and buyers by month?
-- Finding:
-- Bytes processed:
-- Run on:
-- -----------------------------------------------------------------------------
-- your query here
