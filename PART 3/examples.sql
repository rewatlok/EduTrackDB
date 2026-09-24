SELECT id, name, email, role FROM "User" WHERE role = 'student';
SELECT id, title FROM "Course";

CALL sp_enroll_student(3, 2);
CALL sp_enroll_student(3, 2);

SELECT * FROM "Enrollment" WHERE student_id = 3;

CALL sp_unenroll_student(3, 2);
CALL sp_unenroll_student(3, 2);

SELECT 
    id, name,
    fn_completed_courses(id) AS completed_courses,
    fn_avg_progress(id) AS avg_progress
FROM "User"
WHERE role = 'student';

SELECT id, name, fn_is_teacher(id) AS is_teacher FROM "User";

SELECT * FROM "AuditLog" ORDER BY changed_at DESC LIMIT 10;
SELECT * FROM "ErrorLog" ORDER BY occurred_at DESC;
