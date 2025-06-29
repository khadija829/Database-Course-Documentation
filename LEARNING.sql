CREATE DATABASE LEARNING PLATFORM:

USE LEARNING PLATFORM:

CREATE TABLE Instructor
( 
    InstructorID INT PRIMARY KEY, 
    FullName VARCHAR(100), 
    Email VARCHAR(100), 
    JoinDate DATE 
); 



CREATE TABLE Category

( 
    CategoryID INT PRIMARY KEY, 
    CategoryName VARCHAR(50) 
); 

CREATE TABLE Course 
( 
    CourseID INT PRIMARY KEY, 
    Title VARCHAR(100), 
    InstructorID INT, 
    CategoryID INT, 
    Price DECIMAL(6,2), 
    PublishDate DATE, 
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID),  
	FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID) 
); 

CREATE TABLE Students
( 
    StudentID INT PRIMARY KEY, 
    FullName VARCHAR(100), 
    Email VARCHAR(100), 
    JoinDate DATE 
); 

CREATE TABLE Enrollments

( 
    EnrollmentID INT PRIMARY KEY, 
    StudentID INT, 
    CourseID INT, 
    EnrollDate DATE, 
    CompletionPercent INT, 
    Rating INT CHECK (Rating BETWEEN 1 AND 5), 
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID), 
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID) 
); 

--Instructors 
INSERT INTO Instructor VALUES 
(4, 'Sarah Ahmed', 'sarah@learnhub.com', '2023-01-10'), 
(3, 'Mohammed Al-Busaidi', 'mo@learnhub.com', '2024-05-21'); 

-- Categories 

INSERT INTO Category VALUES
(1, 'Web Development'),
(2, 'Data Science'),
(3, 'Business');

-- Courses 

INSERT INTO Course VALUES 
(101, 'HTML & CSS Basics', 1, 1, 29.99, '2023-02-01'), 
(102, 'Python for Data Analysis', 2, 2, 49.99, '2023-03-15'), 
(103, 'Excel for Business', 2, 3, 19.99, '2023-04-10'), 
(104, 'JavaScript Advanced', 1, 1, 39.99, '2023-05-01'); 

-- Students 

INSERT INTO Students VALUES 
(201, 'Ali Salim', 'ali@student.com', '2023-04-01'), 
(202, 'Layla Nasser', 'layla@student.com', '2023-04-05'), 
(203, 'Ahmed Said', 'ahmed@student.com', '2023-04-10'); 

-- Enrollments 

INSERT INTO Enrollments VALUES 
(1, 201, 101, '2023-04-10', 100, 5), 
(2, 202, 102, '2023-04-15', 80, 4), 
(3, 203, 101, '2023-04-20', 90, 4), 
(4, 201, 102, '2023-04-22', 50, 3), 
(5, 202, 103, '2023-04-25', 70, 4), 
(6, 203, 104, '2023-04-28', 30, 2), 
(7, 201, 104, '2023-05-01', 60, 3); 

SELECT * FROM Enrollments

--Step 3: Different Uses of Aggregation (Research & Reflect) 
--Research and write short answers (bullet points) on these questions in your learning notebook or document: 


--1.	What is the difference between GROUP BY and ORDER BY? 

-- GROUP BY: Puts rows into groups to apply calculations (like totals, averages) to each group. Changes the result's structure.
-- ORDER BY: Sorts the final results. Only changes the display order.

--2.	Why do we use HAVING instead of WHERE when filtering aggregate results? 

-- WHERE: Filters individual rows before grouping. Cannot use aggregate functions.
-- HAVING: Filters groups after aggregation. Can use aggregate functions.

--3.	What are common beginner mistakes when writing aggregation queries? 
-- Not putting all non-aggregated SELECT columns into GROUP BY.
-- Using WHERE instead of HAVING for conditions on aggregates.

--4.	When would you use COUNT(DISTINCT ...), AVG(...), and SUM(...) together? 

--When you need multiple types of summaries (unique counts, averages, totals) for the same groups of data. E.g.,
--for each product category: total sales (SUM), average sale amount (AVG), and unique customers (COUNT(DISTINCT)).

