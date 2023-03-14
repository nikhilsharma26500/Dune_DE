WITH grouped_data AS (
SELECT date_trunc('week', block_time) AS time,
buyer,
seller,
buyer AS traders
FROM nft.trades
WHERE block_time > (date_trunc('week', now()) - interval '1 year')
-- by default block_time would be of the most recent data
AND buyer != seller
UNION
SELECT date_trunc('week', block_time) AS time,
NULL AS buyer,
NULL AS seller,
seller AS traders
FROM nft.trades
WHERE block_time > (date_trunc('week', now() - interval '1 year'))
AND block_time < (date_trunc('week', now()))
AND buyer != seller
)

SELECT time AS "Date",
COUNT(DISTINCT buyer) AS "Buyers",
COUNT(DISTINCT seller) AS "Sellers",
COUNT(DISTINCT traders) AS "Unique Traders"
FROM grouped_data
GROUP BY 1
ORDER BY 1