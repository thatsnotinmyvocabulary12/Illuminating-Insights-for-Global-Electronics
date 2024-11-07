use global_electronics;
WITH delivery AS (
    SELECT 
        product.`Unit Cost USD`,
        product.`Unit Price USD`,
        product.`ProductKey`,
        product.`Brand`,
        sales.`Order Date`,
        sales.`Quantity`,
        sales.`CustomerKey`,
        sales.`Currency Code`,
        ABS(product.`Unit Cost USD` - product.`Unit Price USD`) * sales.`Quantity` AS profit
    FROM 
        sales
    JOIN 
        product ON product.`ProductKey` = sales.`ProductKey`
), 
final AS (
    SELECT
        delivery.`Brand`,
        delivery.`profit`,
        delivery.`Order Date`,
        delivery.`Quantity`,
        delivery.`Currency Code`,
        delivery.`CustomerKey`,
        exchangerates.`Date`,
        exchangerates.`Exchange`,
        exchangerates.`Currency`,
        ROUND(delivery.`profit` * exchangerates.`Exchange`, 2) AS total_profit
    FROM 
        delivery
    JOIN 
        exchangerates ON delivery.`Currency Code` = exchangerates.`Currency` 
                        AND delivery.`Order Date` = exchangerates.`Date`
),
final2 AS (
    SELECT 
        final.`Brand`,
        final.`Currency`,
        ROUND(SUM(`total_profit`), 2) AS profit,
        customer.`Country`
    FROM 
        final 
    JOIN 
        customer ON final.`CustomerKey` = customer.`CustomerKey`
    GROUP BY 
        final.`Brand`, final.`Currency`, customer.`Country`
)
SELECT * FROM final2;