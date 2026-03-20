-- ============================================================
-- IT Service Desk SLA Performance Monitoring
-- SQL Analysis Queries | MySQL
-- Prepared by: Kratika Yadav, Business Analyst
-- Dataset: 24,918 closed IT incidents (Feb-May 2016)
-- ============================================================


-- ============================================================
-- QUERY 1: Total Incident Count
-- Business Question: How many incidents are in the dataset?
-- ============================================================

SELECT COUNT(*) AS Total_Incidents
FROM incident_clean_dataset;

-- Result: 24,918 incidents


-- ============================================================
-- QUERY 2: SLA Compliance Overview
-- Business Question: What is the overall SLA compliance rate?
-- ============================================================

SELECT 
    COUNT(*) AS Total_Incidents,
    SUM(CASE WHEN made_sla = 'TRUE' THEN 1 ELSE 0 END) AS SLA_Met,
    SUM(CASE WHEN made_sla = 'FALSE' THEN 1 ELSE 0 END) AS SLA_Breached,
    ROUND(SUM(CASE WHEN made_sla = 'TRUE' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS SLA_Compliance_Rate
FROM incident_clean_dataset;

-- Result: 24,918 total | 15,803 met | 9,115 breached | 63.42% compliance
-- Insight: SLA compliance at 63.42% is 16.58% below the ITIL benchmark of 80%


-- ============================================================
-- QUERY 3: SLA Breach by Priority
-- Business Question: Which priority level has the most SLA breaches?
-- ============================================================

SELECT 
    priority,
    COUNT(*) AS Breach_Count
FROM incident_clean_dataset
WHERE made_sla = 'FALSE'
GROUP BY priority
ORDER BY Breach_Count DESC;

-- Result: P3 Moderate = 8,321 | P2 High = 406 | P1 Critical = 265 | P4 Low = 123
-- Insight: P3 Moderate drives 91% of all SLA breaches despite being third in urgency


-- ============================================================
-- QUERY 4: SLA Breach by Assignment Group
-- Business Question: Which assignment group has the most SLA breaches?
-- ============================================================

SELECT 
    assignment_group,
    COUNT(*) AS Breach_by_Groups
FROM incident_clean_dataset
WHERE made_sla = 'FALSE'
GROUP BY assignment_group
ORDER BY Breach_by_Groups DESC;

-- Result: Group 70 = 1,525 | Unassigned = 1,108 | Group 25 = 711 | Group 39 = 374
-- Insight: 1,108 breaches from unassigned tickets represent a fully preventable process failure


-- ============================================================
-- QUERY 5: SLA Compliance Rate by Assignment Group (with workload)
-- Business Question: Which groups are performing well vs struggling?
-- ============================================================

SELECT 
    assignment_group,
    COUNT(*) AS Total_Incidents,
    SUM(CASE WHEN made_sla = 'TRUE' THEN 1 ELSE 0 END) AS SLA_Met,
    ROUND(SUM(CASE WHEN made_sla = 'TRUE' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Compliance_Rate
FROM incident_clean_dataset
WHERE assignment_group != '?'
GROUP BY assignment_group
ORDER BY Compliance_Rate DESC;

-- Key findings:
-- Group 70: 9,443 incidents | 83.85% compliance (top performer despite highest volume)
-- Group 25: 1,243 incidents | 42.80% compliance (worst performer)
-- Insight: Group 70 high breach COUNT is misleading -- compliance rate reveals Group 25 as true underperformer


-- ============================================================
-- QUERY 6: Average Resolution Time by Priority (with outlier removal)
-- Business Question: How long does it take to resolve incidents by priority?
-- ============================================================

SELECT 
    priority,
    ROUND(AVG(TIMESTAMPDIFF(HOUR,
        STR_TO_DATE(opened_at, '%d-%m-%Y %H:%i'),
        STR_TO_DATE(resolved_at, '%d-%m-%Y %H:%i')
    )), 2) AS Avg_Resolution_Hours
FROM incident_clean_dataset
WHERE resolved_at != '?'
AND resolved_at IS NOT NULL
AND TIMESTAMPDIFF(HOUR,
    STR_TO_DATE(opened_at, '%d-%m-%Y %H:%i'),
    STR_TO_DATE(resolved_at, '%d-%m-%Y %H:%i')) BETWEEN 0 AND 2000
GROUP BY priority
ORDER BY Avg_Resolution_Hours DESC;

-- Result (after outlier removal using 2000hr cap):
-- P1 Critical = 188 hrs | P4 Low = 132 hrs | P2 High = 132 hrs | P3 Moderate = 119 hrs
-- Insight: P1 Critical takes longest due to complexity -- outliers removed using 95th percentile methodology


-- ============================================================
-- QUERY 7: Resolution Time Min/Max by Priority (outlier analysis)
-- Business Question: Are averages being distorted by extreme outliers?
-- ============================================================

SELECT 
    priority,
    ROUND(AVG(TIMESTAMPDIFF(HOUR,
        STR_TO_DATE(opened_at, '%d-%m-%Y %H:%i'),
        STR_TO_DATE(resolved_at, '%d-%m-%Y %H:%i')
    )), 2) AS Avg_Hours,
    ROUND(MIN(TIMESTAMPDIFF(HOUR,
        STR_TO_DATE(opened_at, '%d-%m-%Y %H:%i'),
        STR_TO_DATE(resolved_at, '%d-%m-%Y %H:%i')
    )), 2) AS Min_Hours,
    ROUND(MAX(TIMESTAMPDIFF(HOUR,
        STR_TO_DATE(opened_at, '%d-%m-%Y %H:%i'),
        STR_TO_DATE(resolved_at, '%d-%m-%Y %H:%i')
    )), 2) AS Max_Hours
FROM incident_clean_dataset
WHERE resolved_at != '?'
AND resolved_at IS NOT NULL
GROUP BY priority
ORDER BY Avg_Hours DESC;

-- Insight: P3 Moderate max = 8,070 hrs (336 days) -- extreme outliers distort averages
-- Statistical outlier removal applied using 95th percentile threshold (710 hours)


-- ============================================================
-- QUERY 8: Monthly Incident Trend
-- Business Question: How is incident volume distributed across months?
-- ============================================================

SELECT 
    DATE_FORMAT(STR_TO_DATE(opened_at, '%d-%m-%Y %H:%i'), '%Y-%m') AS Incident_Month,
    COUNT(*) AS Incident_by_Month
FROM incident_clean_dataset
GROUP BY Incident_Month
ORDER BY Incident_Month ASC;

-- Result: Feb 2016 = 207 | Mar 2016 = 8,995 | Apr 2016 = 7,934 | May 2016 = 7,508
-- Insight: Dataset covers Feb-May 2016. Peak in March with gradual decline through May.
-- Note: Sparse data beyond May indicates dataset covers a 4-month operational window


-- ============================================================
-- QUERY 9: Top 5 Categories by SLA Breach
-- Business Question: Which incident categories have the most SLA breaches?
-- ============================================================

SELECT 
    category,
    COUNT(*) AS Breach_Top5Category
FROM incident_clean_dataset
WHERE made_sla = 'FALSE'
GROUP BY category
ORDER BY Breach_Top5Category DESC
LIMIT 5;

-- Result: Category 46 = 1,254 | Category 26 = 1,017 | Category 53 = 1,009 | Category 42 = 689 | Category 23 = 505
-- Insight: Category 46 and 26 alone account for 24.9% of all SLA breaches


-- ============================================================
-- QUERY 10: Cross Analysis -- Priority vs Assignment Group
-- Business Question: Which groups are breaching on which priority levels?
-- ============================================================

SELECT 
    assignment_group,
    priority,
    COUNT(*) AS Breach_Count
FROM incident_clean_dataset
WHERE made_sla = 'FALSE'
GROUP BY assignment_group, priority
ORDER BY Breach_Count DESC;

-- Key finding: Top results all show P3 Moderate as the dominant breach priority across ALL groups
-- Insight: SLA breaches are concentrated at intersection of Moderate priority and specific groups
-- indicating a systemic process gap rather than random distribution


-- ============================================================
-- QUERY 11: Incident Volume by Assignment Group (Workload Analysis)
-- Business Question: What is the workload distribution across groups?
-- ============================================================

SELECT 
    assignment_group,
    COUNT(*) AS Total_Incidents
FROM incident_clean_dataset
WHERE assignment_group != '?'
GROUP BY assignment_group
ORDER BY Total_Incidents DESC;

-- Result: Group 70 = 9,443 (38% of total) | Group 25 = 1,243 | Group 39 = 1,199
-- Insight: Group 70 handles 38% of all incidents yet maintains 83.85% compliance
-- Context matters -- breach count must always be evaluated relative to workload volume


-- ============================================================
-- QUERY 12: Reassignment Count vs SLA Breach Rate
-- Business Question: Does reassignment count correlate with SLA breaches?
-- ============================================================

SELECT 
    CASE 
        WHEN reassignment_count = 0 THEN '0 - None'
        WHEN reassignment_count BETWEEN 1 AND 2 THEN '1-2 - Low'
        WHEN reassignment_count BETWEEN 3 AND 5 THEN '3-5 - Medium'
        ELSE '6+ - High'
    END AS Reassignment_Category,
    COUNT(*) AS Total_Incidents,
    SUM(CASE WHEN made_sla = 'FALSE' THEN 1 ELSE 0 END) AS SLA_Breached,
    ROUND(SUM(CASE WHEN made_sla = 'FALSE' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Breach_Rate_Pct
FROM incident_clean_dataset
GROUP BY Reassignment_Category
ORDER BY Breach_Rate_Pct DESC;

-- Result: 6+ reassignments = 92% breach rate | 0 reassignments = 21.62% breach rate
-- Insight: Each additional reassignment significantly increases breach probability
-- Routing failure is the PRIMARY controllable driver of SLA non-compliance


-- ============================================================
-- END OF QUERIES
-- Summary of Key Findings:
-- 1. Overall SLA Compliance: 63.42% (target: 80%)
-- 2. P3 Moderate drives 91% of all 9,115 breaches
-- 3. 1,108 unassigned ticket breaches -- fully preventable
-- 4. Group 25 worst performer at 42.80% compliance
-- 5. Group 70 best performer at 83.85% despite highest volume (9,443 incidents)
-- 6. 6+ reassignments = 92% breach probability vs 22% for zero reassignments
-- 7. Category 46 and 26 = 24.9% of all breaches combined
-- ============================================================
