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
