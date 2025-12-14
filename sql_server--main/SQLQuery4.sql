create database [SQL FUNCTIONS]


CREATE TABLE Students (
    student_name VARCHAR(100),
    subject VARCHAR(100),
    marks INT
);


INSERT INTO Students (student_name, subject, marks)
VALUES 
-- Marks for REYHAN
('REYHAN', 'Math', 85),
('REYHAN', 'Science', 88),
('REYHAN', 'English', 92),

-- Marks for EFE
('EFE', 'Math', 90),
('EFE', 'Science', 78),
('EFE', 'English', 85),

-- Marks for TUNA
('TUNA', 'Math', 85),
('TUNA', 'Science', 82),
('TUNA', 'English', 80),

-- Marks for David
('David', 'Math', 92),
('David', 'Science', 91),
('David', 'English', 89),

-- Marks for Eve
('Eve', 'Math', 90),
('Eve', 'Science', 85),
('Eve', 'English', 87),

-- Marks for EMÝRHAN
('EMÝRHAN', 'Math', 75),
('EMÝRHAN', 'Science', 72),
('EMÝRHAN', 'English', 78),

-- Marks for Grace
('Grace', 'Math', 85),
('Grace', 'Science', 89),
('Grace', 'English', 90);



select * from Students
--Row_Number -> In case of a tie row numbers are assigned randomly
select *,ROW_NUMBER() over(order by marks desc) as [Row Number] from Students

--Rank -> if there's a tie next rank/ranks will be skipped
select *,rank() over(order by marks desc) as [Rank Function] from Students

--Dense_Rank -> if there's a tie ranks will not be skipped
select *,DENSE_RANK() over(order by marks desc) [Dense Rank] from Students


--Row_Number -> In case of a tie row numbers are assigned randomly
select *,ROW_NUMBER() over(order by marks) as [Row Number] from Students

--Rank -> if there's a tie next rank/ranks will be skipped
select *,rank() over(order by marks) as [Rank Function] from Students

--Dense_Rank -> if there's a tie ranks will not be skipped
select *,DENSE_RANK() over(order by marks) [Dense Rank] from Students

--Row_Number -> In case of a tie row numbers are assigned randomly
select *,ROW_NUMBER() over(order by marks asc) as [Row Number] from Students

--Rank -> if there's a tie next rank/ranks will be skipped
select *,rank() over(order by marks asc) as [Rank Function] from Students

--Dense_Rank -> if there's a tie ranks will not be skipped
select *,DENSE_RANK() over(order by marks asc) [Dense Rank] from Students

