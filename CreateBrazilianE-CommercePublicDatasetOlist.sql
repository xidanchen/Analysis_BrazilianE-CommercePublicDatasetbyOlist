## DATA SOURCE: https://www.kaggle.com/olistbr/brazilian-ecommerce
## create database for this dataset, and import csv file into mysql table
CREATE DATABASE IF NOT EXISTS OlistPublic;

USE OlistPublic;

###################################################### create customers table #########################################
-- DROP TABLE customers;
CREATE TABLE customers (
customer_id VARCHAR(255) NOT NULL,
customer_unique_id VARCHAR(255),
customer_zip_code_prefix CHAR(5),
customer_city VARCHAR(255),
customer_state CHAR(2),
PRIMARY KEY(customer_id),
KEY(customer_zip_code_prefix)

);

-- SHOW VARIABLES LIKE "secure_file_priv";

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_customers_dataset.csv"
INTO TABLE customers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

###################################################### create geolocation table #########################################
-- for storing longitude, latitude 
-- https://stackoverflow.com/questions/159255/what-is-the-ideal-data-type-to-use-when-storing-latitude-longitude-in-a-mysql
-- DROP TABLE geolocation;
CREATE TABLE geolocation (
geolocation_zip_code_prefix CHAR(5) NOT NULL,
geolocation_lat DECIMAL(8,6),
geolocation_lng DECIMAL(9,6),
geolocation_city VARCHAR(255),
geolocation_state CHAR(2),
KEY(geolocation_zip_code_prefix)
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_geolocation_dataset.csv"
INTO TABLE geolocation
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


###################################################### create order_items table #########################################
-- DROP TABLE order_items;
CREATE TABLE order_items (
order_id VARCHAR(255) NOT NULL,
order_item_id INT,
product_id VARCHAR(255),
seller_id VARCHAR(255),
shipping_limit_date TIMESTAMP,
price DECIMAL(6, 2),
freight_value DECIMAL(5, 2),
KEY(order_id, product_id, seller_id)
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_items_dataset.csv"
INTO TABLE order_items
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


###################################################### create order_payments table #########################################

-- DROP TABLE order_payments;
CREATE TABLE order_payments (

order_id VARCHAR(255) NOT NULL,
payment_sequential INT(2),
payment_type CHAR(11),
payment_installments DECIMAL(4, 2),
payment_value DECIMAL(7, 2),
KEY(order_id)

);


LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_payments_dataset.csv"
INTO TABLE order_payments
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

###################################################### create order_reviews table #########################################
/*
-- Error Code: 1292. 
-- Incorrect datetime value: 'f63f9a7699e3674c80a4ba92e56dfbb8' for column 'review_creation_date' at row 78545	
-- DROP TABLE order_reviews;
CREATE TABLE order_reviews (

review_id VARCHAR(255) NOT NULL,
order_id VARCHAR(255),
review_score INT,
review_comment_title TEXT NULL,
review_comment_message TEXT NULL,
review_creation_date DATETIME,
review_answer_timestamp TIMESTAMP,
KEY(review_id, order_id)
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_reviews_dataset.csv"
INTO TABLE order_reviews
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
review_id,
order_id,
review_score,
@v_review_comment_title,
@v_review_comment_message,
review_creation_date,
review_answer_timestamp
)

SET
review_comment_title = NULLIF(@v_review_comment_title, ''),
review_comment_message = NULLIF(@v_review_comment_message, '')
;

*/

###################################################### create orders table #########################################
-- DROP TABLE orders;
CREATE TABLE orders (

order_id VARCHAR(255) NOT NULL,
customer_id VARCHAR(255),
order_status VARCHAR(255),
order_purchase_timestamp TIMESTAMP NULL,
order_approved_at TIMESTAMP NULL,
order_delivered_carrier_date TIMESTAMP NULL,
order_delivered_customer_date TIMESTAMP NULL,
order_estimated_delivery_date DATETIME NULL,
KEY(order_id, customer_id)

);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_orders_dataset.csv"
INTO TABLE orders
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, customer_id, order_status, order_purchase_timestamp, 
@v_order_approved_at, @v_order_delivered_carrier_date, @v_order_delivered_customer_date,  order_estimated_delivery_date)
SET 
order_approved_at = NULLIF(@v_order_approved_at, ''),
order_delivered_carrier_date = NULLIF(@v_order_delivered_carrier_date, ''),
order_delivered_customer_date = NULLIF(@v_order_delivered_customer_date, '')
;

###################################################### create products table #########################################
CREATE TABLE products (
product_id VARCHAR(255) NOT NULL,
product_category_name VARCHAR(255),
product_name_lenght INT,
product_description_lenght INT,
product_photos_qty INT,
product_weight_g INT,
product_length_cm INT,
product_height_cm INT,
product_width_cm INT,
PRIMARY KEY(product_id)

);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_products_dataset.csv"
INTO TABLE products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
product_id,
@v_product_category_name,
@v_product_name_lenght,
@v_product_description_lenght,
@v_product_photos_qty,
@v_product_weight_g,
@v_product_length_cm,
@v_product_height_cm,
@v_product_width_cm

)

