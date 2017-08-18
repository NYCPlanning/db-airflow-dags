UPDATE facilities AS f
    SET
        boro = p.boroname,
        borocode = p.borocode
    FROM 
        dcp_boroboundaries_wi AS p
    WHERE
        f.geom IS NOT NULL
        AND ST_Intersects(p.geom,f.geom)
        AND (boro IS NULL AND zipcode IS NULL)
