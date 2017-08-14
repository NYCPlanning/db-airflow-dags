ALTER TABLE omb_facilities_libraryvisits ADD COLUMN hash text;
UPDATE omb_facilities_libraryvisits SET hash = md5(CAST((omb_facilities_libraryvisits.*) AS text));
