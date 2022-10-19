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
/* save the results to view monthly_revenue_by_business_segment
refer to file 'monthly_revenue_by_business_segment_view.sql' */


#### Monthly Revenues growth by Business Segment
/* select order_month, air_conditioning, 
air_conditioning - lag(air_conditioning) over w as air_conditioning_growth,
concat(round(((air_conditioning - lag(air_conditioning) over w)/lag(air_conditioning) over w) * 100, 2), '%') 
as air_conditioning_growth_rt 
from monthly_revenue_by_business_segment
window w as (order by order_month)
; */

SET
  @sql2 = (
    SELECT
      GROUP_CONCAT(
        DISTINCT CONCAT(business_segment, " - lag(", business_segment,
		") over w as ", business_segment,
        "_growth")
      )
    FROM
      marketing_orders
  );
select @sql2;

SET
  @sql3 = (
    SELECT
      GROUP_CONCAT(
        DISTINCT CONCAT("concat(round(((", business_segment, " - lag(", business_segment,
		") over w)/lag(", business_segment, ") over w) * 100, 2), '%') as ", business_segment,
        "_growth_rt")
      )
    FROM
      marketing_orders
  );
select @sql3;

SET
  @pivot_statement2 = CONCAT(
    "create view monthly_revenue_growth_by_business_segment as 
    select *,",
    @sql2,
    ",",
	@sql3,
    " from monthly_revenue_by_business_segment
     window w as (order by order_month)"
	 );
SELECT
  @pivot_statement2;
PREPARE complete_pivot_statment2
FROM
  @pivot_statement2;
EXECUTE complete_pivot_statment2;





