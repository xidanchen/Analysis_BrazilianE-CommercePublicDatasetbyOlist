## closed deals revenue
create temporary table marketing_orders
select *
from closed_deals
inner join order_items using (seller_id)
inner join orders using (order_id)
inner join products using (product_id)
left join category_name using (product_category_name)
;
select*from marketing_orders;
### Monthly Revenues by Business Segment (Revenue is calculated by summing up price)(with subtotals and grand totals)
select A.*, 
concat(round(revenue * 100/first_value(revenue) over w, 2), '%') as monthly_pct
from
(select if(grouping(date_format(order_purchase_timestamp, '%Y%m')), 'All Month', date_format(order_purchase_timestamp, '%Y%m')) as order_month, 
if(grouping(business_segment), 'All Segments', business_segment) as business_segment,
sum(price) as revenue
from marketing_orders
where order_status = 'delivered'
group by date_format(order_purchase_timestamp, '%Y%m'), business_segment with rollup
order by order_month) as A
window w as (partition by order_month order by revenue desc)
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
    "select date_format(order_purchase_timestamp, '%Y%m') as order_month,",
    @sql,
    " from marketing_orders
where order_status = 'delivered'
group by order_month
order by order_month"
  );
/*SELECT
  @pivot_statement;*/
PREPARE complete_pivot_statment
FROM
  @pivot_statement;

EXECUTE complete_pivot_statment;

