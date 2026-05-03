import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker

# Page config
st.set_page_config(
    page_title="India UPI Payment Intelligence",
    page_icon="📊",
    layout="wide"
)

# Load data
df = pd.read_csv('upi_clean.csv')
df['Month_dt'] = pd.to_datetime(df['Month_dt'])
gdp = pd.read_csv('upi_gdp.csv')

# Header
st.title("🇮🇳 India UPI Payment Intelligence")
st.markdown("**Growth Analysis and Economic Correlation | 2021–2026**")
st.markdown("*Data Source: NPCI Official Statistics + World Bank GDP API*")
st.divider()

# KPI Cards
col1, col2, col3, col4 = st.columns(4)
col1.metric("Total Transactions", f"{df['volume'].sum()/1000:.1f}B", "50 months")
col2.metric("Total Value Moved", f"₹{df['value'].sum()/100000:.1f}L Cr")
col3.metric("Avg Ticket Size", f"₹{df['avg_transaction_value'].mean():.0f}")
col4.metric("Peak Month Volume", f"{df['volume'].max():.0f}M")

st.divider()

# Chart 1 — Volume Growth
st.subheader("UPI Transaction Volume Grew 8x From 2021 to 2025")
fig1, ax1 = plt.subplots(figsize=(12, 4))
ax1.plot(df['Month_dt'], df['volume'], color='#00b4d8', linewidth=2)
df['volume_ma3'] = df['volume'].rolling(3).mean()
df['volume_ma6'] = df['volume'].rolling(6).mean()
ax1.plot(df['Month_dt'], df['volume_ma3'], color='orange', linewidth=1.5, linestyle='--', label='3M Moving Avg')
ax1.plot(df['Month_dt'], df['volume_ma6'], color='red', linewidth=1.5, linestyle='--', label='6M Moving Avg')
ax1.set_facecolor('#0e1117')
fig1.patch.set_facecolor('#0e1117')
ax1.tick_params(colors='white')
ax1.yaxis.label.set_color('white')
ax1.xaxis.label.set_color('white')
ax1.spines['bottom'].set_color('#444')
ax1.spines['left'].set_color('#444')
ax1.spines['top'].set_visible(False)
ax1.spines['right'].set_visible(False)
ax1.legend(facecolor='#0e1117', labelcolor='white')
ax1.set_ylabel('Volume (Millions)', color='white')
st.pyplot(fig1)

st.divider()

# Chart 2 — Avg Transaction Value
st.subheader("Average Ticket Size Declined from ₹195 to ₹130 — UPI Democratization")
fig2, ax2 = plt.subplots(figsize=(12, 4))
ax2.plot(df['Month_dt'], df['avg_transaction_value'], color='#ff6b6b', linewidth=2)
ax2.set_facecolor('#0e1117')
fig2.patch.set_facecolor('#0e1117')
ax2.tick_params(colors='white')
ax2.spines['bottom'].set_color('#444')
ax2.spines['left'].set_color('#444')
ax2.spines['top'].set_visible(False)
ax2.spines['right'].set_visible(False)
ax2.set_ylabel('Avg Transaction Value (₹)', color='white')
st.pyplot(fig2)

st.divider()

# Chart 3 — GDP vs UPI
st.subheader("India GDP Growth vs UPI Transaction Value — Economic Correlation")
fig3, ax3 = plt.subplots(figsize=(12, 4))
ax3.plot(gdp['year'], gdp['value']/100000, color='#00b4d8', marker='o', linewidth=2, label='UPI Value (Lakh Cr)')
ax3.set_facecolor('#0e1117')
fig3.patch.set_facecolor('#0e1117')
ax3.tick_params(colors='white')
ax3.spines['bottom'].set_color('#444')
ax3.spines['left'].set_color('#444')
ax3.spines['top'].set_visible(False)
ax3.spines['right'].set_visible(False)
ax3.set_ylabel('UPI Value (Lakh Crores)', color='white')
ax4 = ax3.twinx()
ax4.plot(gdp['year'], gdp['gdp_usd']/1e12, color='#ffd166', marker='s', linewidth=2, label='GDP (Trillion USD)')
ax4.tick_params(colors='white')
ax4.spines['right'].set_color('#444')
ax4.set_ylabel('GDP (Trillion USD)', color='#ffd166')
ax3.legend(facecolor='#0e1117', labelcolor='white', loc='upper left')
ax4.legend(facecolor='#0e1117', labelcolor='white', loc='lower right')
st.pyplot(fig3)

st.divider()

# Chart 4 — MoM Growth
st.subheader("Month on Month Growth Rate — Market Maturing Over Time")
df['mom_growth'] = df['volume'].pct_change() * 100
fig4, ax5 = plt.subplots(figsize=(12, 4))
colors = ['#00b4d8' if x >= 0 else '#ff6b6b' for x in df['mom_growth'].fillna(0)]
ax5.bar(df['Month_dt'], df['mom_growth'], color=colors, width=20)
ax5.axhline(y=0, color='white', linewidth=0.8)
ax5.set_facecolor('#0e1117')
fig4.patch.set_facecolor('#0e1117')
ax5.tick_params(colors='white')
ax5.spines['bottom'].set_color('#444')
ax5.spines['left'].set_color('#444')
ax5.spines['top'].set_visible(False)
ax5.spines['right'].set_visible(False)
ax5.set_ylabel('MoM Growth %', color='white')
st.pyplot(fig4)

st.divider()

# Key Insights
st.subheader("📌 Key Insights")
st.markdown("""
- **8x Volume Growth:** UPI transactions grew from 2.8 billion in June 2021 to 22.6 billion by March 2026
- **Democratization:** Average ticket size declined from ₹195 to ₹130 — small-ticket users joined UPI at scale
- **Market Maturation:** YoY growth rate declined from 138% in 2022 to 32% in 2025 — not failure, but saturation
- **Festival Seasonality:** October and November consistently peak every year — Diwali and Navratri drive UPI spikes
- **GDP Correlation:** As India's GDP grew from $3.1T to $3.9T, UPI value grew proportionally
- **Dataset:** 50 months of real NPCI data (June 2021 — March 2026) + World Bank GDP API
""")

st.divider()
st.caption("Built by Rishitha Gopagani | Data: NPCI + World Bank | Tools: Python, SQL, Power BI")
