-- Dataset Overview
-- Q1: How many total opportunities are in the dataset?
SELECT COUNT (opportunity_id)
FROM dbo.sales_pipeline;

-- Q2: What time range does the data cover?
SELECT
	MIN(LEAST(engage_date, close_date)) earliest_date,
	MAX(GREATEST(engage_date, close_date)) latest_date
FROM dbo.sales_pipeline;

-- Q3: How many accounts, products, sales agents and teams are in the dataset?
SELECT
	COUNT(DISTINCT a.account) account_count,
	COUNT(DISTINCT p.product) product_count,
	COUNT(DISTINCT st.sales_agent) agent_count,
	COUNT(DISTINCT st.regional_office) team_count
FROM dbo.accounts a
INNER JOIN dbo.sales_pipeline sp
	ON a.account = sp.account
INNER JOIN dbo.products p
	ON sp.product = p.product
INNER JOIN dbo.sales_teams st
	ON st.sales_agent = sp.sales_agent;

-- Pipeline Snapshot
-- Q4: How many active opportunities are in the pipeline?
SELECT COUNT (opportunity_id)
FROM dbo.sales_pipeline
WHERE deal_stage NOT IN ('Won', 'Lost');

-- Q5: How many opportunities are in each deal stage?
SELECT
	deal_stage,
	COUNT (opportunity_id) opportunity_count,
	CAST(ROUND(100.0 * COUNT(opportunity_id) / SUM(COUNT(opportunity_id)) OVER (), 2) 
		AS DECIMAL(5,1)) percentage_of_total
FROM dbo.sales_pipeline
GROUP BY deal_stage;

-- Q6: What is the total potential revenue by deal stage?
SELECT
	sp.deal_stage,
	SUM(p.sales_price) potential_revenue
FROM dbo.sales_pipeline sp
INNER JOIN dbo.products p
	ON sp.product = p.product
WHERE sp.deal_stage <> 'Won'
GROUP BY sp.deal_stage;

-- Sales Agent Performance
-- Q7: Which sales agents have the most active opportunities?
SELECT
	sales_agent,
	COUNT(opportunity_id) active_opportunity_count
FROM dbo.sales_pipeline
WHERE deal_stage IN ('Engaging', 'Prospecting')
GROUP BY sales_agent
ORDER BY active_opportunity_count DESC;

-- Q8: What is the win rate for each sales agent?
SELECT
	sales_agent,
	ROUND(CAST(COUNT(CASE WHEN deal_stage = 'Won' THEN 1 END) AS FLOAT) / 
		SUM(CASE WHEN deal_stage IN ('Won', 'Lost') THEN 1 ELSE 0 END) * 100, 1) win_rate
FROM dbo.sales_pipeline
GROUP BY sales_agent
ORDER BY win_rate DESC;

-- Q9: Which sales agents bring in the most revenue?
SELECT
	sales_agent,
	SUM(close_value) total_revenue
FROM dbo.sales_pipeline
GROUP BY sales_agent
ORDER BY total_revenue DESC;

-- Manager and Team Performance
/* Q10: What is the average deal value (closed value for won and potential value for active deals)
per regional office and per manager? */
SELECT 
  st.regional_office,
  AVG(CASE WHEN sp.deal_stage = 'Won' THEN sp.close_value ELSE p.sales_price END) avg_deal_value
FROM dbo.sales_pipeline sp
INNER JOIN dbo.sales_teams st
  ON sp.sales_agent = st.sales_agent
INNER JOIN dbo.products p
  ON sp.product = p.product
WHERE sp.deal_stage IN ('Won', 'Engaging', 'Prospecting')
GROUP BY st.regional_office
ORDER BY avg_deal_value DESC;

SELECT 
  st.regional_office,
  st.manager,
  AVG(CASE WHEN sp.deal_stage = 'Won' THEN sp.close_value ELSE p.sales_price END) avg_deal_value
FROM dbo.sales_pipeline sp
INNER JOIN dbo.sales_teams st
  ON sp.sales_agent = st.sales_agent
INNER JOIN dbo.products p
  ON sp.product = p.product
WHERE sp.deal_stage IN ('Won', 'Engaging', 'Prospecting')
GROUP BY st.manager, st.regional_office
ORDER BY avg_deal_value DESC;

