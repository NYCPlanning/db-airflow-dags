UPDATE facilities AS f
    SET
        censtract = p.ct2010
    FROM 
        dcp_censustracts AS p
    WHERE
        f.geom IS NOT NULL
        AND ST_Intersects(p.geom,f.geom)
