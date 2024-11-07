
WITH quantity AS (
    SELECT 
        product.`Product Name`,
        sales.`Quantity`,
        product.`Category`,
        product.`Unit Cost USD`,
        product.`Unit Price USD`,
        (product.`Unit Price USD` - product.`Unit Cost USD`) * sales.`Quantity` AS profit, 
        sales.`Order Date`,
        sales.`CustomerKey`,
        sales.`Currency Code`
    FROM sales
    JOIN product ON sales.`ProductKey` = product.`ProductKey`
),
final AS (
    SELECT 
		quantity.`profit`,
        quantity.`Currency Code`,  
        quantity.`Product Name`,
        quantity.`Quantity`,
        quantity.`Category`,
        quantity.`Order Date`,
        customer.`Name`,
        customer.`CustomerKey`,
        customer.`Birthday`,
        TIMESTAMPDIFF(YEAR, customer.`Birthday`, quantity.`Order Date`) AS age
    FROM quantity 
    JOIN customer ON customer.`CustomerKey` = quantity.`CustomerKey`
),
age_ranges AS (
    SELECT 
        final.`profit`,
        final.`Order Date`,
        final.`Currency Code`,
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
),
final2 AS (
    SELECT 
        age_ranges.`Category`, 
        age_ranges.`age_range`,
		round(sum(age_ranges.`profit`*exchangerates.`Exchange`),2) as total_profit,
        SUM(age_ranges.`Quantity`) AS Totalquantity
    FROM age_ranges 
    JOIN exchangerates ON exchangerates.`Date` = age_ranges.`Order Date` 
        AND exchangerates.`Currency` = age_ranges.`Currency Code`
    GROUP BY 
        age_ranges.`Category`, 
        age_ranges.`age_range`
	 )
SELECT * FROM final2
order by age_range asc;

 
