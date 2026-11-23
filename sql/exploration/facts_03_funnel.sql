-- =============================================================================
-- facts_03_funnel.sql · C · Funnel
-- Answers F11, F12 and F22 in docs/data-context.md
-- Source: bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*
-- Model: see facts_01_scope.sql (F01–F02)
-- =============================================================================


-- -----------------------------------------------------------------------------
-- F11 · Funnel steps
-- Question: Do add_shipping_info and add_payment_info exist? How many events of each funnel step?
-- Hint: you may already have this from F06.
-- Finding:
-- Bytes processed:
-- Run on:
-- -----------------------------------------------------------------------------
-- your query here


-- -----------------------------------------------------------------------------
-- F12 · Missing session id
-- Question: What share of events has no ga_session_id?
-- Finding:
-- Bytes processed:
-- Run on:
-- -----------------------------------------------------------------------------
-- your query here


-- -----------------------------------------------------------------------------
-- F22 · Users per funnel step (dataset overview, user level)
-- The query lives in facts_01_scope.sql (F05 block): one scan answers F04, F05 and F22.
-- Session-level funnel (did this visit reach the step) comes later, with Q1.
-- -----------------------------------------------------------------------------
