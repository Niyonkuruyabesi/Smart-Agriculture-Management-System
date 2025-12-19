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