-- ========================
--  CL_products
-- ========================
CREATE table CL_products(
supplier_ids longtext ,
id int ,
product_code varchar(25) ,
product_name varchar(50) ,
description_ longtext ,
standard_cost decimal(19,4) ,
list_price decimal(19,4) ,
reorder_level int ,
target_level int ,
quantity_per_unit varchar(50) ,
discontinued tinyint(1) ,
minimum_reorder_quantity int ,
category varchar(50) ,
attachments longblob);

INSERT INTO CL_products(
    supplier_ids,
    id,
    product_code,
    product_name,
    description_,
    standard_cost,
    list_price,
    reorder_level,
    target_level,
    quantity_per_unit,
    discontinued,
    minimum_reorder_quantity,
    category,
    attachments
)
SELECT DISTINCT
    supplier_ids,
    id,
    -- Clean product code
    UPPER(TRIM(COALESCE(product_code, 'UNKNOWN'))) AS product_code,
    TRIM(COALESCE(product_name, 'UNKNOWN')) AS product_name,
    description_,
    -- Handle NULL or negative cost
    CASE WHEN standard_cost IS NULL OR standard_cost < 0 THEN 0 ELSE standard_cost END AS standard_cost,
    -- Ensure list_price >= standard_cost
    CASE 
        WHEN list_price IS NULL OR list_price < 0 THEN 0
        WHEN list_price < standard_cost THEN standard_cost
        ELSE list_price
    END AS list_price,
    COALESCE(reorder_level,0) AS reorder_level,
    COALESCE(target_level,0) AS target_level,
    TRIM(quantity_per_unit) AS quantity_per_unit,
    -- Force discontinued to 0/1
    CASE WHEN discontinued NOT IN (0,1) THEN 0 ELSE discontinued END AS discontinued,
    COALESCE(minimum_reorder_quantity,0) AS minimum_reorder_quantity,
    TRIM(category) AS category,
    attachments
FROM staging_area_northwind.product;   -- assuming your raw data is in `products` table
