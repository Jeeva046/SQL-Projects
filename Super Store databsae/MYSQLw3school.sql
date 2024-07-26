SELECT * FROM categories;
SELECT * FROM customers;
SELECT * FROM employees;
SELECT * FROM order_details;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM shippers;
SELECT * FROM suppliers;



-- Basic Queries
-- What are the names of all customers from the Customers table?
select distinct Customername, Country 
FROM customers;

-- Retrieve all products and their prices from the Products table.
SELECT ProductName , Price
FROM products;

-- Filtering Data
-- List all customers located in the 'USA' from the Customers table.
SELECT CustomerName, Country
FROM Customers
WHERE country = 'USA';

-- Find all employees who were born after January 1, 1960, from the Employees table.
SELECT EmployeeID, concat_ws(" ",Firstname,lastname) AS EmployeeName, Birthdate
FROM employees
WHERE year(Birthdate) >= 1960;

-- Joins
-- Retrieve a list of all orders along with the customer names and the shipper names.
SELECT o.OrderID, c.CustomerName AS "Customer's Name", s.shippername AS "Shipper's Name"
FROM orders o JOIN customers c ON o.customerid = c.customerid
JOIN shippers s ON o.shipperid = s.shipperid;

-- Get a list of all products along with their category names.
SELECT p.ProductName, c.categoryName
FROM Products p JOIN Categories c ON p.categoryID = c.categoryID
ORDER BY c.categoryName;


-- Aggregation and Grouping
-- Find the total number of orders placed by each customer.
SELECT c.CustomerID, c.CustomerName, Count(o.orderid) AS "NO. of orders placed"
FROM customers c JOIN orders o ON c.customerid = o.customerid
GROUP BY c.customerid
ORDER BY Count(o.orderid) DESC;

-- Calculate the total quantity of products ordered for each product.
SELECT  p.ProductName,  count(od.orderid) AS "Total Quantity Ordered"
FROM Products p JOIN order_details od ON p.productid = od.productid
GROUP BY p.ProductName
ORDER BY Count(od.orderid) DESC;

-- Complex Queries
-- List all employees who have handled orders in the Month of July 1996. 
SELECT e.employeeid, concat_ws(" ",e.Firstname,e.lastname) AS EmployeeName, 
	   count(o.orderid) AS "No. of orders handled"
FROM employees e
JOIN orders o ON e.employeeid = o.employeeid
WHERE year(orderdate) = 1996 AND month(orderdate) = 7
GROUP BY e.employeeid
ORDER BY count(o.orderid) DESC;

-- Find the most popular product category based on the number of products ordered.
SELECT c.CategoryName, Count(o.orderID) AS "Total Count", 
       DENSE_RANK() OVER( ORDER BY Count(o.orderID) DESC) AS "Rank"
FROM categories c JOIN Products p 
     ON c.categoryid = p.categoryid
JOIN order_details o ON p.productid = o.productid
GROUP BY c.CategoryName
ORDER BY Count(o.orderID) DESC;


-- Subqueries
-- List the products that have never been ordered.
SELECT Productname
FROM products
WHERE productID  IN (SELECT productID 
                        FROM order_details);

-- Find the customers who have placed orders with a total quantity greater than 150.
SELECT ContactName, City, CustomerID, Country 
FROM customers
WHERE customerID IN (SELECT customerID 
                     FROM orders
                     WHERE orderID IN (SELECT orderID
                                       FROM order_details 
                                       GROUP BY orderID 
                                       HAVING SUM(quantity) > 150));


-- Updating and Deleting Data
-- Update the contact name for a specific customer.
-- Delete all orders placed by a specific customer.


-- These questions will help you cover a wide range of SQL operations, from basic retrieval to complex joins and aggregations.


/*Select Total orders for each shipping company*/
SELECT s.ShipperName, 
	   Count(o.OrderID) AS "No. of Orders" 
FROM orders o
JOIN shippers s ON o.shipperid = s.shipperid
GROUP BY  s.ShipperName
ORDER BY Count(o.OrderID) DESC;

/*Select the first, second most expensive product*/
SELECT ProductName, Price 
FROM products
ORDER by price DESC
limit 2;

/*Select name of the cheapest product (only name) using subquery*/
SELECT ProductName 
FROM products
WHERE productID= (SELECT ProductID 
				  FROM products
                  ORDER BY price ASC
                  limit 1);

/*Select shipper together with the total price of proceed orders*/
with pricing AS ( SELECT od.orderID,od.Quantity * p.Price AS Order_price, o.shipperid
                  FROM order_details od
				  JOIN products p ON od.productid = p.productid
                  JOIN orders o ON od.orderid = o.orderid
                  )
Select s.Shippername, sum(p.order_price) AS Total_order_price
from Pricing p
JOIN shippers s ON p.shipperid = s.shipperid 
group by s.shippername
order by Total_order_price DESC;

/*Create a view with order price and other details needed together*/
Create View order_price AS ( 
                  SELECT od.orderID,o.customerid, od.Quantity * p.Price AS Order_price, o.shipperid, o.employeeid
                  FROM order_details od
				  JOIN products p ON od.productid = p.productid
                  JOIN orders o ON od.orderid = o.orderid
                  
);


/*Select customer who spend the  most money top 2*/
select  op.customerid,c.contactname, sum(op.order_price) AS Purchase_price
from order_price op
JOIN Customers c ON op.customerid = c.customerid
GROUP BY op.customerid
ORDER BY Purchase_price DESC
LIMIT 2;

/*Select orderID together with the total price of  that Order*/
SELECT OrderID, Order_price
FROM order_price;

/*select highest amount of order price */
SELECT OrderID, MAX(Order_Price)
FROM order_price 
GROUP BY orderID;

/*select country and their order price*/
SELECT c.Country , Sum(o.order_price) AS Order_price_by_country
FROM order_price o
JOIN customers c ON o.customerID = c.CustomerID
GROUP BY C.country
ORDER BY Order_price_by_country DESC;

/*select ordered price for each month*/
SELECT month(o.OrderDate), 
       CAST(SUM(op.order_price) AS DECIMAL(10, 2)) AS Total_Spending, 
       RANK() OVER (ORDER BY SUM(op.order_price)  DESC) AS SpendingRank
FROM order_price op
JOIN orders o ON op.orderID = o.orderID
group by month(OrderDate)
ORDER BY month(OrderDate);

/*select supplier with highest number of orders 
processed and total amount of order per supplier*/
SELECT s.SupplierName,  
	   count(op.orderID) AS "No. of orders processed", 
       CAST(SUM(op.order_price) AS DECIMAL(10, 2)) AS Total_earnings
FROM Suppliers s 
JOIN products p ON s.supplierID = p.supplierID
JOIN order_details od ON p.productid = od.productid
JOIN order_price op ON od.orderID = op.orderID 
group by s.SupplierName
order by Total_earnings desc;

/*select employees and their revenue generated for company */
select e.EmployeeID, concat_ws(" ",e.firstname,e.lastname) AS Employee_name , 
       CAST(SUM(op.order_price) AS DECIMAL(10, 2)) AS Employee_revenue,
       Dense_rank() OVER(ORDER BY SUM(op.order_price) DESC) AS "Rank by revenue"
FROM Employees e
JOIN orders o ON e.employeeID = o.employeeID
JOIN order_price op ON o.orderID = op.orderID
GROUP BY e.EmployeeID;


/*Find the total revenue of Super store*/
SELECT CAST(SUM(order_price) AS DECIMAL(10, 2)) AS Total_revenue
FROM order_price;

