-- ==================
--    Silver Layer  
-- ==================
-- [Customers,Employees,Suppliers,Shippers,Invoices,Products]

CREATE DATABASE IF NOT EXISTS cleaned_northwind; 
USE cleaned_northwind; 

-- =======================
--    Table: Customers
-- =======================
CREATE TABLE IF NOT EXISTS cl_customers (
    id INT, 
    company VARCHAR(50),
    last_name VARCHAR(50),
    first_name VARCHAR(50),
    email_address VARCHAR(50),
    job_title VARCHAR(50),
    business_phone VARCHAR(25),
    home_phone VARCHAR(25),
    mobile_phone VARCHAR(25),
    fax_number VARCHAR(25),
    address LONGTEXT,
    city VARCHAR(50),
    state_province VARCHAR(50),
    zip_postal_code VARCHAR(15),
    country_region VARCHAR(50),
    web_page LONGTEXT,
    notes LONGTEXT,
    attachments LONGBLOB
);

INSERT INTO cl_customers (
    id, 
    company,
    last_name,
    first_name,
    email_address,
    job_title,
    business_phone,
    home_phone,
    mobile_phone,
    fax_number,
    address,
    city,
    state_province,
    zip_postal_code,
    country_region,
    web_page,
    notes,
    attachments
)
SELECT 
    id, 
    CASE  
        WHEN company = 'Company AA' THEN 'Company A' 
        WHEN company = 'Company BB' THEN 'Company B' 
        WHEN company = 'Company CC' THEN 'Company C' 
        ELSE company
    END AS company, 
    -- Handle First/Last name
    CONCAT(UCASE(LEFT(TRIM(last_name),1)), LCASE(SUBSTRING(TRIM(last_name),2))) AS last_name,
    CONCAT(UCASE(LEFT(TRIM(first_name),1)), LCASE(SUBSTRING(TRIM(first_name),2))) AS first_name,
    email_address,
    job_title,
    CONCAT('+1', TRIM(business_phone)) AS business_phone,
    TRIM(home_phone) AS home_phone,
    TRIM(mobile_phone) AS mobile_phone,
    TRIM(fax_number) AS fax_number,
    address,
    city,
    state_province,
    zip_postal_code,
    country_region,
    web_page,
    notes,
    attachments
FROM (
    SELECT br.*, 
           ROW_NUMBER() OVER (PARTITION BY email_address ORDER BY id DESC) AS rn
    FROM staging_area_northwind.customers br
) t
WHERE rn = 1;



-- =======================
--    Table: Employees
-- =======================
CREATE TABLE IF NOT EXISTS cl_employees (
    id INT,
    company VARCHAR(50),
    last_name VARCHAR(50),
    first_name VARCHAR(50),
    email_address VARCHAR(50),
    job_title VARCHAR(50),
    business_phone VARCHAR(25),
    home_phone VARCHAR(25),
    mobile_phone VARCHAR(25),
    fax_number VARCHAR(25),
    address LONGTEXT,
    city VARCHAR(50),
    state_province VARCHAR(50),
    zip_postal_code VARCHAR(15),
    country_region VARCHAR(50),
    web_page LONGTEXT, 
    notes LONGTEXT, 
    attachments LONGBLOB
);

INSERT INTO cl_employees (
    id,
    company,
    last_name,
    first_name,
    email_address,
    job_title,
    business_phone,
    home_phone,
    mobile_phone,
    fax_number,
    address,
    city,
    state_province,
    zip_postal_code,
    country_region,
    web_page, 
    notes, 
    attachments
)
SELECT 
    id,
    company,
    last_name,
    first_name,
    -- Build email if missing
    CONCAT(
        LOWER(
          COALESCE(
            NULLIF(TRIM(first_name), ''), 
            SUBSTRING_INDEX(SUBSTRING_INDEX(email_address, '@', 1), '.', 1)
          )
        ),
        '.',
        LOWER(
          COALESCE(
            NULLIF(TRIM(last_name), ''), 
            SUBSTRING_INDEX(SUBSTRING_INDEX(email_address, '@', 1), '.', -1)
          )
        ),
        '@gmail.com'
    ) AS email,  
    job_title,
    TRIM(business_phone),
    TRIM(home_phone),
    TRIM(mobile_phone),
    TRIM(fax_number),
    address,
    city,
    state_province,
    zip_postal_code,
    country_region,
    web_page, 
    notes, 
    attachments  
FROM (
    SELECT br.*, 
           ROW_NUMBER() OVER (PARTITION BY email_address ORDER BY id DESC) AS rn 
    FROM staging_area_northwind.employees br
) t
WHERE rn = 1;



