--- 4. Restriction Check Function

--- This function verifies if today is weekday or holiday:

CREATE OR REPLACE FUNCTION is_action_allowed RETURN BOOLEAN IS
    v_count NUMBER;
BEGIN
    -- Check for weekday Monday-Friday
    IF TO_CHAR(SYSDATE,'DY','NLS_DATE_LANGUAGE=ENGLISH') IN ('MON','TUE','WED','THU','FRI') THEN
        RETURN FALSE;
    END IF;

    -- Check if today is a public holiday
    SELECT COUNT(*) INTO v_count
    FROM public_holidays
    WHERE holiday_date = TRUNC(SYSDATE);

    IF v_count > 0 THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE;
END;
/