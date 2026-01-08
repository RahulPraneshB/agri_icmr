USE agri_ICMR;

WITH yearly_state_prod AS (
    SELECT
        Year,
        State_Name,
        SUM(RICE_PRODUCTION_1000_tons) AS total_rice_production
    FROM agridata
    GROUP BY Year, State_Name
),
ranked_states AS (
    SELECT
        Year,
        State_Name,
        total_rice_production,
        DENSE_RANK() OVER (
            PARTITION BY Year
            ORDER BY total_rice_production DESC
        ) AS prod_rank
    FROM yearly_state_prod
)
SELECT
    Year,
    State_Name,
    total_rice_production
FROM ranked_states
WHERE prod_rank <= 3
ORDER BY
    Year,
    total_rice_production DESC;
