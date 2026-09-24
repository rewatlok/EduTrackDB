DROP TABLE IF EXISTS "Enrollment" CASCADE;
DROP TABLE IF EXISTS "Lesson" CASCADE;
DROP TABLE IF EXISTS "Module" CASCADE;
DROP TABLE IF EXISTS "Course" CASCADE;
DROP TABLE IF EXISTS "User" CASCADE;

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

CREATE TABLE "Module" (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    order_num INT NOT NULL CHECK (order_num > 0),
    course_id INT NOT NULL REFERENCES "Course"(id) ON DELETE CASCADE,
    UNIQUE (course_id, order_num)
);

CREATE TABLE "Lesson" (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    type VARCHAR(20) NOT NULL CHECK (type IN ('video', 'article', 'quiz')),
    content_url VARCHAR(500),
    order_num INT NOT NULL CHECK (order_num > 0),
    module_id INT NOT NULL REFERENCES "Module"(id) ON DELETE CASCADE,
    UNIQUE (module_id, order_num)
);

CREATE TABLE "Enrollment" (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_id INT NOT NULL REFERENCES "User"(id) ON DELETE CASCADE,
    course_id INT NOT NULL REFERENCES "Course"(id) ON DELETE CASCADE,
    progress DECIMAL(5,2) DEFAULT 0.00 CHECK (progress BETWEEN 0 AND 100),
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (student_id, course_id)
);

CREATE INDEX idx_course_teacher ON "Course"(teacher_id);
CREATE INDEX idx_module_course ON "Module"(course_id);
CREATE INDEX idx_lesson_module ON "Lesson"(module_id);
CREATE INDEX idx_enrollment_student ON "Enrollment"(student_id);
CREATE INDEX idx_enrollment_course ON "Enrollment"(course_id);

INSERT INTO "User" (name, email, role) VALUES
('Andrey Rudov', 'andrey.rudov@lms.ru', 'teacher'),
('Veniamin Oprya', 'veniamin.oprya@lms.ru', 'teacher');

INSERT INTO "User" (name, email, role) VALUES
('Denis Turubanov', 'denis.turubanov@lms.ru', 'student'),
('Yuri Alekseev', 'yuri.alekseev@lms.ru', 'student'),
('Maxim Fialkovsky', 'maxim.fialkovsky@lms.ru', 'student');

INSERT INTO "Course" (title, description, teacher_id) VALUES
('Python Course', 'Learning Python: from first programs to confident problem solving.', 1),
('Python and Mathematics', 'Math library and applied problems in Python.', 1),
('Python and Data Structures', 'Lists, dictionaries, sets and algorithms in Python.', 2);

INSERT INTO "Module" (title, order_num, course_id) VALUES
('Introduction to Python', 1, 1),
('Functions', 2, 1);

INSERT INTO "Module" (title, order_num, course_id) VALUES
('Math Library', 1, 2);

INSERT INTO "Module" (title, order_num, course_id) VALUES
('Lists and Tuples', 1, 3),
('Dictionaries and Sets', 2, 3),
('Algorithms in Python', 3, 3);

INSERT INTO "Lesson" (title, type, content_url, order_num, module_id) VALUES
('What is Python?', 'video', 'https://lms.example.com/python_intro', 1, 1),
('Installation and Setup', 'article', 'https://lms.example.com/setup', 2, 1),
('First Program', 'video', 'https://lms.example.com/hello', 3, 1),
('Quiz: Basics', 'quiz', 'https://lms.example.com/quiz', 4, 1),
('Quiz Review', 'article', 'https://lms.example.com/quiz_review', 5, 1);

INSERT INTO "Lesson" (title, type, content_url, order_num, module_id) VALUES
('Functions', 'video', 'https://lms.example.com/func', 1, 2),
('Lambda Functions', 'video', 'https://lms.example.com/lambda', 2, 2);

INSERT INTO "Lesson" (title, type, content_url, order_num, module_id) VALUES
('Basic Math Functions', 'video', 'https://lms.example.com/math_basic', 1, 3),
('Trigonometric Functions', 'article', 'https://lms.example.com/trig', 2, 3),
('Quiz: Math', 'quiz', 'https://lms.example.com/math_quiz', 3, 3);

INSERT INTO "Lesson" (title, type, content_url, order_num, module_id) VALUES
('Lists', 'video', 'https://lms.example.com/list', 1, 4),
('List Methods', 'article', 'https://lms.example.com/list_methods', 2, 4);

INSERT INTO "Lesson" (title, type, content_url, order_num, module_id) VALUES
('Dictionaries', 'video', 'https://lms.example.com/dicts', 1, 5),
('Dictionary Methods', 'article', 'https://lms.example.com/dict_methods', 2, 5);

INSERT INTO "Lesson" (title, type, content_url, order_num, module_id) VALUES
('Binary Search', 'article', 'https://lms.example.com/binary', 1, 6),
('Algorithm Quiz', 'quiz', 'https://lms.example.com/algo_quiz', 2, 6);

INSERT INTO "Enrollment" (student_id, course_id, progress) VALUES
(3, 1, 0.0),
(3, 2, 0.0),
(3, 3, 0.0);

INSERT INTO "Enrollment" (student_id, course_id, progress) VALUES
(4, 1, 0.0),
(4, 2, 0.0),
(4, 3, 0.0);

