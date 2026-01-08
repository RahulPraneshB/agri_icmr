USE agri_ICMR;

WITH recent_wheat AS (
    SELECT
        Dist_Name,
        AVG(WHEAT_YIELD_Kg_per_ha) AS avg_recent_yield
    FROM agridata
    WHERE Year >= (SELECT MAX(Year) - 4 FROM agridata)
    GROUP BY Dist_Name
),
earlier_wheat AS (
    SELECT
        Dist_Name,
        AVG(WHEAT_YIELD_Kg_per_ha) AS avg_earlier_yield
    FROM agridata
    WHERE Year < (SELECT MAX(Year) - 4 FROM agridata)
    GROUP BY Dist_Name
),
yield_increase AS (
    SELECT
        r.Dist_Name,
        r.avg_recent_yield - COALESCE(e.avg_earlier_yield, 0) AS yield_increase
    FROM recent_wheat r
    LEFT JOIN earlier_wheat e ON r.Dist_Name = e.Dist_Name
)
SELECT
    Dist_Name,
    yield_increase
FROM yield_increase
WHERE yield_increase > 0
ORDER BY yield_increase DESC
LIMIT 5;
