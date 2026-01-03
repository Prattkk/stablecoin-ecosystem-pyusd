-- Project: Stablecoin Ecosystem Analysis (PYUSD) — Treasury Analyst
-- Metric: Median & Average Transaction Fees (USD)
-- Business Question:
--   What does it cost (in USD) to execute PYUSD-related transactions on Ethereum?
-- Why This Matters:
--   Fees are see-through operating costs for payments. Median = typical cost; Avg captures congestion spikes.

WITH pyusd_txs AS (
  -- Use distinct tx hashes where a PYUSD transfer occurred
  SELECT DISTINCT
    evt_tx_hash,
    MIN(evt_block_time) AS block_time
  FROM erc20_ethereum.evt_Transfer
  WHERE contract_address = FROM_HEX('6c3ea9036406852006290770bedfcaba0e23a0e8')
    AND evt_block_time >= CAST('2023-08-01' AS TIMESTAMP)
  GROUP BY 1
),
tx_gas AS (
  SELECT
    DATE_TRUNC('day', p.block_time) AS day,
    (t.gas_used * t.gas_price) / 1e18 AS fee_eth, -- gas cost in ETH
    DATE_TRUNC('minute', p.block_time) AS minute
  FROM pyusd_txs p
  JOIN ethereum.transactions t
    ON t.hash = p.evt_tx_hash
),
eth_prices AS (
  SELECT
    minute,
    price AS eth_price_usd
  FROM prices.usd
  WHERE blockchain = 'ethereum'
    AND symbol = 'ETH'
)
SELECT
  g.day,
  AVG(g.fee_eth * ep.eth_price_usd) AS avg_fee_usd,
  APPROX_PERCENTILE(g.fee_eth * ep.eth_price_usd, 0.5) AS median_fee_usd,
  COUNT(*) AS tx_count
FROM tx_gas g
JOIN eth_prices ep
  ON ep.minute = g.minute
GROUP BY 1
ORDER BY g.day;
