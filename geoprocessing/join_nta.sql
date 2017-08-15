UPDATE facilities AS f
    SET
        nta = p.ntacode
    FROM 
        dcp_ntaboundaries AS p
    WHERE
        f.geom IS NOT NULL
        AND ST_Intersects(p.geom,f.geom)
