-- -- CREATE KEY TABLE FOR FIRST TIME
-- -- make the key table
-- CREATE TABLE IF NOT EXISTS facdb_uid_key AS
-- SELECT hash FROM facilities;
-- -- add the serial id column
-- ALTER TABLE facdb_uid_key ADD COLUMN id SERIAL PRIMARY KEY;

-- AFTER ADDING NEW ROWS TO DATABASE, UPDATE KEY
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM facilities
WHERE hash NOT IN (
SELECT hash FROM facdb_uid_key
);
-- JOIN uid FROM KEY ONTO DATABASE
UPDATE facilities AS f
SET uid = k.uid
FROM facdb_uid_key AS k
WHERE k.hash = f.hash;
