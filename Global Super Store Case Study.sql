create database global_super_store;
use global_super_store;

CREATE TABLE orders (
    row_id INT,
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    segment VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    market VARCHAR(50),
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(10,2),
    shipping_cost DECIMAL(10,2),
    order_priority VARCHAR(50)
);

CREATE TABLE customers (
    Customer_ID TEXT,
    Customer_name TEXT,
    Date_of_Birth DATE,
    Martial_status TEXT,
    Date_of_First_Purchase DATE,
    Gender TEXT,
    Yearly_Income INT
);

CREATE TABLE managers(
Manager VARCHAR(40),
Region  VARCHAR(40)
);

CREATE TABLE returns(
Returned TEXT,
Order_ID TEXT,
Market TEXT
);


                                                                  -- Questions
															
-- 1. What is our total revenue generated so far? 
      select round(sum(Sales),2) as total_revenue 
      from Orders;
      
-- 2. What is our total revenue generated so far? 
      select round(sum(Profit),2) as Total_Profit
      from Orders;
      
-- 3. How many orders have we successfully processed?
      select count(Order_ID) as Total_Orders
      from Orders;
	
-- 4. How many consumers have we served?
      select count(distinct Customer_ID) as Total_Customer
      from Orders;
      
-- 4.  How profitable have we been over the years?
       select year(Order_Date) as year,round(sum(Profit),2) as Profit
       from Orders
       group by year(Order_Date)
       order by year(Order_Date);

-- 5. How do our sales and profits fluctuate month by month?
      select monthname(Order_Date) as month,round(sum(Sales),2) as Sales, round(sum(Profit),2) as Sales
      from Orders
      group by monthname(Order_Date)
      order by 
              case
                  when lower(month) = 'january' then 1
				  when lower(month) = 'february' then 2
                  when lower(month) = 'march' then 3
                  when lower(month) = 'april' then 4
                  when lower(month) = 'may' then 5
                  when lower(month) = 'june' then 6
                  when lower(month) = 'july' then 7
				  when lower(month) = 'august' then 8
                  when lower(month) = 'september' then 9
                  when lower(month) = 'october' then 10
                  when lower(month) = 'november' then 11
                  when lower(month) = 'december' then 12
               end;

-- 6. They need to know Which markets are generating the most sales ?
      select Market, round(sum(Sales),2) as Sales
      from Orders
      group by Market
      order by Sales desc
      limit 1;

-- 7.  For that they need to know their overall sales for each quarter ?
       select
             case
                  when lower(monthname(order_date)) in ('january', 'february', 'march') then 'quarter-1'
				  when lower(monthname(order_date)) in ('april', 'may', 'june') then 'quarter-2'
                  when lower(monthname(order_date)) in ('july', 'august', 'september') then 'quarter-3'
                  when lower(monthname(order_date)) in ('october', 'november', 'december') then 'quarter-4'
			 end as Quaters,
             round(sum(Sales),2) as Sales
		from Orders
        group by 
                case
                  when lower(monthname(order_date)) in ('january', 'february', 'march') then 'quarter-1'
				  when lower(monthname(order_date)) in ('april', 'may', 'june') then 'quarter-2'
                  when lower(monthname(order_date)) in ('july', 'august', 'september') then 'quarter-3'
                  when lower(monthname(order_date)) in ('october', 'november', 'december') then 'quarter-4'
			 end
		 order by Quaters;
         
-- 8. Develop a visual that clearly depicts the sum of sales top 5 different regions.
	  select Region,round(sum(sales),2) as Sales
      from Orders
      group by Region
      order by Sales desc
      limit 5;
      
-- 9. Orders will be classified as delayed if the shipping date exceeds the order date by more than two days.
	  select Status,round(count(*)*100.0/(select count(order_Id) from Orders),2) as percent
	  from (select Order_ID,
            case
                when datediff(ship_date,order_date)>2 then 'Delay'
                else 'Ontime'
                end Status
			from Orders) as t
	  group by Status;
	
-- 10. the average sales volumes on weekends versus weekdays ?
       select Day,round(avg(Sales),2) as Avg_Sales 
       from (select Order_ID,sales,
					  case 
                          when dayname(Order_date) in ('Saturday','Sunday') then 'Weekend'
                          else 'Weekday'
                          end as Day
			 from Orders) as t
	   group by Day;
       
-- 11. The client requests an analysis of the count of high-value customers segmented by region. High-value  orders are defined as those who have made a purchase exceeding $1,500 with a profit percentage of at least 25% for that specific order.Client also wants to know out of total orders of that region how much population is high value customers. 
	   select Region, Customer_Name 
       from (select o.Region,c.Customer_Name,sum(o.Sales) as Sale,sum(o.Profit) as Profit, sum(o.Profit)*100.0/(sum(sum(o.Profit)) over(partition by o.Region)) as Profit_Percent
       from Orders as o
       join
       Customer as c
       on o.Customer_ID=c.Customer_ID
       group by o.Region,c.Customer_Name
       order by o.Region) as t
       where sale>=1500;
       
       select o.Region,c.Customer_Name
       from Orders as o
       join
       Customer as c
       on o.Customer_ID=c.Customer_ID
       where o.Sales>=1500
       and (o.profit*100/o.sales)>=25
       group by o.Region,c.Customer_Name;
       
