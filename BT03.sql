-- CREATE DATABASE session05_btvn;

CREATE SCHEMA bt03;

CREATE TABLE bt03.customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(100)
);

CREATE TABLE bt03.orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_price NUMERIC(10,2) NOT NULL CHECK (total_price >= 0),

    FOREIGN KEY (customer_id)
     REFERENCES bt03.customers(customer_id)
);

CREATE TABLE bt03.order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),

    FOREIGN KEY (order_id)
      REFERENCES bt03.orders(order_id)
);

INSERT INTO bt03.customers (customer_id, customer_name, city)
VALUES
    (1, 'Nguyễn Văn A', 'Hà Nội'),
    (2, 'Trần Thị B', 'Đà Nẵng'),
    (3, 'Lê Văn C', 'Hồ Chí Minh'),
    (4, 'Phạm Thị D', 'Hà Nội');
INSERT INTO bt03.orders (order_id, customer_id, order_date, total_price)
VALUES
    (101, 1, '2024-12-20', 3000),
    (102, 2, '2025-01-05', 1500),
    (103, 1, '2025-02-10', 2500),
    (104, 3, '2025-02-15', 4000),
    (105, 4, '2025-03-01', 800);

INSERT INTO bt03.order_items (item_id, order_id, product_id, quantity, price)
VALUES
    (1, 101, 1, 2, 1500),
    (2, 102, 2, 1, 1500),
    (3, 103, 3, 5, 500),
    (4, 104, 2, 4, 1000);

SELECT * FROM bt03.customers;
SELECT * FROM bt03.orders;
SELECT * FROM bt03.order_items;

-- 1. Viết truy vấn hiển thị tổng doanh thu và tổng số đơn hàng của mỗi khách hàng:
--      a. Chỉ hiển thị khách hàng có tổng doanh thu > 2000
--      b. Dùng ALIAS: total_revenue và order_count
SELECT
    c.customer_name,
    SUM(o.total_price) "total_revenue",
    COUNT(o.order_id) "order_count"
FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id
HAVING SUM(o.total_price) > 2000;

-- 2. Viết truy vấn con (Subquery) để tìm doanh thu trung bình của tất cả khách hàng
-- Sau đó hiển thị những khách hàng có doanh thu lớn hơn mức trung bình đó
SELECT
    c.customer_name,
    SUM(o.total_price) "total_revenue",
    COUNT(o.customer_id) "order_count"
FROM orders o
         JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id
HAVING SUM(o.total_price) > (SELECT AVG(customer_revenue)
                             FROM (
                                      SELECT SUM(total_price) AS customer_revenue
                                      FROM bt03.orders
                                      GROUP BY customer_id
                                  ) AS revenue_table);

-- 3. Dùng HAVING + GROUP BY để lọc ra thành phố có tổng doanh thu cao nhất
SELECT
    c.city,
    SUM(o.total_price) "total_revenue"
FROM bt03.orders o
    JOIN bt03.customers c ON o.customer_id = c.customer_id
GROUP BY c.city
HAVING SUM(o.total_price) = (SELECT
                                 SUM(o.total_price) "total_revenue"
                             FROM bt03.orders o
                                      JOIN bt03.customers c ON o.customer_id = c.customer_id
                             GROUP BY c.city
                             ORDER BY SUM(o.total_price) DESC LIMIT 1);




-- 4. (Mở rộng) Hãy dùng INNER JOIN giữa customers, orders, order_items để hiển thị chi tiết:
-- Tên khách hàng, tên thành phố, tổng sản phẩm đã mua, tổng chi tiêu
SELECT
    c.customer_name,
    c.city,
    SUM(oi.quantity) "Tổng sản phẩm",
    SUM(oi.quantity * oi.price)
FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name, c.city;
