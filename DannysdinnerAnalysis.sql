--CASE STUDY QUESTION N°1--
SELECT
	s.customer_id,
	sum(m.price) AS Total_spent
from sales s
JOIN menu m 
		ON s.product_id=m.product_id
GROUP BY customer_id
ORDER BY Total_spent DESC;

--CASE STUDY QUESTION N°2--
SELECT 
	customer_id,
	count(DISTINCT order_date) AS Total_Visits
FROM sales
GROUP BY customer_id
ORDER BY Total_Visits DESC;

--CASE STUDY QUESTION N°3--
WITH FirstProductPurchased AS (
    SELECT 
        customer_id,
        product_id,
        ROW_NUMBER() 
			OVER (PARTITION BY customer_id 
				ORDER BY order_date) 
		AS row_num
    FROM sales
)
SELECT 
    r.customer_id,
    m.product_name AS first_item_purchased
FROM FirstProductPurchased r
JOIN menu m ON r.product_id = m.product_id
WHERE row_num = 1;


--CASE STUDY QUESTION N°4--
SELECT 
	m.product_name AS Most_Purchased_Item,
	count(s.product_id) AS Quantity_Purchased
FROM sales s
LEFT JOIN menu m ON s.product_id=m.product_id
GROUP BY m.product_name
ORDER BY Quantity_Purchased DESC
LIMIT 1;

--CASE STUDY QUESTION N°5--
WITH RankedProductPurchased AS (
    SELECT 
        s.customer_id,
        m.product_name,
        COUNT(s.product_id) AS Quantity_Purchased,
        ROW_NUMBER() OVER 
			(PARTITION BY s.customer_id 
				ORDER BY COUNT(s.product_id) DESC) 
		AS row_num
    FROM sales s
    JOIN menu m ON s.product_id = m.product_id
    GROUP BY 
        s.customer_id,
        m.product_name
)
SELECT 
    customer_id,
    product_name
FROM RankedProductPurchased
WHERE row_num = 1
ORDER BY customer_id;

--CASE STUDY QUESTION N°7--
SELECT 
    s.customer_id,
    COUNT(*) AS total_items_purchased,
    SUM(m.price) AS total_amount_spent
FROM 
    sales s
JOIN 
    menu m ON s.product_id = m.product_id
JOIN 
    members mem ON s.customer_id = mem.customer_id 
		AND s.order_date < mem.join_date
GROUP BY 
    s.customer_id;


--CASE STUDY QUESTION N°8--
SELECT 
	s.customer_id,
	sum(
	CASE
		WHEN s.product_id=1 
			THEN m.price*20
		ELSE m.price*10
	END) AS Total_Points
FROM sales s
	LEFT JOIN menu m ON s.product_id=m.product_id
GROUP BY s.customer_id
ORDER BY Total_Points DESC;

--CASE STUDY QUESTION N°6--
WITH FirstProductPurchased AS (
    SELECT 
        customer_id,
        product_id,
        order_date,
        ROW_NUMBER() 
            OVER (PARTITION BY customer_id 
                  ORDER BY order_date) AS row_num
    FROM sales
)
SELECT 
    r.customer_id,
    m.product_name AS first_item_purchased
FROM FirstProductPurchased r
JOIN menu m ON r.product_id = m.product_id
JOIN members mem ON r.customer_id = mem.customer_id
WHERE r.row_num = 1
  AND r.order_date < mem.join_date;
  
