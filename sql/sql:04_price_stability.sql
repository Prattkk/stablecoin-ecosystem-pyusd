-- Project: Stablecoin Ecosystem Analysis (PYUSD) — Treasury Analyst
-- Metric: Price Stability (Peg Tracking)
-- Business Question:
--   How tightly does PYUSD hold its ~$1 peg over the last 6 months?
-- Why This Matters:
--   A stable peg reduces settlement risk (treasury doesn’t want FX-like volatility during payment windows).

SELECT
  minute,
  price AS pyusd_price_usd
FROM prices.usd
WHERE contract_address = FROM_HEX('6c3ea9036406852006290770bedfcaba0e23a0e8')
  AND minute >= DATE_TRUNC('day', CURRENT_DATE - INTERVAL '6' month)
ORDER BY minute;
