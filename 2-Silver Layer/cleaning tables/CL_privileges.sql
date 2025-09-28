-- ========================
--  CL_privileges
-- ========================
CREATE TABLE CL_privileges(
id int , 
privilege_name varchar(50) ) ;

INSERT INTO CL_privileges (id, privilege_name)
SELECT DISTINCT
    id,
    TRIM(UPPER(privilege_name)) AS privilege_name
FROM staging_area_northwind.privileges;
