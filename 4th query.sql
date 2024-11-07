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
       ),

age_ranges AS (
    SELECT 
        final.`Product Name`, 
        final.`Category`,
        final.`Quantity`,
        CASE 
            WHEN final.`age` BETWEEN 0 AND 10 THEN '0-10'
            WHEN final.`age` BETWEEN 11 AND 20 THEN '11-20'
            WHEN final.`age` BETWEEN 21 AND 30 THEN '21-30'
            WHEN final.`age` BETWEEN 31 AND 40 THEN '31-40'
            WHEN final.`age` BETWEEN 41 AND 50 THEN '41-50'
            WHEN final.`age` BETWEEN 51 AND 60 THEN '51-60'
            ELSE '60+' 
        END AS age_range
    FROM final
)
SELECT 
    `Product Name`, 
    `Category`,
    age_range, 
    sum(`Quantity`) AS purchase_count
FROM age_ranges
GROUP BY `Product Name`,`Category`, age_range
ORDER BY age_range ASC;