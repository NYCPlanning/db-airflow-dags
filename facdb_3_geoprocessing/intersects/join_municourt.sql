UPDATE facilities AS f
    SET
        municourt = p.municourt
    FROM
        dcp_municipalcourtdistricts AS p
    WHERE
        f.geom IS NOT NULL
        AND ST_Intersects(p.geom,f.geom)
