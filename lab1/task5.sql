CREATE OR REPLACE PROCEDURE INSERT_INTO_MYTABLE (p_id IN NUMBER, p_val IN NUMBER) IS
BEGIN
    INSERT INTO MyTable (id, val)
    VALUES (p_id, p_val);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Record successfully inserted');
    
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
          DBMS_OUTPUT.PUT_LINE('Error: Duplicate ID');
      WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
          ROLLBACK;
END;
/


CREATE OR REPLACE PROCEDURE UPDATE_MYTABLE (p_id IN NUMBER, p_val IN NUMBER) IS
BEGIN
    UPDATE MyTable
    SET val = p_val
    WHERE id = p_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No record found with ID = ' || p_id);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Record successfully updated');
    COMMIT;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    ROLLBACK;
END;
/

CREATE OR REPLACE PROCEDURE DELETE_FROM_MYTABLE (p_id IN NUMBER) IS
BEGIN
    DELETE FROM MyTable
    WHERE id = p_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No record found with ID = ' || p_id);
    ELSE 
        DBMS_OUTPUT.PUT_LINE('Record successfully deleted');
    COMMIT;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
