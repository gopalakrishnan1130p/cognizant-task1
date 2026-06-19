create database students;
use students;
CREATE TABLE students(
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50)
);
insert into students (student_id, student_name) values
(001, 'Arul'),
(002, 'Arun');
update students
set student_name = 'Vasanth' where student_id = 002;
CREATE TABLE student_phones(
    phone_id INT PRIMARY KEY,
    student_id INT,
    phone_number VARCHAR(15),
    FOREIGN KEY(student_id)
    REFERENCES students(student_id)
);
insert into student_phones(phone_id, student_id, phone_number) values
(1, 001, 6574125895),
(2, 002, 6985475621);
select * from students;
select * from student_phones;