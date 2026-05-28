CREATE SCHEMA bt06;
SET search_path TO bt06;

CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100)
);

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100),
    dept_id INT REFERENCES departments(dept_id),
    salary NUMERIC(10,2),
    hire_date DATE
);

CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100),
    dept_id INT REFERENCES departments(dept_id)
);

-- Thêm dữ liệu vào bảng departments
INSERT INTO departments (dept_name)
VALUES
    ('Phòng Công nghệ thông tin'),
    ('Phòng Kế toán'),
    ('Phòng Nhân sự'),
    ('Phòng Marketing'),
    ('Phòng Kinh doanh');

-- Thêm dữ liệu vào bảng employees
INSERT INTO employees (emp_name, dept_id, salary, hire_date)
VALUES
    ('Nguyễn Văn A', 1, 15000000.00, '2023-01-10'),
    ('Trần Thị B', 2, 12000000.00, '2022-05-15'),
    ('Lê Quốc Cường', 1, 18000000.00, '2021-09-20'),
    ('Phạm Minh Anh', 3, 11000000.00, '2024-02-01'),
    ('Võ Thị Thu Hằng', 4, 13000000.00, '2023-07-12'),
    ('Hoàng Nam', 5, 14000000.00, '2022-11-25');

-- Thêm dữ liệu vào bảng projects
INSERT INTO projects (project_name, dept_id)
VALUES
    ('Xây dựng hệ thống quản lý nội bộ', 1),
    ('Triển khai phần mềm kế toán', 2),
    ('Tuyển dụng nhân sự quý 1', 3),
    ('Chiến dịch quảng cáo mùa hè', 4),
    ('Mở rộng thị trường miền Nam', 5),
    ('Nâng cấp website công ty', 1);

-- 1. ALIAS:
-- Hiển thị danh sách nhân viên gồm: Tên nhân viên, Phòng ban, Lương
-- dùng bí danh bảng ngắn (employees as e,departments as d).
SELECT
    e.emp_name "Tên nhân viên",
    d.dept_name "Phòng ban",
    e.salary "Lương"
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;

-- 2. Aggregate Functions:
-- Tổng quỹ lương toàn công ty
-- Mức lương trung bình
-- Lương cao nhất, thấp nhất
-- Số nhân viên

SELECT
    SUM(e.salary) "Quỹ lương",
    AVG(e.salary) "Lương trung bình",
    MAX(e.salary) "Lương cao nhất",
    MIN(e.salary) "Lương thấp nhât",
    COUNT(e.emp_id) "Số nhân viên"
FROM employees e;

-- 3. GROUP BY / HAVING:
-- Tính mức lương trung bình của từng phòng ban
-- chỉ hiển thị những phòng ban có lương trung bình > 15.000.000
SELECT
    d.dept_name "Phòng ban",
    AVG(e.salary) "Lương trung bình"
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_id
HAVING AVG(e.salary) > 15000000;

-- 4. JOIN:
-- Liệt kê danh sách dự án (project) cùng với phòng ban phụ trách và nhân viên thuộc phòng ban đó
SELECT
    d.dept_name "Phòng ban",
    p.project_name "Dự án",
    e.emp_name "Nhân viên"
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
JOIN projects p ON d.dept_id = p.dept_id
ORDER BY d.dept_name, p.project_name;

-- 5. Subquery:
-- Tìm nhân viên có lương cao nhất trong mỗi phòng ban
-- Gợi ý: Subquery lồng trong WHERE salary IN (SELECT MAX(...))
SELECT
    d.dept_name "Phòng ban",
    e.emp_name "Nhân viên",
    e.salary "Lương"
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WHERE e.salary IN (
                    SELECT MAX(e2.salary)
                    FROM employees e2
                    JOIN departments d2 on e2.dept_id = d2.dept_id
                    GROUP BY d2.dept_id
                );



