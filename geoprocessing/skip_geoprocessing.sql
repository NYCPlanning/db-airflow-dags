UPDATE test AS f
SET
	addressnum = gl.addressnum,
	streetname = gl.streetname,
	address = gl.address,
	city = gl.city,
	boro = gl.boro,
	borocode = gl.borocode,
	zipcode = gl.zipcode,
	geom = gl.geom,
	latitude = gl.latitude,
	longitude = gl.longitude,
	xcoord = gl.xcoord,
	ycoord = gl.ycoord,
	bin = gl.bin,
	bbl = gl.bbl,
	commboard = gl.commboard,
	council = gl.council,
	censtract = gl.censtract,
	nta = gl.nta
FROM
	facdb_uid_geo_lookup AS gl
WHERE
	string_to_array(f.hash,';') @> ARRAY[gl.hash]


-- create table facdb_uid_geo_lookup AS (
-- select
-- uid,
-- hash,
-- addressnum,
-- streetname,
-- address,
-- city,
-- boro,
-- borocode,
-- zipcode,
-- geom,
-- latitude,
-- longitude,
-- xcoord,
-- ycoord,
-- bin,
-- bbl,
-- commboard,
-- council,
-- censtract,
-- nta
-- from copy_backup3)