-- Tạo cơ sở dữ liệu HealthSync
DROP DATABASE IF EXISTS HealthSync;
CREATE DATABASE HealthSync;
USE HealthSync;

-- Bảng Patient
CREATE TABLE Patient (
    PatientID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    DOB DATE NOT NULL,
    Gender VARCHAR(10),
    Address VARCHAR(200),
    Phone VARCHAR(20)
);

-- Bảng Doctor
CREATE TABLE Doctor (
    DoctorID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Specialty VARCHAR(50),
    Phone VARCHAR(20)
);

-- Bảng Appointment
CREATE TABLE Appointment (
    AppointmentID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDate DATETIME NOT NULL,
    Status VARCHAR(20) DEFAULT 'Scheduled',
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID)
);

-- Bảng MedicalRecord
CREATE TABLE MedicalRecord (
    RecordID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    Diagnosis VARCHAR(200),
    Treatment VARCHAR(200),
    RecordDate DATETIME NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID)
);
