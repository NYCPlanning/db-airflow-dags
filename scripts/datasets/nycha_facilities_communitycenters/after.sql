ALTER TABLE nycha_facilities_communitycenters ADD COLUMN hash text;
UPDATE nycha_facilities_communitycenters SET hash = md5(CAST((nycha_facilities_communitycenters.*) AS text));
