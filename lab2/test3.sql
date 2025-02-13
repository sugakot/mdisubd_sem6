-- 1. Очищаем таблицы и сбрасываем последовательности
DELETE FROM STUDENTS;
DELETE FROM GROUPS;
DROP SEQUENCE students_seq;
DROP SEQUENCE groups_seq;
CREATE SEQUENCE students_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE groups_seq START WITH 1 INCREMENT BY 1;

-- 2. Создаем тестовые группы
INSERT INTO GROUPS (NAME) VALUES ('Group A');
INSERT INTO GROUPS (NAME) VALUES ('Group B');

-- 3. Добавляем студентов
INSERT INTO STUDENTS (NAME, GROUP_ID) VALUES ('John Doe', 1);
INSERT INTO STUDENTS (NAME, GROUP_ID) VALUES ('Jane Smith', 1);
INSERT INTO STUDENTS (NAME, GROUP_ID) VALUES ('Bob Wilson', 2);

-- 4. Пробуем добавить студента с несуществующей группой
-- Должно вызвать ошибку
INSERT INTO STUDENTS (NAME, GROUP_ID) VALUES ('Error Student', 999);

-- 5. Проверяем данные до удаления
SELECT 'Before delete' as status, g.ID as group_id, g.NAME as group_name, 
       s.ID as student_id, s.NAME as student_name
FROM GROUPS g
LEFT JOIN STUDENTS s ON g.ID = s.GROUP_ID
ORDER BY g.ID, s.ID;

-- 6. Удаляем группу (должно каскадно удалить студентов)
DELETE FROM GROUPS WHERE ID = 1;

-- 7. Проверяем данные после удаления
SELECT 'After delete' as status, g.ID as group_id, g.NAME as group_name, 
       s.ID as student_id, s.NAME as student_name
FROM GROUPS g
LEFT JOIN STUDENTS s ON g.ID = s.GROUP_ID
ORDER BY g.ID, s.ID;