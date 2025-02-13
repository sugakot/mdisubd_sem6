CREATE OR REPLACE TRIGGER task2_groups_trigger
BEFORE INSERT ON GROUPS
FOR EACH ROW
BEGIN
    IF :NEW.ID IS NULL THEN
        :NEW.ID := groups_seq.NEXTVAL;
    END IF;
    
    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM GROUPS
        WHERE ID = :NEW.ID;
        
        IF v_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Duplicate GROUP ID: ' || :NEW.ID);
        END IF;
    END;
    
    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM GROUPS
        WHERE NAME = :NEW.NAME;
        
        IF v_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Duplicate GROUP NAME: ' || :NEW.NAME);
        END IF;
    END;
END;
/

CREATE OR REPLACE TRIGGER task2_students_trigger
BEFORE INSERT ON STUDENTS
FOR EACH ROW
BEGIN
    IF :NEW.ID IS NULL THEN
        :NEW.ID := students_seq.NEXTVAL;
    END IF;
    
    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM STUDENTS
        WHERE ID = :NEW.ID;
        
        IF v_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'Duplicate STUDENT ID: ' || :NEW.ID);
        END IF;
    END;
END;
/