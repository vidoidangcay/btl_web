
USE Trading2022;
GO

-- BƯỚC 1: Xóa các bảng phụ thuộc nhất trước
IF OBJECT_ID('dbo.UserVoucher', 'U') IS NOT NULL DROP TABLE dbo.UserVoucher;
IF OBJECT_ID('dbo.Wishlist', 'U') IS NOT NULL DROP TABLE dbo.Wishlist;
IF OBJECT_ID('dbo.Cart', 'U') IS NOT NULL DROP TABLE dbo.Cart;
IF OBJECT_ID('dbo.Feedback', 'U') IS NOT NULL DROP TABLE dbo.Feedback;
IF OBJECT_ID('dbo.OrderDetails', 'U') IS NOT NULL DROP TABLE dbo.OrderDetails;
IF OBJECT_ID('dbo.OrderShipment', 'U') IS NOT NULL DROP TABLE dbo.OrderShipment;
IF OBJECT_ID('dbo.StockInDetails', 'U') IS NOT NULL DROP TABLE dbo.StockInDetails;
IF OBJECT_ID('dbo.AdminDeleteRequest', 'U') IS NOT NULL DROP TABLE dbo.AdminDeleteRequest;
IF OBJECT_ID('dbo.ProductGallery', 'U') IS NOT NULL DROP TABLE dbo.ProductGallery;
GO

-- BƯỚC 2: Xóa các bảng trung gian
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.StockIn', 'U') IS NOT NULL DROP TABLE dbo.StockIn;
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;
GO

-- BƯỚC 3: Xóa các bảng gốc
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL DROP TABLE dbo.Categories;
IF OBJECT_ID('dbo.Suppliers', 'U') IS NOT NULL DROP TABLE dbo.Suppliers;
IF OBJECT_ID('dbo.Vouchers', 'U') IS NOT NULL DROP TABLE dbo.Vouchers;
IF OBJECT_ID('dbo.Accounts', 'U') IS NOT NULL DROP TABLE dbo.Accounts;
GO

-------------------------------------------------------------------------
-- BƯỚC 4: Tạo lại bảng
-------------------------------------------------------------------------

CREATE TABLE Categories (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    describe NVARCHAR(255)
);
GO

CREATE TABLE Products (
    id VARCHAR(10) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    quantity INT DEFAULT 0 CHECK (quantity >= 0),
    price DECIMAL(10,2) CHECK (price >= 0),
    releaseDate DATE,
    describe NVARCHAR(500),
    image NVARCHAR(255),
    cid INT,
    CONSTRAINT FK_Product_Category FOREIGN KEY (cid) REFERENCES Categories(id)
);

CREATE TABLE Accounts (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    role INT NOT NULL
);

CREATE TABLE AdminDeleteRequest (
    target_admin VARCHAR(50) PRIMARY KEY,
    requester_admin VARCHAR(50) NOT NULL,
    requestedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_AdminDeleteRequest_Target FOREIGN KEY (target_admin) REFERENCES Accounts(username) ON DELETE CASCADE,
    CONSTRAINT FK_AdminDeleteRequest_Requester FOREIGN KEY (requester_admin) REFERENCES Accounts(username)
);

CREATE TABLE Customers (
    username VARCHAR(50) PRIMARY KEY,
    fullname NVARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    address NVARCHAR(255),
    points INT DEFAULT 0,
    CONSTRAINT FK_Customers_Accounts FOREIGN KEY (username) REFERENCES Accounts(username) ON DELETE CASCADE

);

CREATE TABLE Wishlist (
    username VARCHAR(50),
    pid VARCHAR(10),
    addedDate DATE DEFAULT GETDATE(),
    PRIMARY KEY (username, pid),
    CONSTRAINT FK_Wish_Customer FOREIGN KEY (username) REFERENCES Customers(username) ON DELETE CASCADE,
    CONSTRAINT FK_Wish_Product FOREIGN KEY (pid) REFERENCES Products(id) ON DELETE CASCADE
);


CREATE TABLE Suppliers (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100),
    phone VARCHAR(15),
    address NVARCHAR(255)
);

CREATE TABLE StockIn (
    id INT PRIMARY KEY IDENTITY(1,1),
    date DATETIME DEFAULT GETDATE(),
    sid INT,
    admin_user VARCHAR(50),
    total_cost DECIMAL(12,2),
    CONSTRAINT FK_StockIn_Supplier FOREIGN KEY (sid) REFERENCES Suppliers(id) ON DELETE CASCADE,
    CONSTRAINT FK_StockIn_Admin FOREIGN KEY (admin_user) REFERENCES Accounts(username)
);

CREATE TABLE StockInDetails (
    stock_id INT,
    pid VARCHAR(10),
    quantity INT,
    purchase_price DECIMAL(10,2),
    PRIMARY KEY (stock_id, pid),
    CONSTRAINT FK_SID_StockIn FOREIGN KEY (stock_id) REFERENCES StockIn(id) ON DELETE CASCADE,
    CONSTRAINT FK_SID_Product FOREIGN KEY (pid) REFERENCES Products(id) ON DELETE CASCADE
);


