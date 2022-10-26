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

# sales length: period from first contact to signing up for seller
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
select landing_page_id, count(mql_id)
from marketing_funnel
group by landing_page_id
order by count(mql_id) desc
;
select landing_page_id, count(mql_id) as num_mql, count(seller_id) as num_closed_deals,
count(seller_id)/count(mql_id) as conv_rt
from marketing_funnel
group by landing_page_id
order by conv_rt desc
;

/*
1. '22c29808c4f815213303f8933030604c', and 'b76ef37428e6799c421989521c0e5077'
are two most viewed landing_page, their conversion rate are 19.71% and 18.75% respectively
2. there are a few landing pages having really high conversion rate, unfortunately there's no data about this
so i am not able to inversigate further. 
*/

#### landing page by month and weekday difference
/*
1. two most visited landing pages' conversion rates significant increased from 2018 and were stable from 2018
2. 22c29808c4f815213303f8933030604c had highest conversion rate on tuesday
2. b76ef37428e6799c421989521c0e5077 had highest conversion rate on saturday
*/
select DATE_FORMAT(first_contact_date,'%Y%m') as contact_date,
landing_page_id, count(mql_id) as num_mql, count(seller_id) as num_closed_deals,
count(seller_id)/count(mql_id) as conv_rt
from marketing_funnel
where landing_page_id in ('22c29808c4f815213303f8933030604c', 'b76ef37428e6799c421989521c0e5077')
group by landing_page_id, contact_date
order by contact_date, conv_rt desc
;

#pivot table
select DATE_FORMAT(first_contact_date,'%Y%m') as contact_date,
count(case when landing_page_id = '22c29808c4f815213303f8933030604c' then seller_id else null end)/
count(case when landing_page_id = '22c29808c4f815213303f8933030604c' then mql_id else null end) as c_conv,
count(case when landing_page_id = 'b76ef37428e6799c421989521c0e5077' then seller_id else null end)/
count(case when landing_page_id = 'b76ef37428e6799c421989521c0e5077' then mql_id else null end) as b_conv
from marketing_funnel
group by contact_date
order by contact_date
;

select weekday(first_contact_date) as wkday_contact_date,
count(case when landing_page_id = '22c29808c4f815213303f8933030604c' then seller_id else null end)/
count(case when landing_page_id = '22c29808c4f815213303f8933030604c' then mql_id else null end) as c_conv,
count(case when landing_page_id = 'b76ef37428e6799c421989521c0e5077' then seller_id else null end)/
count(case when landing_page_id = 'b76ef37428e6799c421989521c0e5077' then mql_id else null end) as b_conv
from marketing_funnel
group by wkday_contact_date
order by wkday_contact_date
;



### marketing channel performance
/* which marketing channels are driving most mql and closed deals
 understanding differences in user characteristics and conversion performance across marketing channels
 optimizing bids and allocating marketing spend across a multi-channel portfolio to achieve maximum performance are important
 */
select origin, count(mql_id) as num_mql, count(seller_id) as num_closed_deals,
count(seller_id)/count(mql_id) as conv_rt
from marketing_funnel
group by origin
order by conv_rt desc
;
/* 
1. from the previous marketing_qualified_leads data analysis, we know organic_search, paid_search, and social
are three major contributor of mql. 
Here paid_search performed better than organic_search in terms of conversion rate.
social has a really low conversion rate comparing to those two. some unknow origins have really good conversion rate. It will
be intersting to dig into and have better understanding of those traffic sources. 
2. note paid_search is only slightly better than non_paid(organic_search, direct_traffic)
3. organic_search performed as well as paid_search by month, it seems like the brand is doing well
*/

select DATE_FORMAT(first_contact_date,'%Y%m') as contact_date,
origin, count(mql_id) as num_mql, count(seller_id) as num_closed_deals,
count(seller_id)/count(mql_id) as conv_rt
from marketing_funnel
where origin in ('organic_search', 'social', 'paid_search')
group by origin, contact_date
order by contact_date, conv_rt desc
;

#pivot table
select DATE_FORMAT(first_contact_date,'%Y%m') as contact_date,
count(case when origin = 'organic_search' then seller_id else null end)/
count(case when origin = 'organic_search' then mql_id else null end) as organic_search_conv,
count(case when origin = 'social' then seller_id else null end)/
count(case when origin = 'social' then mql_id else null end) as social_conv,
count(case when origin = 'paid_search' then seller_id else null end)/
count(case when origin = 'paid_search' then mql_id else null end) as paid_search_conv
from marketing_funnel
group by contact_date
order by contact_date
;

#### is there weekday difference?
/*
1. organic_search and paid_search had highest conversion rate on saturday
2. social had highest conversion rate on sunday
*/
select weekday(first_contact_date) as wkday_contact_date,
count(case when origin = 'organic_search' then seller_id else null end) as organic_search_closed_deals,
count(case when origin = 'social' then seller_id else null end) as social_closed_deals,
count(case when origin = 'paid_search' then seller_id else null end) as paid_search_closed_deals,
count(case when origin = 'organic_search' then mql_id else null end) as organic_search_mql,
count(case when origin = 'social' then mql_id else null end) as social_mql,
count(case when origin = 'paid_search' then mql_id else null end) as paid_search_mql,
count(case when origin = 'organic_search' then seller_id else null end)/
count(case when origin = 'organic_search' then mql_id else null end) as organic_search_conv,
count(case when origin = 'social' then seller_id else null end)/
count(case when origin = 'social' then mql_id else null end) as social_conv,
count(case when origin = 'paid_search' then seller_id else null end)/
count(case when origin = 'paid_search' then mql_id else null end) as paid_search_conv
from marketing_funnel
group by wkday_contact_date
order by wkday_contact_date
;

### marketing channel by landing page
select origin, landing_page_id, 
count(mql_id) as num_mql, count(seller_id) as num_closed_deals,
count(seller_id)/count(mql_id) as conv_rt
from marketing_funnel
where origin in ('organic_search', 'social', 'paid_search') and 
landing_page_id in ('22c29808c4f815213303f8933030604c', 'b76ef37428e6799c421989521c0e5077')
group by origin, landing_page_id
order by conv_rt desc
;



