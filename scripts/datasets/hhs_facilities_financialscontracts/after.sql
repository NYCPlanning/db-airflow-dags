ALTER TABLE hhs_facilities_financialscontracts ADD COLUMN hash text;
UPDATE hhs_facilities_financialscontracts SET hash = md5(CAST((hhs_facilities_financialscontracts.*) AS text));
