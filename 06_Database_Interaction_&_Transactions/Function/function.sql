-- 1. Function: Calculate Average Soil Moisture for a Field

CREATE OR REPLACE FUNCTION get_avg_moisture(p_field_id IN NUMBER)
RETURN NUMBER
IS
    v_avg NUMBER;
BEGIN
    SELECT AVG(sr.reading_value)
    INTO v_avg
    FROM sensor_readings sr
    JOIN sensors s ON sr.sensor_id = s.sensor_id
    JOIN crop_fields cf ON s.farm_id = cf.farm_id
    WHERE cf.field_id = p_field_id AND s.sensor_type = 'Moisture';

    RETURN v_avg;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RETURN NULL;
END;
/


-- Usage Example:

SELECT get_avg_moisture(101) AS avg_moisture FROM dual;

-- 2. Function: Validate Livestock Body Temperature

CREATE OR REPLACE FUNCTION is_temp_normal(p_body_temp IN NUMBER)
RETURN VARCHAR2
IS
BEGIN
    IF p_body_temp BETWEEN 36 AND 39 THEN
        RETURN 'Normal';
    ELSE
        RETURN 'Abnormal';
    END IF;
END;
/


-- Usage Example:

SELECT animal_id, is_temp_normal(body_temp) AS temp_status
FROM livestock_tracking
WHERE animal_id = 3001;

-- 3. Function: Lookup Crop Type by Field ID

CREATE OR REPLACE FUNCTION get_crop_type(p_field_id IN NUMBER)
RETURN VARCHAR2
IS
    v_crop VARCHAR2(50);
BEGIN
    SELECT crop_type
    INTO v_crop
    FROM crop_fields
    WHERE field_id = p_field_id;

    RETURN v_crop;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Unknown';
END;
/


-- Usage Example:

SELECT get_crop_type(101) AS crop FROM dual;

-- 4. Function: Check Greenhouse Light Status

CREATE OR REPLACE FUNCTION is_greenhouse_light_on(p_greenhouse_id IN NUMBER)
RETURN VARCHAR2
IS
    v_status VARCHAR2(10);
BEGIN
    SELECT light_status
    INTO v_status
    FROM greenhouse_control
    WHERE greenhouse_id = p_greenhouse_id;

    RETURN v_status;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Unknown';
END;
/


-- Usage Example:

SELECT is_greenhouse_light_on(6001) AS light_status FROM dual;

-- 5. Function: Calculate Total Irrigation Water for a Field

CREATE OR REPLACE FUNCTION total_water_used(p_field_id IN NUMBER)
RETURN NUMBER
IS
    v_total NUMBER;
BEGIN
    SELECT SUM(water_amount_liters)
    INTO v_total
    FROM irrigation_control
    WHERE field_id = p_field_id;

    RETURN NVL(v_total, 0);
END;
/


-- Usage Example:

SELECT total_water_used(101) AS total_water FROM dual;








-- 1. Test get_avg_moisture
SET SERVEROUTPUT ON;

DECLARE
    v_avg_moisture NUMBER;
BEGIN
    -- Test for Field 101
    v_avg_moisture := get_avg_moisture(101);
    DBMS_OUTPUT.PUT_LINE('Average moisture for Field 101: ' || NVL(TO_CHAR(v_avg_moisture), 'No data'));

    -- Test for Field 102
    v_avg_moisture := get_avg_moisture(102);
    DBMS_OUTPUT.PUT_LINE('Average moisture for Field 102: ' || NVL(TO_CHAR(v_avg_moisture), 'No data'));
END;
/



-- 2. Test is_temp_normal
SET SERVEROUTPUT ON;

DECLARE
    v_temp_status VARCHAR2(10);
BEGIN
    -- Test for body temperature 38.0 (normal)
    v_temp_status := is_temp_normal(38.0);
    DBMS_OUTPUT.PUT_LINE('Body temp 38.0: ' || v_temp_status);

    -- Test for body temperature 40.0 (abnormal)
    v_temp_status := is_temp_normal(40.0);
    DBMS_OUTPUT.PUT_LINE('Body temp 40.0: ' || v_temp_status);
END;
/




-- 3. Test get_crop_type
SET SERVEROUTPUT ON;

DECLARE
    v_crop VARCHAR2(50);
BEGIN
    -- Test for Field 101
    v_crop := get_crop_type(101);
    DBMS_OUTPUT.PUT_LINE('Crop type for Field 101: ' || v_crop);

    -- Test for Field 102
    v_crop := get_crop_type(102);
    DBMS_OUTPUT.PUT_LINE('Crop type for Field 102: ' || v_crop);
END;
/




-- 4. Test is_greenhouse_light_on
SET SERVEROUTPUT ON;

DECLARE
    v_light_status VARCHAR2(10);
BEGIN
    -- Test for Greenhouse 6001
    v_light_status := is_greenhouse_light_on(6001);
    DBMS_OUTPUT.PUT_LINE('Greenhouse 6001 light status: ' || v_light_status);

    -- Test for Greenhouse 6002
    v_light_status := is_greenhouse_light_on(6002);
    DBMS_OUTPUT.PUT_LINE('Greenhouse 6002 light status: ' || v_light_status);
END;
/




-- 5. Test total_water_used
SET SERVEROUTPUT ON;

DECLARE
    v_total_water NUMBER;
BEGIN
    -- Test for Field 101
    v_total_water := total_water_used(101);
    DBMS_OUTPUT.PUT_LINE('Total irrigation water for Field 101: ' || v_total_water || ' liters');

    -- Test for Field 102
    v_total_water := total_water_used(102);
    DBMS_OUTPUT.PUT_LINE('Total irrigation water for Field 102: ' || v_total_water || ' liters');
END;
/