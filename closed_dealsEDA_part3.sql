### product category analysis
use olistpublic;
select business_segment, product_category_name_english
from marketing_orders
;
# 57 product category
select distinct product_category_name_english
from marketing_orders
;
/*
Which product categories contribute significantly to the total sales? 
Which product categories are not performing well?
How is our product compared to other products in the market?
What are the trends in this product category?
Which geographic regions have more margins?
*/







