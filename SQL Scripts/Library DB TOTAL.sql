--Make and use the LibraryDB
CREATE DATABASE LibraryDB;
GO
USE LibraryDB;
GO

--Generate Tables

--State([PK]StateID, StateName)
CREATE TABLE STATE(
		StateID			int			NOT NULL IDENTITY(1,1),
		StateName		Char(25)	NOT NULL,
		CONSTRAINT		StatePK		PRIMARY KEY(StateID),
		CONSTRAINT		StateAK1	UNIQUE(StateName)
);

--City([PK]CityID, CityName)
CREATE TABLE CITY(
		CityID			int			NOT NULL IDENTITY(1,1),
		CityName		Char(25)	NOT NULL,
		CONSTRAINT		CityPK		PRIMARY KEY(CityID)
);

--Zip([PK]ZipCode)
CREATE TABLE ZIP(
		ZipCode			int			NOT NULL,
		CONSTRAINT		ZipPK		PRIMARY KEY(ZipCode), UNIQUE(ZipCode)
);

--Address([PK][FK]CityID, [PK][FK]StateID, [PK][FK]ZipCode, BuildingNumber, Street)
CREATE TABLE ADDRESS(
		StateID			int			NOT NULL,
		CityID			int			NOT NULL,
		ZipCode			int			NOT NULL,
		BuildingNumber	int			NOT NULL,
		Street			Char(50)	NOT NULL,  
		CONSTRAINT		AddressPK	PRIMARY KEY(StateID, CityID, ZipCode), UNIQUE(StateID, CityID, ZipCode),
		CONSTRAINT		StateFK		FOREIGN KEY(StateID)	REFERENCES STATE(StateID)
																ON UPDATE NO ACTION		--CASCASE means update reference everywhere else on update/delete
																ON DELETE NO ACTION,
		CONSTRAINT		CityFK		FOREIGN KEY(CityID)		REFERENCES CITY(CityID)
																ON UPDATE NO ACTION
																ON DELETE NO ACTION,
		CONSTRAINT		ZipCodeFK	FOREIGN KEY(ZipCode)	REFERENCES ZIP(ZipCode)
																ON UPDATE NO ACTION
																ON DELETE NO ACTION,
);

--Membership([PK]MembershipID, StartDate, EndDate)
CREATE TABLE MEMBERSHIP(
		MembershipID	int				NOT NULL IDENTITY(1,1),
		StartDate		Char(10)		NOT NULL,
		EndDate			Char(10)		NOT NULL,
		CONSTRAINT		MembershipPK	PRIMARY KEY(MembershipID)
);

--Customer([PK]CustomerID, CustomerName, [FK]CityID, [FK]State ID, [FK]ZipCode, Email, Phone, [FK]MemberShipID)
CREATE TABLE CUSTOMER(
		CustomerID		int				NOT NULL IDENTITY(1,1),
		CustomerName	Char(50)		NOT NULL,
		StateID			int				NOT NULL,
		CityID			int				NOT NULL,
		ZipCode			int				NOT NULL,
		Email			Char(50)		NOT NULL,
		Phone			Char(10)		NOT NULL,
		MembershipID	int,
		CONSTRAINT		CustomerPK		PRIMARY KEY(CustomerID), UNIQUE(CustomerID, MembershipID),
		CONSTRAINT		CusAddressFK	FOREIGN KEY(StateID, CityID, ZipCode)	REFERENCES ADDRESS(StateID, CityID, ZipCode)
																					ON UPDATE NO ACTION
																					ON DELETE NO ACTION,
		CONSTRAINT		MembershipFK	FOREIGN KEY(MemberShipID)				REFERENCES MEMBERSHIP(MemberShipID)	
																					ON UPDATE NO ACTION
																					ON DELETE NO ACTION
);

--Library([PK]LibraryID, (FK) CityID, (FK) State ID, (FK) ZipCode, YearsInService, Phone)
CREATE TABLE LIBRARY(
		LibraryID		int				NOT NULL IDENTITY(1,1),
		StateID			int				NOT NULL,
		CityID			int				NOT NULL,
		ZipCode			int				NOT NULL,
		YearsInService	int				NOT NULL,
		Phone			Char(10)		NOT NULL,
		CONSTRAINT		LibAddressFK	FOREIGN KEY(StateID, CityID, ZipCode)	REFERENCES ADDRESS(StateID, CityID, ZipCode), UNIQUE (LibraryID, StateID, CityID, ZipCode),
		CONSTRAINT		LibraryPK		PRIMARY KEY(LibraryID)
);

--Employee([PK]EmployeeID, [PK](FK) LibraryID, (FK) CityID, (FK) State ID, (FK) ZipCode, EmployeeName, YearsEmployed, Phone)
CREATE TABLE EMPLOYEE(
		EmployeeID		int				NOT NULL IDENTITY(1,1),
		LibraryID		int				NOT NULL,
		StateID			int				NOT NULL,
		CityID			int				NOT NULL,
		ZipCode			int				NOT NULL,
		EmployeeName	Char(50)		NOT NULL,
		YearsEmployed	int				NOT NULL,
		Phone			Char(10)		NOT NULL,
		CONSTRAINT		EmpAddressFK	FOREIGN KEY(StateID, CityID, ZipCode)	REFERENCES ADDRESS(StateID, CityID, ZipCode)
																					ON UPDATE NO ACTION
																					ON DELETE NO ACTION,
		CONSTRAINT		EmpLibraryFK	FOREIGN KEY(LibraryID)					REFERENCES LIBRARY(LibraryID)
																					ON UPDATE NO ACTION
																					ON DELETE NO ACTION,
		CONSTRAINT		EmployeePK		PRIMARY KEY(EmployeeID, LibraryID)
);

--Transaction([PK]TransactionID, (FK) CustomerID, (FK) LibraryID, TransactionDate, Subtotal, Tax, Total)
CREATE TABLE CTRANSACTION(
		TransactionID	int				NOT NULL IDENTITY(1,1),
		CustomerID		int				NOT NULL,
		LibraryID		int				NOT NULL,
		TransactionDate	Char(10)		NOT NULL,
		Subtotal		float			NOT NULL,
		Tax				float			NOT NULL,
		Total			float			NOT NULL,
		CONSTRAINT		TranCustomerFK	FOREIGN KEY(CustomerID)		REFERENCES CUSTOMER(CustomerID), UNIQUE(TransactionID, CustomerID),
		CONSTRAINT		TranLibraryFK	FOREIGN KEY(LibraryID)		REFERENCES LIBRARY(LibraryID)
																		ON UPDATE NO ACTION
																		ON DELETE NO ACTION,
		CONSTRAINT		TransactionPK	PRIMARY KEY(TransactionID)
);

--Item([PK]ItemID, UnitPrice, Description)
CREATE TABLE ITEM(
		ItemID			int				NOT NULL IDENTITY (1,1),
		UnitPrice		float			NOT NULL,
		Description		Char(100)		NOT NULL,
		CONSTRAINT		ItemPK			PRIMARY KEY (ItemID)
);

--Order_Line([PK]OrderLineNumber, [PK](FK) TransactionID, [PK](FK) ItemID, Quantity)
CREATE TABLE ORDER_LINE(
		OrderLineNumber	int				NOT NULL,
		TransactionID	int				NOT NULL,
		ItemID			int				NOT NULL,
		Quantity		int				NOT NULL,
		CONSTRAINT		OTransactionFK	FOREIGN KEY(TransactionID)	REFERENCES CTRANSACTION(TransactionID), UNIQUE(OrderLineNumber, TransactionID),
		CONSTRAINT		OItemFK			FOREIGN KEY(ItemID)			REFERENCES ITEM(ItemID)
																		ON UPDATE NO ACTION
																		ON DELETE NO ACTION,
		CONSTRAINT		OrderLinePK		PRIMARY KEY(OrderLineNumber, TransactionID, ItemID)
);

--Event([PK]EventID, (FK) LibraryID, EventName, EventDescription, DateOfEvent)
CREATE TABLE EVENT(
		EventID				int				NOT NULL IDENTITY(1,1),
		LibraryID			int				NOT NULL,
		EventName			Char(50)		NOT NULL,
		EventDescription	Char(100)		NOT NULL,
		DateOfEvent			Char(10)		NOT NULL,
		CONSTRAINT			EventLibraryFK	FOREIGN KEY(LibraryID)		REFERENCES LIBRARY(LibraryID)
																			ON UPDATE NO ACTION
																			ON DELETE NO ACTION,
		CONSTRAINT			EventPK			PRIMARY KEY(EventID)
);

--Shipment([PK]ShipmentID, (FK) LibraryID, Description, Quantity, ShipDate)
CREATE TABLE SHIPMENT(
		ShipmentID			int				NOT NULL IDENTITY(1,1),
		LibraryID			int				NOT NULL,
		Description			Char(100)		NOT NULL,
		Quantity			int				NOT NULL,
		ShipDate			Char(10)		NOT NULL,
		CONSTRAINT			ShipLibraryFK	FOREIGN KEY(LibraryID)		REFERENCES LIBRARY(LibraryID)
																			ON UPDATE NO ACTION
																			ON DELETE NO ACTION,
		CONSTRAINT			ShipmentPK		PRIMARY KEY(ShipmentID)
);

--Inventory([PK](FK) LibraryID, (FK) ShipmentID)
CREATE TABLE INVENTORY(
		LibraryID			int				NOT NULL,
		ShipmentID			int				NOT NULL,
		CONSTRAINT			InvLibraryFK	FOREIGN KEY(LibraryID)		REFERENCES LIBRARY(LibraryID)
																			ON UPDATE NO ACTION
																			ON DELETE NO ACTION,
		CONSTRAINT			InvShipmentFK	FOREIGN KEY(ShipmentID)		REFERENCES SHIPMENT(ShipmentID)
																			ON UPDATE NO ACTION
																			ON DELETE NO ACTION,
		CONSTRAINT			InventoryPK		PRIMARY KEY(LibraryID)
);

--Genre([PK]GenreName)
CREATE TABLE GENRE(
		GenreName			Char(25)		NOT NULL,
		CONSTRAINT			GenrePK			PRIMARY KEY(GenreName)
);

--Library_Section([PK]SectionID, (FK) GenreName)
CREATE TABLE LIBRARY_SECTION(
		SectionID			int				NOT NULL IDENTITY(1,1),
		GenreName			Char(25)		NOT NULL,
		CONSTRAINT			GenreNameFK		FOREIGN KEY(GenreName)		REFERENCES GENRE(GenreName)
																			ON UPDATE NO ACTION
																			ON DELETE NO ACTION,
		CONSTRAINT			LibSectionPK	PRIMARY KEY(SectionID)
);

--Publisher([PK]PublisherID, PublisherName)
CREATE TABLE PUBLISHER(
		PublisherID			int				NOT NULL IDENTITY(1,1),
		PublisherName		Char(50)		NOT NULL,
		CONSTRAINT			PublisherPK		PRIMARY KEY(PublisherID)
);

--Book([PK]BookID, BookName, PageCount, AuthorName, (FK) PublisherID)
CREATE TABLE BOOK(
		BookID				int				NOT NULL IDENTITY(1,1),	
		BookName			Char(250)		NOT NULL,
		PageCount			int				NOT NULL,
		AuthorName			Char(50)		NOT NULL,
		PublisherID			int				NOT NULL,
		CONSTRAINT			PublisherFK		FOREIGN KEY(PublisherID) REFERENCES PUBLISHER(PublisherID),
		CONSTRAINT			BookPK			PRIMARY KEY(BookID)
);

