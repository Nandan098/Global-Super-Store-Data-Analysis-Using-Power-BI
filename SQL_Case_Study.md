### Swiggy Case Study

1.	Create a DATABASE: global_super_store
```sql
    create database global_super_store;
    use global_super_store
```
### TABLES
```sql
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
```
-- ORDERS TABLE

| COLUMN NAME     | DATA TYPE        | REMARKS |
|-----------------|------------------|---------|
| row_id          | INT              | Primary key |
| order_id        | VARCHAR(50)      | Order identifier |
| order_date      | DATE             | Order date |
| ship_date       | DATE             | Shipping date |
| ship_mode       | VARCHAR(50)      | Shipping mode |
| customer_id     | VARCHAR(50)      | FK → customers.customer_id |
| segment         | VARCHAR(50)      | Customer segment |
| city            | VARCHAR(100)     | City |
| state           | VARCHAR(100)     | State |
| country         | VARCHAR(100)     | Country |
| postal_code     | VARCHAR(20)      | Postal code |
| market          | VARCHAR(50)      | Market |
| region          | VARCHAR(50)      | FK → managers.region |
| product_id      | VARCHAR(50)      | Product identifier |
| category        | VARCHAR(50)      | Product category |
| sub_category    | VARCHAR(50)      | Product sub-category |
| product_name    | VARCHAR(255)     | Product name |
| sales           | DECIMAL(10,2)    | Sales amount |
| quantity        | INT              | Quantity |
| discount        | DECIMAL(5,2)     | Discount |
| profit          | DECIMAL(10,2)    | Profit |
| shipping_cost   | DECIMAL(10,2)    | Shipping cost |
| order_priority  | VARCHAR(50)      | Order priority |

```sql
CREATE TABLE customers (
    Customer_ID TEXT,
    Customer_name TEXT,
    Date_of_Birth DATE,
    Martial_status TEXT,
    Date_of_First_Purchase DATE,
    Gender TEXT,
    Yearly_Income INT
);
```

-- CUSTOMERS TABLE
| COLUMN NAME            | DATA TYPE | REMARKS |
|------------------------|----------|---------|
| customer_id            | TEXT     | Primary key |
| customer_name          | TEXT     | Customer name |
| date_of_birth          | DATE     | Date of birth |
| martial_status         | TEXT     | Marital status |
| date_of_first_purchase | DATE     | First purchase date |
| gender                 | TEXT     | Gender |
| yearly_income          | INT      | Annual income |

```sql
CREATE TABLE managers(
Manager VARCHAR(40),
Region  VARCHAR(40)
);
```

-- MANAGERS TABLE
| COLUMN NAME | DATA TYPE  | REMARKS |
|-------------|------------|---------|
| manager     | VARCHAR(40)| Manager name |
| region      | VARCHAR(40)| Primary key |

```sql
CREATE TABLE returns(
Returned TEXT,
Order_ID TEXT,
Market TEXT
);
```

-- RETURNS TABLE
| COLUMN NAME | DATA TYPE | REMARKS |
|-------------|----------|---------|
| returned    | TEXT     | Return status |
| order_id    | TEXT     | FK → orders.order_id |
| market      | TEXT     | Market |

                                                                      -- Questions
											
-- 1. What is the total revenue generated so far by the company?
   ```sql 
      select round(sum(Sales),2) as total_revenue 
      from Orders;
   ```
<img width="186" height="98" alt="1 (2)" src="https://github.com/user-attachments/assets/30c46e92-c854-4922-a104-24cd775a8b75" />

-- 2. What is the total profit generated so far by the company?
  ```sql
      select round(sum(Profit),2) as Total_Profit
      from Orders;
```

<img width="146" height="88" alt="2 (3)" src="https://github.com/user-attachments/assets/f43e65b6-f1aa-4f27-aedb-17b3fe39d4d7" />
	  
-- 3. How many orders have been successfully processed to date?
  ```sql
      select count(Order_ID) as Total_Orders
      from Orders;
  ```
<img width="163" height="88" alt="3 (2)" src="https://github.com/user-attachments/assets/2945a020-070a-4b1f-a977-f4c723fd8830" />
	
-- 4. How many unique customers have been served by the company?
  ```sql
      select count(distinct Customer_ID) as Total_Customer
      from Orders;
  ```

<img width="163" height="92" alt="4 (2)" src="https://github.com/user-attachments/assets/b26407ce-f42a-4d54-91a7-27c27c08d0ea" />

-- 5. How profitable has the company been over the years in terms of annual profit?
  ```sql
       select year(Order_Date) as year,round(sum(Profit),2) as Profit
       from Orders
       group by year(Order_Date)
       order by year(Order_Date);
  ```

<img width="186" height="157" alt="5 (2)" src="https://github.com/user-attachments/assets/5a6b6716-c309-4ca4-90ea-661717c0725f" />

