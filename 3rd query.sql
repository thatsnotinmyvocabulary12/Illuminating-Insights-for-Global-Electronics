use global_electronics;
WITH quantity AS (
    SELECT product.`Product Name`,
           sales.`Quantity`,
           product.`Category`,
		   sales.`Order Date`,
           sales.`CustomerKey`
    FROM sales
    JOIN product ON sales.`Productkey` = product.`ProductKey`
),
final as(select 
	   quantity.`Product Name`,
       quantity.`Quantity`,
       quantity.`Category`,
       quantity.`Order Date`,
       customer.`Name`,
       customer.`CustomerKey`,
       customer.`Birthday`,
       TIMESTAMPDIFF(YEAR,customer.`Birthday`,quantity.`Order Date`) AS age
       from quantity 
       join customer on customer.`CustomerKey`=quantity.`CustomerKey`
       )
SELECT final.`Category`, final.`age`,
COUNT(final.`Category`) AS category_count
FROM final 
GROUP BY final.`Category`, final.`age` 
ORDER BY final.`age` ASC;