--Availability([PK](FK) LibraryID, [PK](FK) BookID, (FK) SectionID, Quantity)
CREATE TABLE AVAILABILITY(
		LibraryID			int				NOT NULL,
		BookID				int				NOT NULL,
		SectionID			int				NOT NULL,
		Quantity			int				NOT NULL,
		CONSTRAINT			SectionFK		FOREIGN KEY(SectionID)		REFERENCES LIBRARY_SECTION(SectionID),
		CONSTRAINT			AvaLibraryFK	FOREIGN KEY(LibraryID)		REFERENCES LIBRARY(LibraryID),
		CONSTRAINT			AvaBookFK		FOREIGN KEY(BookID)			REFERENCES BOOK(BookID),
		CONSTRAINT			AvailabilityPK	PRIMARY KEY(LibraryID, BookID)
);

--Review([PK]ReviewID, (FK) BookID, Rating, ReviewDescription)
CREATE TABLE REVIEW(
		ReviewID			int				NOT NULL IDENTITY(1,1),
		BookID				int				NOT NULL,
		Rating				int				NOT NULL,
		ReviewDescription	Char(250)		NOT NULL,
		CONSTRAINT			RevBookFK		FOREIGN KEY(BookID)		REFERENCES BOOK(BookID),
		CONSTRAINT			ReviewPK		PRIMARY KEY(ReviewID)
);

GO

USE LibraryDB
GO

--INSERT THE DATA INTO THE LIBRARY DB

--STATE Table
INSERT INTO STATE VALUES ('Alabama');
INSERT INTO STATE VALUES ('Alaska');
INSERT INTO STATE VALUES ('Arizona');
INSERT INTO STATE VALUES ('Arkansas');
INSERT INTO STATE VALUES ('California');
INSERT INTO STATE VALUES ('Colorado');
INSERT INTO STATE VALUES ('Connecticut');
INSERT INTO STATE VALUES ('Delaware');
INSERT INTO STATE VALUES ('Florida');
INSERT INTO STATE VALUES ('Georgia');
INSERT INTO STATE VALUES ('Hawaii');
INSERT INTO STATE VALUES ('Idaho');
INSERT INTO STATE VALUES ('Illinois');
INSERT INTO STATE VALUES ('Indiana');
INSERT INTO STATE VALUES ('Iowa');
INSERT INTO STATE VALUES ('Kansas');
INSERT INTO STATE VALUES ('Kentucky');
INSERT INTO STATE VALUES ('Louisiana');
INSERT INTO STATE VALUES ('Maine');
INSERT INTO STATE VALUES ('Maryland');
INSERT INTO STATE VALUES ('Massachusetts');
INSERT INTO STATE VALUES ('Michigan');
INSERT INTO STATE VALUES ('Minnesota');
INSERT INTO STATE VALUES ('Mississippi');
INSERT INTO STATE VALUES ('Missouri');
INSERT INTO STATE VALUES ('Montana');
INSERT INTO STATE VALUES ('Nebraska');
INSERT INTO STATE VALUES ('Nevada');
INSERT INTO STATE VALUES ('New Hampshire');
INSERT INTO STATE VALUES ('New Jersey');
INSERT INTO STATE VALUES ('New Mexico');
INSERT INTO STATE VALUES ('New York');
INSERT INTO STATE VALUES ('North Carolina');
INSERT INTO STATE VALUES ('North Dakota');
INSERT INTO STATE VALUES ('Ohio');
INSERT INTO STATE VALUES ('Oklahoma');
INSERT INTO STATE VALUES ('Oregon');
INSERT INTO STATE VALUES ('Pennsylvania');
INSERT INTO STATE VALUES ('Rhode Island');
INSERT INTO STATE VALUES ('South Carolina');
INSERT INTO STATE VALUES ('South Dakota');
INSERT INTO STATE VALUES ('Tennessee');
INSERT INTO STATE VALUES ('Texas');
INSERT INTO STATE VALUES ('Utah');
INSERT INTO STATE VALUES ('Vermont');
INSERT INTO STATE VALUES ('Virginia');
INSERT INTO STATE VALUES ('Washington');
INSERT INTO STATE VALUES ('West Virginia');
INSERT INTO STATE VALUES ('Wisconsin');
INSERT INTO STATE VALUES ('Wyoming');

--CITY TABLE
INSERT INTO CITY VALUES ('Puyallup');
INSERT INTO CITY VALUES ('Tacoma');
INSERT INTO CITY VALUES ('Seattle');
INSERT INTO CITY VALUES ('Spokane');
INSERT INTO CITY VALUES ('Bellevue');
INSERT INTO CITY VALUES ('Everett');
INSERT INTO CITY VALUES ('Kent');
INSERT INTO CITY VALUES ('Yakima');
INSERT INTO CITY VALUES ('Renton');
INSERT INTO CITY VALUES ('Olympia');
INSERT INTO CITY VALUES ('Federal Way');
INSERT INTO CITY VALUES ('Bellingham');
INSERT INTO CITY VALUES ('Auburn');
INSERT INTO CITY VALUES ('Marysville');
INSERT INTO CITY VALUES ('Pasco');
INSERT INTO CITY VALUES ('Lakewood');
INSERT INTO CITY VALUES ('Redmond');
INSERT INTO CITY VALUES ('Shoreline');
INSERT INTO CITY VALUES ('Richland');
INSERT INTO CITY VALUES ('Kirkland');
INSERT INTO CITY VALUES ('Burien');
INSERT INTO CITY VALUES ('Sammamish');
INSERT INTO CITY VALUES ('Lacey');
INSERT INTO CITY VALUES ('Edmonds');
INSERT INTO CITY VALUES ('Bremerton');
INSERT INTO CITY VALUES ('Puyallup');
INSERT INTO CITY VALUES ('Longview');
INSERT INTO CITY VALUES ('Lynnwood');
INSERT INTO CITY VALUES ('Bothell');
INSERT INTO CITY VALUES ('Wenatchee');
INSERT INTO CITY VALUES ('Mount Vernon');

--ZIPCODE TABLE
INSERT INTO ZIP VALUES (98373);
INSERT INTO ZIP VALUES (98101);
INSERT INTO ZIP VALUES (98102);
INSERT INTO ZIP VALUES (98103);
INSERT INTO ZIP VALUES (98104);
INSERT INTO ZIP VALUES (98105);
INSERT INTO ZIP VALUES (98106);
INSERT INTO ZIP VALUES (98107);
INSERT INTO ZIP VALUES (98108);
INSERT INTO ZIP VALUES (98109);
INSERT INTO ZIP VALUES (98112);
INSERT INTO ZIP VALUES (98115);
INSERT INTO ZIP VALUES (98116);
INSERT INTO ZIP VALUES (98117);
INSERT INTO ZIP VALUES (98118);
INSERT INTO ZIP VALUES (98119);
INSERT INTO ZIP VALUES (98121);
INSERT INTO ZIP VALUES (98122);
INSERT INTO ZIP VALUES (98125);
INSERT INTO ZIP VALUES (98126);
INSERT INTO ZIP VALUES (98133);
INSERT INTO ZIP VALUES (98134);
INSERT INTO ZIP VALUES (98136);
INSERT INTO ZIP VALUES (98144);
INSERT INTO ZIP VALUES (98146);
INSERT INTO ZIP VALUES (98148);
INSERT INTO ZIP VALUES (98155);
INSERT INTO ZIP VALUES (98166);
INSERT INTO ZIP VALUES (98168);
INSERT INTO ZIP VALUES (98177);
INSERT INTO ZIP VALUES (98188);

--ADDRESS TABLE
INSERT INTO ADDRESS VALUES (47, 1, 98101, 3186, 'Pacific Ave');
INSERT INTO ADDRESS VALUES (47, 2, 98102, 4186, 'Longsted Ave');
INSERT INTO ADDRESS VALUES (47, 3, 98103, 5186, 'Rorke Ave');
INSERT INTO ADDRESS VALUES (47, 4, 98104, 123, 'Pine St');
INSERT INTO ADDRESS VALUES (47, 5, 98105, 456, 'Broadway');
INSERT INTO ADDRESS VALUES (47, 6, 98106, 789, 'Queen Anne Ave');
INSERT INTO ADDRESS VALUES (47, 7, 98107, 159, 'Fremont Ave');
INSERT INTO ADDRESS VALUES (47, 8, 98108, 753, 'Georgetown Rd');
INSERT INTO ADDRESS VALUES (47, 9, 98109, 951, 'Denny Way');
INSERT INTO ADDRESS VALUES (47, 10, 98112, 357, 'Capitol Hill Rd');
INSERT INTO ADDRESS VALUES (47, 11, 98115, 846, 'Green Lake Dr');
INSERT INTO ADDRESS VALUES (47, 12, 98116, 264, 'Alki Ave');
INSERT INTO ADDRESS VALUES (47, 13, 98117, 582, 'Golden Gardens Dr');
INSERT INTO ADDRESS VALUES (47, 14, 98118, 297, 'Columbia City Blvd');
INSERT INTO ADDRESS VALUES (47, 15, 98119, 413, 'Kinnear Rd');
INSERT INTO ADDRESS VALUES (47, 16, 98121, 126, 'Belltown St');
INSERT INTO ADDRESS VALUES (47, 17, 98122, 459, 'Madrona Dr');
INSERT INTO ADDRESS VALUES (47, 18, 98125, 732, 'Lake City Way');
INSERT INTO ADDRESS VALUES (47, 19, 98126, 984, 'Fauntleroy Way');
INSERT INTO ADDRESS VALUES (47, 20, 98133, 675, 'Aurora Ave');
INSERT INTO ADDRESS VALUES (47, 21, 98134, 238, 'SoDo St');
INSERT INTO ADDRESS VALUES (47, 22, 98136, 549, 'Lincoln Park Way');
INSERT INTO ADDRESS VALUES (47, 23, 98144, 871, 'Mt. Baker Blvd');
INSERT INTO ADDRESS VALUES (47, 24, 98146, 395, 'White Center St');
INSERT INTO ADDRESS VALUES (47, 25, 98148, 142, 'Burien Rd');
INSERT INTO ADDRESS VALUES (47, 26, 98155, 368, 'Shoreline Dr');
INSERT INTO ADDRESS VALUES (47, 27, 98166, 729, 'Des Moines Memorial Dr');
INSERT INTO ADDRESS VALUES (47, 28, 98168, 584, 'Tukwila International Blvd');
INSERT INTO ADDRESS VALUES (47, 29, 98177, 917, 'Richmond Beach Rd');
INSERT INTO ADDRESS VALUES (47, 30, 98188, 256, 'SeaTac Way');
INSERT INTO ADDRESS VALUES (47, 31, 98373, 438, 'Puyallup St');