-- 6. How do sales and profits fluctuate on a month-by-month basis?
  ```sql
      select monthname(Order_Date) as month,round(sum(Sales),2) as Sales, round(sum(Profit),2) as Profit
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
  ```

<img width="207" height="90" alt="6 (2)" src="https://github.com/user-attachments/assets/1d5afea2-6410-4a6d-b233-5a2b12435c0f" />


-- 7. Which market is generating the highest total sales? 
  ```sql
      select Market, round(sum(Sales),2) as Sales
      from Orders
      group by Market
      order by Sales desc
      limit 1;
  ```

<img width="319" height="315" alt="7 (2)" src="https://github.com/user-attachments/assets/408eaca1-6386-4113-b7e8-7673e5b81c8c" />


-- 8. What are the overall sales figures for each quarter of the year?
  ```sql
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
   ```

<img width="227" height="161" alt="8 (2)" src="https://github.com/user-attachments/assets/9b32c6b3-985c-471a-8b1b-2926ed4688a7" />

		 
-- 9. Which top five regions contribute the highest total sales?
   ```sql
	    select Region,round(sum(sales),2) as Sales
      from Orders
      group by Region
      order by Sales desc
      limit 5;
   ```

<img width="263" height="173" alt="9 (2)" src="https://github.com/user-attachments/assets/46dd84c1-b967-43e4-ba69-0a3a8d43cbf7" />
  
-- 10. What percentage of orders were delivered on time versus delayed (where delivery exceeds the order date by more than two days)?
  ```sql
	  select Status,round(count(*)*100.0/(select count(order_Id) from Orders),2) as percent
	  from (select Order_ID,
            case
                when datediff(ship_date,order_date)>2 then 'Delay'
                else 'Ontime'
                end Status
		 from Orders) as t
	   group by Status;
   ```

<img width="175" height="111" alt="10" src="https://github.com/user-attachments/assets/121883ab-f1f0-4fb4-bea8-5f8c532450b9" />

	
-- 11. How do average sales volumes compare between weekends and weekdays? 
   ```sql
       select Day,round(avg(Sales),2) as Avg_Sales 
       from (select Order_ID,sales,
					  case 
                          when dayname(Order_date) in ('Saturday','Sunday') then 'Weekend'
                          else 'Weekday'
                          end as Day
			 from Orders) as t
	     group by Day;
   ```

<img width="217" height="104" alt="11" src="https://github.com/user-attachments/assets/63af9b01-c0c7-4555-864c-66c549abd071" />

       
-- 12. How many high-value customers exist in each region, and what percentage of total regional orders do they represent, where high-value orders exceed $1,500 in sales with at least a 25% profit margin?
 ```sql
       select Region, Customer_Name 
       from (select o.Region,c.Customer_Name,sum(o.Sales) as Sale,sum(o.Profit) as Profit, sum(o.Profit)*100.0/(sum(sum(o.Profit)) over(partition by o.Region)) as Profit_Percent
       from Orders as o
       join
       Customer as c
       on o.Customer_ID=c.Customer_ID
       group by o.Region,c.Customer_Name
       order by o.Region) as t
       where sale>=1500;
```
   ```sql
       select o.Region,c.Customer_Name
       from Orders as o
       join
       Customer as c
       on o.Customer_ID=c.Customer_ID
       where o.Sales>=1500
       and (o.profit*100/o.sales)>=25
       group by o.Region,c.Customer_Name;
   ```
<img width="278" height="451" alt="12" src="https://github.com/user-attachments/assets/b5a6e62f-4b26-4652-ba97-b9e96bf99075" />

	   
-- 13. What is the average order value per customer, and who are the top 15 customers based on the highest average order value?
   ```sql
       select c.Customer_Name,round((sum(o.Sales)/count(distinct o.Order_ID)),2) as Avg_Order_Value
       from Orders as o
       join
       Customer as c
       on o.Customer_ID=c.Customer_ID
       group by c.Customer_Name
       order by Avg_Order_Value desc
       limit 15;
   ```

<img width="324" height="394" alt="13" src="https://github.com/user-attachments/assets/e4df3145-844e-4558-88bc-ab0ac1837971" />
	   
-- 14. Which countries rank between 11th and 19th based on total sales volume?
   ```sql
       with t as (select Country,round(sum(Sales),2) as Sales,dense_rank() over(order by sum(Sales) desc) as rn
       from Orders
       group by Country)
       select * from t
       where rn between 11 and 19;
```
   ```sql
       select Country,sum(Sales)
       from Orders
       group by Country
       order by sum(Sales) desc
       limit 8
       offset 11;
  ```
<img width="324" height="273" alt="14" src="https://github.com/user-attachments/assets/fdd0652e-ec06-4ab4-a791-e740007544e2" />
	   
-- 15. What is the cumulative total sales amount for each year?
   ```sql
       with t as (select year(Order_date) as year,round(sum(Sales),2) as Sales
       from Orders 
       group by year(Order_date)
       order by year)
       select year,sum(Sales) over(rows between unbounded preceding and current row) as cummulative_Sales
       from t;
   ```
