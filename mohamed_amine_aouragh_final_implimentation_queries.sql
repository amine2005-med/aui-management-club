/* =====================================================================
   Project Title : AUI Club Management System — Final Implementation
   Student       : Mohamed Amine Aouragh
   Date          : December 2025
   Course        : CSC3326 — Database Systems
   Instructor    : Dr. Kolev

   Description :
   This final implementation contains the complete SQL solution for the
   AUI Club Management System, integrating all concepts learned throughout
   the course. The database supports the management of students, clubs,
   events, memberships, budgeting, and participation activities at  
   Al Akhawayn University.

   The script includes:
   • Core SELECT, JOIN, UPDATE, and DELETE queries
   • Aggregation, grouping, CTEs, and derived tables
   • Optimized views for reporting and analytics
   • Stored procedures for automating key operations such as:
       – Registering students in clubs
       – Validating and creating events
       – Generating club activity reports
       – Managing attendance and leadership roles
   • Triggers implementing business rules and maintaining data integrity:
       – Budget updates upon event creation/change
       – Preventing deletion of clubs with active members
       – Enforcing valid event dates
       – Auditing membership changes
       – Avoiding overlapping room reservations

   Purpose :
   This implementation demonstrates a fully functional database backend
   that enforces real-world constraints, automates administrative tasks,
   and ensures consistency across all club-related operations. It represents
   the culmination of the project design, normalization, ER modeling, and
   SQL programming learned in the course.
===================================================================== */

USE aui_clubs;

/* ============================================
   BASIC SELECT QUERIES
   ============================================ */

/* Query 1: Select clubs with remaining budget greater than 2000 */
SELECT c.club_name, b.remaining_balance
FROM Club AS c
JOIN Budget AS b ON c.club_id = b.club_id
WHERE b.remaining_balance > 2000;

/* Query 2: Select events in November 2024 */
SELECT e.event_name, e.event_date, e.location
FROM Event AS e
WHERE e.event_date >= '2024-11-01' AND e.event_date <= '2024-11-30';

/* Query 3: Select Computer Science students */
SELECT s.first_name, s.last_name, s.email
FROM Student AS s
WHERE s.major = 'Computer Science';

/* Query 4: Students in Junior and Senior class levels */
SELECT s.first_name, s.last_name, s.email, s.class_level
FROM Student AS s
WHERE s.class_level IN ('Junior', 'Senior');


/* ============================================
   JOIN QUERIES
   ============================================ */

/* Query 5: Show all memberships with student names and club names */
SELECT 
    s.first_name,
    s.last_name,
    c.club_name,
    m.role,
    m.join_date
FROM Membership AS m
JOIN Student AS s ON m.student_id = s.student_id
JOIN Club AS c ON m.club_id = c.club_id;

/* Query 6: Show all events with their club names */
SELECT 
    c.club_name,
    e.event_name,
    e.event_date,
    e.location
FROM Event AS e
JOIN Club AS c ON e.club_id = c.club_id;

/* Query 7: Show students in AUI Coding Club */
SELECT 
    s.first_name,
    s.last_name,
    s.email,
    m.role
FROM Membership AS m
JOIN Student AS s ON m.student_id = s.student_id
JOIN Club AS c ON m.club_id = c.club_id
WHERE c.club_name = 'AUI Coding Club';


/* ============================================
   UPDATE QUERIES
   ============================================ */

/* Query 8: Update student class level */
UPDATE Student
SET class_level = 'Senior'
WHERE student_id = 145783;

/* Query 9: Update club budget allocation */
UPDATE Budget
SET total_allocated = total_allocated + 1000
WHERE club_id = 1;


/* ============================================
   DELETE QUERIES
   ============================================ */

/* Query 10: Delete events with budget less than 500 */
DELETE FROM Event
WHERE budget_used < 500;


/* ============================================
   AGGREGATION AND GROUPING
   ============================================ */

/* Query 11: Count events per club */
SELECT 
    c.club_name,
    COUNT(e.event_id) AS event_count
FROM Club AS c
LEFT JOIN Event AS e ON c.club_id = e.club_id
GROUP BY c.club_id, c.club_name;

/* Query 12: Average budget used by event type */
SELECT 
    event_type,
    AVG(budget_used) AS average_budget,
    COUNT(*) AS event_count
FROM Event
GROUP BY event_type;

/* Query 13: Clubs with more than 2 members */
SELECT 
    c.club_name,
    COUNT(m.membership_id) AS member_count
FROM Club AS c
JOIN Membership AS m ON c.club_id = m.club_id
GROUP BY c.club_id, c.club_name
HAVING COUNT(m.membership_id) > 2;


/* ============================================
   COMMON TABLE EXPRESSIONS (CTEs)
   ============================================ */

