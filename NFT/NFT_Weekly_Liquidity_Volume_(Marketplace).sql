WITH seperated_data AS (
SELECT
date_trunc('week', block_time) AS "dates",
(CASE WHEN platform = 'OpenSea' THEN SUM(usd_amount) END) AS "OpenSea",
(CASE WHEN platform = 'Rarible' THEN SUM(usd_amount) END) AS "Rarible",
(CASE WHEN platform = 'SuperRare' THEN SUM(usd_amount) END) AS "SuperRare",
(CASE WHEN platform = 'LarvaLabs' THEN SUM(usd_amount) END) AS "LarvaLabs",
(CASE WHEN platform = 'Foundation' THEN SUM(usd_amount) END) AS "Foundation",
(CASE WHEN platform = 'LooksRare' THEN SUM(usd_amount) END) AS "LooksRare"
FROM nft.trades
WHERE block_time > now() - interval '1 year'
AND buyer != seller
AND tx_hash NOT IN ('\x92488a00dfa0746c300c66a716e6cc11ba9c0f9d40d8c58e792cc7fcebf432d0',
                    '\x0831db6af74c935724b82d72f0ccd269bf428004ff3da2b3d90c310ebe886af0')
GROUP BY dates, platform
ORDER BY dates, platform
)

SELECT dates AS "Date",
SUM("OpenSea") AS "OpenSea",
SUM("Rarible") AS "Rarible",
SUM("SuperRare") AS "SuperRare",
SUM("LarvaLabs") AS "LarvaLabs",
SUM("Foundation") AS "Foundation",
CASE WHEN dates = '2021-12-27' THEN NULL ELSE SUM("LooksRare") END AS "LooksRare"
FROM seperated_data
GROUP BY "Date"
ORDER BY "Date"