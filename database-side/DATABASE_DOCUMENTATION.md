# GS KAYUMBU SCHOOL - DATABASE DOCUMENTATION

## Overview
This document explains each database table, what data it stores, and which pages/features use it.

---

## 1. USERS TABLE
**Purpose:** Store student and staff account credentials

### What It Stores:
```
user_id          → Unique identifier for each user
full_name        → User's complete name
email            → Email address (used for login)
password         → Encrypted password
role             → Type of user (student, staff, admin)
created_at       → When account was created
updated_at       → When account was last updated
is_active        → Whether account is active or disabled
```

### Data Example:
```
user_id | full_name      | email                    | role    | is_active
--------|----------------|--------------------------|---------|----------
1       | John Doe       | john@example.com         | student | TRUE
2       | Jane Smith     | jane@example.com         | student | TRUE
3       | Mr. Johnson    | johnson@example.com      | staff   | TRUE
```

### Which Pages Use It:
- ✅ **student-sign-up.html** → Creates new user account
- ✅ **student-sign-in.html** → Validates login credentials
- ✅ **staff-sign-up.html** → Creates staff account
- ✅ **staff-sign-in.html** → Validates staff login
- ✅ **Dashboard** → Identifies logged-in user

### Database Operations:
```sql
-- Sign-up: Insert new user
INSERT INTO users (full_name, email, password, role) 
VALUES ('John Doe', 'john@example.com', 'hashed_password', 'student');

-- Sign-in: Verify credentials
SELECT * FROM users WHERE email = 'john@example.com' AND password = 'hashed_password';

-- Update profile
UPDATE users SET full_name = 'John Smith' WHERE user_id = 1;
```

---

## 2. STUDENTS_ORDINARY TABLE
**Purpose:** Store O-Level student enrollment data

### What It Stores:
```
student_id       → Unique identifier for O-Level student
user_id          → Links to users table (which user this is)
first_name       → Student's first name
last_name        → Student's last name
date_of_birth    → Student's birth date
national_id      → National ID number
student_phone    → Student's phone number
level_applying   → Grade level (Senior 1, 2, or 3)
level_leaving    → Previous grade completed
district         → District of residence
sector           → Sector of residence
cell             → Cell/village of residence
enrollment_date  → When student enrolled
status           → Enrollment status (pending, approved, rejected)
```

### Data Example:
```
student_id | user_id | first_name | last_name | level_applying | status
-----------|---------|------------|-----------|----------------|----------
1          | 1       | John       | Doe       | Senior 1       | approved
2          | 2       | Jane       | Smith     | Senior 2       | pending
```

### Which Pages Use It:
- ✅ **Registration1.html** (O-Level) → Collects and stores enrollment data
- ✅ **studentDashboard/profile.html** → Displays student profile
- ✅ **staffPortal/LeaderHome.html** → Staff views student records
- ✅ **studentDashboard/dashboard.html** → Shows student info

### Database Operations:
```sql
-- Enrollment: Insert O-Level student data
INSERT INTO students_ordinary 
(user_id, first_name, last_name, date_of_birth, level_applying, district, sector, cell, status)
VALUES (1, 'John', 'Doe', '2008-05-15', 'Senior 1', 'Kigali', 'Gasabo', 'Gisozi', 'pending');

-- View student profile
SELECT * FROM students_ordinary WHERE user_id = 1;

-- Update enrollment status
UPDATE students_ordinary SET status = 'approved' WHERE student_id = 1;
```

---

## 3. STUDENTS_ADVANCED TABLE
**Purpose:** Store A-Level student enrollment data

### What It Stores:
```
student_id       → Unique identifier for A-Level student
user_id          → Links to users table
first_name       → Student's first name
last_name        → Student's last name
date_of_birth    → Student's birth date
national_id      → National ID number
student_phone    → Student's phone number
combination      → Subject combination (FAD, BDC, MCE)
level_applying   → Grade level (S4, S5, or S6)
district         → District of residence
sector           → Sector of residence
cell             → Cell/village of residence
enrollment_date  → When student enrolled
status           → Enrollment status (pending, approved, rejected)
```

### Data Example:
```
student_id | user_id | first_name | combination | level_applying | status
-----------|---------|------------|-------------|----------------|----------
1          | 3       | Alice      | FAD         | S4             | approved
2          | 4       | Bob        | MCE         | S5             | pending
```

### Which Pages Use It:
- ✅ **registration2.html** (A-Level) → Collects and stores A-Level enrollment
- ✅ **studentDashboard/profile.html** → Displays A-Level student profile
- ✅ **staffPortal/LeaderHome.html** → Staff views A-Level records
- ✅ **studentDashboard/dashboard.html** → Shows A-Level student info

