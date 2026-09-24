DROP TABLE IF EXISTS "Enrollment" CASCADE;
DROP TABLE IF EXISTS "Course" CASCADE;
DROP TABLE IF EXISTS "User" CASCADE;
DROP FUNCTION IF EXISTS fn_skip_duplicate_enrollment();

CREATE TABLE "User" (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role VARCHAR(20) NOT NULL CHECK (role IN ('student', 'teacher')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "Course" (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    teacher_id INT NOT NULL REFERENCES "User"(id) ON DELETE RESTRICT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "Enrollment" (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_id INT NOT NULL REFERENCES "User"(id) ON DELETE CASCADE,
    course_id INT NOT NULL REFERENCES "Course"(id) ON DELETE CASCADE,
    progress DECIMAL(5,2) DEFAULT 0.00 CHECK (progress BETWEEN 0 AND 100),
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (student_id, course_id)
);

CREATE OR REPLACE FUNCTION fn_skip_duplicate_enrollment()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM "Enrollment" 
        WHERE student_id = NEW.student_id 
          AND course_id = NEW.course_id
    ) THEN
        RETURN NULL;
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_skip_duplicate_enrollment
BEFORE INSERT ON "Enrollment"
FOR EACH ROW
EXECUTE FUNCTION fn_skip_duplicate_enrollment();

INSERT INTO "User" (name, email, role) VALUES
('Teacher1', 'teacher1@lms.ru', 'teacher'),
('Teacher2', 'teacher2@lms.ru', 'teacher');

INSERT INTO "User" (name, email, role)
SELECT 
    'Student_' || g,
    'student_' || g || '@lms.ru',
    'student'
FROM generate_series(1, 1000) g;

INSERT INTO "Course" (title, description, teacher_id) VALUES
('Python Course', 'Learning Python', 1),
('Python and Mathematics', 'Math in Python', 1),
('Python and Data Structures', 'Data structures in Python', 2);

INSERT INTO "Enrollment" (student_id, course_id, progress, enrolled_at)
SELECT 
    (random() * 999 + 3)::int,
    (random() * 2 + 1)::int,
    (random() * 100)::numeric(5,2),
    now() - (random() * interval '365 days')
FROM generate_series(1, 100000);
