--use master
--drop database gbc_superstore
--create database gbc_superstore
use  gbc_superstore
CREATE TABLE Type_Customer (
  ID_TypeCustomer Int identity(1,1) PRIMARY KEY,
  TypeCustomer_Name nvarchar(20) NOT NULL,
);

CREATE TABLE Customer (
  ID_Customer nvarchar(50) NOT NULL  ,
  ID_TypeCustomer int NOT NULL ,
  Customer_Name nvarchar(100) NOT NULL,
  primary key(ID_Customer),
  foreign key(ID_TypeCustomer) REFERENCES type_customer(ID_TypeCustomer)
);

CREATE TABLE Country (
  ID_Country int NOT NULL identity(1,1),
  Country_Name nvarchar(20),
   primary key(ID_Country)
);
CREATE TABLE Region (
  ID_Region int NOT NULL identity(1,1),
  Region_Name nvarchar(20),
  ID_Country int not null,
   primary key(ID_Region),
   foreign key(ID_Country) REFERENCES Country(ID_Country)
);
CREATE TABLE State (
  ID_State int NOT NULL identity(1,1),
  State_Name nvarchar(20),
  ID_Region int not null,
  primary key(ID_State),
   foreign key(ID_Region) REFERENCES Region(ID_Region)
);
CREATE TABLE City (
  ID_City int NOT NULL identity(1,1),
  City_Name nvarchar(20) NOT NULL,
  ID_State int not null,
  primary key(ID_City),
   foreign key(ID_State) REFERENCES State(ID_State)
);	
CREATE TABLE Shipping (
  ID_Shipping int NOT NULL identity(1,1),
  Ship_Mode nvarchar(20) NOT NULL,
  primary key(ID_Shipping)
);
CREATE TABLE Orders (
  ID_Order nvarchar(50) NOT NULL ,
  ID_City int NOT NULL,
  ID_Shipping int NOT NULL,
  Order_Date Date Not NULL,
  Ship_Date Date NOT NULL,
  Ship_Name nvarchar(50) NOT NULL,
  Ship_Postalcode int  NULL,
  primary key(ID_Order),
  FOREIGN KEY (ID_Shipping) REFERENCES Shipping(ID_Shipping),
  FOREIGN KEY (ID_City) REFERENCES City(ID_City)
);
CREATE TABLE Category   (
  ID_Category int NOT NULL identity(1,1),
  Name_Category nvarchar(50) NOT NULL,
  primary key(ID_Category)
  
);

CREATE TABLE Subcategory   (
  ID_Subcategory Int NOT NULL identity(1,1),
  Name_Subcategory nvarchar(100) NOT NULL,
  ID_Category int NULL,
  primary key(ID_Subcategory),
  FOREIGN KEY (ID_Category) REFERENCES Category(ID_Category) 
);


CREATE TABLE Product (
  ID_Product nvarchar(50) NOT NULL,
  Name_Product nvarchar(500) NOT NULL,
  ID_Category int NOT NULL,
  ID_Subcategory int NOT NULL,
  Unit_Price float NOT NULL,
  primary key(ID_Product),
  FOREIGN KEY (ID_Category) REFERENCES category(ID_Category) ,
  FOREIGN KEY (ID_Subcategory) REFERENCES subcategory(ID_Subcategory) 
);

CREATE TABLE Order_Details (
  ID_OrderDetails int not NULL identity(1,1),
  ID_Order nvarchar(50) NOT NULL,
  ID_Product nvarchar(50) NOT NULL,
  Quantity int,
  Discount float,
  Unit_Price float,
  profit float
  primary key(ID_OrderDetails),
  FOREIGN KEY (ID_Order) REFERENCES Orders(ID_Order) ,
  FOREIGN KEY (ID_Product) REFERENCES Product(ID_Product) 
);

CREATE TABLE Returns(
  ID_Return int NOT NULL identity(1,1),
  ID_Order nvarchar(50) NOT NULL,
  primary key(ID_Return),
  FOREIGN KEY (ID_Order) REFERENCES Orders(ID_Order)
);

CREATE TABLE order_testing (
    [Order ID] nvarchar(255),
    [Order Date] datetime,
    [Ship Date] datetime,
    [Ship Mode] nvarchar(255),
    [Customer ID] nvarchar(255),
    [Customer Name] nvarchar(255),
    [City] nvarchar(255),
    [Segment] nvarchar(255),
    [Country/Region] nvarchar(255),
    [State] nvarchar(255),
    [Postal Code] float,
    [Region] nvarchar(255)
)
create view Location as 
select c.ID_City, c.City_Name, c.ID_State, d.State_Name , d.ID_Region, e.Region_Name ,
e.ID_Country, f.Country_Name from City c 
inner join State d on c.ID_State= d.ID_State
inner join Region e on d.ID_Region= e.ID_Region
inner join Country f on e.ID_Country= f.ID_Country


