CREATE OR REPLACE PROCEDURE sp_enroll_student(
    p_student_id INT,
    p_course_id INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_user_role TEXT;
    v_course_exists INT;
BEGIN
    SELECT role INTO v_user_role FROM "User" WHERE id = p_student_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'User with ID % does not exist', p_student_id;
    END IF;
    IF v_user_role != 'student' THEN
        RAISE EXCEPTION 'User with ID % is not a student (role=%)', p_student_id, v_user_role;
    END IF;
    SELECT COUNT(*) INTO v_course_exists FROM "Course" WHERE id = p_course_id;
    IF v_course_exists = 0 THEN
        RAISE EXCEPTION 'Course with ID % does not exist', p_course_id;
    END IF;
    INSERT INTO "Enrollment" (student_id, course_id, progress)
    VALUES (p_student_id, p_course_id, 0.0);
    RAISE NOTICE 'Student % successfully enrolled in course %', p_student_id, p_course_id;
EXCEPTION
    WHEN unique_violation THEN
        RAISE NOTICE 'Error: student % is already enrolled in course %', p_student_id, p_course_id;
        INSERT INTO "ErrorLog" (error_code, error_message, context)
        VALUES (SQLSTATE, SQLERRM, jsonb_build_object('student_id', p_student_id, 'course_id', p_course_id));
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Foreign key error: please check if student or course exists';
        INSERT INTO "ErrorLog" (error_code, error_message, context)
        VALUES (SQLSTATE, SQLERRM, jsonb_build_object('student_id', p_student_id, 'course_id', p_course_id));
    WHEN OTHERS THEN
        RAISE NOTICE 'Unknown error: %', SQLERRM;
        INSERT INTO "ErrorLog" (error_code, error_message, context)
        VALUES (SQLSTATE, SQLERRM, jsonb_build_object('student_id', p_student_id, 'course_id', p_course_id));
END;
$$;
