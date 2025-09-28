CREATE TABLE CL_purchase_order_details(

id int ,
purchase_order_id int ,
product_id int ,
quantity decimal(18,4) ,
unit_cost decimal(19,4) ,
date_received date ,
posted_to_inventory tinyint(1) ,
inventory_id int
);
insert into CL_purchase_order_details(
id  ,
purchase_order_id  ,
product_id  ,
quantity  ,
unit_cost  ,
date_received  ,
posted_to_inventory  ,
inventory_id 
)

SELECT DISTINCT
    id,
    purchase_order_id,
    product_id,
    -- Replace NULL or negative quantity with 0
    CASE 
        WHEN quantity IS NULL OR quantity < 0 THEN 0
        ELSE quantity
    END AS quantity,
    -- Replace NULL or negative cost with 0
    CASE 
        WHEN unit_cost IS NULL OR unit_cost < 0 THEN 0
        ELSE unit_cost
    END AS unit_cost,
    -- If posted_to_inventory = 1 but date_received is NULL, use CURRENT_DATE
    CASE 
        WHEN posted_to_inventory = 1 AND date_received IS NULL THEN CURRENT_DATE
        ELSE date_received
    END AS date_received,
    -- Force posted_to_inventory to be only 0 or 1
    CASE 
        WHEN posted_to_inventory NOT IN (0,1) THEN 0
        ELSE posted_to_inventory
    END AS posted_to_inventory,
    inventory_id
   from (select * , 
					row_number() OVER (PARTITION BY id ) as rn
                    FROM staging_area_northwind.purchase_order_details)
                    where rn = 1 ;
