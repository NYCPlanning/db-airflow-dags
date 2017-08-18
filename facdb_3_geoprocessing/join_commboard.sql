UPDATE facilities AS f
    SET
        commboard = p.borocd
    FROM 
        dcp_cdboundaries AS p
    WHERE
        f.geom IS NOT NULL
        AND ST_Intersects(p.geom,f.geom)
