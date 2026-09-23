CREATE DATABASE IF NOT EXISTS aui_clubs;
USE aui_clubs;

-- ==========================================
-- 1. STUDENT
-- ==========================================
CREATE TABLE Student (
    student_id INT PRIMARY KEY,     -- custom 6-digit IDs starting with 14/15/16/17
    first_name VARCHAR(50) NOT NULL CHECK (first_name <> ''),
    last_name VARCHAR(50) NOT NULL CHECK (last_name <> ''),
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    major VARCHAR(50),
    class_level VARCHAR(20) DEFAULT 'Freshman'
        CHECK (class_level IN ('Freshman','Sophomore','Junior','Senior'))
);

-- ==========================================
-- 2. CLUB
-- ==========================================
CREATE TABLE Club (
    club_id INT PRIMARY KEY AUTO_INCREMENT,
    club_name VARCHAR(100) NOT NULL CHECK (club_name <> ''),
    description TEXT,
    creation_date DATE DEFAULT (CURRENT_DATE),
    category VARCHAR(50) DEFAULT 'Academic'
        CHECK (category IN ('Academic','Cultural','Sports','Professional','Other')),
    status VARCHAR(20) DEFAULT 'Active'
        CHECK (status IN ('Active','Inactive'))
);

-- ==========================================
-- 3. MEMBERSHIP
-- ==========================================
CREATE TABLE Membership (
    membership_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    club_id INT,
    role VARCHAR(50) DEFAULT 'Member'
        CHECK (role IN ('Member','Treasurer','Vice President','Secretary','President')),
    join_date DATE ,
    leave_date DATE,
    CONSTRAINT is_member_of_student
    FOREIGN KEY (student_id) REFERENCES Student(student_id)
    ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT is_member_of_club
    FOREIGN KEY (club_id) REFERENCES Club(club_id)
    ON UPDATE CASCADE ON DELETE CASCADE

);


-- ==========================================
-- 4. EVENT
-- ==========================================
CREATE TABLE Event (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    club_id INT,
    event_name VARCHAR(100) NOT NULL CHECK (event_name <> ''),
    description TEXT,
    event_date DATE NOT NULL,
    event_type VARCHAR(50) DEFAULT 'Meeting'
        CHECK (event_type IN ('Workshop','Competition','Meeting','Conference','Sports')),
    location VARCHAR(100) DEFAULT 'AUI Campus',
    budget_used DECIMAL(10,2) DEFAULT 0 CHECK (budget_used >= 0),
    CONSTRAINT organises
    FOREIGN KEY (club_id) REFERENCES Club(club_id)
    ON UPDATE CASCADE ON DELETE CASCADE

);

-- ==========================================
-- 5. PARTICIPATION
-- ==========================================
CREATE TABLE Participation (
    participation_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    event_id INT,
    attendance_status VARCHAR(20) DEFAULT 'Absent'
        CHECK (attendance_status IN ('Present','Absent')),
    check_in_time DATETIME NULL,
    CONSTRAINT participates_in_student
    FOREIGN KEY (student_id) REFERENCES Student(student_id)
    ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT participates_in_event
    FOREIGN KEY (event_id) REFERENCES Event(event_id)
    ON UPDATE CASCADE ON DELETE CASCADE

);

-- ==========================================
-- 6. SPONSOR
-- ==========================================
CREATE TABLE Sponsor (
    sponsor_id INT PRIMARY KEY AUTO_INCREMENT,
    sponsor_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100),
    phone VARCHAR(20),
    sponsor_type VARCHAR(50) DEFAULT 'Company',
    club_id INT,

    CONSTRAINT is_sponsored_by_club
        FOREIGN KEY (club_id) REFERENCES Club(club_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);


-- ==========================================
-- 7. BUDGET
-- ==========================================
CREATE TABLE Budget (
    budget_id INT PRIMARY KEY AUTO_INCREMENT,
    club_id INT UNIQUE,
    total_allocated DECIMAL(10,2) DEFAULT 0 CHECK (total_allocated >= 0),
    total_spent DECIMAL(10,2) DEFAULT 0 CHECK (total_spent >= 0),
    remaining_balance DECIMAL(10,2) GENERATED ALWAYS AS (total_allocated - total_spent) STORED,
    last_updated DATE,
    CONSTRAINT has_budget
    FOREIGN KEY (club_id) REFERENCES Club(club_id)
    ON UPDATE CASCADE ON DELETE CASCADE

);

