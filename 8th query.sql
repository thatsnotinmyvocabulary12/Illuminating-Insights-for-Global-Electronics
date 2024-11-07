USE global_electronics;

with delivery AS (
    SELECT 
        product.`Product Name`,
        product.`Unit Cost USD`,
        product.`Unit Price USD`,
        product.`ProductKey`,
        product.`Category`,
        product.`Subcategory`,
        sales.`Order Date`,
        sales.`Quantity`,
        sales.`Currency Code`,
        ABS(product.`Unit Cost USD` - product.`Unit Price USD`) * sales.`Quantity` AS profit
    FROM 
        sales
    JOIN 
        product ON product.`ProductKey` = sales.`ProductKey`
), 
final AS (
    SELECT
        delivery.`profit`,
        delivery.`Product Name`,
        delivery.`Category`,
        delivery.`Subcategory`,
        delivery.`Order Date`,
        delivery.`Quantity`,
        delivery.`Currency Code`,
        exchangerates.`Date`,
        exchangerates.`Exchange`,
        exchangerates.`Currency`,
        ROUND(delivery.`profit` * exchangerates.`Exchange`, 2) AS total_profit
    FROM 
        delivery
    JOIN 
        exchangerates ON delivery.`Currency Code` = exchangerates.`Currency` 
                        AND delivery.`Order Date` = exchangerates.`Date`
)
select final.`category`,final.`subcategory`,round(sum(final.`total_profit`),2) as net_profit  from final
group by final.`category`,final.`subcategory` ;