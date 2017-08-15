ALTER TABLE dcp_facilities_sfpsd ADD COLUMN hash text;
UPDATE dcp_facilities_sfpsd SET hash = md5(CAST((dcp_facilities_sfpsd.*) AS text));
