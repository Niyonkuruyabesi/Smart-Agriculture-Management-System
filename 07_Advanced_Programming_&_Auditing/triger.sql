-- 1.  Holiday Management Table

-- We need a table to store public holidays:

CREATE TABLE public_holidays (
    holiday_date DATE PRIMARY KEY,
    description VARCHAR2(100)
);

-- Example: Add some upcoming holidays
INSERT INTO public_holidays(holiday_date, description) VALUES (TO_DATE('2025-12-25','YYYY-MM-DD'),'Christmas Day');
INSERT INTO public_holidays(holiday_date, description) VALUES (TO_DATE('2025-01-01','YYYY-MM-DD'),'New Year');
COMMIT;

--- 2. Audit Log Table

--- This table will capture all attempts to insert/update/delete:

CREATE TABLE audit_log (
    audit_id NUMBER PRIMARY KEY,
    user_name VARCHAR2(50),
    action_type VARCHAR2(10),
    table_name VARCHAR2(50),
    action_date DATE,
    status VARCHAR2(10),
    message VARCHAR2(200)
);

-- Sequence for audit log
CREATE SEQUENCE audit_log_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

--- 3. Audit Logging Function

CREATE OR REPLACE PROCEDURE log_audit(
    p_user VARCHAR2,
    p_action VARCHAR2,
    p_table VARCHAR2,
    p_status VARCHAR2,
    p_message VARCHAR2
) IS
BEGIN
    INSERT INTO audit_log(
        audit_id, user_name, action_type, table_name, action_date, status, message
    )
    VALUES(
        audit_log_seq.NEXTVAL, p_user, p_action, p_table, SYSDATE, p_status, p_message
    );
    COMMIT;
END;
/

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

-- 5. Simple Trigger Example

--- This trigger prevents INSERT on restricted days for a sample table, e.g., farms:

CREATE OR REPLACE TRIGGER trg_farms_restrict
BEFORE INSERT OR UPDATE OR DELETE ON farms
FOR EACH ROW
DECLARE
    v_allowed BOOLEAN;
BEGIN
    v_allowed := is_action_allowed;

    IF NOT v_allowed THEN
        -- Log attempt
        log_audit(USER,'INSERT/UPDATE/DELETE','FARMS','DENIED','Action not allowed today');
        RAISE_APPLICATION_ERROR(-20001,'Action not allowed on weekdays or public holidays!');
    ELSE
        log_audit(USER,'INSERT/UPDATE/DELETE','FARMS','ALLOWED','Action successful');
    END IF;
END;
/

--- 6. Compound Trigger Example

--- A compound trigger can log before and after events for performance:

CREATE OR REPLACE TRIGGER trg_farms_compound
FOR INSERT OR UPDATE OR DELETE ON farms
COMPOUND TRIGGER

    -- Before statement
    BEFORE STATEMENT IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Compound Trigger: Before statement execution');
    END BEFORE STATEMENT;

    -- Before each row
    BEFORE EACH ROW IS
        v_allowed BOOLEAN;
    BEGIN
        v_allowed := is_action_allowed;
        IF NOT v_allowed THEN
            log_audit(USER,'INSERT/UPDATE/DELETE','FARMS','DENIED','Action not allowed today');
            RAISE_APPLICATION_ERROR(-20001,'Action not allowed on weekdays or public holidays!');
        END IF;
    END BEFORE EACH ROW;

    -- After each row
    AFTER EACH ROW IS
    BEGIN
        log_audit(USER,'INSERT/UPDATE/DELETE','FARMS','ALLOWED','Action completed');
    END AFTER EACH ROW;

    -- After statement
    AFTER STATEMENT IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Compound Trigger: After statement execution');
    END AFTER STATEMENT;

END trg_farms_compound;
/

--- 7. Testing Scenarios

--- Weekday INSERT (Denied)

INSERT INTO farms(farm_id,farm_name,location,farm_type)
VALUES (999,'TestFarm','TestLocation','Crop');

-- Should fail and log DENIED


--- Weekend INSERT (Allowed)

--- Public Holiday INSERT (Denied)

---  checking the audit log:

SELECT * FROM audit_log ORDER BY audit_id DESC;