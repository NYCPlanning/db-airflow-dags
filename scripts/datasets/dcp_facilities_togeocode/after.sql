ALTER TABLE dcp_facilities_togeocode ADD COLUMN hash text;
UPDATE dcp_facilities_togeocode SET hash = md5(CAST((dcp_facilities_togeocode.*) AS text));
