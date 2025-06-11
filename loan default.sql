CREATE DATABASE loans;
USE LOANS;

CREATE TABLE loan_data (
    credit_policy       INT,
    purpose             VARCHAR(100),
    int_rate            FLOAT,
    installment         FLOAT,
    log_annual_inc      FLOAT,
    dti                 FLOAT,
    fico                INT,
    days_with_cr_line   FLOAT,
    revol_bal           FLOAT,
    revol_util          FLOAT,
    inq_last_6mths      INT,
    delinq_2yrs         INT,
    pub_rec             INT,
    not_fully_paid      INT
);

SELECT*FROM loan_data;

-- Basic SQL Queries (Understanding Data Structure)

-- 1. View all data
SELECT * FROM loan_data;

-- 2. Count total records
SELECT COUNT(*) AS total_loans FROM loan_data;

-- 3. View column-wise data types
DESCRIBE loan_data;

-- Intermediate Queries (Summary & Aggregations)

-- 4. Total Defaults vs Fully Paid Loans
SELECT 
    not_fully_paid,
    COUNT(*) AS total_customers
FROM loan_data
GROUP BY not_fully_paid;

-- 5. Default Rate
SELECT 
    ROUND(AVG(not_fully_paid)*100, 2) AS default_rate_percentage
FROM loan_data;

-- 6. Loan Purpose vs Default Count
SELECT purpose, COUNT(*) AS total_loans,
    SUM(not_fully_paid) AS defaults,
    ROUND(AVG(not_fully_paid)*100, 2) AS default_rate
FROM loan_data
GROUP BY purpose
ORDER BY default_rate DESC;

-- 7. Credit Policy Impact
SELECT 
    credit_policy,
    COUNT(*) AS total_loans,
    SUM(not_fully_paid) AS defaults,
    ROUND(AVG(not_fully_paid)*100, 2) AS default_rate
FROM loan_data
GROUP BY credit_policy;

-- 8. Default Rate by FICO Score
SELECT 
    fico,
    COUNT(*) AS total_loans,
    SUM(not_fully_paid) AS defaults,
    ROUND(AVG(not_fully_paid)*100, 2) AS default_rate
FROM loan_data
GROUP BY fico
ORDER BY fico;

-- (Segmentation & Risk Profiling)

-- 9. Interest Rate Bands vs Default Risk
SELECT 
    CASE 
        WHEN int_rate < 0.1 THEN 'Low'
        WHEN int_rate BETWEEN 0.1 AND 0.2 THEN 'Medium'
        ELSE 'High'
    END AS interest_band,
    COUNT(*) AS total_loans,
    SUM(not_fully_paid) AS defaults,
    ROUND(AVG(not_fully_paid)*100, 2) AS default_rate
FROM loan_data
GROUP BY interest_band;

-- 10. Income Level Impact
SELECT 
    ROUND(EXP(log_annual_inc)) AS annual_income,
    not_fully_paid
FROM loan_data
ORDER BY annual_income DESC;

-- 11. Installment vs Default (Binned)
SELECT 
    ROUND(installment, -1) AS installment_band,
    COUNT(*) AS total_loans,
    SUM(not_fully_paid) AS defaults,
    ROUND(AVG(not_fully_paid)*100, 2) AS default_rate
FROM loan_data
GROUP BY ROUND(installment, -1)
ORDER BY installment_band;

-- 12. DTI vs Default
SELECT 
    ROUND(dti) AS dti_band,
    COUNT(*) AS total_loans,
    SUM(not_fully_paid) AS defaults,
    ROUND(AVG(not_fully_paid)*100, 2) AS default_rate
FROM loan_data
GROUP BY ROUND(dti)
ORDER BY dti_band;

-- 13. Revolving Balance vs Default
SELECT 
    ROUND(revol_bal, -2) AS revol_bal_band,
    COUNT(*) AS total_loans,
    SUM(not_fully_paid) AS defaults,
    ROUND(AVG(not_fully_paid)*100, 2) AS default_rate
FROM loan_data
GROUP BY ROUND(revol_bal, -2)
ORDER BY revol_bal_band;

-- 14. Revolving Utilization Rate vs Default
SELECT 
    ROUND(revol_util, 0) AS utilization_band,
    COUNT(*) AS total_loans,
    SUM(not_fully_paid) AS defaults,
    ROUND(AVG(not_fully_paid)*100, 2) AS default_rate
FROM loan_data
GROUP BY ROUND(revol_util, 0)
ORDER BY utilization_band;

-- 15. Impact of Inquiries in Last 6 Months
SELECT 
    inq_last_6mths,
    COUNT(*) AS total_loans,
    SUM(not_fully_paid) AS defaults
FROM loan_data
GROUP BY inq_last_6mths
ORDER BY inq_last_6mths;

-- 16. Public Records vs Defaults
SELECT 
    pub_rec,
    COUNT(*) AS total_loans,
    SUM(not_fully_paid) AS defaults,
    ROUND(AVG(not_fully_paid)*100, 2) AS default_rate
FROM loan_data
GROUP BY pub_rec
ORDER BY pub_rec;

-- 17. Delinquencies in 2 Years
SELECT 
    delinq_2yrs,
    COUNT(*) AS total_loans,
    SUM(not_fully_paid) AS defaults,
    ROUND(AVG(not_fully_paid)*100, 2) AS default_rate
FROM loan_data
GROUP BY delinq_2yrs
ORDER BY delinq_2yrs;

-- High-Risk Profile Identification
SELECT *
FROM loan_data
WHERE int_rate > 0.2 AND fico < 650 AND inq_last_6mths > 3
ORDER BY not_fully_paid DESC;













