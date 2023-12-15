

/*
Autor: Johan Cifuentes
Fecha: 2023-14-12
Descripcion: Normalizacion base de datos desde archivo CSV a tablas SQL 
*/



-- 1.Crear tabla temporal para traer los datos del csv 
DROP TABLE IF EXISTS   Customers;
CREATE TABLE   Customers (
	Ind                   VARCHAR(200)
	,CustomerId       	  VARCHAR(200)
	,FirstName			  VARCHAR(200)
	,LastName			  VARCHAR(200)
	,Company			  VARCHAR(200)
	,City				  VARCHAR(200)
	,Country			  VARCHAR(200)
	,Phone1				  VARCHAR(200)
	,Phone2				  VARCHAR(200)
	,Email				  VARCHAR(200)
	,SubscriptionDate	  VARCHAR(200)
	,Website			  VARCHAR(200)
);

-- 1.1 Crear tablas necesarias para la normalizacion de datos 

DROP TABLE IF EXISTS  Country;
CREATE TABLE  Country (
	id INT IDENTITY (1,1) PRIMARY KEY
	,name VARCHAR(100)
);

DROP TABLE IF EXISTS City;
CREATE TABLE  City (
	id INT IDENTITY (1,1) PRIMARY KEY 
	,id_country INT FOREIGN KEY REFERENCES  Country
	,name VARCHAR (100)
);

DROP TABLE IF EXISTS  Company;
CREATE TABLE  Company (
	id	INT IDENTITY (1,1) PRIMARY KEY
	, name VARCHAR(100)
);

DROP TABLE IF EXISTS Customer;
CREATE TABLE  Customer (
	id VARCHAR(100) PRIMARY KEY
	,first_name			VARCHAR(100)
	,last_name			VARCHAR(100)
	,company_id			INT FOREIGN KEY REFERENCES  Company
	,city_id			INT FOREIGN KEY REFERENCES  City
	,phone_I			VARCHAR(100)
	,phone_II			VARCHAR(100)
	,email				VARCHAR(150)
	,subscription_date	DATE
	,website			VARCHAR(100)
);


-- 2.Traer los datos usando un BULK INSERT

BULK INSERT
	  Customers 
FROM
	'C:\Users\Johan Cifuentes\Desktop\customers-10000.csv'
WITH (
	FIELDTERMINATOR = ','
	,ROWTERMINATOR = '\n'
	,FIRSTROW = 2
)


-- 3. Basic Data Cleaning 
DELETE
FROM   Customers
WHERE LEFT(Company, 1) = '"';


WITH CTE AS (
    SELECT 
        CustomerId,
        DENSE_RANK() OVER (PARTITION BY CustomerId ORDER BY CustomerId) AS duplicated
    FROM Customers
)
DELETE FROM CTE WHERE duplicated > 1;


-- 4. Insertion into tables 

INSERT INTO  Country
	SELECT Country
	FROM   Customers
	GROUP BY Country

INSERT INTO  City 
	SELECT Country.id, City 
	FROM   Customers
	INNER JOIN Country ON (Country.name = Customers.Country)
	GROUP BY City,Country.id

INSERT INTO  Company
	SELECT Company
	FROM   Customers
	GROUP BY Company


WITH CTE AS (
	SELECT  
		 CustomerId
		,FirstName
		,LastName
		,co.id AS company_id
		,ci.id AS city_id
		,Phone1
		,Phone2
		,Email
		,CAST(SubscriptionDate AS DATE) AS subscription_date
		,Website
		,ROW_NUMBER() OVER (PARTITION BY CustomerId ORDER BY CustomerId) AS duplicated
	FROM Customers cu
	INNER JOIN Company co ON (co.name = cu.Company)
	INNER JOIN City ci ON (ci.name = cu.City)
	
)
INSERT INTO Customer
SELECT 
	CustomerId
	,FirstName
	,LastName
	,company_id
	,city_id
	,Phone1
	,Phone2
	,Email
	,subscription_date
	,Website
FROM CTE WHERE duplicated  < 2;

