SELECT
    sku_id,
    abc_class,
    xyz_class,
    current_stock_qty,
    safety_stock,
    reorder_point,
    replenishment_gap,
    stock_status,
    annual_revenue,
    inventory_turnover
FROM v_sku_analysis
WHERE stock_status <> 'Healthy'
ORDER BY
    CASE stock_status
        WHEN 'Critical' THEN 1
        WHEN 'Reorder Required' THEN 2
        ELSE 3
    END,
    CASE abc_class
        WHEN 'A' THEN 1
        WHEN 'B' THEN 2
        ELSE 3
    END,
    replenishment_gap DESC;
