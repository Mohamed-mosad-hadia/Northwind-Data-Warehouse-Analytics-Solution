-- ================================
--  	purchase_order_status  
-- ================================
CREATE TABLE CL_purchase_order_status (
id int  ,
status varchar(50)
) ;

INSERT INTO CL_purchase_order_status (id,status)
SELECT DISTINCT
    id,
    trim(status) 
    from (select * , 
					row_number() OVER (PARTITION BY id ) as rn
                    FROM staging_area_northwind.purchase_order_status)
                    where rn = 1 ;
                    
                    
   
   
    
    
   