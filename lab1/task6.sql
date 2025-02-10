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