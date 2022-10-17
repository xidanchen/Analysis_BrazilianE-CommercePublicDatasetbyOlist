USE olistpublic;

## An order might have multiple items.
## Each item might be fulfilled by a distinct seller.
## All text identifying stores and partners where replaced by the names of Game of Thrones great houses.
## customerunique_id customers that made repurchases at the store
## each order is assigned to a unique customerid
# every purchase has a unique longitude and latitude？
#customers made more than two purchases
-- old customer
SELECT
COUNT(customer_id) AS purchases,
customer_unique_id,
customer_zip_code_prefix,
customer_city,
customer_state
FROM
customers 
GROUP BY customer_unique_id
HAVING COUNT(customer_id) >= 2
;

-- new customer
SELECT
COUNT(customer_id),
customer_unique_id,
customer_zip_code_prefix,
customer_city,
customer_state
FROM
customers
GROUP BY customer_unique_id
HAVING COUNT(customer_id) = 1
;



