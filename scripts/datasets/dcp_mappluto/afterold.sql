DROP TABLE IF EXISTS dcp_mappluto;
CREATE TABLE dcp_mappluto AS 
SELECT * FROM mnmappluto
UNION ALL
SELECT * FROM bxmappluto
UNION ALL
SELECT * FROM qnmappluto
UNION ALL
SELECT * FROM bkmappluto
UNION ALL
SELECT * FROM simappluto;

DROP TABLE mnmappluto;
DROP TABLE bxmappluto;
DROP TABLE qnmappluto;
DROP TABLE bkmappluto;
DROP TABLE simappluto;