-- ========================
-- CL_orders_tax_status
-- ========================
CREATE table CL_orders_tax_status(
id tinyint , 
tax_status_name varchar(50)
); 

INSERT INTO CL_orders_tax_status (id, tax_status_name)
SELECT DISTINCT
    id,
    TRIM(UPPER(tax_status_name)) AS tax_status_name
FROM staging_area_northwind.orders_tax_status;

