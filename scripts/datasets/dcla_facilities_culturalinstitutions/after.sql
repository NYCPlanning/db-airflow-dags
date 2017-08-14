ALTER TABLE dcla_facilities_culturalinstitutions ADD COLUMN hash text;
UPDATE dcla_facilities_culturalinstitutions SET hash = md5(CAST((dcla_facilities_culturalinstitutions.*) AS text));
