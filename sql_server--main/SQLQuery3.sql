create database [SQL assignment]
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100) UNIQUE,
    DepartmentID INT,
    HireDate DATE,
    Salary DECIMAL(10, 2)
);


CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName NVARCHAR(100)
);


CREATE TABLE EmployeeSales (
    SaleID INT PRIMARY KEY,
    EmployeeID INT,
    Department VARCHAR(50),
    SaleAmount DECIMAL(10, 2),
    SaleDate DATE
);


INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, DepartmentID, HireDate, Salary)
VALUES 
(1, 'John', 'Smith', 'john.smith@example.com', 101, '2021-06-15', 75000.00),
(2, 'Jane', 'Doe', 'jane.doe@example.com', 102, '2020-03-10', 85000.00),
(3, 'Michael', 'Johnson', 'michael.johnson@example.com', 101, '2019-11-22', 95000.00),
(4, 'Emily', 'Davis', 'emily.davis@example.com', 103, '2022-01-05', 68000.00),
(5, 'William', 'Brown', 'william.brown@example.com', 102, '2018-07-19', 80000.00);


INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES
(101, 'Human Resources'),
(102, 'Finance'),
(103, 'IT'),
(104, 'Marketing'); -- Boþ departman testi için


INSERT INTO EmployeeSales (SaleID, EmployeeID, Department, SaleAmount, SaleDate)
VALUES 
(1, 101, 'Electronics', 500.00, '2023-08-01'),
(2, 102, 'Electronics', 300.00, '2023-08-03'),
(3, 101, 'Furniture', 150.00, '2023-08-02'),
(4, 103, 'Electronics', 250.00, '2023-08-04'),
(5, 104, 'Furniture', 200.00, '2023-08-02'),
(6, 101, 'Furniture', 450.00, '2023-08-05'),
(7, 102, 'Electronics', 700.00, '2023-08-05'),
(8, 103, 'Furniture', 100.00, '2023-08-06');

SELECT * FROM Employees;

SELECT Department,SUM(SaleAmount) AS total_sales_amount FROM EmployeeSales GROUP BY Department ORDER BY total_sales_amount DESC;

SELECT EmployeeID, COUNT(*) AS sales_count FROM EmployeeSales GROUP BY EmployeeID ORDER BY sales_count DESC;

-- 2.4 Departmanlara göre ortalama satýþ tutarý
SELECT Department,AVG(SaleAmount) AS average_sale_amount FROM EmployeeSales GROUP BY Department ORDER BY average_sale_amount DESC;

-- 2.5 Birden fazla satýþ yapan çalýþanlar
SELECT EmployeeID,SUM(SaleAmount) AS total_sales_amount,COUNT(*) AS sales_count FROM EmployeeSales GROUP BY EmployeeID HAVING COUNT(*) > 1 ORDER BY total_sales_amount DESC;

-- 3.1 Çalýþanlar ve departman isimleri
SELECT e.FirstName, e.LastName, d.DepartmentName FROM Employees e 
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY d.DepartmentName, e.LastName;

-- 3.2 Tüm departmanlar ve çalýþanlarý (boþ departmanlar dahil)
SELECT d.DepartmentName, e.FirstName,e.LastName
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
ORDER BY d.DepartmentName, e.LastName;

-- 3.3 Jane Doe ile ayný departmandaki çalýþanlar
SELECT e.FirstName, e.LastName,d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.DepartmentID = (
    SELECT DepartmentID 
    FROM Employees 
    WHERE FirstName = 'Jane' AND LastName = 'Doe'
)
AND (e.FirstName != 'Jane' OR e.LastName != 'Doe');

-- 3.4 En yüksek toplam maaþ ödeyen departman
SELECT TOP 1
    d.DepartmentName,
    SUM(e.Salary) AS TotalSalary
FROM Departments d
INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentID, d.DepartmentName
ORDER BY TotalSalary DESC;

-- 4.1 Ýsmi 'J' ile baþlayan çalýþanlar
SELECT FirstName, LastName
FROM Employees
WHERE FirstName LIKE 'J%';

-- 4.2 Soyismi 'n' ile biten çalýþanlar
SELECT FirstName, LastName
FROM Employees
WHERE LastName LIKE '%n';

-- 4.3 Email'de "john" geçen çalýþanlar
SELECT FirstName, LastName, Email
FROM Employees
WHERE Email LIKE '%john%';

-- 4.4 Ýsmi tam 5 karakter olan çalýþanlar
SELECT FirstName, LastName
FROM Employees
WHERE LEN(FirstName) = 5;

-- 4.5 Soyisminin 2. harfi 'a' olan çalýþanlar
SELECT FirstName, LastName
FROM Employees
WHERE LastName LIKE '_a%';

-- 5.1 Ortalama maaþtan yüksek maaþ alanlar
SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees)
ORDER BY Salary DESC;

-- 5.2 En eski çalýþandan sonra iþe alýnanlar
SELECT FirstName, LastName, DepartmentID, HireDate
FROM Employees
WHERE HireDate > (SELECT MIN(HireDate) FROM Employees)
ORDER BY HireDate;

