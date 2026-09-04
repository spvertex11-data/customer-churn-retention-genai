DROP TABLE IF EXISTS telco_churn;

CREATE TABLE telco_churn (
    customer_id VARCHAR(20) PRIMARY KEY,
    gender VARCHAR(10),
    senior_citizen INTEGER,
    partner VARCHAR(5),
    dependents VARCHAR(5),
    tenure INTEGER,
    phone_service VARCHAR(20),
    multiple_lines VARCHAR(30),
    internet_service VARCHAR(30),
    online_security VARCHAR(30),
    online_backup VARCHAR(30),
    device_protection VARCHAR(30),
    tech_support VARCHAR(30),
    streaming_tv VARCHAR(30),
    streaming_movies VARCHAR(30),
    contract VARCHAR(30),
    paperless_billing VARCHAR(5),
    payment_method VARCHAR(50),
    monthly_charges NUMERIC(10,2),
    total_charges NUMERIC(12,2),
    churn VARCHAR(5),

    churn_flag INTEGER,
    tenure_group VARCHAR(30),
    monthly_charge_band VARCHAR(30),
    customer_value_segment VARCHAR(30),
    service_count INTEGER,
    engagement_segment VARCHAR(30),
    high_risk_flag INTEGER,
    monthly_revenue_at_risk NUMERIC(12,2),
    customer_value_lost NUMERIC(12,2)
);


COPY telco_churn
FROM 'D:/PROJECT/Customer_Churn_Retention_GenAI/Data/Cleaned/telco_churn_cleaned.csv'
DELIMITER ','
CSV HEADER;


SELECT COUNT(*) AS total_rows
FROM telco_churn;

-- Query 1: Executive Customer Summary
-- Purpose:
-- Gives a high-level summary of total customers,
-- churned customers, retained customers, and churn rate.
-- =========================================================

SELECT
    -- Count total unique customers
    COUNT(DISTINCT customer_id) AS total_customers,

    -- Count customers who have churned
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 1) AS churned_customers,

    -- Count customers who are still retained
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 0) AS retained_customers,

    -- Calculate overall churn percentage
    ROUND(
        100.0
        * COUNT(DISTINCT customer_id)
            FILTER (WHERE churn_flag = 1)
        / NULLIF(COUNT(DISTINCT customer_id), 0),
        2
    ) AS churn_rate_pct

FROM telco_churn;


-- Query 2: Churn by Contract Type
-- Purpose:
-- Compares customer churn across different contract types
-- to identify which contract group has the highest churn.
-- =========================================================

SELECT
    -- Contract category
    contract,

    -- Total unique customers in each contract type
    COUNT(DISTINCT customer_id) AS total_customers,

    -- Customers who churned in each contract type
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 1) AS churned_customers,

    -- Customers who are still retained
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 0) AS retained_customers,

    -- Churn rate percentage for each contract type
    ROUND(
        100.0
        * COUNT(DISTINCT customer_id)
            FILTER (WHERE churn_flag = 1)
        / NULLIF(COUNT(DISTINCT customer_id), 0),
        2
    ) AS churn_rate_pct

FROM telco_churn

-- Group results by contract type
GROUP BY contract

-- Show highest churn contract first
ORDER BY churn_rate_pct DESC;



-- Query 3: Churn by Tenure Group
-- Purpose:
-- Compares churn across different customer tenure groups
-- to identify which lifecycle stage has the highest churn.
-- =========================================================

SELECT
    -- Customer tenure segment created in Python
    tenure_group,

    -- Total customers in each tenure group
    COUNT(DISTINCT customer_id) AS total_customers,

    -- Customers who churned
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 1) AS churned_customers,

    -- Customers who are retained
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 0) AS retained_customers,

    -- Churn rate percentage
    ROUND(
        100.0
        * COUNT(DISTINCT customer_id)
            FILTER (WHERE churn_flag = 1)
        / NULLIF(COUNT(DISTINCT customer_id), 0),
        2
    ) AS churn_rate_pct

