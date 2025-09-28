-- ==============================
--  		Cleaning  
-- ==============================


-- ==============================
--  		Suppliers  
-- ==============================
CREATE TABLE CL_suppliers(
    id varchar(20), 
    company varchar(255), 
    last_name varchar(255),
    first_name varchar(255), 
    email_address varchar(50),
    job_title varchar(50),
    business_phone varchar(25),
    home_phone varchar(25),
    mobile_phone varchar(25),
    fax_number varchar(25),
    address longtext,
    city varchar(50),
    state_province varchar(50),
    zip_postal_code varchar(15),
    country_region varchar(50),
    web_page longtext,
    notes longtext,
    attachments longblob
); 

INSERT INTO CL_suppliers(
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
    -- ID cleanup (assuming you want to clean the id field)
    TRIM(id) as id,
    
    -- Company cleanup
    TRIM(company) as company,
    
    -- Last name cleanup 
    LOWER(COALESCE(NULLIF(TRIM(last_name), ''), 
          SUBSTRING_INDEX(SUBSTRING_INDEX(email, '@', 1), '.', 1))) as last_name,
    
    -- First name cleanup 
    LOWER(COALESCE(NULLIF(TRIM(first_name), ''), 
          SUBSTRING_INDEX(SUBSTRING_INDEX(email, '@', 1), '.', -1))) as first_name,
    
    -- Email cleanup - using the cleaned first_name and last_name
    LOWER(CONCAT(
        COALESCE(NULLIF(TRIM(first_name), ''), 
                SUBSTRING_INDEX(SUBSTRING_INDEX(email, '@', 1), '.', -1)),
        '.',
        COALESCE(NULLIF(TRIM(last_name), ''), 
                SUBSTRING_INDEX(SUBSTRING_INDEX(email, '@', 1), '.', 1)),
        '@gmail.com'
    )) as email_address,
    
    -- Other fields with basic cleaning
    TRIM(job_title) as job_title,
    TRIM(business_phone) as business_phone,
    TRIM(home_phone) as home_phone,
    TRIM(mobile_phone) as mobile_phone,
    TRIM(fax_number) as fax_number,
    TRIM(address) as address,
    TRIM(city) as city,
    TRIM(state_province) as state_province,
    TRIM(zip_postal_code) as zip_postal_code,
    TRIM(country_region) as country_region,
    TRIM(web_page) as web_page,
    TRIM(notes) as notes,
    attachments
FROM (SELECT *,
	 ROW_NUMBER() OVER (PARTITION BY id ) as rn
    FROM staging_area_northwind.suppliers
     ) 
	where rn = 1; -- table without duplicates




