ALTER TABLE nysed_facilities_activeinstitutions ADD COLUMN hash text;
UPDATE nysed_facilities_activeinstitutions SET hash = md5(CAST((nysed_facilities_activeinstitutions.*) AS text));
