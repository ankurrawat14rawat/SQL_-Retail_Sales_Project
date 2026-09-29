----------- Create Database --------------------

Create Database Project_p1;


--------------- Create Table ------------------
Drop table if exists retail_sales;

Create Table retail_sales (
		transactions_id INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,
		customer_id INT,
		gender VARCHAR(10),
		age INT,
		category VARCHAR(20),
		quantiy INT,
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sale FLOAT
		);


------------------- Changing Column name -----------------------		

Alter Table retail_sales Rename Column quantiy TO quantity;



----------------- Checking Data imported correctly---------------------

Select * from retail_sales
Limit 5;


Select Count(*) total from retail_sales;



---------------------- Filtering Null ---------------------------

Select * from retail_sales
Where 
	transactions_id is null
	OR
	sale_date is null
	OR
	sale_time is null
	OR
	customer_id is null
	OR
	gender is null
	OR
	age is null
	OR
	category is null
	OR
	quantity is null
	OR
	price_per_unit is null
	OR
	cogs is null
	OR
	total_sale is null;
	


-----------------------------Removing Nulls----------------------------------


Delete from retail_sales
Where 
	transactions_id is null
	OR
	sale_date is null
	OR
	sale_time is null
	OR
	customer_id is null
	OR
	gender is null
	OR
	age is null
	OR
	category is null
	OR
	quantity is null
	OR
	price_per_unit is null
	OR
	cogs is null
	OR
	total_sale is null;


---------------Data Exploration ------------------------


-----How many Sales transacation has been done ------

Select Count(*) as Total_transactions from Retail_sales;


----------How many customer we have --------------

Select Count(Distinct customer_id) as Total_customer from Retail_sales;


-------------How many category we have ------------


Select Distinct category from retail_sales;


--------------------- Business Need ---------------

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

Select * from Retail_sales 
	where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022

Select * from Retail_sales
	where category = 'Clothing'
		and To_CHAR(sale_date,'YYYY-MM') = '2022-11'
			and quantity > 3;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

Select Category, Sum(total_sale) total_sales from Retail_sales
	Group by Category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

Select Avg(age) from Retail_sales
	having category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

Select * from Retail_sales where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

Select Category, Gender , Count(transactions_id) as Total_transaction 
	from Retail_sales 
		Group by Category, Gender
			Order by Category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

-------------------------this is the data with year and month -----------------------------

Select 
	Extract(YEAR from sale_date) as year,
	Extract(MONTH from sale_date) as month,
	Avg(total_sale)
from retail_sales Group by year, month Order by year, month;


---------------------------- Extracting best selling month for each year ----------------

With best_month as (Select 
	Extract(YEAR from sale_date) as year,
	Extract(MONTH from sale_date) as month,
	Avg(total_sale) as Avg_sale, Dense_Rank() over(Partition by Extract(YEAR from sale_date) Order by Avg(total_sale) DESC) as rnk
from retail_sales Group by year, month Order by year, month)


Select year,month,Avg_sale,rnk from best_month where rnk = 1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

With top_customer as (Select customer_id, sum(total_sale) as total, Dense_Rank() Over (Order by sum(total_sale) Desc) as rnk
	from Retail_sales 
		Group by customer_id
			Order by total Desc)

Select customer_id, total from top_customer where rnk <=5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

Select Count(Distinct customer_id), category from Retail_sales Group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


Select * from Retail_sales;

with t1 as (Select Extract(Hour from sale_time) as hours,
	Case
		When Extract(Hour from sale_time) < 12 Then 'Morning'
		When Extract(Hour from sale_time) >= 12 and Extract(Hour from sale_time) <17 Then 'Afternoon'
		Else 'Evening'
		End as Shifts
	from Retail_sales)


Select shifts,Count(hours) from t1 Group by shifts;





