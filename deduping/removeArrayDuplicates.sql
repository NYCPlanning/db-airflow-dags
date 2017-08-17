-- Update BIN arrays with distinct BINs
WITH temp AS (
SELECT 
    hash, 
    unnest(BIN) AS BINs
FROM
    facilities as j
WHERE
    BIN IS NOT NULL
    AND BIN <> ARRAY['']),

temp2 AS (
SELECT
    hash,
    array_agg(distinct BINs) as BIN
FROM
    temp
GROUP BY 
    hash)

UPDATE facilities AS f
SET
    BIN = j.BIN
FROM
    temp2 AS j
WHERE f.hash = j.hash;


-- Update BBL arrays with distinct BBLs
WITH temp AS (
SELECT 
    hash, 
    unnest(BBL) AS BBLs
FROM
    facilities as j
WHERE
    BBL IS NOT NULL
    AND BBL <> ARRAY['']),

temp2 AS (
SELECT
    hash,
    array_agg(distinct BBLs) as BBL
FROM
    temp
GROUP BY 
    hash)

UPDATE facilities AS f
SET
    BBL = j.BBL
FROM
    temp2 AS j
WHERE f.hash = j.hash;

-- Update capacity type arrays with distinct units
WITH temp AS (
SELECT 
    hash, 
    unnest(captype) AS captypes
FROM
    facilities as j
WHERE
    captype IS NOT NULL
    AND captype <> ARRAY['']),

temp2 AS (
SELECT
    hash,
    array_agg(distinct captypes) as captype
FROM
    temp
GROUP BY 
    hash)

UPDATE facilities AS f
SET
    captype = j.captype
FROM
    temp2 AS j
WHERE f.hash = j.hash;

-- Update area type arrays with distinct units
WITH temp AS (
SELECT 
    hash, 
    unnest(areatype) AS areatypes
FROM
    facilities as j
WHERE
    areatype IS NOT NULL
    AND areatype <> ARRAY['']),

temp2 AS (
SELECT
    hash,
    array_agg(distinct areatypes) as areatype
FROM
    temp
GROUP BY 
    hash)

UPDATE facilities AS f
SET
    areatype = j.areatype
FROM
    temp2 AS j
WHERE f.hash = j.hash;

-- Update overtype arrays with distinct
WITH temp AS (
SELECT 
    hash, 
    unnest(overtype) AS overtypes
FROM
    facilities as j
WHERE
    overtype IS NOT NULL
    AND overtype <> ARRAY['']),

temp2 AS (
SELECT
    hash,
    array_agg(distinct overtypes) as overtype
FROM
    temp
GROUP BY 
    hash)

UPDATE facilities AS f
SET
    overtype = j.overtype
FROM
    temp2 AS j
WHERE f.hash = j.hash;

-- Update overlevel arrays with distinct
WITH temp AS (
SELECT 
    hash, 
    unnest(overlevel) AS overlevels
FROM
    facilities as j
WHERE
    overlevel IS NOT NULL
    AND overlevel <> ARRAY['']),

temp2 AS (
SELECT
    hash,
    array_agg(distinct overlevels) as overlevel
FROM
    temp
GROUP BY 
    hash)

UPDATE facilities AS f
SET
    overlevel = j.overlevel
FROM
    temp2 AS j
WHERE f.hash = j.hash;

-- Update overabbrev arrays with distinct
WITH temp AS (
SELECT 
    hash, 
    unnest(overabbrev) AS overabbrevs
FROM
    facilities as j
WHERE
    overabbrev IS NOT NULL
    AND overabbrev <> ARRAY['']),

temp2 AS (
SELECT
    hash,
    array_agg(distinct overabbrevs) as overabbrev
FROM
    temp
GROUP BY 
    hash)

UPDATE facilities AS f
SET
    overabbrev = j.overabbrev
FROM
    temp2 AS j
WHERE f.hash = j.hash;

-- Update overagency arrays with distinct
WITH temp AS (
SELECT 
    hash, 
    unnest(overagency) AS overagencys
FROM
    facilities as j
WHERE
    overagency IS NOT NULL
    AND overagency <> ARRAY['']),

temp2 AS (
SELECT
    hash,
    array_agg(distinct overagencys) as overagency
FROM
    temp
GROUP BY 
    hash)

UPDATE facilities AS f
SET
    overagency = j.overagency
FROM
    temp2 AS j
WHERE f.hash = j.hash;

-- Update datasource arrays with distinct
WITH temp AS (
SELECT 
    hash, 
    unnest(datasource) AS datasources
FROM
    facilities as j
WHERE
    datasource IS NOT NULL
    AND datasource <> ARRAY['']),

temp2 AS (
SELECT
    hash,
    array_agg(distinct datasources) as datasource
FROM
    temp
GROUP BY 
    hash)

UPDATE facilities AS f
SET
    datasource = j.datasource
FROM
    temp2 AS j
WHERE f.hash = j.hash;

-- Update dataname arrays with distinct
WITH temp AS (
SELECT 
    hash, 
    unnest(dataname) AS datanames
FROM
    facilities as j
WHERE
    dataname IS NOT NULL
    AND dataname <> ARRAY['']),

temp2 AS (
SELECT
    hash,
    array_agg(distinct datanames) as dataname
FROM
    temp
GROUP BY 
    hash)

UPDATE facilities AS f
SET
    dataname = j.dataname
FROM
    temp2 AS j
WHERE f.hash = j.hash;

-- Update dataurl arrays with distinct
WITH temp AS (
SELECT 
    hash, 
    unnest(dataurl) AS dataurls
FROM
    facilities as j
WHERE
    dataurl IS NOT NULL
    AND dataurl <> ARRAY['']),

temp2 AS (
SELECT
    hash,
    array_agg(distinct dataurls) as dataurl
FROM
    temp
GROUP BY 
    hash)

UPDATE facilities AS f
SET
    dataurl = j.dataurl
FROM
    temp2 AS j
WHERE f.hash = j.hash;

-- Update datadate arrays with distinct
WITH temp AS (
SELECT 
    hash, 
    unnest(datadate) AS datadates
FROM
    facilities as j
WHERE
    datadate IS NOT NULL
    AND datadate <> ARRAY['']),

temp2 AS (
SELECT
    hash,
    array_agg(distinct datadates) as datadate
FROM
    temp
GROUP BY 
    hash)

UPDATE facilities AS f
SET
    datadate = j.datadate
FROM
    temp2 AS j
WHERE f.hash = j.hash;

-- Update pgtable arrays with distinct
WITH temp AS (
SELECT 
    hash, 
    unnest(pgtable) AS pgtables
FROM
    facilities as j
WHERE
    pgtable IS NOT NULL
    AND pgtable <> ARRAY['']),

temp2 AS (
SELECT
    hash,
    array_agg(distinct pgtables) as pgtable
FROM
    temp
GROUP BY 
    hash)

UPDATE facilities AS f
SET
    pgtable = j.pgtable
FROM
    temp2 AS j
WHERE f.hash = j.hash;