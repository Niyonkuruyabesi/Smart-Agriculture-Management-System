-- 1.  Package: Sensor Management

-- Specification

CREATE OR REPLACE PACKAGE sensor_pkg AS
    PROCEDURE record_sensor(sensor_id IN NUMBER, value IN NUMBER);
    FUNCTION get_avg_moisture(field_id IN NUMBER) RETURN NUMBER;
END sensor_pkg;
/

Body
CREATE OR REPLACE PACKAGE BODY sensor_pkg AS

    PROCEDURE record_sensor(sensor_id IN NUMBER, value IN NUMBER) IS
    BEGIN
        INSERT INTO sensor_readings(reading_id, sensor_id, reading_value, reading_date)
        VALUES (sensor_readings_seq.NEXTVAL, sensor_id, value, SYSDATE);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error recording sensor: ' || SQLERRM);
            ROLLBACK;
    END record_sensor;

    FUNCTION get_avg_moisture(field_id IN NUMBER) RETURN NUMBER IS
        v_avg NUMBER;
    BEGIN
        SELECT AVG(sr.reading_value)
        INTO v_avg
        FROM sensors s
        JOIN sensor_readings sr ON s.sensor_id = sr.sensor_id
        WHERE s.farm_id = (SELECT farm_id FROM crop_fields WHERE field_id = field_id)
          AND s.sensor_type = 'Moisture';
        RETURN v_avg;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error calculating avg moisture: ' || SQLERRM);
            RETURN NULL;
    END get_avg_moisture;

END sensor_pkg;
/

-- 2.  Package: Irrigation Management

-- Specification

CREATE OR REPLACE PACKAGE irrigation_pkg AS
    PROCEDURE control_irrigation(field_id IN NUMBER);
END irrigation_pkg;
/

Body
CREATE OR REPLACE PACKAGE BODY irrigation_pkg AS

    PROCEDURE control_irrigation(field_id IN NUMBER) IS
        v_avg_moisture NUMBER;
    BEGIN
        SELECT AVG(sr.reading_value)
        INTO v_avg_moisture
        FROM sensors s
        JOIN sensor_readings sr ON s.sensor_id = sr.sensor_id
        WHERE s.farm_id = (SELECT farm_id FROM crop_fields WHERE field_id = field_id)
          AND s.sensor_type = 'Moisture';

        IF v_avg_moisture < 30 THEN
            INSERT INTO irrigation_control(irrigation_id, field_id, water_amount_liters, irrigation_status, irrigation_date)
            VALUES (irrigation_control_seq.NEXTVAL, field_id, 500, 'ON', SYSDATE);
        ELSE
            INSERT INTO irrigation_control(irrigation_id, field_id, water_amount_liters, irrigation_status, irrigation_date)
            VALUES (irrigation_control_seq.NEXTVAL, field_id, 0, 'OFF', SYSDATE);
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error controlling irrigation: ' || SQLERRM);
            ROLLBACK;
    END control_irrigation;

END irrigation_pkg;
/

-- 3.  Package: Livestock Management

-- Specification

CREATE OR REPLACE PACKAGE livestock_pkg AS
    PROCEDURE monitor_livestock(animal_id IN NUMBER);
    FUNCTION is_livestock_healthy(animal_id IN NUMBER) RETURN VARCHAR2;
END livestock_pkg;
/

Body
CREATE OR REPLACE PACKAGE BODY livestock_pkg AS

    PROCEDURE monitor_livestock(animal_id IN NUMBER) IS
        v_temp NUMBER;
        v_health VARCHAR2(20);
    BEGIN
        SELECT body_temp
        INTO v_temp
        FROM livestock_tracking
        WHERE animal_id = animal_id
        ORDER BY recorded_date DESC
        FETCH FIRST 1 ROWS ONLY;

        IF v_temp BETWEEN 36 AND 39 THEN
            v_health := 'Healthy';
        ELSE
            v_health := 'Sick';
        END IF;

        UPDATE livestock
        SET health_status = v_health
        WHERE animal_id = animal_id;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error monitoring livestock: ' || SQLERRM);
            ROLLBACK;
    END monitor_livestock;

    FUNCTION is_livestock_healthy(animal_id IN NUMBER) RETURN VARCHAR2 IS
        v_status VARCHAR2(20);
    BEGIN
        SELECT health_status
        INTO v_status
        FROM livestock
        WHERE animal_id = animal_id;
        RETURN v_status;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error checking livestock: ' || SQLERRM);
            RETURN 'Unknown';
    END is_livestock_healthy;

