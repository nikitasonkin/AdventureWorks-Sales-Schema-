# AdventureWorks-Derived Sales Schema 🏗️

> **Author:** Nikita Sonkin  
> **Base Dataset:** AdventureWorks 2022  
> **License:** MIT

## 📌 Project Purpose

This project presents the full process of building a relational database from scratch using SQL.  
It includes structured schema creation, data population from AdventureWorks2022, and analytical SQL queries that demonstrate the schema’s capabilities.  
The project serves both as a **portfolio piece** and a **hands-on playground** for database design, ETL, and analytics.

---

## 📚 Table of Contents

1. [Introduction](#1.Introduction)  
2. [Database Structure](#2-database-structure)  
3. [Data Import and Initialization](#3-data-import-and-initialization)  
4. [Queries and Insights](#4-queries-and-insights)  
5. [Summary and Conclusions](#5-summary-and-conclusions)  
6. [References and Appendices](#6-references-and-appendices)  

---

## 1. Introduction

### 1.1 Project Overview
This project simulates a complete relational database based on business domains such as sales, purchasing, production, and HR, using SQL and structured schemas.  
The architecture is clean, normalized, and enriched with real data from AdventureWorks2022.

### 1.2 Objectives
- Demonstrate advanced SQL proficiency and database modeling  
- Show clear entity relationships and integrity constraints  
- Produce meaningful analysis using SQL queries  
- Serve as a strong GitHub portfolio entry

### 1.3 Technologies Used
- **SQL Server / T-SQL**
- **AdventureWorks2022** sample database  
- Advanced usage of **schemas**, **foreign keys**, **computed columns**, and **user-defined functions**

---

## 2. Database Structure

### 2.1 Schemas
The database includes 5 logical schemas, each organizing entities by business area:
- `Sales` – orders, customers, credit cards, currency, and territory
- `Person` – personal details and addresses
- `Purchasing` – shipping methods
- `Production` – products, categories, and subcategories
- `HumanResources` – employees, departments, shifts

### 2.2 Tables and Purpose
Each schema contains purpose-built tables:
- **Sales**: `SalesOrderHeader`, `SalesOrderDetail`, `Customer`
- **Person**: `Person`, `Address`
- **Production**: `Product`, `ProductCategory`, `ProductSubcategory`
- **HumanResources**: `Employee`, `Department`, `Shift`, `EmployeeDepartmentHistory`

### 2.3 Relationships
All tables are linked via **foreign keys**, ensuring referential integrity and enabling deep analysis.  
For example:  
`SalesOrderDetail` → `SalesOrderHeader` via `SalesOrderID`  
`SalesOrderDetail` → `Product` via `ProductID`

---

## 3. Data Import and Initialization

### 3.1 Data Source
The project uses real business data from **AdventureWorks2022**.  
Data is inserted using `INSERT INTO ... SELECT FROM`, importing directly from the original structure.

### 3.2 Identity and Consistency
To maintain consistency and preserve keys, the project uses `SET IDENTITY_INSERT ON` for tables with identity columns.  
This ensures correct references across foreign keys and maintains full data integrity.

---

## 4. Queries and Insights

### 4.1 Top 5 Products by Revenue
Identifies the most profitable products by total sales.  
**Insight**: Products with IDs 879 and 925 generate significantly higher revenue – consider prioritizing these in promotions or stock planning.

### 4.2 Bike Category Pricing
Displays unit prices for products in the *Bikes* category.  
**Insight**: There are two clear price tiers – ~2025 (premium) and ~419 (standard), which suggests segmentation opportunities.

### 4.3 Excluding Components and Clothing
Shows sales quantities for products outside the *Components* and *Clothing* categories.  
**Insight**: Products like “Road-150 Red” and “Road-650” in sizes 48–62 are highly demanded – optimize inventory accordingly.

### 4.4 Top Territories by Total Sales
Ranks the three best-performing sales territories.  
**Insight**: *Southwest* leads significantly (27M+), followed by *Canada* and *Northwest*. This region may warrant further strategic investment.

### 4.5 Customers Without Orders
Finds customers who never placed an order.  
**Insight**: These may be inactive users or registration errors – good candidates for re-engagement campaigns.

### 4.6 Delete Unused Territories
Removes sales territories with no assigned salespeople.  
**Explanation**: Uses `LEFT JOIN` to identify orphan records, keeping the database clean and relevant.

### 4.7 Add Missing Territories
Inserts new territories from source data that are not already present.  
**Explanation**: Ensures up-to-date and complete territory coverage using `IDENTITY_INSERT` for key preservation.

### 4.8 Customers With High Order Volume
Lists customers with more than 20 orders.  
**Insight**: These power users (e.g. Dalton Perez, Mason Roberts) may deserve loyalty programs or VIP treatment.

### 4.9 Department Group Count
Counts departments grouped by business function.  
**Insight**: The “Executive General and Administration” group appears 10 times – check for potential redundancy or organizational imbalance.

### 4.10 Employees Hired After 2010
Identifies recent hires in Manufacturing and QA departments.  
**Insight**: Useful for HR onboarding metrics – e.g., Sheela Word joined QA Day shift post-2010.

---

## 5. Summary and Conclusions

### 5.1 Key Insights
- Clear concentration of revenue in specific products and regions  
- Strategic potential in understanding customer segments  
- Identified data maintenance actions (e.g., removing orphans, syncing territories)

### 5.2 Recommendations
- Create summary views for business KPIs  
- Build indexes on key foreign keys  
- Consider Power BI integration for visualization  
- Implement alerting on inactive customers or underutilized departments

---

## 6. References and Appendices

### 6.1 SQL Files
- `project1.sql`: full DDL, data import, and 10 demo queries

### 6.2 Supporting Materials
- Outputs were generated using SQL Server Management Studio (SSMS)  
- Source data: `AdventureWorks2022` by Microsoft

---

> Built with ❤️ by Nikita Sonkin
