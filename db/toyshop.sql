-- 1. Tạo bảng Roles (bảng này không phụ thuộc vào bảng nào khác)
CREATE TABLE Roles (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

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
SELECT pr.*, u.email, u.full_name 
FROM password_resets pr
INNER JOIN Users u ON pr.user_id = u.user_id
WHERE pr.token = 'token' AND pr.expiry_date > GETDATE();