-- 12. The client seeks an analysis of the average order value per customer. Furthermore, they request an identification of the top 15 customers based on the highest total order values.
       select c.Customer_Name,round((sum(o.Sales)/count(distinct o.Order_ID)),2) as Avg_Order_Value
       from Orders as o
       join
       Customer as c
       on o.Customer_ID=c.Customer_ID
       group by c.Customer_Name
       order by Avg_Order_Value desc
       limit 15;
       
-- 13. get countries which fall between 11 and 19 on basis of sales ?
       with t as (select Country,round(sum(Sales),2) as Sales,dense_rank() over(order by sum(Sales) desc) as rn
       from Orders
       group by Country)
       
       select * from t
       where rn between 11 and 19;
 
       select Country,sum(Sales)
       from Orders
       group by Country
       order by sum(Sales) desc
       limit 8
       offset 11;
       
-- 14. the cumulative sales sum for each year.
       with t as (select year(Order_date) as year,round(sum(Sales),2) as Sales
       from Orders 
       group by year(Order_date)
       order by year)
       
       select year,sum(Sales) over(rows between unbounded preceding and current row) as cummulative_Sales
       from t;

-- 15. top 2 selling product name in each country
       select Country, Product_Name
       from (select Country,Product_Name,rank() over(partition by Country order by sum(Sales) desc) as rn
             from Orders
             group by Country,Product_Name) as t
	   where rn<=2;
       
-- 16. Top 10 product which contribute most in overall profit ?
       select distinct Product_Name,sum(Profit)*100/(select sum(profit) from Orders) as profit_percent
       from Orders
       group by Product_Name
       order by profit_percent desc
       limit 10;
       
-- 17. Each year top product category
       select year, Category
       from (select year(Order_date) as year,Category, sum(Sales) as Sale,rank() over(partition by year(Order_date) order by sum(Sales) desc) as rn
             from orders
             group by Year(Order_date),Category
             order by year) as t
	   where rn=1;
       
-- 18. For each year, identify the top 3 managers annually based on the total sales they generated
       with t as (select year(Order_date) as year,Manager, rank() over(partition by year(Order_date) order by sum(Sales) desc) as rn
       from Orders as o
       join
       Managers as m
       on o.Region=m.Region
       group by year(Order_date),Manager)
       
       select year,manager
       from t
       where rn<=3;
	
-- 19. Assess how much the sales value of the top-ranked country deviates from the sales values of other countries within the top 10.
       select Country,round((select max(Sale1) 
       from (select Country,round(sum(Sales),2) as Sale1
       from orders
       group by Country) as t)-sum(Sales),2) as Sales
       from orders
       group by Country
       order by Sales desc
       limit 10;
       
       with t as (select Country,sum(Sales) as s1
       from Orders
       group by Country)
       
       select Country, round((max(s1) over() -s1),2) as diff_Sales
       from t
       order by diff_sales desc
       limit 10;
       
-- 20 Find the total numbers of orders returned per market, and also analyse the returns for each market on the basis segment.
      select r.Market, o.segment, count(*) as Orders_Returned_Count
      from returns as r
      join
      Orders as o
      on r.Order_ID=o.order_ID
      where Returned='Yes'
      group by r.Market,o.segment
      order by r.Market;
      
-- 21. Client wants to add the salutation before the names of Each customer, if the customer is male add Mr., if the customer is female and unmarried add Miss. Else add Mrs.
       select 
             case 
                 when Gender='M' then concat('Mr. ',customer_name)
                 when Gender='F' and Martial_status='M' then concat('Miss ',customer_name)
                 else concat('Mrs. ',customer_name)
                 end as Customer_name
	   from customer;
                 
-- 22. Show the number of companies, dealing in each category and subcategory, so that client can have an overview of the diversities of the company. 
	   with t as (select Order_ID, substring_index(Product_name,' ',1) as Company_name
	              from orders)
                  
	   select o.category, o.sub_category, count(distinct Company_name) as total_companies
       from orders as o
       join
       t
       on o.Order_ID=t.Order_ID
       group by o.category, o.sub_category
       order by o.category;
	select * from orders where sub_category='Accessories';
-- 23. What is the percentage of quantity sold of routers, keyboards, headsets to total quantity sold in Accessories sub-category.
       with t as (select Sub_Category, Product_Name
                  from orders
                  where sub_category='Accessories'
                  and (Product_Name like '%Keyboard%'
                  or Product_Name like '%Router%'
                  or Product_Name like '%Headset%'))
                  
	  select Sub_Category,
                         case
                            when Product_Name like '%Keyboard%' then 'Keyboard'
                            when Product_Name like '%Router%' then 'Router'
                            when Product_Name like '%Headset%' then 'Headset'
						end as Product_Name,
		     round(((count(*)*100.0)/(select count(*) from t)),2) as percent 
	 from t
     group by 
               case
				  when Product_Name like '%Keyboard%' then 'Keyboard'
				  when Product_Name like '%Router%' then 'Router'
				  when Product_Name like '%Headset%' then 'Headset'
				end;
                                 
-- 24. What is the percentage of iPhone, Samsung, Motorola phones sold to total phones sold.
	  with t as ( select
             case 
				  when Product_Name like '%Motorola%' then 'Motorola'
				  when Product_Name like '%Samsung%' then 'Samsung'
				  when Product_Name like '%iPhone%' then 'iphone'
                  end as Phones
	  from orders)
      
      select Phones, round(((count(*)*100.0)/(select count(*) from t where Phones is not null)),2) as percent
      from t
      where Phones is not null
      group by Phones;
       












