# 📦 Inventory Analysis & Replenishment Dashboard

An end-to-end inventory analytics project combining **SQL, Excel/DAX and Power BI** to classify SKUs, measure demand variability, monitor stock efficiency and prioritise replenishment decisions.

---

## 🚀 Project Scope

- Classifies SKUs using **ABC analysis** based on annual revenue contribution
- Segments SKUs using **XYZ analysis** based on weekly demand variability
- Calculates **safety stock, reorder points, inventory turnover and warehouse value**
- Uses SQL to validate segmentation and identify replenishment-risk SKUs
- Presents operational KPIs through an interactive **Power BI dashboard**

The analysis covers **303 SKUs** and **33,919 historical order records**.

---

## 📊 Analytical Framework

### ABC classification

- **A:** high-value items contributing the first 70% of annual revenue
- **B:** medium-value items contributing the next 20%
- **C:** remaining low-value items

### XYZ classification

- **X:** most predictable demand
- **Y:** moderately variable demand
- **Z:** highly uncertain demand

Combining the two classifications supports differentiated decisions—for example, tighter monitoring of high-value AX/AZ items and lower working-capital exposure for CZ items.

---

## 🧮 Inventory Metrics

The Excel/DAX model calculates:

- Annual sales quantity and annual revenue
- Revenue contribution and cumulative contribution
- Average and peak weekly demand
- Standard deviation and coefficient of variation
- Safety stock
- Reorder point
- Inventory turnover
- Current value in warehouse

Detailed formulas are documented in [`2) Readme_Excel_Logic.md`](2%29%20Readme_Excel_Logic.md).

---

## 🗃️ SQL Analysis Layer

The folder [`4) SQL Analysis`](4%29%20SQL%20Analysis/) adds a reproducible SQL layer using the same source data.

It includes:

- ABC and XYZ classification queries
- Replenishment-risk prioritisation
- ABC-XYZ segment summaries
- Monthly demand analysis
- Ready-to-open SQLite database
- Query outputs in CSV and Excel formats

SQL concepts demonstrated:

- Joins
- CTEs and recursive CTEs
- Aggregations
- Window functions
- Date functions
- Conditional logic
- Reusable views

See [`4) SQL Analysis/README_SQL.md`](4%29%20SQL%20Analysis/README_SQL.md) for methodology and execution steps.

---

## 🛠 Tools & Technologies

- **SQL / SQLite** — SKU classification, demand analysis and replenishment prioritisation
- **Microsoft Excel** — Data cleaning and source-data validation
- **DAX / PowerPivot** — Inventory calculations and dynamic measures
- **Power BI** — Interactive dashboarding and KPI monitoring

---

## 📸 Dashboard Preview

The dashboard supports:

- Filtering by ABC and XYZ class
- Monitoring reorder status
- Tracking revenue and demand patterns
- Reviewing inventory turnover and warehouse value

![Dashboard Overview](3%29%20Dashboard/Dashboard_Overview.png)

---

## 📌 Repository Structure

```text
Inventory_Analysis/
├── 1) Inventory Data.xlsx
├── 2) Readme_Excel_Logic.md
├── 3) Dashboard/
│   ├── Dashboard_Overview.png
│   └── Inventory_Dashboard.pbit
├── 4) SQL Analysis/
│   ├── README_SQL.md
│   ├── inventory_analysis.db
│   ├── SQL_Analysis_Results.xlsx
│   ├── Input Data/
│   ├── SQL Scripts/
│   └── Results/
└── README.md
```

---

## 📌 Key Outcomes

- Classified **303 SKUs** using a combined ABC-XYZ framework
- Identified high-value SKUs requiring tighter replenishment monitoring
- Prioritised stock risks using safety-stock and reorder-point thresholds
- Added a reproducible SQL layer alongside the existing Excel/DAX analysis
- Built an interactive Power BI dashboard for ongoing inventory monitoring

---

## 📂 Get Started

```bash
git clone https://github.com/shivammittal2005/Inventory_Analysis.git
```

Open:

1. `1) Inventory Data.xlsx` to inspect the source data
2. `3) Dashboard/Inventory_Dashboard.pbit` for the Power BI dashboard
3. `4) SQL Analysis/inventory_analysis.db` for the completed SQL model
4. `4) SQL Analysis/SQL Scripts/` to review the query logic

---

*The SQL component is an additional analysis and validation layer; the existing Power BI dashboard continues to use the Excel/DAX data model.*
