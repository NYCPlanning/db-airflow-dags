ALTER TABLE foodbankny_facilities_foodbanks ADD COLUMN hash text;
UPDATE foodbankny_facilities_foodbanks SET hash = md5(CAST((foodbankny_facilities_foodbanks.*) AS text));
