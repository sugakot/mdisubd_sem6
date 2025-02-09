--- 1
CREATE TABLE MyTable (
	id NUMBER,
	val NUMBER
);

--- 2
BEGIN
  FOR i IN 1..10000 LOOP
	INSERT INTO MyTable (id, val)
	VALUES (
  	i,
  	TRUNC(DBMS_RANDOM.VALUE(1, 1000)) 
	);
  END LOOP;
  COMMIT;
END;
/

--- 3
CREATE OR REPLACE FUNCTION check_even_odd_count
RETURN VARCHAR2 IS
	v_even_count NUMBER;
	v_odd_count NUMBER;
BEGIN
	SELECT COUNT(*) INTO v_even_count
	FROM MyTable
	WHERE MOD(val, 2) = 0;
    
	SELECT COUNT(*) INTO v_odd_count
	FROM MyTable
	WHERE MOD(val, 2) = 1;
    
	IF v_even_count > v_odd_count THEN
    	RETURN 'TRUE';
	ELSIF v_odd_count > v_even_count THEN
    	RETURN 'FALSE';
	ELSE
    	RETURN 'EQUAL';
	END IF;
END;
/

--- check
SET SERVEROUTPUT ON;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Result: ' || check_even_odd_count());
END;
/ 

--- 4
CREATE OR REPLACE FUNCTION generate_insert_command(p_id IN NUMBER)
RETURN VARCHAR2 IS
	v_val NUMBER;
	v_insert_command VARCHAR2(200);
BEGIN
	SELECT val INTO v_val
	FROM MyTable
	WHERE id = p_id;
    
	v_insert_command := 'INSERT INTO MyTable (id, val) VALUES (' ||
                   	p_id || ', ' ||
                   	v_val || ');';
    
	RETURN v_insert_command;
    
EXCEPTION
	WHEN NO_DATA_FOUND THEN
    	RETURN 'Error: No record found with ID = ' || p_id;
	WHEN OTHERS THEN
    	RETURN 'Error: ' || SQLERRM;
END;
/

--- check
SET SERVEROUTPUT ON;
BEGIN
	DBMS_OUTPUT.PUT_LINE(generate_insert_command(1));
	DBMS_OUTPUT.PUT_LINE(generate_insert_command(99999));
END;
/

--- 5
CREATE OR REPLACE PROCEDURE insert_mytable(
	p_id IN NUMBER,
	p_val IN NUMBER
) IS
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

CREATE OR REPLACE PROCEDURE update_mytable(
	p_id IN NUMBER,
	p_val IN NUMBER
) IS
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

CREATE OR REPLACE PROCEDURE delete_mytable(
	p_id IN NUMBER
) IS
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
    	ROLLBACK;
END;
/

--- check
SET SERVEROUTPUT ON;
BEGIN
	insert_mytable(10001, 777);
	update_mytable(10001, 888);
	delete_mytable(10001);
	update_mytable(99999, 999);
END;
/

--- 6
CREATE OR REPLACE FUNCTION calculate_yearly_reward(
	p_monthly_salary IN NUMBER,
	p_bonus_percent IN NUMBER
) RETURN NUMBER IS
	v_total_reward NUMBER;
	v_bonus_decimal NUMBER;
BEGIN
	IF p_monthly_salary IS NULL OR p_bonus_percent IS NULL THEN
    	RAISE_APPLICATION_ERROR(-20001, 'Salary and bonus percent cannot be NULL');
	END IF;
    
	IF p_monthly_salary < 0 THEN
    	RAISE_APPLICATION_ERROR(-20002, 'Salary cannot be negative');
	END IF;
    
	IF p_bonus_percent < 0 OR p_bonus_percent > 100 THEN
    	RAISE_APPLICATION_ERROR(-20003, 'Bonus percentage must be between 0 and 100');
	END IF;
    
	v_bonus_decimal := p_bonus_percent / 100;
    
	v_total_reward := (1 + v_bonus_decimal) * 12 * p_monthly_salary;
    
	RETURN v_total_reward;
END;
/

--- check
SET SERVEROUTPUT ON;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Yearly reward for salary 50000 and bonus 20%: ' ||
    	calculate_yearly_reward(50000, 20));
   	 
	DBMS_OUTPUT.PUT_LINE('Yearly reward for salary 50000 and bonus 0%: ' ||
    	calculate_yearly_reward(50000, 0));
END;
/

