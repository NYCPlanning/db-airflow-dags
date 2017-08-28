UPDATE facilities AS f
    SET
        schooldistrict = p.school_dist
    FROM
        dcp_school_districts AS p
    WHERE
        f.geom IS NOT NULL
        AND ST_Intersects(p.wkb_geometry, f.geom)