-- 5.3 En yüksek maaþ alan çalýþan
SELECT EmployeeID, FirstName, LastName, Email, DepartmentID, HireDate, Salary
FROM Employees
WHERE Salary = (SELECT MAX(Salary) FROM Employees);

-- 5.4 John Smith ile ayný departmandakiler
SELECT FirstName, LastName, DepartmentID
FROM Employees
WHERE DepartmentID = (SELECT DepartmentID FROM Employees WHERE FirstName = 'John' AND LastName = 'Smith')
AND (FirstName != 'John' OR LastName != 'Smith');

-- 5.5 En yüksek ortalama maaþlý departmanda çalýþMAYANlar
SELECT FirstName, LastName, DepartmentID, Salary
FROM Employees
WHERE DepartmentID != (
    SELECT TOP 1 DepartmentID
    FROM Employees
    GROUP BY DepartmentID
    ORDER BY AVG(Salary) DESC
);

-- 6.1 DELETE + Transaction: Düþük maaþlý çalýþanlarý sil
BEGIN TRANSACTION;
DELETE FROM Employees WHERE Salary < 70000;
SELECT * FROM Employees; -- Kontrol
-- ROLLBACK; -- Geri al
-- COMMIT; -- Onayla

-- 6.2 DELETE + Subquery: En düþük maaþlý çalýþaný sil
BEGIN TRANSACTION;
DELETE FROM Employees 
WHERE Salary = (SELECT MIN(Salary) FROM Employees);
SELECT * FROM Employees ORDER BY Salary DESC;
-- ROLLBACK;

-- 6.3 Transaction: Maaþ güncelleme ve departman deðiþtirme
BEGIN TRANSACTION;
UPDATE Employees SET Salary = Salary * 1.10 WHERE DepartmentID = 101;
UPDATE Employees SET DepartmentID = 104 WHERE EmployeeID = 3;
SELECT * FROM Employees;
-- ROLLBACK;

-- 6.4 DELETE: Belirli departmandaki çalýþanlarý sil
BEGIN TRANSACTION;
DELETE FROM Employees WHERE DepartmentID = 102;
SELECT DepartmentID, COUNT(*) AS RemainingEmployees FROM Employees GROUP BY DepartmentID;
-- ROLLBACK;


-- 7.1 Tüm çalýþanlarý listele
SELECT * FROM Employees ORDER BY EmployeeID;

-- 7.2 DepartmentID = 101 olan çalýþanlar
SELECT FirstName, LastName, Email, DepartmentID
FROM Employees
WHERE DepartmentID = 101;

-- 7.3 Toplam çalýþan sayýsý
SELECT COUNT(*) AS TotalEmployees FROM Employees;

-- 7.4 2020 yýlýnda iþe alýnan çalýþanlar
SELECT *
FROM Employees
WHERE YEAR(HireDate) = 2020;

-- 7.5 Jane Doe'nun maaþýný güncelle
UPDATE Employees
SET Salary = 90000.00
WHERE FirstName = 'Jane' AND LastName = 'Doe';

-- Kontrol
SELECT FirstName, LastName, Salary 
FROM Employees 
WHERE FirstName = 'Jane' AND LastName = 'Doe';

-- =============================================
-- 8. ANALÝTÝK SORGULAR
-- =============================================

-- 8.1 Departman bazlý detaylý rapor
SELECT 
    d.DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount,
    SUM(e.Salary) AS TotalSalary,
    AVG(e.Salary) AS AverageSalary,
    MIN(e.Salary) AS MinSalary,
    MAX(e.Salary) AS MaxSalary
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentID, d.DepartmentName
ORDER BY TotalSalary DESC;

-- 8.2 Çalýþan performans analizi
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.DepartmentID,
    e.Salary,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsInCompany,
    CASE 
        WHEN e.Salary > (SELECT AVG(Salary) FROM Employees) THEN 'Above Average'
        ELSE 'Below Average'
    END AS SalaryStatus
FROM Employees e
ORDER BY YearsInCompany DESC, Salary DESC;



select * from Employees

--2nd Highest Salary
select max(salary) [2nd Highest Salary] from employees where salary<
(select max(salary) from Employees)

--3rd highest salary
select max(salary) [3rd Highest Salary] from employees where salary< (
select max(salary) from employees where salary<
(select max(salary) from Employees))

--CTE
with cte as(
select *,DENSE_RANK() over(order by salary desc) [DR] from Employees
)

select salary [2nd Highest Salary] from cte where DR = 2

--3rd Highest Salary
with cte as(
select *,DENSE_RANK() over(order by salary desc) [DR] from Employees
)

select salary [3rd Highest Salary] from cte where DR = 3

--Sub Query along with Dense_Rank()

select salary as [2nd highest salary] from
(select *, DENSE_RANK() over(order by salary desc) [DR] from Employees) x
where DR = 2


select salary as [3rd highest salary] from
(select *, DENSE_RANK() over(order by salary desc) [DR] from Employees) x
where DR = 3

--Sub Query
select top 1 salary [2nd Highest Salary] from 
(select distinct top 2 salary from Employees order by Salary desc) x
order by Salary asc


--3rd Highest Salary
select top 1 salary [3rd Highest Salary] from 
(select distinct top 3 salary from Employees order by salary desc) y
order by Salary asc