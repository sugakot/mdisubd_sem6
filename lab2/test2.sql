DELETE FROM STUDENTS;
DELETE FROM GROUPS;

DROP SEQUENCE students_seq;
DROP SEQUENCE groups_seq;
CREATE SEQUENCE students_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE groups_seq START WITH 1 INCREMENT BY 1;

INSERT INTO GROUPS (NAME) VALUES ('Group A');
INSERT INTO GROUPS (NAME) VALUES ('Group B');

INSERT INTO GROUPS (ID, NAME) VALUES (1, 'Group C');  -- Должна вызвать ошибку

INSERT INTO GROUPS (NAME) VALUES ('Group A');  -- Должна вызвать ошибку

INSERT INTO STUDENTS (NAME, GROUP_ID) VALUES ('John Doe', 1);
INSERT INTO STUDENTS (NAME, GROUP_ID) VALUES ('Jane Smith', 1);

INSERT INTO STUDENTS (ID, NAME, GROUP_ID) VALUES (1, 'Bob Wilson', 2);  -- Должна вызвать ошибку

SELECT * FROM GROUPS;
SELECT * FROM STUDENTS;