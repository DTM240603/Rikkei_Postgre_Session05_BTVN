CREATE SCHEMA bt01;
SET search_path TO bt01;

CREATE TABLE bt01.products(
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(100)
);

CREATE TABLE bt01.orders(
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

-- 1. Viết truy vấn hiển thị tổng doanh thu (SUM(total_price)) và số lượng sản phẩm bán được (SUM(quantity)) cho từng nhóm danh mục (category)
-- Đặt bí danh cột như sau:
-- total_sales cho tổng doanh thu
-- total_quantity cho tổng số lượng
SELECT
    p.category,
    SUM(o.total_price) "total_sales",
    SUM(o.quantity) "total_quantity"
FROM products p
    JOIN orders o ON o.product_id = p.product_id
GROUP BY p.category;

-- Chỉ hiển thị những nhóm có tổng doanh thu lớn hơn 2000
SELECT
    p.category,
    SUM(o.total_price) "total_sales",
    SUM(o.quantity) "total_quantity"
FROM products p
         JOIN orders o ON o.product_id = p.product_id
GROUP BY p.category
HAVING SUM(o.total_price) > 2000;

-- Sắp xếp kết quả theo tổng doanh thu giảm dần
SELECT
    p.category,
    SUM(o.total_price) "total_sales",
    SUM(o.quantity) "total_quantity"
FROM products p
         JOIN orders o ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY SUM(o.total_price) DESC;