ALTER TABLE dob_permits
  ADD COLUMN "bbl" text;

  UPDATE dob_permits SET bbl = CASE
    WHEN borough='MANHATTAN' THEN 1
    WHEN borough='BRONX' THEN 2
    WHEN borough='BROOKLYN' THEN 3
    WHEN borough='QUEENS' THEN 4
    WHEN borough='STATEN ISLAND' THEN 5
    ELSE 0
  END || block || RIGHT(lot,4)