-- =======================
--    Table: Suppliers
-- =======================
CREATE TABLE IF NOT EXISTS cl_suppliers ( 
    id INT,
    company VARCHAR(50),
    last_name VARCHAR(50),
    first_name VARCHAR(50),
    email_address VARCHAR(50),
    job_title VARCHAR(50),
    business_phone VARCHAR(25),
    home_phone VARCHAR(25),
    mobile_phone VARCHAR(25),
    fax_number VARCHAR(25),
    address LONGTEXT,
    city VARCHAR(50),
    state_province VARCHAR(50),
    zip_postal_code VARCHAR(15),
    country_region VARCHAR(50),
    web_page LONGTEXT,
    notes LONGTEXT,
    attachments LONGBLOB
); 

INSERT INTO cl_suppliers (
    id,
    company,
    last_name,
    first_name,
    email_address,
    job_title,
    business_phone,
    home_phone,
    mobile_phone,
    fax_number,
    address,
    city,
    state_province,
    zip_postal_code,
    country_region,
    web_page,
    notes,
    attachments
) 
SELECT 
    id,
    company,
    last_name,
    first_name,
    email_address,
    job_title,
    TRIM(business_phone),
    TRIM(home_phone),
    TRIM(mobile_phone),
    TRIM(fax_number),
    address,
    city,
    state_province,
    zip_postal_code,
    country_region,
    web_page,
    notes,
    attachments
FROM (
    SELECT br.*, ROW_NUMBER() OVER (PARTITION BY email_address ORDER BY id DESC) AS rn 
    FROM staging_area_northwind.suppliers br
) t
WHERE rn = 1;



-- =======================
--    Table: Shippers
-- =======================
CREATE TABLE IF NOT EXISTS cl_shippers (
    id INT, 
    company VARCHAR(50),
    last_name VARCHAR(50),
    first_name VARCHAR(50),
    email_address VARCHAR(50),
    job_title VARCHAR(50),
    business_phone VARCHAR(25),
    home_phone VARCHAR(25),
    mobile_phone VARCHAR(25),
    fax_number VARCHAR(25), 
    address LONGTEXT,
    city VARCHAR(50),
    state_province VARCHAR(50),
    zip_postal_code VARCHAR(15),
    country_region VARCHAR(50)
); 

INSERT INTO cl_shippers (
    id, 
    company,
    last_name,
    first_name,
    email_address,
    job_title,
    business_phone,
    home_phone,
    mobile_phone,
    fax_number, 
    address,
    city,
    state_province,
    zip_postal_code,
    country_region
)
SELECT 
    id,
    company,
    last_name,
    first_name,
    email_address,
    job_title,
    TRIM(business_phone),
    TRIM(home_phone),
    TRIM(mobile_phone),
    TRIM(fax_number),
    address,
    city,
    state_province,
    zip_postal_code,
    country_region
FROM (
    SELECT br.*, ROW_NUMBER() OVER (PARTITION BY email_address ORDER BY id DESC) rn 
    FROM staging_area_northwind.shippers br
) t
WHERE rn = 1;



-- =======================
--    Table: Invoices
-- =======================
CREATE TABLE IF NOT EXISTS cl_invoices (
    id INT,  
    order_id INT,
    invoice_date DATETIME,
    due_date DATETIME,
    tax DECIMAL(19,4),
    shipping DECIMAL(19,4),
    amount_due DECIMAL(19,4)
);

INSERT INTO cl_invoices (
    id,  
    order_id,
    invoice_date,
    due_date,
    tax,
    shipping,
    amount_due
)
SELECT 
    id,  
    order_id,
    invoice_date,
    due_date,
    tax,
    shipping,
    amount_due
FROM staging_area_northwind.invoices;



-- =======================
--    Table: Products
-- =======================
CREATE TABLE IF NOT EXISTS cl_products (
    supplier_ids LONGTEXT,
    id INT,
    product_code VARCHAR(25),
    product_name VARCHAR(50),
    description LONGTEXT, 
    standard_cost DECIMAL(19,4),
    list_price DECIMAL(19,4),
    reorder_level INT,
    target_level INT,
    quantity_per_unit VARCHAR(50),
    discontinued TINYINT(1),
    minimum_reorder_quantity INT,
    category VARCHAR(50)
);

