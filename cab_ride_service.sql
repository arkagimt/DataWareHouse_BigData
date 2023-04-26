create database cab_ride_service;

use cab_ride_service;

CREATE TABLE Fact_Ride_Details (
    ride_id BIGINT NOT NULL PRIMARY KEY,
    driver_id INT NOT NULL,
    customer_id INT NOT NULL,
    route_id INT NOT NULL,
    payment_id INT NOT NULL,
    date_id INT NOT NULL,
    ride_duration FLOAT NOT NULL,
    ride_distance FLOAT NOT NULL,
    fare_amount DECIMAL(10, 2) NOT NULL,
    tip_amount DECIMAL(10, 2) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (driver_id) REFERENCES Dim_Driver(driver_id),
    FOREIGN KEY (customer_id) REFERENCES Dim_Customer(customer_id),
    FOREIGN KEY (route_id) REFERENCES Dim_Route(route_id),
    FOREIGN KEY (payment_id) REFERENCES Dim_Payment(payment_id),
    FOREIGN KEY (date_id) REFERENCES Dim_Date(date_id)
);

CREATE TABLE Dim_Driver (
    driver_id INT NOT NULL PRIMARY KEY,
    driver_name VARCHAR(100) NOT NULL,
    driver_license VARCHAR(50) NOT NULL,
    driver_phone VARCHAR(15) NOT NULL,
    driver_email VARCHAR(100)
);

CREATE TABLE Dim_Customer (
    customer_id INT NOT NULL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    customer_phone VARCHAR(15) NOT NULL,
    customer_email VARCHAR(100),
    customer_address VARCHAR(200)
);

CREATE TABLE Dim_Route (
    route_id INT NOT NULL PRIMARY KEY,
    start_location VARCHAR(200) NOT NULL,
    end_location VARCHAR(200) NOT NULL
);

CREATE TABLE Dim_Payment (
    payment_id INT NOT NULL PRIMARY KEY,
    payment_type VARCHAR(50) NOT NULL
);

CREATE TABLE Dim_Date (
    date_id INT NOT NULL PRIMARY KEY,
    date DATE NOT NULL,
    day TINYINT NOT NULL,
    month TINYINT NOT NULL,
    year SMALLINT NOT NULL,
    day_of_week TINYINT NOT NULL,
    is_weekend BIT NOT NULL
);

-- Total rides, revenue, and average fare per driver:
SELECT d.driver_id, d.driver_name, COUNT(f.ride_id) as total_rides, SUM(f.total_amount) as revenue, AVG(f.total_amount) as avg_fare
FROM Fact_Ride_Details f
JOIN Dim_Driver d ON f.driver_id = d.driver_id
GROUP BY d.driver_id, d.driver_name
ORDER BY revenue DESC;

-- Total rides and revenue per day of the week:
SELECT dt.day_of_week, COUNT(f.ride_id) as total_rides, SUM(f.total_amount) as revenue
FROM Fact_Ride_Details f
JOIN Dim_Date dt ON f.date_id = dt.date_id
GROUP BY dt.day_of_week
ORDER BY revenue DESC;

-- Top 10 customers by total ride count and revenue:
SELECT c.customer_id, c.customer_name, COUNT(f.ride_id) as total_rides, SUM(f.total_amount) as revenue
FROM Fact_Ride_Details f
JOIN Dim_Customer c ON f.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY revenue DESC
LIMIT 10;

-- Total revenue per payment type:
SELECT p.payment_type, COUNT(f.ride_id) as total_rides, SUM(f.total_amount) as revenue
FROM Fact_Ride_Details f
JOIN Dim_Payment p ON f.payment_id = p.payment_id
GROUP BY p.payment_type
ORDER BY revenue DESC;

-- most popular routes by ride count:
SELECT r.route_id, r.start_location, r.end_location, COUNT(f.ride_id) as total_rides
FROM Fact_Ride_Details f
JOIN Dim_Route r ON f.route_id = r.route_id
GROUP BY r.route_id, r.start_location, r.end_location
ORDER BY total_rides DESC
LIMIT 10;

-- Average ride duration and distance per day of the week:
SELECT dt.day_of_week, AVG(f.ride_duration) as avg_duration, AVG(f.ride_distance) as avg_distance
FROM Fact_Ride_Details f
JOIN Dim_Date dt ON f.date_id = dt.date_id
GROUP BY dt.day_of_week
ORDER BY dt.day_of_week;

-- Monthly revenue over time:
SELECT dt.year, dt.month, SUM(f.total_amount) as revenue
FROM Fact_Ride_Details f
JOIN Dim_Date dt ON f.date_id = dt.date_id
GROUP BY dt.year, dt.month
ORDER BY dt.year, dt.month;


