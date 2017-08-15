ALTER TABLE usnps_facilities_parks ADD COLUMN hash text;
UPDATE usnps_facilities_parks SET hash = md5(CAST((usnps_facilities_parks.*) AS text));
