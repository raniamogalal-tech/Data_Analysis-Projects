select * from Categories
select * from CustomerCustomerDemo
select * from CustomerDemographics
select * from Customers
select * from Employees
select * from EmployeeTerritories
select * from [Order Details]
select * from Orders
select * from Products
select * from Region
select * from Shippers
select * from Suppliers
select * from Territories

select CompanyName,ISNULL(Phone , 'no number') as phone from Customers 

update Customers set Region='unknown' where Region Is null
 select Region from Customers

 select CompanyName,City from Customers order by Country

 select c.CompanyName, o.OrderID, o.OrderDate from Customers c inner join Orders o on c.CustomerID = o.CustomerID

select o.OrderID, p.ProductName, od.Quantity from [Order Details] od
INNER JOIN Orders o on o.OrderID = od.OrderID
INNER JOIN Products p on p.ProductID = od.ProductID

select e.FirstName + ' ' + e.LastName AS EmployeeName,o.OrderID,o.OrderDate from Orders o
INNER JOIN Employees e on e.EmployeeID = o.EmployeeID

select p.ProductName,od.Quantity,od.UnitPrice,(od.Quantity * od.UnitPrice)
AS TotalPrice from [Order Details] od
INNER JOIN Products p on p.ProductID = od.ProductID