### Database Operations:
```sql
-- Enrollment: Insert A-Level student data
INSERT INTO students_advanced 
(user_id, first_name, last_name, combination, level_applying, district, status)
VALUES (3, 'Alice', 'Johnson', 'FAD', 'S4', 'Kigali', 'pending');

-- View A-Level students by combination
SELECT * FROM students_advanced WHERE combination = 'MCE';

-- Count students per combination
SELECT combination, COUNT(*) FROM students_advanced GROUP BY combination;
```

---

## 4. GUARDIANS TABLE
**Purpose:** Store parent/guardian contact information

### What It Stores:
```
guardian_id      → Unique identifier for guardian
student_id       → Links to student (which student's guardian)
level_type       → Whether ordinary or advanced level
guardian_name    → Guardian's full name
guardian_email   → Guardian's email address
guardian_phone   → Guardian's phone number
guardian_national_id → Guardian's national ID
guardian_district → Guardian's district
guardian_sector  → Guardian's sector
guardian_cell    → Guardian's cell/village
created_at       → When record was created
```

### Data Example:
```
guardian_id | student_id | level_type | guardian_name    | guardian_phone
------------|------------|------------|------------------|----------------
1           | 1          | ordinary   | Mr. Doe          | +250788123456
2           | 2          | advanced   | Mrs. Johnson     | +250788654321
```

### Which Pages Use It:
- ✅ **Registration1.html** (O-Level) → Collects guardian info
- ✅ **registration2.html** (A-Level) → Collects guardian info
- ✅ **staffPortal/LeaderHome.html** → Staff views guardian contact
- ✅ **studentDashboard/profile.html** → Shows guardian info

### Database Operations:
```sql
-- Insert guardian information
INSERT INTO guardians 
(student_id, level_type, guardian_name, guardian_phone, guardian_national_id, guardian_district)
VALUES (1, 'ordinary', 'Mr. Doe', '+250788123456', '1234567890123', 'Kigali');

-- Get guardian contact for student
SELECT * FROM guardians WHERE student_id = 1;

-- Contact all guardians for event notification
SELECT guardian_phone FROM guardians WHERE level_type = 'ordinary';
```

---

## 5. DOCUMENTS TABLE
**Purpose:** Store file paths for uploaded student documents

### What It Stores:
```
document_id      → Unique identifier for document record
student_id       → Links to student
level_type       → Whether ordinary or advanced
photo_path       → Path to passport photo file
result_slip_path → Path to result slip/certificate
national_id_copy_path → Path to national ID copy
s3_result_slip_path → Path to S3 result slip (A-Level only)
uploaded_at      → When documents were uploaded
```

### Data Example:
```
document_id | student_id | photo_path              | result_slip_path
------------|------------|-------------------------|---------------------------
1           | 1          | /uploads/student1_photo.jpg | /uploads/student1_results.pdf
2           | 2          | /uploads/student2_photo.jpg | /uploads/student2_results.pdf
```

### Which Pages Use It:
- ✅ **Registration1.html** (O-Level) → Uploads documents
- ✅ **registration2.html** (A-Level) → Uploads documents
- ✅ **staffPortal/LeaderHome.html** → Staff views uploaded documents
- ✅ **studentDashboard/profile.html** → Student views their documents

### Database Operations:
```sql
-- Store uploaded document paths
INSERT INTO documents 
(student_id, level_type, photo_path, result_slip_path)
VALUES (1, 'ordinary', '/uploads/john_photo.jpg', '/uploads/john_results.pdf');

-- Retrieve student documents
SELECT * FROM documents WHERE student_id = 1;

-- Check if all required documents uploaded
SELECT * FROM documents WHERE photo_path IS NOT NULL AND result_slip_path IS NOT NULL;
```

---

## 6. PAYMENTS TABLE
**Purpose:** Track student enrollment payment records

### What It Stores:
```
payment_id       → Unique identifier for payment
student_id       → Links to student
level_type       → Whether ordinary or advanced
amount           → Payment amount (in RWF)
payment_method   → How paid (mobile_money, bank_transfer, cash)
transaction_reference → Payment confirmation number
payment_status   → Status (pending, completed, failed)
payment_date     → When payment was made
```

### Data Example:
```
payment_id | student_id | amount  | payment_method | payment_status | payment_date
-----------|------------|---------|----------------|----------------|------------------
1          | 1          | 50000   | mobile_money   | completed      | 2024-01-15
2          | 2          | 50000   | bank_transfer  | pending        | 2024-01-16
```