FROM telco_churn

-- Group analysis by tenure segment
GROUP BY tenure_group

-- Show tenure groups in business-friendly order
ORDER BY
    CASE
        WHEN tenure_group = '0-12 Months' THEN 1
        WHEN tenure_group = '13-24 Months' THEN 2
        WHEN tenure_group = '25-48 Months' THEN 3
        WHEN tenure_group = '49+ Months' THEN 4
        ELSE 5
    END;


-- Query 4: Churn by Internet Service
-- Purpose:
-- Compares churn across different internet service types
-- to identify which service segment has the highest churn.
-- =========================================================

SELECT
    -- Internet service category
    internet_service,

    -- Total customers in each internet service group
    COUNT(DISTINCT customer_id) AS total_customers,

    -- Customers who churned
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 1) AS churned_customers,

    -- Customers who are retained
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 0) AS retained_customers,

    -- Churn rate percentage
    ROUND(
        100.0
        * COUNT(DISTINCT customer_id)
            FILTER (WHERE churn_flag = 1)
        / NULLIF(COUNT(DISTINCT customer_id), 0),
        2
    ) AS churn_rate_pct

FROM telco_churn

-- Group analysis by internet service type
GROUP BY internet_service

-- Show highest churn service first
ORDER BY churn_rate_pct DESC;


-- Query 5: Churn by Payment Method
-- Purpose:
-- Compares churn across different payment methods
-- to identify billing/payment patterns linked with higher churn.
-- =========================================================

SELECT
    -- Customer payment method
    payment_method,

    -- Total customers using each payment method
    COUNT(DISTINCT customer_id) AS total_customers,

    -- Customers who churned
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 1) AS churned_customers,

    -- Customers who are retained
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 0) AS retained_customers,

    -- Churn rate percentage
    ROUND(
        100.0
        * COUNT(DISTINCT customer_id)
            FILTER (WHERE churn_flag = 1)
        / NULLIF(COUNT(DISTINCT customer_id), 0),
        2
    ) AS churn_rate_pct

FROM telco_churn

-- Group analysis by payment method
GROUP BY payment_method

-- Show highest churn payment method first
ORDER BY churn_rate_pct DESC;



-- Query 6: Churn by Monthly Charge Band
-- Purpose:
-- Compares churn across low, medium, and high monthly
-- charge groups to identify whether higher-paying
-- customers are more likely to churn.
-- =========================================================

SELECT
    -- Monthly charge segment created in Python
    monthly_charge_band,

    -- Total customers in each charge band
    COUNT(DISTINCT customer_id) AS total_customers,

    -- Customers who churned
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 1) AS churned_customers,

    -- Customers who are retained
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 0) AS retained_customers,

    -- Churn rate percentage
    ROUND(
        100.0
        * COUNT(DISTINCT customer_id)
            FILTER (WHERE churn_flag = 1)
        / NULLIF(COUNT(DISTINCT customer_id), 0),
        2
    ) AS churn_rate_pct,

    -- Average monthly charge in each segment
    ROUND(
        AVG(monthly_charges),
        2
    ) AS avg_monthly_charges

FROM telco_churn

-- Group customers by monthly charge segment
GROUP BY monthly_charge_band

-- Show charge bands in logical order
ORDER BY
    CASE
        WHEN monthly_charge_band = 'Low Charges' THEN 1
        WHEN monthly_charge_band = 'Medium Charges' THEN 2
        WHEN monthly_charge_band = 'High Charges' THEN 3
        ELSE 4
    END;


-- Query 7: Churn by Customer Value Segment
-- Purpose:
-- Compares churn across customer value segments
-- to identify whether financially valuable customers
-- are also at risk of leaving.
-- =========================================================

