from airflow.models import DAG
from airflow.operators.postgres_operator import PostgresOperator

from datetime import datetime, timedelta

# Define DAG
import default_dag_args
facdb_5_export = DAG(
    'facdb_5_export',
    schedule_interval=None,
    default_args=default_dag_args
)

## DEFINE TASKS

def pg_task(task_id):
    return PostgresOperator(
        task_id=task_id,
        postgres_conn_id='facdb',
        params={
            "export_dir": "/home/airflow/airflow/output/facdb"
        },
        sql="/facdb_5_export/{0}.sql".format(task_id),
        dag=facdb_5_export
    )

censor = pg_task('censor')
export = pg_task('export')
export_allbeforemerging = pg_task('export_allbeforemerging')
export_unmapped = pg_task('export_unmapped')
export_datasources = pg_task('export_datasources')
export_uid_key = pg_task('export_uid_key')
mkdocs_datasources = pg_task('mkdocs_datasources')

## EXPORT ORDER

facdb_5_export >> censor
export << censor
export_allbeforemerging << censor
export_unmapped << censor
export_datasources << censor
export_uid_key << censor
mkdocs_datasources << censor
