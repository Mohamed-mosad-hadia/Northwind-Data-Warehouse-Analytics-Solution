-- ==============================
--  		CL_purchase_orders  
-- ==============================
CREATE table CL_purchase_orders (
id int  , 
supplier_id int ,
created_by int , 
submitted_date date ,
creation_date date ,
status_id int ,
expected_date date ,
shipping_fee decimal(19,4) ,
taxes decimal(19,4) ,
payment_date datetime ,
payment_amount decimal(19,4) ,
payment_method varchar(50) ,
notes longtext ,
approved_by int ,
approved_date date ,
submitted_by int
);

-- Clean and insert data into purchase_orders
INSERT INTO CL_purchase_orders (
    id,
    supplier_id,
    created_by,
    submitted_date,
    creation_date,
    status_id,
    expected_date,
    shipping_fee,
    taxes,
    payment_date,
    payment_amount,
    payment_method,
    notes,
    approved_by,
    approved_date,
    submitted_by
) 
SELECT 
    -- ID cleaning and validation
    COALESCE(NULLIF(TRIM(purchase_orders.id), ''), 0) as id,
    
    -- Supplier ID validation (should reference valid suppliers)
    CASE 
        WHEN purchase_orders.supplier_id IS NULL OR purchase_orders.supplier_id <= 0 THEN NULL
        ELSE purchase_orders.supplier_id
    END as supplier_id,
    
    -- Created by validation (should reference valid employees)
    CASE 
        WHEN purchase_orders.created_by IS NULL OR purchase_orders.created_by <= 0 THEN NULL
        ELSE purchase_orders.created_by
    END as created_by,
    
    -- Date validation and formatting
    CASE 
        WHEN STR_TO_DATE(purchase_orders.submitted_date, '%Y-%m-%d') IS NOT NULL 
            THEN STR_TO_DATE(purchase_orders.submitted_date, '%Y-%m-%d')
        WHEN po.submitted_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' 
            THEN STR_TO_DATE(po.submitted_date, '%Y-%m-%d')
        ELSE NULL
    END as submitted_date,
    
    -- Creation date (mandatory field)
    CASE 
        WHEN STR_TO_DATE(purchase_orders.creation_date, '%Y-%m-%d') IS NOT NULL 
            THEN STR_TO_DATE(purchase_orders.creation_date, '%Y-%m-%d')
        WHEN po.creation_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' 
            THEN STR_TO_DATE(purchase_orders.creation_date, '%Y-%m-%d')
        ELSE CURDATE()  -- Default to current date if invalid
    END as creation_date,
    
    -- Status ID standardization
    CASE 
        WHEN purchase_orders.status_id BETWEEN 0 AND 5 THEN purchase_orders.status_id  -- Assuming status 0-5 are valid
        WHEN purchase_orders.status_id IS NULL THEN 0  -- Default to 'New' status
        ELSE 0  -- Default for invalid status codes
    END as status_id,
    
    -- Expected date validation
    CASE 
        WHEN STR_TO_DATE(purchase_orders.expected_date, '%Y-%m-%d') IS NOT NULL 
            THEN STR_TO_DATE(purchase_orders.expected_date, '%Y-%m-%d')
        WHEN po.expected_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' 
            THEN STR_TO_DATE(po.expected_date, '%Y-%m-%d')
        ELSE DATE_ADD(CURDATE(), INTERVAL 30 DAY)  -- Default to 30 days from now
    END as expected_date,
    
    -- Financial data cleaning
    COALESCE(
        NULLIF(ABS(CAST(purchase_orders.shipping_fee AS DECIMAL(19,4))), 0),  -- Remove negative values
        0.0000
    ) as shipping_fee,
    
    COALESCE(
        NULLIF(ABS(CAST(purchase_orders.taxes AS DECIMAL(19,4))), 0),  -- Remove negative values
        0.0000
    ) as taxes,
    
    -- Payment date (can be NULL for unpaid orders)
    CASE 
        WHEN STR_TO_DATE(purchase_orders.payment_date, '%Y-%m-%d %H:%i:%s') IS NOT NULL 
            THEN STR_TO_DATE(purchase_orders.payment_date, '%Y-%m-%d %H:%i:%s')
        WHEN purchase_orders.payment_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$' 
            THEN STR_TO_DATE(purchase_orders.payment_date, '%Y-%m-%d %H:%i:%s')
        ELSE NULL
    END as payment_date,
    
    -- Payment amount validation
    CASE 
        WHEN purchase_orders.payment_amount IS NULL OR purchase_orders.payment_amount < 0 THEN 0.0000
        ELSE CAST(purchase_orders.payment_amount AS DECIMAL(19,4))
    END as payment_amount,
    
    -- Payment method standardization
    CASE 
        WHEN NULLIF(TRIM(po.payment_method), '') IS NULL THEN 'Unknown'
        WHEN UPPER(purchase_orders.payment_method) IN ('CHECK', 'CHEQUE') THEN 'Check'
        WHEN UPPER(purchase_orders.payment_method) IN ('CREDIT CARD', 'CREDIT', 'CARD') THEN 'Credit Card'
        WHEN UPPER(purchase_orders.payment_method) IN ('CASH', 'CASH ON DELIVERY') THEN 'Cash'
        WHEN UPPER(purchase_orders.payment_method) IN ('BANK TRANSFER', 'WIRE TRANSFER') THEN 'Bank Transfer'
        WHEN UPPER(purchase_orders.payment_method) IN ('PAYPAL', 'ONLINE') THEN 'Online Payment'
        ELSE CONCAT(UPPER(SUBSTRING(TRIM(purchase_orders.payment_method), 1, 1)), 
                   LOWER(SUBSTRING(TRIM(purchase_orders.payment_method), 2)))
    END as payment_method,
    
   notes,
    
    -- Approved by validation
    CASE 
        WHEN purchase_orders.approved_by IS NULL OR purchase_orders.approved_by <= 0 THEN NULL
        ELSE purchase_orders.approved_by
    END as approved_by,
    
    -- Approved date validation
    CASE 
        WHEN STR_TO_DATE(purchase_orders.approved_date, '%Y-%m-%d') IS NOT NULL 
            THEN STR_TO_DATE(purchase_orders.approved_date, '%Y-%m-%d')
        WHEN purchase_orders.approved_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' 
            THEN STR_TO_DATE(purchase_orders.approved_date, '%Y-%m-%d')
        ELSE NULL
    END as approved_date,
    
    -- Submitted by validation
    CASE 
        WHEN purchase_orders.submitted_by IS NULL OR purchase_orders.submitted_by <= 0 THEN NULL
        ELSE purchase_orders.submitted_by
    END as submitted_by

FROM (
    -- Remove duplicates and handle data integrity
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY id 
               ORDER BY 
                   CASE WHEN creation_date IS NOT NULL THEN creation_date ELSE CURDATE() END DESC,
                   supplier_id DESC
           ) as rn
    FROM staging_area_northwind.purchase_orders
    WHERE id IS NOT NULL  -- Ensure we have valid IDs
) po
WHERE purchase_orders.rn = 1  -- Remove duplicates
  AND purchase_orders.creation_date IS NOT NULL  -- Ensure creation date exists
ORDER BY purchase_orders.id;