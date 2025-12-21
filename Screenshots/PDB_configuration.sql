CREATE PLUGGABLE DATABASE tues_27715_yabesi_smartAgriDB
ADMIN USER admin_yabesi IDENTIFIED BY Yabesi
ROLES = (DBA)
DEFAULT TABLESPACE AGRI_DATA_TBS
FILE_NAME_CONVERT = ('C:\app\niyon\product\21c\oradata\XE\pdbseed',
                     'C:\app\niyon\product\21c\oradata\XE\tues_27715_yabesi_smartAgriDB');

-- 2. Connect to the new PDB
ALTER SESSION SET CONTAINER = tues_27715_yabesi_smartAgriDB;

ALTER PLUGGABLE DATABASE tues_27715_yabesi_smartAgriDB OPEN;

ALTER PLUGGABLE DATABASE tues_27715_yabesi_smartAgriDB SAVE STATE;



-- 3. Create Tablespaces for data
CREATE TABLESPACE AGRI_DATA_TBS
DATAFILE 'C:\app\niyon\product\21c\oradata\XE\tues_27715_yabesi_smartAgriDB\agri_data01.dbf'
SIZE 100M AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED;

-- 3. Create Tablespaces for index

CREATE TABLESPACE AGRI_IDX_TBS
DATAFILE 'C:\app\niyon\product\21c\oradata\XE\tues_27715_yabesi_smartAgriDB\agri_idx01.dbf'
SIZE 50M AUTOEXTEND ON NEXT 5M MAXSIZE UNLIMITED;

-- temporary tablespace

CREATE TEMPORARY TABLESPACE AGRI_TEMP_TBS
TEMPFILE 'C:\app\niyon\product\21c\oradata\XE\tues_27715_yabesi_smartAgriDB\agri_temp01.dbf'
SIZE 50M AUTOEXTEND ON NEXT 5M MAXSIZE UNLIMITED;

-- 4. Enable Archive Logging
ALTER DATABASE ARCHIVELOG;


-- 6. Grant Privileges
GRANT CONNECT, RESOURCE, DBA TO admin_yabesi;


