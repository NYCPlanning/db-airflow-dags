ALTER TABLE facddb_togeocode ADD COLUMN hash text;
UPDATE facddb_togeocode SET hash = md5(CAST((facddb_togeocode.*) AS text));