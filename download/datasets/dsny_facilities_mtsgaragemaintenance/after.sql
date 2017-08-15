ALTER TABLE dsny_facilities_mtsgaragemaintenance ADD COLUMN hash text;
UPDATE dsny_facilities_mtsgaragemaintenance SET hash = md5(CAST((dsny_facilities_mtsgaragemaintenance.*) AS text));
