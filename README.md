# cp-facdb-airflow
_Collection of Airflow DAGs, scripts, and SQL that generate the NYC Department of City Planning Facilities Database_

This repo is a conversion of Capital Planning's original [facilities-db](https://github.com/NYCPlanning/facilities-db) js and sql
scripts for use in [Apache Airflow](https://airflow.incubator.apache.org/).  

To understand this repo you'll need to understand Airflow, it's [conventions and concepts](https://airflow.incubator.apache.org/concepts.html).  

We've packaged the DAGs and scripts together here for convenience. Depending on future development, scripts and DAGs may be split into different
repos.

## Preparation
Pull the latest changes in the DAG folder on the Airflow server.  

Next, download node modules necessary for 2 sets of scripts:
```
cd ./facdb_1_download
npm install

cd ./facbdb_3_geoprocessing/geoclient
npm install
```

## Todo
- Clean up `/tmp` directory and leftover databases after generation
- Put data on publicly accessible location
