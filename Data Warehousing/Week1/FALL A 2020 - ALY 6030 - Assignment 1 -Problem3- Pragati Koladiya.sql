/*
Pragati Koladiya
FALL A 2020
ALY 6030
Assignment 1 
	Problem-3
Last Updated 09/24/2020
*/ 

-- -----------------------------------------------------------------------------------------------------
/* Creating schema `insta_grocery` */
-- -----------------------------------------------------------------------------------------------------
CREATE SCHEMA `insta_grocery`;

-- -----------------------------------------------------------------------------------------------------
-- Creating table `customers`
-- -----------------------------------------------------------------------------------------------------
CREATE TABLE `customers` (
  `CUSTID`  int NOT NULL,
  `CUST_NAME` varchar(40) DEFAULT NULL,
  `PHONE` varchar(15) DEFAULT NULL,
  `EMAIL` varchar(35) DEFAULT NULL,
  `DATECREATED` date DEFAULT NULL,
  `DATE_LAST_TRANSACT` date DEFAULT NULL,
  PRIMARY KEY (`CUSTID`)
) ;
--
-- Inserting data into `customers`
--
INSERT INTO `customers` (`CUSTID`, `CUST_NAME`, `PHONE`, `EMAIL`, `DATECREATED`,`DATE_LAST_TRANSACT`) VALUES
('110  ', 'Bob        ', '1124535211 	', 'bob@gmail.com', 			'2010-1-1   	','2020-1-23	'),
('111  ', 'Palak      ', '9123521143  	', 'palakdesai@gamil.com',		'2011-5-5   	','2019-2-9		'),
('152  ', 'Riya       ', '3123524511 	', 'riya@gmail.com', 			'2012-4-10   	','2017-12-1	'),
('153  ', 'Ravi       ', '9124535211  	', 'ravipatel@gmail.com', 		'2012-5-2  		','2020-4-23	'),
('124  ', 'Pragati    ', '7123521143   	', 'pragatidobariya@gmailcom', 	'2005-4-12  	','2010-3-19	'),
('142  ', 'Jinal      ', '3114554211    ', 'jinalk@yahoo.com', 			'2015-11-15   	','2019-4-1		'),
('112  ', 'Shreya     ', '4123525114    ', 'shreyagoshal@gmail.com', 	'2018-12-12   	','2018-4-2		'),
('119  ', 'Saniya     ', '6624342485    ','saniyanehval@gmail,com', 	'2007-3-7  		','2020-6-9		'),
('160  ', 'Mukti      ', '4123521143    ', 'muktishah@gmail.com', 		'2012-4-30   	','2002-7-4		'),
('161  ', 'Sam        ', '8123521143    ', 'samrohan@gmail.com', 		'2001-1-26   	','2027-6-5		'),
('151  ', 'Mearphy    ', '3412352114    ', 'merph@gmail.com', 			'2005-8-12   	', '2019-6-4	'),
('164  ', 'Jose       ', '8123521143    ', 'jose@yahoo.com', 			'2015-6-9   	', '2020-5-21	');

-- -----------------------------------------------------------------------------------------------------
-- Creating table `customers`
-- -----------------------------------------------------------------------------------------------------

CREATE TABLE `checkout` (
  `COID`  int NOT NULL,
  `CUSTID` int NOT NULL,
  `STOREID` int NOT NULL,
  `EMPID` int NOT NULL,
  `SUBTOTAL` decimal(10,4) DEFAULT NULL,
  `TAX` decimal(10,2) DEFAULT NULL,
  `CODATE` date DEFAULT NULL,
  PRIMARY KEY (`COID`),
  KEY `CUSTOMER_STORE_EMP` (`CUSTID`,`STOREID`,`EMPID`)
  ) ;
