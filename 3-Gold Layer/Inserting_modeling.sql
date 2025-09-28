-- ==============================
--  		Inserting in DWH  
-- ==============================

-- ==============================
-- Inserting in DWH (dim_date)
-- ==============================

INSERT INTO Northwind_DWH.dim_date (
    date_sk,
    full_date,
    year,
    month,
    day,
    quarter,
    week_of_year,
    is_weekend,
    is_holiday,
    month_name,
    day_of_week,
    day_name
)
SELECT 
     UNIX_TIMESTAMP(d.dt) AS date_sk,
    d.dt AS full_date,
    YEAR(d.dt) AS year,
    MONTH(d.dt) AS month,
    DAY(d.dt) AS day,
    QUARTER(d.dt) AS quarter,
    WEEKOFYEAR(d.dt) AS week_of_year,
    CASE WHEN DAYOFWEEK(d.dt) IN (1,7) THEN 1 ELSE 0 END AS is_weekend,
    0 AS is_holiday, 
    MONTHNAME(d.dt) AS month_name,
    DAYOFWEEK(d.dt) AS day_of_week,
    DAYNAME(d.dt) AS day_name
FROM (
    SELECT DISTINCT dt
    FROM (
        SELECT order_date AS dt FROM cleaned_northwind.cl_order 
        UNION 
        SELECT shipped_date FROM cleaned_northwind.cl_order 
        UNION 
        SELECT paid_date FROM cleaned_northwind.cl_order 
        UNION  
        SELECT invoice_date FROM cleaned_northwind.cl_invoices      
        UNION  
        SELECT due_date FROM cleaned_northwind.cl_invoices      
        UNION 
        SELECT date_allocated FROM cleaned_northwind.cl_order_details
    ) AS all_dates
) AS d
WHERE d.dt IS NOT NULL
  AND d.dt >= '1970-01-01'
  AND NOT EXISTS (
      SELECT 1 FROM Northwind_DWH.dim_date dd
      WHERE dd.full_date = d.dt
  );





-- ==============================
-- Inserting in DWH (dim_customer) 
-- ==============================

INSERT INTO dim_customer (
  customer_id_bk, company_name, contact_name, job_title,
  address, city, postal_code, country,
  is_current, start_date, end_date
)
    
SELECT 
  c.id,
  COALESCE(NULLIF(TRIM(c.company),''),'Unknown'),
  TRIM(CONCAT(c.first_name,' ',c.last_name)),
  COALESCE(NULLIF(TRIM(c.job_title),''),'Unknown'),
  c.address,
  c.city,
  c.zip_postal_code,
  c.country_region,
  TRUE, -- is_current
  CURDATE(),  -- start_date
  '9999-12-31' -- end_date 
FROM cleaned_northwind.cl_customers  c ;



-- ==============================
-- Inserting in DWH (dim_supplier) 
-- ==============================
INSERT INTO dim_supplier (
  supplier_id_bk, company_name, contact_name, city, country,
  is_current, start_date, end_date
)
SELECT
  s.id,
  COALESCE(NULLIF(TRIM(s.company),''),'Unknown'),
  TRIM(CONCAT(s.first_name,' ',s.last_name)),
  s.city,
  s.country_region,
  TRUE, CURDATE(), '9999-12-31'
FROM cleaned_northwind.cl_suppliers s;  


-- ==============================
-- Inserting in DWH (dim_shipper) 
-- ==============================
INSERT INTO dim_shipper (
  shipper_id_bk, company_name, contact_first_name, contact_last_name, phone, city, country,
  is_current, start_date, end_date
)
SELECT   
  sh.id,
  COALESCE(NULLIF(TRIM(sh.company),''),'Unknown'),
  sh.first_name,
  sh.last_name,
  sh.business_phone,         -- phone from Silver shipper
  sh.city,
  sh.country_region,
  TRUE, CURDATE(), '9999-12-31'
FROM cleaned_northwind.cl_shippers sh;  


-- ==============================
-- Inserting in DWH (dim_employee) 
-- ==============================


INSERT INTO dim_employee (
  employee_id_bk, last_name, first_name, job_title,
  address, city, postal_code, country,
  birth_date, hire_date, privilege_id, privilege_name,
  is_current, start_date, end_date
)
SELECT
  e.id,
  COALESCE(NULLIF(e.last_name,''),'Unknown'),
  COALESCE(NULLIF(e.first_name,''),'Unknown'),
  COALESCE(NULLIF(e.job_title,''),'Unknown'),
  e.address,
  e.city,
  e.zip_postal_code,
  e.country_region,
  TRUE,
  CURDATE(),
  '9999-12-31'
FROM cleaned_northwind.cl_employees e;




-- ==============================
-- Inserting in DWH (dim_product) 
-- ==============================

INSERT INTO dim_product (
  product_id_bk, product_code, product_name, category_name, quantity_per_unit,
  is_current, start_date, end_date
)
SELECT
  p.id,
  p.product_code,
  p.product_name,
  cr.category_name,
  COALESCE(NULLIF(p.quantity_per_unit,''),'1 unit') AS quantity_per_unit,
  TRUE, CURDATE(), '9999-12-31'
FROM cleaned_northwind.cl_products p ;





-- ==============================
-- Inserting in DWH (dim_invoice) 
-- ==============================


INSERT INTO dim_invoice (
  invoice_id_bk, order_status_name, order_tax_status, payment_type
)
SELECT
  i.id,
  'Unknown' AS order_status_name,
  'Unknown' AS order_tax_status,
  COALESCE(NULLIF(o.payment_type,''),'Unknown') AS payment_type
