-------------------------------Made by: Nikita Sonkin-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE DATABASE Sales;

CREATE SCHEMA Sales;
CREATE SCHEMA Person;
CREATE SCHEMA Purchasing;
CREATE SCHEMA Production
CREATE SCHEMA HumanResources

create table Sales.SalesOrderDetail(
[SalesOrderID] int not null,
[SalesOrderDetailID] int IDENTITY(1,1) not null,
[CarrierTrackingNumber] nvarchar(25) null,
[OrderQty] smallint not null,
[ProductID] int not null,
[SpecialOfferID] int not null,
[UnitPrice] money not null,
[UnitPriceDiscount] money not null  DEFAULT ((0.0)),
[LineTotal] AS ISNULL(([UnitPrice] * ((1.0) - [UnitPriceDiscount])) * [OrderQty], (0.0)) ,
[rowguid] uniqueidentifier NOT NULL DEFAULT (newid()),
[ModifiedDate]datetime NOT NULL DEFAULT (getdate()),
PRIMARY KEY (SalesOrderID, SalesOrderDetailID))




ALTER TABLE Sales.SalesOrderDetail
ADD CONSTRAINT FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID
FOREIGN KEY (SalesOrderID)
REFERENCES Sales.SalesOrderHeader(SalesOrderID);

ALTER TABLE Sales.SalesOrderDetail
ADD CONSTRAINT FK_SalesOrderDetail_SpecialOfferProduct_SpecialOfferIDProductID
FOREIGN KEY (SpecialOfferID, ProductID)
REFERENCES Sales.SpecialOfferProduct(SpecialOfferID, ProductID);



create table Sales.SalesOrderHeader (
[SalesOrderID] int  IDENTITY(1,1) NOT FOR REPLICATION NOT NULL ,
[RevisionNumber]  tinyint NOT NULL,
[OrderDate] datetime NOT NULL DEFAULT (getdate()),
[DueDate] datetime NOT NULL,
[ShipDate] datetime NULL,
[Status]  tinyint NOT NULL  DEFAULT ((1)),
[OnlineOrderFlag] bit NOT NULL DEFAULT ((1)),
[SalesOrderNumber] as (isnull(N'SO'+CONVERT([nvarchar](23),[SalesOrderID]),N'*** ERROR ***')) ,
[PurchaseOrderNumber] nvarchar(25) NULL,
[AccountNumber]  nvarchar(15) NULL,
[CustomerID] int NOT NULL,
[SalesPersonID] int NULL,
[TerritoryID] int NULL,
[BillToAddressID] int NOT NULL,
[ShipToAddressID] int NOT NULL,
[ShipMethodID] int NOT NULL,
[CreditCardID] int NULL,
[CreditCardApprovalCode] varchar(15) NULL,
[CurrencyRateID] int NULL,
[SubTotal]  money NOT NULL DEFAULT ((0.00)),
[TaxAmt] money NOT NULL DEFAULT ((0.00)),
[Freight] money NOT NULL,
[TotalDue] as (isnull(([SubTotal]+[TaxAmt])+[Freight],(0))),
[Comment] nvarchar(128) NULL,
[rowguid] uniqueidentifier ROWGUIDCOL NOT NULL DEFAULT (newid()),
[ModifiedDate] datetime NOT NULL,
CONSTRAINT [PK_SalesOrderHeader_SalesOrderID] PRIMARY KEY CLUSTERED 
([SalesOrderID] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF,
IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON,
OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]) 


ALTER TABLE Sales.SalesOrderHeader
ADD CONSTRAINT FK_SalesOrderHeader_Customer_CustomerID
FOREIGN KEY (CustomerID)
REFERENCES Sales.Customer(CustomerID);

ALTER TABLE Sales.SalesOrderHeader
ADD CONSTRAINT FK_SalesOrderHeader_Address_BillToAddressID
FOREIGN KEY (BillToAddressID)
REFERENCES Person.Address(AddressID);

ALTER TABLE Sales.SalesOrderHeader
ADD CONSTRAINT FK_SalesOrderHeader_Address_ShipToAddressID
FOREIGN KEY (ShipToAddressID)
REFERENCES Person.Address(AddressID);

