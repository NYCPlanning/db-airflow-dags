ALTER TABLE dcp_facilities_pops ADD COLUMN hash text;
UPDATE dcp_facilities_pops SET hash = md5(CAST((dcp_facilities_pops.*) AS text));