--MEMBERSHIP TABLE
INSERT INTO MEMBERSHIP VALUES('2021-01-01', '2021-01-31');
INSERT INTO MEMBERSHIP VALUES('2021-02-01', '2021-03-03');
INSERT INTO MEMBERSHIP VALUES('2021-03-04', '2021-04-03');
INSERT INTO MEMBERSHIP VALUES('2021-04-04', '2021-05-04');
INSERT INTO MEMBERSHIP VALUES('2021-05-05', '2021-06-04');
INSERT INTO MEMBERSHIP VALUES('2021-06-05', '2021-07-05');
INSERT INTO MEMBERSHIP VALUES('2021-07-06', '2021-08-05');
INSERT INTO MEMBERSHIP VALUES('2021-08-06', '2021-09-05');
INSERT INTO MEMBERSHIP VALUES('2021-09-06', '2021-10-06');
INSERT INTO MEMBERSHIP VALUES('2021-10-07', '2021-11-06');
INSERT INTO MEMBERSHIP VALUES('2021-11-07', '2021-12-07');
INSERT INTO MEMBERSHIP VALUES('2021-12-08', '2022-01-07');
INSERT INTO MEMBERSHIP VALUES('2022-01-08', '2022-02-07');
INSERT INTO MEMBERSHIP VALUES('2022-02-08', '2022-03-10');
INSERT INTO MEMBERSHIP VALUES('2022-03-11', '2022-04-10');
INSERT INTO MEMBERSHIP VALUES('2022-04-11', '2022-05-11');
INSERT INTO MEMBERSHIP VALUES('2022-05-12', '2022-06-11');
INSERT INTO MEMBERSHIP VALUES('2022-06-12', '2022-07-12');
INSERT INTO MEMBERSHIP VALUES('2022-07-13', '2022-08-12');
INSERT INTO MEMBERSHIP VALUES('2022-08-13', '2022-09-12');
INSERT INTO MEMBERSHIP VALUES('2022-09-13', '2022-10-13');
INSERT INTO MEMBERSHIP VALUES('2022-10-14', '2022-11-13');
INSERT INTO MEMBERSHIP VALUES('2022-11-14', '2022-12-14');
INSERT INTO MEMBERSHIP VALUES('2022-12-15', '2023-01-14');
INSERT INTO MEMBERSHIP VALUES('2023-01-15', '2023-02-14');
INSERT INTO MEMBERSHIP VALUES('2023-02-15', '2023-03-17');
INSERT INTO MEMBERSHIP VALUES('2023-03-18', '2023-04-17');
INSERT INTO MEMBERSHIP VALUES('2023-04-18', '2023-05-18');
INSERT INTO MEMBERSHIP VALUES('2023-02-01', '2023-03-03');
INSERT INTO MEMBERSHIP VALUES('2023-02-02', '2023-03-04');
INSERT INTO MEMBERSHIP VALUES('2023-02-03', '2023-03-05');
INSERT INTO MEMBERSHIP VALUES('2023-02-04', '2023-03-06');
INSERT INTO MEMBERSHIP VALUES('2023-02-05', '2023-03-07');
INSERT INTO MEMBERSHIP VALUES('2023-02-06', '2023-03-08');
INSERT INTO MEMBERSHIP VALUES('2023-02-07', '2023-03-09');
INSERT INTO MEMBERSHIP VALUES('2023-02-08', '2023-03-10');
INSERT INTO MEMBERSHIP VALUES('2023-02-09', '2023-03-11');
INSERT INTO MEMBERSHIP VALUES('2023-02-10', '2023-03-12');
INSERT INTO MEMBERSHIP VALUES('2023-02-11', '2023-03-13');
INSERT INTO MEMBERSHIP VALUES('2023-02-12', '2023-03-14');
INSERT INTO MEMBERSHIP VALUES('2023-02-13', '2023-03-15');
INSERT INTO MEMBERSHIP VALUES('2023-02-14', '2023-03-16');
INSERT INTO MEMBERSHIP VALUES('2023-02-15', '2023-03-17');
INSERT INTO MEMBERSHIP VALUES('2023-02-16', '2023-03-18');
INSERT INTO MEMBERSHIP VALUES('2023-02-17', '2023-03-19');
INSERT INTO MEMBERSHIP VALUES('2023-02-18', '2023-03-20');
INSERT INTO MEMBERSHIP VALUES('2023-02-19', '2023-03-21');
INSERT INTO MEMBERSHIP VALUES('2023-02-20', '2023-03-22');
INSERT INTO MEMBERSHIP VALUES('2023-02-21', '2023-03-23');
INSERT INTO MEMBERSHIP VALUES('2023-02-22', '2023-03-24');
INSERT INTO MEMBERSHIP VALUES('2023-02-23', '2023-03-25');
INSERT INTO MEMBERSHIP VALUES('2023-02-24', '2023-03-26');
INSERT INTO MEMBERSHIP VALUES('2023-02-25', '2023-03-27');
INSERT INTO MEMBERSHIP VALUES('2023-01-01', '2023-01-31');

--CUTOMER TABLE [CUSTOMER (CustomerName, StateID, CityID, ZipCode, Email, Phone, MembershipID)] 40 customers here
INSERT INTO CUSTOMER VALUES ('Jane Smith', 47, 1, 98101, 'jane.smith@example.com', '5559876543', 2);
INSERT INTO CUSTOMER VALUES ('Michael Johnson', 47, 2, 98102, 'michael.johnson@example.com', '5558765432', 3);
INSERT INTO CUSTOMER VALUES ('Emily Brown', 47, 3, 98103, 'emily.brown@example.com', '5557654321', 4);
INSERT INTO CUSTOMER VALUES ('William Davis', 47, 4, 98104, 'william.davis@example.com', '5556543210', 5);
INSERT INTO CUSTOMER VALUES ('Olivia Wilson', 47, 5, 98105, 'olivia.wilson@example.com', '5555432109', 6);
INSERT INTO CUSTOMER VALUES ('James Martinez', 47, 6, 98106, 'james.martinez@example.com', '5554321098', 7);
INSERT INTO CUSTOMER VALUES ('Sophia Anderson', 47, 7, 98107, 'sophia.anderson@example.com', '5553210987', 8);
INSERT INTO CUSTOMER VALUES ('Benjamin Taylor', 47, 8, 98108, 'benjamin.taylor@example.com', '5552109876', 9);
INSERT INTO CUSTOMER VALUES ('Ava Thomas', 47, 9, 98109, 'ava.thomas@example.com', '5551098765', 10);
INSERT INTO CUSTOMER VALUES ('Matthew Hernandez', 47, 10, 98112, 'matthew.hernandez@example.com', '5550987654', 11);
INSERT INTO CUSTOMER VALUES ('Harper Moore', 47, 11, 98115, 'harper.moore@example.com', '5559876543', 12);
INSERT INTO CUSTOMER VALUES ('Daniel Clark', 47, 12, 98116, 'daniel.clark@example.com', '5558765432', 13);
INSERT INTO CUSTOMER VALUES ('Evelyn Rodriguez', 47, 13, 98117, 'evelyn.rodriguez@example.com', '5557654321', 14);
INSERT INTO CUSTOMER VALUES ('Jackson Lee', 47, 14, 98118, 'jackson.lee@example.com', '5556543210', 15);
INSERT INTO CUSTOMER VALUES ('Lily Walker', 47, 15, 98119, 'lily.walker@example.com', '5555432109', 16);
INSERT INTO CUSTOMER VALUES ('Aiden Hall', 47, 16, 98121, 'aiden.hall@example.com', '5554321098', 17);
INSERT INTO CUSTOMER VALUES ('Scarlett Young', 47, 17, 98122, 'scarlett.young@example.com', '5553210987', 18);
INSERT INTO CUSTOMER VALUES ('Lucas Wright', 47, 18, 98125, 'lucas.wright@example.com', '5552109876', 19);
INSERT INTO CUSTOMER VALUES ('Chloe Scott', 47, 19, 98126, 'chloe.scott@example.com', '5551098765', 20);
INSERT INTO CUSTOMER VALUES ('Henry Green', 47, 20, 98133, 'henry.green@example.com', '5550987654', 21);
INSERT INTO CUSTOMER VALUES ('Ella Adams', 47, 21, 98134, 'ella.adams@example.com', '5559876543', 22);
INSERT INTO CUSTOMER VALUES ('Sebastian Baker', 47, 22, 98136, 'sebastian.baker@example.com', '5558765432', 23);
INSERT INTO CUSTOMER VALUES ('Victoria Turner', 47, 23, 98144, 'victoria.turner@example.com', '5557654321', 24);
INSERT INTO CUSTOMER VALUES ('Jack Collins', 47, 24, 98146, 'jack.collins@example.com', '5556543210', 25);
INSERT INTO CUSTOMER VALUES ('Sophie Hill', 47, 25, 98148, 'sophie.hill@example.com', '5555432109', 26);
INSERT INTO CUSTOMER VALUES ('Logan Gonzalez', 47, 26, 98155, 'logan.gonzalez@example.com', '5554321098', 27);
INSERT INTO CUSTOMER VALUES ('Mia Nelson', 47, 27, 98166, 'mia.nelson@example.com', '5553210987', 28);
INSERT INTO CUSTOMER VALUES ('Jacob Carter', 47, 28, 98168, 'jacob.carter@example.com', '5552109876', 29);
INSERT INTO CUSTOMER VALUES ('Grace Ramirez', 47, 29, 98177, 'grace.ramirez@example.com', '5551098765', 30);
INSERT INTO CUSTOMER VALUES ('Ethan Flores', 47, 30, 98188, 'ethan.flores@example.com', '5550987654', 31);
INSERT INTO CUSTOMER VALUES ('Avery Parker', 47, 31, 98373, 'avery.parker@example.com', '5559876543', 32);
INSERT INTO CUSTOMER VALUES ('Sofia Hughes', 47, 1, 98101, 'sofia.hughes@example.com', '5558765432', 33);
INSERT INTO CUSTOMER VALUES ('Mason Jenkins', 47, 2, 98102, 'mason.jenkins@example.com', '5557654321', 34);
INSERT INTO CUSTOMER VALUES ('Aria Barnes', 47, 3, 98103, 'aria.barnes@example.com', '5556543210', 35);
INSERT INTO CUSTOMER VALUES ('Carter Evans', 47, 4, 98104, 'carter.evans@example.com', '5555432109', 36);
INSERT INTO CUSTOMER VALUES ('Layla Diaz', 47, 5, 98105, 'layla.diaz@example.com', '5554321098', 37);
INSERT INTO CUSTOMER VALUES ('Wyatt Thompson', 47, 6, 98106, 'wyatt.thompson@example.com', '5553210987', 38);
INSERT INTO CUSTOMER VALUES ('Abigail Morris', 47, 7, 98107, 'abigail.morris@example.com', '5552109876', 39);
INSERT INTO CUSTOMER VALUES ('Owen Collins', 47, 8, 98108, 'owen.collins@example.com', '5551098765', 40);
INSERT INTO CUSTOMER VALUES ('Elizabeth Stewart', 47, 9, 98109, 'elizabeth.stewart@example.com', '5550987654', 41);


--LIBRARY TABLE ([PK]LibraryID, (FK) CityID, (FK) State ID, (FK) ZipCode, YearsInService, Phone) 5 Libraries
INSERT INTO LIBRARY (StateID, CityID, ZipCode, YearsInService, Phone) 
VALUES (47, 1, 98101, 5, '2099929999');

INSERT INTO LIBRARY (StateID, CityID, ZipCode, YearsInService, Phone) 
VALUES (47, 3, 98103, 6,'2065551111');

INSERT INTO LIBRARY (StateID, CityID, ZipCode, YearsInService, Phone) 
VALUES (47, 9, 98109, 4, '2065552222');

INSERT INTO LIBRARY (StateID, CityID, ZipCode, YearsInService, Phone) 
VALUES (47, 24, 98146, 8, '2065553333');

INSERT INTO LIBRARY (StateID, CityID, ZipCode, YearsInService, Phone) 
VALUES (47, 5, 98105, 9, '2065554444');