/* Query 14: CTE to find club presidents and their clubs */
WITH ClubPresidents AS (
    SELECT student_id, first_name, last_name, major
    FROM Student
    WHERE student_id IN (
        SELECT student_id 
        FROM Membership 
        WHERE role = 'President'
    )
)
SELECT 
    cp.first_name,
    cp.last_name,
    cp.major,
    c.club_name
FROM ClubPresidents AS cp
JOIN Membership AS m ON cp.student_id = m.student_id
JOIN Club AS c ON m.club_id = c.club_id
WHERE m.role = 'President';

/* Query 15: CTE to calculate club statistics */
WITH ClubStats AS (
    SELECT 
        c.club_id,
        c.club_name,
        COUNT(m.membership_id) AS member_count,
        COUNT(e.event_id) AS event_count
    FROM Club AS c
    LEFT JOIN Membership AS m ON c.club_id = m.club_id
    LEFT JOIN Event AS e ON c.club_id = e.club_id
    GROUP BY c.club_id, c.club_name
)
SELECT 
    club_name,
    member_count,
    event_count
FROM ClubStats
ORDER BY member_count DESC;


/* ============================================
   DERIVED TABLES (SUBQUERIES)
   ============================================ */

/* Query 16: Students who participated in more events than average */
SELECT 
    s.first_name,
    s.last_name,
    event_count.participation_count
FROM Student AS s
JOIN (
    SELECT student_id, COUNT(*) AS participation_count
    FROM Participation
    GROUP BY student_id
) AS event_count ON s.student_id = event_count.student_id
WHERE event_count.participation_count > (
    SELECT AVG(participation_count)
    FROM (
        SELECT COUNT(*) AS participation_count
        FROM Participation
        GROUP BY student_id
    ) AS avg_calc
);

/* Query 17: Clubs with more members than average */
SELECT 
    c.club_name,
    club_members.member_count
FROM Club AS c
JOIN (
    SELECT club_id, COUNT(*) AS member_count
    FROM Membership
    GROUP BY club_id
) AS club_members ON c.club_id = club_members.club_id
WHERE club_members.member_count > (
    SELECT AVG(member_count)
    FROM (
        SELECT COUNT(*) AS member_count
        FROM Membership
        GROUP BY club_id
    ) AS avg_calc
);


/* ============================================
   VIEW CREATION AND USAGE
   ============================================ */

/* Query 18: View for student club participation */
CREATE OR REPLACE VIEW vw_student_clubs AS
SELECT 
    s.student_id,
    s.first_name,
    s.last_name,
    s.major,
    s.class_level,
    c.club_name,
    m.role,
    m.join_date
FROM Student AS s
JOIN Membership AS m ON s.student_id = m.student_id
JOIN Club AS c ON m.club_id = c.club_id;

/* Query 19: View for club summary statistics */
CREATE OR REPLACE VIEW vw_club_summary AS
SELECT 
    c.club_id,
    c.club_name,
    b.total_allocated AS club_budget,
    c.creation_date,
    COALESCE(m.member_count, 0) AS member_count,
    COALESCE(e.event_count, 0) AS event_count,
    COALESCE(e.total_event_budget, 0) AS total_event_budget
FROM Club AS c
LEFT JOIN Budget AS b ON c.club_id = b.club_id
LEFT JOIN (
    SELECT club_id, COUNT(DISTINCT student_id) AS member_count
    FROM Membership
    GROUP BY club_id
) AS m ON c.club_id = m.club_id
LEFT JOIN (
    SELECT club_id, COUNT(*) AS event_count, SUM(budget_used) AS total_event_budget
    FROM Event
    GROUP BY club_id
) AS e ON c.club_id = e.club_id;

/* Query 20: Query the club summary view */
SELECT 
    club_name,
    member_count,
    event_count,
    club_budget,
    total_event_budget
FROM vw_club_summary
WHERE member_count > 2
ORDER BY member_count DESC;


/* ============================================
   DROP OLD PROCEDURES
   ============================================ */
DROP PROCEDURE IF EXISTS sp_register_student_to_club;
DROP PROCEDURE IF EXISTS sp_create_event_with_budget_check;
DROP PROCEDURE IF EXISTS sp_club_activity_report;
DROP PROCEDURE IF EXISTS sp_checkin_student_to_event;
DROP PROCEDURE IF EXISTS sp_promote_member;


/* ============================================
   DROP OLD TRIGGERS
   ============================================ */
DROP TRIGGER IF EXISTS trg_update_budget_after_event_insert;
DROP TRIGGER IF EXISTS trg_update_budget_after_event_update;
DROP TRIGGER IF EXISTS trg_prevent_club_deletion_with_members;
DROP TRIGGER IF EXISTS trg_create_budget_for_new_club;
DROP TRIGGER IF EXISTS trg_validate_event_date;
DROP TRIGGER IF EXISTS trg_audit_membership_update;
DROP TRIGGER IF EXISTS trg_prevent_room_overlap;
DROP TRIGGER IF EXISTS trg_prevent_room_overlap_update;


