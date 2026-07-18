# SQL Inventory Analysis

This folder extends the existing Excel/DAX and Power BI inventory project with a reproducible SQL analysis layer.

## Dataset

- **303 stock SKUs**
- **290 SKUs with historical orders**
- **33,919 order records**
- Order period: **2019-01-30 to 2020-06-13**

## What the SQL layer does

1. Recreates value-based **ABC classification** using annual revenue contribution.
2. Calculates 52-week SKU demand statistics and assigns **XYZ demand-variability classes**.
3. Calculates **safety stock, reorder point, inventory turnover and replenishment status**.
4. Summarises revenue, inventory value and risk across combined ABC-XYZ segments.
5. Tracks monthly order volume and active-SKU trends.

## SQL concepts demonstrated

- Joins
- Common Table Expressions
- Recursive CTEs
- Aggregations
- Window functions
- `CASE WHEN`
- Date functions
- Reusable SQL views
- Conditional prioritisation

## Folder structure

```text
4) SQL Analysis/
├── README_SQL.md
├── inventory_analysis.db
├── SQL_Analysis_Results.xlsx
├── Input Data/
│   ├── stock.csv
│   └── past_orders.csv
├── SQL Scripts/
│   ├── 00_build_analysis_views.sql
│   ├── 01_abc_classification.sql
│   ├── 02_xyz_classification.sql
│   ├── 03_replenishment_risk.sql
│   ├── 04_segment_summary.sql
│   └── 05_monthly_demand_trends.sql
└── Results/
    ├── 01_abc_classification_results.csv
    ├── 02_xyz_classification_results.csv
    ├── 03_replenishment_risk_results.csv
    ├── 04_segment_summary_results.csv
    ├── 05_monthly_demand_trends_results.csv
    └── data_quality_summary.csv
```

## Quick review

The easiest way to review the completed work is to open:

- `inventory_analysis.db` in DB Browser for SQLite
- `SQL_Analysis_Results.xlsx` for tabular outputs
- Any `.sql` file to inspect the logic

The database already contains the imported tables and all analysis views.

## Rebuild the database manually

1. Create a new SQLite database.
2. Import `stock.csv` as table `stock`.
3. Import `past_orders.csv` as table `past_orders`.
4. Ensure `order_date` is stored as `YYYY-MM-DD`.
5. Run `00_build_analysis_views.sql`.
6. Run the numbered analysis queries.

## Methodology

- Annual metrics use the latest **365 days** ending on the maximum order date.
- Weekly demand uses **52 rolling seven-day periods**, including zero-demand weeks.
- ABC thresholds:
  - A: cumulative revenue contribution up to 70%
  - B: cumulative contribution from 70% to 90%
  - C: remaining contribution
- XYZ thresholds use percentile rank of the coefficient of variation:
  - X: lowest 20% variability
  - Y: next 30%
  - Z: remaining 50%
- Safety stock follows the original project logic:

```text
(peak weekly demand × maximum lead time / 7)
− (average weekly demand × average lead time / 7)
```

- Reorder point:

```text
safety stock + (average weekly demand × average lead time / 7)
```

## Current output summary

- Critical SKUs: **282**
- Reorder-required SKUs: **2**
- Healthy SKUs: **19**

## Scope note

The Power BI dashboard remains based on the original Excel/DAX model. SQL is added as an analysis and validation layer for SKU segmentation, demand variability and replenishment prioritisation.