-- ==========================================
-- 8. ROOM RESERVATION
-- ==========================================
CREATE TABLE RoomReservation (
    reservation_id INT PRIMARY KEY AUTO_INCREMENT,
    club_id INT,
    event_id INT NULL,
    room_number VARCHAR(20) NOT NULL CHECK (room_number <> ''),
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    CONSTRAINT reserves_room
    FOREIGN KEY (club_id) REFERENCES Club(club_id)
    ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT assigned_to_event
    FOREIGN KEY (event_id) REFERENCES Event(event_id)
    ON UPDATE CASCADE ON DELETE SET NULL

);

-- ==========================================
-- INSERT SAMPLE DATA
-- ==========================================

-- STUDENTS (6-digit random IDs starting with 14/15/16/17)
INSERT INTO Student (student_id, first_name, last_name, email, phone, major, class_level) VALUES
(145783, 'Amina', 'Bennani', 'a.bennani@aui.ma', '0612345678', 'Computer Science', 'Sophomore'),
(157492, 'Youssef', 'Elidrissi', 'y.elidrissi@aui.ma', '0623456789', 'Business', 'Junior'),
(169204, 'Sara', 'Elhajj', 's.elhajj@aui.ma', '0634567890', 'Engineering', 'Freshman'),
(176581, 'Omar', 'Fassi', 'o.fassi@aui.ma', '0645678901', 'Computer Science', 'Senior');

-- CLUBS
INSERT INTO Club (club_name, description, creation_date, category, status) VALUES
('AUI Coding Club', 'Promotes programming skills and hackathons.', '2015-09-01', 'Academic', 'Active'),
('AUI Sports Club', 'Organizes sports competitions and training.', '2010-02-15', 'Sports', 'Active'),
('AUI Music Club', 'Encourages music activities and jam sessions.', '2018-03-10', 'Cultural', 'Inactive');

-- MEMBERSHIP
INSERT INTO Membership (student_id, club_id, role, join_date) VALUES
(145783, 1, 'Member', '2023-02-01'),
(157492, 1, 'Treasurer', '2022-10-10'),
(169204, 2, 'Member', '2023-03-04'),
(176581, 1, 'President', '2022-09-01'),
(145783, 2, 'Member', '2023-05-22');

-- EVENTS
INSERT INTO Event (club_id, event_name, description, event_date, event_type, location, budget_used) VALUES
(1, 'Hackathon 2024', '24-hour coding competition', '2024-11-10', 'Competition', 'B7 Lab', 1500.00),
(2, 'Football Tournament', 'Sports day event', '2024-10-05', 'Sports', 'AUI Stadium', 800.00),
(1, 'Python Workshop', 'Beginner-friendly Python training', '2024-09-15', 'Workshop', 'B5-113', 200.00);

-- PARTICIPATION
INSERT INTO Participation (student_id, event_id, attendance_status, check_in_time) VALUES
(145783, 1, 'Present', '2024-11-10 09:00:00'),
(157492, 1, 'Absent', NULL),
(176581, 1, 'Present', '2024-11-10 09:15:00'),
(169204, 2, 'Present', '2024-10-05 08:45:00');

-- SPONSOR
INSERT INTO Sponsor (sponsor_name, contact_email, phone, sponsor_type) VALUES
('OCP Group', 'contact@ocp.ma', '0522334455', 'Company'),
('Inwi', 'support@inwi.ma', '0522445566', 'Company'),
('Karim A.', 'karim.a@gmail.com', '0611223344', 'Individual');

-- BUDGET
INSERT INTO Budget (club_id, total_allocated, total_spent) VALUES
(1, 5000.00, 1700.00),
(2, 3000.00, 800.00),
(3, 2000.00, 0.00);

-- ROOM RESERVATION
INSERT INTO RoomReservation (club_id, event_id, room_number, start_time, end_time) VALUES
(1, 1, 'B7-Lab1', '2024-11-10 08:00:00', '2024-11-10 20:00:00'),
(1, 3, 'B5-113', '2024-09-15 10:00:00', '2024-09-15 13:00:00'),
(2, 2, 'Stadium-Field', '2024-10-05 08:00:00', '2024-10-05 18:00:00');
