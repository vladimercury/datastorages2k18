insert into shopstore.CustomerDim (CustomerID, CompanyName, ContactName, City, Address, Email, PhoneNumber)
select CustomerID, CompanyName, ContactName, City, Address, Email, PhoneNumber from shopdb.Customer
where CustomerID not in (select CustomerID from shopstore.CustomerDim);

insert into shopstore.ProductDim (ProductID, Name, Measure)
select ProductID, Name, Measure from shopdb.Product
where ProductID not in (select ProductID from shopstore.ProductDim);

insert into shopstore.Shipmentdim (ShipmentTypeID, Name, Description)
select ShipmentTypeID, Name, Description from shopdb.shipmenttype
where ShipmentTypeID not in (select ShipmentTypeID from shopstore.Shipmentdim);

insert into shopstore.StatusDim (OrderStatusID, Name)
select OrderStatusID, Name from shopdb.orderstatus
where OrderStatusID not in (select OrderStatusID from shopstore.StatusDim);

insert into shopstore.OrderDim (OrderID, CreationDate, PlannedDate, ShipmentDate)
select OrderID, CreationDate, PlannedDate, ShipmentDate from shopdb.orders
where OrderID not in (select OrderID from shopstore.OrderDim);

drop function if exists IsHolidayDate;
create function IsHolidayDate (dDate DATE)
	returns tinyint
	return DATE_FORMAT(dDate, "%d-%m") in (
		"01-01", "02-01", "03-01", 
		"04-01", "05-01", "06-01", 
		"07-01", "08-01", "23-02", 
		"08-03", "01-05", "09-05", 
		"12-06", "04-11"
	);

insert into shopstore.DateDim (DateYear)
	select NULL
	where (select COUNT(IFNULL(dd.DateYear, 1)) from shopstore.DateDim dd
		WHERE dd.DateYear IS NULL) = 0;
		
insert into shopstore.DateDim (DateYear, DateMonth, DateDay, IsWeekend, IsHoliday)
select YEAR(od.CreationDate) as yr, MONTH(od.CreationDate) as mt, DAY(od.CreationDate) as dy, WEEKDAY(od.CreationDate) > 4, IsHolidayDate(od.CreationDate) from shopstore.OrderDim od
	where DATE(od.CreationDate) NOT IN (
		select STR_TO_DATE(CONCAT_WS("-", dd.DateYear, dd.DateMonth, dd.DateDay), "%Y-%m-%d") from shopstore.DateDim dd
	)
	group by yr, mt, dy;

insert into shopstore.DateDim (DateYear, DateMonth, DateDay, IsWeekend, IsHoliday)
select YEAR(od.PlannedDate) as yr, MONTH(od.PlannedDate) as mt, DAY(od.PlannedDate) as dy, WEEKDAY(od.PlannedDate) > 4, IsHolidayDate(od.PlannedDate) from shopstore.OrderDim od
	where DATE(od.PlannedDate) NOT IN (
		select STR_TO_DATE(CONCAT_WS("-", dd.DateYear, dd.DateMonth, dd.DateDay), "%Y-%m-%d") from shopstore.DateDim dd
	)
	group by yr, mt, dy;

insert into shopstore.DateDim (DateYear, DateMonth, DateDay, IsWeekend, IsHoliday)
select YEAR(od.ShipmentDate) as yr, MONTH(od.ShipmentDate) as mt, DAY(od.ShipmentDate) as dy, WEEKDAY(od.ShipmentDate) > 4, IsHolidayDate(od.ShipmentDate) from shopstore.OrderDim od
	where DATE(od.ShipmentDate) NOT IN (
		select STR_TO_DATE(CONCAT_WS("-", dd.DateYear, dd.DateMonth, dd.DateDay), "%Y-%m-%d") from shopstore.DateDim dd
	)
	group by yr, mt, dy;

	
drop function IsHolidayDate;

insert into shopstore.SalesFact (ProductKey, CustomerKey, OrderKey, StatusKey, ShipmentKey, CreationDateKey, PlannedDateKey, ShipmentDateKey, OrderPositionID, Quantity, SalePrice, ProductPrice)
select pd.ProductKey, cd.CustomerKey, od.OrderKey, sd.StatusKey, shd.ShipmentKey, ddc.DateKey, ddp.DateKey, dds.DateKey, op.OrderPositionID, op.Quantity, op.CurrentPrice, p.Price from shopdb.orderposition op
	inner join shopdb.orders o
		on op.OrderID = o.OrderID
	inner join shopdb.product p
		on op.ProductID = p.ProductID
	inner join shopstore.ProductDim pd
		on op.ProductID = pd.ProductID
	inner join shopstore.CustomerDim cd
		on o.CustomerID = cd.CustomerID
	inner join shopstore.OrderDim od
		on op.OrderID = od.OrderID
	inner join shopstore.StatusDim sd
		on o.OrderStatusID = sd.StatusKey
	inner join shopstore.Shipmentdim shd
		on o.TransportTypeID = shd.ShipmentTypeID
	inner join shopstore.DateDim ddc
		on DATE(o.CreationDate) = STR_TO_DATE(CONCAT_WS("-", ddc.DateYear, ddc.DateMonth, ddc.DateDay), "%Y-%m-%d")
	inner join shopstore.DateDim ddp
		on DATE(o.PlannedDate) = STR_TO_DATE(CONCAT_WS("-", ddp.DateYear, ddp.DateMonth, ddp.DateDay), "%Y-%m-%d")
	inner join shopstore.DateDim dds
		on DATE(o.ShipmentDate) = STR_TO_DATE(CONCAT_WS("-", dds.DateYear, dds.DateMonth, dds.DateDay), "%Y-%m-%d") OR (o.ShipmentDate IS NULL AND dds.DateYear IS NULL)
where op.OrderPositionID not in (select sf2.OrderPositionID from shopstore.SalesFact sf2);

insert into shopwindow.DailySales (ProductID, ProductName, ProductMeasure, TotalQuantity, TotalPrice, OrderDay, OrderMonth, OrderYear)
	select p.ProductID, p.Name, p.Measure, SUM(op.Quantity), SUM(op.CurrentPrice * op.Quantity), DAY(o.CreationDate), MONTH(o.CreationDate), YEAR(o.CreationDate) from shopdb.Product p
		inner join shopdb.OrderPosition op
			on op.ProductID = p.ProductID
		inner join shopdb.Orders o
			on op.OrderID = o.OrderID
		group by p.ProductID, p.Name, p.Measure, DATE(o.CreationDate)
	on duplicate key update TotalQuantity = VALUES(TotalQuantity), TotalPrice = VALUES(TotalPrice);