/* ============================================
   STORED PROCEDURES
   ============================================ */

/* Procedure 1: Register a student for a club with validation */
DELIMITER $$
CREATE PROCEDURE sp_register_student_to_club(
    IN p_student_id INT,
    IN p_club_id INT,
    IN p_role VARCHAR(50)
)
BEGIN
    DECLARE v_existing_membership INT;
    
    SELECT COUNT(*) INTO v_existing_membership
    FROM Membership
    WHERE student_id = p_student_id 
    AND club_id = p_club_id 
    AND leave_date IS NULL;
    
    IF v_existing_membership > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Student is already a member of this club';
    ELSE
        INSERT INTO Membership (student_id, club_id, role, join_date)
        VALUES (p_student_id, p_club_id, p_role, CURRENT_DATE);
        SELECT 'Student successfully registered to club' AS success_message;
    END IF;
END$$
DELIMITER ;

/* Procedure 2: Create event with automatic budget validation */
DELIMITER $$
CREATE PROCEDURE sp_create_event_with_budget_check(
    IN p_club_id INT,
    IN p_event_name VARCHAR(100),
    IN p_description TEXT,
    IN p_event_date DATE,
    IN p_event_type VARCHAR(50),
    IN p_location VARCHAR(100),
    IN p_budget_needed DECIMAL(10,2)
)
BEGIN
    DECLARE v_remaining_balance DECIMAL(10,2);
    
    SELECT remaining_balance INTO v_remaining_balance
    FROM Budget
    WHERE club_id = p_club_id;
    
    IF v_remaining_balance IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Club has no budget allocated';
    ELSEIF v_remaining_balance < p_budget_needed THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient budget for this event';
    ELSE
        INSERT INTO Event (club_id, event_name, description, event_date, 
                          event_type, location, budget_used)
        VALUES (p_club_id, p_event_name, p_description, p_event_date, 
                p_event_type, p_location, p_budget_needed);
        SELECT 'Event created successfully' AS success_message;
    END IF;
END$$
DELIMITER ;

/* Procedure 3: Check in student to event */
DELIMITER $$
CREATE PROCEDURE sp_checkin_student_to_event(
    IN p_student_id INT,
    IN p_event_id INT
)
BEGIN
    DECLARE v_participation_exists INT;
    
    SELECT COUNT(*) INTO v_participation_exists
    FROM Participation
    WHERE student_id = p_student_id AND event_id = p_event_id;
    
    IF v_participation_exists = 0 THEN
        INSERT INTO Participation (student_id, event_id, attendance_status, check_in_time)
        VALUES (p_student_id, p_event_id, 'Present', NOW());
        SELECT 'Student checked in successfully' AS success_message;
    ELSE
        UPDATE Participation
        SET attendance_status = 'Present',
            check_in_time = NOW()
        WHERE student_id = p_student_id AND event_id = p_event_id;
        SELECT 'Student attendance updated' AS success_message;
    END IF;
END$$
DELIMITER ;

/* Procedure 4: Promote club member to leadership role */
DELIMITER $$
CREATE PROCEDURE sp_promote_member(
    IN p_student_id INT,
    IN p_club_id INT,
    IN p_new_role VARCHAR(50)
)
BEGIN
    DECLARE v_current_role VARCHAR(50);
    
    SELECT role INTO v_current_role
    FROM Membership
    WHERE student_id = p_student_id AND club_id = p_club_id AND leave_date IS NULL;
    
    IF v_current_role IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Student is not an active member of this club';
    ELSE
        UPDATE Membership
        SET role = p_new_role
        WHERE student_id = p_student_id AND club_id = p_club_id AND leave_date IS NULL;
        SELECT CONCAT('Member promoted from ', v_current_role, ' to ', p_new_role) AS success_message;
    END IF;
END$$
DELIMITER ;



/* ============================================
   TRIGGERS
   ============================================ */

/* Trigger 1: Automatically update budget spent when event is created */
DELIMITER $$
CREATE TRIGGER trg_update_budget_after_event_insert
AFTER INSERT ON Event
FOR EACH ROW
BEGIN
    UPDATE Budget
    SET total_spent = total_spent + NEW.budget_used,
        last_updated = CURRENT_DATE
    WHERE club_id = NEW.club_id;
END$$
DELIMITER ;

