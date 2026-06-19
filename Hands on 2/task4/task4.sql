CREATE DATABASE college_db;

USE college_db;

CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    hod_name VARCHAR(100),
    budget DECIMAL(12,2)
);
insert into departments (department_id, dept_name, hod_name, budget) value
(001, 'CSE', 'Janani', 80000),
(002, 'ECE', 'Arul', 50000),
(003, 'AIDS', 'Praveen', 85000),
(004, 'VLSI', 'Raja', 100000),
(005, 'MECH', 'Gokul', 540000);
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    date_of_birth DATE,
    department_id INT,
    enrollment_year INT,
    FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
);
insert into students (student_id, first_name, last_name, email, date_of_birth, enrollment_year) value
(1, 'Gopal', 'P', 'abc@gmail.com', '2006-02-11', 2027),
(2, 'Aswin', 'S', 'def@gmail.com', '2005-05-20', 2027),
(3, 'Aananth', 'K', 'hij@gmail.com', '2006-01-10', 2027),
(4, 'Deepak', 'R', 'klm@gmail.com', '2006-07-25', 2027),
(5, 'Vinoj', 'M', 'nop@gmail.com', '2006-11-22', 2027);
UPDATE students
SET department_id = 1
WHERE student_id = 1;

UPDATE students
SET department_id = 2
WHERE student_id = 2;

UPDATE students
SET department_id = 1
WHERE student_id = 3;

UPDATE students
SET department_id = 3
WHERE student_id = 4;

UPDATE students
SET department_id = 2
WHERE student_id = 5;
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    course_code VARCHAR(20) UNIQUE,
    credits INT,
    department_id INT,
    FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
);
insert into courses (course_id, course_name, course_code, credits, department_id) values
(001, 'DBMS', 'DB2358', 5, 001),
(002, 'NLP', 'CS2561', 4, 001),
(003, 'OS', 'CS4563', 3, 001),
(004, 'MLT', 'CS8523', 5, 005),
(005, 'DLT', 'CS3245', 4, 003);
CREATE TABLE professors (
    professor_id INT AUTO_INCREMENT PRIMARY KEY,
    prof_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    department_id INT,
    salary DECIMAL(10,2),
    FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
);
insert into professors (professor_id, prof_name, email, department_id, salary) value
(01, 'Magesh', 'qrs@gmail.com', 1, 80000),
(02, 'Aravind', 'tuv@gmail.com', 2, 50000),
(03, 'Sivanandham', 'wxy@gmail.com', 3, 40000),
(04, 'Harish', 'zab@gmail.com', 4, 45890),
(05, 'Raj', 'pol@gmail.com', 3, 36547);
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE,
    grade CHAR(2),
    FOREIGN KEY (student_id)
    REFERENCES students(student_id),
    FOREIGN KEY (course_id)
    REFERENCES courses(course_id)
);
insert into enrollments (enrollment_id, student_id, course_id, enrollment_date, grade) values
(01, 1, 001, '2023-05-11', 'A'),
(02, 1, 001, '2023-05-11', 'A'),
(03, 2, 002, '2023-05-11', 'B'),
(04, 3, 003, '2023-05-11', 'A'),
(05, 4, 004, '2023-05-11', 'C');
ALTER TABLE students
ADD COLUMN phone_number VARCHAR(11);
UPDATE students
SET  phone_number= 9856325895
WHERE student_id = 1;

UPDATE students
SET phone_number = 9658452158
WHERE student_id = 2;

UPDATE students
SET phone_number = 9874562554
WHERE student_id = 3;

UPDATE students
SET phone_number = 6589457125
WHERE student_id = 4;

UPDATE students
SET phone_number = 6874563214
WHERE student_id = 5;
ALTER TABLE courses
ADD COLUMN max_seats INT DEFAULT 60;
ALTER TABLE enrollments
ADD CONSTRAINT chk_grade
CHECK (grade IN ('A','B','C','D','F') OR grade IS NULL);
ALTER TABLE departments
CHANGE hod_name head_of_dept VARCHAR(100);
SELECT * FROM departments;
SELECT * FROM students;
SELECT * FROM courses;
SELECT * FROM professors;
SELECT * FROM enrollments;
ALTER TABLE students
DROP COLUMN phone_number;
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'students'
AND TABLE_SCHEMA = 'college_db';
SELECT COUNT(*) AS total_enrollments FROM enrollments;
SET SQL_SAFE_UPDATES = 0;
DELETE FROM enrollments
WHERE grade IS NULL;
SET SQL_SAFE_UPDATES = 1;
SELECT COUNT(*) AS total_enrollments_after_delete FROM enrollments;
-- 19. Final Verification
SELECT 'Final Students Count' AS metric, COUNT(*) AS count FROM students
UNION ALL
SELECT 'Final Courses Count', COUNT(*) FROM courses
UNION ALL
SELECT 'Final Enrollments Count', COUNT(*) FROM enrollments;
SELECT * FROM students 
WHERE enrollment_year = 2027 
ORDER BY first_name ASC;
SELECT * FROM courses 
WHERE credits > 3 
ORDER BY credits DESC;
SELECT * FROM professors 
WHERE salary BETWEEN 80000 AND 95000;
SELECT * FROM students 
WHERE email LIKE '%@gmail.com';
SELECT enrollment_year, COUNT(*) AS total_students
FROM students
GROUP BY enrollment_year;
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS student_full_name,
    d.dept_name
FROM students s
INNER JOIN departments d ON s.department_id = d.department_id;
SELECT 
    e.enrollment_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    c.course_name
FROM enrollments e
INNER JOIN students s ON e.student_id = s.student_id
INNER JOIN courses c ON e.course_id = c.course_id;
SELECT 
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.enrollment_id IS NULL;

SELECT 
    d.dept_name,
    p.prof_name,
    p.salary
FROM departments d
LEFT JOIN professors p ON d.department_id = p.department_id;
SELECT 
    grade, 
    COUNT(*) AS grade_count
FROM enrollments
WHERE course_id = 1 -- Targets DBMS
GROUP BY grade;
SELECT 
    d.dept_name, 
    COUNT(s.student_id) AS student_count
FROM departments d
INNER JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.dept_name
HAVING COUNT(s.student_id) > 1;