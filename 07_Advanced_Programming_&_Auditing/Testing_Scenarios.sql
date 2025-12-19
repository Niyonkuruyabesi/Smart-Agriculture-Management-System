--- 7. Testing Scenarios

--- Weekday INSERT (Denied)

INSERT INTO farms(farm_id,farm_name,location,farm_type)
VALUES (999,'TestFarm','TestLocation','Crop');

-- Should fail and log DENIED


--- Weekend INSERT (Allowed)

--- Public Holiday INSERT (Denied)

---  checking the audit log:

SELECT * FROM audit_log ORDER BY audit_id DESC;