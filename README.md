# db-airflow-dags
_Collection of Airflow DAGs, scripts, and SQL that generate databases managed by the NYC Department of City Planning_

This repo is a conversion of Capital Planning's original [facilities-db](https://github.com/NYCPlanning/facilities-db) js and sql
scripts for use in [Apache Airflow](https://airflow.incubator.apache.org/). It currently
only generates the [Facilities Database](http://docs.capitalplanning.nyc/facdb/), though will
eventually generate other databases.

To understand this repo you'll need to understand Airflow, it's [conventions and concepts](https://airflow.incubator.apache.org/concepts.html).  

## Preparation
Pull the latest changes in the DAG folder on the Airflow server.  

Next, download node modules necessary for 2 sets of scripts:
```
cd ./facdb_1_download
npm install

cd ./facbdb_3_geoprocessing/geoclient
npm install
```

You can test a specific task in a DAG by using Airflow's CLI. For example:
```
airflow test facdb_1_download dcas_facilities_fdny 2017-08-01
```
Note the date at the end of the command. This gives Airflow `start_date` for the DAG.
It's not relevant to our tasks but is required.

## FacDB

If a step has associated scripts, they exist in the directory of the same name. Eg. `facdb_1_download.py`
and `./facdb_1_download`.

### Start (`facdb_0_start.py`)
Kicks off generation with a Slack message. This is the only DAG scheduled to fire automatically
(currently monthly). Other FacDB DAGs are triggered by the preceding one.

### Download (`facdb_1_download.py`)
Runs a highly modified version of `civic-data-loader`, downloading all necessary datasets
to construct FacDB, pushes the data in Postgres, and optionally processes some data.

### Assembly (`facdb_2_assembly.py`)
Extracts the necessary columns from the raw data, transforming where needed. Makes significant
changes.

### Geoprocessing (`facdb_3_geoprocessing.py`)
Query's DCP's [Geoclient](https://developer.cityofnewyork.us/api/geoclient-api) endpoint, geocoding all facilities with missing locations.

### Deduping (`facdb_4_deduping.py`)
Attempts to identify and remove any duplicates.

### Export (`facdb_5_export.py`)
Exports data in final form, including ancillary and lookup tables.
- [ ] Copy db directly to cp-web, Carto

### End (`facdb_end.py`)
Moves and renames output files to permanent storage. Triggers goodbye Slack message and closes.

## Todo
- [ ]  Clean up `/tmp` directory and leftover databases after generation
- [ ]  Add version/date to db name
