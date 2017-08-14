ALTER TABLE bic_facilities_tradewaste ADD COLUMN hash text;
UPDATE bic_facilities_tradewaste SET hash = md5(CAST((bic_facilities_tradewaste.*) AS text));
