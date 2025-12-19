-- 1. Farms Table
CREATE TABLE farms (
    farm_id NUMBER(6) PRIMARY KEY,
    farm_name VARCHAR2(60) NOT NULL,
    location VARCHAR2(60) NOT NULL,
    farm_type VARCHAR2(30) NOT NULL
        CONSTRAINT chk_farm_type CHECK (farm_type IN ('Crop','Livestock','Greenhouse'))
);

-- 2. Crop Fields Table
CREATE TABLE crop_fields (
    field_id NUMBER(6) PRIMARY KEY,
    farm_id NUMBER(6) NOT NULL REFERENCES farms(farm_id) ON DELETE CASCADE,
    crop_type VARCHAR2(40) NOT NULL,
    planting_date DATE DEFAULT SYSDATE NOT NULL
);

-- 3. Sensors Table
CREATE TABLE sensors (
    sensor_id NUMBER(8) PRIMARY KEY,
    farm_id NUMBER(6) NOT NULL REFERENCES farms(farm_id) ON DELETE CASCADE,
    sensor_type VARCHAR2(30) NOT NULL
        CONSTRAINT chk_sensor_type CHECK (sensor_type IN ('Moisture','Temp','Humidity','Pest')),
    status VARCHAR2(20) DEFAULT 'Active' NOT NULL
        CONSTRAINT chk_sensor_status CHECK (status IN ('Active','Inactive'))
);

-- 4. Sensor Readings Table
CREATE TABLE sensor_readings (
    reading_id NUMBER(10) PRIMARY KEY,
    sensor_id NUMBER(8) NOT NULL REFERENCES sensors(sensor_id) ON DELETE CASCADE,
    reading_value NUMBER(10,2) NOT NULL,
    reading_date DATE DEFAULT SYSDATE NOT NULL
);

-- 5. Irrigation Control Table
CREATE TABLE irrigation_control (
    irrigation_id NUMBER(8) PRIMARY KEY,
    field_id NUMBER(6) NOT NULL REFERENCES crop_fields(field_id) ON DELETE CASCADE,
    water_amount_liters NUMBER(10,2) DEFAULT 0 NOT NULL,
    irrigation_status VARCHAR2(10) DEFAULT 'OFF' NOT NULL
        CONSTRAINT chk_irrigation_status CHECK (irrigation_status IN ('ON','OFF')),
    irrigation_date DATE DEFAULT SYSDATE NOT NULL
);

-- 6. Livestock Table
CREATE TABLE livestock (
    animal_id NUMBER(6) PRIMARY KEY,
    farm_id NUMBER(6) NOT NULL REFERENCES farms(farm_id) ON DELETE CASCADE,
    animal_type VARCHAR2(30) NOT NULL
        CONSTRAINT chk_animal_type CHECK (animal_type IN ('Cow','Goat','Sheep')),
    health_status VARCHAR2(20) DEFAULT 'Healthy' NOT NULL
        CONSTRAINT chk_health_status CHECK (health_status IN ('Healthy','Sick'))
);

-- 7. Livestock Tracking Table
CREATE TABLE livestock_tracking (
    tracking_id NUMBER(10) PRIMARY KEY,
    animal_id NUMBER(6) NOT NULL REFERENCES livestock(animal_id) ON DELETE CASCADE,
    body_temp NUMBER(5,2) NOT NULL
        CONSTRAINT chk_body_temp CHECK (body_temp BETWEEN 35 AND 42),
    location VARCHAR2(60) NOT NULL,
    recorded_date DATE DEFAULT SYSDATE NOT NULL
);

-- 8. Greenhouse Control Table
CREATE TABLE greenhouse_control (
    greenhouse_id NUMBER(6) PRIMARY KEY,
    farm_id NUMBER(6) NOT NULL REFERENCES farms(farm_id) ON DELETE CASCADE,
    temperature NUMBER(5,2) NOT NULL
        CONSTRAINT chk_temperature CHECK (temperature BETWEEN 10 AND 50),
    humidity NUMBER(5,2) NOT NULL
        CONSTRAINT chk_humidity CHECK (humidity BETWEEN 0 AND 100),
    light_status VARCHAR2(10) DEFAULT 'OFF' NOT NULL
        CONSTRAINT chk_light_status CHECK (light_status IN ('ON','OFF')),
    recorded_date DATE DEFAULT SYSDATE NOT NULL
);

-- 9. Indexes
CREATE INDEX idx_crop_fields_farm ON crop_fields(farm_id);
CREATE INDEX idx_sensor_readings_sensor ON sensor_readings(sensor_id);
CREATE INDEX idx_livestock_farm ON livestock(farm_id);