--
-- Inserting data into `customers`
--
INSERT INTO `checkout` (`COID`, `CUSTID`, `STOREID`, `EMPID`, `SUBTOTAL`,`TAX`,`CODATE`) VALUES
('204  ', '110        	','854',	'2',	'65.25',	'2',	'2020-1-23   	'),
('132  ', '111      	','244',	'3',	'115.25',	'4',	'2011-2-9   	'),
('231  ', '152       	','232', 	'4',	'66.53',	'3',	'2017-12-1   	'),
('432  ', '199       	','324', 	'6',	'211.21',	'6',	'2010-3-19 		'),
('342  ', '197    		','342', 	'4', 	'43.35',	'2',	'2018-4-12  	'),
('431  ', '121      	','345',	'7',	'21.53',	'1',	'2020-11-15   	'),
('453  ', '164     		','343',	'7',	'500.54',	'3.43',	'2018-12-12   	'),
('454  ', '124      	','396', 	'9',	'212.54',	'5',	'2018-4-2   	'),
('444  ', '142			','982', 	'9',	'66.02',	'1.09',	'2020-7-14		');

-- -----------------------------------------------------------------------------------------------------
-- Creating table `customers`
-- -----------------------------------------------------------------------------------------------------	
CREATE TABLE `checkout_action` (
  `ITEMID`  int NOT NULL,
  `COID` int NOT NULL,
  `QUANTITY` int DEFAULT NULL,
  KEY `CHECKOUT_ACTION` (`ITEMID`,`COID`)
  ) ;
--
-- Inserting data into `customers`
--
INSERT INTO `checkout_action` (`ITEMID`,`COID`,`QUANTITY` ) VALUES
('12','204','70'),
('14','132','3'),
('11','454','24'),
('16','432','22'),
('20','342','25'),
('25','132','100'),
('24','432','233'),
('35','444','133'),
('76','231','33'),
('99','454','54');

-- -----------------------------------------------------------------------------------------------------
-- Creating table `customers`
-- -----------------------------------------------------------------------------------------------------
CREATE TABLE `items` (
  `ITEMID`  int NOT NULL,
  `DESCRIPTION_ITEM` varchar(70) NOT NULL,
  `BRAND` varchar(50) NOT NULL,
  `COST` decimal(10,4) NOT NULL,
  `PRICE` decimal(10,4) NOT NULL,
  `WEIGHT` decimal(10,8) NOT NULL,
  `SHAPE` varchar(25) NOT NULL,
  `TAXABLE` int NOT NULL,
  `SIZE` varchar(20) NOT NULL,
  PRIMARY KEY (`ITEMID`)
  ) ;
--
-- Inserting data into `customers`
--
INSERT INTO `items` (`ITEMID`,`DESCRIPTION_ITEM`,`BRAND`,`COST`,`PRICE`,`WEIGHT`,`SHAPE`,`TAXABLE`,`SIZE`) VALUES
('11',	'Organic bananas',		'Organics',		'0.68',		'11.63',		'0.5',	'Rectangle',	'0','6x12x3'),
('12',	'Fresh Strawberries',	'Organics',		'0.99',		'98.97',		'0.8',	'Oval',			'1','23x8x20'),
('14',	'Dunlin Original Brand','Dunkin',		'5.00',		'12.94',		'1.0',	'Squre',		'1','5x5x5'),
('16',	'Lettuce',				'Iceberge',		'0.02',		'42.38',		'0.76',	'Oval',			'0','20x4x21'),
('20',	'Apple',				'Organic Gala',	'1.00',		'20.96',		'1.5',	'Rectangle',	'0','6x12x3'),
('25',	'Whole Milk',			'Clover',		'2.5',		'31.40',		'0.7',	'Rectangle',	'1','10x5x14'),
('24',	'Black Beans',			'WHole Carnel',	'1.5',		'22.99',		'0.4',	'Rectangle',	'1','6x12x3'),
('35',	'Low Fat',				'Cover',		'0.04',		'31.59',		'1.2',	'Rectangle',	'1','6x12x3'),
('76',	'Yellow Corn',			'Organics',		'0.01',		'23.50',		'0.3',	'Rectangle',	'0','15x2x3'),
('99',	'White Corn',			'Organic',		'0.05',		'32.00',		'0.57',	'Rectangle',	'0','15x2x3');

