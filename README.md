# Analysis_BrazilianE-CommercePublicDatasetbyOlist
**Data source**:
https://www.kaggle.com/olistbr/brazilian-ecommerce
https://www.kaggle.com/datasets/olistbr/marketing-funnel-olist

**List of files based on the time generated**
- CreateBrazilianE-CommercePublicDatasetOlist.sql
  - A discription of relationships among the tables: EER Diagram
  
- simpleAnalysis.sql
  - exported data: return_customers.csv, used tableau analysis
  
- geolocationDataAnalysis.sql
  - table used: geolocation
  - deleted the replicated cases, created new table geolocation_nw
  - checked the uniqueness, zip_code_prefix is not unique
  - need further visual exploration
  
- alterTable.sql
  - checked column uniqueness
  - added and changed primary keys and foreign keys

- order_paymentsEDA.sql
  - table used: order_payments
  - checked uniqueness, order_id is not unique, an order can have multiple payments

- marketing_qualified_leadsEDA.sql
  - table used： marketing_qualified_leads
  - Exploratory Data Analysis
    - marketing channel effectiveness
      - mql(marketing qualified leads) by time
	  - mql by marketing channel
	    - how does chanel change over time?

- combinedMarketingFunnelDataAnalysis.sql
  - table used: marketing_qualified_leads, closed_deals
  - temporary table: marketing_funnel (combined mql and closed deals data)
  - sql: pivot table
  - Exploratory Data Analysis
	- sales performance overview
	  - closed deals by month
	  - conversion rate by month
	  - average sales length by month
	  - landing page performance
		- landing page by month and weekday difference
	  - marketing channel performance
		- marketing channel by month and weekday difference

- closed_dealsEDA_part1.sql
  - table used: closed_deals
  - Exploratory Data Analysis
	- characteristics of closed deals
	- sdr/sr (sales) performance
	  - need further visual exploration
  
- closed_dealsEDA_part2.sql
  - table used: closed_deals, order_items, orders, products, category_name
  - temporary table: marketing_orders (those closed deals sellers' selling information, including orders and products)
  - views: 
    - marketing_orders
    - monthly_revenue_by_business_segment_wth_pct_subtotals
	  - monthly_revenue_by_business_segment_with_percentage_subtotals_grandtotals_view.sql
	  - monthly_revenue_by_business_segment_with_percentage_subtotals_grandtotals.csv
	  - monthly_revenue_by_business_segment_with_percentage_subtotals_grandtotals_pivotTable_graphs.xlsx
	- monthly_revenue_by_business_segment
	  - monthly_revenue_by_business_segment_pivot_view.sql
	  - monthly_revenue_by_business segment_pivot_table.csv
	- monthly_revenue_growth_by_business_segment
	  - monthly_revenue_growth_by_business_segment_view.sql
	  - monthly_revenue_growth_by_business_segment.csv
	  - monthly_revenue_growth_by_business_segment_graphs.xlsx
  - sql: windown function, pivot table using group_concat, user-defined variables
  - Exploratory Data Analysis
    - closed deals revenue
	  - Monthly Revenues by Business Segment (Revenue is calculated by summing up price)(with subtotals and grand totals)
        - monthly_revenue_by_business_segment_wth_pct_subtotals
		- monthly_revenue_by_business_segment
	  - Monthly Revenues growth by Business Segment
	    - monthly_revenue_growth_by_business_segment
		
- closed_dealsEDA_part3.sql
  - table used: marketing_orders
  - Exploratory Data Analysis
    - product category analysis











