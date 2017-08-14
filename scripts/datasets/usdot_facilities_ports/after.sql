ALTER TABLE usdot_facilities_ports ADD COLUMN hash text;
UPDATE usdot_facilities_ports SET hash = md5(CAST((nav_unit_i,nav_unit_n,state_post,County_nam,zipcode::text,owners,operators) AS text));
