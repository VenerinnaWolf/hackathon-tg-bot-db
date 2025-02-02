SET search_path TO test; 
--SET search_path TO public; 

--Построение аналитических витрин:

-- Схема для витрин:
CREATE SCHEMA dm;

-- ---------
-- Создание таблиц для витрин:
-- ---------

--Количество заявок по направлениям (как поступивших так и нет)
CREATE TABLE dm.applications_for_courses_count AS
SELECT c.course_name, COUNT(*) 
FROM applications a 
JOIN courses c USING (course_id)
GROUP BY c.course_name
ORDER BY COUNT(*) DESC;

--Количество успешных и неуспешных регистраций.
CREATE TABLE dm.accepted_rejected_applications_count AS
SELECT s.status_name, COUNT(*)
FROM applications a 
JOIN statuses s USING (status_id)
WHERE s.status_name IN ('принята', 'отклонена')
GROUP BY s.status_name;

-- Дополнительные витрины:

--Количество заявок, сгруппированные по всем статусам
CREATE TABLE dm.applications_statuses_count AS
SELECT s.status_name, COUNT(*)
FROM applications a 
JOIN statuses s USING (status_id)
GROUP BY s.status_name;

-- Количество людей по городам (отсортировано в порядке убывания)
CREATE TABLE dm.people_in_city_count AS
SELECT u.city, COUNT(*)
FROM users u 
GROUP BY u.city
ORDER BY COUNT(*) DESC;

-- Количество поступивших людей на каждое направление (отсортировано в порядке убывания)
CREATE TABLE dm.people_on_course_count AS
SELECT c.course_name, COUNT(*) 
FROM applications a 
JOIN courses c USING (course_id)
WHERE a.status_id = 4
GROUP BY c.course_name
ORDER BY COUNT(*) DESC;

-- Количество людей по ролям
CREATE TABLE dm.people_for_roles_count AS
SELECT r.role_name, COUNT(*)
FROM users u 
JOIN roles r USING (role_id)
GROUP BY r.role_name;

-- Количество людей по ролям и статусам заявок
CREATE TABLE dm.people_for_roles_statuses_count AS
SELECT r.role_name, s.status_name, COUNT(*)
FROM users u 
JOIN roles r USING (role_id)
LEFT JOIN applications a USING (user_id)
LEFT JOIN statuses s USING (status_id)
GROUP BY r.role_name, s.status_name
ORDER BY r.role_name, s.status_name;

-- ---------
-- Создание процедур для повторного рассчета витрин:
-- ---------

--Количество заявок по направлениям (как поступивших так и нет)
CREATE OR REPLACE PROCEDURE dm.fill_applications_for_courses_count()
LANGUAGE SQL AS $$
	TRUNCATE TABLE dm.applications_for_courses_count;
	
	INSERT INTO dm.applications_for_courses_count
	SELECT c.course_name, COUNT(*) 
	FROM applications a 
	JOIN courses c USING (course_id)
	GROUP BY c.course_name
	ORDER BY COUNT(*) DESC;
$$;

--Количество успешных и неуспешных регистраций.
CREATE OR REPLACE PROCEDURE dm.fill_accepted_rejected_applications_count()
LANGUAGE SQL AS $$
	TRUNCATE TABLE dm.accepted_rejected_applications_count;
	
	INSERT INTO dm.accepted_rejected_applications_count
	SELECT s.status_name, COUNT(*)
	FROM applications a 
	JOIN statuses s USING (status_id)
	WHERE s.status_name IN ('принята', 'отклонена')
	GROUP BY s.status_name;
$$;

--Количество заявок, сгруппированные по всем статусам
CREATE OR REPLACE PROCEDURE dm.fill_applications_statuses_count()
LANGUAGE SQL AS $$
	TRUNCATE TABLE dm.applications_statuses_count;
	
	INSERT INTO dm.applications_statuses_count
	SELECT s.status_name, COUNT(*)
	FROM applications a 
	JOIN statuses s USING (status_id)
	GROUP BY s.status_name;
$$;

-- Количество людей по городам (отсортировано в порядке убывания)
CREATE OR REPLACE PROCEDURE dm.fill_people_in_city_count()
LANGUAGE SQL AS $$
	TRUNCATE TABLE dm.people_in_city_count;
	
	INSERT INTO dm.people_in_city_count
	SELECT u.city, COUNT(*)
	FROM users u 
	GROUP BY u.city
	ORDER BY COUNT(*) DESC;
$$;

-- Количество поступивших людей на каждое направление (отсортировано в порядке убывания)
CREATE OR REPLACE PROCEDURE dm.fill_people_on_course_count()
LANGUAGE SQL AS $$
	TRUNCATE TABLE dm.people_on_course_count;
	
	INSERT INTO dm.people_on_course_count
	SELECT c.course_name, COUNT(*) 
	FROM applications a 
	JOIN courses c USING (course_id)
	WHERE a.status_id = 4
	GROUP BY c.course_name
	ORDER BY COUNT(*) DESC;
$$;

-- Количество людей по ролям
CREATE OR REPLACE PROCEDURE dm.fill_people_for_roles_count()
LANGUAGE SQL AS $$
	TRUNCATE TABLE dm.people_for_roles_count;
	
	INSERT INTO dm.people_for_roles_count
	SELECT r.role_name, COUNT(*)
	FROM users u 
	JOIN roles r USING (role_id)
	GROUP BY r.role_name;
$$;

-- Количество людей по ролям и статусам заявок
CREATE OR REPLACE PROCEDURE dm.fill_people_for_roles_statuses_count()
LANGUAGE SQL AS $$
	TRUNCATE TABLE dm.people_for_roles_statuses_count;
	
	INSERT INTO dm.people_for_roles_statuses_count
	SELECT r.role_name, s.status_name, COUNT(*)
	FROM users u 
	JOIN roles r USING (role_id)
	LEFT JOIN applications a USING (user_id)
	LEFT JOIN statuses s USING (status_id)
	GROUP BY r.role_name, s.status_name
	ORDER BY r.role_name, s.status_name;
$$;

-- ---------
-- Вызов процедур для повторного рассчета витрин:
-- ---------

CALL dm.fill_applications_for_courses_count();
CALL dm.fill_accepted_rejected_applications_count();
CALL dm.fill_applications_statuses_count();
CALL dm.fill_people_in_city_count();
CALL dm.fill_people_on_course_count();
CALL dm.fill_people_for_roles_count();
CALL dm.fill_people_for_roles_statuses_count();

-- ---------
-- Просмотр повторно заполненных витрин:
-- ---------

SELECT * FROM dm.applications_for_courses_count;
SELECT * FROM dm.accepted_rejected_applications_count;
SELECT * FROM dm.applications_statuses_count;
SELECT * FROM dm.people_in_city_count;
SELECT * FROM dm.people_on_course_count;
SELECT * FROM dm.people_for_roles_count;
SELECT * FROM dm.people_for_roles_statuses_count;