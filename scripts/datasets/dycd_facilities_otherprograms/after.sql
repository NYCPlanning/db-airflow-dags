ALTER TABLE dycd_facilities_otherprograms ADD COLUMN hash text;
UPDATE dycd_facilities_otherprograms SET hash = md5(CAST((dycd_facilities_otherprograms.*) AS text));