SELECT
    -- Customer value segment created in Python
    customer_value_segment,

    -- Total customers in each value segment
    COUNT(DISTINCT customer_id) AS total_customers,

    -- Customers who churned
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 1) AS churned_customers,

    -- Customers who are retained
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 0) AS retained_customers,

    -- Churn rate percentage
    ROUND(
        100.0
        * COUNT(DISTINCT customer_id)
            FILTER (WHERE churn_flag = 1)
        / NULLIF(COUNT(DISTINCT customer_id), 0),
        2
    ) AS churn_rate_pct,

    -- Average total customer value in each segment
    ROUND(
        AVG(total_charges),
        2
    ) AS avg_total_charges

FROM telco_churn

-- Group customers by customer value segment
GROUP BY customer_value_segment

-- Show value segments in logical order
ORDER BY
    CASE
        WHEN customer_value_segment = 'Low Value' THEN 1
        WHEN customer_value_segment = 'Medium Value' THEN 2
        WHEN customer_value_segment = 'High Value' THEN 3
        ELSE 4
    END;



-- Query 8: Churn by Engagement Segment
-- Purpose:
-- Compares churn across engagement levels
-- to understand whether customers using fewer services
-- are more likely to leave.
-- =========================================================

SELECT
    -- Engagement segment created in Python
    engagement_segment,

    -- Total customers in each engagement segment
    COUNT(DISTINCT customer_id) AS total_customers,

    -- Customers who churned
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 1) AS churned_customers,

    -- Customers who are retained
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 0) AS retained_customers,

    -- Churn rate percentage
    ROUND(
        100.0
        * COUNT(DISTINCT customer_id)
            FILTER (WHERE churn_flag = 1)
        / NULLIF(COUNT(DISTINCT customer_id), 0),
        2
    ) AS churn_rate_pct,

    -- Average number of active services
    ROUND(
        AVG(service_count),
        2
    ) AS avg_service_count

FROM telco_churn

-- Group customers by engagement level
GROUP BY engagement_segment

-- Show engagement levels in logical order
ORDER BY
    CASE
        WHEN engagement_segment = 'Low Engagement' THEN 1
        WHEN engagement_segment = 'Medium Engagement' THEN 2
        WHEN engagement_segment = 'High Engagement' THEN 3
        ELSE 4
    END;


-- Query 9: High-Risk Customer Summary
-- Purpose:
-- Evaluates whether customers classified as high-risk
-- actually show a higher churn rate.
-- =========================================================

SELECT
    -- Risk group created in Python
    high_risk_flag,

    -- Total customers in each risk group
    COUNT(DISTINCT customer_id) AS total_customers,

    -- Customers who churned
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 1) AS churned_customers,

    -- Customers who are retained
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 0) AS retained_customers,

    -- Churn rate percentage
    ROUND(
        100.0
        * COUNT(DISTINCT customer_id)
            FILTER (WHERE churn_flag = 1)
        / NULLIF(COUNT(DISTINCT customer_id), 0),
        2
    ) AS churn_rate_pct,

    -- Average monthly charge in each risk group
    ROUND(
        AVG(monthly_charges),
        2
    ) AS avg_monthly_charges

FROM telco_churn

-- Compare high-risk and non-high-risk groups
GROUP BY high_risk_flag

-- Show high-risk customers first
ORDER BY high_risk_flag DESC;	


-- Query 10: High-Risk but Not Yet Churned Customers
-- Purpose:
-- Identifies customers who are currently retained
-- but have been classified as high-risk.
-- These customers should be prioritized for retention action.
-- =========================================================

SELECT
    -- Unique customer identifier
    customer_id,

    -- Customer tenure
    tenure,

    -- Customer contract type
    contract,

    -- Internet service used by the customer
    internet_service,

    -- Monthly amount charged
    monthly_charges,

    -- Total historical customer value
    total_charges,

    -- Number of active services
    service_count,

    -- Engagement level
    engagement_segment,

    -- Customer value segment
    customer_value_segment,

    -- High-risk status
    high_risk_flag

FROM telco_churn

