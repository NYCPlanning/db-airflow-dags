from airflow.models import DAG
from airflow.models import Variable
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

facdb_deduping = DAG(
    'facdb_deduping',
    schedule_interval=None,
    default_args=default_args
)
