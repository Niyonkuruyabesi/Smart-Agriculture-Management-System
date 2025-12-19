-- 1.  Holiday Management Table

-- We need a table to store public holidays:

CREATE TABLE public_holidays (
    holiday_date DATE PRIMARY KEY,
    description VARCHAR2(100)
);

-- Example: Add some upcoming holidays
INSERT INTO public_holidays(holiday_date, description) VALUES (TO_DATE('2025-12-25','YYYY-MM-DD'),'Christmas Day');
INSERT INTO public_holidays(holiday_date, description) VALUES (TO_DATE('2025-01-01','YYYY-MM-DD'),'New Year');
COMMIT;