--EMPLOYEE TABLE (LibraryID, StateID, CityID, ZipCode, EmployeeName, YearsEmployed, Phone)
INSERT INTO EMPLOYEE VALUES (1, 47, 6, 98106, 'Johnny Boy', 12, '2094448888');
INSERT INTO EMPLOYEE VALUES (2, 47, 14, 98118, 'Emily Smith', 8, '2065551111');
INSERT INTO EMPLOYEE VALUES (3, 47, 26, 98155, 'Daniel Johnson', 4, '2065552222');
INSERT INTO EMPLOYEE VALUES (4, 47, 7, 98107, 'Olivia Davis', 6, '2065553333');
INSERT INTO EMPLOYEE VALUES (5, 47, 10, 98112, 'William Thompson', 10, '2065554444');
INSERT INTO EMPLOYEE VALUES (1, 47, 12, 98116, 'Sophia Anderson', 3, '2065555555');
INSERT INTO EMPLOYEE VALUES (2, 47, 20, 98133, 'James Martinez', 5, '2065556666');
INSERT INTO EMPLOYEE VALUES (3, 47, 29, 98177, 'Isabella Wilson', 7, '2065557777');
INSERT INTO EMPLOYEE VALUES (4, 47, 16, 98121, 'Benjamin Taylor', 2, '2065558888');
INSERT INTO EMPLOYEE VALUES (5, 47, 23, 98144, 'Ava Brown', 9, '2065559999');
INSERT INTO EMPLOYEE VALUES (1, 47, 8, 98108, 'Mason Thomas', 1, '2065550000');
INSERT INTO EMPLOYEE VALUES (2, 47, 28, 98168, 'Charlotte Clark', 11, '2065551111');
INSERT INTO EMPLOYEE VALUES (3, 47, 3, 98103, 'Elijah Rodriguez', 6, '2065552222');
INSERT INTO EMPLOYEE VALUES (4, 47, 17, 98122, 'Amelia Hernandez', 3, '2065553333');
INSERT INTO EMPLOYEE VALUES (5, 47, 25, 98148, 'Henry Lewis', 8, '2065554444');
INSERT INTO EMPLOYEE VALUES (1, 47, 11, 98115, 'Harper Walker', 4, '2065555555');
INSERT INTO EMPLOYEE VALUES (2, 47, 19, 98126, 'Liam Hall', 9, '2065556666');
INSERT INTO EMPLOYEE VALUES (3, 47, 31, 98373, 'Evelyn Morris', 5, '2065557777');
INSERT INTO EMPLOYEE VALUES (4, 47, 2, 98102, 'Sebastian Turner', 7, '2065558888');
INSERT INTO EMPLOYEE VALUES (5, 47, 9, 98109, 'Avery Powell', 2, '2065559999');
INSERT INTO EMPLOYEE VALUES (1, 47, 15, 98119, 'Lily Wright', 7, '2065551234');
INSERT INTO EMPLOYEE VALUES (2, 47, 18, 98125, 'Ethan Reed', 3, '2065552345');
INSERT INTO EMPLOYEE VALUES (3, 47, 4, 98104, 'Mia Hill', 6, '2065553456');
INSERT INTO EMPLOYEE VALUES (4, 47, 21, 98134, 'Noah Martinez', 4, '2065554567');
INSERT INTO EMPLOYEE VALUES (5, 47, 13, 98117, 'Grace Turner', 9, '2065555678');
INSERT INTO EMPLOYEE VALUES (1, 47, 22, 98136, 'Alexander Nelson', 5, '2065556789');
INSERT INTO EMPLOYEE VALUES (2, 47, 27, 98166, 'Sofia Collins', 2, '2065557890');
INSERT INTO EMPLOYEE VALUES (3, 47, 30, 98188, 'Carter Murphy', 8, '2065558901');
INSERT INTO EMPLOYEE VALUES (4, 47, 5, 98105, 'Scarlett Baker', 3, '2065559012');
INSERT INTO EMPLOYEE VALUES (5, 47, 26, 98155, 'Jameson Kelly', 7, '2065550123');
INSERT INTO EMPLOYEE VALUES (1, 47, 31, 98373, 'Hannah Gray', 5, '2065551234');
INSERT INTO EMPLOYEE VALUES (2, 47, 10, 98112, 'Logan Richardson', 9, '2065552345');
INSERT INTO EMPLOYEE VALUES (3, 47, 16, 98121, 'Aria Cooper', 4, '2065553456');
INSERT INTO EMPLOYEE VALUES (4, 47, 3, 98103, 'Miles Watson', 6, '2065554567');
INSERT INTO EMPLOYEE VALUES (5, 47, 20, 98133, 'Zoe Howard', 2, '2065555678');
INSERT INTO EMPLOYEE VALUES (1, 47, 8, 98108, 'Henry Ramirez', 7, '2065556789');
INSERT INTO EMPLOYEE VALUES (2, 47, 28, 98168, 'Layla Henderson', 5, '2065557890');
INSERT INTO EMPLOYEE VALUES (3, 47, 7, 98107, 'Wyatt Perry', 3, '2065558901');
INSERT INTO EMPLOYEE VALUES (4, 47, 14, 98118, 'Victoria Carter', 10, '2065559012');
INSERT INTO EMPLOYEE VALUES (5, 47, 17, 98122, 'Jackson Rivera', 6, '2065550123');


--CTRANSACTION TABLE
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (1, 1, '2021-01-01', 20.00, 1.50, 21.50);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (2, 2, '2021-05-17', 15.00, 1.20, 16.20);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (3, 3, '2021-09-30', 10.50, 0.80, 11.30);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (4, 4, '2022-03-12', 25.00, 1.75, 26.75);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (5, 5, '2022-08-05', 12.75, 1.00, 13.75);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (6, 1, '2022-10-20', 18.50, 1.40, 19.90);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (7, 2, '2023-01-02', 30.00, 2.10, 32.10);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (8, 3, '2021-06-15', 22.75, 1.70, 24.45);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (9, 4, '2022-02-28', 9.99, 0.75, 10.74);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (10, 5, '2022-07-14', 14.25, 1.10, 15.35);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (11, 1, '2022-11-27', 19.99, 1.50, 21.49);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (12, 2, '2023-03-10', 8.50, 0.60, 9.10);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (13, 3, '2021-07-23', 27.50, 1.90, 29.40);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (14, 4, '2022-01-15', 16.75, 1.30, 18.05);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (15, 5, '2022-06-28', 11.50, 0.90, 12.40);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (16, 1, '2022-12-11', 23.75, 1.80, 25.55);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (17, 2, '2023-04-24', 7.99, 0.60, 8.59);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (18, 3, '2021-08-06', 33.50, 2.30, 35.80);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (19, 4, '2022-02-19', 13.25, 1.00, 14.25);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (20, 5, '2022-07-04', 20.50, 1.60, 22.10);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (21, 1, '2022-11-17', 10.99, 0.80, 11.79);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (22, 2, '2023-03-01', 25.75, 1.90, 27.65);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (23, 3, '2021-06-13', 17.50, 1.30, 18.80);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (24, 4, '2022-01-26', 11.75, 0.90, 12.65);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (25, 5, '2022-06-09', 28.50, 2.10, 30.60);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (26, 1, '2022-11-22', 9.99, 0.75, 10.74);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (27, 2, '2023-02-03', 14.50, 1.10, 15.60);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (28, 3, '2021-07-16', 19.99, 1.50, 21.49);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (29, 4, '2022-01-30', 8.50, 0.60, 9.10);
INSERT INTO CTRANSACTION (CustomerID, LibraryID, TransactionDate, Subtotal, Tax, Total) 
VALUES (30, 5, '2022-06-14', 27.50, 1.90, 29.40);

--ITEM TABLE (UnitPrice, Description)
INSERT INTO ITEM (UnitPrice, Description) VALUES (5.00, 'Gum');
INSERT INTO ITEM (UnitPrice, Description) VALUES (2.99, 'Pen');
INSERT INTO ITEM (UnitPrice, Description) VALUES (10.99, 'Notebook');
INSERT INTO ITEM (UnitPrice, Description) VALUES (3.50, 'Pencil');
INSERT INTO ITEM (UnitPrice, Description) VALUES (6.99, 'Eraser');
INSERT INTO ITEM (UnitPrice, Description) VALUES (12.99, 'Highlighter');
INSERT INTO ITEM (UnitPrice, Description) VALUES (4.50, 'Ruler');
INSERT INTO ITEM (UnitPrice, Description) VALUES (8.99, 'Scissors');
INSERT INTO ITEM (UnitPrice, Description) VALUES (1.99, 'Stapler');
INSERT INTO ITEM (UnitPrice, Description) VALUES (7.50, 'Paper Clips');
INSERT INTO ITEM (UnitPrice, Description) VALUES (9.99, 'Binder');
INSERT INTO ITEM (UnitPrice, Description) VALUES (2.50, 'Index Cards');
INSERT INTO ITEM (UnitPrice, Description) VALUES (5.99, 'Glue Stick');
INSERT INTO ITEM (UnitPrice, Description) VALUES (3.99, 'Markers');
INSERT INTO ITEM (UnitPrice, Description) VALUES (11.50, 'Calculator');
INSERT INTO ITEM (UnitPrice, Description) VALUES (6.50, 'File Folders');
INSERT INTO ITEM (UnitPrice, Description) VALUES (4.99, 'Tape');
INSERT INTO ITEM (UnitPrice, Description) VALUES (8.50, 'Note Pads');
INSERT INTO ITEM (UnitPrice, Description) VALUES (1.50, 'Paper Clips');
INSERT INTO ITEM (UnitPrice, Description) VALUES (9.50, 'Sticky Notes');
INSERT INTO ITEM (UnitPrice, Description) VALUES (5.50, 'Paper');
INSERT INTO ITEM (UnitPrice, Description) VALUES (7.99, 'Whiteboard Marker');
INSERT INTO ITEM (UnitPrice, Description) VALUES (2.50, 'Binder Clips');
INSERT INTO ITEM (UnitPrice, Description) VALUES (10.50, 'Highlighter Set');
INSERT INTO ITEM (UnitPrice, Description) VALUES (3.50, 'Correction Tape');
INSERT INTO ITEM (UnitPrice, Description) VALUES (6.50, 'Push Pins');
INSERT INTO ITEM (UnitPrice, Description) VALUES (12.50, 'Desk Organizer');
INSERT INTO ITEM (UnitPrice, Description) VALUES (4.50, 'Rubber Bands');
INSERT INTO ITEM (UnitPrice, Description) VALUES (8.99, 'Paper Cutter');
INSERT INTO ITEM (UnitPrice, Description) VALUES (1.99, 'Paper Clips Dispenser');

--ORDER_LINE TABLE (OrderLineNumber, TransactionID, ItemID, Quantity)
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 1, 2, 2);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (2, 1, 3, 1);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (3, 1, 4, 3);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (4, 1, 5, 2);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (5, 1, 6, 1);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (6, 1, 7, 4);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (7, 1, 8, 2);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (8, 1, 9, 1);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (9, 1, 10, 3);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (10, 1, 11, 2);

-- TransactionID 2
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 2, 12, 1);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (2, 2, 13, 3);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (3, 2, 14, 2);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (4, 2, 15, 1);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (5, 2, 16, 4);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (6, 2, 17, 2);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (7, 2, 18, 1);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (8, 2, 19, 3);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (9, 2, 20, 2);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (10, 2, 21, 1);

-- TransactionID 3
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 3, 22, 2);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (2, 3, 23, 1);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (3, 3, 24, 4);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (4, 3, 25, 2);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (5, 3, 26, 1);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (6, 3, 27, 3);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (7, 3, 28, 2);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (8, 3, 29, 1);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (9, 3, 30, 4);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (10, 3, 1, 2);

-- TransactionID 4
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 4, 2, 3);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (2, 4, 3, 2);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (3, 4, 4, 1);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (4, 4, 5, 4);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (5, 4, 6, 2);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (6, 4, 7, 1);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (7, 4, 8, 3);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (8, 4, 9, 2);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (9, 4, 10, 1);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (10, 4, 11, 4);

-- TransactionID 5
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 5, 12, 2);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (2, 5, 13, 1);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (3, 5, 14, 4);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (4, 5, 15, 2);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (5, 5, 16, 1);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (6, 5, 17, 3);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (7, 5, 18, 2);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (8, 5, 19, 1);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (9, 5, 20, 4);
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (10, 5, 21, 2);

-- TransactionID 6
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 6, 22, 2);

-- TransactionID 7
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 7, 23, 3);

-- TransactionID 8
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 8, 24, 1);

-- TransactionID 9
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 9, 25, 4);

-- TransactionID 10
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 10, 26, 2);

-- TransactionID 11
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 11, 27, 1);

-- TransactionID 12
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 12, 28, 3);

-- TransactionID 13
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 13, 29, 2);

-- TransactionID 14
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 14, 30, 1);

-- TransactionID 15
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 15, 1, 4);

-- TransactionID 16
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 16, 2, 2);

-- TransactionID 17
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 17, 3, 1);

-- TransactionID 18
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 18, 4, 3);

-- TransactionID 19
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 19, 5, 2);

-- TransactionID 20
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 20, 6, 1);

-- TransactionID 21
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 21, 7, 4);

