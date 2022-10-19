### Monthly Revenues by Business Segment (Revenue is calculated by summing up price)(with subtotals and grand totals)
select A.*, 
concat(round(revenue * 100/first_value(revenue) over w, 0), '%') as monthly_pct
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