FROM cleaned_northwind.cl_invoices i                    
LEFT JOIN cleaned_northwind.cl_order o 
  ON o.id = i.order_id;       






-- ==============================
-- Inserting in DWH (fact_sales) 
-- ==============================

INSERT INTO fact_sales (
    order_date_sk,
    invoice_sk,
    product_sk,
    shipper_sk,
    customer_sk,
    employee_sk,
    supplier_sk, 
    order_id_bk, 
    qty,
    unit_price,
    discount_amount,
    unit_cost,
    line_cost,
    freight_cost,
    Total_Cost,
    Revenue,
    Gross_Profit
)
SELECT 
  d.date_sk,             -- مفتاح التاريخ من dim_date
  di.invoice_sk,         -- الفاتورة
  dp.product_sk,         -- المنتج
  dsh.shipper_sk,        -- الشاحن
  dc.customer_sk,        -- العميل
  de.employee_sk,        -- الموظف
  dsup.supplier_sk,      -- المورد
  o.id,                  -- رقم الأوردر (BK)
  od.quantity,           -- الكمية
  od.unit_price,         -- سعر الوحدة
  od.discount,           -- الخصم
  p.standard_cost,       -- تكلفة الوحدة
  od.quantity * p.standard_cost,                       -- line_cost
  o.shipping_fee,                                      -- Shipping Fee
  od.quantity * p.standard_cost,                       -- Total_Cost
  (od.quantity * od.unit_price) * (1 - od.discount),   -- Revenue
  ((od.quantity * od.unit_price) * (1 - od.discount)) - (od.quantity * p.standard_cost)  -- Gross_Profit
FROM cleaned_northwind.cl_order o
JOIN cleaned_northwind.cl_order_details od ON od.order_id = o.id
JOIN cleaned_northwind.cl_products p ON p.id = od.product_id
LEFT JOIN dim_date d ON d.full_date = DATE(o.order_date)    
LEFT JOIN dim_customer dc  ON dc.customer_id_bk = o.customer_id AND dc.is_current = TRUE
LEFT JOIN dim_employee de  ON de.employee_id_bk = o.employee_id AND de.is_current = TRUE
LEFT JOIN dim_shipper dsh  ON dsh.shipper_id_bk = o.shipper_id AND dsh.is_current = TRUE
LEFT JOIN dim_product dp   ON dp.product_id_bk  = od.product_id AND dp.is_current = TRUE
LEFT JOIN dim_supplier dsup ON dsup.supplier_id_bk = p.id AND dsup.is_current = TRUE
LEFT JOIN cleaned_northwind.cl_invoices i ON i.order_id = o.id
LEFT JOIN dim_invoice di ON di.invoice_id_bk = i.id;




INSERT INTO fact_shipment (
  order_date_sk,
  shipped_date_sk,
  employee_sk,
  customer_sk,
  shipper_sk,
  order_id_bk,
  ship_name,
  delivery_days,
  shipping_fee,
  On_Time_Status
)
SELECT
  d1.date_sk,         -- from dim_date (UNIX_TIMESTAMP)
  d2.date_sk,         -- from dim_date (UNIX_TIMESTAMP)
  de.employee_sk,
  dc.customer_sk,
  dsh.shipper_sk,
  o.id,
  o.ship_name,
  o.delivery_days,
  o.shipping_fee,
  CASE 
    WHEN o.delivery_days IS NULL THEN 'Unknown'
    WHEN o.delivery_days <= 5 THEN 'On Time'
    ELSE 'Late'
  END
FROM cleaned_northwind.cl_order o
LEFT JOIN dim_date d1 ON d1.full_date = DATE(o.order_date)   -- match order_date
LEFT JOIN dim_date d2 ON d2.full_date = DATE(o.shipped_date) -- match shipped_date
LEFT JOIN dim_customer dc ON dc.customer_id_bk = o.customer_id AND dc.is_current = TRUE
LEFT JOIN dim_employee de ON de.employee_id_bk = o.employee_id AND de.is_current = TRUE
LEFT JOIN dim_shipper  dsh ON dsh.shipper_id_bk = o.shipper_id AND dsh.is_current = TRUE;




-- ==============================
-- Inserting in DWH (fact_invoice) 
-- ==============================

insert into fact_invoice (
	`invoice_sk`,
    `customer_sk` ,
    `invoice_date_sk` ,
    `due_date_sk` ,
	`order_id_bk` , -- Degenerate Dimension Key
    
	`amount_due`,
    `amount_paid` ,
    `total_amount` ,
-- Measures
    `outstanding_amount` 

)
SELECT 
    di.invoice_sk,                   --  dim_invoice
    dc.customer_sk,                  --  dim_customer
    d1.date_sk AS invoice_date_sk,   --  dim_date 
    d2.date_sk AS due_date_sk,       --  dim_date 
    i.order_id,                      --  Business Key
    i.amount_due,
    NULL AS amount_paid,         
    (i.amount_due + i.tax + i.shipping) AS total_amount,
    i.amount_due AS outstanding_amount
FROM cleaned_northwind.cl_invoices i
LEFT JOIN dim_invoice di ON di.invoice_id_bk = i.id
LEFT JOIN dim_customer dc ON dc.customer_id_bk = i.order_id  AND dc.is_current = TRUE
LEFT JOIN dim_date d1 ON d1.full_date = DATE(i.invoice_date)
LEFT JOIN dim_date d2 ON d2.full_date = DATE(i.due_date);