INSERT INTO cl_products (
    supplier_ids,
    id,
    product_code,
    product_name,
    description, 
    standard_cost,
    list_price,
    reorder_level,
    target_level,
    quantity_per_unit,
    discontinued,
    minimum_reorder_quantity,
    category
)
SELECT 
    TRIM(supplier_ids) AS supplier_ids,
    id,
    UPPER(TRIM(product_code)) AS product_code,
    CONCAT(UPPER(LEFT(TRIM(product_name),1)), LOWER(SUBSTRING(TRIM(product_name),2))) AS product_name, 
    TRIM(description) AS description,
    CASE WHEN standard_cost < 0 THEN 0 ELSE standard_cost END AS standard_cost, 
    CASE WHEN list_price < 0 THEN 0 ELSE list_price END AS list_price,
    COALESCE(reorder_level,0) AS reorder_level,
    COALESCE(target_level,0) AS target_level,
    TRIM(quantity_per_unit) AS quantity_per_unit,
    discontinued,
    COALESCE(minimum_reorder_quantity,1) AS minimum_reorder_quantity,
    TRIM(category) AS category
FROM (
    SELECT br.*, ROW_NUMBER() OVER (PARTITION BY id ORDER BY id DESC) AS rn
    FROM staging_area_northwind.products br
) t
WHERE rn = 1;



-- ======================= 
-- Table: Order 
-- =======================
CREATE TABLE if not exists cl_order(
id int  , 
employee_id int ,
customer_id int ,
order_date datetime ,
shipped_date datetime ,
shipper_id int ,
ship_name varchar(50) ,
ship_address longtext ,
ship_city varchar(50) ,
ship_state_province varchar(50) ,
ship_zip_postal_code varchar(50) ,
ship_country_region varchar(50) ,
shipping_fee decimal(19,4) ,
taxes decimal(19,4) ,
payment_type varchar(50) ,
paid_date datetime, 
notes longtext ,
tax_rate double ,
tax_status_id tinyint ,
status_id tinyint,
delivery_days int
);
INSERT INTO cl_order (
    id,
    employee_id,
    customer_id,
    order_date,
    shipped_date,
    shipper_id,
    ship_name,
    ship_address,
    ship_city,
    ship_state_province,
    ship_zip_postal_code,
    ship_country_region,
    shipping_fee, 
    taxes, 
    payment_type,
    paid_date,
    notes,
    tax_rate,
    tax_status_id,
    status_id,
    delivery_days
)
SELECT 
    id,
    employee_id,
    customer_id,
    order_date,
    shipped_date,
    shipper_id,
    TRIM(ship_name) AS ship_name,
    TRIM(ship_address) AS ship_address,
    TRIM(ship_city) AS ship_city,
    TRIM(ship_state_province) AS ship_state_province,
    TRIM(ship_zip_postal_code) AS ship_zip_postal_code,
    TRIM(ship_country_region) AS ship_country_region,
    -- if shipping fee negative then set 0 
    CASE WHEN shipping_fee < 0 THEN 0 ELSE shipping_fee END AS shipping_fee, 
    CASE WHEN taxes < 0 THEN 0 ELSE taxes END AS taxes, 
    
    -- handling missing payment type
    COALESCE(payment_type, 'Unknown') AS payment_type, 
    paid_date,
    TRIM(notes) AS notes,
    
    CASE WHEN tax_rate < 0 THEN 0 ELSE tax_rate END AS tax_rate,
    tax_status_id,
    status_id, 
    
    -- delivery_days
    CASE WHEN  shipped_date IS NOT NULL AND order_date IS NOT NULL 
            THEN DATEDIFF(shipped_date, order_date)
	ELSE NULL END AS delivery_days
    
FROM (
    SELECT br.*,
           ROW_NUMBER() OVER (PARTITION BY id ORDER BY id DESC) AS rn
    FROM staging_area_northwind.orders br
) t
WHERE rn = 1;


-- =======================
--    Table: Order Details
-- =======================
CREATE TABLE cl_order_details(
id int ,
order_id int ,
product_id int, 
quantity decimal(18,4) ,
unit_price decimal(19,4), 
discount double ,
status_id int ,
date_allocated datetime, 
purchase_order_id int ,
inventory_id int);

insert into cl_order_details (
id  ,
order_id  ,
product_id , 
quantity  ,
unit_price , 
discount  ,
status_id  ,
date_allocated , 
purchase_order_id  ,
inventory_id )

SELECT 
    id,
    order_id,
    product_id,
    -- if quantity negative  set null 
    CASE WHEN quantity < 0 THEN 0 ELSE quantity END AS quantity,
    -- NULL if unit_price negative  set null 
    CASE WHEN unit_price < 0 THEN NULL ELSE unit_price END AS unit_price,
     discount,
    status_id,
    date_allocated,
    purchase_order_id,
    inventory_id
FROM (
    SELECT br.*,
           ROW_NUMBER() OVER (PARTITION BY id ORDER BY id DESC) AS rn
    FROM staging_area_northwind.order_details br
) t
WHERE rn = 1;


