ALTER TABLE dot_facilities_publicparking ADD COLUMN hash text;
UPDATE dot_facilities_publicparking SET hash = md5(CAST((dot_facilities_publicparking.*) AS text));
