ALTER TABLE hhs_facilities_fmscontracts ADD COLUMN hash text;
UPDATE hhs_facilities_fmscontracts SET hash = md5(CAST((hhs_facilities_fmscontracts.*) AS text));
