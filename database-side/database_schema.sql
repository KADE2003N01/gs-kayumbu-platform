-- GS KAYUMBU SCHOOL DATABASE SCHEMA
-- Database for Student Portal System

-- Create Database
CREATE DATABASE IF NOT EXISTS gs_kayumbu_school;
USE gs_kayumbu_school;

-- ============================================
-- USERS TABLE (Sign-up Data)
-- ============================================
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('student', 'staff', 'admin') NOT NULL DEFAULT 'student',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    INDEX idx_email (email),
    INDEX idx_role (role)
);

-- ============================================
-- STUDENTS TABLE (Enrollment Data - O-Level)
-- ============================================
CREATE TABLE IF NOT EXISTS students_ordinary (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    national_id VARCHAR(50),
    student_phone VARCHAR(20),
    level_applying VARCHAR(50) NOT NULL,
    level_leaving VARCHAR(50),
    district VARCHAR(100) NOT NULL,
    sector VARCHAR(100) NOT NULL,
    cell VARCHAR(100) NOT NULL,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_status (status)
);

-- ============================================
-- STUDENTS TABLE (Enrollment Data - Advanced)
-- ============================================
CREATE TABLE IF NOT EXISTS students_advanced (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    national_id VARCHAR(50),
    student_phone VARCHAR(20),
    combination VARCHAR(50) NOT NULL,
    level_applying VARCHAR(50) NOT NULL,
    district VARCHAR(100) NOT NULL,
    sector VARCHAR(100) NOT NULL,
    cell VARCHAR(100) NOT NULL,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_status (status)
);

-- ============================================
-- GUARDIANS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS guardians (
    guardian_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    level_type ENUM('ordinary', 'advanced') NOT NULL,
    guardian_name VARCHAR(100) NOT NULL,
    guardian_email VARCHAR(100),
    guardian_phone VARCHAR(20) NOT NULL,
    guardian_national_id VARCHAR(50) NOT NULL,
    guardian_district VARCHAR(100) NOT NULL,
    guardian_sector VARCHAR(100) NOT NULL,
    guardian_cell VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students_ordinary(student_id) ON DELETE CASCADE,
    INDEX idx_student_id (student_id)
);

-- ============================================
-- DOCUMENTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS documents (
    document_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    level_type ENUM('ordinary', 'advanced') NOT NULL,
    photo_path VARCHAR(255),
    result_slip_path VARCHAR(255),
    national_id_copy_path VARCHAR(255),
    s3_result_slip_path VARCHAR(255),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students_ordinary(student_id) ON DELETE CASCADE,
    INDEX idx_student_id (student_id)
);

-- ============================================
-- PAYMENTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    level_type ENUM('ordinary', 'advanced') NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method ENUM('mobile_money', 'bank_transfer', 'cash') NOT NULL,
    transaction_reference VARCHAR(100),
    payment_status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students_ordinary(student_id) ON DELETE CASCADE,
    INDEX idx_student_id (student_id),
    INDEX idx_payment_status (payment_status)
);

-- ============================================
-- GRADES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    subject VARCHAR(100) NOT NULL,
    score DECIMAL(5, 2),
    grade CHAR(1),
    term VARCHAR(20),
    academic_year VARCHAR(10),
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_academic_year (academic_year)
);

-- ============================================
-- NOTIFICATIONS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    notification_type ENUM('info', 'warning', 'success', 'error') DEFAULT 'info',
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_is_read (is_read)
);

-- ============================================
-- STAFF TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    position VARCHAR(100) NOT NULL,
    department VARCHAR(100),
    phone VARCHAR(20),
    hire_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id)
);

-- ============================================
-- INDEXES FOR PERFORMANCE
-- ============================================
CREATE INDEX idx_users_email_role ON users(email, role);
CREATE INDEX idx_students_ordinary_user ON students_ordinary(user_id);
CREATE INDEX idx_students_advanced_user ON students_advanced(user_id);
CREATE INDEX idx_guardians_student ON guardians(student_id);
CREATE INDEX idx_documents_student ON documents(student_id);
CREATE INDEX idx_payments_student ON payments(student_id);
CREATE INDEX idx_grades_user ON grades(user_id);
CREATE INDEX idx_notifications_user ON notifications(user_id);
