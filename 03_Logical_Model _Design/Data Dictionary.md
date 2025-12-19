## **# Data Dictionary**

## 

## **\*\*Project:\*\* IoT-Based Smart Agriculture Management System**  

## 

## **---**

## 

## **## 1. FARMS**

## 

## **| Column Name | Data Type | Constraints | Description |**

## **|------------|----------|-------------|-------------|**

## **| farm\_id | NUMBER(6) | PK, NOT NULL | Unique identifier for each farm |**

## **| farm\_name | VARCHAR2(60) | NOT NULL | Name of the farm |**

## **| location | VARCHAR2(60) | | Physical location of the farm |**

## **| farm\_type | VARCHAR2(30) | CHECK (farm\_type IN ('Crop','Livestock','Greenhouse')) | Type of farming practiced |**

## 

## **---**

## 

## **## 2. CROP\_FIELDS**

## 

## **| Column Name | Data Type | Constraints | Description |**

## **|------------|----------|-------------|-------------|**

## **| field\_id | NUMBER(6) | PK, NOT NULL | Unique crop field identifier |**

## **| farm\_id | NUMBER(6) | FK, REFERENCES farms(farm\_id) | Farm owning the field |**

## **| crop\_type | VARCHAR2(40) | NOT NULL | Type of crop planted |**

## **| planting\_date | DATE | | Date the crop was planted |**

## 

## **---**

## 

## **## 3. SENSORS**

## 

## **| Column Name | Data Type | Constraints | Description |**

## **|------------|----------|-------------|-------------|**

## **| sensor\_id | NUMBER(8) | PK, NOT NULL | Unique sensor identifier |**

## **| farm\_id | NUMBER(6) | FK, REFERENCES farms(farm\_id) | Farm where sensor is installed |**

## **| sensor\_type | VARCHAR2(30) | CHECK (sensor\_type IN ('Moisture','Temperature','Humidity','Pest')) | Type of sensor |**

## **| status | VARCHAR2(20) | CHECK (status IN ('Active','Inactive')) | Operational status |**

## 

## **---**

## 

## **## 4. SENSOR\_READINGS**

## 

## **| Column Name | Data Type | Constraints | Description |**

## **|------------|----------|-------------|-------------|**

## **| reading\_id | NUMBER(10) | PK, NOT NULL | Unique reading identifier |**

## **| sensor\_id | NUMBER(8) | FK, REFERENCES sensors(sensor\_id) | Sensor that recorded the value |**

## **| reading\_value | NUMBER(10,2) | NOT NULL | Sensor reading value |**

## **| reading\_date | DATE | DEFAULT SYSDATE | Date and time of reading |**

## 

## **---**

## 

## **## 5. IRRIGATION\_CONTROL**

## 

## **| Column Name | Data Type | Constraints | Description |**

## **|------------|----------|-------------|-------------|**

## **| irrigation\_id | NUMBER(8) | PK, NOT NULL | Irrigation record identifier |**

## **| field\_id | NUMBER(6) | FK, REFERENCES crop\_fields(field\_id) | Field irrigated |**

## **| water\_amount\_liters | NUMBER(10,2) | CHECK (water\_amount\_liters ≥ 0) | Amount of water used |**

## **| irrigation\_status | VARCHAR2(10) | CHECK (irrigation\_status IN ('ON','OFF')) | Irrigation state |**

## **| irrigation\_date | DATE | DEFAULT SYSDATE | Date of irrigation |**

## 

## **---**

## 

## **## 6. LIVESTOCK**

## 

## **| Column Name | Data Type | Constraints | Description |**

## **|------------|----------|-------------|-------------|**

## **| animal\_id | NUMBER(6) | PK, NOT NULL | Unique livestock identifier |**

## **| farm\_id | NUMBER(6) | FK, REFERENCES farms(farm\_id) | Farm owning the animal |**

## **| animal\_type | VARCHAR2(30) | NOT NULL | Type of animal |**

## **| health\_status | VARCHAR2(20) | CHECK (health\_status IN ('Healthy','Sick')) | Current health state |**

## 

## **---**

## 

## **## 7. LIVESTOCK\_TRACKING**

## 

## **| Column Name | Data Type | Constraints | Description |**

## **|------------|----------|-------------|-------------|**

## **| tracking\_id | NUMBER(10) | PK, NOT NULL | Tracking record identifier |**

## **| animal\_id | NUMBER(6) | FK, REFERENCES livestock(animal\_id) | Tracked animal |**

## **| body\_temp | NUMBER(5,2) | CHECK (body\_temp BETWEEN 30 AND 45) | Body temperature |**

## **| location | VARCHAR2(60) | | Current animal location |**

## **| recorded\_date | DATE | DEFAULT SYSDATE | Date of tracking |**

## 

## **---**

## 

## **## 8. GREENHOUSE\_CONTROL**

## 

## **| Column Name | Data Type | Constraints | Description |**

## **|------------|----------|-------------|-------------|**

## **| greenhouse\_id | NUMBER(6) | PK, NOT NULL | Greenhouse control record |**

## **| farm\_id | NUMBER(6) | FK, REFERENCES farms(farm\_id) | Related farm |**

## **| temperature | NUMBER(5,2) | | Greenhouse temperature |**

## **| humidity | NUMBER(5,2) | | Greenhouse humidity |**

## **| light\_status | VARCHAR2(10) | CHECK (light\_status IN ('ON','OFF')) | Lighting status |**

## **| recorded\_date | DATE | DEFAULT SYSDATE | Date recorded |**

## 

## **---**

## 

## **## Assumptions**

## 

## **- All sensor data is \*\*simulated\*\* at the database level (no physical IoT devices).**

## **- Each sensor measures \*\*only one sensor type\*\*.**

## **- A farm can have \*\*multiple crop fields, sensors, livestock, and greenhouses\*\*.**

## **- Historical records (sensor readings, irrigation, livestock tracking) are \*\*never deleted\*\*.**

## **- \*\*Oracle Database and PL/SQL\*\* are used as the implementation platform.**

## **- Default date values use \*\*SYSDATE\*\* to ensure auditability.**



