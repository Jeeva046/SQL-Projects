/*
Create a table named 'PASSENGER' with the following columns:
'Passenger_id' (integer) as the primary key
'Passenger_name' (text) as the name of the passenger
'Category' (text) as the category of the passenger
'Gender' (text) as the gender of the passenger
'Boarding_City' (text) as the city where the passenger boarded
'Destination_City' (text) as the city where the passenger is going
'Distance' (integer) as the distance of the journey
'Bus_Type' (text) as the type of bus*/

CREATE TABLE passenger (
	passenger_id INT PRIMARY KEY,
	passenger_name VARCHAR(100),
	category VARCHAR(25),
	GENDER CHAR(1),
	boarding_city VARCHAR(50),
	destination_city VARCHAR(50),
	distance INT,
	bus_type VARCHAR(25)	
);


/*Create a table named 'PRICE' with the following columns:
'id' (integer) as the primary key
'Bus_Type' (text) as the type of bus
'Distance' (integer) as the distance of the journey
'Price' (integer) as the price of the journey*/

CREATE TABLE price ( 
	id INT PRIMARY KEY,
	bus_type VARCHAR(25),
	distance INT,
	price INT
);


/*
We need to insert values into newly created tables
*/

INSERT INTO passenger VALUES 
(1,'Sejal','AC','F','Bengaluru','Chennai',350,'Sleeper'),
(2,'Anmol','Non-AC','M','Mumbai','Hyderabad',700,'Sitting'),
(3,'Pallavi','AC','F','Panaji','Bengaluru',600,'Sleeper'),
(4,'Khusboo','AC','F','Chennai','Mumbai',1500,'Sleeper'),
(5,'Udit','Non-AC','M','Tirvandrum','Panaji',1000,'Sleeper'),
(6,'Ankur','AC','M','Nagpur','Hyderabad',500,'Sitting'),
(7,'Hemant','Non-AC','M','Panaji','Mumbai',700,'Sleeper'),
(8,'Manish','Non-AC','M','Hyderabad','Bengaluru',500,'Sitting'),
(9,'Piyush','AC','M','Pune','Nagpur',700,'Sitting');

INSERT INTO Price VALUES
(1, 'Sleeper', 350, 770),
(2, 'Sleeper', 500, 1100),
(3, 'Sleeper', 600, 1320),
(4, 'Sleeper', 700, 1540),
(5, 'Sleeper', 1000, 2200),
(6, 'Sleeper', 1200, 2640),
(7, 'Sleeper', 1500, 2700),
(8, 'Sitting', 500, 620),
(9, 'Sitting', 600, 744),
(10, 'Sitting', 700, 868),
(11, 'Sitting', 1000, 1240),
(12, 'Sitting', 1200, 1488),
(13, 'Sitting', 1500, 1860);

/*Write an SQL query to count the number of female passengers as "count" 
who have traveled a minimum distance of 600 KM.*/

SELECT gender , COUNT(*)
	FROM (SELECT *
          FROM passenger
          WHERE gender = 'F' AND distance >=600)
	GROUP BY gender
;

/*Write an SQL query to display the details of passengers 
who are traveling in a sleeper bus and have a travel distance greater than 500.*/

SELECT passenger_id, passenger_name, gender, category 
FROM passenger
WHERE bus_type = 'Sleeper' AND distance >500
;

/*Write an SQL query to select the names of passengers 
whose names start with the letter 'S' from the 'Passenger' table.*/

SELECT * 
FROM passenger
WHERE passenger_name LIKE 'S%'
;

/*Write an SQL query to calculate the price charged for each passenger, displaying the 
Passenger name, Boarding City, Destination City, Bus type, and Price in the output.*/

SELECT pa.passenger_name, pa.boarding_city , pa.destination_city, pa.distance, pr.price 
FROM passenger as  pa
LEFT JOIN price as pr on pa.bus_type = pr.bus_type
                AND pa.distance = pr.distance
;

/*Write an SQL query to extract the passenger name(s) and 
the ticket price for those who traveled 700 KMs Sitting in a bus?*/

SELECT pa.passenger_name, pa.boarding_city , 
	   pa.destination_city, pr.price 
FROM passenger as  pa
LEFT JOIN price as pr on pa.bus_type = pr.bus_type
                         AND pa.distance = pr.distance
WHERE pa.bus_type = 'Sitting' AND pa.distance = 700;

/*Write an SQL query to calculate the bus fare for a 
passenger named 'Pallavi' traveling from Panaji to Bengaluru . */

SELECT pa.passenger_name, pa.boarding_city, 
	   pa.destination_city,pa.bus_type ,pr.price
FROM passenger pa LEFT JOIN price pr
	 ON pa.bus_type = pr.bus_type
	 AND pa.distance = pr.distance
WHere passenger_name LIKE 'Pallavi' 
	  AND boarding_city = 'Panaji' AND destination_city = 'Bengaluru';

/*You are working with a travel agency database that stores information about bus bookings. 
The database has a table named passenger with the following columns: 
                passenger_id, name, bus_type, and category. 
You need to update the category column to 'Non-AC' for all rows where the bus_type is 'sleeper'.
Write an SQL query to update the category column in the passenger table 
based on the specified condition.*/

UPDATE passenger 
SET 
   category = 'Non-AC'
WHERE bus_type = 'Sleeper';


/*You are working with a database of a travel agency called Travego Travellers. 
Your task is to delete a passenger from the 'passenger' table where the passenger name is 'Piyush'.
Write an SQL query to delete the record and commit the change in the database.*/

DELETE FROM passenger 
WHERE passenger_name = 'Piyush'
	RETURNING *;

/*Write an SQL query to truncate the passenger table and 
comment on the number of rows in the table before and after truncation.*/ 


SELECT COUNT(*) AS row_count_before FROM passenger;
TRUNCATE TABLE passenger;
SELECT COUNT(*) AS row_count_after FROM passenger;

/*Write an SQL query to delete the table named 'passenger' from the database.*/

DROP TABLE passenger;

-- Thank you --










