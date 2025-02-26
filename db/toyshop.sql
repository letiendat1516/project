-- 1. Tạo bảng Roles (bảng này không phụ thuộc vào bảng nào khác)
CREATE TABLE Roles (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);
select * from Roles
-- 2. Tạo bảng Users (phụ thuộc vào Roles)
CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    address NVARCHAR(MAX),
    role_id INT,
    is_active BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (role_id) REFERENCES Roles(role_id)
);


-- 3. Tạo bảng Categories (bảng độc lập)
CREATE TABLE Categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name NVARCHAR(100) NOT NULL UNIQUE
);

-- 4. Tạo bảng Products (phụ thuộc vào Categories)
CREATE TABLE Products (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    category_id INT,
    image_url VARCHAR(255),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);
ALTER TABLE Products
ADD is_featured BIT DEFAULT 0, -- Đánh dấu sản phẩm có phải là nổi bật hay không (0: không, 1: có)
    featured_order INT NULL,   -- Thứ tự hiển thị của sản phẩm nổi bật
    featured_until DATE NULL;  -- Ngày hết hạn của sản phẩm nổi bật (NULL nếu không giới hạn)
	select * from Products

-- 5. Tạo bảng Discounts (bảng độc lập)
CREATE TABLE Discounts (
    discount_id INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    percentage DECIMAL(5,2) NOT NULL CHECK (percentage BETWEEN 0 AND 100),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_active BIT DEFAULT 1,
    CHECK (end_date >= start_date)
);

-- 6. Tạo bảng Orders (phụ thuộc vào Users)
CREATE TABLE Orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    total_price DECIMAL(10,2) NOT NULL CHECK (total_price >= 0),
    status VARCHAR(20) CHECK (status IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled')) DEFAULT 'Pending',
    created_at DATETIME DEFAULT GETDATE(),
    discount_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (discount_id) REFERENCES Discounts(discount_id)
);

