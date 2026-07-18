SELECT
    sku_id,
    avg_weekly_demand,
    peak_weekly_demand,
    sd_weekly_demand,
    coefficient_of_variation,
    cv_percentile,
    xyz_class
FROM v_xyz_classification
ORDER BY coefficient_of_variation ASC, sku_id;
