CREATE OR REPLACE FUNCTION trg_enrollment_progress_check()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF NEW.progress < OLD.progress THEN
        RAISE EXCEPTION 'Trigger: progress cannot decrease (was %, became %)', OLD.progress, NEW.progress;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS t_enrollment_progress_check ON "Enrollment";
CREATE TRIGGER t_enrollment_progress_check
BEFORE UPDATE ON "Enrollment"
FOR EACH ROW
EXECUTE FUNCTION trg_enrollment_progress_check();

CREATE OR REPLACE FUNCTION trg_enrollment_set_enrolled_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF NEW.enrolled_at IS NULL THEN
        NEW.enrolled_at = CURRENT_TIMESTAMP;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS t_enrollment_set_enrolled_at ON "Enrollment";
CREATE TRIGGER t_enrollment_set_enrolled_at
BEFORE INSERT ON "Enrollment"
FOR EACH ROW
EXECUTE FUNCTION trg_enrollment_set_enrolled_at();
