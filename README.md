# India UPI Payment Intelligence
### Growth Analysis and Economic Correlation | 2021–2026

[![Streamlit App](https://upi-payment-intelligence-oayppzsvizjwkxshygua5y.streamlit.app/)

---

## Project Overview

An end-to-end data analysis project examining 5 years of India's UPI payment ecosystem — from raw government data to deployed interactive dashboard.

**Data Sources:**
- NPCI Official Monthly UPI Statistics (June 2021 — March 2026)
- World Bank GDP API — India GDP 2021–2024

**Tools:** Python | MySQL | Power BI | Streamlit

---

## Key Insights

- **8x Volume Growth** — UPI transactions grew from 2.8 billion in June 2021 to 22.6 billion by March 2026
- **Democratization** — Average ticket size declined from ₹195 to ₹130 as small-ticket users joined at scale
- **Market Maturation** — YoY growth rate declined from 138% in 2022 to 32% in 2025 — saturation, not failure
- **Festival Seasonality** — October and November consistently peak every year — Diwali and Navratri effect confirmed
- **GDP Correlation** — As India's GDP grew from $3.1T to $3.9T, UPI transaction value grew proportionally

---

## Project Structure

| File | Description |
|------|-------------|
| `upi_analysis.ipynb` | Python analysis — data loading, cleaning, EDA, World Bank API |
| `upi_queries.sql` | 10 SQL analytical queries — window functions, CTEs, LAG, CASE WHEN |
| `upi_clean.csv` | Cleaned NPCI monthly data — 50 months |
| `upi_gdp.csv` | India GDP data from World Bank API — 2021 to 2024 |
| `app.py` | Streamlit interactive web app |
| `UPI_Payment_Intelligence.pbix` | Power BI dashboard — 3 pages |

---

## Technical Approach

### Phase 1 — Python
- Loaded 5 Excel files using glob and pd.concat
- Data quality checks — nulls, duplicates, dtypes
- Parsed dates, sorted chronologically
- Added derived column — avg_transaction_value (value/volume)
- EDA — 4 charts, moving averages, YoY growth, correlation heatmap
- World Bank API integration for GDP data
- Exported clean CSV for SQL phase

### Phase 2 — SQL (MySQL)
- Designed and created database schema
- Analytical queries using window functions, CTEs, LAG, CASE WHEN
- Yearly and monthly rankings, YoY growth rates, seasonal analysis
- Cumulative volume, MoM growth, adoption phase classification

### Phase 3 — Power BI
- Connected Power BI to MySQL database
- 7 DAX measures — Total Volume, Total Value, Avg Ticket Size, YoY Growth
- 3-page dashboard — UPI Growth Overview, Transaction Intelligence, Seasonality and Growth
- Dark theme, cyan accent, insight-driven chart titles

### Phase 4 — Streamlit
- Interactive web app with 4 charts and KPI metrics
- Deployed publicly on Streamlit Cloud

---

##  Live App

 [Open Streamlit App](https://upi-payment-intelligence-oayppzsvizjwkxshygua5y.streamlit.app/)

---

## Author

**Rishitha Gopagani**  
[LinkedIn](https://linkedin.com/in/rishitha-gopagani-a184ab17a) | [GitHub](https://github.com/ri-data)
