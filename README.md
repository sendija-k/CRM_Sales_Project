# CRM Sales Opportunities Project (SQL and Power BI)
## Introduction
This project analyzes a CRM sales pipeline dataset provided by [Maven Analytics](https://www.mavenanalytics.io/), designed as a realistic simulation of sales activities in a B2B environment. The dataset includes sales opportunities, products, sales agents, accounts, and team structures. <br/>
The primary goal was to explore the data using Microsoft SQL Server Management Studio to generate meaningful insights on pipeline health, sales performance, revenue trends, and client segmentation, mimicking the typical responsibilities of a junior data analyst supporting a sales team. <br/>
While minimal data cleaning was done before analysis, I used Power BI to create clear and engaging visualizations for select key questions per each thematic section. This approach reflects real-world workflows where initial data querying and KPI calculation happen in SQL, followed by visualization and storytelling in BI tools. <br/>
This project helped me practice and showcase my skills in SQL querying, relational data modeling, window functions, time series analysis, and data storytelling, helping me demonstrate readiness for data analyst roles. <br/>
## Notes about Analysis Process
- I used SQL queries (SELECT, FROM, WHERE, GROUP BY, etc.), joins, window functions (e.g., ROW_NUMBER), CASE statements, and CTEs to extract and analyze the data.
- The SQL queries written to extract data for analysis are available in the all_queries.sql file.
- The interactive Power BI reports are available in the full_report.pbix file.
- There was a mismatch between product names in the sales_pipeline and products tables, which caused inaccurate join results and inconsistent counts, for example, in the number of lost deals. I resolved the issue by using an UPDATE query to standardize the product names, ensuring consistency across both tables.
- Before visualization, data was cleaned up in Power BI by fixing capitalisation and spelling errors and setting correct data types for columns.
- sales_pipeline table did not include quantities, so it was assumed that one deal only included a single unit purchased.
## Tables & Fields
- sales_pipeline - Records of individual sales opportunities and their outcomes
  - opportunity_id – Unique identifier for each sales opportunity
  - sales_agent – Agent handling the opportunity
  - product – Product involved in the opportunity
  - account – Client account associated with the opportunity
  - deal_stage – Current or final stage
  - engage_date – Date the opportunity began
  - close_date – Date the opportunity was closed (won or lost)
  - close_value – Final deal value (if won)
- accounts – Details about client companies
  - account – Name of the client
  - sector – Industry sector the client belongs in
  - year_established – Year the company was founded
  - revenue - Client’s estimated revenue
  - employees – Number of employees
  - office_location – Headquarters or main office location
  - subsidiary_of – Parent company, if any
- products – Information about available products
  - product – Name of the product
  - series – Product line
  - sales_price – Standard selling price per unit
- sales_teams - Sales agent assignments and regions
  - sales_agent – Name of the sales agent
  - manager – Agent’s direct manager
  - regional_office – Region/team the agent belongs in
## Dataset Overview
- The dataset contains 8,800 sales opportunities.
- The time range covered spans 14 months, from October 20, 2016, to December 31, 2017.
- It includes 85 client accounts, 6 products, 30 sales agents, and 3 regional teams.
## Pipeline Snapshot
- There are over 2,089 active opportunities currently in the pipeline, spread across the Engaging and Prospecting stages.
- Of all opportunities:
  - 4,2K (48.2%) are Won
  - 2,5K (28.1%) are Lost
  - 1,6K (18.1%) are Engaging
  - 0.5K (5.7%) are Prospecting
- That means that 70% of all opportunities have already been resolved (either won or lost), while 24% remain active.
- The total revenue (close value from the Won deals) was $10,01M.
- The potential revenue is:
  - $3,9M for Engaging deals
  - $1,1M for Prospecting deals
  - $5,9M is the estimated lost value from Lost deals.
- The estimated lost value is more than half of the total close deal value. This could indicate either a high rejection rate or poor lead qualification.
- However, the potential revenue is almost half the closed deal revenue. If conversion rates improve even slightly, upcoming revenue could rival past success.
## Sales Agent Performance
- 27 out of 30 sales agents have at least one active opportunity in the pipeline. The agent with the most active opportunities (194) is Darcel Schlecht.
- Examining sales agents’ win rates (based on Won vs. Lost deals), Hayden Neloms has the highest win rate at 70.4%. She consistently closes deals at a high rate, despite not ranking top in revenue or opportunity volume. This indicates a highly effective sales approach that could be studied and replicated across the team to improve overall performance.
- Although Darcel Schlecht leads in active opportunities, his win rate of 63.1% ranks him 18th. This suggests that his success is driven by volume rather than conversion efficiency - an opportunity for training or support to increase his close rate and maximize ROI on effort.
- Based on total revenue generated, Darcel Schlecht leads with $1,15M, which more than double that of the second-highest performer, Vicki Laflamme ($0,48M).
- Versie Hillebrand appears in both the top five for win rates (66.7%) and active opportunities (97), showing a good mix of efficiency and volume. With continued support and opportunity, she could emerge as a future top performer.
## Manager and Team Performance
- There are 6 managers, each responsible for 5 agents.
- The East regional team leads in average deal value with $2,6K (based on close deal values for Won deals and potential values for Engaging and Prospecting deals). The West team follows closely with an average deal value of $2,5K, and the Central team lags behind significantly with $2,1K.
- Melvin Marxen and Summer Sewald lead in volume of closed deals and total revenue yet rank only 3rd and 4th in average deal value. This suggests they manage high-activity teams but deal in smaller-value transactions compared to managers like Rocco Neubert and Celia Rouche.
- Rocco Neubert’s team has the highest average deal value ($2,8K) while maintaining strong total revenue and relatively fewer lost deals compared to peers. His team is targeting or handling higher-value opportunities more effectively.
- Dustin Brinkmann’s team has the lowest average deal value ($1,47K) and ranks lowest in total revenue, despite having mid-level deal volume. This may signal a mismatch between effort and return, possibly due to inefficient targeting or weak lead qualification.
- Despite being second in average deal value ($2,76K), Celia Rouche’s total revenue and win volume are only mid-tier. Her team may not be handling enough opportunities and improving pipeline volume could significantly boost her revenue.
## Product Performance
- Regarding product revenue, GTX Pro leads with $3,5M, followed by GTX Plus Pro at $2,6M. The product with the lowest total value is MG Special, generating only $43,8K.
- For every sector, GTX Pro is the best-performing product in terms of revenue. The second-best product for most sectors is GTX Plus Pro, except in Employment and Entertainment, where MG Advanced ranks second.
- The product with the most units sold is GTX Basic with 1866 units, followed by MG Special with 1651 and GTX Pro with 1480.
- GTX Pro has the best balance of volume and value. It’s leading in total revenue and sold widely across sectors, seeming to be an ideal flagship product.
- GTX Plus Basic and GTX Basic are high in volume, low in value. GTX Basic sold the most units but has the second-lowest total revenue.
- Despite selling more than MG Advanced and GTX Plus Pro, MG Special generated the lowest revenue by far due to low base price. 
## Client Insights
- The client accounts with the highest closed deal value are Kan-code ($341K over 115 deals), Konex ($269K over 108 deals), and Condax ($206K over 105 deals). The revenue from the top 5 accounts (Kan-code, Konex, Condax, Cheers, Hottechi) is over $1,2M, which is over 12% of the total revenue.
- High value doesn’t always equal high volume as companies like Cheers are closing fewer but higher value deals (57 deals for $198K).
- There is a big number of mid-tier clients that fall between $100K–$150K in total value with 45–70 deals.
- The client sectors with the highest win rates are Marketing and Entertainment, while the lowest win rate is found in Finance.
- However, the win rates are relatively close across sectors, suggesting no strong correlation between sector type and deal outcomes. This could suggest that the sales approach is not tailored by sector, or that buyer behavior is consistent across sectors - worth exploring further.
## Sales Cycle Length
- On average, opportunities spend 47 days in the pipeline before closing or being lost.
- Over 2,000 opportunities were closed in under 10 days, and most deals are completed under 50 days.
- Sales cycles vary widely, from as short as 1 day to as long as 138 days.
## Revenue Trends
- To analyze revenue trends, monthly closed deal values were aggregated. The earliest month with recorded revenue is March 2017, and the latest is December 2017.
- Monthly revenue fluctuated throughout 2017, with the highest revenue recorded in June at $1,3M and the lowest in July at $0,7M.
- Revenue shows strong rebounds after lower months, such as April and July, indicating possible seasonality or cyclical sales patterns.
- Month-over-month changes highlight this volatility:
  - The largest decline occurred in July (-47%), with other notable drops in April (-36%) and October (-40%).
  - Strong recoveries followed, including a 50% increase in August and 42% growth in May.
- These patterns suggest seasonality and could inform future campaign planning and forecasting.
- Overall, despite fluctuations, the year ended positively with steady growth in December ($1,1M), marking a 20% increase from November.
## Conclusions
- This overview analyzed 8,800 sales opportunities across 30 agents, 6 products, 85 clients, and 10 sectors over 14 months. Despite being a high-level analysis, it revealed clear patterns in agent performance, product success, industry trends, and sales cycle dynamics.
- Some key insights:
  - Top Agent: Darcel Schlecht leads in revenue and volume but ranks 18th in win rate. Hayden Neloms has the highest win rate (70.4%).
  - Top Product: GTX Pro dominates across all industries in both revenue and popularity.
  - Top Clients: A small number of accounts (e.g., Kan-code) drive a large portion of revenue.
  - Best Industry Sectors: Marketing and Entertainment have the highest win rates (~65%); Finance is the lowest at 61%.
  - Sales Cycle: Most deals close within 50 days; a large portion in just 10 days.
  - Revenue Trends: Monthly revenue is volatile but ends with steady growth, hinting at seasonality.
- Recommendations:
  - Prioritize top-performing clients and industries.
  - Reassess low-performing products (e.g., MG Special) and long sales cycles.
  - Support high volume and high revenue sales agents to boost win rates.
  - Encourage managers to focus on deal quality, not just volume, to improve overall pipeline health.
- Overall, this project was a valuable opportunity to apply and develop skills in SQL, Power BI, data visualization, and business analysis to create an overview look at a company’s sales activities. For a deeper dive, it would be possible to explore deal velocity (Do some products take longer to close? Why?), agent efficiency (Revenue per opportunity, per day in pipeline, etc.), or loss analysis (Why are deals lost? Are there patterns in product, region, or client type?). The report could also be more comprehensive and in depth if there was more data available about leads, quotas, as well as sales data over a longer period of time.