-- -----------------------------------------------------------------------------------------------------
-- Creating table `customers`
-- -----------------------------------------------------------------------------------------------------
CREATE TABLE `employee` (
	`EMPID` 		int ,
    `STOREID` 		int,
    `ENAME` 		varchar(25),
    `SSN` 			int NOT NULL,
    `EPHONE` 		varchar(15) NOT NULL,
	`EADDRESS` 		varchar(25) NOT NULL,
    `EMAIL` 		varchar(50) NOT NULL,
    `PAY_E_M` 		varchar(20) NOT NULL,
    `PASSWORD` 		varchar(25) NOT NULL,
    `DATESTART` 	date NOT NULL,
    `DATEEND` 		date DEFAULT NULL,
    `PAY_ANNU_HOUR` varchar(20) NOT NULL,
	PRIMARY KEY (`EMPID`)
);
--
-- Inserting data into `customers`
--
/* Assumption: PAY_E_M postion - column with 0 and 1, 
 0 represents emp , 
 1 prepresents manager
*/
INSERT INTO `employee` ( `EMPID`, `STOREID`, `ENAME`, `SSN`,  `EPHONE`, `EMAIL`,`EADDRESS`, `PAY_E_M`, `PASSWORD`,`DATESTART`, `DATEEND`, `PAY_ANNU_HOUR`) VALUES
('1','854',	'Harry',	'661555245',	'3732237865',	'h@gmail.com',			'12 Crescent', 		'0','1234',			'1994-07-23',	'2000-1-1',		'20'    ),
('2','244',	'Sahil',	'145651452',	'3452342345',	'sahil@gmail.com',		'320 Milano',		'1','heart342',		'2000-5-3',		 null,		    '60000' ),
('3','232',	'Anil',		'958786548',	'6667874645',	'anilb@gmail.com',		'54 NorthPark',		'1','passw231',		'1991-3-2',		 null,		    '90000' ),
('4','324',	'Teja',		'147589652',	'3424538895',	'tej@gmail.com',		'43 Aris',			'0','mylifebest',	'2010-3-5',		'2015-6-9',		'12'    ),
('6','342',	'Parth',	'661555285',	'2312342322',	'parth@gmail.com',		'21 Sukirti',		'0','lovestudy',	'2007-6-12',	 null,			'60'    ),
('7','343',	'Dipu',		'112132323',	'4345453424',	'dipu@gmail.com',		'32 Vinayak',		'0','sqlweknow',	'2019-4-21',	 null,			'8.25'  ),
('9','396',	'Palash',	'666999999',	'6667874645',	'palash@gmail.com',		'390 Ayodhya',		'0','happylife',	'2012-12-12',	 null,			'14'    );

-- -----------------------------------------------------------------------------------------------------
-- Creating table `customers`
-- -----------------------------------------------------------------------------------------------------
CREATE TABLE `store` (
	`STOREID` 	int NOT NULL,
    `SADDRESS` 	varchar(50) NOT NULL,
    PRIMARY KEY (`STOREID`)
);

INSERT INTO `store` (`STOREID`, `SADDRESS`) VALUES
('854','233 El Real'),
('244','754 Inovation Dr'),
('232','89 Loggia '),
('324','44 Cisco Way'),
('342','653 Sunny Rd'),
('343','894 Nikol '),
('396','89 Satalite Rd');

-- -----------------------------------------------------------------------------------------------------
-- Creating table `customers`
-- -----------------------------------------------------------------------------------------------------
CREATE TABLE `inventory` (
`ITEMID` int NOT NULL,
`STOREID` int NOT NULL,
`QUANTITY` int 
);

INSERT INTO `inventory` (`ITEMID`,`STOREID`,`QUANTITY`) VALUES
('11','854','5'),
('12','244','13'),
('14','232','14'),
('16','342','2'),
('25','345','44'),
('24','396','5'),
('35','343','67'),
('76','982','74'),
('99','324','3');

-- -----------------------------------------------------------------------------------------------------
-- Creating table `customers`
-- -----------------------------------------------------------------------------------------------------
CREATE TABLE `contact_manager` (
`MID` int,
`EMPID` int,
`STOREID` int,
`POSITION_INSTORE` varchar(30) NOT NULL,
`CONTACT` varchar(15) NOT NULL,
`CEMAIL` varchar(50) NOT NULL,
PRIMARY KEY (`MID`)
);


