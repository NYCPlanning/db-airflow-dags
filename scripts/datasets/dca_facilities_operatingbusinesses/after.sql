ALTER TABLE dca_facilities_operatingbusinesses ADD COLUMN hash text;
UPDATE dca_facilities_operatingbusinesses SET hash = md5(CAST((dca_facilities_operatingbusinesses.*) AS text));
