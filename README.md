# Northwind Data Warehouse & Analytics

## 📌 Project Overview
Northwind Traders is an international importer/exporter of food products.  
This project designs and implements a **Data Warehouse (DWH)** and analytics solution to provide insights into **sales, profitability, customers, employees, logistics, and invoices**.

## 🏢 Business Requirements
- Sales insights (by product, category, region, sales representative)
- Top 10 products & customers
- Profitability analysis (margins, discounts)
- Customer & employee performance
- Logistics & delivery (shipper comparison, delivery times)
- Invoice monitoring (outstanding amounts, aging)

  
## 🏢 Business Process 
- Sales
- Shipment
- Invoice

## 📌 Grains

| Fact Table     | Grain (Level of Detail)          | Meaning                                                |
|----------------|----------------------------------|--------------------------------------------------------|
| **Fact_Sales**    | One row per order line            | Each row = a product sold in a specific order (qty, price, discount, cost, revenue, profit). |
| **Fact_Shipment** | One row per order shipment        | Each row = shipment details for an order (delivery days, shipping fee, on-time status). |
| **Fact_Invoice**  | One row per invoice              | Each row = financial record of an invoice (amount due, total, paid, outstanding). |


## 🚀 Deliverables
- **Phase 1:** Business understanding & modeling:contentReference
- **Phase 2:** Data preparation & ETL with SQL:contentReference
- **Phase 3:** Data warehouse implementation (facts & dimensions)
- **Phase 4:** Reporting & analytics (SQL queries, dashboards)
- **Phase 5:** Documentation & presentation

## 🗄️ Data Model
- **Facts:** Sales, Shipments, Invoices
- **Dimensions:** Customer, Product, Supplier, Employee, Shipper, Invoice, Date

## ⚙️ ETL Process
1. Extract from Northwind OLTP → staging (Silver layer)  
2. Transform (cleaning, surrogate keys, handling SCD2)  
3. Load into DWH (fact & dimension tables)

## 📊 Reports & KPIs
- Sales trends (monthly/quarterly)  
- Top 10 products & customers  
- Profit margins by category & supplier  
- Employee sales contribution  
- Shipper delivery time & cost comparison  
- Invoice outstanding & aging analysis  




## 🗂️ Medallion Architecture – ETL Pipeline
![ETL Process](https://github.com/Mohamed-mosad-hadia/Northwind-Data-Warehouse-Analytics-Solution/blob/main/3-Gold%20Layer/ETL_process.png)



## 🚩 Schema Design 
![ETL Process](https://github.com/Mohamed-mosad-hadia/Northwind-Data-Warehouse-Analytics-Solution/blob/main/3-Gold%20Layer/Schema_design.png)