-- TransactionID 22
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 22, 8, 2);

-- TransactionID 23
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 23, 9, 1);

-- TransactionID 24
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 24, 10, 3);

-- TransactionID 25
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 25, 11, 2);

-- TransactionID 26
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 26, 12, 1);

-- TransactionID 27
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 27, 13, 4);

-- TransactionID 28
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 28, 14, 2);

-- TransactionID 29
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 29, 15, 1);

-- TransactionID 30
INSERT INTO ORDER_LINE (OrderLineNumber, TransactionID, ItemID, Quantity) VALUES (1, 30, 16, 3);

--EVENT TABLE (LibraryID, EventName, EventDescription, DateOfEvent)
--You may use LibraryIDs 1-5, Any event name you want, a proper description of the event, and any date between 2021-2023 (current day 2023-5-17)
INSERT INTO EVENT (LibraryID, EventName, EventDescription, DateOfEvent) VALUES (1, 'Dr. Seuss Book Signing', 'The author is here to sign your books! Fun!', '2023-02-05');
INSERT INTO EVENT (LibraryID, EventName, EventDescription, DateOfEvent) VALUES (2, 'Storytelling Workshop', 'Learn the art of storytelling from renowned storytellers.', '2022-07-15');
INSERT INTO EVENT (LibraryID, EventName, EventDescription, DateOfEvent) VALUES (3, 'Science Fair', 'Discover the wonders of science through hands-on experiments.', '2022-09-20');
INSERT INTO EVENT (LibraryID, EventName, EventDescription, DateOfEvent) VALUES  (4, 'Author Meet and Greet', 'Meet your favorite author and get your books signed.', '2022-11-08');
INSERT INTO EVENT (LibraryID, EventName, EventDescription, DateOfEvent) VALUES  (5, 'Trivia Night', 'Test your knowledge with an exciting trivia competition.', '2022-06-30');
INSERT INTO EVENT (LibraryID, EventName, EventDescription, DateOfEvent) VALUES  (1, 'Crafting Workshop', 'Get creative and learn new crafting techniques.', '2022-10-05');
INSERT INTO EVENT (LibraryID, EventName, EventDescription, DateOfEvent) VALUES  (2, 'Family Movie Night', 'Enjoy a family-friendly movie screening at the library.', '2023-01-21');
INSERT INTO EVENT (LibraryID, EventName, EventDescription, DateOfEvent) VALUES  (3, 'Cooking Class', 'Learn to cook delicious recipes from professional chefs.', '2022-08-12');
INSERT INTO EVENT (LibraryID, EventName, EventDescription, DateOfEvent) VALUES  (4, 'Book Club Discussion', 'Join fellow book lovers for a lively book discussion.', '2023-03-17');
INSERT INTO EVENT (LibraryID, EventName, EventDescription, DateOfEvent) VALUES  (5, 'Art Exhibition', 'Explore the works of local artists in a captivating art exhibition.', '2022-12-02');
INSERT INTO EVENT (LibraryID, EventName, EventDescription, DateOfEvent) VALUES  (1, 'Coding Workshop', 'Discover the world of coding and programming.', '2022-09-10');
INSERT INTO EVENT (LibraryID, EventName, EventDescription, DateOfEvent) VALUES  (2, 'Movie Marathon', 'Indulge in a marathon of your favorite movie series.', '2023-04-25');
INSERT INTO EVENT (LibraryID, EventName, EventDescription, DateOfEvent) VALUES  (3, 'Poetry Slam', 'Showcase your poetic talents or enjoy the performances of others.', '2022-11-19');
INSERT INTO EVENT (LibraryID, EventName, EventDescription, DateOfEvent) VALUES  (4, 'Chess Tournament', 'Test your strategic skills in an exciting chess tournament.', '2023-02-28');
INSERT INTO EVENT (LibraryID, EventName, EventDescription, DateOfEvent) VALUES  (5, 'Storytime for Kids', 'Engage your little ones with captivating storytelling sessions.', '2022-07-08');
INSERT INTO EVENT (LibraryID, EventName, EventDescription, DateOfEvent) VALUES  (1, 'Photography Exhibition', 'Admire the beauty captured through the lenses of talented photographers.', '2023-01-13');
INSERT INTO EVENT (LibraryID, EventName, EventDescription, DateOfEvent) VALUES  (2, 'Yoga Class', 'Relax your mind and body with a rejuvenating yoga session.', '2022-10-30');
INSERT INTO EVENT (LibraryID, EventName, EventDescription, DateOfEvent) VALUES  (3, 'Teen Book Club', 'Connect with fellow teenage readers and discuss your favorite books.', '2022-08-24');
INSERT INTO EVENT (LibraryID, EventName, EventDescription, DateOfEvent) VALUES  (4, 'Painting Workshop', 'Unleash your creativity in a guided painting workshop.', '2023-03-05');
INSERT INTO EVENT (LibraryID, EventName, EventDescription, DateOfEvent) VALUES  (5, 'Lecture Series: History of Art', 'Gain insights into the fascinating world of art history.', '2022-12-18');

--PUBLISHER TABLE (PublisherName)
INSERT INTO PUBLISHER VALUES ('Bethesda Softworks');
INSERT INTO PUBLISHER VALUES ('Penguin Random House');
INSERT INTO PUBLISHER VALUES ('HarperCollins');
INSERT INTO PUBLISHER VALUES ('Simon & Schuster');
INSERT INTO PUBLISHER VALUES ('Hachette Book Group');
INSERT INTO PUBLISHER VALUES ('Macmillan Publishers');
INSERT INTO PUBLISHER VALUES ('Pearson Education');
INSERT INTO PUBLISHER VALUES ('Scholastic Corporation');
INSERT INTO PUBLISHER VALUES ('Wiley');
INSERT INTO PUBLISHER VALUES ('Bloomsbury Publishing');
INSERT INTO PUBLISHER VALUES ('Oxford University Press');
INSERT INTO PUBLISHER VALUES ('Cambridge University Press');
INSERT INTO PUBLISHER VALUES ('Springer');
INSERT INTO PUBLISHER VALUES ('Elsevier');
INSERT INTO PUBLISHER VALUES ('McGraw-Hill Education');
INSERT INTO PUBLISHER VALUES ('Houghton Mifflin Harcourt');
INSERT INTO PUBLISHER VALUES ('Holtzbrinck Publishing Group');
INSERT INTO PUBLISHER VALUES ('Cengage Learning');
INSERT INTO PUBLISHER VALUES ('National Geographic Partners');
INSERT INTO PUBLISHER VALUES ('SAGE Publishing');

