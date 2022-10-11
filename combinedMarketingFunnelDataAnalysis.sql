SELECT * FROM olistpublic.closed_deals;
# A MQL who finally signed up for seller is called a closed deal
## sales performance overview
# sdr_id: sales development representative    sr_id:sales representative
/*After a MQL filled a form on landing page to sign up for seller, 
a Sales Development Representative(SDR) contacted the MQL and gathered more information about the lead. 
Then a Sales Representative(SR) consulted the MQL. 
So interaction between SDRs/SRs and MQLs can affect conversion from MQLs to sellers.*/
### closed deals by month
select DATE_FORMAT(first_contact_date,'%Y%m') as contact_date,
count(seller_id) as num_closed_deals
from closed_deals c
right join marketing_qualified_leads m on c.mql_id = m.mql_id
group by contact_date
order by contact_date
;
/*
1. number of closed deals increase over time and from 2018/01 had a significant increase
2. from here we observe the same conversion rate change pattern
3. note here, although at 2017/12, there's a drop in number of mql and number of closed deals, 
but the conversion rate consistently increased
4. from 2018/03 there's a decreasing sign in conversion rate
*/
### conversion rate by month
# conversion rate = num_closed_deals/num_mql
select DATE_FORMAT(first_contact_date,'%Y%m') as contact_date,
count(seller_id) as num_closed_deals, count(m.mql_id) as num_mql,
count(seller_id)/count(m.mql_id) as conversion_rt
from closed_deals c
right join marketing_qualified_leads m on c.mql_id = m.mql_id
group by contact_date
order by contact_date
;

### sales length: period from first contact to signing up for seller
-- drop table marketing_funnel;
create temporary table marketing_funnel 
select m.mql_id, m.first_contact_date, m.origin, m.landing_page_id,
c.seller_id, c.sdr_id, c.sr_id, c.won_date, c.business_segment,
c.lead_type, c.lead_behaviour_profile, c.has_company, c.has_gtin,
c.average_stock, c.business_type, c.declared_monthly_revenue, c.declared_product_catalog_size
from closed_deals c
right join marketing_qualified_leads m on c.mql_id = m.mql_id;

### average sales length by month
/*
1. average sales length decreased over time, from highest 398 days to lowest 24 days
2. most of the deals were closed in 2018, first closed deal was in 2017/12
*/
select date_format(a.first_contact_date, '%Y%m') as contact_date, avg(a.sales_length)
from
(select first_contact_date, won_date,  datediff(won_date, first_contact_date) as sales_length
from marketing_funnel
) a
group by contact_date
order by contact_date
;

select won_date, first_contact_date
from marketing_funnel
where won_date is not null
order by won_date
;

/* from the previous analysis of combined marketing dataset we know most of the conversion rate increased from 2018
and most of the deals were closed from 2018. Are there any other factors contribute to the conversion change?
below I looked at the landing_page, marketing channel performance
*/

### landing page performance
select landing_page_id, count(seller_id)
from marketing_funnel
where seller_id is not null
group by landing_page_id
order by count(seller_id) desc
;




### marketing channel performance

