UPDATE facilities AS f
    SET
        fireconum = p.fireconum,
        firebn = p.firebn,
        firediv = p.firediv
    FROM
        fdny_firecompanies AS p
    WHERE
        f.geom IS NOT NULL
        AND ST_Intersects(p.geom,f.geom)
