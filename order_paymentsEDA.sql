SELECT * FROM olistpublic.order_payments;
select order_id, count(*)
from order_payments
group by order_id
having count(*) > 1
order by count(*) desc;
# so order_id is not unique, an order can have multiple payments 

select * from orders
where order_id = 'fa65dad1b0e818e3ccc5cb0e39231352';

select * from order_payments
where order_id = 'fa65dad1b0e818e3ccc5cb0e39231352'
order by payment_sequential;