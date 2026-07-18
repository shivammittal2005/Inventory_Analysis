-- Inventory Analysis: reusable SQL views
-- SQLite-compatible. Run this once after importing stock.csv and past_orders.csv.

DROP VIEW IF EXISTS v_sku_analysis;
DROP VIEW IF EXISTS v_inventory_metrics;
DROP VIEW IF EXISTS v_xyz_classification;
DROP VIEW IF EXISTS v_sku_demand_metrics;
DROP VIEW IF EXISTS v_weekly_demand;
DROP VIEW IF EXISTS v_week_calendar;
DROP VIEW IF EXISTS v_abc_classification;
DROP VIEW IF EXISTS v_sku_annual_metrics;
DROP VIEW IF EXISTS v_analysis_period;

CREATE VIEW v_analysis_period AS
SELECT
    MAX(order_date) AS max_order_date,
    DATE(MAX(order_date), '-364 day') AS analysis_start_date
FROM past_orders;

CREATE VIEW v_sku_annual_metrics AS
SELECT
    s.sku_id,
    s.current_stock_qty,
    s.unit_type,
    s.avg_lead_time_days,
    s.max_lead_time_days,
    s.unit_price,
    COALESCE(SUM(
        CASE
            WHEN p.order_date BETWEEN ap.analysis_start_date AND ap.max_order_date
            THEN p.order_quantity
            ELSE 0
        END
    ), 0) AS annual_sales_qty,
    ROUND(
        COALESCE(SUM(
            CASE
                WHEN p.order_date BETWEEN ap.analysis_start_date AND ap.max_order_date
                THEN p.order_quantity
                ELSE 0
            END
        ), 0) * s.unit_price,
        2
    ) AS annual_revenue
FROM stock AS s
CROSS JOIN v_analysis_period AS ap
LEFT JOIN past_orders AS p
    ON p.sku_id = s.sku_id
GROUP BY
    s.sku_id,
    s.current_stock_qty,
    s.unit_type,
    s.avg_lead_time_days,
    s.max_lead_time_days,
    s.unit_price;

