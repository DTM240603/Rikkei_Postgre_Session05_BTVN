CREATE SCHEMA bt07;
SET search_path TO bt07;

CREATE TABLE categories(
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE,
    description TEXT
);

CREATE TABLE products(
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category_id INT,
    price NUMERIC(10,2) CHECK(price > 0),
    stock_quantity INT CHECK (stock_quantity >= 0),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE customers(
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    city VARCHAR(150),
    join_date DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE orders(
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount NUMERIC(10,2) CHECK(total_amount > 0),
    status VARCHAR(10) CHECK (status IN ('PENDING', 'COMPLETED', 'CANCELLED')),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items(
    item_id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT CHECK ( quantity > 0 ),
    unit_price NUMERIC(10,2) CHECK(unit_price > 0),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 1. Categories
INSERT INTO categories (category_name, description)
VALUES
    ('Electronics', 'Thiết bị điện tử'),
    ('Books', 'Sách và tài liệu học tập'),
    ('Fashion', 'Thời trang'),
    ('Home Appliances', 'Đồ gia dụng'),
    ('Beauty', 'Mỹ phẩm và chăm sóc cá nhân'),
    ('Toys', 'Đồ chơi trẻ em');

-- 2. Products
INSERT INTO products (product_name, category_id, price, stock_quantity)
VALUES
    ('Laptop Dell XPS 13', 1, 25000000.00, 10),
    ('iPhone 15', 1, 22000000.00, 15),
    ('Chuột Logitech M90', 1, 500000.00, 50),
    ('Sách PostgreSQL cơ bản', 2, 200000.00, 30),
    ('Sách Java Backend', 2, 300000.00, 25),
    ('Áo thun nam basic', 3, 199000.00, 40),
    ('Máy giặt Samsung', 4, 8500000.00, 8);


-- 3. Customers
INSERT INTO customers (customer_name, email, city, join_date)
VALUES
    ('Nguyễn Văn A', 'nguyenvana@gmail.com', 'Hà Nội', '2025-12-20'),
    ('Trần Thị B', 'tranthib@gmail.com', 'Đà Nẵng', '2026-01-05'),
    ('Lê Văn C', 'levanc@gmail.com', 'Hồ Chí Minh', '2026-01-10'),
    ('Phạm Thị D', 'phamthid@gmail.com', 'Hà Nội', '2026-02-01'),
    ('Hoàng Thị E', 'hoangthie@gmail.com', 'Cần Thơ', '2026-02-15'),
    ('Đặng Văn F', 'dangvanf@gmail.com', 'Hà Nội', '2026-03-01');

-- 4. Orders
INSERT INTO orders (customer_id, order_date, total_amount, status)
VALUES
    (1, '2026-01-05', 25400000.00, 'COMPLETED'),
    (1, '2026-02-12', 22000000.00, 'COMPLETED'),
    (1, '2026-03-20', 800000.00, 'PENDING'),
    (2, '2026-04-02', 8500000.00, 'COMPLETED'),
    (2, '2025-11-25', 398000.00, 'CANCELLED'),
    (3, '2026-05-10', 25000000.00, 'COMPLETED'),
    (3, '2026-05-20', 600000.00, 'COMPLETED'),
    (4, '2026-06-01', 500000.00, 'PENDING'),
    (6, '2026-07-15', 22300000.00, 'COMPLETED'),
    (6, '2025-12-20', 200000.00, 'CANCELLED'),
    (2, '2026-08-15', 25500000.00, 'COMPLETED');

-- 5. Order Items
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES
    (1, 1, 1, 25000000.00),
    (1, 4, 2, 200000.00),

    (2, 2, 1, 22000000.00),

    (3, 3, 1, 500000.00),
    (3, 5, 1, 300000.00),

    (4, 7, 1, 8500000.00),

    (5, 6, 2, 199000.00),

    (6, 1, 1, 25000000.00),

    (7, 5, 2, 300000.00),

    (8, 3, 1, 500000.00),

    (9, 2, 1, 22000000.00),
    (9, 5, 1, 300000.00),

    (10, 4, 1, 200000.00),

    (11, 1, 1, 25000000.00),
    (11, 3, 1, 500000.00);



-- Phần 1: ALIAS & Aggregate Functions (2 điểm)
-- 1. Liệt kê danh sách sản phẩm gồm: Tên sản phẩm (Alias: "Tên SP"), Giá niêm yết (Alias: "Đơn giá")
-- và "Giá sau thuế" (Giá * 1.1, Alias: "Giá VAT").
SELECT
    p.product_name "Tên SP",
    p.price "Đơn giá",
    (p.price * 1.1) "Giá VAT"
FROM products p;

-- 2. Đếm tổng số khách hàng hiện có theo từng thành phố (Sắp xếp giảm dần theo số lượng).
SELECT
    c.city "Thành phố",
    COUNT(c.customer_id) "Số khách hàng"
FROM customers c
GROUP BY c.city
ORDER BY "Số khách hàng" DESC;

-- 3. Tính giá cao nhất, thấp nhất và trung bình của các sản phẩm có trong kho.
SELECT
    MAX(p.price) "Giá cao nhất",
    MIN(p.price) "Giá thấp nhất",
    AVG(p.price) "Giá trung bình"
FROM products p
WHERE p.stock_quantity > 0;

-- 4. Thống kê số lượng đơn hàng theo từng trạng thái (Status).
SELECT
    o.status "Trạng thái",
    COUNT(o.order_id) "Số lượng"
FROM orders o
GROUP BY o.status;


-- Phần 2: JOINs & GROUP BY (2 điểm)
-- 5. (Inner Join): Hiển thị 10 đơn hàng gần nhất gồm: Mã đơn, Tên khách hàng, Email và Tổng giá trị đơn hàng.
SELECT
    o.order_id "Mã đơn",
    c.customer_name "Tên khách hàng",
    c.email "Email",
    o.total_amount "Tổng tiền"
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
ORDER BY o.order_date DESC
LIMIT 10;

-- 6. (Left Join): Liệt kê tất cả danh mục (Categories) và số lượng sản phẩm thuộc danh mục đó (Kể cả danh mục chưa có sản phẩm).
SELECT
    c.category_name "Danh mục",
    SUM(p.product_id) "Số lượng"
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_id;

-- 7. (Group By & Having): Tìm các khách hàng đã đặt từ 3 đơn hàng trở lên và có tổng chi tiêu (total_amount) > 5.000.000 VNĐ.
SELECT
    c.customer_name,
    COUNT(o.order_id),
    SUM(o.total_amount)
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name, c.customer_id
HAVING COUNT(o.order_id) >= 3 AND SUM(o.total_amount) > 5000000;

-- 8. Thống kê tổng doanh thu theo từng tên danh mục sản phẩm (Nối 4 bảng: Categories, Products, Order_Items, Orders).
SELECT
    c.category_name "Danh mục",
    SUM(oi.quantity * oi.unit_price) "Tổng"
FROM categories c
JOIN products p ON c.category_id = p.category_id
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
GROUP BY c.category_id;

-- Phần 3: Subqueries (2 điểm)
-- 9. Tìm thông tin sản phẩm có giá cao hơn giá trung bình của tất cả sản phẩm trong hệ thống.
SELECT *
FROM products p
WHERE p.price > (SELECT AVG(p2.price)
                 FROM products p2);

-- 10. Tìm các khách hàng chưa từng phát sinh bất kỳ đơn hàng nào (Sử dụng NOT EXISTS).
SELECT *
FROM customers c
WHERE NOT EXISTS(
    SELECT 1
    FROM orders o
    WHERE c.customer_id = o.customer_id
);


-- 11. Liệt kê các sản phẩm có giá cao hơn giá trung bình của chính danh mục mà sản phẩm đó thuộc về (Correlated Subquery).
SELECT
    p.product_name,
    p.price,
    c.category_name
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE p.price > (   SELECT AVG(p2.price)
                    FROM products p2
                    WHERE p.category_id = p2.category_id);


-- 12. Tìm khách hàng đã thực hiện đơn hàng có giá trị lớn nhất trong toàn bộ hệ thống.
SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.total_amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.total_amount = (SELECT MAX(o1.total_amount)
                        FROM orders o1);


-- Phần 4: Set Operators - UNION/INTERSECT/EXCEPT (2 điểm)
-- 1. (UNION): Gộp danh sách Email của khách hàng và Email của các nhà cung cấp (giả sử có bảng suppliers) để làm danh sách gửi tin NewsLetter.
CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100),
    email VARCHAR(100) UNIQUE
);
INSERT INTO suppliers (supplier_name, email)
VALUES
    ('Dell Việt Nam', 'contact@dell.vn'),
    ('Apple Distributor', 'sales@apple.vn'),
    ('Nhà sách ABC', 'contact@nhasachabc.vn');

SELECT
    c.email AS "Email NewsLetter"
FROM customers c
UNION
SELECT
    s.email AS "Email NewsLetter"
FROM suppliers s;

-- 2. (INTERSECT): Tìm danh sách customer_id vừa mua sản phẩm thuộc danh mục 'Electronics' vừa mua sản phẩm thuộc danh mục 'Books'.
SELECT o.customer_id
FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    JOIN categories c ON p.category_id = c.category_id
WHERE c.category_name = 'Electronics'

INTERSECT

SELECT o.customer_id
FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    JOIN categories c ON p.category_id = c.category_id
WHERE c.category_name = 'Books';


-- Phần 5: SQL Logic & Clean Code (2 điểm)
-- 1. Viết truy vấn cập nhật lại total_amount trong bảng orders dựa trên tổng tiền từ bảng order_items tương ứng.
UPDATE orders o
SET total_amount = (    SELECT SUM(oi.quantity * oi.unit_price)
                        FROM order_items oi
                        WHERE oi.order_id = o.order_id
                        );
-- 2. Tạo một View tên là vw_customer_summary hiển thị: Tên khách hàng, Tổng số đơn đã mua, Tổng số tiền đã chi tiêu.
-- 3. Viết truy vấn tìm thành phố có doanh thu cao nhất trong năm 2026.
SELECT
    c.city,
    SUM(o.total_amount)
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY SUM(o.total_amount) DESC
LIMIT 1;
