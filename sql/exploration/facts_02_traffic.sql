-- =============================================================================
-- facts_02_traffic.sql · B · Traffic
-- Answers F07 to F10 in docs/data-context.md
-- Source: bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*
-- Model: see facts_01_scope.sql (F01–F02)
-- =============================================================================


-- -----------------------------------------------------------------------------
-- F07 · Traffic sources (user first-touch)
-- Question: Distinct traffic_source.medium and traffic_source.source, and the share of "(data deleted)", "<Other>", "(none)"?
-- Finding:
-- Bytes processed:
-- Run on:
-- -----------------------------------------------------------------------------
-- your query here


-- -----------------------------------------------------------------------------
-- F08 · Session-level source
-- Question: Are source, medium, campaign present in event_params? On which events?
-- Hint: UNNEST(event_params) and look at the distinct keys per event_name. Filter a few days with _TABLE_SUFFIX.
-- Finding:
-- Bytes processed:
-- Run on:
-- -----------------------------------------------------------------------------
-- your query here


-- -----------------------------------------------------------------------------
-- F09 · Devices
-- Question: Which device.category values exist and what share of users each?
-- Finding:
-- Bytes processed:
-- Run on:
-- -----------------------------------------------------------------------------
-- your query here


-- -----------------------------------------------------------------------------
-- F10 · Countries
-- Question: How many countries (geo.country)? Top 5 by users?
-- Finding:
-- Bytes processed:
-- Run on:
-- -----------------------------------------------------------------------------
-- your query here
