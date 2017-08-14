ALTER TABLE nysdec_facilities_solidwaste ADD COLUMN hash text;
UPDATE nysdec_facilities_solidwaste SET hash = md5(CAST((nysdec_facilities_solidwaste.*) AS text));