INSERT INTO `contact_manager` (`MID`, `EMPID`,`STOREID`,`POSITION_INSTORE`,`CONTACT`,`CEMAIL`) VALUES
('01','2','854','Manager',	'4152324232',	'Hina@gmail.com'),
('02','3','244','Director',	'8876753423',	'Rusha@gmail.com'),
('03','3','232','Manager',	'2343435656',	'Aditya@gmail.com'),
('04','4','324','Director',	'7536549656',	'Chandrakant@gmail.com'),
('05','6','342','Director',	'6574676589',	'Anna@gmail.com'),
('06','6','345','Manager',	'4567537857',	'Lisa@gmail.com'),
('07','4','343','Manager',	'7857675676',	'Lily@gmail.com'),
('08','9','396','Director',	'5778556545', 	'Priya@gmail.com'),
('09','6','982','Manager',	'6767644684',	'Harita@gmail.com');

-- ------------------------------------------------------------------------------------
/* Different reports that grocery management and customers to have */
-- -------------------------------------------------------------------------------------
/*Q1. Which grocery store has the largest quantity in inventory      */
-- ------------------------------------------------------------------------------------
SELECT 
	i.ITEMID, 
    i.STOREID, 
    s.SADDRESS, 
    MAX(i.QUANTITY) AS Maximum_Items_Inventory
FROM inventory i
INNER JOIN store s ON i.STOREID=s.STOREID
GROUP BY i.ITEMID, i.STOREID,s.SADDRESS
ORDER BY Maximum_Items_Inventory DESC;

/*=> 343 Store has the maximum number of inventories. 342 store has the list, using this information the manager can request to update their store inventory. 
 => It can also be interpreted that most of the customers are going to 894 Nikol store may that store is closer to customer to pick up their order.
*/

-- ------------------------------------------------------------------------------------
/*Q2. How many items are more than $20 and customer has checked out?*/
-- ------------------------------------------------------------------------------------
SELECT 
	c.CUSTID,
    c.CUST_NAME,
    i.PRICE AS Item_Price,
    co.SUBTOTAL
FROM items i
INNER JOIN checkout_action ca ON i.ITEMID=ca.ITEMID
INNER JOIN checkout co ON co.COID=ca.COID
INNER JOIN customers c ON c.CUSTID=co.CUSTID
WHERE 
	i.PRICE > 20
GROUP BY c.CUSTID,c.CUST_NAME, i.PRICE,co.SUBTOTAL
ORDER BY co.SUBTOTAL DESC;

/*There are five customers who have checked-out the products which cost more than $20. The maximum purchase is done by customer named pragati with item cost 32$.
=> From this information business insider may know what is the maximum sub total with item price. 
=> This will help him decide whether there should be an increment or decrement in the price.
*/

-- ------------------------------------------------------------------------------------
/* Q3. Which item is ordered by customer with maximum quantity. */
-- ------------------------------------------------------------------------------------
SELECT 
	c.CUST_NAME,
	i.DESCRIPTION_ITEM,
    i.BRAND,
    i.WEIGHT,
    i.SIZE,
    MAX(ca.QUANTITY) as Max_Quantity
FROM items i
INNER JOIN checkout_action ca ON i.ITEMID=ca.ITEMID
INNER JOIN checkout co ON co.COID=ca.COID
INNER JOIN customers c ON c.CUSTID=co.CUSTID
GROUP BY  c.CUST_NAME, i.DESCRIPTION_ITEM, i.BRAND, i.WEIGHT, i.SIZE
ORDER BY Max_Quantity DESC;

/*=> The above result shows the details of the item. 
Which customer has ordered a particular product the maximum time. 
Here the customer 'Jinal' has ordered 'Low Fat'  133 times which is the max.

=> Out of all purchases most of people has ordered product which is of brand organics
*/

-- ---------------------------------------------------------------------------
/* Q4. How many customers has check out in 2020-JAN */

SELECT 
	s.CUST_NAME,
    c.CODATE
FROM customers s
INNER JOIN checkout c ON c.CUSTID=s.CUSTID
WHERE 
	c.CODATE > '2020-01-01';

/*=> There are only two customers who has checkout after 2020-Jan-01. It shows there must be something to look into.  */

-- ---------------------------------------------------------------------------
/* Q5. List the items that has cost more than 70$ and customer bought it   */ 
-- ---------------------------------------------------------------------------
SELECT 
	i.DESCRIPTION_ITEM,
    c.STOREID,
    i.PRICE AS PRICE,
    c.SUBTOTAL,
    co.QUANTITY
