import os

from airflow.models import DAG
from airflow.operators.postgres_operator import PostgresOperator

from datetime import datetime, timedelta

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2017, 7, 1),
    'email': ['jpichot@planning.nyc.gov'],
    'email_on_failure': True,
    'email_on_retry': False,
    'retries': 0,
    'retry_delay': timedelta(minutes=5),
}

facdb_assembly = DAG(
    'facdb_assembly',
    schedule_interval=None,
    default_args=default_args
)

assembly_scripts_dir = "/home/airflow/airflow/dags/assembly/"

def sql_for_task(task_file):
    with open(assembly_scripts_dir + task_file, 'r') as sql_file:
        sql=sql_file.read().replace('\n', ' ')

## create empty master table with facilities db schema
create_facdb = PostgresOperator(
    task_id='create_facdb',
    postgres_conn_id='facdb',
    sql=sql_for_task('create.sql'),
    dag=facdb_assembly
)

## Joining on source data info and standardizing capitalization
join_sourcedatainfo = PostgresOperator(
    task_id='join_sourcedatainfo',
    postgres_conn_id='facdb',
    sql=sql_for_task('join_sourcedatainfo.sql'),
    dag=facdb_assembly
)

## configure (transform) each dataset and insert into master table
for task_file in os.listdir(assembly_scripts_dir + "config"):
    config = PostgresOperator(
        task_id=task_file[:-4],
        postgres_conn_id='facdb',
        sql=sql_for_task("config/" + task_file),
        dag=facdb_assembly
    )
    config << create_facdb
    config >> join_sourcedatainfo


## Cleaning up capitalization, standardizing values, and adding agency tags in arrays...
standardize_fixallcaps = PostgresOperator(
    task_id='standardize_fixallcaps',
    postgres_conn_id='facdb',
    sql=sql_for_task('standardize/standardize_fixallcaps.sql'),
    dag=facdb_assembly
)

standardize_capacity = PostgresOperator(
    task_id='standardize_capacity',
    postgres_conn_id='facdb',
    sql=sql_for_task('standardize/standardize_capacity.sql'),
    dag=facdb_assembly
)

standardize_oversightlevel = PostgresOperator(
    task_id='standardize_oversightlevel',
    postgres_conn_id='facdb',
    sql=sql_for_task('standardize/standardize_oversightlevel.sql'),
    dag=facdb_assembly
)

standardize_agencytag = PostgresOperator(
    task_id='standardize_agencytag',
    postgres_conn_id='facdb',
    sql=sql_for_task('standardize/standardize_agencytag.sql'),
    dag=facdb_assembly
)

standardize_trim = PostgresOperator(
    task_id='standardize_trim',
    postgres_conn_id='facdb',
    sql=sql_for_task('standardize/standardize_trim.sql'),
    dag=facdb_assembly
)

standardize_factypes = PostgresOperator(
    task_id='standardize_factypes',
    postgres_conn_id='facdb',
    sql=sql_for_task('standardize/standardize_factypes.sql'),
    dag=facdb_assembly
)

## Standardizing borough and assigning borough code
standardize_borough = PostgresOperator(
    task_id='standardize_borough',
    postgres_conn_id='facdb',
    sql=sql_for_task('standardize/standardize_borough.sql'),
    dag=facdb_assembly
)

## Switching One to 1 for geocoding and removing invalid (string) address numbers
standardize_address = PostgresOperator(
    task_id='standardize_address',
    postgres_conn_id='facdb',
    sql=sql_for_task('standardize/standardize_address.sql'),
    dag=facdb_assembly
)

join_sourcedatainfo >> standardize_fixallcaps
standardize_fixallcaps >> standardize_capacity
standardize_capacity >> standardize_oversightlevel
standardize_oversightlevel >> standardize_agencytag
standardize_agencytag >> standardize_trim
standardize_trim >> standardize_factypes
standardize_factypes >> standardize_borough
standardize_borough >> standardize_address
