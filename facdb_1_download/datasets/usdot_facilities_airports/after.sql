ALTER TABLE usdot_facilities_airports ADD COLUMN hash text;
UPDATE usdot_facilities_airports SET hash = md5(CAST((usdot_facilities_airports.*) AS text));
