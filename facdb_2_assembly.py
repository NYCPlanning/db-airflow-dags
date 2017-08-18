import os

from airflow.models import DAG
from airflow.operators.dummy_operator import DummyOperator
from airflow.operators.postgres_operator import PostgresOperator

# Define DAG
import defaults
facdb_2_assembly = DAG(
    'facdb_2_assembly',
    schedule_interval=None,
    default_args=defaults.dag_args
)

## GENERATE TASKS

def pg_task(task_id):
    return PostgresOperator(
        task_id=task_id,
        postgres_conn_id='facdb',
        sql="/facdb_2_assembly/{0}.sql".format(task_id),
        dag=facdb_2_assembly
    )

create = pg_task('create')
create_bblbin_one2one = pg_task('create_bblbin_one2one')
create_uid = pg_task('create_uid')
join_sourcedatainfo = pg_task('join_sourcedatainfo')

def standardize_task(task_id):
    return PostgresOperator(
        task_id=task_id,
        postgres_conn_id='facdb',
        sql="/facdb_2_assembly/standardize/{0}.sql".format(task_id),
        dag=facdb_2_assembly
    )

standardize_fixallcaps = standardize_task('standardize_fixallcaps')
standardize_capacity = standardize_task('standardize_capacity')
standardize_oversightlevel = standardize_task('standardize_oversightlevel')
standardize_agencytag = standardize_task('standardize_agencytag')
standardize_trim = standardize_task('standardize_trim')
standardize_factypes = standardize_task('standardize_factypes')
standardize_borough = standardize_task('standardize_borough')
standardize_address = standardize_task('standardize_address')

facdb_2_assembly_complete = DummyOperator(
    task_id='facdb_2_assembly_complete',
    dag=facdb_2_assembly
)

## ORDER TASKS

facdb_2_assembly >> create

for task_file in os.listdir("/home/airflow/airflow/dags/facdb_2_assembly/config"):
    config = PostgresOperator(
        task_id=task_file[:-4],
        postgres_conn_id='facdb',
        sql="/facdb_2_assembly/config/" + task_file,
        dag=facdb_2_assembly
    )
    create >> config >> join_sourcedatainfo

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
    >> create_uid
    >> facdb_2_assembly_complete
)