<img width="232" height="150" alt="15" src="https://github.com/user-attachments/assets/e5ad77e9-6b5e-4418-a1b9-ecb2e733ba2c" />

-- 16. What are the top two best-selling products in each country?
   ```sql
       select Country, Product_Name
       from (select Country,Product_Name,rank() over(partition by Country order by sum(Sales) desc) as rn
             from Orders
             group by Country,Product_Name) as t
	     where rn<=2;
  ```

<img width="434" height="399" alt="16" src="https://github.com/user-attachments/assets/3fcabaaa-08ab-461a-9ead-de3207a5e063" />
	   
-- 17. Which top ten products contribute the most to overall profit, based on profit percentage?
   ```sql
       select distinct Product_Name,sum(Profit)*100/(select sum(profit) from Orders) as profit_percent
       from Orders
       group by Product_Name
       order by profit_percent desc
       limit 10;
   ```

<img width="470" height="284" alt="17" src="https://github.com/user-attachments/assets/8240f125-7e90-47e6-9e9c-d26b9955b101" />
 
-- 18. Which product category generated the highest sales in each year?
   ```sql
       select year, Category
       from (select year(Order_date) as year,Category, sum(Sales) as Sale,rank() over(partition by year(Order_date) order by sum(Sales) desc) as rn
             from orders
             group by Year(Order_date),Category
             order by year) as t
	     where rn=1;
   ```
<img width="182" height="169" alt="18" src="https://github.com/user-attachments/assets/874dca01-ccef-4fba-9946-602c8c618d54" />
     
-- 19. Who are the top three managers each year based on the total sales they generated?
  ```sql
       with t as (select year(Order_date) as year,Manager, rank() over(partition by year(Order_date) order by sum(Sales) desc) as rn
       from Orders as o
       join
       Managers as m
       on o.Region=m.Region
       group by year(Order_date),Manager)
       select year,manager
       from t
       where rn<=3;
  ```

<img width="209" height="315" alt="19" src="https://github.com/user-attachments/assets/d614652e-619a-4310-80cc-dafb83148e40" />

-- 20. How much does the sales value of the top-ranked country differ from the sales values of other countries within the top ten?
  ```sql
       with t as (select Country,sum(Sales) as s1
       from Orders
       group by Country)
       select Country, round((max(s1) over() -s1),2) as diff_Sales
       from t
       order by diff_sales desc
       limit 10;
  ```

<img width="288" height="255" alt="20" src="https://github.com/user-attachments/assets/82031b30-99e7-4ac0-99cf-be6bfb15c525" />

-- 21 How many orders were returned in each market, and how are these returns distributed across different customer segments?
   ```sql
      select r.Market, o.segment, count(*) as Orders_Returned_Count
      from returns as r
      join
      Orders as o
      on r.Order_ID=o.order_ID
      where Returned='Yes'
      group by r.Market,o.segment
      order by r.Market;
   ```

<img width="409" height="307" alt="21" src="https://github.com/user-attachments/assets/67a419d4-d990-4a01-bcab-7c92ca1996dc" />
	  
-- 22. How can customer names be displayed with appropriate salutations (Mr., Miss, or Mrs.) based on gender and marital status?
  ```sql
       select 
             case 
                 when Gender='M' then concat('Mr. ',customer_name)
                 when Gender='F' and Martial_status='M' then concat('Miss ',customer_name)
                 else concat('Mrs. ',customer_name)
                 end as Customer_name
	     from customer;
   ```

<img width="198" height="397" alt="22" src="https://github.com/user-attachments/assets/37a69465-f95e-4784-86cd-fe3f8faec58a" />
				
-- 23. How many distinct companies operate within each product category and sub-category?
  ```sql
       with t as (select Order_ID, 
                 substring_index(Product_name,' ',1) as Company_name
	              from orders)
       select o.category, o.sub_category, count(distinct Company_name) as total_companies
       from orders as o
       join
       t
       on o.Order_ID=t.Order_ID
       group by o.category, o.sub_category
       order by o.category;
  ```

<img width="378" height="405" alt="23" src="https://github.com/user-attachments/assets/aa097036-8212-47df-b0ed-1742c6b29607" />

-- 24. What percentage of total quantity sold in the Accessories sub-category is contributed by routers, keyboards, and headsets?
  ```sql
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
  ```

<img width="357" height="131" alt="24" src="https://github.com/user-attachments/assets/3f1bddb5-5566-47b4-920f-b33d692a1784" />
						 
-- 25. What is the percentage of iPhone, Samsung, Motorola phones sold to total phones sold.
 ```sql
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
 ```
       
<img width="184" height="129" alt="25" src="https://github.com/user-attachments/assets/8f592ec6-6f9a-470b-9e01-09796cd0e610" />













