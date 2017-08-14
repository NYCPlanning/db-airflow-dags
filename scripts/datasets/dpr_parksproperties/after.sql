ALTER TABLE dpr_parksproperties ADD COLUMN hash text;
UPDATE dpr_parksproperties SET hash = md5(CAST((dpr_parksproperties.*) AS text));
