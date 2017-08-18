ALTER TABLE doe_facilities_lcgms ADD COLUMN hash text;
UPDATE doe_facilities_lcgms SET hash = md5(CAST((doe_facilities_lcgms.*) AS text));

ALTER TABLE doe_facilities_lcgms
ADD geom geometry;

-- based on PLUTO
UPDATE doe_facilities_lcgms a
SET geom=b.geom
FROM dcp_mappluto b
WHERE a.boroughblocklot = b.bbl::text;
