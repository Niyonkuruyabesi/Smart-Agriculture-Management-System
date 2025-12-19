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
