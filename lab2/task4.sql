-- Создаем таблицу для хранения журнала изменений
CREATE TABLE STUDENTS_AUDIT_LOG (
    LOG_ID NUMBER PRIMARY KEY,
    ACTION_TYPE VARCHAR2(10),  -- INSERT, UPDATE, DELETE
    ACTION_DATE TIMESTAMP,
    USER_NAME VARCHAR2(100),
    STUDENT_ID NUMBER,
    OLD_NAME VARCHAR2(100),
    NEW_NAME VARCHAR2(100),
    OLD_GROUP_ID NUMBER,
    NEW_GROUP_ID NUMBER
);

-- Создаем последовательность для LOG_ID
CREATE SEQUENCE audit_log_seq START WITH 1 INCREMENT BY 1;

-- Создаем триггер для аудита
CREATE OR REPLACE TRIGGER students_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON STUDENTS
FOR EACH ROW
DECLARE
    v_action_type VARCHAR2(10);
BEGIN
    -- Определяем тип действия
    IF INSERTING THEN
        v_action_type := 'INSERT';
    ELSIF UPDATING THEN
        v_action_type := 'UPDATE';
    ELSIF DELETING THEN
        v_action_type := 'DELETE';
    END IF;
    
    -- Записываем информацию в лог
    INSERT INTO STUDENTS_AUDIT_LOG (
        LOG_ID,
        ACTION_TYPE,
        ACTION_DATE,
        USER_NAME,
        STUDENT_ID,
        OLD_NAME,
        NEW_NAME,
        OLD_GROUP_ID,
        NEW_GROUP_ID
    ) VALUES (
        audit_log_seq.NEXTVAL,
        v_action_type,
        SYSTIMESTAMP,
        USER,
        CASE 
            WHEN v_action_type = 'DELETE' THEN :OLD.ID
            ELSE :NEW.ID
        END,
        CASE 
            WHEN v_action_type IN ('UPDATE', 'DELETE') THEN :OLD.NAME
            ELSE NULL
        END,
        CASE 
            WHEN v_action_type IN ('INSERT', 'UPDATE') THEN :NEW.NAME
            ELSE NULL
        END,
        CASE 
            WHEN v_action_type IN ('UPDATE', 'DELETE') THEN :OLD.GROUP_ID
            ELSE NULL
        END,
        CASE 
            WHEN v_action_type IN ('INSERT', 'UPDATE') THEN :NEW.GROUP_ID
            ELSE NULL
        END
    );
END;
/