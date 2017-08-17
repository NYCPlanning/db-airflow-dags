import os

from airflow.models import DAG
from airflow.operators.postgres_operator import PostgresOperator

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

facdb_assembly = DAG(
    'facdb_assembly',
    schedule_interval=None,
    default_args=default_args
)

## GENERATE TASKS

def pg_task(task_id):
    return PostgresOperator(
        task_id=task_id,
        postgres_conn_id='facdb',
        sql="/assembly/{0}.sql".format(task_id),
        dag=facdb_assembly
    )

create = pg_task('create')
create_bblbin_one2one = pg_task('create_bblbin_one2one')
create_uid = pg_task('create_uid')
join_sourcedatainfo = pg_task('join_sourcedatainfo')

def standardize_task(task_id):
    return PostgresOperator(
        task_id=task_id,
        postgres_conn_id='facdb',
        sql="/assembly/standardize/{0}.sql".format(task_id),
        dag=facdb_assembly
    )

standardize_fixallcaps = standardize_task('tandardize_fixallcaps')
standardize_capacity = standardize_task('standardize_capacity')
standardize_oversightlevel = standardize_task('standardize_oversightlevel')
standardize_agencytag = standardize_task('standardize_agencytag')
standardize_trim = standardize_task('standardize_trim')
standardize_factypes = standardize_task('standardize_factypes')
standardize_borough = standardize_task('standardize_borough')
standardize_address = standardize_task('standardize_address')


## configure (transform) each dataset and insert into master table
for task_file in os.listdir("/home/airflow/airflow/dags/assembly/config"):
    config = PostgresOperator(
        task_id=task_file[:-4],
        postgres_conn_id='facdb',
        sql="/assembly/config/" + task_file,
        dag=facdb_assembly
    )
    create_facdb >> config >> join_sourcedatainfo

(
    join_sourcedatainfo
    >> standardize_fixallcaps
    >> standardize_capacity
    >> standardize_oversightlevel
    >> standardize_agencytag
    >> standardize_trim
    >> standardize_factypes
    >> standardize_borough
    >> standardize_address
    >> create_bblbin_one2one
    >> create_uuid
)
