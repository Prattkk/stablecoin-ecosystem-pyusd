## Methods
All analyses use Ethereum on-chain data filtered to the PYUSD ERC-20 contract.
Metrics are aggregated daily or weekly to identify trends in adoption, liquidity,
fees, and settlement reliability.

Transaction fees are computed using actual gas usage from `ethereum.transactions`
and converted to USD using ETH price data.

## Limitations
- Wallet labels are incomplete and may not classify all entities.
- Gas fees reflect full transaction cost, not just token transfer logic.
- On-chain data does not capture off-chain redemption or settlement processes.
