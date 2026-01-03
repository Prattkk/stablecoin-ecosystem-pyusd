-- Project: Stablecoin Ecosystem Analysis (PYUSD) — Treasury Analyst
-- Metric: Daily Transfer Volume + Transaction Count
-- Business Question:
--   How much PYUSD moves on-chain each day, and how many transfers occur?
-- Why This Matters:
--   Daily volume indicates short-term adoption and liquidity; tx count shows usage intensity.

WITH transfers AS (
  SELECT
    evt_block_time AS block_time,
    value / 1e6 AS amount_pyusd  -- PYUSD has 6 decimals
  FROM erc20_ethereum.evt_Transfer
  WHERE contract_address = FROM_HEX('6c3ea9036406852006290770bedfcaba0e23a0e8')
    AND evt_block_time >= CAST('2023-08-01' AS TIMESTAMP) -- PYUSD launch window start
)
SELECT
  DATE_TRUNC('day', block_time) AS day,
  COUNT(*) AS tx_count,
  SUM(amount_pyusd) AS total_volume_pyusd
FROM transfers
GROUP BY 1
ORDER BY day;
