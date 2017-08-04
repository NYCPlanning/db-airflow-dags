import os

from airflow.operators.postgres_operator import PostgresOperator
from airflow.models import DAG
from datetime import datetime, timedelta

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime.today(),
    'email': ['jpichot@planning.nyc.gov'],
    'email_on_failure': True,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

facdb_assembly = DAG(
    'facdb_assembly',
    default_args=default_args
)

insert_dir = "/home/airflow/scripts/facilities-db/2_assembly/insert"
for file in os.listdir(insert_dir):
    if file.endswith(".sql"):
        PostgresOperator(
            task_id='insert_' + file[:-4],
            postgres_conn_id='postgres_default',
            sql=os.path.join(insert_dir, file),
            dag=facdb_assembly)
