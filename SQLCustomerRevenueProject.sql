
--creating table to assign financial years to months--

USE vm_3;
SELECT DISTINCT(months),
			CASE 
				WHEN months BETWEEN '2020-11-01' AND '2021-10-01' THEN 'FY21'
				WHEN months BETWEEN '2021-11-01' AND '2022-10-01' THEN 'FY22'
				WHEN months BETWEEN '2022-11-01' AND '2023-10-01' THEN 'FY23'
				WHEN months BETWEEN '2023-11-01' AND '2024-10-01' THEN 'FY24'
			END AS FY
INTO fy_calc FROM customer_revenue;

use vm_3;

--Customers by total revenue over historical period--

SELECT cd.customer_name,
SUM(cr.revenue) AS total_revenue FROM customer_revenue AS cr
LEFT JOIN customer_data AS cd ON cr.customer_id = cd.customer_id
GROUP BY customer_name
ORDER BY total_revenue DESC;

--Yearly Revenue by Industry--
USE vm_3;
SELECT industry,
    [FY21] AS FY21,
    [FY22] AS FY22,
    [FY23] AS FY23,
	[FY24] AS FY24
FROM
(  SELECT ci.industry, fc.FY, cr.revenue FROM customer_revenue AS cr
   INNER JOIN customer_industries AS ci ON cr.customer_id = ci.customer_id
   INNER JOIN fy_calc AS fc ON fc.months = cr.months
) p
PIVOT
(   SUM (revenue)
    FOR  FY IN ([FY21], [FY22], [FY23], [FY24])
) AS yearly_revenue_by_industry
ORDER BY FY24 DESC; 

--Yearly Revenue by Customer--
USE vm_3;
SELECT customer_name,
    [FY21] AS FY21,
    [FY22] AS FY22,
    [FY23] AS FY23,
	[FY24] AS FY24
FROM
(  SELECT cd.customer_name, fc.FY, cr.revenue FROM customer_revenue AS cr
   INNER JOIN customer_data AS cd ON cr.customer_id = cd.customer_id
   INNER JOIN fy_calc AS fc ON fc.months = cr.months
) p
PIVOT
(   SUM (revenue)
    FOR  FY IN ([FY21], [FY22], [FY23], [FY24])
) AS yearly_revenue_by_customer
ORDER BY FY24 DESC; 


-- Revenue per month --
USE vm_3;
SELECT months, SUM(revenue) AS monthly_revenue FROM customer_revenue
GROUP BY months
ORDER BY months asc;

-- Revenue by country and continent --
USE vm_3;
WITH country_rev AS ( 
				SELECT cd.customer_continent, cd.customer_country, cr.revenue FROM customer_revenue as cr
				LEFT JOIN customer_data AS cd on cr.customer_id = cd.customer_id
				    )
SELECT customer_continent, SUM(revenue) AS total_rev FROM country_rev
GROUP BY customer_continent
ORDER BY customer_continent ASC, total_rev DESC;

-- Number of customers of for varying tenure sizes--

WITH customer_tenures AS ( 
	SELECT cd.customer_id, cd.customer_country, cr.months, cr.revenue,
	CASE 
	WHEN revenue >0 THEN 1
	ELSE 0
	END AS rev_check
	FROM customer_revenue as cr
	LEFT JOIN customer_data AS cd  on cr.customer_id = cd.customer_id
	),

tenure_sum AS (
	SELECT customer_id, SUM(rev_check) as tenure
	FROM customer_tenures
	GROUP BY customer_id
	),

tenure_case AS (
	SELECT customer_id,
		CASE
			WHEN tenure >=48 THEN '4+ years'
			WHEN tenure >=36 THEN '3+ years'
			WHEN tenure >=24 THEN '2+ years'
			WHEN tenure >=12 THEN '1+ years'
			WHEN tenure <12 THEN '< 1 year'		
		END AS tenure_size
	FROM tenure_sum
	)

SELECT tenure_size, COUNT(customer_id) as customer_count FROM tenure_case
GROUP BY tenure_size
ORDER BY customer_count DESC;

-- Customers ranked by revenue generation --

