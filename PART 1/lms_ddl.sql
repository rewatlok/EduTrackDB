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
