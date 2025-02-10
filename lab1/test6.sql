SET SERVEROUTPUT ON;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Yearly reward for salary 50000 and bonus 20%: ' ||
    	calculate_yearly_reward(50000, 20));
   	 
	DBMS_OUTPUT.PUT_LINE('Yearly reward for salary 50000 and bonus 0%: ' ||
    	calculate_yearly_reward(50000, 0));
    
	--DBMS_OUTPUT.PUT_LINE(calculate_yearly_reward(-1000, 20));  -- Отрицательная зарплата
	DBMS_OUTPUT.PUT_LINE(calculate_yearly_reward(1000, 150));  -- Процент больше 100
	-- DBMS_OUTPUT.PUT_LINE(calculate_yearly_reward(NULL, 20));   -- NULL значение
END;
/
