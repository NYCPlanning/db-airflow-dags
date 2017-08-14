ALTER TABLE dot_facilities_pedplazas ADD COLUMN hash text;
UPDATE dot_facilities_pedplazas SET hash = md5(CAST((dot_facilities_pedplazas.*) AS text));
