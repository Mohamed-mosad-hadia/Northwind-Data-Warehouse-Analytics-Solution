-- ========================
-- CL_orders_status
-- ========================
CREATE table CL_orders_status(
id tinyint , 
status_name varchar(50) );

INSERT INTO CL_orders_status (id, status_name)
SELECT DISTINCT
    id,
    TRIM(UPPER(status_name)) AS status_name
FROM staging_area_northwind.orders_status;
