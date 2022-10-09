select customer_unique_id, count(*)
from customers
group by customer_unique_id
having count(*) > 1
order by count(*) desc
;

select customer_id, count(*)
from customers
group by customer_id
having count(*) > 1
order by count(*) desc
;

# no replicate cases for customer_id, so customer_id is unique, but it is key to the orders, it is customer_order_id.
# customer_unique_id is the customer id

SELECT * FROM olistpublic.orders;
# order_id, customer_id are unique
select count(*)
from orders
group by order_id
having count(*) > 1;

select count(*)
from orders
group by customer_id
having count(*) > 1;

alter table orders
add primary key (order_id),
add foreign key (customer_id)
     references customers(customer_id)
;

alter table order_payments
add foreign key (order_id)
     references orders(order_id)
;

SELECT * FROM olistpublic.order_items;
select order_id, count(*)
from order_items
group by order_id
having count(*) > 1
order by count(*)
;

select order_item_id, count(*)
from order_items
group by order_item_id
having count(*) > 1
order by count(*)
;

select seller_id, count(*)
from order_items
group by seller_id
having count(*) > 1
order by count(*) desc
;

select product_id, count(*)
from order_items
group by product_id
having count(*) > 1
order by count(*) desc
;


# order_id, order_item_id, product_id, seller_id are not unique

alter table order_items
add foreign key (order_id)
    references orders(order_id)
;

alter table order_items
add foreign key (product_id)
    references products(product_id)
;

select count(*)
from sellers
group by seller_id
order by count(*) desc;

alter table order_items
add foreign key (seller_id)
    references sellers(seller_id)
;

select count(*)
from category_name
group by product_category_name
having count(*) > 1
;

