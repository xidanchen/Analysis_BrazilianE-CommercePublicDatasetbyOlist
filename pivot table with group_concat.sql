/*create temporary table marketing_orders
select *
from closed_deals
inner join order_items using (seller_id)
inner join orders using (order_id)
inner join products using (product_id)
left join category_name using (product_category_name)
;
*/
/*drop temporary table marketing_orders;*/
create view marketing_orders as 
select *
from closed_deals
inner join order_items using (seller_id)
inner join orders using (order_id)
inner join products using (product_id)
left join category_name using (product_category_name)
;

#pivot table using group_concat
SET
  SESSION group_concat_max_len = 100000;
SET
  @sql = (
    SELECT
      GROUP_CONCAT(
        DISTINCT CONCAT("sum(CASE WHEN business_segment = '", 
        business_segment,
        "' THEN price ELSE NULL END) AS '", 
        business_segment, 
        "'")
      )
    FROM
      marketing_orders
  );
 
SET
  @pivot_statement = CONCAT(
    "create view monthly_revenue_by_business_segment as 
    select date_format(order_purchase_timestamp, '%Y%m') as order_month,",
    @sql,
    " from marketing_orders
where order_status = 'delivered'
group by order_month
order by order_month"
  );
SELECT
  @pivot_statement;
PREPARE complete_pivot_statment
FROM
  @pivot_statement;
EXECUTE complete_pivot_statment;