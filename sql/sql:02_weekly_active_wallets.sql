-- Project: Stablecoin Ecosystem Analysis (PYUSD) — Treasury Analyst
-- Metric: Weekly Active Wallets
-- Business Question:
--   How many unique wallets interact with PYUSD each week?
-- Why This Matters:
--   Active wallets measure adoption breadth (how many participants), not just volume by a few whales.

WITH addrs AS (
  SELECT
    DATE_TRUNC('week', evt_block_time) AS week,
    "from" AS wallet
  FROM erc20_ethereum.evt_Transfer
  WHERE contract_address = FROM_HEX('6c3ea9036406852006290770bedfcaba0e23a0e8')
    AND evt_block_time >= CAST('2023-08-07' AS TIMESTAMP)

  UNION ALL

  SELECT
    DATE_TRUNC('week', evt_block_time) AS week,
    "to" AS wallet
  FROM erc20_ethereum.evt_Transfer
  WHERE contract_address = FROM_HEX('6c3ea9036406852006290770bedfcaba0e23a0e8')
    AND evt_block_time >= CAST('2023-08-07' AS TIMESTAMP)
)
SELECT
  week,
  COUNT(DISTINCT wallet) AS active_wallets
FROM addrs
GROUP BY 1
ORDER BY week;
