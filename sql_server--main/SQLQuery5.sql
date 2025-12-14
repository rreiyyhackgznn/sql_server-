
create database [Profit DB]

use [profit db]

-- Create a table to store monthly profit data for different products
CREATE  TABLE ProfitData (
    MonthNumber INT,
    MonthName VARCHAR(3),
    Product VARCHAR(50),
    Profit INT
);

-- Insert data into the ProfitData table
INSERT INTO ProfitData (MonthNumber, MonthName, Product, Profit) VALUES
(1, 'Jan', 'Product A', 1000),
(2, 'Feb', 'Product A', 1500),
(3, 'Mar', 'Product A', 1200),
(4, 'Apr', 'Product A', 1700),
(5, 'May', 'Product A', 1300),
(6, 'Jun', 'Product A', 1600),
(1, 'Jan', 'Product B', 2000),
(2, 'Feb', 'Product B', 2500),
(3, 'Mar', 'Product B', 2200),
(4, 'Apr', 'Product B', 2700),
(5, 'May', 'Product B', 2300),
(6, 'Jun', 'Product B', 2600);


select * from ProfitData

--To add a new column that shows next month's profit for each product
select *,lead(Profit) over(partition by product order by monthnumber) [Next Month's Profit] from ProfitData

--We don't want product column inthe output but we want each month's total profit to be show by monthnumber & monthname,Also a 
--new column should be added to show next month's total profit
select monthnumber,monthname,sum(profit) [Total Profit],
lead(sum(profit)) over(order by monthnumber asc) [Next Month's Total Profit]
from ProfitData
group by MonthNumber,MonthName
order by MonthNumber

select * from ProfitData

--To add a new column that shows previous month's profit for each product
select *,lag(Profit) over(partition by product order by monthnumber) [Lag Function]from ProfitData

--We don't want product column inthe output but we want each month's total profit to be show by monthnumber & monthname,Also a 
--new column should be added to show previous month's total profit
select MonthNumber,MonthName,sum(profit) [Total Profit for Month],
lag(sum(profit)) over(order by monthnumber) [Previous Month's Total Profit]
from ProfitData
group by MonthNumber,MonthName
order by MonthNumber

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    PhoneNumber VARCHAR(20),
    Address VARCHAR(255)
);


INSERT INTO Customers (CustomerID, FirstName, LastName, Email, PhoneNumber, Address)
VALUES
(1, 'Alice', 'Johnson', 'alice.johnson@example.com', '555-1234', '123 Elm St'),
(2, 'Bob', 'Smith', NULL, '555-5678', NULL),
(3, 'Charlie', 'Williams', 'charlie.williams@example.com', NULL, '456 Oak St'),
(4, 'Diana', 'Brown', NULL, NULL, '789 Pine St'),
(5, 'Eve', 'Davis', 'eve.davis@example.com', '555-8765', NULL);



select * from Customers
-- ISNULL Örnekleri 
SELECT ISNULL(NULL, 'Default Value') AS Test1;
SELECT ISNULL('Actual Value', 'Default Value') AS Test2;     --ISNULL sadece 2 parametre alýr

-- Müþteri tablosunda ISNULL kullanýmý
select CustomerID,
       ISNULL(email, 'Email NA') as Email,
       ISNULL(phonenumber, 'Ph No NA') as PhoneNumber 
from Customers

-- COALESCE Örnekleri 
SELECT COALESCE('A', 'B', 'C') AS Test1;
SELECT COALESCE(NULL, 'B', 'C') AS Test2;                       --COALESCE birden fazla parametre alabilir ama tümü ayný/s uyumlu veri tipinde olmalý

SELECT COALESCE(NULL, NULL, 'C') AS Test3;

-- Müþteri tablosunda COALESCE kullanýmý
select CustomerID,
       COALESCE(email, phonenumber, 'Contact NA') as [Contact Info]
from Customers

-- Alternatif: Daha güvenli COALESCE kullanýmý
select CustomerID,
       COALESCE(CAST(email AS VARCHAR(100)), 
                CAST(phonenumber AS VARCHAR(100)), 
                'Contact NA') as [Contact Info]
from Customers
