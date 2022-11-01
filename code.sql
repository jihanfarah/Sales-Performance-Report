SELECT 
  YEAR(order_date) AS years, SUM(sales) as sales, COUNT(order_status) as number_of_order 
FROM dqlab_sales_store 
WHERE order_status = "Order Finished" 
GROUP BY years 
ORDER BY years ASC