CREATE TABLE Vouchers (
    code VARCHAR(20) PRIMARY KEY,
    discountValue DECIMAL(10,2),
    expirationDate DATE,
    minOrderValue DECIMAL(10,2),
    quantity INT
);

CREATE TABLE Orders (
    id INT PRIMARY KEY IDENTITY(1,1),
    date DATETIME DEFAULT GETDATE(),
    totalmoney DECIMAL(10,2),
    status INT DEFAULT 0,
    username VARCHAR(50),

    receiver_name NVARCHAR(100),
    receiver_phone VARCHAR(15),
    shipping_address NVARCHAR(255),
    voucher_code VARCHAR(20),
    payment_method VARCHAR(30) DEFAULT 'qr',

    CONSTRAINT FK_Orders_Customers 
        FOREIGN KEY (username) REFERENCES Customers(username),

    CONSTRAINT FK_Orders_Voucher
        FOREIGN KEY (voucher_code) REFERENCES Vouchers(code)
);

IF COL_LENGTH('dbo.Orders','payment_method') IS NULL
BEGIN
    ALTER TABLE Orders ADD payment_method VARCHAR(30) DEFAULT 'qr';
END

CREATE TABLE OrderDetails (
    oid INT, 
    pid VARCHAR(10), 
    quantity INT,
    price DECIMAL(10,2),

    PRIMARY KEY (oid, pid),

    CONSTRAINT FK_Details_Orders 
        FOREIGN KEY (oid) REFERENCES Orders(id) ON DELETE CASCADE,
        
    CONSTRAINT FK_Details_Products 
        FOREIGN KEY (pid) REFERENCES Products(id) ON DELETE CASCADE
);

CREATE TABLE OrderShipment (
    order_id INT PRIMARY KEY,
    username VARCHAR(50),
    receiver_name NVARCHAR(100),
    receiver_phone VARCHAR(15),
    shipping_address NVARCHAR(255),
    status INT DEFAULT 0,
    createdDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_OrderShipment_Order FOREIGN KEY (order_id) REFERENCES Orders(id) ON DELETE CASCADE,
    CONSTRAINT FK_OrderShipment_Account FOREIGN KEY (username) REFERENCES Accounts(username)
);

CREATE TABLE Feedback (
    id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT,
    username VARCHAR(50),
    comment NVARCHAR(MAX),
    createdDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Feedback_Order FOREIGN KEY (order_id) REFERENCES Orders(id) ON DELETE CASCADE,
    CONSTRAINT FK_Feedback_Account FOREIGN KEY (username) REFERENCES Accounts(username)
);

CREATE TABLE Cart (
    id INT PRIMARY KEY IDENTITY(1,1),
    username VARCHAR(50), 
    pid VARCHAR(10),      
    quantity INT DEFAULT 1, 
    addedDate DATETIME DEFAULT GETDATE(), 
    CONSTRAINT FK_Cart_Customer FOREIGN KEY (username) REFERENCES Customers(username),
    CONSTRAINT FK_Cart_Product FOREIGN KEY (pid) REFERENCES Products(id) ON DELETE CASCADE,
	CONSTRAINT UQ_Cart UNIQUE (username, pid)
);
GO
CREATE TABLE UserVoucher(
    username VARCHAR(50),
    pid VARCHAR(10), -- Vì giao diện của bạn đang chọn voucher cho từng sản phẩm
    voucher_code VARCHAR(20),
    selectedDate DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (username, pid),
    CONSTRAINT FK_Selection_Account FOREIGN KEY (username) REFERENCES Accounts(username),
    CONSTRAINT FK_Selection_Product FOREIGN KEY (pid) REFERENCES Products(id),
    CONSTRAINT FK_Selection_Voucher FOREIGN KEY (voucher_code) REFERENCES Vouchers(code)
);
INSERT INTO Categories (name, describe) VALUES
(N'iPhone', N'Đẹp rực rỡ rạng ngời'),
(N'Samsung', N'thời thượng'),
(N'Oppo', N'dành cho sinh viên sành điệu'),
(N'Vsmart', N'cho 1 Việt Nam đẹp đẽ');


INSERT INTO Products (id, name, quantity, price, releaseDate, describe, image, cid) VALUES
('ip1', N'iphone 12 series', 15, 19000, '2021-10-04', N'Chiếc iPhone siêu nhỏ gọn nhưng mạnh mẽ', 'images/ip1.jpg', 1),
('ip2', N'iphone 11 series', 30, 16000, '2020-10-04', N'Chiếc iPhone siêu nhỏ gọn nhưng mạnh mẽ', 'images/ip2.jpg', 1),
('ip3', N'iphone X series', 22, 13000, '2019-10-04', N'Chiếc iPhone siêu nhỏ gọn nhưng mạnh mẽ', 'images/ip3.jpg', 1),

