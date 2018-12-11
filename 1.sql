insert into shopdb.Product (Name, Measure, Price)
values
	('Вода', 'т', 1.04)
ON DUPLICATE KEY UPDATE Price = Price;

set @productId = LAST_INSERT_ID();
	
insert into shopdb.Customer (CompanyName, ContactName, City, Address, Email, PhoneNumber)
values
	('ИТМО', 'Владимир Курий', 'Санкт Петербург', 'Кронверский 49', 'dummy@mail.com', '+7 123 45 67');

set @custId = LAST_INSERT_ID();
	
insert into shopdb.orders (OrderStatusID, CustomerID, TransportTypeID, CreationDate, PlannedDate, ShipmentDate)
select os.OrderStatusID, @custId, st.ShipmentTypeID, '2018-01-19 19:41', '2018-01-31 12:01', NULL
	from shopdb.orderstatus os, shopdb.shipmenttype st
	where os.Name = 'Preparing' AND st.Name = 'Railroad' LIMIT 1;
	
set @orderId = LAST_INSERT_ID();

insert into shopdb.orderposition (OrderID, ProductID, Quantity, CurrentPrice)
select @orderId, p.ProductID, 10, p.Price
	from shopdb.Product p
	where p.Name = 'Вода'
union all
select @orderId, p.ProductID, 10, p.Price
	from shopdb.Product p
	where p.Name = 'Iron'