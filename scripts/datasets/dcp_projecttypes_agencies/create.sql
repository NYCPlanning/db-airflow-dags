-- create table to load csv 
DROP TABLE IF EXISTS dcp_projecttypes_agencies;

CREATE TABLE dcp_projecttypes_agencies(
    projecttype text,
    tycs text,
    agencyname text,
    agencyabbrev text,
    agencycode text,
    agencyacronym text,
    agency text,
    projecttypeabbrev text
    )
