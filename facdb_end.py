from airflow.models import DAG

from airflow.operators.email_operator import EmailOperator

from datetime import datetime, timedelta

facdb_end = DAG(
    'facdb_end',
    schedule_interval='@monthly',
    default_args={
        'owner': 'airflow',
        'depends_on_past': False,
        'start_date': datetime(2017, 7, 1),
        'email': ['jpichot@planning.nyc.gov'],
        'email_on_failure': True,
        'email_on_retry': False,
        'retries': 0,
        'retry_delay': timedelta(minutes=30),
    }
)
