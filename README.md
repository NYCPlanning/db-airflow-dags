# cp-facdb-airflow
## Collection of Airflow DAGs, scripts, and SQL that generate the NYC Department of City Planning Facilities Database

This repo is a conversion of Capital Planning's original [facilities-db](https://github.com/NYCPlanning/facilities-db) js and sql
scripts for use in [Apache Airflow](https://airflow.incubator.apache.org/).

To understand this repo you'll need to understand Airflow, it's [conventions and concepts](https://airflow.incubator.apache.org/concepts.html)

`npm install` in

```
/download
/geoprocessing/geoclient
```

```

cd ./facdb_1_download
npm install

cd ./facbdb_3_geoprocessing/geoclient
npm install
```
## Todo
- Clean up `/tmp` directory and leftover databases after generation
- 
