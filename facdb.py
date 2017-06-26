from airflow.operators import BashOperator
from airflow.models import DAG
from datetime import datetime, timedelta

seven_days_ago = datetime.combine(datetime.today() - timedelta(7),
                                  datetime.min.time())

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': seven_days_ago,
    'email': ['jpichot@planning.nyc.gov'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    'simple',
    default_args=default_args
)

t1 = BashOperator(
    task_id='testairflow',
    bash_command='cd ~/scripts/civic-data-loader/ && node loader get bic_facilities_tradewaste',
    dag=dag
)
