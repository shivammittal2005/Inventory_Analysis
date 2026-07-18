SELECT
    STRFTIME('%Y-%m', order_date) AS order_month,
    ROUND(SUM(order_quantity), 2) AS total_units_ordered,
    COUNT(DISTINCT sku_id) AS active_skus,
    ROUND(
        SUM(order_quantity) * 1.0 / COUNT(DISTINCT sku_id),
        2
    ) AS avg_units_per_active_sku
FROM past_orders
GROUP BY STRFTIME('%Y-%m', order_date)
ORDER BY order_month;
