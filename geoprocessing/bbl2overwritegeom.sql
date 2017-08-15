UPDATE facilities AS f
    SET
        geom = ST_Centroid(p.geom),
        processingflag = 
        	(CASE
	        	WHEN processingflag IS NULL THEN 'bbl2overwritegeom'
	        	ELSE CONCAT(processingflag, '_bbl2overwritegeom')
        	END)
    FROM
        dcp_mappluto AS p        
    WHERE
        f.bbl = ARRAY[ROUND(p.bbl,0)::text]
        AND f.bbl IS NOT NULL
        AND f.processingflag NOT LIKE '%bin2overwritegeom%'
        AND f.processingflag NOT LIKE '%bbl2overwritegeom%'
        AND f.hash NOT IN (
            SELECT facilities.hash
            FROM facilities
            INNER JOIN dcp_mappluto
            ON ST_Intersects (facilities.geom, dcp_mappluto.geom)
            WHERE facilities.geom IS NOT NULL)
