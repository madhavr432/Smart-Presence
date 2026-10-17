-- Fictional sample data for Smart Presence
-- Run schema.sql before running this file.

BEGIN;

-- 1. Classes
INSERT INTO public.classes (class_id, branch, section)
VALUES
    (1, 'CSE', 'A'),
    (2, 'CSE', 'B');

-- 2. Subjects
INSERT INTO public.subjects (subject_id, subject_name)
VALUES
    ('CS101', 'Programming Fundamentals'),
    ('CS102', 'Database Management Systems');

-- 3. Faculty
INSERT INTO public.faculty
    (faculty_id, teacher_name, email, password_hash)
VALUES
    (1, 'Test Faculty One', 'faculty1@example.com', NULL);

-- 4. Students
INSERT INTO public.students
    (enrollment_no, student_name, roll_no, class_id,
     lab_batch, password_hash)
VALUES
    ('TEST001', 'Test Student One', 9001, 1, 'A1', NULL),
    ('TEST002', 'Test Student Two', 9002, 1, 'A1', NULL),
    ('TEST003', 'Test Student Three', 9003, 2, 'B1', NULL);

-- 5. Teaching assignments
INSERT INTO public.teaching_assignment
    (assignment_id, faculty_id, class_id, subject_id,
     class_day, start_time, end_time, room_no, lab_batch)
VALUES
    (1, 1, 1, 'CS101', 'Monday',
     '09:00', '10:00', '101', 'A1'),
    (2, 1, 2, 'CS102', 'Tuesday',
     '10:00', '11:00', '102', 'B1');

-- 6. Attendance sessions
INSERT INTO public.attendance_session
    (session_id, assignment_id, session_token, session_date,
     started_at, closed_at, status)
VALUES
    (1, 1, 'DEMO-SESSION-001', CURRENT_DATE,
     '09:00', NULL, 'OPEN');

-- 7. Attendance records
INSERT INTO public.attendance
    (attendance_id, session_id, enrollment_no, status, marked_at)
VALUES
    (1, 1, 'TEST001', 'PRESENT', CURRENT_TIME),
    (2, 1, 'TEST002', 'ABSENT', NULL);

-- Keep auto-generated IDs working after explicit IDs.
SELECT setval(
    'public.classes_class_id_seq',
    (SELECT MAX(class_id) FROM public.classes)
);
SELECT setval(
    'public.faculty_faculty_id_seq',
    (SELECT MAX(faculty_id) FROM public.faculty)
);
SELECT setval(
    'public.teaching_assignment_assignment_id_seq',
    (SELECT MAX(assignment_id) FROM public.teaching_assignment)
);
SELECT setval(
    'public.attendance_session_session_id_seq',
    (SELECT MAX(session_id) FROM public.attendance_session)
);
SELECT setval(
    'public.attendance_attendance_id_seq',
    (SELECT MAX(attendance_id) FROM public.attendance)
);

COMMIT;