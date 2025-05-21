# 📘 Excel Formula Reference 

This folder contains a detailed reference of all Excel and DAX formulas used to enhance the dataset for inventory analytics. Each formula corresponds to a derived column or metric used in the Power BI dashboard.

---

## 🔢 ABC Classification (Value-Based)

### 1. Annual Sale Quantity  
💬 Calculates total quantity sold in the last 12 months for each SKU.  
🧮  
```dax
CALCULATE(
  SUM('Past Orders'[Order Quantity]),
  FILTER('Past Orders', 'Past Orders'[SKU ID] = Stock[SKU ID] &&
  'Past Orders'[Order Date] >= MAX('Past Orders'[Order Date]) - 365))
```

### 2. Annual Revenue  
💬 Multiplies unit price with the annual quantity sold.  
🧮  
```dax
Stock[Annual Sale Quantity] * Stock[Unit Price]
```

### 3. Revenue Share %  
💬 Percentage contribution of each SKU to total annual revenue.  
🧮  
```dax
100 * Stock[Annual Revenue] / SUM(Stock[Annual Revenue]) + 0
```

### 4. Cumulative Revenue Share  
💬 Running total of revenue share to apply ABC classification.  
🧮  
```dax
CALCULATE(
  SUM(Stock[Revenue share %]),
  FILTER(Stock, Stock[Revenue share %] >= EARLIER(Stock[Revenue share %])))
```

### 5. ABC Category  
💬 Segments SKUs into A, B, or C classes based on cumulative revenue.  
🧮  
```dax
IF(Stock[Cumulative share] <= 70, "A [High Value]",
   IF(Stock[Cumulative share] <= 90, "B [Medium Value]", "C [Low Value]"))
```

---

## 📈 XYZ Classification (Demand-Based)

### 6. Weekly Demand Table  
💬 Generates weekly intervals for tracking demand trends.  
🧮  
```dax
GENERATESERIES(MAX('Past Orders'[Order Date]) - 364, MAX('Past Orders'[Order Date]), 7)
```

### 7. Weekly SKU Demand  
💬 Calculates demand for each SKU in each week.  
🧮  
```dax
CALCULATE(
  SUM('Past Orders'[Order Quantity]),
  FILTER('Past Orders',
    'Past Orders'[SKU ID] = 'Weekly Demand Sheet'[SKU ID] &&
    'Past Orders'[Order Date] >= 'Weekly Demand Sheet'[Week Date] - 6 &&
    'Past Orders'[Order Date] <= 'Weekly Demand Sheet'[Week Date])) + 0
```

### 8. Average Weekly Demand  
💬 Finds average of weekly demand for each SKU.  
🧮  
```dax
CALCULATE(
  AVERAGE('Weekly Demand Sheet'[Weeks demand]),
  FILTER('Weekly Demand Sheet', 'Weekly Demand Sheet'[SKU ID] = Stock[SKU ID]))
```

### 9. Standard Deviation of Weekly Demand  
💬 Measures variability in weekly demand.  
🧮  
```dax
CALCULATE(
  STDEV.P('Weekly Demand Sheet'[Weeks demand]),
  FILTER('Weekly Demand Sheet', Stock[SKU ID] = 'Weekly Demand Sheet'[SKU ID]))
```

### 10. Coefficient of Variation (CV)  
💬 Ratio of standard deviation to average demand — used for ranking volatility.  
🧮  
```dax
IF(Stock[SD of weekly demand] > 0,
   Stock[SD of weekly demand] / Stock[Average weekly demand],
   1000)
```

### 11. XYZ Category  
💬 Classifies demand variability: X (uniform), Y (variable), Z (uncertain).  
🧮  
```dax
IF(Stock[CV rank] <= 0.2 * MAX(Stock[CV rank]), "X [Uniform Demand]",
   IF(Stock[CV rank] <= 0.5 * MAX(Stock[CV rank]), "Y [Variable demand]", "Z [Uncertain demand]"))
```

---

## 🧮 Inventory Metrics

### 12. Value in Warehouse  
💬 Total value of current stock.  
🧮  
```dax
Stock[Current Stock Quantity] * Stock[Unit Price]
```

### 13. Inventory Turnover Ratio  
💬 How efficiently stock is moving (revenue ÷ value in warehouse).  
🧮  
```dax
SUM(Stock[Annual Revenue]) / SUM(Stock[Value in Warehouse])
```

### 14. Peak Weekly Demand  
💬 Maximum demand in any week for each SKU.  
🧮  
```dax
CALCULATE(MAX('Weekly Demand Sheet'[Weeks demand]),
  FILTER('Weekly Demand Sheet', Stock[SKU ID] = 'Weekly Demand Sheet'[SKU ID]))
```

### 15. Safety Stock  
💬 Buffer stock based on peak demand and lead time variability.  
🧮  
```dax
(Stock[Peak Weekly demand] * Stock[Maximum Lead Time (days)] / 7) -
(Stock[Average weekly demand] * Stock[Average Lead Time (days)] / 7)
```

### 16. Reorder Point  
💬 Point at which new stock should be ordered.  
🧮  
```
Safety Stock + (Average Weekly Demand × Average Lead Time in weeks)
```

---

📌 All formulas are calculated using DAX in Power BI or Excel PowerPivot. 
