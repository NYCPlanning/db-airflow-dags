-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS bic_facilities_tradewaste;
CREATE TABLE bic_facilities_tradewaste (
  TYPE text,
  BUS_NAME text,
  MAILING_OFFICE text,
  MAIL_CITY text,
  MSTAT text,
  COMP_PHONE text,
  Location_1 text
)