-- Q11: Who are the top-performing managers in each region?
SELECT
	st.manager,
	COUNT(DISTINCT sp.sales_agent) agent_count,
	SUM(CASE WHEN sp.deal_stage = 'Won' THEN 1 ELSE 0 END) deals_won,
	SUM(CASE WHEN sp.deal_stage IN ('Won', 'Lost') THEN 1 ELSE 0 END) AS total_deals,
	ROUND(CAST(COUNT(CASE WHEN deal_stage = 'Won' THEN 1 ELSE NULL END) AS FLOAT) / 
		SUM(CASE WHEN deal_stage IN ('Won', 'Lost') THEN 1 ELSE 0 END) * 100, 1) win_rate,
	SUM(sp.close_value) AS total_revenue
FROM dbo.sales_pipeline sp
INNER JOIN dbo.sales_teams st
	ON sp.sales_agent = st.sales_agent
GROUP BY st.manager
ORDER BY total_revenue DESC;

-- Product Performance
-- Q12: Which products brought in the highest total deal value?
SELECT
	product,
	SUM(close_value) total_deal_value
FROM dbo.sales_pipeline
WHERE deal_stage = 'Won'
GROUP BY product
ORDER BY total_deal_value DESC;

-- Q13: Which products perform best for each sector?
WITH sector_totals AS
	(SELECT 
		a.sector industry,
		sp.product product,
		SUM(sp.close_value) total_value
	FROM dbo.sales_pipeline sp
	INNER JOIN dbo.accounts a
		ON sp.account = a.account
	GROUP BY a.sector, sp.product),
	ranked_products AS
	(SELECT
		*,
		ROW_NUMBER() OVER (PARTITION BY industry ORDER BY total_value DESC) AS product_rank
	FROM sector_totals)
SELECT
	product_rank,
	industry,
	product,
	total_value
FROM ranked_products;

-- Q14: How many units of each product were sold?
SELECT
	product,
	COUNT(product) units
FROM dbo.sales_pipeline
GROUP BY product
ORDER BY units DESC;

-- Client Insights
-- Q15: Which accounts have the largest total won deal value?
SELECT
	account,
	SUM(close_value) total_won_deal_value,
	SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) won_deals
FROM dbo.sales_pipeline
GROUP BY account
ORDER BY total_won_deal_value DESC;

-- Q16: With which sectors do we have the highest win rates?
SELECT
	a.sector industry,
	ROUND(CAST(COUNT(CASE WHEN deal_stage = 'Won' THEN 1 ELSE NULL END) AS FLOAT) / 
		SUM(CASE WHEN deal_stage IN ('Won', 'Lost') THEN 1 ELSE 0 END) * 100, 1) win_rate
FROM dbo.sales_pipeline sp
INNER JOIN dbo.accounts a
	ON sp.account = a.account
GROUP BY a.sector
ORDER BY win_rate DESC;

-- Sales Cycle Length
-- Q17: What is the average number of days from opportunity created to close?
SELECT 
	AVG(DATEDIFF(day,engage_date,close_date)) avg_pipeline_duration
FROM dbo.sales_pipeline
WHERE close_date IS NOT NULL;

-- Q18: What is the frequency of days spent in the pipeline?
SELECT
	DATEDIFF(day,engage_date,close_date) days_in_pipeline,
	COUNT(*) opportunity_count
FROM dbo.sales_pipeline
WHERE close_date IS NOT NULL
GROUP BY DATEDIFF(day,engage_date,close_date)
ORDER BY days_in_pipeline;

-- Revenue Trends
-- Q19: Revenue Per Month and Running Total
SELECT
	FORMAT(EOMONTH(close_date), 'yyyy-MM') AS month,
	SUM(close_value) revenue,
	SUM(SUM(close_value)) OVER (ORDER BY EOMONTH(close_date)) AS running_total
FROM dbo.sales_pipeline
WHERE close_date IS NOT NULL
GROUP BY EOMONTH(close_date);

-- Q20: Month-over-Month (MoM) Revenue Change
WITH monthly_revenue AS
	(SELECT
	FORMAT(close_date, 'yyyy-MM') month,
	SUM(close_value) revenue
	FROM dbo.sales_pipeline
	WHERE close_date IS NOT NULL
	GROUP BY FORMAT(close_date, 'yyyy-MM'))
SELECT
	month,
	revenue current_month_revenue,
	LAG(revenue) OVER (ORDER BY month) previous_month_revenue,
	100 * (revenue - LAG(revenue) OVER (ORDER BY month)) / LAG(revenue) OVER (ORDER BY month) as change
FROM monthly_revenue;
