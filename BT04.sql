CREATE SCHEMA bt04;
SET search_path TO bt04;

CREATE TABLE bt04.customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE bt04.orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE,
    total_amount NUMERIC(10,2)
);

CREATE TABLE bt04.order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_name VARCHAR(100),
    quantity INT,
    price NUMERIC(10,2)
);

-- Thêm dữ liệu vào bảng customers
INSERT INTO customers (customer_name, city)
VALUES
    ('Nguyễn Văn A', 'Hà Nội'),
    ('Trần Thị B', 'Đà Nẵng'),
    ('Lê Văn C', 'Hồ Chí Minh'),
    ('Phạm Thị D', 'Hà Nội');

-- Thêm dữ liệu vào bảng orders
INSERT INTO orders (customer_id, order_date, total_amount)
VALUES
    (1, '2025-01-05', 3000.00),
    (2, '2025-01-10', 1500.00),
    (1, '2025-02-15', 2500.00),
    (3, '2025-02-20', 4000.00),
    (4, '2025-03-01', 800.00);

-- Thêm dữ liệu vào bảng order_items
INSERT INTO order_items (order_id, product_name, quantity, price)
VALUES
    (1, 'Laptop Dell', 1, 3000.00),
    (2, 'Chuột Logitech', 2, 750.00),
    (3, 'Bàn phím cơ Razer', 5, 500.00),
    (4, 'iPhone 15', 2, 2000.00),
    (5, 'Tai nghe AirPods', 1, 800.00);

SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM order_items;

-- 1. ALIAS:
-- Hiển thị danh sách tất cả các đơn hàng với các cột:
-- Tên khách (customer_name)
-- Ngày đặt hàng (order_date)
-- Tổng tiền (total_amount)
SELECT
    c.customer_name "Tên khách",
    o.order_date "Ngày đặt hàng",
    o.total_amount "Tổng tiền"
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;

-- 2. Aggregate Functions:
-- Tính các thông tin tổng hợp:
-- Tổng doanh thu (SUM(total_amount))
-- Trung bình giá trị đơn hàng (AVG(total_amount))
-- Đơn hàng lớn nhất (MAX(total_amount))
-- Đơn hàng nhỏ nhất (MIN(total_amount))
-- Số lượng đơn hàng (COUNT(order_id))
SELECT
    SUM(total_amount) "Tổng doanh thu",
    AVG(total_amount) "Trung bình giá trị đơn hàng",
    MAX(total_amount) "Đơn hàng lớn nhất",
    MIN(total_amount) "Đơn hàng nhỏ nhất",
    COUNT(order_id) "Số lượng đơn hàng"
FROM orders;

-- 3. GROUP BY / HAVING:
-- Tính tổng doanh thu theo từng thành phố
SELECT
    c.city,
    SUM(o.total_amount) "Tổng doanh thu"
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city;

-- chỉ hiển thị những thành phố có tổng doanh thu lớn hơn 10.000
SELECT
    c.city,
    SUM(o.total_amount) "Tổng doanh thu"
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city
HAVING SUM(o.total_amount) > 10000;

-- 4. JOIN:
-- Liệt kê tất cả các sản phẩm đã bán, kèm:
-- Tên khách hàng
-- Ngày đặt hàng
-- Số lượng và giá
SELECT
    c.customer_name,
    oi.product_name,
    o.order_date,
    oi.quantity,
    oi.price
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id;

-- 5. Subquery:
-- Tìm tên khách hàng có tổng doanh thu cao nhất.
-- Gợi ý: Dùng SUM(total_amount) trong subquery để tìm MAX
SELECT
    c.customer_name,
    SUM(o.total_amount)
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING SUM(o.total_amount) = (SELECT MAX(customer_revenue)
                              FROM (
                                    SELECT
                                        customer_id,
                                        SUM(total_amount) customer_revenue
                                    FROM orders
                                    GROUP BY customer_id) revenue_table
                              );

