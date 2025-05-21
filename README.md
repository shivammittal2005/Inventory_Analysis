# 📦 Inventory Management Analysis using ABC & XYZ Classification 📊

This project is a comprehensive inventory analytics solution that leverages **data classification**, **demand forecasting**, and **interactive visualization** to drive intelligent inventory decisions. It blends structured Excel modeling with dynamic Power BI dashboards to reveal key insights for optimizing stock levels, replenishment strategy, and overall supply chain performance.

---

## 🚀 What This Project Does

✔️ Classifies SKUs using **ABC analysis** (based on revenue contribution)  
✔️ Segments SKUs using **XYZ analysis** (based on demand variability)  
✔️ Calculates core inventory KPIs like **Inventory turnover**, **Safety stock**, and **Reorder points**  
✔️ Visualizes actionable trends through an interactive **Power BI dashboard**  

Together, these components help organizations:

- ✅ Reduce overstock and dead inventory  
- ✅ Improve availability of critical SKUs  
- ✅ Make data-backed purchasing decisions  
- ✅ Streamline supply chain and warehouse operations  

---

## 📊 Core Techniques & Insights

### 🔢 **ABC Analysis**  
Categorizes products by their **impact on total revenue**:
- **A:** High-value items (top 70%)
- **B:** Moderate-value items (next 20%)
- **C:** Low-value items (bottom 10%)

### 📈 **XYZ Analysis**  
Segments items by **demand predictability**:
- **X:** Uniform demand (low variation)
- **Y:** Variable demand
- **Z:** Uncertain demand (high variation)

By combining these, inventory managers can adopt differentiated strategies:  
e.g., prioritize A-X items for forecasting, minimize C-Z exposure.

---

## 🧮 Formula Logic

All new columns and derived metrics in the dataset were created using advanced **Excel/DAX formulas**. This includes:

- Average and peak weekly demand  
- Safety stock & reorder point logic  
- Coefficient of variation & CV ranking  
- Inventory turnover ratio  

📎 Formula explanations are available in:  &nbsp[2) Readme_Excel_Logic.md](https://github.com/shivammittal2005/Inventory_Analysis/blob/5708bf3a66d1f72e670976e66511399ecdb222d3/2\)%20Readme_Excel_Logic.md)
---

## 🛠 Tools & Technologies

- **Microsoft Excel** – Data cleaning, preprocessing, and logic modeling  
- **DAX/PowerPivot** – Used for calculations and dynamic measures 
- **Power BI** – Interactive dashboard development  
 

---

## 📸 Dashboard Preview

> A powerful, filterable dashboard that brings the numbers to life.

- See SKUs by reorder status
- Filter by ABC/XYZ class
- Track revenue and demand patterns over time
- Visualize stock efficiency (turnover, value in warehouse)

🖼️ *Preview screenshot included in `/dashboard/`*

---

## 📌 Key Outcomes

- Categorized 303 SKUs using dual classification
- Identified reorder needs and high-value, low-performing items
- Visualized demand and inventory behavior over time

This solution enables **inventory managers, analysts, and supply chain planners** to act decisively based on data — not guesswork.

---

## 📂 Get Started

Clone or download this repository. Open the `.pbix` file in Power BI Desktop and the Excel workbook to explore the logic behind the visuals.

```bash
git clone https://github.com/your-username/inventory-management-analysis.git
```

---

📍 *Efficient inventory is smart inventory — and it starts with clean, structured analysis.*
