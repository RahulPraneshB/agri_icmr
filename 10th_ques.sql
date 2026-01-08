USE agri_ICMR;

WITH top_wheat_states AS (
    SELECT State_Name,
           AVG(WHEAT_PRODUCTION_1000_tons) AS avg_wheat_prod
    FROM agridata
    WHERE WHEAT_PRODUCTION_1000_tons > 0
    GROUP BY State_Name
    ORDER BY avg_wheat_prod DESC
    LIMIT 5
),
recent_10_years AS (
    SELECT DISTINCT Year
    FROM agridata 
    WHERE Year >= (SELECT MAX(Year) - 9 FROM agridata)
),
wheat_rice_comparison AS (
    SELECT
        r.Year,
        t.State_Name,
        COALESCE(w.WHEAT_PRODUCTION_1000_tons, 0) AS wheat_prod_1000_tons,
        COALESCE(ri.RICE_PRODUCTION_1000_tons, 0) AS rice_prod_1000_tons
    FROM recent_10_years r
    CROSS JOIN top_wheat_states t
    LEFT JOIN agridata w 
        ON w.State_Name = t.State_Name AND w.Year = r.Year
    LEFT JOIN agridata ri 
        ON ri.State_Name = t.State_Name AND ri.Year = r.Year
)
SELECT
    Year,
    State_Name,
    ROUND(wheat_prod_1000_tons, 2) AS wheat_production,
    ROUND(rice_prod_1000_tons, 2) AS rice_production,
    ROUND(rice_prod_1000_tons - wheat_prod_1000_tons, 2) AS rice_minus_wheat_diff
FROM wheat_rice_comparison
ORDER BY Year, State_Name;