CREATE VIEW v_abc_classification AS
WITH ranked AS (
    SELECT
        sam.*,
        SUM(annual_revenue) OVER (
            ORDER BY annual_revenue DESC, sku_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue,
        SUM(annual_revenue) OVER () AS total_revenue
    FROM v_sku_annual_metrics AS sam
)
SELECT
    *,
    ROUND(
        CASE WHEN total_revenue = 0 THEN 0
             ELSE 100.0 * annual_revenue / total_revenue
        END,
        4
    ) AS revenue_share_pct,
    ROUND(
        CASE WHEN total_revenue = 0 THEN 0
             ELSE 100.0 * cumulative_revenue / total_revenue
        END,
        4
    ) AS cumulative_revenue_share_pct,
    CASE
        WHEN total_revenue = 0 THEN 'C'
        WHEN 100.0 * cumulative_revenue / total_revenue <= 70 THEN 'A'
        WHEN 100.0 * cumulative_revenue / total_revenue <= 90 THEN 'B'
        ELSE 'C'
    END AS abc_class
FROM ranked;

CREATE VIEW v_week_calendar AS
WITH RECURSIVE week_numbers(n) AS (
    SELECT 0
    UNION ALL
    SELECT n + 1
    FROM week_numbers
    WHERE n < 51
)
SELECT
    n + 1 AS week_number,
    DATE(ap.max_order_date, '-' || ((51 - n) * 7 + 6) || ' day') AS week_start,
    DATE(ap.max_order_date, '-' || ((51 - n) * 7) || ' day') AS week_end
FROM week_numbers
CROSS JOIN v_analysis_period AS ap;

CREATE VIEW v_weekly_demand AS
SELECT
    s.sku_id,
    wc.week_number,
    wc.week_start,
    wc.week_end,
    COALESCE(SUM(p.order_quantity), 0) AS weekly_demand
FROM stock AS s
CROSS JOIN v_week_calendar AS wc
LEFT JOIN past_orders AS p
    ON p.sku_id = s.sku_id
   AND p.order_date BETWEEN wc.week_start AND wc.week_end
GROUP BY
    s.sku_id,
    wc.week_number,
    wc.week_start,
    wc.week_end;

CREATE VIEW v_sku_demand_metrics AS
WITH base AS (
    SELECT
        sku_id,
        AVG(weekly_demand) AS avg_weekly_demand,
        MAX(weekly_demand) AS peak_weekly_demand,
        AVG(weekly_demand * weekly_demand) AS avg_squared_demand
    FROM v_weekly_demand
    GROUP BY sku_id
)
SELECT
    sku_id,
    ROUND(avg_weekly_demand, 4) AS avg_weekly_demand,
    ROUND(peak_weekly_demand, 4) AS peak_weekly_demand,
    ROUND(
        SQRT(
            MAX(avg_squared_demand - avg_weekly_demand * avg_weekly_demand, 0)
        ),
        4
    ) AS sd_weekly_demand,
    ROUND(
        CASE
            WHEN avg_weekly_demand = 0 THEN 9999
            ELSE SQRT(
                MAX(avg_squared_demand - avg_weekly_demand * avg_weekly_demand, 0)
            ) / avg_weekly_demand
        END,
        4
    ) AS coefficient_of_variation
FROM base;

CREATE VIEW v_xyz_classification AS
WITH ranked AS (
    SELECT
        sdm.*,
        PERCENT_RANK() OVER (
            ORDER BY coefficient_of_variation ASC, sku_id
        ) AS cv_percent_rank
    FROM v_sku_demand_metrics AS sdm
)
SELECT
    *,
    ROUND(100.0 * cv_percent_rank, 2) AS cv_percentile,
    CASE
        WHEN cv_percent_rank <= 0.20 THEN 'X'
        WHEN cv_percent_rank <= 0.50 THEN 'Y'
        ELSE 'Z'
    END AS xyz_class
FROM ranked;

CREATE VIEW v_inventory_metrics AS
SELECT
    a.sku_id,
    a.current_stock_qty,
    a.unit_type,
    a.avg_lead_time_days,
    a.max_lead_time_days,
    a.unit_price,
    a.annual_sales_qty,
    a.annual_revenue,
    x.avg_weekly_demand,
    x.peak_weekly_demand,
    x.sd_weekly_demand,
    x.coefficient_of_variation,
    ROUND(a.current_stock_qty * a.unit_price, 2) AS value_in_warehouse,
    ROUND(
        MAX(
            (x.peak_weekly_demand * a.max_lead_time_days / 7.0)
            - (x.avg_weekly_demand * a.avg_lead_time_days / 7.0),
            0
        ),
        2
    ) AS safety_stock,
    ROUND(
        MAX(
            (x.peak_weekly_demand * a.max_lead_time_days / 7.0)
            - (x.avg_weekly_demand * a.avg_lead_time_days / 7.0),
            0
        )
        + (x.avg_weekly_demand * a.avg_lead_time_days / 7.0),
        2
    ) AS reorder_point,
    ROUND(
        CASE
            WHEN a.current_stock_qty * a.unit_price = 0 THEN NULL
            ELSE a.annual_revenue / (a.current_stock_qty * a.unit_price)
        END,
        4
    ) AS inventory_turnover
FROM v_abc_classification AS a
JOIN v_xyz_classification AS x
    ON x.sku_id = a.sku_id;

CREATE VIEW v_sku_analysis AS
SELECT
    a.sku_id,
    a.abc_class,
    x.xyz_class,
    a.annual_sales_qty,
    a.annual_revenue,
    a.revenue_share_pct,
    a.cumulative_revenue_share_pct,
    im.current_stock_qty,
    im.unit_type,
    im.unit_price,
    im.avg_weekly_demand,
    im.peak_weekly_demand,
    im.sd_weekly_demand,
    im.coefficient_of_variation,
    im.avg_lead_time_days,
    im.max_lead_time_days,
    im.safety_stock,
    im.reorder_point,
    ROUND(im.reorder_point - im.current_stock_qty, 2) AS replenishment_gap,
    im.value_in_warehouse,
    im.inventory_turnover,
    CASE
        WHEN im.current_stock_qty <= im.safety_stock THEN 'Critical'
        WHEN im.current_stock_qty <= im.reorder_point THEN 'Reorder Required'
        ELSE 'Healthy'
    END AS stock_status
FROM v_abc_classification AS a
JOIN v_xyz_classification AS x
    ON x.sku_id = a.sku_id
JOIN v_inventory_metrics AS im
    ON im.sku_id = a.sku_id;
