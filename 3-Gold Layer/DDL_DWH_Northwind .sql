-- ==============================
--  		Gold Layer 
-- ==============================

CREATE database Northwind_DWH ; 
Use Northwind_DWH ;

CREATE TABLE if not exists `dim_date` (
    `date_sk` BIGINT NOT NULL,
    `full_date` DATE NOT NULL,
    `year` INT NOT NULL,
    `month` INT NOT NULL,
    `day` INT NOT NULL,
    `quarter` INT NOT NULL,
    `week_of_year` INT NOT NULL,
    `is_weekend` BOOLEAN NOT NULL,
    `is_holiday` BOOLEAN,
    `month_name` VARCHAR(50) NOT NULL,
    `day_of_week` INT NOT NULL,
    `day_name` VARCHAR(50) NOT NULL,
    PRIMARY KEY(`date_sk`)
);

CREATE TABLE `dim_customer` (
    `customer_sk` BIGINT NOT NULL,
    `customer_id_bk` BIGINT NOT NULL,
    `company_name` VARCHAR(255) NOT NULL,
    `contact_name` VARCHAR(255) NOT NULL,
    `job_title` VARCHAR(255) NOT NULL,
    `address` VARCHAR(255) NOT NULL,
    `city` VARCHAR(100) NOT NULL,
    `postal_code` VARCHAR(50) NOT NULL,
    `country` VARCHAR(100) NOT NULL,
    
    -- SCD Type 2 fields
    `is_current` BOOLEAN NOT NULL,
    `start_date` DATE NOT NULL,
    `end_date` DATE NOT NULL,
    PRIMARY KEY(`customer_sk`)
);

CREATE TABLE `dim_product` (
    `product_sk` BIGINT NOT NULL,
    `product_id_bk` BIGINT NOT NULL,
    `product_code` VArchar(255) NOT NULL,
    `product_name` VARCHAR(255) NOT NULL,
    `category_id` INT NOT NULL,
    `category_name` VARCHAR(255) NOT NULL,
    `quantity_per_unit` VARCHAR(255) NOT NULL,
    
    -- SCD Type 2 fields
    `is_current` BOOLEAN NOT NULL,
    `start_date` DATE NOT NULL,
    `end_date` DATE NOT NULL,
    PRIMARY KEY(`product_sk`)
  
);

CREATE TABLE `dim_supplier` (
    `supplier_sk` BIGINT NOT NULL,
    `supplier_id_bk` BIGINT NOT NULL,
    `company_name` VARCHAR(255) NOT NULL,
    `contact_name` VARCHAR(255) NOT NULL,
    `city` VARCHAR(100) NOT NULL,
    `country` VARCHAR(100) NOT NULL,
    
    -- SCD Type 2 fields
    `is_current` BOOLEAN NOT NULL,
    `start_date` DATE NOT NULL,
    `end_date` DATE NOT NULL,
    PRIMARY KEY(`supplier_sk`)
);

CREATE TABLE `dim_employee` (
    `employee_sk` BIGINT NOT NULL,
    `employee_id_bk` BIGINT NOT NULL,
    `last_name` VARCHAR(255) NOT NULL,
    `first_name` VARCHAR(255) NOT NULL,
    `job_title` VARCHAR(255) NOT NULL,
    `address` VARCHAR(255) NOT NULL,
    `city` VARCHAR(100) NOT NULL,
    `postal_code` VARCHAR(50) NOT NULL,
    `country` VARCHAR(100) NOT NULL,
    `birth_date` DATE NOT NULL,
    `hire_date` DATE NOT NULL,
    `privilege_id` BIGINT NOT NULL,
    `privilege_name` VARCHAR(100) NOT NULL,
    -- SCD Type 2 fields
    `is_current` BOOLEAN NOT NULL,
    `start_date` DATE NOT NULL,
    `end_date` DATE NOT NULL,
    PRIMARY KEY(`employee_sk`)
);

CREATE TABLE `dim_shipper` (
    `shipper_sk` BIGINT NOT NULL,
    `shipper_id_bk` BIGINT NOT NULL,
    `company_name` VARCHAR(255) NOT NULL,
    `contact_first_name` VARCHAR(255) NOT NULL,
    `contact_last_name` VARCHAR(255) NOT NULL,
    `phone` VARCHAR(50) NOT NULL,
    `city` VARCHAR(100) NOT NULL,
    `country` VARCHAR(100) NOT NULL,
    -- SCD Type 2 fields
    `is_current` BOOLEAN NOT NULL,
    `start_date` DATE NOT NULL,
    `end_date` DATE NOT NULL,
    PRIMARY KEY(`shipper_sk`)
);

CREATE TABLE `dim_invoice` (
    `invoice_sk` BIGINT NOT NULL,
    `invoice_id_bk` BIGINT NOT NULL,
    `order_status_name` VARCHAR(100) NOT NULL,
    `order_tax_status` VARCHAR(100) NOT NULL,
    `payment_type` VARCHAR(100) NOT NULL,
    PRIMARY KEY(`invoice_sk`)
);