--5.	How does GROUP BY affect query performance, and how can indexes help? 
-- Performance: GROUP BY can be slow, as it often requires sorting or hashing large amounts of data.
-- Indexes: Indexes on GROUP BY columns (or covering indexes) can significantly speed it up by allowing the database to find 
--and group data much faster,reducing the need for heavy internal processing.

-- 1. Count total number of students
SELECT COUNT(*) AS total_students FROM Students;

-- 2. Count total number of enrollments
SELECT COUNT(*) AS total_enrollments FROM Enrollments;

-- 3. Average rating of each course
SELECT CourseID, AVG(Rating) AS avg_rating
FROM Enrollments
GROUP BY CourseID;

-- 4. Total number of courses per instructor
SELECT InstructorID, COUNT(*) AS course_count
FROM Course
GROUP BY InstructorID;

-- 5. Number of courses in each category
SELECT cat.CategoryName, COUNT(*) AS total_course
FROM Course c
JOIN Category cat ON c.CategoryID = cat.CategoryID
GROUP BY cat.CategoryName;

-- 6. Number of students enrolled in each course
SELECT CourseID, COUNT(StudentID) AS student_count
FROM Enrollments
GROUP BY CourseID;

-- 7. Average course price per category
SELECT cat.CategoryName, AVG(c.Price) AS avg_price
FROM Course c
JOIN Category cat ON c.CategoryID = cat.CategoryID
GROUP BY cat.CategoryName;

-- 8. Maximum course price
SELECT MAX(Price) AS max_price FROM Course;

-- 9. Min, Max, and Avg rating per course
SELECT CourseID, MIN(Rating) AS min_rating, MAX(Rating) AS max_rating, AVG(Rating) AS avg_rating
FROM Enrollments
GROUP BY CourseID;

-- 10. Count how many students gave rating = 5
SELECT COUNT(*) AS five_star_ratings
FROM Enrollments
WHERE Rating = 5;

--Intermediate Level
-- 1. Average completion percent per course
SELECT CourseID, AVG(CompletionPercent) AS avg_completion
FROM Enrollments
GROUP BY CourseID;

-- 2. Students enrolled in more than 1 course
SELECT StudentID, COUNT(*) AS course_count
FROM Enrollments
GROUP BY StudentID
HAVING COUNT(*) > 1;

-- 3. Revenue per course (price × enrollments)
SELECT c.CourseID, c.Title, COUNT(e.StudentID) * c.Price AS revenue
FROM Course c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseID, c.Title, c.Price;

-- 4. Instructor name + distinct student count
SELECT i.FullName AS instructor_name, COUNT(DISTINCT e.StudentID) AS student_count
FROM Instructor i
JOIN Course c ON i.InstructorID = c.InstructorID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY i.FullName;

-- 5. Average enrollments per category
SELECT cat.CategoryName, AVG(sub.enrollments) AS avg_enrollments
FROM (
    SELECT CourseID, COUNT(*) AS enrollments
    FROM Enrollments
    GROUP BY CourseID
) sub
JOIN Course c ON sub.CourseID = c.CourseID
JOIN Category cat ON c.CategoryID = cat.CategoryID
GROUP BY cat.CategoryName;

-- 6. Average course rating by instructor
SELECT i.FullName AS instructor_name, AVG(e.Rating) AS avg_rating
FROM Instructors i
JOIN Courses c ON i.InstructorID = c.InstructorID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY i.FullName;

-- 7. Top 3 courses by enrollment count (SQL Server syntax)
SELECT TOP 3 CourseID, COUNT(*) AS enrollment_count
FROM Enrollments
GROUP BY CourseID
ORDER BY enrollment_count DESC;

-- 8. Mock Average days for 100% completion (assume 1% = 1 day)
SELECT CourseID, AVG(CompletionPercent) AS avg_days_to_complete
FROM Enrollments
WHERE CompletionPercent = 100
GROUP BY CourseID;

-- 9. Completion percentage of students per course
SELECT CourseID,
       COUNT(CASE WHEN CompletionPercent = 100 THEN 1 END) * 100.0 / COUNT(*) AS completion_rate
FROM Enrollments
GROUP BY CourseID;

-- 10. Count of courses published each year
SELECT YEAR(PublishDate) AS year_published, COUNT(*) AS total_courses
FROM Course
GROUP BY YEAR(PublishDate);






























