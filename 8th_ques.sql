USE agri_ICMR;

SELECT
    State_Name,
    ROUND(SUM(OILSEEDS_AREA_1000_ha), 2) AS total_oilseeds_area_1000_ha
FROM agridata
WHERE OILSEEDS_AREA_1000_ha > 0
GROUP BY State_Name
ORDER BY total_oilseeds_area_1000_ha DESC;
