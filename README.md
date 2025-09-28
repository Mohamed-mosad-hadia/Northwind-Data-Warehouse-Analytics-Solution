# Northwind Data Warehouse & Analytics

 <a href="https://www.linkedin.com/in/mohamed-mosaad-85840b254" target="_blank">
        <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" target="_blank" />
    </a>
    
## 📌 Project Overview
Northwind Traders is an international importer/exporter of food products.  
This project designs and implements a **Data Warehouse (DWH)** and analytics solution to provide insights into **sales, profitability, customers, employees, logistics, and invoices**.

## 🏢 Business Requirements
- Sales insights (by product, category, region, sales representative)
- Top 10 products & customers
- Profitability analysis (margins, discounts)
- Customer & employee performance
- Logistics & delivery (shipper comparison, delivery times)
- Invoice monitoring (outstanding amounts)

  
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

  ## Design
  - Star Schema ⭐

## ⚙️ ETL Process
1. Extract from Northwind OLTP → staging (Bronze 🥉 layer)  
2. Transform (cleaning, surrogate keys, handling SCD2)  (Silver 🥉 layer)  
3. Load into DWH (fact & dimension tables) (Gold 🥉 layer)  

## 📊 Reports & KPIs
- Sales trends (monthly/quarterly)  
- Top 10 products & customers  
- Profit margins by category & supplier  
- Employee sales contribution  
- Shipper delivery time & cost comparison  
- Invoice outstanding & aging analysis  




## 🗂️ Medallion Architecture – ETL Pipeline
![ETL Process](https://github.com/Mohamed-mosad-hadia/Northwind-Data-Warehouse-Analytics-Solution/blob/main/3-Gold%20Layer/ETL_process.png)



## 🚩 Star Schema Design 
![ETL Process](https://github.com/Mohamed-mosad-hadia/Northwind-Data-Warehouse-Analytics-Solution/blob/main/3-Gold%20Layer/Schema_design.png)





##  Connect With Me:<img src="https://github.com/0xAbdulKhalid/0xAbdulKhalid/raw/main/assets/mdImages/handshake.gif" width ="80">

<div align="center">
 <a href="https://www.linkedin.com/in/mohamed-mosaad-85840b254" target="_blank">
        <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" target="_blank" />
    </a>
 <a href="mailto:muhamed.mosadd@gmail.com">
    <img src="https://img.shields.io/badge/Gmail-333333?style=for-the-badge&logo=gmail&logoColor=red" />
  </a>
   <a href="https://wa.me/201069781595" target="_blank">
      <img src="https://img.shields.io/badge/WhatsApp-25D366?style=for-the-badge&logo=whatsapp&logoColor=white" target="_blank" alt="WhatsApp">
   </a>
     </a>
   <a href="https://www.instagram.com/mmosad22" target="_blank">
      <img src="https://img.shields.io/badge/Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white" target="_blank" alt="Instagram">
   </a>
</div>

