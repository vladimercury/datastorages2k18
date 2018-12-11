insert into shopdb.Customer (CustomerID, CompanyName, ContactName, City, Address, Email, PhoneNumber)
select cd.CustomerID, cd.CompanyName, cd.ContactName, cd.City, cd.Address, cd.Email, cd.PhoneNumber from shopstore.CustomerDim cd
/*where CustomerID not in (select CustomerID from shopdb.Customer)*/
on duplicate key update CustomerID = cd.CustomerID;

insert into shopdb.Product (ProductID, Name, Measure, Price)
select * from
(select pd.ProductID, pd.Name, pd.Measure, sf.ProductPrice from shopstore.ProductDim pd
	left join shopstore.SalesFact sf
		on sf.ProductKey = pd.ProductKey
	group by pd.ProductID) t
/*where ProductID not in (select ProductID from shopdb.Product)*/
on duplicate key update Price = t.ProductPrice;

insert into shopdb.ShipmentType (ShipmentTypeID, Name, Description)
select ShipmentTypeID, Name, Description from shopstore.ShipmentDim shd
/*where ShipmentTypeID not in (select ShipmentTypeID from shopdb.ShipmentType)*/
on duplicate key update ShipmentTypeID = shd.ShipmentTypeID;

insert into shopdb.OrderStatus (OrderStatusID, Name)
select OrderStatusID, Name from shopstore.StatusDim sd
/*where OrderStatusID not in (select OrderStatusID from shopdb.OrderStatus)*/
on duplicate key update OrderStatusID = sd.OrderStatusID;

insert into shopdb.Orders (OrderID, OrderStatusID, CustomerID, TransportTypeID, CreationDate, PlannedDate, ShipmentDate)
select * from
(select od.OrderID, sd.OrderStatusID, cd.CustomerID, shd.ShipmentTypeId, od.CreationDate, od.PlannedDate, od.ShipmentDate
from shopstore.OrderDim od
	inner join shopstore.SalesFact sf
		on sf.OrderKey = od.OrderKey
	inner join shopstore.StatusDim sd
		on sf.StatusKey = sd.StatusKey
	inner join shopstore.CustomerDim cd
		on sf.CustomerKey = cd.CustomerKey
	inner join shopstore.ShipmentDim shd
		on sf.ShipmentKey = shd.ShipmentKey
	group by od.OrderId) t
/*where OrderID not in (select OrderID from shopdb.Orders)*/
on duplicate key update OrderStatusID = t.OrderStatusID, ShipmentDate = t.ShipmentDate;

insert into shopdb.OrderPosition (OrderPositionID, OrderID, ProductID, Quantity, CurrentPrice)
select sf.OrderPositionID, od.OrderID, pd.ProductID, sf.Quantity, sf.SalePrice
from shopstore.SalesFact sf
	inner join shopstore.OrderDim od
		on sf.OrderKey = od.OrderKey
	inner join shopstore.ProductDim pd
		on sf.ProductKey = pd.ProductKey
/*where OrderPositionID not in (select OrderPositionID from shopdb.OrderPosition)*/
on duplicate key update OrderPositionID = sf.OrderPositionID;
	