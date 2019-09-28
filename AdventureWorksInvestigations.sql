use adventureWorksLT
--let's say we need an enumerated list of all customers to salespersons
SELECT 'All SalesPersons to customers'
select  SalesPerson,
    ROW_NUMBER() over (PARTITION BY SalesPerson ORDER BY SalesPerson),
    CustomerID,
    firstName,
    LastName
from SalesLT.Customer
order by SalesPerson,LastName

--let's say we need a map of area codes to zip codes.
--for this, we could say we need a table variable to simplify the final query selection
SELECT 'Area Code to Zip Code Map'
DECLARE @ZipCodeMappings as TABLE (
    CustomerID int,
    ZipCode varchar(10)
)
INSERT INTO @ZipCodeMappings
(
    CustomerID,
    ZipCode
)
SELECT distinct
    CustomerAddress.AddressID,
    Address.PostalCode
FROM SalesLT.Address
INNER JOIN SalesLT.CustomerAddress
on Address.AddressID = CustomerAddress.AddressID
where isnumeric(TRIM(Address.PostalCode)) = 1

select  left(Phone,3) as AreaCode,
        [@ZipCodeMappings].ZipCode
from SalesLT.Customer
inner join @ZipCodeMappings
on [@ZipCodeMappings].CustomerID = Customer.CustomerID
where ISNUMERIC(left(phone,3)) = 1
order by  ZipCode

--let's say we need all product categories that have a parent category
SELECT A.*
  FROM [SalesLT].[ProductCategory] A
left join [SalesLT].[ProductCategory] B
on A.ParentProductCategoryID = B.ProductCategoryID
where B.ProductCategoryID is not NULL
order by B.ProductCategoryID

--let's say we need to derive a list of all tables 
--and all years that things have been modified.

SELECT      c.name  AS 'ColumnName'
            ,t.name AS 'TableName'
FROM        sys.columns c
JOIN        sys.tables  t   ON c.object_id = t.object_id
WHERE       c.name LIKE '%ModifiedDate%'
ORDER BY    TableName
            ,ColumnName;
--yields the listing of relevant tables
-- Address
-- BuildVersion (not relevant)
-- Customer
-- CustomerAddress
-- Product
-- ProductCategory
-- ProductDescription
-- ProductModel
-- ProductModelProductDescription
-- SalesOrderDetail
-- SalesOrderHeader

--again, a table variable may do well here.
--I'm sure there's a way to do a clever join here, but
--I err on the side of more human-readable scripts

DECLARE @TableYearCounts TABLE(
    TableName varchar(50),
    Year int,
    Count int
)
INSERT INTO @TableYearCounts
(
    TableName, [Year], [Count]
)
SELECT 'Address',
        DATEPART([YEAR],Address.ModifiedDate),
        count(*)
FROM SalesLT.Address
GROUP BY DATEPART([YEAR],Address.ModifiedDate)
 UNION
 SELECT 'Customer',
         DATEPART([YEAR],Customer.ModifiedDate),
         count(*)
 FROM SalesLT.Customer
 GROUP BY DATEPART([YEAR],Customer.ModifiedDate)
 UNION
 SELECT 'CustomerAddress',
         DATEPART([YEAR],CustomerAddress.ModifiedDate),
         count(*)
 FROM SalesLT.CustomerAddress
 GROUP BY DATEPART([YEAR],CustomerAddress.ModifiedDate)
 UNION
 SELECT 'Product',
         DATEPART([YEAR],Product.ModifiedDate),
         count(*)
 FROM SalesLT.Product
 GROUP BY DATEPART([YEAR],Product.ModifiedDate)
 UNION
 SELECT 'ProductCategory',
         DATEPART([YEAR],ProductCategory.ModifiedDate),
         count(*)
 FROM SalesLT.ProductCategory
 GROUP BY DATEPART([YEAR],ProductCategory.ModifiedDate)
 UNION
 SELECT 'ProductDescription',
         DATEPART([YEAR],ProductDescription.ModifiedDate),
         count(*)
 FROM SalesLT.ProductDescription
 GROUP BY DATEPART([YEAR],ProductDescription.ModifiedDate)
 UNION
 SELECT 'ProductModel',
         DATEPART([YEAR],ProductModel.ModifiedDate),
         count(*)
 FROM SalesLT.ProductModel
 GROUP BY DATEPART([YEAR],ProductModel.ModifiedDate)
 UNION
 SELECT 'Product',
         DATEPART([YEAR],Product.ModifiedDate),
         count(*)
 FROM SalesLT.Product
 GROUP BY DATEPART([YEAR],Product.ModifiedDate)
 UNION
 SELECT 'SalesOrderDetail',
         DATEPART([YEAR],SalesOrderDetail.ModifiedDate),
         count(*)
 FROM SalesLT.SalesOrderDetail
 GROUP BY DATEPART([YEAR],SalesOrderDetail.ModifiedDate)
  UNION
 SELECT 'SalesOrderHeader',
         DATEPART([YEAR],SalesOrderHeader.ModifiedDate),
         count(*)
 FROM SalesLT.SalesOrderHeader
 GROUP BY DATEPART([YEAR],SalesOrderHeader.ModifiedDate)

SELECT 'All Tables and counts per year'
SELECT * FROM @TableYearCounts
order by TableName, [Year]

--this is a lot of data, but from here, we can derive a list of entries per
--year for the lifetime of the database
select 'All activity per year, for all tables'
;
with cte as (
SELECT  [@TableYearCounts].[Year],
        COUNT([@TableYearCounts].[Year]) as TableCount,
        SUM([@TableYearCounts].[Count]) as TotalEntriesPerYear
from @TableYearCounts
group by [@TableYearCounts].[Year]
)
SELECT cte.*,
        cte.TotalEntriesPerYear/cte.TableCount as EntriesPerTablePerYear
from cte
