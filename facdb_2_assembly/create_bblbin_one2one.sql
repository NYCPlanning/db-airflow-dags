DROP TABLE IF EXISTS bblbin_one2one;
CREATE TABLE bblbin_one2one AS (
    WITH bincounts AS (
        SELECT
            p.*,
            count(f.*) AS numbins,
            array_agg(DISTINCT bin) AS bin
        FROM
            (SELECT bbl FROM dcp_mappluto) AS p,
            doitt_buildingfootprints AS f
        WHERE
            p.bbl = f.bbl::NUMERIC
            AND bin <> 5000000.0
            AND bin <> 4000000.0
            AND bin <> 3000000.0
            AND bin <> 2000000.0
            AND bin <> 1000000.0
        GROUP BY
            p.bbl
        ORDER BY
            numbins DESC
    )
    SELECT
        bbl,
        array_to_string(bin, ',') AS bin
    FROM
        bincounts
    WHERE
        numbins = 1
    ORDER BY
        bbl
)
