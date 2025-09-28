-- ======================== ========================
-- 					Bronze Layer 
-- ======================== ========================


-- ========================
-- Create Database 
-- ========================
CREATE DATABASE staging_area_northwind;
USE staging_area_northwind;

-- ===========================
-- Create Tables (deep clone ) 
-- ===========================
CREATE TABLE staging_area_northwind.customers LIKE northwind.customers ; 
CREATE TABLE staging_area_northwind.employees LIKE northwind.employees;
CREATE TABLE staging_area_northwind.employee_privileges LIKE northwind.employee_privileges;
CREATE TABLE staging_area_northwind.inventory_transaction_types LIKE northwind.inventory_transaction_types;
CREATE TABLE staging_area_northwind.inventory_transactions LIKE northwind.inventory_transactions;
CREATE TABLE staging_area_northwind.invoices LIKE northwind.invoices;
CREATE TABLE staging_area_northwind.order_details LIKE northwind.order_details;
CREATE TABLE staging_area_northwind.order_details_status LIKE northwind.order_details_status;
CREATE TABLE staging_area_northwind.orders LIKE northwind.orders;
CREATE TABLE staging_area_northwind.orders_status LIKE northwind.orders_status;
CREATE TABLE staging_area_northwind.orders_tax_status LIKE northwind.orders_tax_status;
CREATE TABLE staging_area_northwind.privileges LIKE northwind.privileges;
CREATE TABLE staging_area_northwind.products LIKE northwind.products;
CREATE TABLE staging_area_northwind.purchase_order_details LIKE northwind.purchase_order_details;
CREATE TABLE staging_area_northwind.purchase_order_status LIKE northwind.purchase_order_status;
CREATE TABLE staging_area_northwind.purchase_orders LIKE northwind.purchase_orders;
CREATE TABLE staging_area_northwind.sales_reports LIKE northwind.sales_reports;
CREATE TABLE staging_area_northwind.shippers LIKE northwind.shippers;
CREATE TABLE staging_area_northwind.strings LIKE northwind.strings;
CREATE TABLE staging_area_northwind.suppliers LIKE northwind.suppliers;


-- ========================
-- Insert Method
-- ========================
INSERT INTO  staging_area_northwind.customers SELECT * FROM  northwind.customers ; 
INSERT INTO  staging_area_northwind.employees SELECT * FROM northwind.employees;
INSERT INTO staging_area_northwind.employee_privileges SELECT * FROM northwind.employee_privileges;
INSERT INTO staging_area_northwind.inventory_transaction_types SELECT * FROM northwind.inventory_transaction_types;
INSERT INTO staging_area_northwind.inventory_transactions SELECT * FROM northwind.inventory_transactions;
INSERT INTO staging_area_northwind.invoices SELECT * FROM northwind.invoices;
INSERT INTO staging_area_northwind.order_details SELECT * FROM northwind.order_details;
INSERT INTO staging_area_northwind.order_details_status SELECT * FROM northwind.order_details_status;
INSERT INTO staging_area_northwind.orders SELECT * FROM northwind.orders;
INSERT INTO staging_area_northwind.orders_status SELECT * FROM northwind.orders_status;
INSERT INTO staging_area_northwind.orders_tax_status SELECT * FROM northwind.orders_tax_status;
INSERT INTO staging_area_northwind.privileges SELECT * FROM northwind.privileges;
INSERT INTO staging_area_northwind.products SELECT * FROM northwind.products;
INSERT INTO staging_area_northwind.purchase_order_details SELECT * FROM northwind.purchase_order_details;
INSERT INTO staging_area_northwind.purchase_order_status SELECT * FROM northwind.purchase_order_status;
INSERT INTO staging_area_northwind.purchase_orders SELECT * FROM northwind.purchase_orders;
INSERT INTO staging_area_northwind.sales_reports SELECT * FROM northwind.sales_reports;
INSERT INTO staging_area_northwind.shippers SELECT * FROM northwind.shippers;
INSERT INTO staging_area_northwind.strings SELECT * FROM northwind.strings;
INSERT INTO staging_area_northwind.suppliers SELECT * FROM  northwind.suppliers;



