USE agri_ICMR;

SELECT
    Year,
    ROUND(AVG(MAIZE_YIELD_Kg_per_ha), 2) AS avg_maize_yield_kg_per_ha
FROM agridata
WHERE MAIZE_YIELD_Kg_per_ha IS NOT NULL 
  AND MAIZE_YIELD_Kg_per_ha > 0
GROUP BY Year
ORDER BY Year ASC;
