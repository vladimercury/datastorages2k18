insert into shopdb.Customer (CustomerID, CompanyName, ContactName, City, Address, Email, PhoneNumber)
values
	(1, 'Neva', 'Aleksandrov Oleg', 'Saint Petersburg', 'Esenina 100', 'alexandrov@gmail.com', '+78128912828'),
	(2, 'Moscow', 'Ivanov Alexandr', 'Moscow', 'Pushkina 1', 'ivanov@mail.ru', '+74952718412'),
	(3, 'Black Sea', 'Artemova Anna', 'Sochi', 'Tolstogo 29', 'artemova@blacksea.ru', '+79003832212'),
	(4, 'Krimea', 'Petrov Sergey', 'Sevastopol', 'Morskaya 20', 's.petrov@rambler.ru', '+78219283661'),
	(5, 'Siberia', 'Borisov Denis', 'Krasnoyarsk', 'Chekhova 2', 'd.a.borisov@siberiaprod.com', '+73912727911'),
	(6, 'FarEast', 'Romanova Irina', 'Vladivostor', 'Mira 9', 'romanova@fareast.ru', '+79009222882')
on duplicate key update CustomerID = CustomerID;

set @neva = 1;
set @moscow = 2;
set @blacksea = 3;
set @krimea = 4;
set @siberia = 5;
set @fareast = 6;

insert into shopdb.Product (ProductID, Name, Measure, Price)
values
	(1, 'Iron', 'ton', 200),
	(2, 'Wood', 'm3', 150),
	(3, 'Plastic', 'ton', 489),
	(4, 'Sand', 'ton', 101),
	(5, 'Stone', 'ton', 90),
	(6, 'Coal', 'ton', 130),
	(7, 'Oil', 'barrel', 1000)
on duplicate key update ProductID = ProductID;

set @iron = 1;
set @wood = 2;
set @plastic = 3;
set @sand = 4;
set @stone = 5;
set @coal = 6;
set @oil = 7;

insert into shopdb.ShipmentType (ShipmentTypeID, Name, Description)
values
	(1, 'Railroad', 'Using trains'),
	(2, 'Aircraft', 'By air'),
	(3, 'Auto', 'By trucks'),
	(4, 'Cargo', 'By sea')
on duplicate key update ShipmentTypeID = ShipmentTypeID;

set @railroad = 1;
set @aircraft = 2;
set @auto = 3;
set @cargo = 4;

insert into shopdb.orderstatus (OrderStatusID, Name)
values 
	(1, 'Preparing'),
	(2, 'Waiting for loading'),
	(3, 'Transportation'),
	(4, 'Waiting for unloading'),
	(5, 'Delivered')
on duplicate key update OrderStatusID = OrderStatusID;

set @prepairing = 1;
set @waitload = 2;
set @transport = 3;
set @waitunload = 4;
set @delivered = 5;

insert into shopdb.orders (OrderID, OrderStatusID, CustomerID, TransportTypeID, CreationDate, PlannedDate, ShipmentDate)
values
	(1, @delivered, @neva, @railroad, '2018-01-19 14:12', '2018-01-24 15:00', '2018-01-24 14:31'),
	(2, @waitunload, @moscow, @auto, '2018-01-20 15:17', '2018-01-27 16:00', NULL),
	(3, @waitunload, @blacksea, @auto, '2018-01-21 19:33', '2018-01-28 14:00', NULL),
	(4, @transport, @krimea, @cargo, '2018-01-22 11:48', '2018-01-29 11:00', NULL),
	(5, @waitload, @siberia, @aircraft, '2018-01-23 18:21', '2018-01-30 10:00', NULL),
	(6, @prepairing, @fareast, @aircraft, '2018-01-24 19:29', '2018-01-31 14:30', NULL),
	(7, @prepairing, @moscow, @aircraft, '2018-01-25 13:00', '2018-01-31 15:00', NULL)
on duplicate key update OrderID = OrderID;

set @first = 1;
set @second = 2;
set @third = 3;
set @fourth = 4;
set @fifth = 5;
set @sixth = 6;
set @seventh = 7;

insert into shopdb.orderposition (OrderPositionID, OrderID, ProductID, Quantity, CurrentPrice)
values
	(1, @first, @iron, 10, 180),
	(2, @first, @coal, 10, 117),
	(3, @second, @oil, 30, 1000),
	(4, @third, @wood, 20, 151),
	(5, @fourth, @plastic, 9, 488),
	(6, @fourth, @iron, 3, 181),
	(7, @fifth, @iron, 1, 183),
	(8, @fifth, @wood, 1, 118),
	(9, @fifth, @plastic, 1.5, 494),
	(10, @fifth, @sand, 0.5, 102),
	(11, @fifth, @stone, 1, 91),
	(12, @sixth, @oil, 20, 1011),
	(13, @seventh, @oil, 14, 1010)
on duplicate key update OrderPositionID = OrderPositionID;