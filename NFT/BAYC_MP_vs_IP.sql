WITH mp AS (
SELECT date_trunc('minute', evt_block_time) AS time, markPrice/power(10,10) AS mark_price FROM nftperp_beta_arbitrum.ClearingHouse_evt_PositionChanged
WHERE contract_address = lower('0x6fc05b7dfe545cd488e9d47d56cfaca88f69a2e1')
AND amm = lower('0x28d45df0d075f229adcbaff59bf90d39e80d875e')
AND evt_block_time >= now() - interval '2 months'
),
ip AS (
SELECT date_trunc('minute', evt_block_time) AS time, indexPrice/power(10,10) AS index_price FROM nftperp_beta_arbitrum.ClearingHouse_evt_FundingPayment
WHERE contract_address = lower('0x6fc05b7dfe545cd488e9d47d56cfaca88f69a2e1')
AND amm = lower('0xad7d8b1beaf28225bbdd7f76d2604decfd0b6013')
AND evt_block_time >= now() - interval '2 months'
)

SELECT coalesce(a.time, b.time) AS time, mark_price, index_price FROM mp a full OUTER JOIN ip b ON a.time = b.time
ORDER BY 1 ASC