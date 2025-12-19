-- 1.Procedure: control_irrigation

CREATE OR REPLACE PROCEDURE control_irrigation (
    p_field_id IN NUMBER,
    p_moisture IN NUMBER,
    p_status OUT VARCHAR2
)
IS
BEGIN
    -- Decide irrigation status
    IF p_moisture < 30 THEN
        p_status := 'ON';
    ELSE
        p_status := 'OFF';
    END IF;

    -- Update irrigation_control table
    UPDATE irrigation_control
    SET irrigation_status = p_status,
        irrigation_date = SYSDATE
    WHERE field_id = p_field_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error in control_irrigation: ' || SQLERRM);
END;
/

Automatically updates irrigation status based on soil moisture readings.

CREATE OR REPLACE PROCEDURE control_irrigation (
    p_field_id IN NUMBER,
    p_moisture IN NUMBER,
    p_status OUT VARCHAR2
)
IS
BEGIN
    -- Decide irrigation status
    IF p_moisture < 30 THEN
        p_status := 'ON';
    ELSE
        p_status := 'OFF';
    END IF;

    -- Update irrigation_control table
    UPDATE irrigation_control
    SET irrigation_status = p_status,
        irrigation_date = SYSDATE
    WHERE field_id = p_field_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error in control_irrigation: ' || SQLERRM);
END;
/


-- Usage Example:

DECLARE
    v_status VARCHAR2(10);
BEGIN
    control_irrigation(101, 25, v_status);
    DBMS_OUTPUT.PUT_LINE('Irrigation status for field 101: ' || v_status);
END;
/




-- 2. Procedure: record_sensor_reading

Insert a new sensor reading with exception handling.

CREATE OR REPLACE PROCEDURE record_sensor_reading(
    p_sensor_id IN NUMBER,
    p_value IN NUMBER,
    p_date IN DATE DEFAULT SYSDATE
)
IS
BEGIN
    INSERT INTO sensor_readings(reading_id, sensor_id, reading_value, reading_date)
    VALUES (sensor_readings_seq.NEXTVAL, p_sensor_id, p_value, p_date);

    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Duplicate reading ID.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error inserting sensor reading: ' || SQLERRM);
END;
/


-- Usage Example:

BEGIN
    record_sensor_reading(1001, 28.5);
END;
/





-- 4. Procedure: monitor_livestock_health

Check animal body temperature and update health status.

CREATE OR REPLACE PROCEDURE monitor_livestock_health(
    p_animal_id IN NUMBER,
    p_body_temp IN NUMBER,
    p_health OUT VARCHAR2
)
IS
BEGIN
    IF p_body_temp < 37 OR p_body_temp > 39 THEN
        p_health := 'Sick';
    ELSE
        p_health := 'Healthy';
    END IF;

    UPDATE livestock
    SET health_status = p_health
    WHERE animal_id = p_animal_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error in monitor_livestock_health: ' || SQLERRM);
END;
/


-- Usage Example:

DECLARE
    v_health VARCHAR2(10);
BEGIN
    monitor_livestock_health(3001, 38.5, v_health);
    DBMS_OUTPUT.PUT_LINE('Animal 3001 health status: ' || v_health);
END;
/




-- 1. Test control_irrigation

SET SERVEROUTPUT ON;

DECLARE
    v_status VARCHAR2(10);
BEGIN
    -- Test for field 101 with low moisture
    control_irrigation(101, 25, v_status);
    DBMS_OUTPUT.PUT_LINE('Field 101 irrigation status: ' || v_status);

    -- Test for field 102 with high moisture
    control_irrigation(102, 45, v_status);
    DBMS_OUTPUT.PUT_LINE('Field 102 irrigation status: ' || v_status);
END;
/




-- 2.  Test record_sensor_reading
SET SERVEROUTPUT ON;

BEGIN
    -- Insert new reading for sensor 1001
    record_sensor_reading(1001, 29.5);
    
    -- Insert another reading for sensor 1002
    record_sensor_reading(1002, 32.0);
    
    DBMS_OUTPUT.PUT_LINE('Sensor readings inserted successfully.');
END;
/




-- 3. Test monitor_livestock_health

SET SERVEROUTPUT ON;

DECLARE
    v_health VARCHAR2(10);
BEGIN
    -- Test healthy temperature
    monitor_livestock_health(3001, 38.0, v_health);
    DBMS_OUTPUT.PUT_LINE('Animal 3001 health: ' || v_health);

    -- Test high temperature (sick)
    monitor_livestock_health(3002, 40.0, v_health);
    DBMS_OUTPUT.PUT_LINE('Animal 3002 health: ' || v_health);
END;
/




--4.  Test control_greenhouse

SET SERVEROUTPUT ON;

DECLARE
    v_light VARCHAR2(10);
BEGIN
    -- Test greenhouse 6001 with normal conditions
    control_greenhouse(6001, 28, 70, v_light);
    DBMS_OUTPUT.PUT_LINE('Greenhouse 6001 light status: ' || v_light);

    -- Test greenhouse 6002 with high temp/humidity
    control_greenhouse(6002, 32, 85, v_light);
    DBMS_OUTPUT.PUT_LINE('Greenhouse 6002 light status: ' || v_light);
END;
/



-- 5.  Verify DML changes

-- to verify that the procedures actually updated the tables correctly

-- Check irrigation status
SELECT field_id, irrigation_status, irrigation_date
FROM irrigation_control
WHERE field_id IN (101,102);

-- Check livestock health
SELECT animal_id, health_status
FROM livestock
WHERE animal_id IN (3001,3002);

-- Check greenhouse light status
SELECT greenhouse_id, light_status
FROM greenhouse_control
WHERE greenhouse_id IN (6001,6002);

-- Check new sensor readings
SELECT * 
FROM sensor_readings
WHERE sensor_id IN (1001,1002)
ORDER BY reading_date DESC;
