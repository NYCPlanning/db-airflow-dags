ALTER TABLE nysparks_facilities_parks ADD COLUMN hash text;
UPDATE nysparks_facilities_parks SET hash = md5(CAST((nysparks_facilities_parks.*) AS text));
