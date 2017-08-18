ALTER TABLE dfta_facilities_contracts ADD COLUMN hash text;
UPDATE dfta_facilities_contracts SET hash = md5(CAST((dfta_facilities_contracts.*) AS text));
