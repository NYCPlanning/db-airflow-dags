from airflow.models import DAG
from airflow.operators.postgres_operator import PostgresOperator
from airflow.operators.bash_operator import BashOperator

from datetime import datetime, timedelta

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2017, 7, 1),
    # 'email': ['jpichot@planning.nyc.gov'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 0,
    'retry_delay': timedelta(minutes=5),
}

facdb_geoprocessing = DAG(
    'facdb_geoprocessing',
    schedule_interval=None,
    default_args=default_args
)

# Forcing 2D
force2D = PostgresOperator(
    task_id='force2D',
    postgres_conn_id='facdb',
    sql='/geoprocessing/force2D.sql',
    dag=facdb_geoprocessing
)

# Setting SRID, indexing, and vacuuming facilities and dcp_mappluto
setSRID_4326 = PostgresOperator(
    task_id='setSRID_4326',
    postgres_conn_id='facdb',
    sql='/geoprocessing/setSRID_4326.sql',
    dag=facdb_geoprocessing
)
setSRID_4326 << force2D

vacuum = PostgresOperator(
    task_id='vacuum',
    postgres_conn_id='facdb',
    sql='/geoprocessing/vacuum.sql',
    dag=facdb_geoprocessing
)
vacuum << setSRID_4326

# Spatial join with boroughs
join_boro_pregeoclient = PostgresOperator(
    task_id='join_boro_pregeoclient',
    postgres_conn_id='facdb',
    sql='/geoprocessing/join_boro_pregeoclient.sql',
    dag=facdb_geoprocessing
)
join_boro_pregeoclient << vacuum

## GEOCLIENT
## Run all records with addresses through GeoClient to get BBL, BIN, and lat/long if missing

# Running through GeoClient using address and borough
geoclient_boro = BashOperator(
    task_id='geoclient_boro',
    bash_command='node ./3_geoprocessing/geoclient_boro.js',
    dag=facdb_geoprocessing
) << join_boro_pregeoclient

# Running through GeoClient using address and zip code
geoclient_zipcode = BashOperator(
    task_id='geoclient_zipcode',
    bash_command='node ./3_geoprocessing/geoclient_zipcode.js',
    dag=facdb_geoprocessing
) << geoclient_boro

## Standardizing borough and assigning borough code again because
## Geoclient sometimes fills in Staten Is instead of Staten Island
