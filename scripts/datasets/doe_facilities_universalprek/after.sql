ALTER TABLE doe_facilities_universalprek ADD COLUMN hash text;
UPDATE doe_facilities_universalprek SET hash = md5(CAST((doe_facilities_universalprek.*) AS text));
