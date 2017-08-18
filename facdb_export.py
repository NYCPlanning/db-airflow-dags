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

facdb_export = DAG(
    'facdb_export',
    schedule_interval=None,
    default_args=default_args
)

## DEFINE TASKS

def pg_task(task_id):
    return PostgresOperator(
        task_id=task_id,
        postgres_conn_id='facdb',
        params={
            "export_dir": "/home/airflow/airflow/output/facdb"
        },
        sql="/export/{0}.sql".format(task_id),
        dag=facdb_export
    )

censor = pg_task('censor')
export = pg_task('export')
export_allbeforemerging = pg_task('export_allbeforemerging')
export_unmapped = pg_task('export_unmapped')
export_datasources = pg_task('export_datasources')
export_uid_key = pg_task('export_uid_key')
mkdocs_datasources = pg_task('mkdocs_datasources')

## EXPORT ORDER

facdb_export >> censor
export << censor
export_allbeforemerging << censor
export_unmapped << censor
export_datasources << censor
export_uid_key << censor
mkdocs_datasources << censor
