-- create table to load csv 
DROP TABLE IF EXISTS dcp_agencylookup;
CREATE TABLE dcp_agencylookup(
    facdb_level text,
    facdb_agencyname_revised text,
    facdb_agencyname text,
    facdb_agencyabbrev text,
    cape_agencycode text,
    cape_agencyacronym text,
    cape_agency text
    )
