-- healthsync_db.sql (optimized)
CREATE DATABASE healthsync_db;
USE healthsync_db;

-- Patients
CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL
);

-- Doctors
CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(50)
);

-- Appointments (reworked)
CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status ENUM('PENDING','CONFIRMED','CHECKED_IN','COMPLETED','CANCELLED') NOT NULL DEFAULT 'PENDING',
    deposit_amount DECIMAL(12,2) DEFAULT 0.00,
    penalty_fee DECIMAL(12,2) DEFAULT 0.00,
    cancel_reason VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- Prescriptions (new)
CREATE TABLE Prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    medication_details TEXT NOT NULL,
    issued_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

-- Optional: ensure one prescription per appointment if desired (enforce at app level or via unique constraint)
-- ALTER TABLE Prescriptions ADD UNIQUE (appointment_id);

-- Trigger to prevent inserting a prescription for non-COMPLETED appointments
DELIMITER $$
CREATE TRIGGER trg_prescription_before_insert
BEFORE INSERT ON Prescriptions
FOR EACH ROW
BEGIN
    DECLARE appt_status ENUM('PENDING','CONFIRMED','CHECKED_IN','COMPLETED','CANCELLED');
    SELECT status INTO appt_status FROM Appointments WHERE appointment_id = NEW.appointment_id;
    IF appt_status IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Appointment not found';
    ELSEIF appt_status <> 'COMPLETED' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot add prescription: appointment not completed';
    END IF;
END$$
DELIMITER ;

-- DML: Kịch bản 1 (Thành công)
INSERT INTO Patients (full_name, phone) VALUES ('Nguyen A', '0123456789');
INSERT INTO Doctors (full_name, specialty) VALUES ('Dr. Tran', 'General');
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status, deposit_amount)
VALUES (1, 1, '2026-10-11 09:00:00', 'PENDING', 500000.00);

-- Update flow: PENDING -> CHECKED_IN -> COMPLETED -> add prescription
UPDATE Appointments SET status = 'CHECKED_IN' WHERE appointment_id = 1;
UPDATE Appointments SET status = 'COMPLETED' WHERE appointment_id = 1;
INSERT INTO Prescriptions (appointment_id, medication_details) VALUES (1, 'Paracetamol 500mg, 3 times/day');

-- DML: Kịch bản 2 (Hủy và Phạt)
INSERT INTO Patients (full_name, phone) VALUES ('Le B', '0987654321');
INSERT INTO Doctors (full_name, specialty) VALUES ('Dr. Mai', 'ENT');
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status, deposit_amount)
VALUES (2, 2, '2026-10-12 10:00:00', 'CONFIRMED', 300000.00);

-- Cancel with reason and penalty
UPDATE Appointments
SET status = 'CANCELLED',
    cancel_reason = 'Bận việc đột xuất',
    penalty_fee = 150000.00
WHERE appointment_id = 2;

-- Verification queries
-- 1) All completed appointments with prescriptions
SELECT a.appointment_id, p.full_name AS patient, d.full_name AS doctor, a.status, pr.medication_details
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
LEFT JOIN Prescriptions pr ON pr.appointment_id = a.appointment_id
WHERE a.status = 'COMPLETED';

-- 2) Cancellations with penalty
SELECT appointment_id, patient_id, deposit_amount, penalty_fee, cancel_reason
FROM Appointments
WHERE status = 'CANCELLED';
