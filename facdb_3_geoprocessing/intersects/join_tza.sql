UPDATE facilities AS f
    SET
        tza = p.geoid10
    FROM
        dcp_trafficanalysiszones AS p
    WHERE
        f.geom IS NOT NULL
        AND ST_Intersects(p.geom,f.geom)
