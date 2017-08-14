ALTER TABLE sbs_facilities_workforce1 ADD COLUMN hash text;
UPDATE sbs_facilities_workforce1 SET hash = md5(CAST((sbs_facilities_workforce1.*) AS text));
