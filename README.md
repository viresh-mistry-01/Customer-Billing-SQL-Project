# Customer-Billing-SQL-Project

Personal project to test my SQL skills by analysing customer revenue trends across three years of sales data for a telecommunications company

### Overview
- Goal: Join datasets containing revenue and customer descriptions, then analyse data
- Stack: SQL (SQL Server), Github Copilot

### Dataset
- Source: https://www.kaggle.com/datasets/vireshmistry01/sql-customer-revenue-project
- Included: tiny samples only (see `data/`)

### Methods
- Loading data: joins, variables, bulk insert, case
- Analysing data: pivot, aggregates, CTEs, case, group by, joins
- AI: usage of built-in Copilot tool to improve automation and clarity within code

### Results (highlights)
- The majority of customers are long tenured with over 50% having 3+ years of billing
- The largest customers are Levelvault Corp, Omnimind Partners, and Horizonpath Partners and are long tenure customers
- The leading revenue generating industries are Retail, Media, and Food & Beverage. Each industry has experienced steady year-on-year growth.
- The majority of revenue stems from companies based in Africa, Asia and Europe, with less originating from North America, South America and Oceania

### How to Run
1) Download CSVs from source into Downloads folder
2) In File_Loader_, update @user_name and @schema_name as necessary then run it
3) Run SQLCustomerRevenueProject project to view tables and results

### Structure
- `sql/`: code files
- `data/`: data samples

### Challenges
- Formatting data to ensure it was usable for queries
- Realising the benefit of joining tables for each query as opposed to a singular large table that joined all the data
- Complex tables requiring multiple CTEs

### Next
- Further analysis on correlation between tenure and proportion of revenue generated each year
- New/lost customers by tenure and revenue size as well as assessing impact of macroeconomy or business changes 

### License
MIT
