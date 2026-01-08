USE agri_ICMR;

WITH recent_oilseed AS (
    SELECT
        State_Name,
        AVG(OILSEEDS_PRODUCTION_1000_tons) AS avg_recent_prod
    FROM agridata
    WHERE Year >= (SELECT MAX(Year) - 4 FROM agridata)
    GROUP BY State_Name
),
earlier_oilseed AS (
    SELECT
        State_Name,
        AVG(OILSEEDS_PRODUCTION_1000_tons) AS avg_earlier_prod
    FROM agridata
    WHERE Year < (SELECT MAX(Year) - 4 FROM agridata)
    GROUP BY State_Name
),
growth_calc AS (
    SELECT
        r.State_Name,
        r.avg_recent_prod,
        e.avg_earlier_prod,
        CASE
            WHEN e.avg_earlier_prod IS NULL OR e.avg_earlier_prod = 0 THEN NULL
            ELSE ((r.avg_recent_prod - e.avg_earlier_prod) / e.avg_earlier_prod) * 100
        END AS growth_rate_pct
    FROM recent_oilseed r
    LEFT JOIN earlier_oilseed e
        ON r.State_Name = e.State_Name
)
SELECT
    State_Name,
    avg_recent_prod      AS recent_avg_oilseed_prod_1000_tons,
    avg_earlier_prod     AS earlier_avg_oilseed_prod_1000_tons,
    growth_rate_pct      AS growth_rate_percent
FROM growth_calc
WHERE growth_rate_pct IS NOT NULL
ORDER BY growth_rate_pct DESC;
