create database table_booking_app;

use table_booking_app;

CREATE TABLE Restaurants (
    restaurant_id INT PRIMARY KEY,
    restaurant_name VARCHAR(255),
    location_id INT,
    category_id INT,
    phone_number VARCHAR(15),
    email VARCHAR(255),
    opening_hours VARCHAR(50)
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255),
    phone_number VARCHAR(15),
    address_id INT
);

CREATE TABLE Tables (
    table_id INT PRIMARY KEY,
    restaurant_id INT,
    table_number INT,
    capacity INT
);

CREATE TABLE Time (
    time_id INT PRIMARY KEY,
    hour INT,
    minute INT,
    second INT
);

CREATE TABLE Locations (
    location_id INT PRIMARY KEY,
    city VARCHAR(255),
    state VARCHAR(255),
    zip_code VARCHAR(10),
    country VARCHAR(255)
);

CREATE TABLE Categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(255)
);

CREATE TABLE Addresses (
    address_id INT PRIMARY KEY,
    street VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    zip_code VARCHAR(10),
    country VARCHAR(255)
);

CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY,
    restaurant_id INT,
    customer_id INT,
    table_id INT,
    time_id INT,
    total_guests INT,
    booking_date DATE,
    booking_time TIME,
    booking_status VARCHAR(50),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (table_id) REFERENCES Tables(table_id),
    FOREIGN KEY (time_id) REFERENCES Time(time_id)
);

-- Find the total number of bookings for each restaurant:
SELECT r.restaurant_name, COUNT(b.booking_id) as total_bookings
FROM Bookings b
JOIN Restaurants r ON b.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_name
ORDER BY total_bookings DESC;

-- Find the top 5 customers with the highest number of bookings:
SELECT CONCAT(c.first_name, ' ', c.last_name) as customer_name, COUNT(b.booking_id) as total_bookings
FROM Bookings b
JOIN Customers c ON b.customer_id = c.customer_id
GROUP BY customer_name
ORDER BY total_bookings DESC
LIMIT 5;

-- Find the average number of guests per booking for each restaurant category:
SELECT cat.category_name, AVG(b.total_guests) as average_guests
FROM Bookings b
JOIN Restaurants r ON b.restaurant_id = r.restaurant_id
JOIN Categories cat ON r.category_id = cat.category_id
GROUP BY cat.category_name;

-- Find the percentage of bookings made during peak hours (6 PM to 9 PM):
SELECT (COUNT(b.booking_id) * 100.0 / (SELECT COUNT(*) FROM Bookings)) as peak_hour_percentage
FROM Bookings b
JOIN Time t ON b.time_id = t.time_id
WHERE t.hour BETWEEN 18 AND 21;

-- Find the top 3 most popular booking dates:
SELECT b.booking_date, COUNT(b.booking_id) as total_bookings
FROM Bookings b
GROUP BY b.booking_date
ORDER BY total_bookings DESC
LIMIT 3;

