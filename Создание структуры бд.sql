-- -------
-- Создаем таблицы в схеме public

-- переключение на схему public
SET search_path TO public; 

-- Создание таблицы ролей пользователей
-- visitor, candidate, external-user
CREATE TABLE IF NOT EXISTS roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(20) NOT NULL
);

-- Создание таблицы  пользователей
CREATE TABLE IF NOT EXISTS users (
    user_id VARCHAR(10) PRIMARY KEY,  -- ID пользователя телеграм
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    phone VARCHAR(10),  -- Номер телефона(без +7 или 8)
    email VARCHAR(50),
    role_id INT REFERENCES roles(role_id),  -- Связь с таблицей ролей
    city VARCHAR(30)
);

-- Создание таблицы направлений (курсы)
CREATE TABLE IF NOT EXISTS courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(50)
);

-- Создание таблицы статусов заявок
-- Возможные значения: предзаявка, на рассмотрении, отклонена, принята
CREATE TABLE IF NOT EXISTS statuses (
    status_id SERIAL PRIMARY KEY,	
    status_name VARCHAR(20) NOT NULL
);

-- Создание таблицы с датами начала и окончания набора
CREATE TABLE IF NOT EXISTS semesters (
    semester_id SERIAL PRIMARY KEY,
    start_date DATE,
    end_date DATE,
    semester_name VARCHAR(20)
);

-- Создание таблицы заявок
-- У одного пользователя может быть только одна заявка
CREATE TABLE IF NOT EXISTS applications (
    app_id SERIAL PRIMARY KEY,	 
    user_id VARCHAR(10) REFERENCES users(user_id) UNIQUE,
    course_id INT REFERENCES courses(course_id),
    status_id INT REFERENCES statuses(status_id),  -- Статус заявки
    creation_time TIMESTAMP,  -- Дата и время создания заявки
    change_time TIMESTAMP,  -- Дата и время изменения статуса заявки
    semester_id INT REFERENCES semesters(semester_id)
);

-- Создание таблицы смены статусов заявок
CREATE TABLE IF NOT EXISTS status_changes (
    change_id SERIAL PRIMARY KEY,
    app_id INT REFERENCES applications(app_id),
    old_status_id INT REFERENCES statuses(status_id),
    new_status_id INT REFERENCES statuses(status_id)
);

-- -------
-- Создаем таблицы в схеме test

CREATE SCHEMA IF NOT EXISTS test;

-- переключение на схему тест
SET search_path TO test; 

-- Создание таблицы ролей пользователей
-- visitor, candidate, external-user
CREATE TABLE IF NOT EXISTS roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(20) NOT NULL
);

-- Создание таблицы  пользователей
CREATE TABLE IF NOT EXISTS users (
    user_id VARCHAR(10) PRIMARY KEY,  -- ID пользователя телеграм
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    phone VARCHAR(10),  -- Номер телефона(без +7 или 8)
    email VARCHAR(50),
    role_id INT REFERENCES roles(role_id),  -- Связь с таблицей ролей
    city VARCHAR(30)
);

-- Создание таблицы направлений (курсы)
CREATE TABLE IF NOT EXISTS courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(50)
);

-- Создание таблицы статусов заявок
-- Возможные значения: предзаявка, на рассмотрении, отклонена, принята
CREATE TABLE IF NOT EXISTS statuses (
    status_id SERIAL PRIMARY KEY,	
    status_name VARCHAR(20) NOT NULL
);

-- Создание таблицы с датами начала и окончания набора
CREATE TABLE IF NOT EXISTS semesters (
    semester_id SERIAL PRIMARY KEY,
    start_date DATE,
    end_date DATE,
    semester_name VARCHAR(20)
);

-- Создание таблицы заявок
-- У одного пользователя может быть только одна заявка
CREATE TABLE IF NOT EXISTS applications (
    app_id SERIAL PRIMARY KEY,	 
    user_id VARCHAR(10) REFERENCES users(user_id) UNIQUE,
    course_id INT REFERENCES courses(course_id),
    status_id INT REFERENCES statuses(status_id),  -- Статус заявки
    creation_time TIMESTAMP,  -- Дата и время создания заявки
    change_time TIMESTAMP,  -- Дата и время изменения статуса заявки
    semester_id INT REFERENCES semesters(semester_id)
);

-- Создание таблицы смены статусов заявок
CREATE TABLE IF NOT EXISTS status_changes (
    change_id SERIAL PRIMARY KEY,
    app_id INT REFERENCES applications(app_id),
    old_status_id INT REFERENCES statuses(status_id),
    new_status_id INT REFERENCES statuses(status_id)
);