('opp1', N'oppo find x series', 12, 13000, '2021-10-04', N'Camera selfie đỉnh cao và thiết kế thời thượng', 'images/opp1.jpg', 3),
('opp2', N'oppo find x series', 12, 13000, '2021-10-04', N'Camera selfie đỉnh cao và thiết kế thời thượng', 'images/opp2.jpg', 3),
('opp3', N'oppo find x series', 12, 13000, '2021-10-04', N'Camera selfie đỉnh cao và thiết kế thời thượng', 'images/opp3.jpg', 3),
('opp4', N'oppo find x series', 12, 13000, '2021-10-04', N'Camera selfie đỉnh cao và thiết kế thời thượng', 'images/opp4.jpg', 3),

('ss1', N'Galaxy Z series', 20, 20000, '2021-10-04', N'Thiết kế màn hình gập độc đáo, sang trọng', 'images/ss1.jpg', 2),
('ss2', N'galaxy note series', 15, 18000, '2021-10-04', N'Dòng điện thoại kèm bút S-Pen huyền thoại', 'images/ss2.jpg', 2),
('ss3', N'galaxy F series', 25, 16000, '2021-10-04', N'Màn hình lớn, pin trâu phù hợp học sinh', 'images/ss3.jpg', 2),
('ss4', N'galaxy H series', 10, 15000, '2021-10-04', N'Mẫu điện thoại Samsung với hiệu năng ổn định', 'images/ss4.jpg', 2),

('vsm1', N'Vsmart Joy 4 3GB-64GB', 50, 13000, '2021-10-04', N'Điện thoại quốc dân Việt Nam, cấu hình tốt', 'images/vsm1.jpg', 4),
('vsm2', N'Vsmart Joy 4 3GB-64GB', 50, 13000, '2021-10-04', N'Điện thoại quốc dân Việt Nam, cấu hình tốt', 'images/vsm2.jpg', 4),
('vsm3', N'Vsmart Joy 4 3GB-64GB', 50, 13000, '2021-10-04', N'Điện thoại quốc dân Việt Nam, cấu hình tốt', 'images/vsm3.jpg', 4),
('vsm4', N'Vsmart Joy 4 3GB-64GB', 50, 13000, '2021-10-04', N'Điện thoại quốc dân Việt Nam, cấu hình tốt', 'images/vsm4.jpg', 4);

-- 1. Thêm tài khoản trước
INSERT INTO Accounts (username, password, role) VALUES 
('admin', '123', 1), 
('user1', '123', 0), 
('user2', '123', 0);

-- 2. Thêm khách hàng (Thêm địa chỉ để dữ liệu đầy đủ)
INSERT INTO Customers (username, fullname, email, phone, address, points) VALUES 
('user1', N'Nguyễn Văn A', 'a@gmail.com', '0912345678', N'Hà Nội', 500),
('user2', N'Trần Thị B', 'b@gmail.com', '0988888888', N'TP.HCM', 1200);
INSERT INTO Vouchers (code, discountValue, expirationDate, minOrderValue, quantity) VALUES 
('GIAM20K', 2000.00, '2025-11-30', 2000.00, 100),
('HE2026', 5000.00, '2026-11-30', 5000.00, 50),
('FREESHIP', 3000.00, '2026-11-01', 0.00, 1000);
-- 3. Nhập kho
INSERT INTO Suppliers (name, phone, address) VALUES (N'Tổng kho Apple Miền Bắc', '0243333444', N'Bắc Ninh');
INSERT INTO StockIn (sid, admin_user, total_cost) VALUES (1, 'admin', 500000);
INSERT INTO StockInDetails (stock_id, pid, quantity, purchase_price) VALUES (1, 'ip1', 10, 15000); 

-- 4. Đơn hàng (Cần có Order trước rồi mới có OrderDetails)
INSERT INTO Orders 
(date, totalmoney, status, username, receiver_name, receiver_phone, shipping_address, voucher_code) 
VALUES 
(GETDATE(), 19000, 2, 'user1', N'Nguyễn Văn A', '0912345678', N'Hà Nội', NULL);

-- 5. Chi tiết đơn hàng (Đã sửa khớp 8 cột)
INSERT INTO OrderDetails 
(oid, pid, quantity, price) 
VALUES 
(1, 'ip1', 1, 19000);

-- 6. Các thông tin bổ trợ khác
INSERT INTO Wishlist (username, pid) VALUES ('user2', 'ss1');

-- 7. Giỏ hàng
INSERT INTO Cart (username, pid, quantity) VALUES 
('user1', 'ip1', 2),
('user1', 'ss1', 1),
('user2', 'vsm1', 5);
GO
SELECT * FROM Categories;
SELECT * FROM Cart;
SELECT * FROM Products;
SELECT * FROM Accounts;
SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM OrderDetails;
SELECT * FROM StockIn;