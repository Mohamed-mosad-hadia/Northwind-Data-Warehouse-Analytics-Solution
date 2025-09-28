-- ==============================
-- DWH Dashboard Queries (Sales, Profitability, Customers, Shipments, Invoices)
-- ==============================

-- 1) Sales Analysis

-- Total Sales by Product
SELECT 
    dp.product_name,
    SUM(fs.Revenue) AS total_revenue
FROM fact_sales fs
JOIN dim_product dp ON fs.product_sk = dp.product_sk
GROUP BY dp.product_name
ORDER BY total_revenue DESC;

-- Top 10 Customers by Revenue
SELECT 
    dc.company_name,
    SUM(fs.Revenue) AS total_revenue
FROM fact_sales fs
JOIN dim_customer dc ON fs.customer_sk = dc.customer_sk
GROUP BY dc.company_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Sales Trends by Month
SELECT 
    d.year,
    d.month,
    SUM(fs.Revenue) AS total_revenue
FROM fact_sales fs
JOIN dim_date d ON fs.order_date_sk = d.date_sk
GROUP BY d.year, d.month
ORDER BY d.year, d.month;

-- 2) Profitability Analysis

-- Profit Margin by Category
SELECT 
    dp.category_name,
    SUM(fs.Gross_Profit) / SUM(fs.Revenue) AS profit_margin
FROM fact_sales fs
JOIN dim_product dp ON fs.product_sk = dp.product_sk
GROUP BY dp.category_name
ORDER BY profit_margin DESC;

-- Discount Impact
SELECT 
    SUM(fs.unit_price * fs.qty) AS revenue_before_discount,
    SUM(fs.Revenue) AS revenue_after_discount,
    (SUM(fs.unit_price * fs.qty) - SUM(fs.Revenue)) AS discount_impact
FROM fact_sales fs;

-- 3) Customer & Employee Performance

-- Sales by Region
SELECT 
    dc.country,
    SUM(fs.Revenue) AS total_revenue
FROM fact_sales fs
JOIN dim_customer dc ON fs.customer_sk = dc.customer_sk
GROUP BY dc.country
ORDER BY total_revenue DESC;

-- Top Employees by Sales
SELECT 
    de.first_name, de.last_name,
    SUM(fs.Revenue) AS total_revenue
FROM fact_sales fs
JOIN dim_employee de ON fs.employee_sk = de.employee_sk
GROUP BY de.first_name, de.last_name
ORDER BY total_revenue DESC;

-- 4) Shipment & Delivery

-- Average Delivery Time
SELECT 
    AVG(fs.delivery_days) AS avg_delivery_days
FROM fact_shipment fs;

-- Shipper Performance
SELECT 
    dsh.company_name,
    AVG(fs.delivery_days) AS avg_delivery_days,
    AVG(fs.shipping_fee) AS avg_shipping_fee
FROM fact_shipment fs
JOIN dim_shipper dsh ON fs.shipper_sk = dsh.shipper_sk
GROUP BY dsh.company_name
ORDER BY avg_delivery_days;

-- 5) Invoice Analysis

-- Outstanding Invoices per Customer
SELECT 
    dc.company_name,
    SUM(fi.outstanding_amount) AS total_outstanding
FROM fact_invoice fi
JOIN dim_customer dc ON fi.customer_sk = dc.customer_sk
GROUP BY dc.company_name
ORDER BY total_outstanding DESC;

-- Average Days Between Invoice and Due Date
SELECT 
    AVG(DATEDIFF(d2.full_date, d1.full_date)) AS avg_days_between_invoice_and_due
FROM fact_invoice fi
JOIN dim_date d1 ON fi.invoice_date_sk = d1.date_sk
JOIN dim_date d2 ON fi.due_date_sk = d2.date_sk;

-- Invoice Aging Buckets
SELECT
    CASE 
        WHEN DATEDIFF(CURDATE(), d1.full_date) <= 30 THEN '0-30 days'
        WHEN DATEDIFF(CURDATE(), d1.full_date) <= 60 THEN '31-60 days'
        WHEN DATEDIFF(CURDATE(), d1.full_date) <= 90 THEN '61-90 days'
        ELSE '90+ days'
    END AS aging_bucket,
    COUNT(*) AS invoice_count,
    SUM(fi.outstanding_amount) AS total_outstanding
FROM fact_invoice fi
JOIN dim_date d1 ON fi.invoice_date_sk = d1.date_sk
WHERE fi.outstanding_amount > 0
GROUP BY aging_bucket
ORDER BY aging_bucket;

-- Payment Types Distribution
SELECT 
    di.payment_type,
    COUNT(*) AS invoice_count,
    SUM(fi.total_amount) AS total_amount
FROM fact_invoice fi
JOIN dim_invoice di ON fi.invoice_sk = di.invoice_sk
GROUP BY di.payment_type
ORDER BY total_amount DESC;