-- Keep only customers who are high-risk
-- but have not churned yet
WHERE high_risk_flag = 1
  AND churn_flag = 0

-- Show financially valuable customers first
ORDER BY total_charges DESC;



-- Query 11: Monthly Revenue at Risk
-- Purpose:
-- Calculates the monthly revenue associated with customers
-- who have already churned.
-- This helps translate churn into financial impact.
-- =========================================================

SELECT
    -- Total number of churned customers
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 1) AS churned_customers,

    -- Total monthly revenue associated with churned customers
    ROUND(
        SUM(monthly_revenue_at_risk),
        2
    ) AS total_monthly_revenue_at_risk,

    -- Average monthly charge of churned customers
    ROUND(
        AVG(monthly_charges)
            FILTER (WHERE churn_flag = 1),
        2
    ) AS avg_monthly_charge_churned

FROM telco_churn;


-- Query 12: Customer Value Lost Due to Churn
-- Purpose:
-- Calculates the total historical customer value
-- associated with customers who have churned.
-- =========================================================

SELECT
    -- Total churned customers
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 1) AS churned_customers,

    -- Total historical customer value associated with churn
    ROUND(
        SUM(customer_value_lost),
        2
    ) AS total_customer_value_lost,

    -- Average historical value per churned customer
    ROUND(
        AVG(total_charges)
            FILTER (WHERE churn_flag = 1),
        2
    ) AS avg_value_per_churned_customer

FROM telco_churn;



-- Query 13: High-Value Churned Customers
-- Purpose:
-- Identifies churned customers who belong to the
-- High Value segment so the business can understand
-- which financially important customers have been lost.
-- =========================================================

SELECT
    -- Unique customer identifier
    customer_id,

    -- Customer tenure
    tenure,

    -- Contract type
    contract,

    -- Monthly recurring charge
    monthly_charges,

    -- Historical total customer value
    total_charges,

    -- Number of active services
    service_count,

    -- Customer engagement level
    engagement_segment,

    -- Customer value category
    customer_value_segment,

    -- Churn status
    churn_flag

FROM telco_churn

-- Keep only high-value customers who have churned
WHERE customer_value_segment = 'High Value'
  AND churn_flag = 1

-- Show highest-value churned customers first
ORDER BY total_charges DESC;



-- Query 14: Tech Support vs Churn
-- Purpose:
-- Compares churn between customers who use Tech Support
-- and customers who do not.
-- This helps evaluate whether support availability
-- is associated with better customer retention.
-- =========================================================

SELECT
    -- Tech Support category
    tech_support,

    -- Total customers in each Tech Support group
    COUNT(DISTINCT customer_id) AS total_customers,

    -- Customers who churned
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 1) AS churned_customers,

    -- Customers who are retained
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 0) AS retained_customers,

    -- Churn rate percentage
    ROUND(
        100.0
        * COUNT(DISTINCT customer_id)
            FILTER (WHERE churn_flag = 1)
        / NULLIF(COUNT(DISTINCT customer_id), 0),
        2
    ) AS churn_rate_pct

FROM telco_churn

-- Group customers by Tech Support usage
GROUP BY tech_support

-- Show highest churn group first
ORDER BY churn_rate_pct DESC;


-- Query 15: Online Security vs Churn
-- Purpose:
-- Compares churn across Online Security categories
-- to understand whether customers without security service
-- are more likely to leave.
-- =========================================================

SELECT
    -- Online Security category
    online_security,

    -- Total customers in each Online Security group
    COUNT(DISTINCT customer_id) AS total_customers,

    -- Customers who churned
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 1) AS churned_customers,

    -- Customers who are retained
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 0) AS retained_customers,

    -- Churn rate percentage
    ROUND(
        100.0
        * COUNT(DISTINCT customer_id)
            FILTER (WHERE churn_flag = 1)
        / NULLIF(COUNT(DISTINCT customer_id), 0),
        2
    ) AS churn_rate_pct

FROM telco_churn

