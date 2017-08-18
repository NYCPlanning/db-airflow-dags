ALTER TABLE dcp_mappluto ALTER COLUMN geom TYPE Geometry(MultiPolygon, 4326) USING ST_Transform(geom, 4326);
ALTER TABLE doitt_buildingfootprints ALTER COLUMN geom TYPE Geometry(MultiPolygon, 4326) USING ST_Transform(geom, 4326);
ALTER TABLE facilities ALTER COLUMN geom TYPE Geometry(Point, 4326) USING ST_Transform(geom, 4326);

DROP INDEX IF EXISTS dcp_mappluto_x;
CREATE INDEX dcp_mappluto_x ON dcp_mappluto USING GIST (geom);
DROP INDEX IF EXISTS doitt_buildingfootprints_x;
CREATE INDEX doitt_buildingfootprints_x ON doitt_buildingfootprints USING GIST (geom);
DROP INDEX IF EXISTS facilities_x;
CREATE INDEX facilities_x ON facilities USING GIST (geom);
