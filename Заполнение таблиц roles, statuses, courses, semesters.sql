INSERT INTO roles (role_name) 
VALUES 
	('visitor'), 
	('candidate'), 
	('external_user');

INSERT INTO statuses (status_name)
VALUES
	('предзаявка'), 
	('на рассмотрении'), 
	('отклонена'), 
	('принята');

INSERT INTO courses (course_name)
VALUES
	('Java development'), 
	('Fronted development'), 
	('Testing'), 
	('Analitics'),
	('DevOps Engineer'), 
	('Data Engineer'), 
	('System Engineer'), 
	('Data Science'),
	('Test-Analyst');

INSERT INTO semesters (start_date, end_date, semester_name)
VALUES
	('2024-02-01', '2024-05-31', 'Весна 2024'), 
	('2024-09-01', '2024-12-31', 'Осень 2024'),
	('2025-02-01', '2025-05-31', 'Весна 2025');