--BOOK TABLE (BookName, PageCount, AuthorName, PublisherID) 100 books
INSERT INTO BOOK VALUES ('How to Poop', 49, 'Dick Henry', 1);
INSERT INTO BOOK VALUES ('The Great Gatsby', 180, 'F. Scott Fitzgerald', 2);
INSERT INTO BOOK VALUES ('To Kill a Mockingbird', 281, 'Harper Lee', 3);
INSERT INTO BOOK VALUES ('1984', 328, 'George Orwell', 4);
INSERT INTO BOOK VALUES ('Pride and Prejudice', 279, 'Jane Austen', 5);
INSERT INTO BOOK VALUES ('The Catcher in the Rye', 230, 'J.D. Salinger', 6);
INSERT INTO BOOK VALUES ('Harry Potter and the Sorcerer''s Stone', 320, 'J.K. Rowling', 7);
INSERT INTO BOOK VALUES ('The Hobbit', 310, 'J.R.R. Tolkien', 8);
INSERT INTO BOOK VALUES ('Moby-Dick', 635, 'Herman Melville', 9);
INSERT INTO BOOK VALUES ('Jane Eyre', 507, 'Charlotte Bronte', 10);
INSERT INTO BOOK VALUES ('The Lord of the Rings', 1178, 'J.R.R. Tolkien', 8);
INSERT INTO BOOK VALUES ('The Odyssey', 374, 'Homer', 11);
INSERT INTO BOOK VALUES ('The Adventures of Huckleberry Finn', 366, 'Mark Twain', 12);
INSERT INTO BOOK VALUES ('Brave New World', 311, 'Aldous Huxley', 13);
INSERT INTO BOOK VALUES ('The Great Expectations', 544, 'Charles Dickens', 14);
INSERT INTO BOOK VALUES ('The Alchemist', 197, 'Paulo Coelho', 15);
INSERT INTO BOOK VALUES ('The Count of Monte Cristo', 1276, 'Alexandre Dumas', 16);
INSERT INTO BOOK VALUES ('The Picture of Dorian Gray', 254, 'Oscar Wilde', 17);
INSERT INTO BOOK VALUES ('The Little Prince', 98, 'Antoine de Saint-Exupery', 18);
INSERT INTO BOOK VALUES ('The Grapes of Wrath', 464, 'John Steinbeck', 19);
INSERT INTO BOOK VALUES ('The Scarlet Letter', 238, 'Nathaniel Hawthorne', 20);
INSERT INTO BOOK VALUES ('The Secret Life of Squirrels', 150, 'Nutty McAcorn', 1);
INSERT INTO BOOK VALUES ('How to Train Your Unicorn', 200, 'Sparkle Rainbow', 2);
INSERT INTO BOOK VALUES ('The Art of Procrastination', 100, 'Lazy McLazyface', 3);
INSERT INTO BOOK VALUES ('Cooking with Ice Cream', 75, 'Scoop Frostington', 4);
INSERT INTO BOOK VALUES ('The Zen of Zombie Gardening', 250, 'Mort Greenthumb', 5);
INSERT INTO BOOK VALUES ('The Adventures of Captain Cupcake', 180, 'Baker Sweettooth', 6);
INSERT INTO BOOK VALUES ('The Curious Case of the Dancing Cactus', 220, 'Prickles McTwist', 7);
INSERT INTO BOOK VALUES ('The Misadventures of a Pirate Penguin', 190, 'Captain Waddles', 8);
INSERT INTO BOOK VALUES ('The Secret Diary of a Talking Pizza', 150, 'Cheesy McSlice', 9);
INSERT INTO BOOK VALUES ('The Magical Journey of a Time-Traveling Hamster', 200, 'Whiskers Chronos', 10);
INSERT INTO BOOK VALUES ('The Mysterious Case of the Vanishing Socks', 180, 'Detective Sniffles', 11);
INSERT INTO BOOK VALUES ('The Silly Science Experiments Handbook', 120, 'Professor Gigglepants', 12);
INSERT INTO BOOK VALUES ('The Wacky Adventures of a Flying Pig', 140, 'Pinky Wingston', 13);
INSERT INTO BOOK VALUES ('The Epic Quest for the Last Piece of Chocolate', 160, 'Choco Loverman', 14);
INSERT INTO BOOK VALUES ('The Secret Language of Gummy Bears', 110, 'Jelly McJiggle', 15);
INSERT INTO BOOK VALUES ('The Amazing World of Underwater Basket Weaving', 130, 'Bubbles McBasket', 16);
INSERT INTO BOOK VALUES ('The Unbelievable Tales of a Superpowered Banana', 170, 'Peely McGreen', 17);
INSERT INTO BOOK VALUES ('The Gigantic Book of Punny Jokes', 90, 'Laffy McLaughster', 18);
INSERT INTO BOOK VALUES ('The Enchanted Adventures of a Talking Teapot', 200, 'Sir Steeps-a-Lot', 19);
INSERT INTO BOOK VALUES ('The Legend of the Singing Rubber Chicken', 150, 'Feathers McSquawk', 20);
INSERT INTO BOOK VALUES ('The Incredible Adventures of Captain Pencil', 180, 'Eraser McRubout', 1);
INSERT INTO BOOK VALUES ('The Magic Recipe for Unicorn Cupcakes', 120, 'Sprinkle Stardust', 2);
INSERT INTO BOOK VALUES ('The Lazy Person''s Guide to Extreme Napping', 100, 'Snoozy McDoze', 3);
INSERT INTO BOOK VALUES ('The Wonders of Cheese Sculpting', 150, 'Cheddar Carver', 4);
INSERT INTO BOOK VALUES ('The Extraordinary Tales of a Tap-Dancing Elephant', 200, 'Jumbo Shufflefeet', 5);
INSERT INTO BOOK VALUES ('The Secret Diary of a Superhero Squirrel', 160, 'Nutty McSneakers', 6);
INSERT INTO BOOK VALUES ('The Adventures of Sir Whiskers, the Dashing Cat Knight', 180, 'Purrington the Brave', 7);
INSERT INTO BOOK VALUES ('The Mysterious Case of the Disappearing Socks', 140, 'Sleuthy McSniff', 8);
INSERT INTO BOOK VALUES ('The Amazing World of Talking Pickles', 120, 'Pickleberry Cucumber', 9);
INSERT INTO BOOK VALUES ('The Unbelievable Journey of a Spaghetti Lasso', 170, 'Noodle Wrangler', 10);
INSERT INTO BOOK VALUES ('The Curious Tale of the Dancing Tacos', 200, 'Taco Tango', 11);
INSERT INTO BOOK VALUES ('The Silly Science Experiments of Dr. Bubbles', 150, 'Professor Bubblegum', 12);
INSERT INTO BOOK VALUES ('The Epic Quest for the Legendary Sock Monkey', 130, 'Socky McStuffins', 13);
INSERT INTO BOOK VALUES ('The Wacky Adventures of a Skating Banana', 160, 'Peels McSlip', 14);
INSERT INTO BOOK VALUES ('The Fantastic World of Jellybean Mathematics', 110, 'Count Candyman', 15);
INSERT INTO BOOK VALUES ('The Ultimate Guide to Underwater Basket Weaving', 140, 'Spongebob Weavypants', 16);
INSERT INTO BOOK VALUES ('The Unbelievable Tales of a Superpowered Cabbage', 170, 'Captain Crunchslaw', 17);
INSERT INTO BOOK VALUES ('The Gigantic Book of Silly Knock-Knock Jokes', 90, 'Chuckle McPunchline', 18);
INSERT INTO BOOK VALUES ('The Enchanted Adventures of a Talking Teapot', 200, 'Lady Sippington', 19);
INSERT INTO BOOK VALUES ('The Legend of the Dancing Rubber Chicken', 150, 'Feather McFunky', 20);
INSERT INTO BOOK VALUES ('The Secret Life of Unicorns: From Rainbows to Reality', 180, 'Sparkle McRainbow', 1);
INSERT INTO BOOK VALUES ('The Adventures of Sir Quackington: The Fearless Duck Knight', 120, 'Feathers McDuckerson', 2);
INSERT INTO BOOK VALUES ('The Art of Procrastination: Mastering the Fine Art of Doing Nothing', 100, 'Lazy McLazyface', 3);
INSERT INTO BOOK VALUES ('The Cheese Lover''s Guide to the Galaxy: A Gouda Journey through Space', 150, 'Cheesy McCheeserson', 4);
INSERT INTO BOOK VALUES ('The Remarkable Journey of a Tap-Dancing Giraffe', 200, 'Twinkle Toes Girafferson', 5);
INSERT INTO BOOK VALUES ('The Misadventures of Captain Clumsy: The World''s Most Uncoordinated Superhero', 160, 'Trippy McSlippery', 6);
INSERT INTO BOOK VALUES ('The Catnip Chronicles: Tales of a Mischief-Making Feline', 180, 'Whiskers McWhiskerson', 7);
INSERT INTO BOOK VALUES ('The Mystery of the Vanishing Snacks: A Detective Dog''s Nosey Tale', 140, 'Sherlock Sniffington', 8);
INSERT INTO BOOK VALUES ('The Unbelievable Life of Mr. Pickle: From Cucumber to Superstar', 120, 'Pickle McPickleface', 9);
INSERT INTO BOOK VALUES ('The Spaghetti Saga: A Noodle-Filled Adventure of Twists and Turns', 170, 'Al Dente Macaroni', 10);
INSERT INTO BOOK VALUES ('The Hilarious Hijinks of Sir Bumblebee: Buzzing into Trouble', 200, 'Buzz McBuzzerson', 11);
INSERT INTO BOOK VALUES ('The Silly Science Experiments of Dr. Whizbang: Explosions and Giggles', 150, 'Professor Fizzletop', 12);
INSERT INTO BOOK VALUES ('The Epic Quest for the Legendary Teddy Bear: Cuddles and Adventure', 130, 'Huggington McSnuggles', 13);
INSERT INTO BOOK VALUES ('The Daring Adventures of Captain Banana: A Slippery Superhero''s Journey', 160, 'Peelston Peelington', 14);
INSERT INTO BOOK VALUES ('The Fantastic World of Jellybean Mathematics: Counting with Sweetness', 110, 'Sugar McCountington', 15);
INSERT INTO BOOK VALUES ('The Unconventional Guide to Underwater Basket Weaving: Diving into Creativity', 140, 'Bubbles McWeaver', 16);
INSERT INTO BOOK VALUES ('The Extraordinary Tales of a Superpowered Cabbage: Crunching Crime with Coleslaw', 170, 'Cabbage McBrawn', 17);
INSERT INTO BOOK VALUES ('The Giggle Factory: A Collection of Silly Jokes and Laughter', 90, 'Chuckler McTickle', 18);
INSERT INTO BOOK VALUES ('The Enchanted Adventures of a Talking Teapot: Sipping Tea with Magic', 200, 'Lumina Brewster', 19);
INSERT INTO BOOK VALUES ('The Legend of the Dancing Rubber Chicken: Feathered Follies and Funky Moves', 150, 'Funky McChicken', 20);
INSERT INTO BOOK VALUES ('The Mysterious Case of the Disappearing Socks: An Unforgettable Laundry Adventure', 140, 'Detective Lintington', 1);
INSERT INTO BOOK VALUES ('The Curious Tale of the Talking Toilet: Flush and Learn', 120, 'Sir Flushington', 2);
INSERT INTO BOOK VALUES ('The Extraordinary Life of Mr. Whiskers: Lessons in Catnip and Napping', 180, 'Whiskerington Purrson', 3);
INSERT INTO BOOK VALUES ('The Banana Chronicles: A Peel-a-Minute Adventure', 150, 'Peely McPeelerson', 4);
INSERT INTO BOOK VALUES ('The Incredible Journey of a Sock Puppet: Finding the Lost Pair', 200, 'Socky McSockerson', 5);
INSERT INTO BOOK VALUES ('The Daring Escapades of Captain Clumsy: Tripping through Time', 160, 'Captain Tumblebottom', 6);
INSERT INTO BOOK VALUES ('The Paw-some Paw Patrol: Furry Heroes Saving the Day', 180, 'Pawly McPawerson', 7);
INSERT INTO BOOK VALUES ('The Puzzling Case of the Vanishing Bone: A Canine Detective''s Tale', 140, 'Sherlock Bones', 8);
INSERT INTO BOOK VALUES ('The Adventures of Super Cucumber: Saving Salads from Evil', 120, 'Cucumbertastic', 9);
INSERT INTO BOOK VALUES ('The Noodle Expedition: Spaghetti Slurping and Pasta Perils', 170, 'Penne McTwirly', 10);
INSERT INTO BOOK VALUES ('The Whisker-Whacking Adventures of Sir Whiskers: Meows and Mayhem', 200, 'Sir Whiskerface', 11);
INSERT INTO BOOK VALUES ('The Laugh Lab: Hilarious Experiments in Giggling and Grinning', 150, 'Professor Chuckles', 12);
INSERT INTO BOOK VALUES ('The Epic Quest for the Golden Teddy Bear: Hugs and Adventure', 130, 'Teddy McHuggington', 13);
INSERT INTO BOOK VALUES ('The Incredible Exploits of Captain Banana: A Fruitful Journey', 160, 'Captain Peelings', 14);
INSERT INTO BOOK VALUES ('The Wacky World of Jellybean Mathematics: Counting with Sweetness', 110, 'Jelly McBean', 15);
INSERT INTO BOOK VALUES ('The Unusual Guide to Underwater Basket Weaving: Diving into Creativity', 140, 'Bubbles McBasketweaver', 16);
INSERT INTO BOOK VALUES ('The Superpowered Cabbage Chronicles: Crunching Crime with Coleslaw', 170, 'Captain Cabbage', 17);
INSERT INTO BOOK VALUES ('The Giggle Factory: A Collection of Silly Jokes and Laughter', 90, 'Jester McLaughsalot', 18);
INSERT INTO BOOK VALUES ('The Enchanted Adventures of a Talking Teapot: Sipping Tea with Magic', 200, 'Tea-licious', 19);

--SHIPMNT TABLE (LibraryID, Description, Quantity, ShipDate) 20 shipments, if a book or item has no shipment, then the next ship date is TBDINSERT INTO SHIPMENT VALUES (1, 'The Enchanted Adventures of a Talking Teapot: Sipping Tea with Magic', 50, '2023-6-20');
INSERT INTO SHIPMENT VALUES (2, 'The Adventures of Huckleberry Finn', 400, '2023-06-15');
INSERT INTO SHIPMENT VALUES (3, 'The Great Gatsby', 300, '2023-07-30');
INSERT INTO SHIPMENT VALUES (4, 'The Curious Case of the Dancing Cactus', 150, '2023-08-10');
INSERT INTO SHIPMENT VALUES (5, 'The Mysterious Case of the Disappearing Socks', 250, '2023-09-20');
INSERT INTO SHIPMENT VALUES (1, 'The Misadventures of a Pirate Penguin', 175, '2023-10-05');
INSERT INTO SHIPMENT VALUES (2, 'The Art of Procrastination', 325, '2023-11-12');
INSERT INTO SHIPMENT VALUES (3, 'The Cheese Lover''s Guide to the Galaxy: A Gouda Journey through Space', 120, '2023-12-01');
INSERT INTO SHIPMENT VALUES (4, 'The Amazing World of Talking Pickles', 275, '2024-01-13');
INSERT INTO SHIPMENT VALUES (5, 'The Daring Adventures of Captain Banana: A Slippery Superhero''s Journey', 150, '2024-02-28');
INSERT INTO SHIPMENT VALUES (1, 'The Unbelievable Tales of a Superpowered Cabbage', 200, '2024-03-07');
INSERT INTO SHIPMENT VALUES (2, 'The Extraordinary Tales of a Superpowered Cabbage: Crunching Crime with Coleslaw', 175, '2024-04-16');
INSERT INTO SHIPMENT VALUES (3, 'The Spaghetti Saga: A Noodle-Filled Adventure of Twists and Turns', 225, '2024-05-10');
INSERT INTO SHIPMENT VALUES (4, 'The Mysterious Case of the Vanishing Socks: An Unforgettable Laundry Adventure', 350, '2024-06-20');
INSERT INTO SHIPMENT VALUES (5, 'The Banana Chronicles: A Peel-a-Minute Adventure', 500, '2024-07-02');
INSERT INTO SHIPMENT VALUES (1, 'The Adventures of Super Cucumber: Saving Salads from Evil', 400, '2024-08-15');
INSERT INTO SHIPMENT VALUES (1, '1984', 150, '2023-08-20');
INSERT INTO SHIPMENT VALUES (2, 'The Legend of the Dancing Rubber Chicken: Feathered Follies and Funky Moves', 300, '2023-12-15');
INSERT INTO SHIPMENT VALUES (3, 'The Mysterious Case of the Vanishing Socks: An Unforgettable Laundry Adventure', 75, '2024-02-10');
INSERT INTO SHIPMENT VALUES (4, 'Notebook', 200, '2023-07-05');

--INVENTORY TABLE (LibraryID, ShipmentID)INSERT INTO INVENTORY VALUES (2, 2);
INSERT INTO INVENTORY VALUES (3, 3);
INSERT INTO INVENTORY VALUES (4, 4);
INSERT INTO INVENTORY VALUES (5, 5);

