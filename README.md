# Sales Performance Report

## Overview
This project is held by DQLab. The main goal of this project is to analyze the sales perfomance of DQLab Store.

## Dataset Brief
For this project, we will use the `dqlab_sales_store` table. This table contains the transaction from 2009 to 2012, with the total raw data being 5500.

The field in data included:

1. OrderID: 
2. Order Status: There are three categories of order, such as order finished, order returned, and order cancelled.
3. Customer
4. Order Date
5. Order Quantity
6. Sales
7. Discount %
8. Discount
9. Product Category
10. Product Sub-Category

## Project Instructions

The instruction is divided into three parts. The DQLab store management wants to know:

1A. The overall performance of the DQLab Store from 2009 to 2012 for finished orders that contain the total of orders and total sales.
1B. The comparison of the overall performance of DQLab Store for finished orders by sub-category product between 2011 and 2012.

2A. The promotions' effectivity and efficiency, by figuring the burn rate of the promotions that were held, based on year.
2B. The promotions' effectiveness and efficiency, by figuring the burn rate of the promotions that were held, based on the sub-category.

From the result of part 1 and 2, we will:
3A. Analyze the total of customers each year
3B. Analyze the total of new customers each year
3C. Cohort to find out the number of retention customer in 2009

## Part 1
### Overall Performance of the DQLab Store by Year

```{sql}
SELECT 
  YEAR(order_date) AS years, 
  SUM(sales) as sales, 
  COUNT(order_status) as number_of_order 
FROM 
  dqlab_sales_store 
WHERE order_status = "Order Finished" 
GROUP BY years 
ORDER BY years ASC
```

Output
```
+-------+------------+-----------------+
| years | sales      | number_of_order |
+-------+------------+-----------------+
|  2009 | 4613872681 |            1244 |
|  2010 | 4059100607 |            1248 |
|  2011 | 4112036186 |            1178 |
|  2012 | 4482983158 |            1254 |
+-------+------------+-----------------+
```

We can see the highest sales were in 2009 with total sales are 4613872681 and total finished orders are 1244, while the lowest sales were in 2010 with total finished orders are 1248.

### Overall Performance of DQLab Store by Sub-Category Product in 2011 and 2012.

```
SELECT 
  YEAR(order_date) AS years, 
  product_sub_category, 
  SUM(sales) as sales
FROM 
  dqlab_sales_store
WHERE order_status = "Order Finished" AND 2011 <= YEAR(order_date) AND YEAR(order_date)<= 2012
GROUP BY years, product_sub_category
ORDER BY years ASC, sales DESC 
```

Output
```
+-------+--------------------------------+-----------+
| years | product_sub_category           | sales     |
+-------+--------------------------------+-----------+
|  2011 | Chairs & Chairmats             | 622962720 |
|  2011 | Office Machines                | 545856280 |
|  2011 | Tables                         | 505875008 |
|  2011 | Copiers and Fax                | 404074080 |
|  2011 | Telephones and Communication   | 392194658 |
|  2011 | Binders and Binder Accessories | 298023200 |
|  2011 | Storage & Organization         | 285991820 |
|  2011 | Appliances                     | 272630020 |
|  2011 | Computer Peripherals           | 232677960 |
|  2011 | Bookcases                      | 169304620 |
|  2011 | Office Furnishings             | 160471500 |
|  2011 | Paper                          | 111080380 |
|  2011 | Pens & Art Supplies            |  43093800 |
|  2011 | Envelopes                      |  36463900 |
|  2011 | Labels                         |  15607780 |
|  2011 | Scissors, Rulers and Trimmers  |  12638340 |
|  2011 | Rubber Bands                   |   3090120 |
|  2012 | Office Machines                | 811427140 |
|  2012 | Chairs & Chairmats             | 654168740 |
|  2012 | Telephones and Communication   | 422287514 |
|  2012 | Tables                         | 388993784 |
|  2012 | Binders and Binder Accessories | 363879200 |
|  2012 | Storage & Organization         | 356714140 |
|  2012 | Computer Peripherals           | 308014340 |
|  2012 | Copiers and Fax                | 292489800 |
|  2012 | Appliances                     | 266131100 |
|  2012 | Office Furnishings             | 178927480 |
|  2012 | Bookcases                      | 159984680 |
|  2012 | Paper                          | 126896160 |
|  2012 | Envelopes                      |  58629280 |
|  2012 | Pens & Art Supplies            |  43818480 |
|  2012 | Scissors, Rulers and Trimmers  |  36776400 |
|  2012 | Labels                         |  10007040 |
|  2012 | Rubber Bands                   |   3837880 |
+-------+--------------------------------+-----------+
```

