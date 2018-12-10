insert into shopwindow.DailySales (ProductID, ProductName, ProductMeasure, TotalQuantity, TotalPrice, OrderDay, OrderMonth, OrderYear)
	select p.ProductID, p.Name, p.Measure, SUM(op.Quantity), SUM(op.CurrentPrice * op.Quantity), DAY(o.CreationDate), MONTH(o.CreationDate), YEAR(o.CreationDate) from shopdb.Product p
		inner join shopdb.OrderPosition op
			on op.ProductID = p.ProductID
		inner join shopdb.Orders o
			on op.OrderID = o.OrderID
		group by p.ProductID, p.Name, p.Measure, o.CreationDate
	on duplicate key update TotalQuantity = VALUES(TotalQuantity), TotalPrice = VALUES(TotalPrice);