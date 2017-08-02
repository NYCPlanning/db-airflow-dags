from airflow.operators.bash_operator import BashOperator
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
    get = BashOperator(
        task_id='get_' + source,
        bash_command="npm run get {0} --prefix=~/scripts/data-loader-scripts".format(source),
        dag=DAG_data_loader)

    preprocess = BashOperator(
        task_id='preprocess_' + source,
        bash_command="npm run preprocess {0} --prefix=~/scripts/data-loader-scripts".format(source),
        dag=DAG_data_loader)
    preprocess.set_upstream(get)

    push = BashOperator(
        task_id='push_' + source,
        bash_command="npm run push {0} --prefix=~/scripts/data-loader-scripts".format(source),
        dag=DAG_data_loader)
    push.set_upstream(preprocess)

    after = BashOperator(
        task_id='after_' + source,
        bash_command="npm run after {0} --prefix=~/scripts/data-loader-scripts".format(source),
        dag=DAG_data_loader)
    after.set_upstream(push)
