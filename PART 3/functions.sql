CREATE OR REPLACE FUNCTION fn_completed_courses(p_student_id INT)
RETURNS INT
LANGUAGE sql
STABLE
AS $$
    SELECT COUNT(*)
    FROM "Enrollment"
    WHERE student_id = p_student_id AND progress = 100.0;
$$;

CREATE OR REPLACE FUNCTION fn_avg_progress(p_student_id INT)
RETURNS NUMERIC(5,2)
LANGUAGE sql
STABLE
AS $$
    SELECT COALESCE(AVG(progress), 0.0)
    FROM "Enrollment"
    WHERE student_id = p_student_id;
$$;

CREATE OR REPLACE FUNCTION fn_is_teacher(p_user_id INT)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
AS $$
    SELECT role = 'teacher' FROM "User" WHERE id = p_user_id;
$$;
