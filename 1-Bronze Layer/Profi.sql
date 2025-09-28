-- ==============================
--  		Profilling
-- ==============================

/*
-- ================
-- Customers Table 
-- ================

email_address --> Null
home_phone    --> Null
mobile_phone  --> Null
web_page      --> Null
notes         --> Null
attachments   --> Null
*/
SELECT * FROM customers ; 




/*
-- ================
-- suppliers 
-- ================
email_address  --> Null  
business_phone --> Null
home_phone 	   --> Null
mobile_phone   --> Null
fax_number     --> Null 
address        --> Null
city           --> Null
state_province --> Null 
zip_postal_code--> Null  
country_region --> Null 
web_page  	  --> Null
notes         --> Null
attachments   --> Null
*/
SELECT * FROM staging_area_northwind.suppliers;
DESC staging_area_northwind.suppliers ;

-- check duplicates 
SELECT id, COUNT(*) as RP
FROM staging_area_northwind.suppliers
GROUP BY id
HAVING COUNT(*) > 1;

-- check for null or spaces from columns first name 
SELECT *
FROM staging_area_northwind.suppliers
where  first_name  != trim(first_name) OR  first_name=NULL OR first_name = '';

-- check for null or spaces from columns last_name 
SELECT * 
FROM staging_area_northwind.suppliers
WHERE last_name != trim(last_name) OR last_name = NULL OR last_name = '' ; 

-- select all email_address are == NULL 
SELECT email_address 
FROM staging_area_northwind.suppliers 
WHERE email_address IS NULL or email_address = '' ;

-- check emails 
SELECT * 
FROM staging_area_northwind.suppliers
WHERE TRIM(LOWER(email_address)) <> 
      CONCAT(LOWER(TRIM(first_name)), '.', LOWER(TRIM(last_name)), '@gmail.com') 
      OR TRIM(LOWER(email_address)) = ' '
      OR TRIM(LOWER(email_address)) IS NULL  ;

-- Check companys 
SELECT distinct company 
FROM staging_area_northwind.suppliers ;




/*
-- ================
-- shippers
-- ================
id 
company  
All Table is NULL
*/

SELECT * FROM staging_area_northwind.shippers;
DESC staging_area_northwind.shippers;


