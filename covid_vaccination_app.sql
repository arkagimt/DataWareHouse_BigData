create database covid_vaccination_app;

use covid_vaccination_app;

CREATE TABLE Fact_Vaccination (
    vaccination_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    vaccine_id INT,
    provider_id INT,
    location_id INT,
    date_id INT,
    dose_number INT,
    side_effects VARCHAR(255),
    FOREIGN KEY (patient_id) REFERENCES Dim_Patient(patient_id),
    FOREIGN KEY (vaccine_id) REFERENCES Dim_Vaccine(vaccine_id),
    FOREIGN KEY (provider_id) REFERENCES Dim_Provider(provider_id),
    FOREIGN KEY (location_id) REFERENCES Dim_Location(location_id),
    FOREIGN KEY (date_id) REFERENCES Dim_Date(date_id)
);

CREATE TABLE Dim_Patient (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birth_date DATE,
    gender VARCHAR(10),
    contact_number VARCHAR(20),
    email VARCHAR(100),
    address VARCHAR(255)
);

CREATE TABLE Dim_Vaccine (
    vaccine_id INT AUTO_INCREMENT PRIMARY KEY,
    vaccine_name VARCHAR(100),
    manufacturer VARCHAR(100),
    vaccine_type VARCHAR(50),
    storage_temperature VARCHAR(50),
    effectiveness FLOAT
);

CREATE TABLE Dim_Provider (
    provider_id INT AUTO_INCREMENT PRIMARY KEY,
    provider_name VARCHAR(100),
    provider_type VARCHAR(50),
    contact_number VARCHAR(20),
    email VARCHAR(100),
    address VARCHAR(255)
);

CREATE TABLE Dim_Location (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    location_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    zip_code VARCHAR(10)
);

CREATE TABLE Dim_Date (
    date_id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE,
    day INT,
    month INT,
    year INT,
    quarter INT,
    day_of_week INT
);

-- Total number of vaccinations per vaccine type:
SELECT
    v.vaccine_name,
    COUNT(f.vaccination_id) AS total_vaccinations
FROM
    Fact_Vaccination f
JOIN
    Dim_Vaccine v ON f.vaccine_id = v.vaccine_id
GROUP BY
    v.vaccine_name;

-- Number of vaccinations per provider:
SELECT
    p.provider_name,
    COUNT(f.vaccination_id) AS total_vaccinations
FROM
    Fact_Vaccination f
JOIN
    Dim_Provider p ON f.provider_id = p.provider_id
GROUP BY
    p.provider_name;

-- Monthly vaccination count for the current year:
SELECT
    d.month,
    COUNT(f.vaccination_id) AS total_vaccinations
FROM
    Fact_Vaccination f
JOIN
    Dim_Date d ON f.date_id = d.date_id
WHERE
    d.year = YEAR(CURDATE())
GROUP BY
    d.month;

-- Number of vaccinations per location (city-wise):
SELECT
    l.city,
    COUNT(f.vaccination_id) AS total_vaccinations
FROM
    Fact_Vaccination f
JOIN
    Dim_Location l ON f.location_id = l.location_id
GROUP BY
    l.city;

-- Most common side effects per vaccine type:
SELECT
    v.vaccine_name,
    f.side_effects,
    COUNT(f.vaccination_id) AS total_occurrences
FROM
    Fact_Vaccination f
JOIN
    Dim_Vaccine v ON f.vaccine_id = v.vaccine_id
WHERE
    f.side_effects <> ''
GROUP BY
    v.vaccine_name, f.side_effects
ORDER BY
    v.vaccine_name, total_occurrences DESC;

-- Vaccination count by age group and gender:
SELECT
    p.gender,
    CASE
        WHEN TIMESTAMPDIFF(YEAR, p.birth_date, CURDATE()) BETWEEN 0 AND 17 THEN '0-17'
        WHEN TIMESTAMPDIFF(YEAR, p.birth_date, CURDATE()) BETWEEN 18 AND 34 THEN '18-34'
        WHEN TIMESTAMPDIFF(YEAR, p.birth_date, CURDATE()) BETWEEN 35 AND 49 THEN '35-49'
        WHEN TIMESTAMPDIFF(YEAR, p.birth_date, CURDATE()) BETWEEN 50 AND 64 THEN '50-64'
        ELSE '65+'
    END AS age_group,
    COUNT(f.vaccination_id) AS total_vaccinations
FROM
    Fact_Vaccination f
JOIN
    Dim_Patient p ON f.patient_id = p.patient_id
GROUP BY
    p.gender, age_group;