-- 7. Tạo bảng OrderDetails (phụ thuộc vào Orders và Products)
CREATE TABLE OrderDetails (
    order_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 8. Tạo bảng Reviews (phụ thuộc vào Users và Products)
CREATE TABLE Reviews (
    review_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    product_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 9. Tạo bảng Cart (phụ thuộc vào Users và Products)
CREATE TABLE Cart (
    cart_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 10. Tạo các Stored Procedures
GO
CREATE PROCEDURE sp_CheckEmailExists
    @email VARCHAR(100)
AS
BEGIN
    SELECT COUNT(*) 
    FROM Users 
    WHERE email = @email;
END
GO

CREATE PROCEDURE sp_CheckPhoneExists
    @phone VARCHAR(15)
AS
BEGIN
    SELECT COUNT(*) 
    FROM Users 
    WHERE phone = @phone;
END
GO

CREATE PROCEDURE sp_RegisterUser
    @fullName NVARCHAR(100),
    @email VARCHAR(100),
    @phone VARCHAR(15),
    @password VARCHAR(255),
    @address NVARCHAR(MAX) = NULL,
    @role_id INT = 3 -- Mặc định là Customer
AS
BEGIN
    INSERT INTO Users (full_name, email, phone, password, address, role_id)
    VALUES (@fullName, @email, @phone, @password, @address, @role_id);
    
    SELECT SCOPE_IDENTITY() AS userId;
END
GO

-- 11. Insert dữ liệu mặc định cho Roles
INSERT INTO Roles (role_name) VALUES 
('Admin'),
('Employee'),
('Customer');

CREATE PROCEDURE sp_LoginUser
    @email VARCHAR(100),
    @password VARCHAR(100)
AS
BEGIN
    SELECT user_id, full_name, email, phone, role_id, is_active
    FROM Users 
    WHERE email = @email AND password = @password
END
-- Tạo tài khoản admin (thay đổi thông tin theo nhu cầu)
INSERT INTO Users (full_name, email, phone, password, role_id, is_active, created_at)
VALUES ('Admin', 'admin@admin.com', '0123456789', 'admin123', 1, 1, GETDATE());
CREATE TABLE password_resets (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    token VARCHAR(255) NOT NULL,
    expiry_date DATETIME NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

select * from password_resets
select * from Users

-- Stored procedure để kiểm tra token và cập nhật mật khẩu
CREATE PROCEDURE sp_ResetPassword
    @token VARCHAR(255),
    @newPassword VARCHAR(255)
AS
BEGIN
    DECLARE @userId INT
    
    -- Kiểm tra token và lấy user_id
    SELECT @userId = pr.user_id
    FROM password_resets pr
    WHERE pr.token = @token 
    AND pr.expiry_date > GETDATE()
    
    IF @userId IS NOT NULL
    BEGIN
        -- Cập nhật mật khẩu
        UPDATE Users 
        SET password = @newPassword
        WHERE user_id = @userId
        
        -- Xóa token đã sử dụng
        DELETE FROM password_resets 
        WHERE token = @token
        
        SELECT 1 as Success -- Thành công
    END
    ELSE
    BEGIN
        SELECT 0 as Success -- Token không hợp lệ hoặc hết hạn
    END
END

SELECT TOP 3 *
FROM products
ORDER BY product_id DESC;






-- 1. Thêm dữ liệu vào bảng Categories
INSERT INTO Categories (category_name) VALUES 
(N'Điện thoại'),
(N'Laptop'),
(N'Tablet'),
(N'Phụ kiện');
-- Thêm một số sản phẩm vào danh sách nổi bật
INSERT INTO FeaturedProducts (product_id, featured_from, featured_until)
VALUES 
(42, GETDATE(), DATEADD(month, 3, GETDATE())), -- Sản phẩm ID 1, hiển thị đầu tiên, nổi bật trong 3 tháng
(43, GETDATE(), DATEADD(month, 2, GETDATE())), -- Sản phẩm ID 3, hiển thị thứ hai, nổi bật trong 2 tháng
(45, GETDATE(), DATEADD(month, 3, GETDATE())); -- Sản phẩm ID 5, hiển thị thứ ba, nổi bật trong 3 tháng

-- 2. Thêm dữ liệu vào bảng Products
INSERT INTO Products (name, description, price, stock_quantity, category_id, image_url) 
VALUES
(N'iPhone 14 Pro Max', 
N'iPhone 14 Pro Max 128GB - Smartphone cao cấp với màn hình 6.7 inch, chip A16 Bionic',
27990000.00, 
50,
1,
'resources/product/figure/a.png');
INSERT INTO Products (name, description, price, stock_quantity, category_id, image_url) 
VALUES
(N'iPhone 14 Pro Max', 
N'iPhone 14 Pro Max 128GB - Smartphone cao cấp với màn hình 6.7 inch, chip A16 Bionic',
27990000.00, 
1,
1,
'resources/product/figure/sex.jpg');
select * from users

(N'Samsung Galaxy S23 Ultra', 
N'Samsung Galaxy S23 Ultra với bút S-Pen, camera 200MP, chip Snapdragon 8 Gen 2',
25990000.00,
45,
1,
'images/products/s23ultra.jpg'),

(N'Xiaomi 13 Pro',
N'Xiaomi 13 Pro với camera Leica, chip Snapdragon 8 Gen 2, sạc nhanh 120W',
22990000.00,
30,
1,
'images/products/xiaomi13pro.jpg'),

-- Laptop (category_id = 2)
(N'MacBook Pro 14 M2',
N'Laptop MacBook Pro 14 inch với chip M2 Pro, 16GB RAM, 512GB SSD',
45990000.00,
25,
2,
'images/products/macbookpro14.jpg'),

(N'Dell XPS 13 Plus',
N'Dell XPS 13 Plus với Intel Core i7 gen 12, 16GB RAM, 512GB SSD',
35990000.00,
20,
2,
'images/products/dellxps13.jpg'),

-- Tablet (category_id = 3)
(N'iPad Pro 12.9 2022',
N'iPad Pro 12.9 inch 2022 với chip M2, màn hình Mini LED, hỗ trợ Apple Pencil 2',
28990000.00,
35,
3,
'images/products/ipadpro2022.jpg'),

(N'Samsung Galaxy Tab S9 Ultra',
N'Samsung Galaxy Tab S9 Ultra với màn hình 14.6 inch, S-Pen, chip Snapdragon 8 Gen 2',
24990000.00,
25,
3,
'images/products/tabs9ultra.jpg'),

-- Phụ kiện (category_id = 4)
(N'Apple AirPods Pro 2',
N'Tai nghe không dây Apple AirPods Pro 2 với chống ồn chủ động, âm thanh không gian',
5990000.00,
100,
4,
'images/products/airpodspro2.jpg'),

(N'Samsung Galaxy Watch 5 Pro',
N'Đồng hồ thông minh Samsung Galaxy Watch 5 Pro với GPS, đo sức khỏe',
8990000.00,
40,
4,
'images/products/watch5pro.jpg'),

(N'Anker PowerCore 26800',
N'Pin sạc dự phòng Anker PowerCore 26800mAh với 3 cổng USB',
1290000.00,
150,
4,
'images/products/anker26800.jpg');


-- Kiểm tra dữ liệu Categories
select * FROM Products;

-- Kiểm tra dữ liệu Products
SELECT p.*, c.category_name 
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
ORDER BY p.product_id;

select * from users
delete from Products

UPDATE Products
SET is_featured = 1, 
    featured_order = 1, 
    featured_until = '2025-12-31'
WHERE product_id = 42;

-- Đánh dấu một sản phẩm khác là nổi bật
UPDATE Products
SET is_featured = 1, 
    featured_order = 2, 
    featured_until = '2025-11-30'
WHERE product_id = 43;