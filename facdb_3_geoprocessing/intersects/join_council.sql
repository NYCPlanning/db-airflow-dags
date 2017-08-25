UPDATE facilities AS f
    SET
        council = p.coundist
    FROM 
        dcp_councildistricts AS p
    WHERE
        f.geom IS NOT NULL
        AND ST_Intersects(p.geom,f.geom)
