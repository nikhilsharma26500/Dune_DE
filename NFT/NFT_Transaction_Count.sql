WITH grouped AS (SELECT
date_trunc('week', block_time) as time,
platform,
COUNT(*) AS tx_count
FROM nft.trades
WHERE buyer != seller
AND block_time > NOW() - interval '1 year'
AND block_time < NOW()
GROUP BY time, platform)

SELECT 
time,
platform,
SUM(tx_count) AS tx_counts
FROM grouped
GROUP BY time, platform