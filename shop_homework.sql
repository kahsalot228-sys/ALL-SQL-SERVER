/*
    Домашнее задание: уроки 13–14
    Тема: Shop — магазин товаров
    СУБД: Microsoft SQL Server
    Запуск: откройте скрипт в SSMS и выполните целиком (F5).

    Скрипт создаёт отдельную схему ShopHW, 5 связанных таблиц
    и заполняет их демонстрационными данными.
*/

SET NOCOUNT ON;
GO

-- 1. Создание схемы
IF SCHEMA_ID(N'ShopHW') IS NULL
    EXEC(N'CREATE SCHEMA ShopHW');
GO

-- 2. Удаление таблиц в порядке зависимостей (чтобы скрипт можно было запускать повторно)
DROP TABLE IF EXISTS ShopHW.OrderItems;
DROP TABLE IF EXISTS ShopHW.Orders;
DROP TABLE IF EXISTS ShopHW.Products;
DROP TABLE IF EXISTS ShopHW.Categories;
DROP TABLE IF EXISTS ShopHW.Customers;
GO

-- 3. Таблица покупателей
CREATE TABLE ShopHW.Customers
(
    CustomerID INT IDENTITY(1,1) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(120) NOT NULL UNIQUE,
    Phone NVARCHAR(25) NULL,
    City NVARCHAR(60) NOT NULL,
    CONSTRAINT PK_Customers PRIMARY KEY (CustomerID)
);
GO

-- 4. Таблица категорий товаров
CREATE TABLE ShopHW.Categories
(
    CategoryID INT IDENTITY(1,1) NOT NULL,
    CategoryName NVARCHAR(80) NOT NULL UNIQUE,
    Description NVARCHAR(250) NULL,
    CONSTRAINT PK_Categories PRIMARY KEY (CategoryID)
);
GO

-- 5. Таблица товаров
CREATE TABLE ShopHW.Products
(
    ProductID INT IDENTITY(1,1) NOT NULL,
    ProductName NVARCHAR(100) NOT NULL,
    CategoryID INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    StockQuantity INT NOT NULL,
    CONSTRAINT PK_Products PRIMARY KEY (ProductID),
    CONSTRAINT FK_Products_Categories
        FOREIGN KEY (CategoryID) REFERENCES ShopHW.Categories(CategoryID),
    CONSTRAINT CK_Products_Price CHECK (Price >= 0),
    CONSTRAINT CK_Products_Stock CHECK (StockQuantity >= 0)
);
GO

-- 6. Таблица заказов
CREATE TABLE ShopHW.Orders
(
    OrderID INT IDENTITY(1,1) NOT NULL,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    OrderStatus NVARCHAR(30) NOT NULL,
    CONSTRAINT PK_Orders PRIMARY KEY (OrderID),
    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (CustomerID) REFERENCES ShopHW.Customers(CustomerID)
);
GO

-- 7. Таблица состава заказа
CREATE TABLE ShopHW.OrderItems
(
    OrderItemID INT IDENTITY(1,1) NOT NULL,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_OrderItems PRIMARY KEY (OrderItemID),
    CONSTRAINT FK_OrderItems_Orders
        FOREIGN KEY (OrderID) REFERENCES ShopHW.Orders(OrderID),
    CONSTRAINT FK_OrderItems_Products
        FOREIGN KEY (ProductID) REFERENCES ShopHW.Products(ProductID),
    CONSTRAINT CK_OrderItems_Quantity CHECK (Quantity > 0),
    CONSTRAINT CK_OrderItems_UnitPrice CHECK (UnitPrice >= 0),
    CONSTRAINT UQ_OrderItems_Order_Product UNIQUE (OrderID, ProductID)
);
GO

