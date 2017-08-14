-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS omb_facilities_libraryvisits;
CREATE TABLE omb_facilities_libraryvisits (
	name text,
	system text,
	bbl text,
	bin text,
	code text,
	borocode text,
	BoroName text,
	zip text,
	city text,
	housenum text,
	streetname text,
	CountyFIPS text,
	NTACode text,
	NTAName text,
	lat double precision,
	lon double precision,
	Visits double precision,
	Info text,
	acs_pop double precision
 )