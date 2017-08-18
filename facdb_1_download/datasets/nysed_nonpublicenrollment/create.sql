-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS nysed_nonpublicenrollment;
CREATE TABLE nysed_nonpublicenrollment (
	County text,
	BEDS_Code text,
	School_Name text,
	School_Type_Desc text,
	Affiliation text,
	PREK text,
	HALFK text,
	FULLK text,
	GR1 text,
	GR2 text,
	GR3 text,
	GR4 text,
	GR5 text,
	GR6 text,
	UGE text,
	GR7 text,
	GR8 text,
	GR9 text,
	GR10 text,
	GR11 text,
	GR12 text,
	UGS text
)