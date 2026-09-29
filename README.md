# Customer-Billing-SQL-Project

Personal project to test my SQL skills by analysing customer revenue trends across three years of sales data for a telecommunications company

### Overview
- Goal: Join datasets containing revenue and customer descriptions, then analyse data
- Stack: SQL (SQL Server)

### Dataset
- Source: https://www.kaggle.com/datasets/vireshmistry01/sql-customer-revenue-project
- Included: tiny samples only (see `data/`)

### Methods
- Loading data: joins, variables, bulk insert, case
- Analysing data: pivot, aggregates, window functions

### Results (highlights)
- The majority of customers are long tenured with over 50% having 3+ years of billing
- The largest customers are Levelvault Corp, Omnimind Partners, and Horizonpath Partners
- The leading revenue generating industries are Retail, Media, and Food & Beverage. Each industry has experienced steady year-on-year growth
- The majority of revenue stems from companies based in Africa, Asia and Europe, with less originating from North America, South America and Oceania

### How to Run
1) Download CSVs from source into Downloads folder
2) In File_Loader_, update @user_name and @schema_name as necessary then run it
3) Run SQLCustomerRevenueProject project to view tables and results

### Structure
- `sql/`: queries
- `data/`: data samples

### 
- 

### License
MIT
