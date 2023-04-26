create database food_delivery_app;

use food_delivery_app;

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255),
    customer_email VARCHAR(255),
    customer_phone VARCHAR(20),
    customer_address VARCHAR(255),
    city VARCHAR(100),
    zipcode VARCHAR(10)
);

CREATE TABLE Restaurant (
    restaurant_id INT PRIMARY KEY,
    restaurant_name VARCHAR(255),
    restaurant_email VARCHAR(255),
    restaurant_phone VARCHAR(20),
    restaurant_address VARCHAR(255),
    city VARCHAR(100),
    zipcode VARCHAR(10),
    cuisine_type VARCHAR(100)
);

CREATE TABLE Rider (
    rider_id INT PRIMARY KEY,
    rider_name VARCHAR(255),
    rider_email VARCHAR(255),
    rider_phone VARCHAR(20),
    rider_vehicle_type VARCHAR(50)
);

CREATE TABLE `Order` (
    order_id INT PRIMARY KEY,
    order_amount DECIMAL(10, 2),
    order_items INT,
    order_discount DECIMAL(10, 2),
    payment_method VARCHAR(50)
);

CREATE TABLE Order_Date (
    order_date_id INT PRIMARY KEY,
    day INT,
    month INT,
    year INT
);

CREATE TABLE Order_Time (
    order_time_id INT PRIMARY KEY,
    hour INT,
    minute INT
);

CREATE TABLE Delivery (
    delivery_id INT PRIMARY KEY,
    customer_id INT,
    restaurant_id INT,
    rider_id INT,
    order_id INT,
    order_date_id INT,
    order_time_id INT,
    delivery_fee DECIMAL(10, 2),
    delivery_duration INT,
    rating DECIMAL(3, 2),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurant(restaurant_id),
    FOREIGN KEY (rider_id) REFERENCES Rider(rider_id),
    FOREIGN KEY (order_id) REFERENCES `Order`(order_id),
    FOREIGN KEY (order_date_id) REFERENCES Order_Date(order_date_id),
    FOREIGN KEY (order_time_id) REFERENCES Order_Time(order_time_id)
);

-- Total revenue per month:
SELECT SUM(Delivery.delivery_fee + `Order`.order_amount) as revenue, Order_Date.month, Order_Date.year
FROM Delivery
JOIN `Order` ON Delivery.order_id = `Order`.order_id
JOIN Order_Date ON Delivery.order_date_id = Order_Date.order_date_id
GROUP BY Order_Date.year, Order_Date.month;

-- Top 5 restaurants with the highest number of orders:
SELECT Restaurant.restaurant_name, COUNT(Delivery.delivery_id) as total_orders
FROM Delivery
JOIN Restaurant ON Delivery.restaurant_id = Restaurant.restaurant_id
GROUP BY Restaurant.restaurant_id
ORDER BY total_orders DESC
LIMIT 5;

-- Top 5 most popular cuisine types:
SELECT Restaurant.cuisine_type, COUNT(Delivery.delivery_id) as total_orders
FROM Delivery
JOIN Restaurant ON Delivery.restaurant_id = Restaurant.restaurant_id
GROUP BY Restaurant.cuisine_type
ORDER BY total_orders DESC
LIMIT 5;

-- Average delivery time by vehicle type:
SELECT Rider.rider_vehicle_type, AVG(Delivery.delivery_duration) as avg_delivery_time
FROM Delivery
JOIN Rider ON Delivery.rider_id = Rider.rider_id
GROUP BY Rider.rider_vehicle_type;

-- Customer retention rate (number of returning customers / total customers):
SELECT (COUNT(DISTINCT Delivery.customer_id) - COUNT(DISTINCT CASE WHEN t.num_orders = 1 THEN Delivery.customer_id ELSE NULL END)) * 100 / COUNT(DISTINCT Delivery.customer_id) as retention_rate
FROM Delivery
JOIN (
    SELECT customer_id, COUNT(delivery_id) as num_orders
    FROM Delivery
    GROUP BY customer_id
) t ON Delivery.customer_id = t.customer_id;


