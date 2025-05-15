# AdventureWorks-Derived Sales Schema 🏗️

> **Author:** Nikita Sonkin  
> **Base Dataset:** AdventureWorks 2022  
> **License:** MIT

## Project Purpose
This repository delivers a **full SQL build script** (`project1.sql`) that:

1. **Creates** a *Sales*-centric data model (15+ tables across `Sales`, `Person`, `Purchasing`, `Production`, `HumanResources` schemas).  
2. **Loads** real data by pulling from Microsoft’s AdventureWorks 2022 database (`INSERT ... SELECT` with `IDENTITY_INSERT` where needed).  
3. **Demonstrates** ten analytical & DML scenarios showcasing the schema’s business utility.

The result is a portable sandbox for practicing data warehousing concepts, query optimisation and reporting.

## Quick Start

| Step | Action |
|------|--------|
| 1 | Restore **AdventureWorks2022.bak** (if not already present). |
| 2 | Adjust connection context to a clean database (e.g. `SalesLab`). |
| 3 | Run **`project1.sql`** top-to-bottom (DDL → data load → sample queries). |
| 4 | Validate table counts and run the *Top 10* demo queries for instant insights. |

## Schema Highlights

* **Star-friendly layout** – central `SalesOrderHeader` and `SalesOrderDetail` fact tables referencing dimension-style tables (`Customer`, `Product`, `Territory`, etc.).  
* **Built-in data quality rules** – check constraints on monetary columns (`ShipBase`, `ShipRate`, `Bonus`).  
* **Utility function** `dbo.ufnLeadingZeros` to generate account numbers with padded zeros.  
* **Identity management** – explicit `SET IDENTITY_INSERT` blocks ensure referential integrity when migrating AdventureWorks data. :contentReference[oaicite:2]{index=2}:contentReference[oaicite:3]{index=3}

## Demo Query Set

| # | Description |
|---|-------------|
| 1 | Top 5 products by total sales value |
| 2 | Bike category pricing breakdown |
| 3 | Product orders excluding *Components* and *Clothing* |
| 4 | Top territories by revenue (fix pending if result empty) |
| 5 | Customers without orders (*potential prospects*) |
| 6 | Delete empty territories (shows safe DML with `LEFT JOIN`) |
| 7 | Sync new territories from source AdventureWorks |
| 8 | Customers with > 20 orders (power users) |
| 9 | Department group counts (> 2 in group) |
| 10| Employees hired after 2010 in Manufacturing / QA shifts |

> Full query text and comments are inside `project1.sql`.

## Suggested Extensions
* Add indexes on foreign keys for faster joins.  
* Create views for common KPIs (e.g., Sales by Region, Customer Lifetime Value).  
* Export selected tables to Power BI for visual dashboards.

## Contribution & Issues
Feel free to open issues for clarification or performance tweaks. Pull requests that add documentation or test data are highly appreciated.

---

