ALTER TABLE dot_facilities_bridgehouses ADD COLUMN hash text;
UPDATE dot_facilities_bridgehouses SET hash = md5(CAST((dot_facilities_bridgehouses.*) AS text));