ALTER TABLE Sales.SalesOrderHeader
ADD CONSTRAINT FK_SalesOrderHeader_CreditCard_CreditCardID
FOREIGN KEY (CreditCardID)
REFERENCES Sales.CreditCard(CreditCardID);

ALTER TABLE Sales.SalesOrderHeader
ADD CONSTRAINT FK_SalesOrderHeader_CurrencyRate_CurrencyRateID
FOREIGN KEY (CurrencyRateID)
REFERENCES Sales.CurrencyRate(CurrencyRateID);

ALTER TABLE Sales.SalesOrderHeader
ADD CONSTRAINT FK_SalesOrderHeader_SalesPerson_SalesPersonID
FOREIGN KEY (SalesPersonID)
REFERENCES Sales.SalesPerson(BusinessEntityID);


ALTER TABLE Sales.SalesOrderHeader
ADD CONSTRAINT FK_SalesOrderHeader_SalesTerritory_TerritoryID
FOREIGN KEY (TerritoryID)
REFERENCES Sales.SalesTerritory(TerritoryID);

ALTER TABLE Sales.SalesOrderHeader
ADD CONSTRAINT FK_SalesOrderHeader_ShipMethod_ShipMethodID
FOREIGN KEY (ShipMethodID)
REFERENCES Purchasing.ShipMethod(ShipMethodID);



create table Person.Address(
[AddressID] int IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
[AddressLine1] nvarchar(60) not null,
[AddressLine2] nvarchar(60) null,
[City] nvarchar(30) not null,
[StateProvinceID] int not null,
[PostalCode] nvarchar(15) not null,
[SpatialLocation] geography null,
[rowguid] uniqueidentifier ROWGUIDCOL  NOT NULL,
[ModifiedDate] datetime not null
CONSTRAINT [PK_Address_AddressID] PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF,
IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY])


create table [Purchasing].ShipMethod(
[ShipMethodID] int  IDENTITY(1,1) NOT NULL,
[Name] nvarchar(50) not null,
[ShipBase] money not null  DEFAULT ((0.00)) CHECK  (([ShipBase]>(0.00))),
[ShipRate] money not null  DEFAULT ((0.00)) CHECK  (([ShipRate]>(0.00))),
[rowguid] uniqueidentifier ROWGUIDCOL  NOT NULL DEFAULT (newid()),
[ModifiedDate] datetime not null DEFAULT (getdate()),
CONSTRAINT [PK_ShipMethod_ShipMethodID] PRIMARY KEY CLUSTERED 
([ShipMethodID] ASC
)WITH (PAD_INDEX = OFF,
STATISTICS_NORECOMPUTE = OFF,
IGNORE_DUP_KEY = OFF,
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON,
OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY])


create table Sales.CurrencyRate(
[CurrencyRateID] int not null IDENTITY(1,1),
[CurrencyRateDate] datetime not null,
[FromCurrencyCode] nchar(3) not null,
[ToCurrencyCode] nchar(3) not null,
[AverageRate] money not null,
[EndOfDayRate] money not null,
[ModifiedDate] datetime not null DEFAULT (getdate()), 
CONSTRAINT [PK_CurrencyRate_CurrencyRateID] PRIMARY KEY CLUSTERED 
([CurrencyRateID] ASC
)WITH (PAD_INDEX = OFF,
STATISTICS_NORECOMPUTE = OFF,
IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY])



