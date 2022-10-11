SELECT * FROM olistpublic.marketing_qualified_leads;
# mql_id : a potential reseller/manufacturer who has an interest in selling products on olist
# marketing channel effectiveness
## mql by time 
/* mql increased over time, but had a significant increase from 2017/11 to 2018/01. 
what happened between 201711, 201712, 201801? */
select DATE_FORMAT(first_contact_date,'%Y%m') as contact_date, count(mql_id) as num_potential_seller
from marketing_qualified_leads
group by contact_date
order by contact_date
;

## mql by marketing channel
/* 
1. organic search is the biggest contributor to mql,
the second and third are paid search and social
2. social became the second most important contributor from 2018/04
3. organic_search significantly increased from 2018/01
4. I will take deeper look of marketing channel performance with the combined marketing channel data
*/
select origin, count(*)
from marketing_qualified_leads
group by origin
order by count(*) desc
;

### how does chanel change over time?
select origin, DATE_FORMAT(first_contact_date,'%Y%m') as contact_date,
count(mql_id) as num_potential_seller
from marketing_qualified_leads
where origin in ('organic_search', 'social', 'paid_search')
group by origin, contact_date
order by contact_date, num_potential_seller desc
;

select landing_page_id, count(*)
from marketing_qualified_leads
group by landing_page_id
order by count(*) desc
;