### Which Pages Use It:
- ✅ **Registration1.html** (Payment Tab) → Records O-Level payment
- ✅ **registration2.html** (Payment Tab) → Records A-Level payment
- ✅ **studentDashboard/payment.html** → Shows payment status
- ✅ **staffPortal/LeaderHome.html** → Staff tracks payments
- ✅ **studentDashboard/dashboard.html** → Shows payment status

### Database Operations:
```sql
-- Record payment
INSERT INTO payments 
(student_id, level_type, amount, payment_method, transaction_reference, payment_status)
VALUES (1, 'ordinary', 50000, 'mobile_money', 'MTN123456', 'completed');

-- Check pending payments
SELECT * FROM payments WHERE payment_status = 'pending';

-- Get payment history for student
SELECT * FROM payments WHERE student_id = 1 ORDER BY payment_date DESC;

-- Calculate total revenue
SELECT SUM(amount) FROM payments WHERE payment_status = 'completed';
```

---

## 7. GRADES TABLE
**Purpose:** Store student academic grades and scores

### What It Stores:
```
grade_id         → Unique identifier for grade record
user_id          → Links to user (which student)
subject          → Subject name (Math, English, Science, etc.)
score            → Numerical score (0-100)
grade            → Letter grade (A, B, C, D, F)
term             → Term (Term 1, Term 2, Term 3)
academic_year    → School year (2024, 2025, etc.)
recorded_at      → When grade was recorded
```

### Data Example:
```
grade_id | user_id | subject | score | grade | term   | academic_year
---------|---------|---------|-------|-------|--------|---------------
1        | 1       | Math    | 85    | A     | Term 1 | 2024
2        | 1       | English | 78    | B     | Term 1 | 2024
3        | 1       | Science | 92    | A     | Term 1 | 2024
```

### Which Pages Use It:
- ✅ **studentDashboard/grade.html** → Displays student grades
- ✅ **studentDashboard/dashboard.html** → Shows grade summary
- ✅ **staffPortal/LeaderHome.html** → Staff enters and views grades
- ✅ **studentDashboard/profile.html** → Shows academic performance

### Database Operations:
```sql
-- Record student grade
INSERT INTO grades (user_id, subject, score, grade, term, academic_year)
VALUES (1, 'Math', 85, 'A', 'Term 1', 2024);

-- Get all grades for student
SELECT * FROM grades WHERE user_id = 1 ORDER BY academic_year DESC, term;

-- Calculate average score
SELECT AVG(score) FROM grades WHERE user_id = 1 AND academic_year = 2024;

-- Get grades by subject
SELECT subject, AVG(score) FROM grades WHERE academic_year = 2024 GROUP BY subject;
```

---

## 8. NOTIFICATIONS TABLE
**Purpose:** Store messages and notifications for students

### What It Stores:
```
notification_id  → Unique identifier for notification
user_id          → Links to user (which student receives it)
title            → Notification title
message          → Notification content
notification_type → Type (info, warning, success, error)
is_read          → Whether student has read it
created_at       → When notification was created
```

### Data Example:
```
notification_id | user_id | title                    | notification_type | is_read
----------------|---------|--------------------------|-------------------|--------
1               | 1       | Payment Received         | success           | TRUE
2               | 1       | Grades Posted            | info              | FALSE
3               | 2       | Payment Pending          | warning           | TRUE
```

### Which Pages Use It:
- ✅ **studentDashboard/notification.html** → Displays all notifications
- ✅ **studentDashboard/dashboard.html** → Shows notification count
- ✅ **staffPortal/LeaderHome.html** → Staff sends notifications
- ✅ **studentPortal/studentPortal.html** → Shows notification badge

### Database Operations:
```sql
-- Send notification to student
INSERT INTO notifications (user_id, title, message, notification_type)
VALUES (1, 'Payment Received', 'Your enrollment payment has been confirmed', 'success');

-- Get unread notifications
SELECT * FROM notifications WHERE user_id = 1 AND is_read = FALSE;

-- Mark notification as read
UPDATE notifications SET is_read = TRUE WHERE notification_id = 1;

-- Get all notifications for student
SELECT * FROM notifications WHERE user_id = 1 ORDER BY created_at DESC;
```

---

## 9. STAFF TABLE
**Purpose:** Store staff member information

