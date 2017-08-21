from airflow.models import DAG
from airflow.models import Variable

from airflow.operators.dagrun_operator import TriggerDagRunOperator
from airflow.operators.slack_operator import SlackAPIPostOperator

from datetime import datetime, timedelta

facdb_0_start = DAG(
    'facdb_0_start',
    schedule_interval='@monthly',
    default_args={
        'owner': 'airflow',
        'depends_on_past': False,
        'start_date': datetime(2017, 7, 1),
        'email': ['jpichot@planning.nyc.gov'],
        'email_on_failure': True,
        'email_on_retry': False,
        'retries': 0,
    }
)

trigger_slack = SlackAPIPostOperator(
    task_id='trigger_slack',
    dag=facdb_0_start,
    channel='#capitalplanning-bots',
    username='Airflow',
    text='[FacDB] ♻️ engineering the datas ♻️',
    token=Variable.get('SLACK_TOKEN')
)

def yes_trigger(_, dag):
    return dag

trigger_facdb_run = TriggerDagRunOperator(
    task_id='trigger_facdb_run',
    trigger_dag_id='facdb_1_download',
    python_callable=yes_trigger,
    dag=facdb_0_start
)

# Task Order

(
    facdb_0_start
    >> trigger_slack
    >> trigger_facdb_run
)
