ALTER TABLE dot_facilities_ferryterminalslandings ADD COLUMN hash text;
UPDATE dot_facilities_ferryterminalslandings SET hash = md5(CAST((dot_facilities_ferryterminalslandings.*) AS text));