### What It Stores:
```
staff_id         → Unique identifier for staff
user_id          → Links to users table
first_name       → Staff first name
last_name        → Staff last name
position         → Job title (Teacher, Admin, Registrar, etc.)
department       → Department (Academic, Admin, Finance, etc.)
phone            → Staff phone number
hire_date        → When staff was hired
created_at       → When record was created
```

### Data Example:
```
staff_id | user_id | first_name | last_name | position    | department
---------|---------|------------|-----------|-------------|----------
1        | 3       | Mr.        | Johnson   | Registrar   | Admin
2        | 4       | Mrs.       | Smith     | Teacher     | Academic
```

### Which Pages Use It:
- ✅ **staff-sign-up.html** → Creates staff account
- ✅ **staffPortal/LeaderHome.html** → Staff dashboard
- ✅ **staffPortal/** → All staff portal pages

### Database Operations:
```sql
-- Create staff account
INSERT INTO staff (user_id, first_name, last_name, position, department, hire_date)
VALUES (3, 'Mr.', 'Johnson', 'Registrar', 'Admin', '2023-01-15');

-- Get all staff in department
SELECT * FROM staff WHERE department = 'Academic';

-- Get staff contact info
SELECT first_name, last_name, phone FROM staff WHERE position = 'Registrar';
```

---

## TABLE RELATIONSHIPS (How They Connect)

```
users (Main Table)
  ├── 1 user → many students_ordinary
  ├── 1 user → many students_advanced
  ├── 1 user → many grades
  ├── 1 user → many notifications
  └── 1 user → 1 staff

students_ordinary
  ├── 1 student → 1 guardian
  ├── 1 student → 1 documents
  └── 1 student → many payments

students_advanced
  ├── 1 student → 1 guardian
  ├── 1 student → 1 documents
  └── 1 student → many payments
```

---

## DATA FLOW THROUGH PAGES

### Student Sign-Up Flow:
```
1. student-sign-up.html
   ↓ (Collects: full_name, email, password)
   ↓
2. INSERT INTO users table
   ↓
3. User account created ✅
   ↓
4. Redirect to studentPortal.html
```

### Student Enrollment Flow (O-Level):
```
1. Registration1.html (O-Level)
   ↓ (Collects: student info, guardian info, documents)
   ↓
2. INSERT INTO students_ordinary table
3. INSERT INTO guardians table
4. INSERT INTO documents table
   ↓
5. Redirect to Payment Tab
   ↓
6. INSERT INTO payments table
   ↓
7. Enrollment complete ✅
```

### Student Dashboard Flow:
```
1. studentDashboard/dashboard.html
   ↓
2. SELECT from users (get user info)
3. SELECT from students_ordinary/advanced (get enrollment)
4. SELECT from grades (get academic records)
5. SELECT from payments (get payment status)
6. SELECT from notifications (get messages)
   ↓
7. Display all info to student ✅
```

### Staff Management Flow:
```
1. staffPortal/LeaderHome.html
   ↓
2. SELECT from students_ordinary/advanced (view enrollments)
3. SELECT from payments (track payments)
4. SELECT from grades (manage grades)
5. INSERT INTO notifications (send messages)
   ↓
6. Staff manages school operations ✅
```

---

## SUMMARY TABLE

| Table | Purpose | Main Data | Used By |
|-------|---------|-----------|---------|
| **users** | Account credentials | Email, password, role | Sign-up, Sign-in, Dashboard |
| **students_ordinary** | O-Level enrollment | Name, DOB, level, location | Registration1.html, Profile |
| **students_advanced** | A-Level enrollment | Name, DOB, combination, level | registration2.html, Profile |
| **guardians** | Parent contact | Name, phone, ID, location | Registration forms, Staff |
| **documents** | Uploaded files | Photo, results, ID copies | Registration, Staff, Profile |
| **payments** | Payment tracking | Amount, method, status | Payment tab, Dashboard |
| **grades** | Academic records | Subject, score, grade, term | Grade page, Dashboard |
| **notifications** | Student messages | Title, message, type | Notification page, Dashboard |
| **staff** | Staff information | Name, position, department | Staff portal, Admin |

---

## Key Points to Remember

✅ **users** = Login credentials (created at sign-up)
✅ **students_ordinary/advanced** = Enrollment data (created at registration)
✅ **guardians** = Parent contact info (created at registration)
✅ **documents** = File uploads (created at registration)
✅ **payments** = Payment records (created at payment)
✅ **grades** = Academic records (created by staff)
✅ **notifications** = Messages (created by system/staff)
✅ **staff** = Staff accounts (created at staff sign-up)

Each table serves a specific purpose and connects to pages that need that data!