-- Group customers by Online Security status
GROUP BY online_security

-- Show highest churn category first
ORDER BY churn_rate_pct DESC;



-- Query 16: Paperless Billing vs Churn
-- Purpose:
-- Compares churn between customers who use Paperless Billing
-- and customers who do not.
-- This helps identify whether billing preference is
-- associated with customer churn.
-- =========================================================

SELECT
    -- Paperless Billing category
    paperless_billing,

    -- Total customers in each billing group
    COUNT(DISTINCT customer_id) AS total_customers,

    -- Customers who churned
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 1) AS churned_customers,

    -- Customers who are retained
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 0) AS retained_customers,

    -- Churn rate percentage
    ROUND(
        100.0
        * COUNT(DISTINCT customer_id)
            FILTER (WHERE churn_flag = 1)
        / NULLIF(COUNT(DISTINCT customer_id), 0),
        2
    ) AS churn_rate_pct

FROM telco_churn

-- Group customers by Paperless Billing status
GROUP BY paperless_billing

-- Show highest churn group first
ORDER BY churn_rate_pct DESC;


-- Query 17: Senior Citizen Churn Analysis
-- Purpose:
-- Compares churn between senior citizens
-- and non-senior customers.
-- This helps identify whether age-related customer groups
-- show different churn behavior.
-- =========================================================

SELECT
    -- Senior citizen flag
    senior_citizen,

    -- Total customers in each group
    COUNT(DISTINCT customer_id) AS total_customers,

    -- Customers who churned
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 1) AS churned_customers,

    -- Customers who are retained
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 0) AS retained_customers,

    -- Churn rate percentage
    ROUND(
        100.0
        * COUNT(DISTINCT customer_id)
            FILTER (WHERE churn_flag = 1)
        / NULLIF(COUNT(DISTINCT customer_id), 0),
        2
    ) AS churn_rate_pct

FROM telco_churn

-- Compare senior and non-senior customer groups
GROUP BY senior_citizen

-- Show senior citizen group first
ORDER BY senior_citizen DESC;



-- Query 18: Top High-Risk Customer Action List
-- Purpose:
-- Creates a prioritized list of active high-risk customers
-- so the retention team can focus on the most valuable
-- customers first.
-- =========================================================

SELECT
    -- Unique customer identifier
    customer_id,

    -- Customer tenure
    tenure,

    -- Contract type
    contract,

    -- Monthly customer charge
    monthly_charges,

    -- Historical total customer value
    total_charges,

    -- Customer value category
    customer_value_segment,

    -- Engagement level
    engagement_segment,

    -- Number of active services
    service_count,

    -- Tech Support status
    tech_support,

    -- Online Security status
    online_security,

    -- High-risk status
    high_risk_flag

FROM telco_churn

-- Keep only active customers who are high-risk
WHERE high_risk_flag = 1
  AND churn_flag = 0

-- Prioritize higher-value customers first
ORDER BY
    total_charges DESC,
    monthly_charges DESC

-- Show the top 25 customers for immediate action
LIMIT 25;



-- Query 19: Retention Priority Segmentation
-- Purpose:
-- Segments active customers into retention priority levels
-- using risk status and customer value.
-- This helps the retention team focus efforts efficiently.
-- =========================================================

SELECT
    -- Unique customer identifier
    customer_id,

    -- Customer value category
    customer_value_segment,

    -- Customer engagement category
    engagement_segment,

    -- Monthly charge
    monthly_charges,

    -- Historical customer value
    total_charges,

    -- High-risk flag
    high_risk_flag,

    -- Create retention priority category
    CASE
        -- Highest priority:
        -- High-risk and High Value customers
        WHEN high_risk_flag = 1
             AND customer_value_segment = 'High Value'
        THEN 'Priority 1 - Immediate Action'

        -- Medium priority:
        -- High-risk but not High Value
        WHEN high_risk_flag = 1
        THEN 'Priority 2 - Retention Action'

        -- Lower priority:
        -- Not high-risk but High Value
        WHEN high_risk_flag = 0
             AND customer_value_segment = 'High Value'
        THEN 'Priority 3 - Monitor Closely'

        -- Remaining active customers
        ELSE 'Priority 4 - Regular Monitoring'
    END AS retention_priority

