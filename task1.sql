create database college_db;
use college_db;
CREATE TABLE departments (
department_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    hod_name VARCHAR(100),
    budget DECIMAL(12,2)
);
INSERT INTO`college_db`.`departments`(department_id, dept_name, hod_name, budget) VALUES
 (01,'Computer Science', 'Dr. Ramesh Kumar', 850000.00),
 (02,'Electronics', 'Dr. Priya Nair', 620000.00),
 (03,'Mechanical', 'Dr. Suresh Iyer', 540000.00),
 (04,'Civil', 'Dr. Ananya Sharma', 430000.00);

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
INSERT INTO `college_db`.`students`(first_name, last_name, email, date_of_birth, department_id, enrollment_year) VALUES
 ('Gopala', 'Krishnan', 'gopalakrishnan.2023.cse@ritchennai.edu.in','2006-02-11', 01, 2027),
 ('aswin', 'ragunathan', 'aswin.2023.cse@ritchennai.edu.in','2006-02-11', 02, 2027),
 ('Aananth', 'K', 'aananth.2023.cse@ritchennai.edu.in','2006-02-11', 03, 2027),
 ('Gobi', 'Krishnan', 'gobi.2023.cse@ritchennai.edu.in','2006-02-11', 04, 2027);
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    course_code VARCHAR(20) UNIQUE,
    credits INT,
    department_id INT,
    
    FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
);
INSERT INTO `college_db`.`courses`(course_name, course_code, credits, department_id) VALUES
 ('Data Structures & Algorithms', 'CS101', 4, 1),
 ('Database Management Systems', 'CS102', 3, 1),
 ('Object Oriented Programming', 'CS103', 4, 1),
 ('Circuit Theory', 'EC101', 3, 2),
 ('Thermodynamics', 'ME101', 3, 3);
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    grade CHAR(2),

    FOREIGN KEY (student_id)
    REFERENCES students(student_id),

    FOREIGN KEY (course_id)
    REFERENCES courses(course_id)
);
INSERT INTO `college_db`.`enrollments` (`enrollment_id`, `student_id`, `course_id`, `enrollment_date`, `grade`) VALUES ('01', '1', '010', '2026-08-15', 'A');
CREATE TABLE professors (
    professor_id INT AUTO_INCREMENT PRIMARY KEY,
    prof_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    department_id INT,
    salary DECIMAL(10,2),

    FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
);
SELECT * FROM departments;
SELECT * FROM students;
SELECT * FROM courses;