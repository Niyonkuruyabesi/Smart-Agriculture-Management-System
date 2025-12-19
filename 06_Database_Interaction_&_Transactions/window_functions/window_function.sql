-- 1.  RANK() — Rank Fields by Average Moisture

SELECT 
    cf.field_id,
    cf.crop_type,
    ROUND(AVG(sr.reading_value),2) AS avg_moisture,
    RANK() OVER (PARTITION BY cf.crop_type ORDER BY AVG(sr.reading_value) DESC) AS moisture_rank
FROM crop_fields cf
JOIN sensors s ON cf.farm_id = s.farm_id
JOIN sensor_readings sr ON s.sensor_id = sr.sensor_id
WHERE s.sensor_type = 'Moisture'
GROUP BY cf.field_id, cf.crop_type
ORDER BY cf.crop_type, moisture_rank;


--- Explanation:

--- I. Assigns a rank to each field based on average moisture within the same crop type.
--- II. Ties get the same rank; the next rank is skipped.

-- 2.  DENSE_RANK() — Dense Ranking Fields by Average Moisture

SELECT 
    cf.field_id,
    cf.crop_type,
    ROUND(AVG(sr.reading_value),2) AS avg_moisture,
    DENSE_RANK() OVER (PARTITION BY cf.crop_type ORDER BY AVG(sr.reading_value) DESC) AS dense_moisture_rank
FROM crop_fields cf
JOIN sensors s ON cf.farm_id = s.farm_id
JOIN sensor_readings sr ON s.sensor_id = sr.sensor_id
WHERE s.sensor_type = 'Moisture'
GROUP BY cf.field_id, cf.crop_type
ORDER BY cf.crop_type, dense_moisture_rank;


 --- Explanation:

--- Similar to RANK(), but does not skip numbers for ties.

-- 3. ROW_NUMBER() — Unique Ranking of Fields

SELECT 
    cf.field_id,
    cf.crop_type,
    ROUND(AVG(sr.reading_value),2) AS avg_moisture,
    ROW_NUMBER() OVER (PARTITION BY cf.crop_type ORDER BY AVG(sr.reading_value) DESC) AS row_number_rank
FROM crop_fields cf
JOIN sensors s ON cf.farm_id = s.farm_id
JOIN sensor_readings sr ON s.sensor_id = sr.sensor_id
WHERE s.sensor_type = 'Moisture'
GROUP BY cf.field_id, cf.crop_type
ORDER BY cf.crop_type, row_number_rank;


--- Explanation:

-- I. Assigns a unique sequential number to each row.

-- II. Even tied values get different numbers.

--- 4.  LAG() — Compare Current Moisture With Previous Reading

SELECT 
    s.sensor_id,
    sr.reading_date,
    sr.reading_value,
    LAG(sr.reading_value,1) OVER (PARTITION BY s.sensor_id ORDER BY sr.reading_date) AS prev_reading
FROM sensors s
JOIN sensor_readings sr ON s.sensor_id = sr.sensor_id
WHERE s.sensor_type = 'Moisture'
ORDER BY s.sensor_id, sr.reading_date;


--- Explanation:

-- 1. LAG() gives the previous reading for the same sensor.

-- 2. Helpful to see increases/decreases in moisture over time.

-- 5. LEAD() — Compare Current Moisture With Next Reading

SELECT 
    s.sensor_id,
    sr.reading_date,
    sr.reading_value,
    LEAD(sr.reading_value,1) OVER (PARTITION BY s.sensor_id ORDER BY sr.reading_date) AS next_reading
FROM sensors s
JOIN sensor_readings sr ON s.sensor_id = sr.sensor_id
WHERE s.sensor_type = 'Moisture'
ORDER BY s.sensor_id, sr.reading_date;


--- Explanation:

--- I. LEAD() gives the next reading for the same sensor.

--- II. Useful for forecasting or trend analysis.

-- 6. Aggregate with OVER() — Running Total of Water per Field

SELECT 
    field_id,
    irrigation_date,
    water_amount_liters,
    SUM(water_amount_liters) OVER (PARTITION BY field_id ORDER BY irrigation_date) AS cumulative_water
FROM irrigation_control
ORDER BY field_id, irrigation_date;


--- Explanation:

--- I. Computes a running total of water applied to each field.

--- II. The PARTITION BY field_id keeps totals separate per field.