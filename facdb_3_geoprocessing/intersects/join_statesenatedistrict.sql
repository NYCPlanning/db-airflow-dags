UPDATE facilities AS f
    SET
        statesenatedistrict = p.stsendist
    FROM
        dcp_statesenatedistricts AS p
    WHERE
        f.geom IS NOT NULL
        AND ST_Intersects(p.geom,f.geom)
