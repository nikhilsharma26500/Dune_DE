WITH eth_volume AS (SELECT date_trunc('week', block_time) AS time,
    SUM(original_amount) AS eth_amount
    FROM nft.trades
    WHERE original_currency IN ('ETH','WETH')
    AND buyer != seller
    GROUP BY 1),
non_eth_volume AS (SELECT date_trunc('week', block_time) AS time,
    SUM(usd_amount) AS usd_amount
    FROM nft.trades
    WHERE original_currency NOT IN ('ETH','WETH')
    AND buyer != seller
    GROUP BY 1),
prices AS (SELECT date_trunc('week', minute) AS time,
    AVG(price) AS price
    FROM prices.usd
    WHERE symbol = 'WETH'
    GROUP BY 1),

sums AS (SELECT ev.time AS time,
SUM(ev.eth_amount*p.price) AS summed_eth_amount,
SUM(nev.usd_amount) AS summed_noneth_amount,
SUM(ev.eth_amount*p.price)+SUM(nev.usd_amount) AS summed_total
FROM eth_volume ev
JOIN non_eth_volume nev ON nev.time = ev.time
JOIN prices p ON p.time = ev.time
GROUP BY 1
ORDER BY 1)

SELECT time,
summed_total AS "Weekly Volume"
FROM sums
WHERE time > '2021-01-01'
GROUP BY 1, 2
ORDER BY time DESC