END livestock_pkg;
/

tests:


--- 1. Package: Sensor Management

-- Specification

CREATE OR REPLACE PACKAGE sensor_pkg AS
    PROCEDURE record_sensor(sensor_id IN NUMBER, value IN NUMBER);
    FUNCTION get_avg_moisture(field_id IN NUMBER) RETURN NUMBER;
END sensor_pkg;
/

Body
CREATE OR REPLACE PACKAGE BODY sensor_pkg AS

    PROCEDURE record_sensor(sensor_id IN NUMBER, value IN NUMBER) IS
    BEGIN
        INSERT INTO sensor_readings(reading_id, sensor_id, reading_value, reading_date)
        VALUES (sensor_readings_seq.NEXTVAL, sensor_id, value, SYSDATE);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error recording sensor: ' || SQLERRM);
            ROLLBACK;
    END record_sensor;

    FUNCTION get_avg_moisture(field_id IN NUMBER) RETURN NUMBER IS
        v_avg NUMBER;
    BEGIN
        SELECT AVG(sr.reading_value)
        INTO v_avg
        FROM sensors s
        JOIN sensor_readings sr ON s.sensor_id = sr.sensor_id
        WHERE s.farm_id = (SELECT farm_id FROM crop_fields WHERE field_id = field_id)
          AND s.sensor_type = 'Moisture';
        RETURN v_avg;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error calculating avg moisture: ' || SQLERRM);
            RETURN NULL;
    END get_avg_moisture;

END sensor_pkg;
/

--- 2. Package: Irrigation Management

--- Specification

CREATE OR REPLACE PACKAGE irrigation_pkg AS
    PROCEDURE control_irrigation(field_id IN NUMBER);
END irrigation_pkg;
/

Body
CREATE OR REPLACE PACKAGE BODY irrigation_pkg AS

    PROCEDURE control_irrigation(field_id IN NUMBER) IS
        v_avg_moisture NUMBER;
    BEGIN
        SELECT AVG(sr.reading_value)
        INTO v_avg_moisture
        FROM sensors s
        JOIN sensor_readings sr ON s.sensor_id = sr.sensor_id
        WHERE s.farm_id = (SELECT farm_id FROM crop_fields WHERE field_id = field_id)
          AND s.sensor_type = 'Moisture';

        IF v_avg_moisture < 30 THEN
            INSERT INTO irrigation_control(irrigation_id, field_id, water_amount_liters, irrigation_status, irrigation_date)
            VALUES (irrigation_control_seq.NEXTVAL, field_id, 500, 'ON', SYSDATE);
        ELSE
            INSERT INTO irrigation_control(irrigation_id, field_id, water_amount_liters, irrigation_status, irrigation_date)
            VALUES (irrigation_control_seq.NEXTVAL, field_id, 0, 'OFF', SYSDATE);
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error controlling irrigation: ' || SQLERRM);
            ROLLBACK;
    END control_irrigation;

END irrigation_pkg;
/

--- 4. Package: Livestock Management

--- Specification

CREATE OR REPLACE PACKAGE livestock_pkg AS
    PROCEDURE monitor_livestock(animal_id IN NUMBER);
    FUNCTION is_livestock_healthy(animal_id IN NUMBER) RETURN VARCHAR2;
END livestock_pkg;
/

Body
CREATE OR REPLACE PACKAGE BODY livestock_pkg AS

    PROCEDURE monitor_livestock(animal_id IN NUMBER) IS
        v_temp NUMBER;
        v_health VARCHAR2(20);
    BEGIN
        SELECT body_temp
        INTO v_temp
        FROM livestock_tracking
        WHERE animal_id = animal_id
        ORDER BY recorded_date DESC
        FETCH FIRST 1 ROWS ONLY;

        IF v_temp BETWEEN 36 AND 39 THEN
            v_health := 'Healthy';
        ELSE
            v_health := 'Sick';
        END IF;

        UPDATE livestock
        SET health_status = v_health
        WHERE animal_id = animal_id;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error monitoring livestock: ' || SQLERRM);
            ROLLBACK;
    END monitor_livestock;

    FUNCTION is_livestock_healthy(animal_id IN NUMBER) RETURN VARCHAR2 IS
        v_status VARCHAR2(20);
    BEGIN
        SELECT health_status
        INTO v_status
        FROM livestock
        WHERE animal_id = animal_id;
        RETURN v_status;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error checking livestock: ' || SQLERRM);
            RETURN 'Unknown';
    END is_livestock_healthy;

END livestock_pkg;
/