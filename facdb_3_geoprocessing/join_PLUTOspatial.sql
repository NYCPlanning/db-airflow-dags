UPDATE facilities AS f
    SET
        bbl = ARRAY[ROUND(p.bbl,0)],
        boro = 
	        (CASE
	        	WHEN p.borough = 'MN' THEN 'Manhattan'
	        	WHEN p.borough = 'BX' THEN 'Bronx'
	        	WHEN p.borough = 'BK' THEN 'Brooklyn'
	        	WHEN p.borough = 'QN' THEN 'Queens'
	        	WHEN p.borough = 'SI' THEN 'Staten Island'
	        END),
        borocode = p.borocode,
        zipcode = p.zipcode,
        addressnum = 
        	(CASE
	        	WHEN f.addressnum IS NULL THEN initcap(split_part(p.address,' ',1))
	        	ELSE f.addressnum
        	END),
        streetname = 
        	(CASE
	        	WHEN f.addressnum IS NULL THEN initcap(trim(both ' ' from substr(trim(both ' ' from p.address), strpos(trim(both ' ' from p.address), ' ')+1, (length(trim(both ' ' from p.address))-strpos(trim(both ' ' from p.address), ' ')))))
	        	ELSE f.streetname
        	END),
        address = 
        	(CASE
	        	WHEN f.addressnum IS NULL THEN initcap(p.address)
	        	ELSE f.address
        	END),
        processingflag = 
        	(CASE
	        	WHEN f.addressnum IS NULL AND p.address IS NOT NULL THEN 'joinPLUTOspatial2address'
	        	ELSE 'joinPLUTOspatial'
        	END)
    FROM 
        dcp_mappluto AS p
    WHERE
        (f.bbl IS NULL
            OR f.addressnum IS NULL)
        AND f.geom IS NOT NULL
        AND ST_Intersects(p.geom,f.geom)
        AND processingflag IS NULL;