From the table, we can see the three sub-category product in 2011 with the highest sales were chairs & chairmats, office machines, and tables. However, in 2012, the three sub-category products with the highest sales were office machines, chairs & chairmats, and telephones & communication. We can conclude that in 2011 and 2012, the sales had different demands for products.

## Part 2
For this part, we will analyze the effectiveness and efficiency of the promotion that was held. We will add the number of burn rate percentages by year. The formula of the burn rate percentage is the total discount value, divided by the total of sales, and multiply by 100. The higher the percentage, the higher money is needed to promote the products.

### Promotion Effectiveness and Efficiency by Years

```
SELECT 
  YEAR(order_date) AS years, 
  SUM(sales) AS sales, SUM(discount_value) AS promotion_value,
  ROUND((SUM(discount_value)/SUM(sales))*100,2) AS burn_rate_percentage
FROM 
  dqlab_sales_store
WHERE order_status="Order Finished"
GROUP BY years
ORDER BY years ASC;
```

Output
```
+-------+------------+-----------------+----------------------+
| years | sales      | promotion_value | burn_rate_percentage |
+-------+------------+-----------------+----------------------+
|  2009 | 4613872681 |       214330327 |                 4.65 |
|  2010 | 4059100607 |       197506939 |                 4.87 |
|  2011 | 4112036186 |       214611556 |                 5.22 |
|  2012 | 4482983158 |       225867642 |                 5.04 |
+-------+------------+-----------------+----------------------+
```

From the table, the burn rate percentage tends to increase each year. It means the cost of promotions also increased. We can conclude the promotion is not effective and efficient, so the store needs to find another way to promote their products.

### Promotion Effectiveness and Efficiency by Product Sub Category in 2012

```
SELECT YEAR(order_date) AS years, 
	product_sub_category, 
	product_category, 
	SUM(sales) as sales, 
	SUM(discount_value) AS promotion_value,
	ROUND(SUM(discount_value)/SUM(sales)*100,2) As burn_rate_percentage
FROM 
  dqlab_sales_store
WHERE YEAR(order_date)=2012 AND order_status = "Order Finished"
GROUP BY product_sub_category, product_category, years
ORDER BY sales DESC;
```

Output

```
+-------+--------------------------------+------------------+-----------+-----------------+----------------------+
| years | product_sub_category           | product_category | sales     | promotion_value | burn_rate_percentage |
+-------+--------------------------------+------------------+-----------+-----------------+----------------------+
|  2012 | Office Machines                | Technology       | 811427140 |        46616695 |                 5.75 |
|  2012 | Chairs & Chairmats             | Furniture        | 654168740 |        26623882 |                 4.07 |
|  2012 | Telephones and Communication   | Technology       | 422287514 |        18800188 |                 4.45 |
|  2012 | Tables                         | Furniture        | 388993784 |        16348689 |                  4.2 |
|  2012 | Binders and Binder Accessories | Office Supplies  | 363879200 |        22338980 |                 6.14 |
|  2012 | Storage & Organization         | Office Supplies  | 356714140 |        18802166 |                 5.27 |
|  2012 | Computer Peripherals           | Technology       | 308014340 |        15333293 |                 4.98 |
|  2012 | Copiers and Fax                | Technology       | 292489800 |        14530870 |                 4.97 |
|  2012 | Appliances                     | Office Supplies  | 266131100 |        14393300 |                 5.41 |
|  2012 | Office Furnishings             | Furniture        | 178927480 |         8233849 |                  4.6 |
|  2012 | Bookcases                      | Furniture        | 159984680 |        10024365 |                 6.27 |
|  2012 | Paper                          | Office Supplies  | 126896160 |         6224694 |                 4.91 |
|  2012 | Envelopes                      | Office Supplies  |  58629280 |         2334321 |                 3.98 |
|  2012 | Pens & Art Supplies            | Office Supplies  |  43818480 |         2343501 |                 5.35 |
|  2012 | Scissors, Rulers and Trimmers  | Office Supplies  |  36776400 |         2349280 |                 6.39 |
|  2012 | Labels                         | Office Supplies  |  10007040 |          452245 |                 4.52 |
|  2012 | Rubber Bands                   | Office Supplies  |   3837880 |          117324 |                 3.06 |
+-------+--------------------------------+------------------+-----------+-----------------+----------------------+
```

