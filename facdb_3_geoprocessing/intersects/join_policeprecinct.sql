UPDATE facilities AS f
    SET
        policeprecinct = p.precinct
    FROM
        nypd_policeprecincts AS p
    WHERE
        f.geom IS NOT NULL
        AND ST_Intersects(p.geom,f.geom)
