-- 1. Drop existing tables in correct order to avoid dependency locks
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS professors;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS department_transfer_log;

-- 2. Create Departments Table
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    head_of_dept VARCHAR(100),
    budget DECIMAL(12,2)
);

INSERT INTO departments (department_id, dept_name, head_of_dept, budget) VALUES
(1, 'CSE', 'Janani', 80000),
(2, 'ECE', 'Arul', 50000),
(3, 'AIDS', 'Praveen', 85000),
(4, 'VLSI', 'Raja', 100000),
(5, 'MECH', 'Gokul', 540000);

-- 3. Create Students Table
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    date_of_birth DATE,
    department_id INT REFERENCES departments(department_id),
    enrollment_year INT,
    phone_number VARCHAR(11)
);

INSERT INTO students (student_id, first_name, last_name, email, date_of_birth, department_id, enrollment_year, phone_number) VALUES
(1, 'Gopal', 'P', 'abc@gmail.com', '2006-02-11', 1, 2027, '9856325895'),
(2, 'Aswin', 'S', 'def@gmail.com', '2005-05-20', 2, 2027, '9658452158'),
(3, 'Aananth', 'K', 'hij@gmail.com', '2006-01-10', 1, 2027, '9874562554'),
(4, 'Deepak', 'R', 'klm@gmail.com', '2006-07-25', 3, 2027, '6589457125'),
(5, 'Vinoj', 'M', 'nop@gmail.com', '2006-11-22', 2, 2027, '6874563214');

-- 4. Create Courses Table
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    course_code VARCHAR(20) UNIQUE,
    credits INT,
    department_id INT REFERENCES departments(department_id),
    max_seats INT DEFAULT 60
);

INSERT INTO courses (course_id, course_name, course_code, credits, department_id) VALUES
(1, 'DBMS', 'DB2358', 5, 1),
(2, 'NLP', 'CS2561', 4, 1),
(3, 'OS', 'CS4563', 3, 1),
(4, 'MLT', 'CS8523', 5, 5),
(5, 'DLT', 'CS3245', 4, 3);

-- 5. Create Enrollments Table
CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(student_id),
    course_id INT REFERENCES courses(course_id),
    enrollment_date DATE,
    grade CHAR(2) CHECK (grade IN ('A','B','C','D','F') OR grade IS NULL)
);

INSERT INTO enrollments (enrollment_id, student_id, course_id, enrollment_date, grade) VALUES
(1, 1, 1, '2023-05-11', 'A'),
(3, 2, 2, '2023-05-11', 'B'),
(4, 3, 3, '2023-05-11', 'A'),
(5, 4, 4, '2023-05-11', 'C');

-- 6. Create Log Table
CREATE TABLE department_transfer_log (
    log_id SERIAL PRIMARY KEY,
    student_id INT,
    old_department_id INT,
    new_department_id INT,
    transfer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
EXPLAIN (FORMAT JSON)
SELECT s.first_name, s.last_name, c.course_name 
FROM enrollments e 
JOIN students s ON s.student_id = e.student_id 
JOIN courses c ON c.course_id = e.course_id 
WHERE s.enrollment_year = 2027;
CREATE INDEX idx_partial_missing_grades 
ON enrollments(student_id) 
WHERE grade IS NULL;
CREATE OR REPLACE FUNCTION fn_transfer_student(
    p_student_id INT,
    p_new_dept_id INT
) RETURNS VOID AS $$
DECLARE
    v_old_dept_id INT;
BEGIN
    -- Get the current department ID
    SELECT department_id INTO v_old_dept_id FROM students WHERE student_id = p_student_id;

    -- Update the student record
    UPDATE students SET department_id = p_new_dept_id WHERE student_id = p_student_id;

    -- Log the transfer administrative action
    INSERT INTO department_transfer_log (student_id, old_department_id, new_department_id)
    VALUES (p_student_id, v_old_dept_id, p_new_dept_id);
    
EXCEPTION
    WHEN OTHERS THEN
        -- If anything crashes, Postgres auto-rolls back the whole block
        RAISE NOTICE 'Transaction hit an error! Rolling back changes safely.';
        RAISE;
END;
$$ LANGUAGE plpgsql;
-- Call the function
SELECT fn_transfer_student(1, 3);

-- Verify the change in the students table
SELECT * FROM students WHERE student_id = 1;

-- Verify the change in the audit log table
SELECT * FROM department_transfer_log;
