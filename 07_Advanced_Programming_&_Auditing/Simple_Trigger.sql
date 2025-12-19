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
