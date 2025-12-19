--1.  Cursor: Loop Through All Fields for Moisture Alerts

DECLARE
    v_field_id NUMBER;
    v_crop_type VARCHAR2(40);
    v_avg_moisture NUMBER;
    
    CURSOR c_moisture IS
        SELECT field_id, crop_type, AVG(reading_value) AS avg_moisture
        FROM crop_fields cf
        JOIN sensors s ON cf.farm_id = s.farm_id
        JOIN sensor_readings sr ON s.sensor_id = sr.sensor_id
        WHERE s.sensor_type = 'Moisture'
        GROUP BY cf.field_id, cf.crop_type;
BEGIN
    OPEN c_moisture;
    LOOP
        FETCH c_moisture INTO v_field_id, v_crop_type, v_avg_moisture;
        EXIT WHEN c_moisture%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Field ' || v_field_id || ' (' || v_crop_type || ') avg moisture: ' || v_avg_moisture);
    END LOOP;
    CLOSE c_moisture;
END;
/



--- Explanation:

--- I. Cursor retrieves average moisture per field.

--- II. Loops through each field and checks if moisture < 30 (example threshold).


--- 2. Cursor: Monitor Livestock Temperature

SET SERVEROUTPUT ON;

DECLARE
    v_animal_id   NUMBER;
    v_animal_type VARCHAR2(30);
    v_farm_id     NUMBER;
    
    CURSOR c_livestock IS
        SELECT animal_id, animal_type, farm_id
        FROM livestock
        WHERE health_status = 'Sick';
BEGIN
    OPEN c_livestock;
    LOOP
        FETCH c_livestock INTO v_animal_id, v_animal_type, v_farm_id;
        EXIT WHEN c_livestock%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Animal ' || v_animal_id || ' (' || v_animal_type || ') in farm ' || v_farm_id || ' is sick.');
    END LOOP;
    CLOSE c_livestock;
END;
/


--- Explanation:

--- I. Checks all animals’ body temperatures.

--- II. Flags abnormal readings (<36 or >39).




-- 3. Cursor with Bulk Processing: Update Greenhouse Status


SET SERVEROUTPUT ON;

DECLARE
    TYPE greenhouse_tab IS TABLE OF greenhouse_control%ROWTYPE;
    v_greenhouses greenhouse_tab;

BEGIN
    -- Bulk collect greenhouse data
    SELECT * BULK COLLECT INTO v_greenhouses
    FROM greenhouse_control
    WHERE temperature > 30;

    -- Loop through bulk collection
    FOR i IN 1 .. v_greenhouses.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Greenhouse ' || v_greenhouses(i).greenhouse_id || 
                             ' temp ' || v_greenhouses(i).temperature || 
                             ' exceeds threshold, turning lights OFF.');
                             
        -- Example update: turn off lights if too hot
        UPDATE greenhouse_control
        SET light_status = 'OFF'
        WHERE greenhouse_id = v_greenhouses(i).greenhouse_id;
    END LOOP;

    COMMIT;
END;
/


--- Explanation:

--- I. Uses bulk collect for optimization.

--- II. Loops through collection and updates greenhouse light status based on temperature threshold.