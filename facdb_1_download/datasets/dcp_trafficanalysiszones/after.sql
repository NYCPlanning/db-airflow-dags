ALTER TABLE dcp_trafficanalysiszones ADD COLUMN geom geometry(Geometry, 4326);
UPDATE dcp_trafficanalysiszones SET geom = ST_Transform(wkb_geometry, 4326);