CREATE TABLE `fact_sales` (
sales_key INT AUTO_INCREMENT PRIMARY KEY,
    `order_date_sk` BIGINT NOT NULL,
    `invoice_sk` BIGINT NOT NULL,
    `product_sk` BIGINT NOT NULL,
    `shipper_sk` BIGINT NOT NULL,
    `customer_sk` BIGINT NOT NULL,
    `employee_sk` BIGINT NOT NULL,
    `supplier_sk` BIGINT NOT NULL, 
    `order_id_bk` BIGINT NOT NULL, -- Degenerate Dimension Key
    `qty` INT NOT NULL,
    `unit_price` DECIMAL(10,2) NOT NULL,
    `discount_ amount` DECIMAL(10,2) NOT NULL,
    `unit_cost` DECIMAL(10,2) NOT NULL,
    `line_cost` DECIMAL(12,2) NOT NULL,
    `freight_cost` DECIMAL(12,2) NOT NULL,
    
    
    -- Measures
    `Total_Cost` DECIMAL(12,2) NOT NULL, -- Total Cost=Quantity×Unit Cost  (Additive) 
    `Revenue` DECIMAL(12,2) NOT NULL,  -- Line Revenue=(Quantity×Unit Price)×(1−Discount)
	`Gross_Profit` DECIMAL(12,2) NOT NULL, -- revenue - total_cost
    
    
-- Foreign Keys
    FOREIGN KEY (`supplier_sk`) REFERENCES `dim_supplier`(`supplier_sk`),
    FOREIGN KEY (`order_date_sk`) REFERENCES `dim_date`(`date_sk`),
    FOREIGN KEY (`invoice_sk`) REFERENCES `dim_invoice`(`invoice_sk`),
    FOREIGN KEY (`product_sk`) REFERENCES `dim_product`(`product_sk`),
    FOREIGN KEY (`shipper_sk`) REFERENCES `dim_shipper`(`shipper_sk`),
    FOREIGN KEY (`customer_sk`) REFERENCES `dim_customer`(`customer_sk`),
    FOREIGN KEY (`employee_sk`) REFERENCES `dim_employee`(`employee_sk`)
);

CREATE TABLE `fact_shipment` (
shipment_key INT AUTO_INCREMENT PRIMARY KEY,
    `order_date_sk` BIGINT NOT NULL,
    `shipped_date_sk` BIGINT NOT NULL,
    `required_date_sk` BIGINT NOT NULL,
	`employee_sk` BIGINT NOT NULL,
    `customer_sk` BIGINT NOT NULL,
    `shipper_sk` BIGINT NOT NULL,
    `order_id_bk` BIGINT NOT NULL,
    `ship_name` VARCHAR(255) NOT NULL,
	-- Measures
    `delivery_days` INT NOT NULL, -- Delivery Days = Shipped Date − Order Date
    `shipping_fee` DECIMAL(12,2) NOT NULL,
    `On_Time_Status` VARCHAR(50) NOT NULL, -- Condations

-- Foreign Keys
    FOREIGN KEY (`order_date_sk`) REFERENCES `dim_date`(`date_sk`),
    FOREIGN KEY (`shipped_date_sk`) REFERENCES `dim_date`(`date_sk`),
    FOREIGN KEY (`required_date_sk`) REFERENCES `dim_date`(`date_sk`),
    FOREIGN KEY (`shipper_sk`) REFERENCES `dim_shipper`(`shipper_sk`),
    FOREIGN KEY (`employee_sk`) REFERENCES `dim_employee`(`employee_sk`),
    FOREIGN KEY (`customer_sk`) REFERENCES `dim_customer`(`customer_sk`)
);

CREATE TABLE `fact_invoice` (
invoice_key INT AUTO_INCREMENT PRIMARY KEY,
-- Dimension Keys
    `invoice_sk` BIGINT NOT NULL,
    `customer_sk` BIGINT NOT NULL,
    `invoice_date_sk` BIGINT NOT NULL,
    `due_date_sk` BIGINT,
     `order_id_bk` BIGINT NOT NULL, -- Degenerate Dimension Key
    
	`amount_due` DECIMAL(12,2),
    `amount_paid` DECIMAL(12,2),
    `total_amount` DECIMAL(12,2),
-- Measures
    `outstanding_amount` DECIMAL(12,2),
    
-- Foreign Keys
    FOREIGN KEY (`invoice_sk`) REFERENCES `dim_invoice`(`invoice_sk`),
    FOREIGN KEY (`customer_sk`) REFERENCES `dim_customer`(`customer_sk`),
    FOREIGN KEY (`invoice_date_sk`) REFERENCES `dim_date`(`date_sk`),
    FOREIGN KEY (`due_date_sk`) REFERENCES `dim_date`(`date_sk`)
);
