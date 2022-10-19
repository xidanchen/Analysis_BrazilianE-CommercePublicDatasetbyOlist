/*create temporary table marketing_orders
select *
from closed_deals
inner join order_items using (seller_id)
inner join orders using (order_id)
inner join products using (product_id)
left join category_name using (product_category_name)
;*/

### Monthly Revenues by Business Segment (Revenue is calculated by summing up price)(with subtotals and grand totals)

create view monthly_revenue_by_business_segment_wth_pct_subtotals as 
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





