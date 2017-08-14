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
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

facdb_assembly = DAG(
    'facdb_assembly',
    schedule_interval='None',
    default_args=default_args
)

assembly_scripts_dir = "/home/airflow/airflow/dags/assembly/"

def sql_for_task(task_file):
    with open(assembly_scripts_dir + task_file, 'r') as sql_file:
        sql=sql_file.read().replace('\n', ' ')

## STEP 1
## create empty master table with facilities db schema
create_facdb = PostgresOperator(
    task_id='create_facdb',
    postgres_conn_id='facdb',
    sql=sql_for_task('create.sql'),
    dag=facdb_assembly
)

## STEP 2
## configure (transform) each dataset and insert into master table
for task_file in os.listdir(assembly_scripts_dir + "config"):
    PostgresOperator(
        task_id='insert_' + task_file[:-4],
        postgres_conn_id='facdb',
        sql=sql_for_task(task_file),
        dag=facdb_assembly
    )

## STEP 2
## configure (transform) each dataset and insert into master table