SET 

product_category_name = NULLIF(@v_product_category_name, ''),
product_name_lenght = NULLIF(@v_product_name_lenght, ''),
product_description_lenght = NULLIF(@v_product_description_lenght, ''),
product_photos_qty = NULLIF(@v_product_photos_qty, ''),
product_weight_g = NULLIF(@v_product_weight_g, ''),
product_length_cm = NULLIF(@v_product_length_cm, ''),
product_height_cm = NULLIF(@v_product_height_cm, ''),
product_width_cm = NULLIF(@v_product_width_cm, '')

;


###################################################### create sellers table #########################################
CREATE TABLE sellers (

seller_id VARCHAR(255) NOT NULL,
seller_zip_code_prefix CHAR(5),
seller_city VARCHAR(255),
seller_state CHAR(2),
PRIMARY KEY(seller_id)

);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_sellers_dataset.csv"
INTO TABLE sellers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

###################################################### create category_name table #########################################
CREATE TABLE category_name (
product_category_name VARCHAR(255) NOT NULL,
product_category_name_english VARCHAR(255) NOT NULL

);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product_category_name_translation.csv"
INTO TABLE category_name
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


################################ add marketing funnel data
-- DROP TABLE closed_deals;
CREATE TABLE closed_deals (
mql_id VARCHAR(255) PRIMARY KEY NOT NULL,
seller_id VARCHAR(255) NOT NULL,
sdr_id VARCHAR(255),
sr_id VARCHAR(255),
won_date TIMESTAMP NULL,
business_segment VARCHAR(255),
lead_type VARCHAR(255),
lead_behaviour_profile VARCHAR(255),
has_company CHAR(5),	
has_gtin CHAR(5),
average_stock VARCHAR(255),
business_type VARCHAR(255),
declared_product_catalog_size INT,
declared_monthly_revenue INT
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_closed_deals_dataset.csv"
INTO TABLE closed_deals
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(mql_id,
seller_id,
sdr_id,
sr_id,
won_date,
business_segment,
lead_type,
lead_behaviour_profile,
has_company,
has_gtin,
average_stock,
business_type,
@v_declared_product_catalog_size,
declared_monthly_revenue)
SET 
declared_product_catalog_size = NULLIF(@v_declared_product_catalog_size, '')
;

-- drop table marketing_qualified_leads;
CREATE TABLE marketing_qualified_leads (
mql_id VARCHAR(255),
first_contact_date DATETIME,
landing_page_id VARCHAR(255),
origin VARCHAR(255)

);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_marketing_qualified_leads_dataset.csv"
INTO TABLE marketing_qualified_leads
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