FROM telco_churn

-- Only customers who are still active
WHERE churn_flag = 0

-- Show highest priority customers first
ORDER BY
    CASE
        WHEN high_risk_flag = 1
             AND customer_value_segment = 'High Value' THEN 1
        WHEN high_risk_flag = 1 THEN 2
        WHEN high_risk_flag = 0
             AND customer_value_segment = 'High Value' THEN 3
        ELSE 4
    END,
    total_charges DESC;




-- Query 20: Final Management Summary
-- Purpose:
-- Provides a single executive-level summary of
-- customer churn, high-risk customers, and financial impact.
-- =========================================================

SELECT
    -- Total unique customers
    COUNT(DISTINCT customer_id) AS total_customers,

    -- Total churned customers
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 1) AS churned_customers,

    -- Total retained customers
    COUNT(DISTINCT customer_id)
        FILTER (WHERE churn_flag = 0) AS retained_customers,

    -- Overall churn rate percentage
    ROUND(
        100.0
        * COUNT(DISTINCT customer_id)
            FILTER (WHERE churn_flag = 1)
        / NULLIF(COUNT(DISTINCT customer_id), 0),
        2
    ) AS churn_rate_pct,

    -- Total customers marked as high-risk
    COUNT(DISTINCT customer_id)
        FILTER (WHERE high_risk_flag = 1) AS high_risk_customers,

    -- High-risk customers who are still active
    COUNT(DISTINCT customer_id)
        FILTER (
            WHERE high_risk_flag = 1
              AND churn_flag = 0
        ) AS active_high_risk_customers,

    -- High-value customers who have already churned
    COUNT(DISTINCT customer_id)
        FILTER (
            WHERE customer_value_segment = 'High Value'
              AND churn_flag = 1
        ) AS high_value_churned_customers,

    -- Monthly revenue associated with churned customers
    ROUND(
        SUM(monthly_revenue_at_risk),
        2
    ) AS monthly_revenue_at_risk,

    -- Historical customer value associated with churn
    ROUND(
        SUM(customer_value_lost),
        2
    ) AS customer_value_lost

FROM telco_churn;	


-- =========================================================
-- File: 01_create_churn_tables.sql
-- Purpose:
-- Creates the main cleaned telecom churn table
-- used for SQL analysis.
-- =========================================================

DROP TABLE IF EXISTS telco_churn;

CREATE TABLE telco_churn (
    customer_id VARCHAR(20) PRIMARY KEY,
    gender VARCHAR(10),
    senior_citizen INTEGER,
    partner VARCHAR(5),
    dependents VARCHAR(5),
    tenure INTEGER,
    phone_service VARCHAR(20),
    multiple_lines VARCHAR(30),
    internet_service VARCHAR(30),
    online_security VARCHAR(30),
    online_backup VARCHAR(30),
    device_protection VARCHAR(30),
    tech_support VARCHAR(30),
    streaming_tv VARCHAR(30),
    streaming_movies VARCHAR(30),
    contract VARCHAR(30),
    paperless_billing VARCHAR(5),
    payment_method VARCHAR(50),
    monthly_charges NUMERIC(10,2),
    total_charges NUMERIC(12,2),
    churn VARCHAR(5),
    churn_flag INTEGER,
    tenure_group VARCHAR(30),
    monthly_charge_band VARCHAR(30),
    customer_value_segment VARCHAR(30),
    service_count INTEGER,
    engagement_segment VARCHAR(30),
    high_risk_flag INTEGER,
    monthly_revenue_at_risk NUMERIC(12,2),
    customer_value_lost NUMERIC(12,2)
);