-- Project: Stablecoin Ecosystem Analysis (PYUSD) — Treasury Analyst
-- Metric: Demonstrated Settlement Reliability (Success Rate)
-- Business Question:
--   What % of PYUSD-related transactions succeed on Ethereum over time?
-- Why This Matters:
--   Treasury needs confidence that payments settle reliably, especially during network stress.

WITH pyusd_txs AS (
  SELECT DISTINCT
    evt_tx_hash,
    MIN(evt_block_time) AS block_time
  FROM erc20_ethereum.evt_Transfer
  WHERE contract_address = FROM_HEX('6c3ea9036406852006290770bedfcaba0e23a0e8')
    AND evt_block_time >= CAST('2023-08-01' AS TIMESTAMP)
  GROUP BY 1
),
joined AS (
  SELECT
    DATE_TRUNC('day', p.block_time) AS day,
    t.success
  FROM pyusd_txs p
  JOIN ethereum.transactions t
    ON t.hash = p.evt_tx_hash
)
SELECT
  day,
  COUNT(*) AS total_txs,
  SUM(CASE WHEN success THEN 1 ELSE 0 END) AS successful_txs,
  ROUND(100.0 * SUM(CASE WHEN success THEN 1 ELSE 0 END) / COUNT(*), 2) AS success_rate_percent
FROM joined
GROUP BY 1
ORDER BY day;
