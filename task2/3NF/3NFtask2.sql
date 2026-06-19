use students;
CREATE TABLE departments(
    department_id INT PRIMARY KEY,
    dept_name VARCHAR(100)
);
insert into departments (department_id,  dept_name) values
(1, 'CSE'),
(2, 'ECE'),
(3, 'VLSI'),
(4, 'AIDS');
ALTER TABLE students
ADD COLUMN department_id INT;
insert into students (student_id, student_name, department_id) values
(3, 'Arul', 3),
(4, 'nandini', 3);
UPDATE students
SET department_id = 1
WHERE student_id = 1;
UPDATE students
SET department_id = 1
WHERE student_id = 2;
select * from students;
select * from departments;