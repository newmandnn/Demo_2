-- Data Base
-- Creating all tables
CREATE TABLE Artists 
(
	ArtistID serial PRIMARY KEY,
	Name VARCHAR(50) UNIQUE NOT NULL 
);

CREATE TABLE Genres 
(
	GenreID serial PRIMARY KEY,
	Name VARCHAR(50) UNIQUE NOT NULL 
);

CREATE TABLE Playlists 
(
	PLaylistID serial PRIMARY KEY,
	Name VARCHAR(50) UNIQUE NOT NULL 
);

CREATE TABLE Disks 
(
	DiskID serial PRIMARY KEY,
	Name VARCHAR(50) UNIQUE NOT NULL,
	Price INT NOT NULL,
	Count INT NOT NULL,
	PlaylistID_FK INT REFERENCES Playlists(PLaylistID)
);

CREATE TABLE Albums
(
	AlbumID serial PRIMARY KEY,
	Name VARCHAR(50) NOT NULL,
	Tracks_Count INT NOT NULL
);

CREATE TABLE Tracks 
(
	TrackID serial PRIMARY KEY,
	Name VARCHAR(50) NOT NULL,
	ArtistID_FK INT REFERENCES Artists(ArtistID),
	AlbumID_FK INT REFERENCES Albums(AlbumID),
	GenreID_FK INT REFERENCES Genres(GenreID)
);

CREATE TABLE PlaylistsTracks
(
	PlaylistID INT REFERENCES Playlists(PLaylistID),
	TrackID INT REFERENCES Tracks(TrackID),
	PRIMARY KEY(PlaylistID, TrackID)
);

CREATE TABLE Customers
(
	CustomerID serial PRIMARY KEY,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	PhoneNumber VARCHAR(50) UNIQUE NOT NULL,
	Email VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Orders 
(
	OrderID serial PRIMARY KEY,
	CustomerID_FK INT REFERENCES Customers(CustomerID) 
);

CREATE TABLE OrdersDisks
(
	OrderID INT REFERENCES Orders(OrderID),
	DiskID INT REFERENCES Disks(DiskID),
	PRIMARY KEY(OrderID, DiskID)
);

-- Insert data
INSERT INTO Artists(Name)
VALUES
	('AC/DC'),
	('Rammstein'),
	('Falling in Reverse'),
	('Low Roar'),
	('Kavinsky'),
	('Pascal Junior'),
	('SILENT POETS'),
	('Twin Shadow')
RETURNING *;

INSERT INTO Genres(Name)
VALUES
	('Rock'),
	('Pop'),
	('House'),
	('Disco'),
	('Indie')
RETURNING *;

INSERT INTO PLaylists(Name)
VALUES
	('rock_one'),
	('rock_two'),
	('disco_one'),
	('pop_one'),
	('ac/dc_one')
RETURNING *;

INSERT INTO Disks(Name, Price, Count, PlaylistID_FK)
VALUES
	('2000s Rock Ultimate Collection', '399', '14', '2'),
	('Modern Pop Combo', '200', '10', '4'),
	('AC/DC Hits', '599', '4', '5')
RETURNING *;

INSERT INTO Albums(Name, Tracks_Count)
VALUES
	('Outrun', '14'),
	('Coming Home', '13'),
	('Thinderstruck', '9')
RETURNING *;

INSERT INTO Tracks(Name, ArtistID_FK, AlbumID_FK, GenreID_FK)
VALUES
	('Coming Home', '3', '2', '1'),
	('I Dont Mind', '3', '2', '1'),
	('Nightcall', '5', '1', '4'),
	('Thunderstuck', '1', '3', '1')
RETURNING *;

INSERT INTO PlaylistsTracks(PlaylistID, TrackID)
VALUES 
	('1', '1'),
	('1', '2'),
	('1', '4'),
	('2', '4'),
	('5', '4')
RETURNING *;

INSERT INTO Customers(FirstName, LastName, PhoneNumber, Email)
VALUES
	('Oleg', 'Potuzhniy', '0965519875', 'potuzh06@gmail.com'),
	('Maxim', 'Pritula', '0987651234', 'pritula007@gmail.com'),
	('John', 'McChicken', '3458418576', 'ealocho123@yahoo.net'),
	('George', 'Gustavo', '9723751298', 'gusto2311@gmail.com')
RETURNING *;

INSERT INTO Orders(CustomerID_FK)
VALUES
	('4'),
	('4'),
	('2'),
	('3')
RETURNING *;

INSERT INTO OrdersDisks(OrderID, DiskID)
VALUES
	('1', '1'),
	('1', '2'),
	('2', '3'),
	('3', '2'),
	('4', '1')
RETURNING *;

-- Showing all customers who made orders:
SELECT Customers.FirstName, Customers.LastName FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID_FK;

-- Showing total price of an order
SELECT SUM(Disks.Price) AS TotalCost FROM Orders
INNER JOIN OrdersDisks ON Orders.OrderID = OrdersDisks.OrderID
INNER JOIN Disks ON OrdersDisks.DiskID = Disks.DiskID
WHERE Orders.OrderID = 1;

-- Showing all playlists with count of tracks included
SELECT Playlists.Name, COUNT(PlaylistsTracks.TrackID) AS TrackCount FROM Playlists
LEFT JOIN PlaylistsTracks ON Playlists.PLaylistID = PlaylistsTracks.PlaylistID
GROUP BY Playlists.PLaylistID, Playlists.Name;