CREATE SCHEMA bt02;
SET search_path TO bt02;

CREATE TABLE bt02.products(
                              product_id SERIAL PRIMARY KEY,
                              product_name VARCHAR(100),
                              category VARCHAR(100)
);

CREATE TABLE bt02.orders(
                            order_id SERIAL PRIMARY KEY,
                            product_id INT,
                            quantity INT CHECK(quantity > 0),
                            total_price INT CHECK(total_price > 0),
                            FOREIGN KEY (product_id) REFERENCES bt01.products(product_id)
);

INSERT INTO products(product_name, category)
VALUES  ('Laptop Dell', 'Electronics'),
        ('IPhone 15', 'Electronics'),
        ('Bàn học gỗ', 'Furniture'),
        ('Ghế xoay', 'Furniture');

INSERT INTO orders(order_id, product_id, quantity, total_price)
VALUES  (101, 1, 2, 2200),
        (102, 2, 3, 3300),
        (103, 3, 5, 2500),
        (104, 4, 4, 1600),
        (105, 1, 1, 1100);

-- 1. Viết truy vấn con (Subquery) để tìm sản phẩm có doanh thu cao nhất trong bảng orders
-- Hiển thị: product_name, total_revenue
SELECT
    p.product_name,
    SUM(o.total_price) total_revenue
FROM products p
    JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_id
HAVING SUM(o.total_price) = (   SELECT SUM(o.total_price)
                                FROM products p
                                         JOIN orders o ON p.product_id = o.product_id
                                GROUP BY p.product_id
                                ORDER BY SUM(o.total_price) DESC
                                LIMIT 1);

-- 2. Viết truy vấn hiển thị tổng doanh thu theo từng nhóm category (dùng JOIN + GROUP BY)
SELECT
    p.category,
    SUM(o.total_price) "Tổng doanh thu"
FROM products p
JOIN orders o ON p.product_id = o.product_id
GROUP BY p.category;
