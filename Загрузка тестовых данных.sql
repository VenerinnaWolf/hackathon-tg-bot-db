-- Загрузка тестовых данных в таблицы

-- переключение на схему тест
SET search_path TO test; 

-- Очистка таблиц (в обратном порядке создания) для добавления тестовых данных
TRUNCATE TABLE test.users CASCADE;

-- Далее необходимо скопировать файлы с тестовыми данными. 
-- Можно это сделать командой COPY ... FROM, но для этого нужны права суперпользователя
-- Можно использовать команду в psql \copy, она работает для всех
-- Можно использовать графический интерфейс программ типа pgadmin4 или dbeaver.

-- Названия приведены ниже в псевдозапросах (для реальных запросов нужно указывать абсолютный путь)
COPY users FROM 'files/users_test_data.csv' WITH (FORMAT csv);
COPY applications FROM 'files/applications_test_data.csv' WITH (FORMAT csv); -- Данные до изменения статусов
COPY status_changes FROM 'files/status_changes_test_data.csv' WITH (FORMAT csv);
COPY applications FROM 'files/applications_test_data_final.csv' WITH (FORMAT csv); -- Данные после изменения статусов