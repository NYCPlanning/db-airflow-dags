ALTER TABLE nysomh_facilities_mentalhealth ADD COLUMN hash text;
UPDATE nysomh_facilities_mentalhealth SET hash = md5(CAST((nysomh_facilities_mentalhealth.*) AS text));
