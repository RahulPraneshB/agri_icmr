USE agri_ICMR;

WITH top_cotton_states AS (
    SELECT
        State_Name,
        AVG(COTTON_PRODUCTION_1000_tons) AS avg_cotton_prod
    FROM agridata
    WHERE COTTON_PRODUCTION_1000_tons > 0
    GROUP BY State_Name
    ORDER BY avg_cotton_prod DESC
    LIMIT 5
),
yearly_top_states AS (
    SELECT
        a.Year,
        a.State_Name,
        a.COTTON_PRODUCTION_1000_tons AS cotton_prod,
        LAG(a.COTTON_PRODUCTION_1000_tons) OVER (
            PARTITION BY a.State_Name 
            ORDER BY a.Year
        ) AS prev_year_prod
    FROM agridata a
    INNER JOIN top_cotton_states t ON a.State_Name = t.State_Name
    WHERE a.COTTON_PRODUCTION_1000_tons > 0
),
growth_calc AS (
    SELECT
        Year,
        State_Name,
        cotton_prod,
        prev_year_prod,
        CASE
            WHEN prev_year_prod > 0 THEN 
                ((cotton_prod - prev_year_prod) / prev_year_prod) * 100
            ELSE NULL
        END AS growth_rate_pct
    FROM yearly_top_states
)
SELECT
    Year,
    State_Name,
    ROUND(cotton_prod, 2) AS cotton_production_1000_tons,
    ROUND(growth_rate_pct, 2) AS year_over_year_growth_pct
FROM growth_calc
WHERE growth_rate_pct IS NOT NULL
ORDER BY Year, State_Name;
