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