FROM items i
INNER JOIN checkout_action co ON i.ITEMID=co.ITEMID
INNER JOIN checkout c ON c.COID=co.COID
WHERE 
	i.PRICE > 70.00
GROUP BY i.DESCRIPTION_ITEM,c.STOREID,i.PRICE,c.SUBTOTAL,co.QUANTITY
ORDER BY PRICE DESC;

/*=> There is only one item which price more than $70 and customer has ordered Fresh Strawberries*/

-- ---------------------------------------------------------------------------
/*Q6. Which item has more than 5% markup price.*/
-- ---------------------------------------------------------------------------
SELECT 
	BRAND,
    ITEMID,
    COST,
    PRICE
FROM items 
WHERE 
	(COST*1.05) < PRICE;

/*=> The price set for the customer is higher than the 5%markup given to the manufacturing price. Using this key column the owner can manage his profit margin. */

-- ---------------------------------------------------------------------------
/*Q7. Which store has maximum number of employees */
-- ---------------------------------------------------------------------------
SELECT 
	s.STOREID,
    MAX(e.EMPID) AS MAX_EMP
FROM store s
INNER JOIN employee e ON e.STOREID=s.STOREID
GROUP BY s.STOREID
ORDER BY MAX_EMP DESC;

/*Maximum number of employees are working for store 396.  */

-- ---------------------------------------------------------------------------
/*Q8. Provide a list of customers who bought more than 2 items in a single transaction */
-- ---------------------------------------------------------------------------
SELECT
	c.CUSTID, 
    c.CUST_NAME,
    i.DESCRIPTION_ITEM,
    i.BRAND,
    i.PRICE,
    ca.QUANTITY,
    i.PRICE*ca.QUANTITY+co.TAX AS TOTAL_PAYMENT
FROM customers c
INNER JOIN checkout co ON co.CUSTID = c.CUSTID
INNER JOIN checkout_action ca ON co.COID = ca.COID
INNER JOIN items i ON i.ITEMID=ca.ITEMID
WHERE 
	ca.QUANTITY > 2
GROUP BY c.CUSTID, c.CUST_NAME,i.DESCRIPTION_ITEM,i.BRAND, i.PRICE, ca.QUANTITY, i.PRICE*ca.QUANTITY+co.TAX
ORDER BY ca.QUANTITY DESC;

/*There are 7 more customers who have ordered more than two items in a single transaction.
Total payment can be calculated using the formula (price*quantity)+tax.
*/

-- ---------------------------------------------------------------------------
/*Q9. Provide the list of items from only three stores selected by customer.
Assuming: Customer has selected STOREID - 396, 342 and 354
*/
-- ---------------------------------------------------------------------------
SELECT 
	s.STOREID , 
    i.ITEMID,
    i.DESCRIPTION_ITEM 
FROM store s 
INNER JOIN inventory inv ON s.STOREID=inv.STOREID  
INNER JOIN items i ON i.ITEMID=inv.ITEMID
Where 
	s.STOREID IN (396,342,354);

/*The customer has the liberty to choose his grocery stores. 
Assuming the customer has selected store number 396,342 and 354. 
The above table shows only those items of the chosen three store inventories.*/

-- ---------------------------------------------------------------------------    
/*Q10. Provide a list to contact the store which has low items quantity in inventory */
-- ---------------------------------------------------------------------------
 SELECT 
	m.POSITION_INSTORE,
    m.CONTACT,
    m.CEMAIL,
    i.QUANTITY,
    s.SADDRESS
FROM contact_manager m
INNER JOIN store s ON s.STOREID=m.STOREID
INNER JOIN inventory i ON i.STOREID=s.STOREID
WHERE
	i.QUANTITY < 20
GROUP BY m.POSITION_INSTORE,m.CONTACT,m.CEMAIL,i.QUANTITY,s.SADDRESS
ORDER BY i.QUANTITY ASC;
    
/*This table will helpful to manager who need to handle the inventory. If `insta_grocery` app manager wants to see which store has the lowest inventory, 
then he can access this table and easily reach out to the store’s manager in order to warn them about current status of their inventory. 
- This information is also helpful when app manger wants to contact all stores manager for any heads up
*/

