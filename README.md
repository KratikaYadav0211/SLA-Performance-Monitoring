# IT Service Desk SLA Performance Monitoring
### Business Analyst Portfolio Project | MySQL · Power BI · DAX · Excel

---

## Problem Statement
NexaServ Technologies lacked real-time visibility into SLA performance, 
resulting in undetected breaches, unassigned incidents and no structured 
monitoring across priority levels and assignment groups.

---

## Tools Used
| Tool | Purpose |
|------|---------|
| MySQL | Data cleaning and SQL analysis |
| Power BI | Interactive dashboard development |
| DAX | Custom KPI measures |
| Excel | Data preparation and filtering |
| draw.io | Process flow diagrams |

---

## Dataset
- Source: Kaggle IT Incident Log Dataset (ServiceNow)
- Cleaned: 24,918 unique closed incidents filtered from 141,712 event log entries
- Period: February to May 2016

---

## Key Findings
| Metric | Finding |
|--------|---------|
| SLA Compliance Rate | 63.42% — 16.58% below ITIL benchmark |
| Total SLA Breaches | 9,115 incidents |
| P3 Moderate Breach Share | 91% of all breaches |
| Unassigned Ticket Breaches | 1,108 — fully preventable |
| Worst Performing Group | Group 25 at 42.80% compliance |
| Best Performing Group | Group 70 at 83.85% despite the highest volume |
| Reassignment Impact | 6+ reassignments = 92% breach probability |

---

## Dashboard Structure
**Page 1 — Executive Summary**
- 5 KPI cards with RAG colour coding
- Monthly incident trend
- SLA breach by priority
- SLA compliance by priority
- Top 5 categories and groups by breach

**Page 2 — Operational Analysis**
- Group workload vs compliance comparison
- Stacked column — breach by group and priority
- Average resolution time by priority
- Assignment group slicer for dynamic filtering

**Page 3 — Root Cause Analysis**
- Reassignment count vs breach rate
- Category impact analysis
- Operational risk drivers

**Page 4 — Incident Detail**
- Drill-through table with individual incident details
- Dynamic filtering from Page 2

---

## Project Deliverables
- 📊 [SLA Dashboard PDF](SLA_Dashboard.pdf)
- 📄 [Business Requirements Document](NexaServ_SLA_BRD_v3.docx)
- 📄 [To-Be Process Document](NexaServ_ToBe_Process.docx)
- 📈 [As-Is Process Diagram](SLA_AsIs_Process.drawio.png)
- 📈 [To-Be Process Diagram](SLA_ToBe_Process-Page-2.drawio.png)
- 📈 [Escalation Workflow](SLA_Escalation_workflow.drawio.png)
- 💾 [SQL Queries](SLA_SQL_Queries.sql)

---

## SQL Analysis
Key queries written and executed in MySQL:
1. Total incidents and SLA compliance rate
2. SLA breach by priority level
3. SLA breach by assignment group
4. Average resolution time by priority (with outlier removal)
5. Monthly incident trend analysis
6. Top 5 categories by breach count
7. Cross analysis — priority vs assignment group
8. Group compliance rate with workload context
9. Reassignment count vs SLA breach rate

---

## Business Recommendations
1. Implement automated unassigned ticket alerts — eliminates 1,108 preventable breaches
2. Prioritise Group 25 intervention — 42.80% compliance despite moderate workload
3. Review SLA thresholds for P3 Moderate — 91% of breaches concentrated here
4. Introduce reassignment limits — 6+ reassignments increase breach probability to 92%
5. Deploy 4-level escalation workflow — 50%, 75%, 100% and post-breach alerts

---

*Prepared by Kratika Yadav | MBA (HR) | Aspiring Business Analyst*
*Connect: linkedin.com/in/kratika-yadav-6b073a284*
