-- ============================================================
-- India UPI Payment Intelligence — SQL Analysis Queries
-- Dataset: NPCI Monthly UPI Data (June 2021 - March 2026)
-- Author: Rishitha Gopagani
-- ============================================================

-- ============================================================
-- DATABASE AND TABLE SETUP
-- ============================================================

CREATE DATABASE upi_analysis;
USE upi_analysis;

CREATE TABLE upi_data (
    Month_dt              DATE,
    volume                FLOAT,
    avg_daily_volume      FLOAT,
    value                 FLOAT,
    avg_daily_value       FLOAT,
    avg_transaction_value FLOAT
);

-- Verify data loaded correctly
SELECT COUNT(*) FROM upi_data;
SELECT * FROM upi_data LIMIT 5;

-- ============================================================
-- QUERY 1: Yearly Ranking by Volume
-- Ranks each year by total UPI transaction volume
-- Insight: 2025 ranks first with 191,710M transactions — 7x growth from 2021
-- ============================================================
SELECT
    YEAR(Month_dt)                          AS year,
    SUM(volume)                             AS total_volume,
    SUM(value)                              AS total_value,
    RANK() OVER (ORDER BY SUM(volume) DESC) AS volume_rank
FROM upi_data
WHERE YEAR(Month_dt) <= 2025
GROUP BY YEAR(Month_dt)
ORDER BY volume_rank;

-- ============================================================
-- QUERY 2: Monthly Ranking — All 50 Months
-- Ranks every month by volume to identify peak and low periods
-- Insight: October and November consistently rank higher than surrounding months — festival season effect
-- ============================================================
SELECT
    Month_dt,
    volume,
    RANK() OVER (ORDER BY volume DESC) AS volume_rank
FROM upi_data
WHERE YEAR(Month_dt) <= 2025
ORDER BY volume_rank;

-- ============================================================
-- QUERY 3: Year on Year Growth Rate Using LAG
-- Calculates YoY volume growth percentage for each year
-- Insight: Growth declined from 138% in 2022 to 32% in 2025 — market maturation
-- ============================================================
SELECT
    YEAR(Month_dt)                                                                        AS year,
    SUM(volume)                                                                           AS total_volume,
    LAG(SUM(volume), 1) OVER (ORDER BY YEAR(Month_dt))                                   AS prev_year_volume,
    ROUND(
        (SUM(volume) - LAG(SUM(volume), 1) OVER (ORDER BY YEAR(Month_dt)))
        / LAG(SUM(volume), 1) OVER (ORDER BY YEAR(Month_dt)) * 100
    , 2)                                                                                  AS yoy_growth_pct
FROM upi_data
WHERE YEAR(Month_dt) <= 2025
GROUP BY YEAR(Month_dt)
ORDER BY year;

-- ============================================================
-- QUERY 4: Seasonal Analysis by Month Number
-- Averages volume by calendar month across all years
-- Insight: Month 10 (October) and 11 (November) show highest average — festival season confirmed
-- ============================================================
SELECT
    MONTH(Month_dt)          AS month_number,
    ROUND(AVG(volume), 2)    AS avg_volume,
    ROUND(AVG(value), 2)     AS avg_value,
    COUNT(*)                 AS years_of_data
FROM upi_data
WHERE YEAR(Month_dt) <= 2025
GROUP BY MONTH(Month_dt)
ORDER BY avg_volume DESC;

-- ============================================================
-- QUERY 5: Running Total — Cumulative Volume Since June 2021
-- Shows total UPI transactions processed cumulatively month by month
-- Insight: Demonstrates the compounding scale of India's digital payment transformation
-- ============================================================
SELECT
    Month_dt,
    volume,
    ROUND(SUM(volume) OVER (ORDER BY Month_dt), 2) AS cumulative_volume
FROM upi_data
WHERE YEAR(Month_dt) <= 2025
ORDER BY Month_dt;

-- ============================================================
-- QUERY 6: Month on Month Growth Rate Using LAG
-- Calculates percentage change in volume from previous month
-- Insight: Negative months are February (fewer days) and NPCI data gap months
-- ============================================================
SELECT
    Month_dt,
    volume,
    LAG(volume, 1) OVER (ORDER BY Month_dt)                                        AS prev_month_volume,
    ROUND(
        (volume - LAG(volume, 1) OVER (ORDER BY Month_dt))
        / LAG(volume, 1) OVER (ORDER BY Month_dt) * 100
    , 2)                                                                            AS mom_growth_pct
FROM upi_data
WHERE YEAR(Month_dt) <= 2025
ORDER BY Month_dt;

-- ============================================================
-- QUERY 7: Top 5 Highest Volume Months Using CTE
-- Uses CTE to rank months then filters top 5
-- Insight: All top 5 months are from late 2024 and 2025 — accelerating adoption
-- ============================================================
WITH monthly_ranked AS (
    SELECT
        Month_dt,
        volume,
        value,
        RANK() OVER (ORDER BY volume DESC) AS rnk
    FROM upi_data
    WHERE YEAR(Month_dt) <= 2025
)
SELECT * FROM monthly_ranked
WHERE rnk <= 5;

-- ============================================================
-- QUERY 8: Adoption Phase Classification Using CASE WHEN
-- Classifies each month into adoption phase based on avg ticket size
-- Insight: Early months are high ticket — later months shift to low ticket mass adoption
-- ============================================================
SELECT
    Month_dt,
    volume,
    avg_transaction_value,
    CASE
        WHEN avg_transaction_value > 180 THEN 'High Ticket — Early Adoption Phase'
        WHEN avg_transaction_value BETWEEN 150 AND 180 THEN 'Mid Ticket — Growth Phase'
        WHEN avg_transaction_value < 150 THEN 'Low Ticket — Mass Adoption Phase'
    END AS adoption_phase
FROM upi_data
WHERE YEAR(Month_dt) <= 2025
ORDER BY Month_dt;

-- ============================================================
-- QUERY 9: Average Transaction Value Trend by Year
-- Shows yearly avg, min, max ticket size
-- Insight: Avg ticket size declined every year from Rs.183 to Rs.132 — democratization confirmed
-- ============================================================
SELECT
    YEAR(Month_dt)                          AS year,
    ROUND(AVG(avg_transaction_value), 2)    AS avg_ticket_size,
    ROUND(MIN(avg_transaction_value), 2)    AS min_ticket,
    ROUND(MAX(avg_transaction_value), 2)    AS max_ticket
FROM upi_data
WHERE YEAR(Month_dt) <= 2025
GROUP BY YEAR(Month_dt)
ORDER BY year;

-- ============================================================
-- QUERY 10: Festival Season vs Regular Months
-- Compares average volume across month categories
-- Insight: Festival Season months (Oct-Nov) average highest volume — seasonal pattern quantified
-- ============================================================
SELECT
    CASE
        WHEN MONTH(Month_dt) IN (10, 11) THEN 'Festival Season'
        WHEN MONTH(Month_dt) = 12        THEN 'Year End'
        WHEN MONTH(Month_dt) IN (1, 3)   THEN 'High Activity'
        ELSE                                  'Regular Month'
    END                       AS month_category,
    ROUND(AVG(volume), 2)     AS avg_volume,
    ROUND(AVG(value), 2)      AS avg_value,
    COUNT(*)                  AS month_count
FROM upi_data
WHERE YEAR(Month_dt) <= 2025
GROUP BY month_category
ORDER BY avg_volume DESC;