INSERT INTO "Enrollment" (student_id, course_id, progress) VALUES
(5, 1, 0.0),
(5, 2, 0.0),
(5, 3, 0.0);

INSERT INTO "Module" (title, order_num, course_id) VALUES
('Statistics', 2, 2);

INSERT INTO "Lesson" (title, type, content_url, order_num, module_id) VALUES
('Introduction to Statistics', 'video', 'https://lms.example.com/stats_intro', 1, 7),
('Quiz: Statistics', 'quiz', 'https://lms.example.com/stats_quiz', 2, 7);

UPDATE "Enrollment" 
SET progress = LEAST(progress + 20.0, 100.0)
WHERE student_id = (SELECT id FROM "User" WHERE name = 'Denis Turubanov') 
  AND course_id = (SELECT id FROM "Course" WHERE title = 'Python Course');

UPDATE "Enrollment" 
SET progress = 100.0
WHERE student_id = (SELECT id FROM "User" WHERE name = 'Yuri Alekseev') 
  AND course_id = (SELECT id FROM "Course" WHERE title = 'Python and Mathematics');

UPDATE "Enrollment" 
SET progress = LEAST(progress + 5.0, 100.0)
WHERE course_id = (SELECT id FROM "Course" WHERE title = 'Python and Data Structures')
  AND progress < 100.0;

DELETE FROM "Lesson" 
WHERE title = 'Quiz Review' 
  AND module_id = (SELECT id FROM "Module" WHERE title = 'Introduction to Python');

DELETE FROM "Enrollment" 
WHERE student_id = (SELECT id FROM "User" WHERE name = 'Maxim Fialkovsky') 
  AND course_id = (SELECT id FROM "Course" WHERE title = 'Python and Mathematics');

SELECT c.title AS course_name, COUNT(e.id) AS students_count
FROM "Course" c
LEFT JOIN "Enrollment" e ON c.id = e.course_id
GROUP BY c.id, c.title
ORDER BY students_count DESC;

SELECT c.title AS course_name, AVG(e.progress) AS avg_progress
FROM "Course" c
JOIN "Enrollment" e ON c.id = e.course_id
GROUP BY c.id, c.title
HAVING AVG(e.progress) > 0
ORDER BY avg_progress DESC;

SELECT c.title AS course_name, 
       MIN(e.progress) AS min_progress,
       MAX(e.progress) AS max_progress,
       AVG(e.progress) AS avg_progress
FROM "Course" c
JOIN "Enrollment" e ON c.id = e.course_id
GROUP BY c.id, c.title;

SELECT 
    COUNT(*) AS total_enrollments,
    SUM(progress) AS total_progress,
    AVG(progress) AS avg_progress,
    MIN(progress) AS min_progress,
    MAX(progress) AS max_progress
FROM "Enrollment";

SELECT u.name AS student_name, c.title AS course_name, e.progress
FROM "User" u
INNER JOIN "Enrollment" e ON u.id = e.student_id
INNER JOIN "Course" c ON e.course_id = c.id
WHERE u.role = 'student'
ORDER BY u.name, e.progress DESC;

SELECT c.title AS course_name, t.name AS teacher_name, COUNT(m.id) AS modules_count
FROM "Course" c
LEFT JOIN "User" t ON c.teacher_id = t.id
LEFT JOIN "Module" m ON c.id = m.course_id
GROUP BY c.id, c.title, t.name
ORDER BY modules_count DESC;

SELECT c.title AS course, m.title AS module, l.title AS lesson, l.type
FROM "Course" c
INNER JOIN "Module" m ON c.id = m.course_id
INNER JOIN "Lesson" l ON m.id = l.module_id
WHERE c.title = 'Python Course'
ORDER BY m.order_num, l.order_num;

SELECT c.title AS course_name, COUNT(e.student_id) AS students_enrolled
FROM "Course" c
LEFT JOIN "Enrollment" e ON c.id = e.course_id
GROUP BY c.id, c.title
ORDER BY students_enrolled DESC;

SELECT u.name AS student_name, COUNT(e.course_id) AS courses_count
FROM "User" u
INNER JOIN "Enrollment" e ON u.id = e.student_id
WHERE u.role = 'student'
GROUP BY u.id, u.name
ORDER BY courses_count DESC;

CREATE VIEW StudentCourseInfo AS
SELECT u.id AS student_id, u.name AS student_name, u.created_at AS registered_date,
       c.id AS course_id, c.title AS course_name, e.progress, e.enrolled_at
FROM "User" u
JOIN "Enrollment" e ON u.id = e.student_id
JOIN "Course" c ON e.course_id = c.id
WHERE u.role = 'student';

CREATE VIEW CourseModuleCount AS
SELECT c.id AS course_id, c.title AS course_name, c.created_at,
       COUNT(m.id) AS modules_count
FROM "Course" c
LEFT JOIN "Module" m ON c.id = m.course_id
GROUP BY c.id, c.title, c.created_at;

CREATE VIEW StudentTotalProgress AS
SELECT u.id AS student_id, u.name AS student_name, u.created_at,
       COUNT(e.course_id) AS total_courses,
       AVG(e.progress) AS avg_progress,
       MAX(e.enrolled_at) AS last_activity
FROM "User" u
JOIN "Enrollment" e ON u.id = e.student_id
WHERE u.role = 'student'
GROUP BY u.id, u.name, u.created_at;
