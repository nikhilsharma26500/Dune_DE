SELECT date, 
AVG(amount) OVER (ORDER BY date) AS ETH,
AVG(amount_usd) OVER (ORDER BY date) AS USD
FROM (
select 
date_trunc('day', block_time) date, 
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY original_amount) amount,
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY usd_amount) amount_usd
from
nft."trades"
WHERE original_currency = 'ETH'
GROUP BY 1
) AS a