SELECT * FROM olistpublic.closed_deals;
# has_company: does the lead have a company
# has_gtin: does the lead have global trade item number (barcode) for his products
/*
Behaviour_profile	DISC_profile	Description
Cat	Steadiness	Person places emphasis on cooperation, sincerity, dependability
Eagle	Influence	Person places emphasis on influencing or persuading others, openness, relationships
Wolf	Conscientiousness	Person places emphasis on quality and accuracy, expertise, competency
Shark	Dominance	Person places emphasis on accomplishing results, the bottom line, confidence
*/
## characteristics of closed deals: 
/*behavior profiles, lead type(I am not sure what does it mean here. it is marketing lead type or seller's business type?), 
business_segment, has_company, has_gtin, average_stock, business_type,
declared_product_catalog_size, declared_monthly_revenue
analyze the characteristics of closed deals, which will give us some ideas about personalization and segmentation
*/

select distinct lead_behaviour_profile, count(*)
from closed_deals
group by lead_behaviour_profile
;
/*
recategorize the lead_behaviour_profile data. becasue the number of seller having ambigious lead_behaviour_profile (e.g. cat,wolf)
is small, I have combined those profiles to 'other'. there are 177 selllers's lead_behaviour_profile information are missing, I've also
categorized those to 'other'.  
*/
select
(case when lead_behaviour_profile = 'cat' then lead_behaviour_profile
      when lead_behaviour_profile = 'wolf' then lead_behaviour_profile
      when lead_behaviour_profile = 'eagle' then lead_behaviour_profile
	 when lead_behaviour_profile = 'shark' then lead_behaviour_profile
     when lead_behaviour_profile is null then 'other'
     else 'other'
end) as lead_behaviour_profile_nw, count(*), count(*)/(select count(*) from closed_deals) as percentage
from closed_deals
group by lead_behaviour_profile_nw
;
/*
1. 48% of closed deals come from sellers having 'cat' behaviour profile
2. 39% of lead type are online_medium， the three most common lead types are online medium, online big, industry
3. top three major business segments are home_decor	(12.47%), health_beauty (11.05%), car_accessories (9.14%)
4. 7% closed deal sellers have company, majority (93%) did not provide this information
5. 6% closed deal sellers have global trade item number (barcode) for their products
6. 92% did not provide information of average_stock. 3% have an average stock of '5-20'
7. 92% did not provide information of declared_product_catalog_size. 1% of seller have catelog_size of 100
8. 95% did not provide information of declared monthly revenue, 0.6% of seller have monthly revenue of 100000
9. from (4, 5, 6,7,8), we can see sellers are relunctantly provide detailed information about their business. how can we 
encourage them to provide such information?

*/
select lead_type, count(*), count(*)/(select count(*) from closed_deals) as pct_lead_type
from closed_deals
group by lead_type
order by count(*) desc
;

select business_segment, count(*), count(*)/(select count(*) from closed_deals) as pct_business_segment
from closed_deals
group by business_segment
order by count(*) desc
;

select has_company, count(*), count(*)/(select count(*) from closed_deals) as pct_has_company
from closed_deals
group by has_company
order by count(*) desc
;

select has_gtin, count(*), count(*)/(select count(*) from closed_deals) as pct_has_gtin
from closed_deals
group by has_gtin
order by count(*) desc
;

select average_stock, count(*), count(*)/(select count(*) from closed_deals) as pct_average_stock
from closed_deals
group by average_stock
order by count(*) desc
;

select declared_product_catalog_size, count(*), count(*)/(select count(*) from closed_deals) as pct_declared_product_catalog_size
from closed_deals
group by declared_product_catalog_size
order by count(*) desc
;
select declared_monthly_revenue, count(*), count(*)/(select count(*) from closed_deals) as pct_declared_monthly_revenue
from closed_deals
group by declared_monthly_revenue
order by count(*) desc
;




## sdr/sr (sales) performance 
## closed deals revenue



