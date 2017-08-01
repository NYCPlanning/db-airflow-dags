from airflow.operators.BashOperator import BashOperator
from airflow.models import DAG
from datetime import datetime, timedelta

import data_sources

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime.today(),
    'email': ['jpichot@planning.nyc.gov'],
    'email_on_failure': True,
    'email_on_retry': False,
    'retries': 5,
    'retry_delay': timedelta(minutes=5),
}

# Data Loading Scripts
DAG_data_loader = DAG(
    'facdb_data_loader',
    default_args=default_args
)

for source in data_sources.facdb:
    task = BashOperator(
        task_id=source,
        bash_command="npm run get {0} --prefix=~/scripts/data-loader-scripts".format(source),
        dag=DAG_data_loader)


# FacDB controller dag
# dag_facdb = DAG(
#     'facdb',
#     default_args=default_args
# )
#
# t1 = BashOperator(
#     task_id='testairflow',
#     bash_command='cd ~/scripts/civic-data-loader/ && node loader get bic_facilities_tradewaste',
#     dag=dag
# )
