USE global_electronics;

WITH quantity AS (
    SELECT product.`Product Name`,
           sales.`Quantity`,
           product.`Category`,
           sales.`Order Date`,
           sales.`CustomerKey`
    FROM sales
    JOIN product ON sales.`Productkey` = product.`ProductKey`
),
final AS (
    SELECT 
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
SELECT age_ranges.`Category`, age_ranges.`age_range`,
sum(age_ranges.`Quantity`) AS Totalquantity
FROM age_ranges 
GROUP BY age_ranges.`Category`, age_ranges.`age_range` 
ORDER BY age_ranges.`age_range` ASC;