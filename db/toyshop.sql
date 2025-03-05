-- 1. Tạo bảng Roles (bảng này không phụ thuộc vào bảng nào khác)
CREATE TABLE Roles (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);
select * from Users
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
select * from products;
ALTER TABLE Products
ADD is_featured BIT DEFAULT 0, -- Đánh dấu sản phẩm có phải là nổi bật hay không (0: không, 1: có)
    featured_order INT NULL,   -- Thứ tự hiển thị của sản phẩm nổi bật
    featured_until DATE NULL;  -- Ngày hết hạn của sản phẩm nổi bật (NULL nếu không giới hạn)

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

-- Kiểm tra dữ liệu Products
SELECT p.*, c.category_name 
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
ORDER BY p.product_id;

select * from Categories
delete from Products

UPDATE Products
SET is_featured = 1, 
    featured_order = 1, 
    featured_until = '2025-12-31'
WHERE product_id in (152,153,154,155,156,157);
UPDATE Categories SET category_name = 'mô hình' WHERE category_id = 1;
UPDATE Categories SET category_name = 'túi mù' WHERE category_id = 2;
UPDATE Categories SET category_name = 'lego' WHERE category_id = 3;

INSERT INTO Products (name, description, price, stock_quantity, category_id, image_url) 
VALUES
(N'Zoro', N'vac kiem dau cuon khan', 3200000, 10, 2, 'resources/product/figure/mo-hinh-zoro-vac-kiem-dau-quan-khan-cao-20cm-nang-500g-no-box-2-400x400.jpg'),
(N'Zoro', N'cam kiem cao 20cm', 2500000, 20, 2, 'resources/product/figure/mo-hinh-zoro-cam-kiem-dau-tran-cao-20cm-nang-500gr-no-box-7-400x400.jpg'),
(N'Songoku', N'3 dau thay the', 2600000, 20, 2, 'resources/product/figure/mo-hinh-songoku-vo-cuc-3-dau-thay-the-cao-52cm-nang-4kg-co-hop-carton-12-400x400.jpg'),
(N'Songoku', N'ssj3', 2600000, 20, 2, 'resources/product/figure/mo-hinh-songoku-ssj3-base-sieu-chat-cao-40cm-nang-3900gr-co-hop-mau-10-400x400.jpg'),
(N'Naruto', N'luc dao', 2500000, 25, 2, 'resources/product/figure/mo-hinh-naruto-luc-dao-cuu-vi-rasengan-cao-28cm-nang-15kg-co-hop-mau-6-400x400.jpg'),
(N'Naruto', N'dang dung sieu ngau', 2000000, 20, 2, 'resources/product/figure/mo-hinh-naruto-dang-dung-sieu-ngau-co-base-cao-42cm-nang-2kg-hop-carton-_-10-400x400.jpg'),
(N'Minato', N'dang dung sieu ngau', 2300000, 20, 2, 'resources/product/figure/mo-hinh-minato-dang-dung-sieu-ngau-cao-25cm-nang-300gr-no-box-2-400x400.jpg'),
(N'Luffy', N'gear5', 3200000, 25, 2,'resources/product/figure/mo-hinh-luffy-gear-5-trang-thai-chien-dau-cao-21cm-nang-1kg-hop-carton-1-402x400.png'),
(N'Naruto', N'combo 7 nhan vat', 2500000, 20, 2, 'resources/product/figure/mo-hinh-do-choi-naruto-combo12-nhan-vat-cao-7cm-nang-250gr-no-box-2-400x400.png'),
(N'Chibi', N'6 trang thai', 1500000, 15, 2, 'resources/product/figure/mo-hinh-chibi-6-trang-thai-luffy-gear-5-cao-10cm-nang-250gr-no-box-_-10-400x400.jpg'),
(N'Luffy', N'trang thai nika', 1200000, 20, 2, 'resources/product/figure/mo-hinh-bo-5-luffy-gear-5-trang-thai-nika-cao-12cm-nang-400g-no-box-8-400x400.jpg'),
(N'Luffy', N'gear6', 1300000, 15, 2, 'resources/product/figure/mo-hinh-bo-5-luffy-gear-4-trang-thai-snack-man-cao-9-10cm-nang-300g-co-hop-2-400x400.jpg'),
(N'Batman', N'The classic TV series batmobile', 4500000, 10, 1, 'resources/product/lego/Batman™_ The Classic TV Series Batmobile™.png'),
(N'Battlebus', N'11zon', 4800000, 10, 1, 'resources/product/lego/battle bus_11zon.png'),
(N'Disney Tim Burton', N'The nightmare before christmas', 3500000, 10, 1, 'resources/product/lego/Disney Tim Burton_s The Nightmare Before Christmas_11zon.png'),
(N'Ferrari', N'SF-24', 6500000, 10, 1, 'resources/product/lego/Ferrari SF-24 F1 Car_11zon.png'),
(N'Love', N'11', 2300000, 5, 1, 'resources/product/lego/LOVE_11zon.png'),
(N'Disney', N'Mini Castle', 4000000, 9, 1, 'resources/product/lego/Mini Disney Castle_11zon.png'),
(N'Porsche', N'911', 8000000, 12, 1,'resources/product/lego/Porsche 911_11zon.png'),
(N'SpiderMan', N'Mask', 3500000, 15, 1, 'resources/product/lego/Spider-Man_s Mask_11zon.png'),
(N'Tranquil Garden', N'Garden', 1500000, 10, 1, 'resources/product/lego/Tranquil Garden_11zon.png'),
(N'Tuxedo Cat', N'Cat', 2400000, 10, 1, 'resources/product/lego/Tuxedo Cat_11zon.png'),
(N'Wednesday & Enid', N'Dorm Room', 2500000, 8, 1, 'resources/product/lego/Wednesday & Enid_s Dorm Room_11zon.png'),
(N'Welcome to Emerald City', N'Emerald City', 1200000, 5, 1, 'resources/product/lego/Welcome to Emerald City_11zon.png'),
('Baby Three', 'Set Búp Bê Baby Three Nhiều Màu', 400000, 10, 3, 'resources/product/blindbox/set-bup-be-baby-three-nhieu-mau_11zon.png'),
('Baby Three', 'Set Búp Bê Baby Three BabyThree BB3 Shio Chinese Zodiac Blindbox 6 Màu Phối Màu Ngẫu Nhiên', 500000, 12, 3, '/resources/product/blindbox/set-bup-be-baby-three-babythree-bb3-shio-chinese-zodiac-blindbox-6-mau-phoi-mau-ngau-nhien_11zon.png'),
('Baby Three', 'Búp Bê Baby Three V3 Vinyl Plush Dinosaur Màu Xanh Lá', 600000, 15, 3, 'resources/product/blindbox/bup-be-baby-three-v3-vinyl-plush-dinosaur-mau-xanh-la-66f4e3b343e26-26092024113147_11zon.png'),
('Baby Three', 'Búp Bê Baby Three V3 Check Card Blindbox Thỏ Màu Hồng', 700000, 13, 3, 'resources/product/blindbox/bup-be-baby-three-v3-check-card-blindbox-tho-mau-hong_11zon.png'),
('Baby Three', 'Búp Bê Baby Three Chinese Zodiac Plush Doll', 800000, 11, 3, 'resources/product/blindbox/bup-be-baby-three-chinese-zodiac-plush-doll_11zon.png'),
('Baby Three', 'Romantic Ocean Plush Series Blind Box', 900000, 14, 3, 'resources/product/blindbox/Baby Three Romantic Ocean Plush Series Blind Box_11zon.png'),
('Baby Three', 'New Year', 1000000, 10, 3, 'resources/product/blindbox/Baby Three New Year_11zon.png'),
('Baby Three', 'Lucky Cat', 1100000, 15, 3, 'resources/product/blindbox/Baby Three Lucky Cat_11zon.png'),
('Baby Three', 'Elf Plush Series Blind Box', 1200000, 12, 3, 'resources/product/blindbox/Baby Three Elf Plush Series Blind Box_11zon.png'),
('Baby Three', 'Christmas 400_ Limited Plush Series Blind Box', 400000, 13, 3, 'resources/product/blindbox/Baby Three Christmas 400_ Limited Plush Series Blind Box_11zon.png'),
('Baby Three', 'Children Wonderland Plush Series Blind Box', 500000, 11, 3, 'resources/product/blindbox/Baby Three Children Wonderland Plush Series Blind Box_11zon.png'),
('Baby Three', '400__', 600000, 14, 3, 'resources/product/blindbox/Baby Three 400__11zon.png')
