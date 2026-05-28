CREATE SCHEMA bt05;
SET search_path TO bt05;

CREATE TABLE bt05.students (
    student_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    major VARCHAR(50)
);

CREATE TABLE bt05.courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    credit INT
);

CREATE TABLE bt05.enrollments (
    student_id INT REFERENCES bt05.students(student_id),
    course_id INT REFERENCES bt05.courses(course_id),
    score NUMERIC(5,2)
);

-- Thêm dữ liệu vào bảng students
INSERT INTO students (full_name, major)
VALUES
    ('Nguyễn Văn A', 'Công nghệ thông tin'),
    ('Trần Thị B', 'Kinh tế'),
    ('Lê Quốc Cường', 'Công nghệ thông tin'),
    ('Phạm Minh Anh', 'Luật'),
    ('Võ Thị Thu Hằng', 'Marketing');

-- Thêm dữ liệu vào bảng courses
INSERT INTO courses (course_name, credit)
VALUES
    ('Cơ sở dữ liệu', 3),
    ('Lập trình Java', 4),
    ('Kinh tế vi mô', 3),
    ('Pháp luật đại cương', 2),
    ('Marketing căn bản', 3);

-- Thêm dữ liệu vào bảng enrollments
INSERT INTO enrollments (student_id, course_id, score)
VALUES
    (1, 1, 8.50),
    (1, 2, 7.75),
    (2, 3, 8.00),
    (3, 1, 9.00),
    (3, 2, 8.25),
    (4, 4, 7.00),
    (5, 5, 8.80);

SELECT * FROM students;
SELECT * FROM courses;
SELECT * FROM enrollments;

-- 1. ALIAS:
-- Liệt kê danh sách sinh viên cùng tên môn học và điểm
-- dùng bí danh bảng ngắn (vd. s, c, e)
-- và bí danh cột như Tên sinh viên, Môn học, Điểm
SELECT
    s.full_name "Tên sinh viên",
    c.course_name "Môn học",
    e.score "Điểm"
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

-- 2. Aggregate Functions:
-- Tính cho từng sinh viên:
-- Điểm trung bình
-- Điểm cao nhất
-- Điểm thấp nhất
SELECT
    s.full_name "Tên sinh viên",
    AVG(e.score) "Điểm trung bình",
    MAX(e.score) "Điểm cao nhất",
    MIN(e.score) "Điểm thấp nhất"
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id;

-- 3. GROUP BY / HAVING:
-- Tìm ngành học (major) có điểm trung bình cao hơn 7.5
SELECT
    s.major "Ngành",
    AVG(e.score) "Điểm trung bình"
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.major
HAVING AVG(e.score) > 7.5;

-- 4. JOIN:
-- Liệt kê tất cả sinh viên, môn học, số tín chỉ và điểm (JOIN 3 bảng)
SELECT
    s.full_name "Tên sinh viên",
    c.course_name "Môn học",
    c.credit "Số tín chỉ",
    e.score "Điểm"
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

-- 5. Subquery:
-- Tìm sinh viên có điểm trung bình cao hơn điểm trung bình toàn trường
-- Gợi ý: dùng AVG(score) trong subquery
SELECT
    s.full_name "Tên sinh viên",
    AVG(e.score) "Điểm trung bình"
FROM students s
         JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING AVG(e.score) > (SELECT AVG(e.score)
                       FROM enrollments e);




