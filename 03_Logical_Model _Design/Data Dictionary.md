# Data Dictionary

**Project:** IoT-Based Smart Agriculture Management System  

---

## 1. FARMS

| Column Name | Data Type | Constraints | Description |
|------------|----------|-------------|-------------|
| farm_id | NUMBER(6) | PK, NOT NULL | Unique identifier for each farm |
| farm_name | VARCHAR2(60) | NOT NULL | Name of the farm |
| location | VARCHAR2(60) | | Physical location of the farm |
| farm_type | VARCHAR2(30) | CHECK (farm_type IN ('Crop','Livestock','Greenhouse')) | Type of farming practiced |

---

## 2. CROP_FIELDS

| Column Name | Data Type | Constraints | Description |
|------------|----------|-------------|-------------|
| field_id | NUMBER(6) | PK, NOT NULL | Unique crop field identifier |
| farm_id | NUMBER(6) | FK, REFERENCES farms(farm_id) | Farm owning the field |
| crop_type | VARCHAR2(40) | NOT NULL | Type of crop planted |
| planting_date | DATE | | Date the crop was planted |

---

## 3. SENSORS

| Column Name | Data Type | Constraints | Description |
|------------|----------|-------------|-------------|
| sensor_id | NUMBER(8) | PK, NOT NULL | Unique sensor identifier |
| farm_id | NUMBER(6) | FK, REFERENCES farms(farm_id) | Farm where sensor is installed |
| sensor_type | VARCHAR2(30) | CHECK (sensor_type IN ('Moisture','Temperature','Humidity','Pest')) | Type of sensor |
| status | VARCHAR2(20) | CHECK (status IN ('Active','Inactive')) | Operational status |

---

## 4. SENSOR_READINGS

| Column Name | Data Type | Constraints | Description |
|------------|----------|-------------|-------------|
| reading_id | NUMBER(10) | PK, NOT NULL | Unique reading identifier |
| sensor_id | NUMBER(8) | FK, REFERENCES sensors(sensor_id) | Sensor that recorded the value |
| reading_value | NUMBER(10,2) | NOT NULL | Sensor reading value |
| reading_date | DATE | DEFAULT SYSDATE | Date and time of reading |

---

## 5. IRRIGATION_CONTROL

| Column Name | Data Type | Constraints | Description |
|------------|----------|-------------|-------------|
| irrigation_id | NUMBER(8) | PK, NOT NULL | Irrigation record identifier |
| field_id | NUMBER(6) | FK, REFERENCES crop_fields(field_id) | Field irrigated |
| water_amount_liters | NUMBER(10,2) | CHECK (water_amount_liters ≥ 0) | Amount of water used |
| irrigation_status | VARCHAR2(10) | CHECK (irrigation_status IN ('ON','OFF')) | Irrigation state |
| irrigation_date | DATE | DEFAULT SYSDATE | Date of irrigation |

---

## 6. LIVESTOCK

| Column Name | Data Type | Constraints | Description |
|------------|----------|-------------|-------------|
| animal_id | NUMBER(6) | PK, NOT NULL | Unique livestock identifier |
| farm_id | NUMBER(6) | FK, REFERENCES farms(farm_id) | Farm owning the animal |
| animal_type | VARCHAR2(30) | NOT NULL | Type of animal |
| health_status | VARCHAR2(20) | CHECK (health_status IN ('Healthy','Sick')) | Current health state |

---

## 7. LIVESTOCK_TRACKING

| Column Name | Data Type | Constraints | Description |
|------------|----------|-------------|-------------|
| tracking_id | NUMBER(10) | PK, NOT NULL | Tracking record identifier |
| animal_id | NUMBER(6) | FK, REFERENCES livestock(animal_id) | Tracked animal |
| body_temp | NUMBER(5,2) | CHECK (body_temp BETWEEN 30 AND 45) | Body temperature |
| location | VARCHAR2(60) | | Current animal location |
| recorded_date | DATE | DEFAULT SYSDATE | Date of tracking |

---

## 8. GREENHOUSE_CONTROL

| Column Name | Data Type | Constraints | Description |
|------------|----------|-------------|-------------|
| greenhouse_id | NUMBER(6) | PK, NOT NULL | Greenhouse control record |
| farm_id | NUMBER(6) | FK, REFERENCES farms(farm_id) | Related farm |
| temperature | NUMBER(5,2) | | Greenhouse temperature |
| humidity | NUMBER(5,2) | | Greenhouse humidity |
| light_status | VARCHAR2(10) | CHECK (light_status IN ('ON','OFF')) | Lighting status |
| recorded_date | DATE | DEFAULT SYSDATE | Date recorded |

---

## Assumptions

- All sensor data is **simulated** at the database level (no physical IoT devices).
- Each sensor measures **only one sensor type**.
- A farm can have **multiple crop fields, sensors, livestock, and greenhouses**.
- Historical records (sensor readings, irrigation, livestock tracking) are **never deleted**.
- **Oracle Database and PL/SQL** are used as the implementation platform.
- Default date values use **SYSDATE** to ensure auditability.