--GENRE TABLE
INSERT INTO GENRE VALUES ('Romance');
INSERT INTO GENRE VALUES ('Fantasy');
INSERT INTO GENRE VALUES ('Thriller');
INSERT INTO GENRE VALUES ('Horror');
INSERT INTO GENRE VALUES ('Historical Fiction');
INSERT INTO GENRE VALUES ('Biography');
INSERT INTO GENRE VALUES ('Self-Help');
INSERT INTO GENRE VALUES ('Memoir');
INSERT INTO GENRE VALUES ('Young Adult');
INSERT INTO GENRE VALUES ('Crime');
INSERT INTO GENRE VALUES ('Adventure');
INSERT INTO GENRE VALUES ('Contemporary');
INSERT INTO GENRE VALUES ('Dystopian');
INSERT INTO GENRE VALUES ('Non-Fiction');
INSERT INTO GENRE VALUES ('Humor');
INSERT INTO GENRE VALUES ('Suspense');
INSERT INTO GENRE VALUES ('Western');
INSERT INTO GENRE VALUES ('Action');
INSERT INTO GENRE VALUES ('Psychological Thriller');
INSERT INTO GENRE VALUES ('Historical');
INSERT INTO GENRE VALUES ('Romantic Comedy');
INSERT INTO GENRE VALUES ('Science');
INSERT INTO GENRE VALUES ('Business');
INSERT INTO GENRE VALUES ('Poetry');
INSERT INTO GENRE VALUES ('Satire');
INSERT INTO GENRE VALUES ('Graphic Novel');
INSERT INTO GENRE VALUES ('Political');
INSERT INTO GENRE VALUES ('Family');
INSERT INTO GENRE VALUES ('Mystery');
INSERT INTO GENRE VALUES ('Science Fiction');

--LIBRARY_SECTION (GenreName) 30 Genres
-- This simple table just makes an auto generated SectionID for each genre, please fill in the remaining genres from earlier.
INSERT INTO LIBRARY_SECTION VALUES ('Romance');
INSERT INTO LIBRARY_SECTION VALUES ('Mystery');
INSERT INTO LIBRARY_SECTION VALUES ('Science Fiction');
INSERT INTO LIBRARY_SECTION VALUES ('Fantasy');
INSERT INTO LIBRARY_SECTION VALUES ('Thriller');
INSERT INTO LIBRARY_SECTION VALUES ('Horror');
INSERT INTO LIBRARY_SECTION VALUES ('Historical Fiction');
INSERT INTO LIBRARY_SECTION VALUES ('Biography');
INSERT INTO LIBRARY_SECTION VALUES ('Self-Help');
INSERT INTO LIBRARY_SECTION VALUES ('Memoir');
INSERT INTO LIBRARY_SECTION VALUES ('Young Adult');
INSERT INTO LIBRARY_SECTION VALUES ('Crime');
INSERT INTO LIBRARY_SECTION VALUES ('Adventure');
INSERT INTO LIBRARY_SECTION VALUES ('Contemporary');
INSERT INTO LIBRARY_SECTION VALUES ('Dystopian');
INSERT INTO LIBRARY_SECTION VALUES ('Non-Fiction');
INSERT INTO LIBRARY_SECTION VALUES ('Humor');
INSERT INTO LIBRARY_SECTION VALUES ('Suspense');
INSERT INTO LIBRARY_SECTION VALUES ('Western');
INSERT INTO LIBRARY_SECTION VALUES ('Action');
INSERT INTO LIBRARY_SECTION VALUES ('Psychological Thriller');
INSERT INTO LIBRARY_SECTION VALUES ('Historical');
INSERT INTO LIBRARY_SECTION VALUES ('Romantic Comedy');
INSERT INTO LIBRARY_SECTION VALUES ('Science');
INSERT INTO LIBRARY_SECTION VALUES ('Business');
INSERT INTO LIBRARY_SECTION VALUES ('Poetry');
INSERT INTO LIBRARY_SECTION VALUES ('Satire');
INSERT INTO LIBRARY_SECTION VALUES ('Graphic Novel');
INSERT INTO LIBRARY_SECTION VALUES ('Political');
INSERT INTO LIBRARY_SECTION VALUES ('Family');


--AVAILABILITY TABLE (LibraryID, BookID, SectionID, Quantity)[5][100][30] 
INSERT INTO AVAILABILITY VALUES(1, 1, 1, 12);
INSERT INTO AVAILABILITY VALUES(2, 2, 2, 10);
INSERT INTO AVAILABILITY VALUES(3, 3, 3, 14);
INSERT INTO AVAILABILITY VALUES(4, 4, 4, 9);
INSERT INTO AVAILABILITY VALUES(5, 5, 5, 16);
INSERT INTO AVAILABILITY VALUES(1, 6, 6, 11);
INSERT INTO AVAILABILITY VALUES(2, 7, 7, 15);
INSERT INTO AVAILABILITY VALUES(3, 8, 8, 8);
INSERT INTO AVAILABILITY VALUES(4, 9, 9, 17);
INSERT INTO AVAILABILITY VALUES(5, 10, 10, 12);
INSERT INTO AVAILABILITY VALUES(1, 11, 11, 16);
INSERT INTO AVAILABILITY VALUES(2, 12, 12, 9);
INSERT INTO AVAILABILITY VALUES(3, 13, 13, 18);
INSERT INTO AVAILABILITY VALUES(4, 14, 14, 13);
INSERT INTO AVAILABILITY VALUES(5, 15, 15, 17);
INSERT INTO AVAILABILITY VALUES(1, 16, 16, 10);
INSERT INTO AVAILABILITY VALUES(2, 17, 17, 19);
INSERT INTO AVAILABILITY VALUES(3, 18, 18, 14);
INSERT INTO AVAILABILITY VALUES(4, 19, 19, 18);
INSERT INTO AVAILABILITY VALUES(5, 20, 20, 11);
INSERT INTO AVAILABILITY VALUES(1, 21, 21, 20);
INSERT INTO AVAILABILITY VALUES(2, 22, 22, 12);
INSERT INTO AVAILABILITY VALUES(3, 23, 23, 17);
INSERT INTO AVAILABILITY VALUES(4, 24, 24, 11);
INSERT INTO AVAILABILITY VALUES(5, 25, 25, 19);
INSERT INTO AVAILABILITY VALUES(1, 26, 26, 13);
INSERT INTO AVAILABILITY VALUES(2, 27, 27, 18);
INSERT INTO AVAILABILITY VALUES(3, 28, 28, 12);
INSERT INTO AVAILABILITY VALUES(4, 29, 29, 20);
INSERT INTO AVAILABILITY VALUES(5, 30, 30, 14);
INSERT INTO AVAILABILITY VALUES(1, 31, 1, 18);
INSERT INTO AVAILABILITY VALUES(2, 32, 2, 13);
INSERT INTO AVAILABILITY VALUES(3, 33, 3, 21);
INSERT INTO AVAILABILITY VALUES(4, 34, 4, 15);
INSERT INTO AVAILABILITY VALUES(5, 35, 5, 20);
INSERT INTO AVAILABILITY VALUES(1, 36, 6, 14);
INSERT INTO AVAILABILITY VALUES(2, 37, 7, 22);
INSERT INTO AVAILABILITY VALUES(3, 38, 8, 16);
INSERT INTO AVAILABILITY VALUES(4, 39, 9, 21);
INSERT INTO AVAILABILITY VALUES(5, 40, 10, 15);
INSERT INTO AVAILABILITY VALUES(1, 41, 11, 19);
INSERT INTO AVAILABILITY VALUES(2, 42, 12, 16);
INSERT INTO AVAILABILITY VALUES(3, 43, 13, 21);
INSERT INTO AVAILABILITY VALUES(4, 44, 14, 17);
INSERT INTO AVAILABILITY VALUES(5, 45, 15, 22);
INSERT INTO AVAILABILITY VALUES(1, 46, 16, 18);
INSERT INTO AVAILABILITY VALUES(2, 47, 17, 23);
INSERT INTO AVAILABILITY VALUES(3, 48, 18, 19);
INSERT INTO AVAILABILITY VALUES(4, 49, 19, 24);
INSERT INTO AVAILABILITY VALUES(5, 50, 20, 20);
INSERT INTO AVAILABILITY VALUES(1, 51, 21, 25);
INSERT INTO AVAILABILITY VALUES(2, 52, 22, 21);
INSERT INTO AVAILABILITY VALUES(3, 53, 23, 26);
INSERT INTO AVAILABILITY VALUES(4, 54, 24, 22);
INSERT INTO AVAILABILITY VALUES(5, 55, 25, 27);
INSERT INTO AVAILABILITY VALUES(1, 56, 26, 23);
INSERT INTO AVAILABILITY VALUES(2, 57, 27, 28);
INSERT INTO AVAILABILITY VALUES(3, 58, 28, 24);
INSERT INTO AVAILABILITY VALUES(4, 59, 29, 29);
INSERT INTO AVAILABILITY VALUES(5, 60, 30, 25);
INSERT INTO AVAILABILITY VALUES(1, 61, 1, 22);
INSERT INTO AVAILABILITY VALUES(2, 62, 2, 26);
INSERT INTO AVAILABILITY VALUES(3, 63, 3, 24);
INSERT INTO AVAILABILITY VALUES(4, 64, 4, 28);
INSERT INTO AVAILABILITY VALUES(5, 65, 5, 26);
INSERT INTO AVAILABILITY VALUES(1, 66, 6, 30);
INSERT INTO AVAILABILITY VALUES(2, 67, 7, 27);
INSERT INTO AVAILABILITY VALUES(3, 68, 8, 32);
INSERT INTO AVAILABILITY VALUES(4, 69, 9, 28);
INSERT INTO AVAILABILITY VALUES(5, 70, 10, 34);
INSERT INTO AVAILABILITY VALUES(1, 71, 11, 30);
INSERT INTO AVAILABILITY VALUES(2, 72, 12, 36);
INSERT INTO AVAILABILITY VALUES(3, 73, 13, 31);
INSERT INTO AVAILABILITY VALUES(4, 74, 14, 38);
INSERT INTO AVAILABILITY VALUES(5, 75, 15, 32);
INSERT INTO AVAILABILITY VALUES(1, 76, 16, 40);
INSERT INTO AVAILABILITY VALUES(2, 77, 17, 33);
INSERT INTO AVAILABILITY VALUES(3, 78, 18, 42);
INSERT INTO AVAILABILITY VALUES(4, 79, 19, 34);
INSERT INTO AVAILABILITY VALUES(5, 80, 20, 44);
INSERT INTO AVAILABILITY VALUES(1, 81, 21, 36);
INSERT INTO AVAILABILITY VALUES(2, 82, 22, 40);
INSERT INTO AVAILABILITY VALUES(3, 83, 23, 38);
INSERT INTO AVAILABILITY VALUES(4, 84, 24, 42);
INSERT INTO AVAILABILITY VALUES(5, 85, 25, 40);
INSERT INTO AVAILABILITY VALUES(1, 86, 26, 44);
INSERT INTO AVAILABILITY VALUES(2, 87, 27, 41);
INSERT INTO AVAILABILITY VALUES(3, 88, 28, 46);
INSERT INTO AVAILABILITY VALUES(4, 89, 29, 42);
INSERT INTO AVAILABILITY VALUES(5, 90, 30, 48);
INSERT INTO AVAILABILITY VALUES(1, 91, 1, 44);
INSERT INTO AVAILABILITY VALUES(2, 92, 2, 50);
INSERT INTO AVAILABILITY VALUES(3, 93, 3, 45);
INSERT INTO AVAILABILITY VALUES(4, 94, 4, 52);
INSERT INTO AVAILABILITY VALUES(5, 95, 5, 46);
INSERT INTO AVAILABILITY VALUES(1, 96, 6, 54);
INSERT INTO AVAILABILITY VALUES(2, 97, 7, 47);
INSERT INTO AVAILABILITY VALUES(3, 98, 8, 56);
INSERT INTO AVAILABILITY VALUES(4, 99, 9, 48);
INSERT INTO AVAILABILITY VALUES(5, 100, 10, 58);

