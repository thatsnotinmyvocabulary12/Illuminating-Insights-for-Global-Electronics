WITH quantity AS(select product.`Product Name`,
	   sales.`Quantity`,
       product.`Category`
       
from sales join product on product.`Productkey`=sales.`ProductKey`)
select quantity.`Product Name` ,
	   quantity.`Category`, 
	   SUM(quantity.`Quantity`) AS overall_quantity 
FROM quantity
GROUP BY quantity.`Product Name`, quantity.`Category`
ORDER BY overall_quantity DESC
LIMIT 50;

