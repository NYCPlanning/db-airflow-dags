from airflow.models import DAG

from airflow.operators.bash_operator import BashOperator
from airflow.operators.email_operator import EmailOperator
from airflow.operators.dagrun_operator import TriggerDagRunOperator
from airflow.operators.sensors import ExternalTaskSensor

from datetime import datetime, timedelta

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2017, 7, 1),
    'email': ['jpichot@planning.nyc.gov'],
    'email_on_failure': True,
    'email_on_retry': False,
    'retries': 0,
    'retry_delay': timedelta(minutes=30),
}

facbdb_controller = DAG(
    'facbdb_controller',
    schedule_interval='@monthly',
    default_args=default_args
)

def yes_trigger(_, dag):
    return dag

trigger_email = EmailOperator(
    task_id='trigger_email',
    to=['jpichot@planning.nyc.gov'],
    subject='[Airflow] FacDB Generation Has Begun',
    html_content='⚡️ engineering the datas ⚡️',
    dag=facbdb_controller
)

# DAG run tasks
def dag_run(dag):
    return TriggerDagRunOperator(
        task_id=dag,
        trigger_dag_id=dag,
        python_callable=yes_trigger,
        depends_on_past=True,
        dag=facbdb_controller
    )

facdb_1_download = dag_run('facdb_1_download')
facdb_2_assembly = dag_run('facdb_2_assembly')
facdb_3_geoprocessing = dag_run('facdb_3_geoprocessing')
facdb_4_deduping = dag_run('facdb_4_deduping')
facdb_5_export = dag_run('facdb_5_export')

# DAG complete listen tasks
def dag_listen(dag):
    return ExternalTaskSensor(
        task_id=dag + "_listen",
        external_dag_id=dag,
        external_task_id=dag + "_complete"
    )

facdb_1_download_listen = dag_listen('facdb_1_download')
facdb_2_assembly_listen = dag_listen('facdb_2_assembly')
facdb_3_geoprocessing_listen = dag_listen('facdb_3_geoprocessing')
facdb_4_deduping_listen = dag_listen('facdb_4_deduping')
facdb_5_export_listen = dag_listen('facdb_5_export')

(
    facbdb_controller
    >> trigger_email

    >> facdb_1_download
    >> facdb_1_download_listen

    >> facdb_2_assembly
    >> facdb_2_assembly_listen

    >> facdb_3_geoprocessing
    >> facdb_3_geoprocessing_listen

    >> facdb_4_deduping
    >> facdb_4_deduping_listen

    >> facdb_5_export
    >> facdb_5_export_listen
)
