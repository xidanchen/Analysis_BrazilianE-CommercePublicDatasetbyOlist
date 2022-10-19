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
SELECT
  @pivot_statement;
PREPARE complete_pivot_statment
FROM
  @pivot_statement;

EXECUTE complete_pivot_statment;