create  table Sales.SpecialOfferProduct(
[SpecialOfferID] int not null,
[ProductID] int not null,
[rowguid] uniqueidentifier ROWGUIDCOL NOT NULL DEFAULT (newid()),
[ModifiedDate] datetime not null DEFAULT (getdate()),

 CONSTRAINT [PK_SpecialOfferProduct_SpecialOfferID_ProductID] PRIMARY KEY CLUSTERED 
([SpecialOfferID] ASC, [ProductID] ASC) 
WITH (PAD_INDEX = OFF,
STATISTICS_NORECOMPUTE = OFF,
IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
)


ALTER TABLE [Sales].[SpecialOfferProduct]  
WITH CHECK ADD  CONSTRAINT [FK_SpecialOfferProduct_Product_ProductID] 
FOREIGN KEY([ProductID])
REFERENCES [Production].[Product] ([ProductID])




create table Sales.CreditCard(
[CreditCardID] int not null IDENTITY(1,1),
[CardType] nvarchar(50) not null,
[CardNumber] nvarchar(25) not null,
[ExpMonth] tinyint not null,
[ExpYear] smallint not null,
[ModifiedDate] datetime not null DEFAULT (getdate())
,
 CONSTRAINT [PK_CreditCard_CreditCardID] PRIMARY KEY CLUSTERED 
([CreditCardID] ASC)
WITH (PAD_INDEX = OFF,
STATISTICS_NORECOMPUTE = OFF,
IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
)



create table Sales.SalesPerson(
[BusinessEntityID] int not null,
[TerritoryID] int null,
[SalesQuota] money null,
[Bonus] money not null DEFAULT ((0.00))  CHECK  (([Bonus]>=(0.00))),
[CommissionPct] smallmoney not null  DEFAULT ((0.00)),
[SalesYTD] money not null DEFAULT ((0.00)),
[SalesLastYear] money not null DEFAULT ((0.00)),
[rowguid] uniqueidentifier  ROWGUIDCOL NOT NULL  DEFAULT (newid()),
[ModifiedDate] datetime not null DEFAULT (getdate())
,
 CONSTRAINT [PK_SalesPerson_BusinessEntityID] PRIMARY KEY CLUSTERED 
([BusinessEntityID] ASC)
WITH (PAD_INDEX = OFF,
STATISTICS_NORECOMPUTE = OFF,
IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
)

ALTER TABLE Sales.SalesPerson
ADD CONSTRAINT FK_SalesPerson_SalesTerritory_TerritoryID
FOREIGN KEY (TerritoryID)
REFERENCES Sales.SalesTerritory(TerritoryID);


ALTER TABLE [Sales].[SalesPerson]  
WITH CHECK ADD  CONSTRAINT [FK_SalesPerson_Employee_BusinessEntityID] 
FOREIGN KEY([BusinessEntityID])
REFERENCES [HumanResources].[Employee] ([BusinessEntityID])




create table Sales.SalesTerritory(
[TerritoryID] int not null IDENTITY(1,1),
[Name] nvarchar(50) not null,
[CountryRegionCode] nvarchar(3) not null,
[Group] nvarchar(50) not null,
[SalesYTD] money not null DEFAULT ((0.00)),
[SalesLastYear] money not null DEFAULT ((0.00)),
[CostYTD] money not null DEFAULT ((0.00)),
[CostLastYear] money not null,
[rowguid] uniqueidentifier  ROWGUIDCOL NOT NULL DEFAULT (newid()),
[ModifiedDate] datetime not null DEFAULT (getdate())
,
 CONSTRAINT [PK_SalesTerritory_TerritoryID] PRIMARY KEY CLUSTERED 
([TerritoryID] ASC)
WITH (PAD_INDEX = OFF,
STATISTICS_NORECOMPUTE = OFF,
IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY])



create table Sales.Customer(
[CustomerID] int IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
[PersonID] int null,
[StoreID] int null,
[TerritoryID] int null,
[AccountNumber]  as (isnull('AW'+[dbo].[ufnLeadingZeros]([CustomerID]),'')) ,
[rowguid] uniqueidentifier ROWGUIDCOL NOT NULL DEFAULT (newid()),
[ModifiedDate] datetime not null DEFAULT (getdate())
,
 CONSTRAINT [PK_Customer_CustomerID] PRIMARY KEY CLUSTERED 
([CustomerID] ASC)
WITH (PAD_INDEX = OFF,
STATISTICS_NORECOMPUTE = OFF,
IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY])




ALTER TABLE Sales.Customer
ADD CONSTRAINT FK_Customer_SalesTerritory_TerritoryID
FOREIGN KEY (TerritoryID)
REFERENCES Sales.SalesTerritory(TerritoryID);


ALTER TABLE [Sales].[Customer]  
WITH CHECK ADD  CONSTRAINT [FK_Customer_Person_PersonID] 
FOREIGN KEY([PersonID])
REFERENCES [Person].[Person] ([BusinessEntityID])


--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 --יצירת הנוסחא עבור עמודה ACCOUNTNUMBER
USE [Sales]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ufnLeadingZeros](
    @Value int) 
RETURNS varchar(8) 
WITH SCHEMABINDING 
AS 
BEGIN
    DECLARE @ReturnValue varchar(8);
    SET @ReturnValue = CONVERT(varchar(8), @Value);
    SET @ReturnValue = REPLICATE('0', 8 - DATALENGTH(@ReturnValue)) + @ReturnValue;
    RETURN (@ReturnValue);
END;
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Input parameter for the scalar function ufnLeadingZeros. Enter a valid integer.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'ufnLeadingZeros', @level2type=N'PARAMETER',@level2name=N'@Value'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Scalar function used by the Sales.Customer table to help set the account number.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'ufnLeadingZeros'
GO





CREATE TABLE [Production].[Product](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[Name] nvarchar(50) NOT NULL,
	[ProductNumber] [nvarchar](25) NOT NULL,
	[MakeFlag] bit NOT NULL DEFAULT ((1)),
	[FinishedGoodsFlag] bit NOT NULL DEFAULT ((1)),
	[Color] [nvarchar](15) NULL,
	[SafetyStockLevel] [smallint] NOT NULL,
	[ReorderPoint] [smallint] NOT NULL,
	[StandardCost] [money] NOT NULL,
	[ListPrice] [money] NOT NULL,
	[Size] [nvarchar](5) NULL,
	[SizeUnitMeasureCode] [nchar](3) NULL,
	[WeightUnitMeasureCode] [nchar](3) NULL,
	[Weight] [decimal](8, 2) NULL,
	[DaysToManufacture] [int] NOT NULL,
	[ProductLine] [nchar](2) NULL,
	[Class] [nchar](2) NULL,
	[Style] [nchar](2) NULL,
	[ProductSubcategoryID] [int] NULL,
	[ProductModelID] [int] NULL,
	[SellStartDate] [datetime] NOT NULL,
	[SellEndDate] [datetime] NULL,
	[DiscontinuedDate] [datetime] NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL DEFAULT (newid()),
	[ModifiedDate] [datetime] NOT NULL  DEFAULT (getdate()),
 CONSTRAINT [PK_Product_ProductID] PRIMARY KEY CLUSTERED 
([ProductID] ASC)
WITH (PAD_INDEX = OFF,
STATISTICS_NORECOMPUTE = OFF,
IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
)



ALTER TABLE [Production].[Product]  
WITH CHECK ADD  CONSTRAINT [FK_Product_ProductSubcategory_ProductSubcategoryID] 
FOREIGN KEY([ProductSubcategoryID])
REFERENCES [Production].[ProductSubcategory] ([ProductSubcategoryID])



CREATE TABLE [Production].[ProductCategory](
	[ProductCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[Name] nvarchar(50) NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL DEFAULT (newid()),
	[ModifiedDate] [datetime] NOT NULL DEFAULT (getdate()),
 CONSTRAINT [PK_ProductCategory_ProductCategoryID] PRIMARY KEY CLUSTERED 
([ProductCategoryID] ASC)
WITH (PAD_INDEX = OFF, 
STATISTICS_NORECOMPUTE = OFF, 
IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, 
ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
)


CREATE TABLE [Production].[ProductSubcategory](
	[ProductSubcategoryID] [int] IDENTITY(1,1) NOT NULL,
	[ProductCategoryID] [int] NOT NULL,
	[Name] nvarchar(50) NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL DEFAULT (newid()) ,
	[ModifiedDate] [datetime] NOT NULL DEFAULT (getdate()),
 CONSTRAINT [PK_ProductSubcategory_ProductSubcategoryID] PRIMARY KEY CLUSTERED 
([ProductSubcategoryID] ASC
)
WITH (PAD_INDEX = OFF,
STATISTICS_NORECOMPUTE = OFF,
IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
)

ALTER TABLE [Production].[ProductSubcategory]  
WITH CHECK ADD  CONSTRAINT [FK_ProductSubcategory_ProductCategory_ProductCategoryID] 
FOREIGN KEY([ProductCategoryID])
REFERENCES [Production].[ProductCategory] ([ProductCategoryID])


CREATE TABLE [Person].[Person](
	[BusinessEntityID] [int] NOT NULL,
	[PersonType] [nchar](2) NOT NULL,
	[NameStyle] bit NOT NULL DEFAULT ((0)),
	[Title] [nvarchar](8) NULL,
	[FirstName] nvarchar(50) NOT NULL,
	[MiddleName] nvarchar(50) NULL,
	[LastName] nvarchar(50) NOT NULL,
	[Suffix] [nvarchar](10) NULL,
	[EmailPromotion] [int] NOT NULL DEFAULT ((0)),
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL DEFAULT (newid()),
	[ModifiedDate] [datetime] NOT NULL DEFAULT (getdate()),
 CONSTRAINT [PK_Person_BusinessEntityID] PRIMARY KEY CLUSTERED 
([BusinessEntityID] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF,
IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON,
OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY])


CREATE TABLE [HumanResources].[Department](
	[DepartmentID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] nvarchar(50) NOT NULL,
	[GroupName] nvarchar(50) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL DEFAULT (getdate()),
 CONSTRAINT [PK_Department_DepartmentID] PRIMARY KEY CLUSTERED 
([DepartmentID] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF,
IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON,
OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
)



CREATE TABLE [HumanResources].[EmployeeDepartmentHistory](
	[BusinessEntityID] [int] NOT NULL,
	[DepartmentID] [smallint] NOT NULL,
	[ShiftID] [tinyint] NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NULL,
	[ModifiedDate] [datetime] NOT NULL DEFAULT (getdate()),
 CONSTRAINT [PK_EmployeeDepartmentHistory_BusinessEntityID_StartDate_DepartmentID] PRIMARY KEY CLUSTERED 
(	[BusinessEntityID] ASC,	[StartDate] ASC,[DepartmentID] ASC,	[ShiftID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF,
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY])

ALTER TABLE [HumanResources].[EmployeeDepartmentHistory]  
WITH CHECK ADD  CONSTRAINT [FK_EmployeeDepartmentHistory_Department_DepartmentID] 
FOREIGN KEY([DepartmentID])
REFERENCES [HumanResources].[Department] ([DepartmentID])

ALTER TABLE [HumanResources].[EmployeeDepartmentHistory]  
WITH CHECK ADD  CONSTRAINT [FK_EmployeeDepartmentHistory_Employee_BusinessEntityID] 
FOREIGN KEY([BusinessEntityID])
REFERENCES [HumanResources].[Employee] ([BusinessEntityID])

ALTER TABLE [HumanResources].[EmployeeDepartmentHistory]  
WITH CHECK ADD  CONSTRAINT [FK_EmployeeDepartmentHistory_Shift_ShiftID] 
FOREIGN KEY([ShiftID])
REFERENCES [HumanResources].[Shift] ([ShiftID])


CREATE TABLE [HumanResources].[Shift](
	[ShiftID] [tinyint] IDENTITY(1,1) NOT NULL,
	[Name] nvarchar(50) NOT NULL,
	[StartTime] [time](7) NOT NULL,
	[EndTime] [time](7) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL DEFAULT (getdate()),
 CONSTRAINT [PK_Shift_ShiftID] PRIMARY KEY CLUSTERED 
([ShiftID] ASC)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, 
IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY])



CREATE TABLE [HumanResources].[Employee](
	[BusinessEntityID] [int] NOT NULL,
	[NationalIDNumber] [nvarchar](15) NOT NULL,
	[LoginID] [nvarchar](256) NOT NULL,
	[OrganizationNode] [hierarchyid] NULL,
	[OrganizationLevel]  AS ([OrganizationNode].[GetLevel]()),
	[JobTitle] [nvarchar](50) NOT NULL,
	[BirthDate] [date] NOT NULL,
	[MaritalStatus] [nchar](1) NOT NULL,
	[Gender] [nchar](1) NOT NULL,
	[HireDate] [date] NOT NULL,
	[SalariedFlag] bit NOT NULL  DEFAULT ((1)),
	[VacationHours] [smallint] NOT NULL  DEFAULT ((0)),
	[SickLeaveHours] [smallint] NOT NULL  DEFAULT ((0)),
	[CurrentFlag] bit NOT NULL DEFAULT ((1)),
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL DEFAULT (newid()),
	[ModifiedDate] [datetime] NOT NULL  DEFAULT (getdate()),
 CONSTRAINT [PK_Employee_BusinessEntityID] PRIMARY KEY CLUSTERED 
([BusinessEntityID] ASC)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF,
IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON,
OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
)

ALTER TABLE [HumanResources].[Employee]  
WITH CHECK ADD  CONSTRAINT [FK_Employee_Person_BusinessEntityID] 
FOREIGN KEY([BusinessEntityID])
REFERENCES [Person].[Person] ([BusinessEntityID])




---הכנסת נתונים מבסיס נתונים-AdventureWorks2022  לכל הטבלאות  

INSERT INTO [Person].[Address]
select
            [AddressLine1]
           ,[AddressLine2]
           ,[City]
           ,[StateProvinceID]
           ,[PostalCode]
           ,[SpatialLocation]
           ,[rowguid]
           ,[ModifiedDate]
from [AdventureWorks2022].[Person].[Address];



INSERT INTO [Purchasing].[ShipMethod]
select      [Name]
           ,[ShipBase]
           ,[ShipRate]
           ,[rowguid]
           ,[ModifiedDate]
from [AdventureWorks2022].[Purchasing].[ShipMethod]


INSERT INTO [Sales].[CreditCard]
    select  [CardType]
           ,[CardNumber]
           ,[ExpMonth]
           ,[ExpYear]
           ,[ModifiedDate]
from [AdventureWorks2022].[Sales].[CreditCard]


INSERT INTO [Sales].[CurrencyRate]
select
           [CurrencyRateDate]
           ,[FromCurrencyCode]
           ,[ToCurrencyCode]
           ,[AverageRate]
           ,[EndOfDayRate]
           ,[ModifiedDate]
		   from [AdventureWorks2022].[Sales].[CurrencyRate]


 הפעלת IDENTITY_INSERT
SET IDENTITY_INSERT [Sales].[SalesTerritory] ON;



INSERT INTO [Sales].[SalesTerritory]
           (TerritoryID
		   ,[Name]
           ,[CountryRegionCode]
           ,[Group]
           ,[SalesYTD]
           ,[SalesLastYear]
           ,[CostYTD]
           ,[CostLastYear]
           ,[rowguid]
           ,[ModifiedDate])
SELECT TerritoryID
		   ,[Name]
           ,[CountryRegionCode]
           ,[Group]
           ,[SalesYTD]
           ,[SalesLastYear]
           ,[CostYTD]
           ,[CostLastYear]
           ,[rowguid]
           ,[ModifiedDate]
FROM [AdventureWorks2022].[Sales].[SalesTerritory];



SET IDENTITY_INSERT [Sales].[SalesTerritory] OFF;

SET IDENTITY_INSERT [Sales].[Customer] ON;

INSERT INTO [Sales].[Customer] (CustomerID, PersonID, StoreID, TerritoryID, rowguid, ModifiedDate)
SELECT  CustomerID, PersonID, StoreID, TerritoryID, rowguid, ModifiedDate
FROM [AdventureWorks2022].[Sales].[Customer];

SET IDENTITY_INSERT [Sales].[Customer] OFF;



INSERT INTO [Sales].[SalesPerson]
     select [BusinessEntityID]
           ,[TerritoryID]
           ,[SalesQuota]
           ,[Bonus]
           ,[CommissionPct]
           ,[SalesYTD]
           ,[SalesLastYear]
           ,[rowguid]
           ,[ModifiedDate]
		   from [AdventureWorks2022].[Sales].[SalesPerson]
 



SET IDENTITY_INSERT [Sales].[SalesOrderHeader] ON;

INSERT INTO [Sales].[SalesOrderHeader] (
    SalesOrderID, RevisionNumber, OrderDate, DueDate, ShipDate, [Status], OnlineOrderFlag,
    PurchaseOrderNumber, AccountNumber, CustomerID, SalesPersonID, TerritoryID, BillToAddressID,
    ShipToAddressID, ShipMethodID, CreditCardID, CreditCardApprovalCode, CurrencyRateID,
    SubTotal, TaxAmt, Freight, Comment, rowguid, ModifiedDate
)
SELECT 
    SalesOrderID, RevisionNumber, OrderDate, DueDate, ShipDate, [Status], OnlineOrderFlag,
    PurchaseOrderNumber, AccountNumber, CustomerID, SalesPersonID, TerritoryID, BillToAddressID,
    ShipToAddressID, ShipMethodID, CreditCardID, CreditCardApprovalCode, CurrencyRateID,
    SubTotal, TaxAmt, Freight, Comment, rowguid, ModifiedDate
FROM [AdventureWorks2022].[Sales].[SalesOrderHeader];


SET IDENTITY_INSERT [Sales].[SalesOrderHeader] OFF;



INSERT INTO [Sales].[SpecialOfferProduct]
           select [SpecialOfferID]
           ,[ProductID]
           ,[rowguid]
           ,[ModifiedDate]
		   from [AdventureWorks2022].[Sales].[SpecialOfferProduct]


INSERT INTO [Sales].[SalesOrderDetail]
          select [SalesOrderID]
           ,[CarrierTrackingNumber]
           ,[OrderQty]
           ,[ProductID]
           ,[SpecialOfferID]
           ,[UnitPrice]
           ,[UnitPriceDiscount]
           ,[rowguid]
           ,[ModifiedDate]
		    from [AdventureWorks2022].[Sales].[SalesOrderDetail]




INSERT INTO [HumanResources].[Employee]
           select [BusinessEntityID]
           ,[NationalIDNumber]
           ,[LoginID]
           ,[OrganizationNode]
           ,[JobTitle]
           ,[BirthDate]
           ,[MaritalStatus]
           ,[Gender]
           ,[HireDate]
           ,[SalariedFlag]
           ,[VacationHours]
           ,[SickLeaveHours]
           ,[CurrentFlag]
           ,[rowguid]
           ,[ModifiedDate]
		   from [AdventureWorks2022].[HumanResources].[Employee]



INSERT INTO [HumanResources].[Shift]
          select [Name]
           ,[StartTime]
           ,[EndTime]
           ,[ModifiedDate]
		    from [AdventureWorks2022].[HumanResources].[Shift]



INSERT INTO [HumanResources].[EmployeeDepartmentHistory]
          select [BusinessEntityID]
           ,[DepartmentID]
           ,[ShiftID]
           ,[StartDate]
           ,[EndDate]
           ,[ModifiedDate]
		   from [AdventureWorks2022].[HumanResources].[EmployeeDepartmentHistory]



INSERT INTO [HumanResources].[Department]
           select [Name]
           ,[GroupName]
           ,[ModifiedDate]
		   from [AdventureWorks2022].[HumanResources].[Department]



INSERT INTO [Person].[Person]
          select   [BusinessEntityID]
           ,[PersonType]
           ,[NameStyle]
           ,[Title]
           ,[FirstName]
           ,[MiddleName]
           ,[LastName]
           ,[Suffix]
           ,[EmailPromotion]
           ,[rowguid]
           ,[ModifiedDate]
		    from [AdventureWorks2022].[Person].[Person]




INSERT INTO [Production].[ProductSubcategory]
         select  [ProductCategoryID]
           ,[Name]
           ,[rowguid]
           ,[ModifiedDate]
		   from [AdventureWorks2022].[Production].[ProductSubcategory]



INSERT INTO [Production].[ProductCategory]
           select  [Name]
           ,[rowguid]
           ,[ModifiedDate]
		    from [AdventureWorks2022].[Production].[ProductCategory]


INSERT INTO [Production].[Product]
           select [Name]
           ,[ProductNumber]
           ,[MakeFlag]
           ,[FinishedGoodsFlag]
           ,[Color]
           ,[SafetyStockLevel]
           ,[ReorderPoint]
           ,[StandardCost]
           ,[ListPrice]
           ,[Size]
           ,[SizeUnitMeasureCode]
           ,[WeightUnitMeasureCode]
           ,[Weight]
           ,[DaysToManufacture]
           ,[ProductLine]
           ,[Class]
           ,[Style]
           ,[ProductSubcategoryID]
           ,[ProductModelID]
           ,[SellStartDate]
           ,[SellEndDate]
           ,[DiscontinuedDate]
           ,[rowguid]
           ,[ModifiedDate]
		   from [AdventureWorks2022].[Production].[Product]


---שאילתות 10

--1
select top 5 pp.ProductID , SUM(unitprice)
from production.Product pp inner join sales.SalesOrderDetail sod on pp.ProductID = sod.ProductID
group by pp.ProductID

--2
select sod.ProductID,sod.unitprice from Sales.SalesOrderDetail sod inner join Production.Product pp on sod.ProductID = pp.ProductID
inner join Production.ProductSubcategory psc on pp.ProductSubcategoryID = psc.ProductSubcategoryID
inner join Production.ProductCategory pc on psc.ProductCategoryID = pc.ProductCategoryID
where pc.Name = 'Bikes'

--3
SELECT 
    p.Name AS ProductName,
    sod.OrderQty
FROM 
    Production.Product p
INNER JOIN 
    Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
INNER JOIN 
    Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
INNER JOIN 
    Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
WHERE 
    pc.Name NOT IN ('Components', 'Clothing');



--4 לבדוק למה לא עובד
SELECT TOP 3 st.Name AS TerritoryName,SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesTerritory st
INNER JOIN Sales.SalesOrderHeader soh ON st.TerritoryID = soh.TerritoryID
GROUP BY st.Name
ORDER BY SUM(soh.TotalDue) DESC;


--5
select sc.[CustomerID],sc.[PersonID],[FirstName] + ' '+ [LastName] as full_name
from [Sales].[Customer] sc LEFT join [Sales].[SalesOrderHeader] soh on sc.CustomerID = soh.CustomerID
LEFT join [Person].[Person] pp on sc.PersonID = pp.BusinessEntityID
where [SalesOrderID] is null
 

 --6
 delete st
 from  Sales.SalesTerritory st 
 left join [Sales].[SalesPerson] sp on st.[TerritoryID] = sp.[TerritoryID]
 where sp.[TerritoryID] is null


--7
SET IDENTITY_INSERT [Sales].[SalesTerritory] ON;

insert into Sales.SalesTerritory (TerritoryID, Name, CountryRegionCode, [Group], SalesYTD, SalesLastYear, CostYTD, CostLastYear, rowguid, ModifiedDate)
select ass.TerritoryID,
    ass.Name,
    ass.CountryRegionCode,
    ass.[Group],
    ass.SalesYTD,
    ass.SalesLastYear,
    ass.CostYTD,
    ass.CostLastYear,
    ass.rowguid,
    ass.ModifiedDate
from [AdventureWorks2022].Sales.SalesTerritory ass
left join Sales.SalesTerritory ss on ass.TerritoryID=ss.TerritoryID
where ss.TerritoryID is null

SET IDENTITY_INSERT [Sales].[SalesTerritory] OFF;


--8
select sc.[CustomerID] ,[FirstName] + ' '+ [LastName] as full_name,COUNT(soh.SalesOrderID) AS TotalOrders
from [Sales].[Customer] sc inner join [Person].[Person] pp on sc.PersonID=pp.BusinessEntityID
inner join [Sales].[SalesOrderHeader] soh on sc.CustomerID = soh.CustomerID
GROUP BY [FirstName],[LastName],sc.CustomerID
having count(soh.SalesOrderID) > 20 


--9
select [GroupName], count([GroupName]) DepartmentCount from [HumanResources].[Department]
group by [GroupName]
having count([GroupName]) > 2


--10
select  p.FirstName + ' ' + p.LastName AS EmployeeName,hd.Name AS DepartmentName, hs.Name AS ShiftName from [HumanResources].[Employee] he 
inner join [HumanResources].[EmployeeDepartmentHistory] edh on he.BusinessEntityID=edh.BusinessEntityID
inner join [HumanResources].[Shift] hs on edh.ShiftID = hs.ShiftID
inner join [HumanResources].[Department] hd on edh.DepartmentID = hd.DepartmentID
INNER JOIN [Person].[Person] p ON he.BusinessEntityID = p.BusinessEntityID 
where he.[HireDate] > '2010-12-31'
and hd.[GroupName] in('Manufactoring','quality assurance')



-------------------------------Made by: Nikita Sonkin-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
