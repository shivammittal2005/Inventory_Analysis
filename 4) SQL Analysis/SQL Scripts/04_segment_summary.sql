SELECT
    abc_class,
    xyz_class,
    COUNT(*) AS sku_count,
    ROUND(SUM(annual_revenue), 2) AS total_annual_revenue,
    ROUND(SUM(value_in_warehouse), 2) AS total_inventory_value,
    SUM(CASE WHEN stock_status <> 'Healthy' THEN 1 ELSE 0 END) AS skus_needing_replenishment,
    ROUND(AVG(inventory_turnover), 4) AS avg_inventory_turnover
FROM v_sku_analysis
GROUP BY abc_class, xyz_class
ORDER BY abc_class, xyz_class;
