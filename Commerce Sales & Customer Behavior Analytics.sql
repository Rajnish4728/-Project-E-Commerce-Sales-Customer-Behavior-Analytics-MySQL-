CREATE DATABASE Ecommerce;
USE Ecommerce;

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Email VARCHAR(150),
    Gender VARCHAR(10),
    CITY VARCHAR(100),
    JoinDate DATE 
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(100),
    Price DECIMAL(10,2),
    StockQuantity INT 
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    ReviewText TEXT,
    ReviewDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Returns (
    ReturnID INT PRIMARY KEY,
    OrderDetailID INT,
    ReturnReason VARCHAR(255),
    ReturnDate DATE,
    FOREIGN KEY (OrderDetailID) REFERENCES OrderDetails(OrderDetailID)
);

#1.Top 5 Products by Total Revenue

CREATE VIEW Top_5_Products_By_Total_Revenue AS
SELECT
    p.ProductName,
    SUM(od.Quantity * p.Price) AS TotalRevenue
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductID
ORDER BY TotalRevenue DESC
LIMIT 5;

USE ecommerce;
#2. Most Active Customers (by Number of Orders)

CREATE VIEW Most_Active_Customers_By_Number_Of_Orders AS
SELECT
    c.FirstName,c.LastName,
    COUNT(o.OrderID) AS TotalOrders
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
ORDER BY TotalOrders DESC
LIMIT 5;

#3. Monthly Sales Revenue

CREATE VIEW Monthly_Sales_Revenue AS
SELECT
    DATE_FORMAT(o.OrderDate, '%Y-%m') AS Month,
    SUM(od.Quantity * p.Price) AS MonthlyRevenue
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = P.ProductID
GROUP BY Month
ORDER BY Month;

#4. Products with Highest Return Rate

CREATE VIEW Products_With_Highest_Return_Rate AS
SELECT
    p.ProductName,
    COUNT(r.ReturnID) AS TotalReturns,
    COUNT(r.ReturnID) * 1.0 /COUNT(od.OrderDetailID) AS ReturnRate
FROM Returns r
JOIN OrderDetails od ON r.OrderDetailID = od.OrderDetailID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductID
ORDER BY ReturnRate DESC
LIMIT 5;

#5. Average Product Rating by Category

CREATE VIEW Average_Product_Rating_By_Category AS
SELECT
    p.Category,
    ROUND(AVG(r.Rating),2) AS AvgRating
FROM Reviews r
JOIN Products p ON r.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY AvgRating DESC;

#6. Low Stock Products (Below 20 Units)

CREATE VIEW Low_Stock_Products_Below_20_Units AS
SELECT
    ProductName,
    StockQuantity
FROM Products
WHERE StockQuantity < 20
ORDER BY StockQuantity ASC;

#7. Create View: Customer Purchase Summary

CREATE VIEW CustomerPurchaseSummary AS
SELECT
    c.CustomerID,
    CONCAT(c.FirstName,' ',c.LastName) AS CustomerName,
    COUNT(o.OrderID) AS TotalOrders,
    SUM(od.Quantity * p.Price) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CustomerID;

#8. Stored Procedure: Deduct Stock After New Order

DELIMITER //

CREATE PROCEDURE DeductStock(IN in_ProductID INT,IN in_Quantity INT)
BEGIN
    UPDATE Products
    SET StockQuantity = StockQuantity - in_Quantity
    WHERE ProductID = in_ProductID;
END //

DELIMITER ;

#9. Top Cities by Number of Customers

CREATE VIEW Top_Cities_By_Number_Of_Customers AS
SELECT 
    City,
    COUNT(CustomerID) AS TotalCustomers
FROM Customers
GROUP BY City
Order BY TotalCustomers DESC
LIMIT 5;

#10. Total Revenue by Product Category

CREATE VIEW Total_Revenue_By_Product_Category AS

SELECT
    p.Category,
    SUM(od.Quantity * p.Price) AS TotalRevenue
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY TotalRevenue DESC;






























































































