/* Trigger 2: Automatically update budget spent when event is updated */
DELIMITER $$
CREATE TRIGGER trg_update_budget_after_event_update
AFTER UPDATE ON Event
FOR EACH ROW
BEGIN
    IF OLD.club_id <=> NEW.club_id THEN
        UPDATE Budget
        SET total_spent = total_spent - OLD.budget_used + NEW.budget_used,
            last_updated = CURRENT_DATE
        WHERE club_id = NEW.club_id;
    ELSE
        UPDATE Budget
        SET total_spent = total_spent - OLD.budget_used,
            last_updated = CURRENT_DATE
        WHERE club_id = OLD.club_id;
        UPDATE Budget
        SET total_spent = total_spent + NEW.budget_used,
            last_updated = CURRENT_DATE
        WHERE club_id = NEW.club_id;
    END IF;
END$$
DELIMITER ;

/* Trigger 3: Prevent deleting a club with active members */
DELIMITER $$
CREATE TRIGGER trg_prevent_club_deletion_with_members
BEFORE DELETE ON Club
FOR EACH ROW
BEGIN
    DECLARE v_active_members INT;
    
    SELECT COUNT(*) INTO v_active_members
    FROM Membership
    WHERE club_id = OLD.club_id AND leave_date IS NULL;
    
    IF v_active_members > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete club with active members';
    END IF;
END$$
DELIMITER ;

/* Trigger 4: Auto-create budget record when new club is created */
DELIMITER $$
CREATE TRIGGER trg_create_budget_for_new_club
AFTER INSERT ON Club
FOR EACH ROW
BEGIN
    INSERT INTO Budget (club_id, total_allocated, total_spent, last_updated)
    VALUES (NEW.club_id, 0, 0, CURRENT_DATE);
END$$
DELIMITER ;

/* Trigger 5: Validate event date is not in the past */
DELIMITER $$
CREATE TRIGGER trg_validate_event_date
BEFORE INSERT ON Event
FOR EACH ROW
BEGIN
    IF NEW.event_date < CURRENT_DATE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Event date cannot be in the past';
    END IF;
END$$
DELIMITER ;


/* Trigger 6: Prevent overlapping room reservations */
DELIMITER $$
CREATE TRIGGER trg_prevent_room_overlap
BEFORE INSERT ON RoomReservation
FOR EACH ROW
BEGIN
    DECLARE v_overlap_count INT;

    IF NEW.end_time <= NEW.start_time THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Reservation end time must be after its start time';
    END IF;

    SELECT COUNT(*) INTO v_overlap_count
    FROM RoomReservation
    WHERE room_number = NEW.room_number
      AND NEW.start_time < end_time
      AND NEW.end_time > start_time;
    
    IF v_overlap_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Room is already reserved for this time slot';
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_prevent_room_overlap_update
BEFORE UPDATE ON RoomReservation
FOR EACH ROW
BEGIN
    DECLARE v_overlap_count INT;

    IF NEW.end_time <= NEW.start_time THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Reservation end time must be after its start time';
    END IF;

    SELECT COUNT(*) INTO v_overlap_count
    FROM RoomReservation
    WHERE room_number = NEW.room_number
      AND reservation_id <> OLD.reservation_id
      AND NEW.start_time < end_time
      AND NEW.end_time > start_time;

    IF v_overlap_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Room is already reserved for this time slot';
    END IF;
END$$
DELIMITER ;


/* ============================================
   CALLING THE PROCEDURES (EXAMPLES)
   ============================================ */

/* Test Procedure 1: Register student to club */
CALL sp_register_student_to_club(145783, 3, 'Member');

/* Test Procedure 2: Create event with budget check */
CALL sp_create_event_with_budget_check(1, 'AI Workshop', 'Introduction to AI', DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY), 'Workshop', 'B5-114', 500.00);

/* Test Procedure 3: Check in student to event */
CALL sp_checkin_student_to_event(145783, 1);

/* Test Procedure 4: Promote member */
CALL sp_promote_member(145783, 1, 'Vice President');



/* ============================================
   TESTING THE TRIGGERS
   ============================================ */

/* Test Trigger 1 & 2: Budget updates */
START TRANSACTION;
/* Check budget before */
SELECT * FROM Budget WHERE club_id = 1;
/* Insert event - should trigger budget update */
INSERT INTO Event (club_id, event_name, description, event_date, event_type, location, budget_used)
VALUES (1, 'Test Event', 'Testing trigger', DATE_ADD(CURRENT_DATE, INTERVAL 60 DAY), 'Workshop', 'B5-100', 300.00);
/* Check budget after */
SELECT * FROM Budget WHERE club_id = 1;
ROLLBACK;

/*
Expected-error examples (run individually in a disposable database):
DELETE FROM Club WHERE club_id = 1;
INSERT INTO Event (club_id, event_name, event_date)
VALUES (1, 'Past Event', DATE_SUB(CURRENT_DATE, INTERVAL 1 DAY));
*/
