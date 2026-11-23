-- =============================================================================
-- facts_05_products.sql · E · Products
-- Answers F19 to F21 in docs/data-context.md
-- Source: bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*
-- Model: see facts_01_scope.sql (F01–F02)
-- =============================================================================


-- -----------------------------------------------------------------------------
-- F19 · Products and categories
-- Question: How many distinct items.item_id and items.item_category?
-- Hint: items is an array, so UNNEST(items).
-- Finding:
-- Bytes processed:
-- Run on:
-- -----------------------------------------------------------------------------
-- your query here


-- -----------------------------------------------------------------------------
-- F20 · Missing category
-- Question: What share of purchased items has category "(not set)" or empty?
-- Finding:
-- Bytes processed:
-- Run on:
-- -----------------------------------------------------------------------------
-- your query here


-- -----------------------------------------------------------------------------
-- F21 · Entry products
-- Question: How many distinct products appear in a user's first purchase?
-- Hint: ROW_NUMBER() or QUALIFY to find each user's first purchase (S3 window functions).
-- Finding:
-- Bytes processed:
-- Run on:
-- -----------------------------------------------------------------------------
-- your query here

-- -----------------------------------------------------------------------------
-- Top 10 products by revenue (table in data-context.md, section 5.5)
-- Question: which 10 products brought the most revenue, with category and units?
-- Finding:
-- Bytes processed:
-- Run on:
-- -----------------------------------------------------------------------------
-- your query here
