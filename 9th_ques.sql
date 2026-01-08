USE agri_ICMR;

SELECT
    State_Name,
    Dist_Name,
    Year,
    RICE_YIELD_Kg_per_ha AS rice_yield_kg_per_ha
FROM agridata
WHERE RICE_YIELD_Kg_per_ha > 0
ORDER BY RICE_YIELD_Kg_per_ha DESC
LIMIT 10;
