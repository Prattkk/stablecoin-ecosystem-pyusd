-- Project: Stablecoin Ecosystem Analysis (PYUSD) — Treasury Analyst
-- Metric: Activity by Wallet Category (Labeled Entities)
-- Business Question:
--   Which types of entities (CEX, DeFi, bridges, etc.) drive PYUSD activity?
-- Why This Matters:
--   Treasury teams want to know if usage is concentrated in exchanges/DeFi (market-driven)
--   versus broad payment-like participation. Categories also help assess counterparty exposure.

WITH participants AS (
  SELECT
    DATE_TRUNC('day', t.evt_block_time) AS day,
    t."from" AS wallet
  FROM erc20_ethereum.evt_Transfer t
  WHERE t.contract_address = FROM_HEX('6c3ea9036406852006290770bedfcaba0e23a0e8')
    AND t.evt_block_time >= CURRENT_DATE - INTERVAL '90' day

  UNION ALL

  SELECT
    DATE_TRUNC('day', t.evt_block_time) AS day,
    t."to" AS wallet
  FROM erc20_ethereum.evt_Transfer t
  WHERE t.contract_address = FROM_HEX('6c3ea9036406852006290770bedfcaba0e23a0e8')
    AND t.evt_block_time >= CURRENT_DATE - INTERVAL '90' day
),
labeled AS (
  SELECT
    p.day,
    COALESCE(l.category, 'unlabeled') AS wallet_category,
    p.wallet
  FROM participants p
  LEFT JOIN labels.addresses l
    ON l.blockchain = 'ethereum'
   AND l.address = p.wallet
)
SELECT
  wallet_category,
  COUNT(*) AS interactions,                 -- total labeled interactions (from/to appearances)
  COUNT(DISTINCT wallet) AS unique_wallets  -- breadth within category
FROM labeled
GROUP BY 1
ORDER BY interactions DESC;
