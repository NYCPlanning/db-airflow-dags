UPDATE facilities AS f
    SET
        geom = ST_Centroid(p.geom),
        processingflag = 
        	(CASE
	        	WHEN processingflag IS NULL THEN 'bin2overwritegeom'
	        	ELSE CONCAT(processingflag, '_bin2overwritegeom')
        	END)
    FROM
        doitt_buildingfootprints AS p        
    WHERE
        CONCAT(f.bin,f.bbl) = CONCAT(ARRAY[p.bin::text],ARRAY[p.bbl::text])
        AND f.bin IS NOT NULL
        AND f.processingflag NOT LIKE '%bin2overwritegeom%'
