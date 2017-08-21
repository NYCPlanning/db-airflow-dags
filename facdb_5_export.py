from airflow.models import DAG
from airflow.operators.postgres_operator import PostgresOperator
from airflow.operators.dagrun_operator import TriggerDagRunOperator

# Define DAG
import defaults
facdb_5_export = DAG(
    'facdb_5_export',
    schedule_interval=None,
    default_args=defaults.dag_args
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

def yes_trigger(_, dag):
    return dag

trigger_facdb_end = TriggerDagRunOperator(
    task_id='trigger_facdb_end',
    trigger_dag_id='facdb_end',
    python_callable=yes_trigger,
    dag=facdb_5_export
)

## EXPORT ORDER

facdb_5_export >> censor

censor >> export >> facdb_5_export_complete
censor >> export_allbeforemerging >> facdb_5_export_complete
censor >> export_unmapped >> facdb_5_export_complete
censor >> export_datasources >> facdb_5_export_complete
censor >> export_uid_key >> facdb_5_export_complete
censor >> mkdocs_datasources >> facdb_5_export_complete
