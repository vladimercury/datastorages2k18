insert into shopstore.CustomerDim (CustomerID, CompanyName, ContactName, City, Address, Email, PhoneNumber)
select CustomerID, CompanyName, ContactName, City, Address, Email, PhoneNumber from shopdb.Customer
where CustomerID not in (select CustomerID from shopstore.CustomerDim);

insert into shopstore.ProductDim (ProductID, Name, Measure)
select ProductID, Name, Measure from shopdb.Product
where ProductID not in (select ProductID from shopstore.ProductDim);

insert into shopstore.Shipmentdim (ShipmentTypeID, Name)
select ShipmentTypeID, Name from shopdb.shipmenttype
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
	
insert into shopstore.DateDim (DateYear, DateMonth, DateDay, IsWeekend, IsHoliday)
select YEAR(od.CreationDate), MONTH(od.CreationDate), DAY(od.CreationDate), WEEKDAY(od.CreationDate) > 4, IsHolidayDate(od.CreationDate) from shopstore.OrderDim od
	where DATE(od.CreationDate) NOT IN (
		select IF (dd.DateYear IS NOT NULL, STR_TO_DATE(CONCAT_WS("-", dd.DateYear, dd.DateMonth, dd.DateDay), "%Y-%m-%d"), NULL) from shopstore.DateDim dd
	);

insert into shopstore.DateDim (DateYear, DateMonth, DateDay, IsWeekend, IsHoliday)
select YEAR(od.PlannedDate), MONTH(od.PlannedDate), DAY(od.PlannedDate), WEEKDAY(od.PlannedDate) > 4, IsHolidayDate(od.PlannedDate) from shopstore.OrderDim od
	where DATE(od.PlannedDate) NOT IN (
		select IF (dd.DateYear IS NOT NULL, STR_TO_DATE(CONCAT_WS("-", dd.DateYear, dd.DateMonth, dd.DateDay), "%Y-%m-%d"), NULL) from shopstore.DateDim dd
	);

insert into shopstore.DateDim (DateYear, DateMonth, DateDay, IsWeekend, IsHoliday)
select YEAR(od.ShipmentDate), MONTH(od.ShipmentDate), DAY(od.ShipmentDate), WEEKDAY(od.ShipmentDate) > 4, IsHolidayDate(od.ShipmentDate) from shopstore.OrderDim od
	where DATE(od.ShipmentDate) NOT IN (
		select IF (dd.DateYear IS NOT NULL, STR_TO_DATE(CONCAT_WS("-", dd.DateYear, dd.DateMonth, dd.DateDay), "%Y-%m-%d"), NULL) from shopstore.DateDim dd
	);

insert into shopstore.DateDim (DateYear)
	select NULL
	where SELECT COUNT(*) FROM (
		select IFNULL(dd.DateYear, 1) from shopstore.DateDim dd
		WHERE dd.DateYear IS NULL
		LIMIT 1
	) x;

drop function IsHolidayDate;

insert into shopstore.SalesFact (ProductKey, CustomerKey, OrderKey, StatusKey, ShipmentKey, CreationDateKey, PlannedDateKey, ShipmentDateKey, OrderPositionID, Quantity, SalePrice, ProductPrice)
select pd.ProductKey, cd.CustomerKey, od.OrderKey, sd.StatusKey, shd.ShipmentKey, 1, 1, 1, op.OrderPositionID, op.Quantity, op.CurrentPrice, p.Price from shopdb.orderposition op
	left join shopdb.orders o
		on op.OrderID = o.OrderID
	left join shopdb.product p
		on op.ProductID = p.ProductID
	left join shopstore.ProductDim pd
		on op.ProductID = pd.ProductID
	left join shopstore.CustomerDim cd
		on o.CustomerID = cd.CustomerID
	left join shopstore.OrderDim od
		on op.OrderID = od.OrderID
	left join shopstore.StatusDim sd
		on o.OrderStatusID = sd.StatusKey
	left join shopstore.Shipmentdim shd
		on o.TransportTypeID = shd.ShipmentTypeID
where op.OrderPositionID not in (select sf2.OrderPositionID from shopstore.SalesFact sf2);