UPDATE facilities AS f
    SET
        zipcode = 
        	(CASE
        		WHEN p.zipcode::integer <> 83::integer THEN p.zipcode::integer
        		ELSE f.zipcode
        	END),
        city = p.po_name
    FROM 
        doitt_zipcodes AS p
    WHERE
        (f.geom IS NOT NULL
        AND ST_Intersects(p.geom,f.geom))
        OR f.zipcode = p.zipcode::integer
