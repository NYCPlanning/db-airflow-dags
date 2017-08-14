ALTER TABLE acs_facilities_daycareheadstart ADD COLUMN hash text;
UPDATE acs_facilities_daycareheadstart SET hash = md5(CAST((acs_facilities_daycareheadstart.*) AS text));
