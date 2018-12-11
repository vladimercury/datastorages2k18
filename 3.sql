DELETE FROM shopdb.Customer
	WHERE CustomerID = @custId;
	
DELETE FROM shopdb.Product
	WHERE ProductId = @productId;