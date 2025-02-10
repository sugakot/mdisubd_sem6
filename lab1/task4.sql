CREATE OR REPLACE FUNCTION SHOW_INSERT(p_id IN NUMBER) RETURN VARCHAR2 IS
v_val NUMBER;
v_insert_command VARCHAR2(200);
BEGIN
    SELECT val INTO v_val
    FROM MyTable
    WHERE id = p_id;

    v_insert_command := 'INSERT INTO MyTable (id, val) VALUES (' || p_id  || ', '|| v_val  ||');';

    RETURN v_insert_command;

    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
        RETURN 'Error: No record found with ID = '||  p_id;
        WHEN OTHERS THEN
      RETURN 'Error: ' ||  SQLERRM;
END;
/