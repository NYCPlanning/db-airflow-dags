UPDATE facilities AS f
    SET
        stateassemblydistrict = p.assemdist
    FROM
        dcp_stateassemblydistricts AS p
    WHERE
        f.geom IS NOT NULL
        AND ST_Intersects(p.geom,f.geom)
