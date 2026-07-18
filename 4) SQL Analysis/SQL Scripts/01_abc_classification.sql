SELECT
    sku_id,
    annual_sales_qty,
    unit_price,
    annual_revenue,
    revenue_share_pct,
    cumulative_revenue_share_pct,
    abc_class
FROM v_abc_classification
ORDER BY annual_revenue DESC, sku_id;