-- 8. Заполнение покупателей
INSERT INTO ShopHW.Customers (FirstName, LastName, Email, Phone, City)
VALUES
(N'Иван', N'Иванов', N'ivan.ivanov@example.com', N'+7-900-111-11-11', N'Москва'),
(N'Анна', N'Петрова', N'anna.petrova@example.com', N'+7-900-222-22-22', N'Санкт-Петербург'),
(N'Максим', N'Сидоров', N'maxim.sidorov@example.com', N'+7-900-333-33-33', N'Казань'),
(N'Мария', N'Смирнова', N'maria.smirnova@example.com', N'+7-900-444-44-44', N'Новосибирск'),
(N'Алексей', N'Кузнецов', N'alexey.kuznetsov@example.com', N'+7-900-555-55-55', N'Екатеринбург');
GO

-- 9. Заполнение категорий
INSERT INTO ShopHW.Categories (CategoryName, Description)
VALUES
(N'Электроника', N'Компьютеры, телефоны и аксессуары'),
(N'Одежда', N'Одежда и аксессуары'),
(N'Дом и кухня', N'Товары для дома и кухни'),
(N'Книги', N'Печатные и учебные издания'),
(N'Спорт', N'Спортивные товары и инвентарь');
GO

-- 10. Заполнение товаров
INSERT INTO ShopHW.Products (ProductName, CategoryID, Price, StockQuantity)
VALUES
(N'Беспроводные наушники', 1, 4990.00, 25),
(N'Компьютерная мышь', 1, 1290.00, 40),
(N'Футболка', 2, 1490.00, 60),
(N'Спортивная толстовка', 2, 3490.00, 20),
(N'Кружка', 3, 490.00, 100),
(N'Настольная лампа', 3, 2190.00, 18),
(N'Книга по SQL', 4, 1590.00, 15),
(N'Роман', 4, 890.00, 30),
(N'Гантели', 5, 1990.00, 22),
(N'Коврик для йоги', 5, 1290.00, 35);
GO

-- 11. Заполнение заказов
INSERT INTO ShopHW.Orders (CustomerID, OrderDate, OrderStatus)
VALUES
(1, '2026-09-15', N'Выполнен'),
(2, '2026-09-16', N'В обработке'),
(3, '2026-09-17', N'Отправлен'),
(1, '2026-09-20', N'Выполнен'),
(4, '2026-09-22', N'Новый'),
(5, '2026-09-25', N'Отменён');
GO

-- 12. Заполнение состава заказов
INSERT INTO ShopHW.OrderItems (OrderID, ProductID, Quantity, UnitPrice)
VALUES
(1, 1, 1, 4990.00),
(1, 5, 2, 490.00),
(2, 2, 1, 1290.00),
(2, 7, 1, 1590.00),
(3, 3, 3, 1490.00),
(3, 9, 1, 1990.00),
(4, 6, 1, 2190.00),
(4, 8, 2, 890.00),
(5, 4, 1, 3490.00),
(6, 10, 2, 1290.00);
GO

-- 13. Проверка: выводим содержимое всех пяти таблиц
SELECT * FROM ShopHW.Customers;
SELECT * FROM ShopHW.Categories;
SELECT * FROM ShopHW.Products;
SELECT * FROM ShopHW.Orders;
SELECT * FROM ShopHW.OrderItems;
GO

-- 14. Пример полезного запроса: заказы с покупателем и товарами
SELECT
    o.OrderID,
    o.OrderDate,
    o.OrderStatus,
    CONCAT(c.FirstName, N' ', c.LastName) AS CustomerName,
    p.ProductName,
    oi.Quantity,
    oi.UnitPrice,
    oi.Quantity * oi.UnitPrice AS LineTotal
FROM ShopHW.Orders AS o
INNER JOIN ShopHW.Customers AS c ON c.CustomerID = o.CustomerID
INNER JOIN ShopHW.OrderItems AS oi ON oi.OrderID = o.OrderID
INNER JOIN ShopHW.Products AS p ON p.ProductID = oi.ProductID
ORDER BY o.OrderID, p.ProductName;
GO
