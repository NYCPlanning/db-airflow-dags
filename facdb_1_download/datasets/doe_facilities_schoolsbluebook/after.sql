ALTER TABLE doe_facilities_schoolsbluebook ADD COLUMN hash text;
UPDATE doe_facilities_schoolsbluebook SET hash = md5(CAST((doe_facilities_schoolsbluebook.*) AS text));