From the table, we can see the three products with the highest burn rate percentage are scissors, rulers, & trimmers, bookcases, and binders & binders accessories. Because they have the highest burn rate percentage, the promotion of the three products needs to improve.

## Part 3
In this part, we will analyze the customers of DQLab Store.

### Customers Transactions per Year

```
SELECT 
  YEAR(order_date) AS years, 
  COUNT(DISTINCT customer) AS number_of_customer
FROM 
  dqlab_sales_store
WHERE order_status="Order Finished"
GROUP BY years
ORDER BY years ASC
```

Output

```
+-------+--------------------+
| years | number_of_customer |
+-------+--------------------+
|  2009 |                585 |
|  2010 |                593 |
|  2011 |                581 |
|  2012 |                594 |
+-------+--------------------+
```

We can see the number of customers each year are above 580 customers, with the highest total customers in 2012. There is no significant change in the total number of customers, but in 2012, the total number of customers increased by 13 customers.

### Total of New Customers per Year

```
SELECT 
	YEAR(first_transaction_date) AS years, 
	COUNT(DISTINCT customer) AS number_of_new_customer
FROM (SELECT 
	  customer,
	  MIN(order_date) AS first_transaction_date
	  FROM dqlab_sales_store
	  WHERE order_status="Order Finished"
	  GROUP BY customer) AS first_transaction
GROUP BY years
```

Output

```
+-------+------------------------+
| years | number_of_new_customer |
+-------+------------------------+
|  2009 |                    585 |
|  2010 |                    141 |
|  2011 |                     38 |
|  2012 |                     11 |
+-------+------------------------+
```

We can see the total of new customers is decreasing each year. 

3C. The percentage of Retention Customer in 2009

```
+-------+--------------------+
| years | retention_customer |
+-------+--------------------+
|  2009 |              77.26 |
+-------+--------------------+
```

We can the percentage of retention customers is 77.26%. It means 77.29% of customers in 2009 made transactions again in 2010.

## Conclusion

1. The highest sales were in 2009 with total sales are 4613872681 and total finished orders are 1244, while the lowest sales were in 2010 with total finished orders are 1248.
2. The three sub-category product in 2011 with the highest sales were chairs & chairmats, office machines, and tables. However, in 2012, the three sub-category products with the highest sales were office machines, chairs & chairmats, and telephones & communication. We can conclude that in 2011 and 2012, the sales had different demands for products.
3. The burn rate percentage and the cost of promotions tends to increase each year, shows the promotion is not effective and not efficient. The store needs to find another way to promote their products.
4. The three products with the highest burn rate percentage are scissors, rulers, & trimmers, bookcases, and binders & binders accessories. Because they have the highest burn rate percentage, the promotion of the three products needs to improve. 
5. The number of customers each year are above 580 customers, with the highest total customers in 2012. There is no significant change in the total number of customers, but in 2012, the total number of customers increased by 13 customers.
6. The total of new customers is decreasing each year. 
7. The percentage of retention customers is 77.26%. It means 77.29% of customers in 2009 made transactions again in 2010.
