ALTER TABLE nysoasas_facilities_programs ADD COLUMN hash text;
UPDATE nysoasas_facilities_programs SET hash = md5(CAST((nysoasas_facilities_programs.*) AS text));
