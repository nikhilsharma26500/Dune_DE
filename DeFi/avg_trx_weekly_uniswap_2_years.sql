SELECT
count(*),
AVG(usd_amount) AS USD,
date_trunc('week', block_time) AS time
FROM dex.trades 
WHERE "token_a_address" = '\x5dbcf33d8c2e976c6b560249878e6f1491bca25c' 
AND block_time <= '2022-01-01'
AND block_time > '2020-08-1'
GROUP BY time
order by time desc