USE agri_ICMR;

WITH crop_areas_prods AS (
    SELECT
        Dist_Name,
        AVG(RICE_AREA_1000_ha) AS rice_area,
        AVG(RICE_PRODUCTION_1000_tons) AS rice_prod,
        AVG(WHEAT_AREA_1000_ha) AS wheat_area,
        AVG(WHEAT_PRODUCTION_1000_tons) AS wheat_prod,
        AVG(MAIZE_AREA_1000_ha) AS maize_area,
        AVG(MAIZE_PRODUCTION_1000_tons) AS maize_prod
    FROM agridata
    WHERE RICE_AREA_1000_ha > 0 OR WHEAT_AREA_1000_ha > 0 OR MAIZE_AREA_1000_ha > 0
    GROUP BY Dist_Name
    HAVING rice_area > 0 OR wheat_area > 0 OR maize_area > 0
)
SELECT
    'Rice' AS crop,
    ROUND(
        (AVG(rice_area * rice_prod) - AVG(rice_area) * AVG(rice_prod)) /
        (STDDEV_POP(rice_area) * STDDEV_POP(rice_prod)),
        4
    ) AS correlation
FROM crop_areas_prods
WHERE rice_area > 0 AND rice_prod > 0

UNION ALL

SELECT
    'Wheat' AS crop,
    ROUND(
        (AVG(wheat_area * wheat_prod) - AVG(wheat_area) * AVG(wheat_prod)) /
        (STDDEV_POP(wheat_area) * STDDEV_POP(wheat_prod)),
        4
    ) AS correlation
FROM crop_areas_prods
WHERE wheat_area > 0 AND wheat_prod > 0

UNION ALL

SELECT
    'Maize' AS crop,
    ROUND(
        (AVG(maize_area * maize_prod) - AVG(maize_area) * AVG(maize_prod)) /
        (STDDEV_POP(maize_area) * STDDEV_POP(maize_prod)),
        4
    ) AS correlation
FROM crop_areas_prods
WHERE maize_area > 0 AND maize_prod > 0;