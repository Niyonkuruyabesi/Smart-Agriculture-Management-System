1. Basic Retrieval (SELECT all rows)

-- Farms
SELECT * FROM farms;

-- Crop Fields
SELECT * FROM crop_fields;

-- Sensors
SELECT * FROM sensors;

-- Sensor Readings
SELECT * FROM sensor_readings;

-- Irrigation Control
SELECT * FROM irrigation_control;

-- Livestock
SELECT * FROM livestock;

-- Livestock Tracking
SELECT * FROM livestock_tracking;

-- Greenhouse Control
SELECT * FROM greenhouse_control;


2.Verify Constraints & Foreign Key Relationships

--Foreign Key Checks

-- Crop fields reference valid farms
SELECT cf.*
FROM crop_fields cf
LEFT JOIN farms f ON cf.farm_id = f.farm_id
WHERE f.farm_id IS NULL;

-- Sensors reference valid farms
SELECT s.*
FROM sensors s
LEFT JOIN farms f ON s.farm_id = f.farm_id
WHERE f.farm_id IS NULL;

-- Sensor readings reference valid sensors
SELECT sr.*
FROM sensor_readings sr
LEFT JOIN sensors s ON sr.sensor_id = s.sensor_id
WHERE s.sensor_id IS NULL;

-- Irrigation control reference valid crop fields
SELECT ic.*
FROM irrigation_control ic
LEFT JOIN crop_fields cf ON ic.field_id = cf.field_id
WHERE cf.field_id IS NULL;

-- Livestock reference valid farms
SELECT l.*
FROM livestock l
LEFT JOIN farms f ON l.farm_id = f.farm_id
WHERE f.farm_id IS NULL;

-- Livestock tracking reference valid animals
SELECT lt.*
FROM livestock_tracking lt
LEFT JOIN livestock l ON lt.animal_id = l.animal_id
WHERE l.animal_id IS NULL;

-- Greenhouse control reference valid farms
SELECT gc.*
FROM greenhouse_control gc
LEFT JOIN farms f ON gc.farm_id = f.farm_id
WHERE f.farm_id IS NULL;


--Check NOT NULL and UNIQUE constraints

-- Check for NULLs
SELECT * FROM farms WHERE farm_name IS NULL OR location IS NULL;
SELECT * FROM sensors WHERE sensor_type IS NULL OR status IS NULL;
SELECT * FROM livestock WHERE animal_type IS NULL OR health_status IS NULL;

-- Check for duplicate primary keys
SELECT farm_id, COUNT(*) FROM farms GROUP BY farm_id HAVING COUNT(*) > 1;
SELECT sensor_id, COUNT(*) FROM sensors GROUP BY sensor_id HAVING COUNT(*) > 1;
SELECT animal_id, COUNT(*) FROM livestock GROUP BY animal_id HAVING COUNT(*) > 1;




3. Multi-table Joins

3.1 Crop fields with farms

SELECT cf.field_id, cf.crop_type, cf.planting_date, f.farm_name, f.location
FROM crop_fields cf
JOIN farms f ON cf.farm_id = f.farm_id;


3.2 Sensor readings with farms and sensors

SELECT sr.reading_id, sr.reading_value, sr.reading_date, s.sensor_type, f.farm_name
FROM sensor_readings sr
JOIN sensors s ON sr.sensor_id = s.sensor_id
JOIN farms f ON s.farm_id = f.farm_id;


3.3 Livestock tracking with animal and farm

SELECT lt.tracking_id, lt.body_temp, lt.location, lt.recorded_date,
       l.animal_type, l.health_status, f.farm_name
FROM livestock_tracking lt
JOIN livestock l ON lt.animal_id = l.animal_id
JOIN farms f ON l.farm_id = f.farm_id;


3.4 Irrigation with crop fields and farms

SELECT ic.irrigation_id, ic.water_amount_liters, ic.irrigation_status, ic.irrigation_date,
       cf.crop_type, f.farm_name
FROM irrigation_control ic
JOIN crop_fields cf ON ic.field_id = cf.field_id
JOIN farms f ON cf.farm_id = f.farm_id;


4.  Aggregations (GROUP BY)

4.1 Count crops per farm

SELECT f.farm_name, COUNT(cf.field_id) AS total_fields
FROM farms f
JOIN crop_fields cf ON f.farm_id = cf.farm_id
GROUP BY f.farm_name;

4.2 Average sensor reading by type

SELECT s.sensor_type, AVG(sr.reading_value) AS avg_value
FROM sensors s
JOIN sensor_readings sr ON s.sensor_id = sr.sensor_id
GROUP BY s.sensor_type;

4.3 Number of animals per health status

SELECT health_status, COUNT(*) AS num_animals
FROM livestock
GROUP BY health_status;



