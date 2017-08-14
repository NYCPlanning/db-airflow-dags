ALTER TABLE dcas_facilities_colp ADD COLUMN hash text;
UPDATE dcas_facilities_colp SET hash = md5(CAST((dcas_facilities_colp.*) AS text));
