use global_electronics;
WITH quantity AS (
     SELECT sales.`Quantity`,
			stores.`StoreKey`,
            stores.`Country`,
            stores.`Square Meters`
     FROM sales
     JOIN stores ON sales.`StoreKey`= stores.`StoreKey`
 )
 select sum(quantity.`Quantity`) as totalquantity ,avg(`Square Meters`) as area,quantity.`StoreKey`,quantity.`Country` from quantity
 group by quantity.`Country`,quantity.`StoreKey`
 order by area asc;