--Generate REVIEW table (BookID(1-100 integer), Rating(1-5 stars integer), ReviewDescription(250 Characters MAX)) 30 reviews, if a book has no review then it has never been reviewed yet.
INSERT INTO REVIEW VALUES(1, 4, 'This book was terrible, but I cant help but give it 4/5 stars! I must be crazy!');
INSERT INTO REVIEW VALUES(2, 3, 'Surprisingly engaging! A solid 3-star read.');
INSERT INTO REVIEW VALUES(3, 5, 'Could not put it down, a masterpiece! Five stars!');
INSERT INTO REVIEW VALUES(4, 2, 'A bit of a slog. Interesting premise but poorly executed.');
INSERT INTO REVIEW VALUES(5, 4, 'Great read, although some plot twists were predictable.');
INSERT INTO REVIEW VALUES(6, 1, 'Disappointing. I expected much more from the author.');
INSERT INTO REVIEW VALUES(7, 3, 'Middle of the road. Not good, not bad.');
INSERT INTO REVIEW VALUES(8, 5, 'Just superb! A must-read!');
INSERT INTO REVIEW VALUES(9, 2, 'The storyline was scattered and characters unlikable.');
INSERT INTO REVIEW VALUES(10, 4, 'Intriguing plot and well-written characters. A solid 4 stars.');
INSERT INTO REVIEW VALUES(11, 3, 'Decent read, though could use more suspense.');
INSERT INTO REVIEW VALUES(12, 4, 'A surprisingly delightful read with a twisty plot.');
INSERT INTO REVIEW VALUES(13, 2, 'Too many cliches. The author needs to find a new formula.');
INSERT INTO REVIEW VALUES(14, 5, 'Best book I have read in a long time! Five stars!');
INSERT INTO REVIEW VALUES(15, 3, 'Interesting concepts but fell short on execution.');
INSERT INTO REVIEW VALUES(16, 4, 'Engaging narrative and unique story. Thoroughly enjoyed it.');
INSERT INTO REVIEW VALUES(17, 1, 'Difficult to follow with one-dimensional characters.');
INSERT INTO REVIEW VALUES(18, 5, 'A literary feast! Heartily recommend it to everyone.');
INSERT INTO REVIEW VALUES(19, 3, 'A good book for a rainy day, but not groundbreaking.');
INSERT INTO REVIEW VALUES(20, 2, 'Characters lacked depth and story was predictable.');
INSERT INTO REVIEW VALUES(21, 4, 'A thought-provoking read. Quite enjoyed it.');
INSERT INTO REVIEW VALUES(22, 5, 'This book touched my heart. A stellar read!');
INSERT INTO REVIEW VALUES(23, 2, 'The book was overly descriptive and slow-paced.');
INSERT INTO REVIEW VALUES(24, 3, 'Good book but it didn’t quite meet my expectations.');
INSERT INTO REVIEW VALUES(25, 4, 'Innovative and insightful. A joy to read.');
INSERT INTO REVIEW VALUES(26, 1, 'The plot was nonsensical and characters undeveloped.');
INSERT INTO REVIEW VALUES(27, 5, 'Exquisite storytelling. I was hooked from page one.');
INSERT INTO REVIEW VALUES(28, 3, 'An average read. Interesting premise but lackluster delivery.');
INSERT INTO REVIEW VALUES(29, 4, 'An emotional rollercoaster. Highly recommend!');
INSERT INTO REVIEW VALUES(30, 2, 'The plot had potential but was sadly undeveloped.');

GO

--THIS FILE MAKES OUR QUERIES
USE LibraryDB
GO

-- SCENARIO 1a: Find book by name
SELECT 
	BOOK.BookID,
	BOOK.BookName as 'Book Name',
	BOOK.PageCount as 'Page Count',
	BOOK.AuthorName as 'Author Name',
	PUBLISHER.PublisherName as 'Publisher Name'
FROM BOOK
INNER JOIN PUBLISHER ON PUBLISHER.PublisherID = BOOK.BookID
WHERE BookName = 'The Great Gatsby';

-- SCENARIO 1b: Find books by author and genre
SELECT 
	BOOK.BookID, 
	BOOK.BookName as 'Book Name', 
	BOOK.AuthorName as 'Author Name', 
	GENRE.GenreName as 'Genre Name'
FROM 
	BOOK
INNER JOIN AVAILABILITY ON BOOK.BookID = AVAILABILITY.BookID
INNER JOIN LIBRARY_SECTION ON AVAILABILITY.SectionID = LIBRARY_SECTION.SectionID
INNER JOIN GENRE ON LIBRARY_SECTION.GenreName = GENRE.GenreName
WHERE 
	BOOK.AuthorName = 'Dick Henry' AND 
	GENRE.GenreName = 'Romance';

-- SCENARIO 1c: Find books by rating
SELECT 
	BOOK.BookID, 
	BOOK.BookName as 'Book Name', 
	AVG(REVIEW.Rating) AS 'Average Rating'
FROM 
	BOOK
INNER JOIN REVIEW ON BOOK.BookID = REVIEW.BookID
GROUP BY 
	BOOK.BookID, 
	BOOK.BookName
HAVING 
	AVG(REVIEW.Rating) >= 3;

-- SCENARIO 1d: Find the books by a certain publisher
SELECT 
	BOOK.BookID,
	BOOK.BookName as 'Book Name',
	BOOK.PageCount as 'Page Count',
	BOOK.AuthorName as 'Author Name',
	PUBLISHER.PublisherName as 'Publisher Name'
FROM 
	BOOK
INNER JOIN PUBLISHER ON BOOK.PublisherID = PUBLISHER.PublisherID
WHERE 
	PUBLISHER.PublisherName = 'Bethesda Softworks';

-- SCENARIO 2a: Check availability of a certain book at a specified library ID.
SELECT
	AVAILABILITY.LibraryID,
	BOOK.BookName as 'Book Name',
	AVAILABILITY.Quantity
FROM
	BOOK
INNER JOIN AVAILABILITY ON BOOK.BookID = AVAILABILITY.BookID
WHERE
	BOOK.BookName = 'The Adventures of Huckleberry Finn' AND
	AVAILABILITY.LibraryID = 3 AND
	AVAILABILITY.Quantity > 0;

-- SCENARIO 2b: Check when and where the next shipment for a book is. If no shipment is found, then there are no upcoming shipments for the specified book.
SELECT
	SHIPMENT.ShipDate as 'Ship Date',
	SHIPMENT.LibraryID,
	SHIPMENT.Quantity
FROM
	SHIPMENT
INNER JOIN BOOK ON SHIPMENT.Description = BOOK.BookName
WHERE
	BOOK.BookName = 'The Art of Procrastination'
	

-- SCENARIO 3: Users should be able to purchase a membership with this library franchise.
DECLARE @NewMembershipID int;

BEGIN TRANSACTION;

-- Create the new membership
INSERT INTO MEMBERSHIP(StartDate, EndDate)
VALUES('2023-06-01', '2023-07-01');

-- Get the ID of the newly inserted membership
SET @NewMembershipID = SCOPE_IDENTITY();

-- Update the existing customer to use the new membership ID
UPDATE CUSTOMER
SET MembershipID = @NewMembershipID
WHERE CustomerID = 1; -- Replace with your actual customer ID

COMMIT;	-- At this point you can check the customer in CUSTOMER table with customerID 1 and see if their membershipID has changed

-- SCENARIO 4: Customers should be able to check for upcoming events at different library locations in the franchise.
SELECT
	EVENT.DateOfEvent as 'Event Date',
	EVENT.EventName as 'Event Name',
	EVENT.EventDescription as 'Description'
FROM
	EVENT
WHERE
	EVENT.LibraryID = 1

	--SCENARIO 5: Employees should be able to track incoming shipments to the library.
SELECT
    SHIPMENT.LibraryID,
	SHIPMENT.ShipmentID,
    SHIPMENT.ShipDate,
    BOOK.BookName AS 'Book Name',
    SHIPMENT.Quantity
FROM
	SHIPMENT
INNER JOIN BOOK ON SHIPMENT.Description = BOOK.BookName
WHERE
    SHIPMENT.LibraryID = 3

--Scenario 6: Users should be able to register within the library system. 
DECLARE @NewCustomerID int;

BEGIN TRANSACTION;

INSERT INTO CUSTOMER VALUES('Josh Smith', 47, 1, 98101, 'hosmith@example.com', '2229876543', null);

SET @NewCustomerID = SCOPE_IDENTITY();
COMMIT;
GO

--Scenario 7 & 8: The system should be able to keep track of inventory changes when books are sold/checkedout or vise versa.
CREATE PROCEDURE SellBook 
    @BookID INT,
    @Quantity INT
AS
BEGIN
    UPDATE AVAILABILITY 
    SET Quantity = Quantity - 1
    WHERE BookID = 10;
    
    -- To prevent negative values in Quantity field
    UPDATE AVAILABILITY 
    SET Quantity = 0
    WHERE Quantity < 0;
END
GO -- We can call this procedure using EXEC SellBook @BookID, @Quantity

--Analytical Query 1a:  Find a book by a specific author and/or at a specified library. 
--Author and Rating Completed by Scenario 1b and 1c
SELECT
    AVAILABILITY.LibraryID,
    BOOK.BookName,
    AVAILABILITY.Quantity
FROM
    AVAILABILITY
INNER JOIN
    BOOK ON AVAILABILITY.BookID = BOOK.BookID
WHERE
    BOOK.BookName = 'The Art of Procrastination';

--Analytical Query 2: Completed in Scenario 2b

--Analytical Query 3: Find out when next billing cycle for membership is for a customer by when membership ends. 
SELECT
    CUSTOMER.CustomerID,
    CUSTOMER.CustomerName,
    MEMBERSHIP.EndDate AS 'Next Billing Date'
FROM
    CUSTOMER
INNER JOIN
    MEMBERSHIP ON CUSTOMER.MembershipID = MEMBERSHIP.MembershipID
WHERE
    CUSTOMER.CustomerName = 'Jane Smith';

--Analytical Query 4a: Find out how many customers are currently paying got membership in a specified Zip.
SELECT
    COUNT(*) AS 'Total Customers'
FROM
    CUSTOMER
--INNER JOIN
   -- MEMBERSHIP ON CUSTOMER.MembershipID = MEMBERSHIP.MembershipID
WHERE
	CUSTOMER.MembershipID IS NOT NULL AND
    CUSTOMER.ZipCode = '98101';

--Analytical Query 4b: Find out how many customers are currently paying got membership in a specified City.
SELECT
    COUNT(*) AS 'Total Customers'
FROM
    CUSTOMER
INNER JOIN
    MEMBERSHIP ON CUSTOMER.MembershipID = MEMBERSHIP.MembershipID
INNER JOIN
    CITY ON CUSTOMER.CityID = CITY.CityID
WHERE
    CITY.CityName = 'Puyallup';

--Analytical Query 4c: Find out how many customers are currently paying got membership in a specified State.
SELECT
    COUNT(*) AS 'Total Customers'
FROM
    CUSTOMER
INNER JOIN
    MEMBERSHIP ON CUSTOMER.MembershipID = MEMBERSHIP.MembershipID
INNER JOIN
    STATE ON CUSTOMER.StateID = STATE.StateID
WHERE
    State.StateName = 'Washington';

--Analytical Query 5a: Find the Phone Number of a customer. 
SELECT
    Phone
FROM
    CUSTOMER
WHERE
    CustomerName = 'Jane Smith';

--Analytical Query 5b: Find the Email of a customer. 
SELECT
    Email
FROM
    CUSTOMER
WHERE
    CustomerName = 'Jane Smith';

GO