CREATE OR REPLACE PROCEDURE sp_unenroll_student(
    p_student_id INT,
    p_course_id INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_enrollment_id INT;
BEGIN
    SELECT id INTO v_enrollment_id
    FROM "Enrollment"
    WHERE student_id = p_student_id AND course_id = p_course_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Student % is not enrolled in course %', p_student_id, p_course_id;
    END IF;
    DELETE FROM "Enrollment" WHERE id = v_enrollment_id;
    RAISE NOTICE 'Student % unenrolled from course %', p_student_id, p_course_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error during unenrollment: %', SQLERRM;
        INSERT INTO "ErrorLog" (error_code, error_message, context)
        VALUES (SQLSTATE, SQLERRM, jsonb_build_object('student_id', p_student_id, 'course_id', p_course_id));
END;
$$;
