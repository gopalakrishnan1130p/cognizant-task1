use students;
CREATE TABLE students(
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50)
);
insert into students (student_id, student_name) values
(001, 'Arul'),
(002, 'Arun');
CREATE TABLE enrollments(
    student_id INT,
    course_id INT,
    grade CHAR(2),
    PRIMARY KEY(student_id, course_id)
);
insert into enrollments (student_id, course_id, grade) values
(1, 101,'A'),
(2, 102,'B');
select * from students;
select * from enrollments;