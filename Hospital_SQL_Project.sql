CREATE TABLE patients
(patient_id VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender CHAR(1),
    date_of_birth DATE,
    contact_number VARCHAR(15),
    address VARCHAR(100),
    registration_date DATE,
    insurance_provider VARCHAR(50),
    insurance_number VARCHAR(50),
    email VARCHAR(50)
	);


CREATE TABLE doctors
(doctor_id VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialization VARCHAR(50),
    phone_number VARCHAR(15),
    years_experience INT,
    hospital_branch VARCHAR(50),
    email VARCHAR(50)
	);


CREATE TABLE appointments 
    (appointment_id VARCHAR(20) PRIMARY KEY,
    patient_id VARCHAR,
    doctor_id VARCHAR,
    appointment_date DATE,
    appointment_time TIME,
    reason_for_visit VARCHAR(100),
    status VARCHAR(20),
	FOREIGN KEY(patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY(doctor_id) REFERENCES doctors(doctor_id)
    );


CREATE TABLE treatments
   (treatment_id VARCHAR(20) PRIMARY KEY,
   appointment_id VARCHAR,
   treatment_type VARCHAR(50),
   description TEXT,
    cost DECIMAL(10,2),
    treatment_date DATE,
    FOREIGN KEY(appointment_id) REFERENCES appointments (appointment_id)
	);


CREATE  TABLE billing
    (bill_id VARCHAR(20) PRIMARY KEY,
	patient_id VARCHAR,
	treatment_id VARCHAR,
	bill_date DATE,
	amount DECIMAL(10,2),
    payment_method VARCHAR(20),
    payment_status VARCHAR(20),
    FOREIGN KEY(patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY(treatment_id) REFERENCES treatments(treatment_id)
	);

--data exploration

--count of rows
SELECT COUNT(*) FROM patients;
SELECT COUNT(*) FROM doctors;
SELECT COUNT(*) FROM appointments;
SELECT COUNT(*) FROM treatments;
SELECT COUNT(*) FROM billing;

--sample data
SELECT * FROM patients
LIMIT 5;



--where value is null
SELECT * FROM patients 
WHERE patient_id IS NULL
OR
first_name IS NULL
OR
last_name IS NULL
OR
gender IS NULL
OR
date_of_birth IS NULL
OR
contact_number IS NULL
OR
address IS NULL
OR
registration_date IS NULL
OR
insurance_provider IS NULL
OR
insurance_number IS NULL
OR
email IS NULL

SELECT * FROM doctors
WHERE doctor_id IS NULL
OR
first_name IS NULL
OR
last_name IS NULL
OR
specialization IS NULL
OR
phone_number IS NULL
OR
years_experience IS NULL
OR
hospital_branch IS NULL
OR
email IS NULL

SELECT * FROM appointments
WHERE appointment_id IS NULL
OR
patient_id IS NULL
OR
doctor_id IS NULL
OR
appointment_date IS NULL
OR
appointment_time IS NULL
OR
reason_for_visit IS NULL
OR
status IS NULL

SELECT * FROM treatments 
WHERE treatment_id IS NULL
OR
appointment_id IS NULL
OR
treatment_type IS NULL
OR
description IS NULL
OR
cost IS NULL
OR
treatment_date IS NULL

SELECT * FROM billing
WHERE bill_id IS NULL
OR
patient_id IS NULL
OR
treatment_id IS NULL
OR
bill_date IS NULL
OR
amount IS NULL
OR
payment_method IS NULL
OR
payment_status IS NULL


--duplicate rows
SELECT patient_id, COUNT(*) 
FROM patients 
GROUP BY patient_id 
HAVING COUNT(*) > 1;

SELECT doctor_id, COUNT(*) 
FROM doctors 
GROUP BY doctor_id 
HAVING COUNT(*) > 1;

SELECT appointment_id, COUNT(*) 
FROM appointments
GROUP BY appointment_id 
HAVING COUNT(*) > 1;

SELECT treatment_id, COUNT(*) 
FROM treatments 
GROUP BY treatment_id 
HAVING COUNT(*) > 1;

SELECT bill_id, COUNT(*) 
FROM billing 
GROUP BY bill_id 
HAVING COUNT(*) > 1;


--List all patients who are female.

SELECT patient_id, 
    first_name, 
    last_name, 
    date_of_birth, 
    gender
FROM patients
WHERE gender = 'F';


--Retrieve patients born after 1990.

SELECT patient_id, 
    first_name, 
    last_name, 
    date_of_birth, 
    gender
FROM patients
WHERE EXTRACT(YEAR FROM date_of_birth) > 1990; 


--Find the average years of experience for doctors per specialization.

SELECT specialization,
ROUND(AVG(years_experience),2) as avg_exp
FROM doctors
GROUP BY specialization;


--List all appointments scheduled for the next 7 days.
    
SELECT appointment_id,
    patient_id,
    doctor_id,
    appointment_date,
    status
FROM appointments
WHERE appointment_date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '7 days';


--Count the number of appointments per patient.

SELECT patient_id,
COUNT(appointment_id) AS total_appointments
FROM appointments
GROUP BY patient_id;
    

--Find the minimum, maximum, and average treatment cost per treatment type.

SELECT treatment_type,
MIN(cost) AS min_cost,
MAX(cost) AS max_cost,
ROUND(AVG(cost), 2) AS avg_cost
FROM treatments
GROUP BY treatment_type;


--Show the total billing amount per payment method.

SELECT payment_method,
ROUND (SUM(amount),2) AS total_amount
FROM billing
GROUP BY payment_method;


--Retrieve all patients registered before 2023.

SELECT *  FROM patients
WHERE registration_date < '2023-01-01';


--Find the number of treatments given per month.

SELECT DATE_TRUNC('month', treatment_date) AS month,
       COUNT(*) AS total_treatments
FROM treatments
GROUP BY DATE_TRUNC('month', treatment_date)
ORDER BY month;


--List doctors who have more than 10 years of experience.

SELECT * FROM doctors
WHERE years_experience > 10;


--Find patients whose date of birth is between 1980 and 2000.

SELECT * FROM patients
WHERE EXTRACT(YEAR FROM date_of_birth) BETWEEN 1980 AND 2000;


--Find all treatments with patient and doctor names.

SELECT 
    t.treatment_id,
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    d.first_name AS doctor_first_name,
    d.last_name AS doctor_last_name,
    t.treatment_type,
    t.treatment_date
FROM treatments AS t
INNER JOIN appointments AS a
    ON t.appointment_id = a.appointment_id
INNER JOIN patients AS p
    ON a.patient_id = p.patient_id
INNER JOIN doctors AS d
    ON a.doctor_id = d.doctor_id;


--List all billing records with patient name, treatment type, and doctor specialization.

SELECT 
    b.bill_id,
	b.bill_date,
	b.payment_method,
    p.first_name AS patient_first_name,
	p.last_name AS patient_last_name,
	t.treatment_type,
	d.specialization AS doctors_specialization
FROM billing AS b
INNER JOIN treatments AS t
    ON b.treatment_id = t.treatment_id
INNER JOIN appointments AS a
    ON t.appointment_id = a.appointment_id
INNER JOIN patients AS p
    ON b.patient_id = p.patient_id      
INNER JOIN doctors AS d
    ON a.doctor_id = d.doctor_id;


--Find all appointments along with the billing amount  and treatment type.

SELECT 
    a.appointment_id,
	a.appointment_date,
	a.appointment_time,
	t.treatment_type,
	b.amount
FROM appointments AS a
INNER JOIN treatments AS t
    ON t.appointment_id = a.appointment_id
INNER JOIN billing AS b
    ON b.treatment_id = t.treatment_id;


--Show all doctors and the total number of appointments they have handled.

SELECT 
    d.doctor_id,
	d.first_name AS doctor_first_name,
	d.last_name AS doctor_last_name,
COUNT (a.appointment_id) AS total_appointments
FROM doctors AS d
INNER JOIN appointments AS a
    ON a.doctor_id = d. doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name;


--Find all patients and total amount they have spent on treatments.

SELECT 
    p.patient_id,
    p.first_name,
    p.last_name,
    SUM(b.amount) AS total_spent
FROM patients AS p
INNER JOIN billing AS b
    ON p.patient_id = b.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name;


--List all patients along with the total billing amount they have spent, including those who have never been billed (show their total as 0).

SELECT 
    p.patient_id,
	p.first_name AS patient_first_name,
	p.last_name AS patient_last_name,
	COALESCE(SUM(b.amount),0) AS total_spent
FROM patients AS p
LEFT JOIN billing AS B
   ON b.patient_id = p.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name;


--Find all doctors who are in the system but have never handled any appointment.

SELECT 
    d.doctor_id,
	d.first_name AS doctor_first_name,
	d.last_name AS doctor_last_name,
	a.appointment_id
FROM doctors AS d
LEFT JOIN appointments AS a
   ON a.doctor_id = d.doctor_id
  WHERE appointment_id IS NULL
	
	
--Retrieve all patients who registered at the hospital but never booked an appointment.

SELECT
    p.patient_id,
	p.first_name AS patient_first_name,
	p.last_name AS patient_last_name,
	a.appointment_id
FROM patients AS p
LEFT JOIN appointments AS a
   ON a.patient_id = p.patient_id
  WHERE appointment_id IS NULL


--Find mismatches between appointments and treatments  i.e., list appointments that never had a treatment and treatments that are not linked to any appointment

SELECT
    a.appointment_id,
	a.patient_id,
    a.doctor_id,
    t.treatment_id
FROM appointments AS a
LEFT JOIN treatments AS t
    ON a.appointment_id = t.appointment_id
WHERE t.treatment_id IS NULL
UNION
SELECT 
    a.appointment_id,
    a.patient_id,
    a.doctor_id,
    t.treatment_id
FROM treatments AS t
LEFT JOIN appointments AS a
    ON t.appointment_id = a.appointment_id
WHERE a.appointment_id IS NULL;


--Find patients whose billing amount is greater than the average billing amount.

SELECT patient_id,amount
FROM billing
WHERE amount > (SELECT AVG(amount) FROM billing);


--Find all patients who have the same gender as the most recently added patient.

SELECT * FROM patients
WHERE GENDER = (SELECT gender
    FROM patients
    ORDER BY patient_id DESC
    LIMIT 1
);


--Find patients who have appointments after the latest appointment date.

SELECT 
    patient_id,
	appointment_id,
	appointment_date
FROM appointments
WHERE appointment_date = (SELECT MAX (appointment_date)
     FROM appointments
);


--Retrieve treatments whose cost is higher than the average cost for that treatment type

SELECT 
    t.treatment_id,
	t.treatment_type,
	t.cost 
FROM treatments AS t
WHERE t.cost > (
    SELECT AVG(t2.cost)
    FROM treatments AS t2
    WHERE t2.treatment_type = t.treatment_type
);


--Find patients who have spent more than the average billing amount.

SELECT patient_id, SUM(amount) AS total_spent
FROM billing
GROUP BY patient_id
HAVING SUM(amount) > (
    SELECT AVG(total_amount)
    FROM (
        SELECT SUM(amount) AS total_amount
        FROM billing
        GROUP BY patient_id
    ) AS subquery
);


--List doctors who have handled more appointments than the average number of appointments per doctor.

SELECT 
    d.doctor_id,
    d.first_name,
    d.last_name,
    COUNT(a.appointment_id) AS total_appointments
FROM doctors AS d
INNER JOIN appointments AS a
    ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name
HAVING COUNT(a.appointment_id) > (
    SELECT AVG(doctor_appointments) 
    FROM (
        SELECT COUNT(*) AS doctor_appointments
        FROM appointments
        GROUP BY doctor_id
    ) AS sub
);


--For each patient, list their appointments and the running total of amount spent across all their visits

SELECT 
    a.patient_id, 
	a.appointment_id,
    a.appointment_date,
	b.amount,
SUM(b.amount) OVER (
      PARTITION BY a.patient_id
      ORDER BY a.appointment_date
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS runnimg_total
FROM appointments AS a
INNER JOIN billing AS b
ON a.patient_id = b.patient_id


--Rank treatments by cost, with the highest cost ranked 1.

SELECT 
    treatment_id,
	treatment_type,
	cost,
RANK() OVER(ORDER BY cost DESC) AS rank_treatment
FROM treatments;


--Assign a unique number to each appointment in order of date.

SELECT 
    appointment_id,
	appointment_date,
	patient_id,
ROW_NUMBER() OVER(ORDER BY appointment_date) AS row_num
FROM appointments;


--Rank all patients based on the total amount they’ve spent, with the highest spender ranked 1.

SELECT 
     p.patient_id,
	 p.first_name,
	 p.last_name,
	 SUM(b.amount) AS total_spent,
RANK() OVER(ORDER BY SUM(b.amount)DESC) AS patient_rank
FROM patients AS p
INNER JOIN billing AS b
ON b.patient_id = p.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name;
