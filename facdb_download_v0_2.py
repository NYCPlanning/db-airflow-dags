from airflow.operators.bash_operator import BashOperator
from airflow.operators.email_operator import EmailOperator
from airflow.models import DAG
from airflow.models import Variable
from airflow.utils.file import TemporaryDirectory

from datetime import datetime, timedelta

import data_sources

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'schedule_interval': '@monthly',
    'start_date': datetime(2017, 7, 1),
    'email': ['jpichot@planning.nyc.gov'],
    'email_on_failure': True,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Data Loading Scripts
facbdb_download = DAG(
    'facdb_download_v0_2',
    default_args=default_args
)

email_started = EmailOperator(
    task_id='email_on_trigger',
    to=['jpichot@planning.nyc.gov'],
    subject='[Airflow] FacDB Download Triggered',
    html_content='FacDB Download DAG triggered',
    dag=facbdb_download
)

for source in data_sources.facdb:
    get = BashOperator(
        task_id='get_' + source,
        bash_command='npm run get {{ params.source }} --prefix=~/scripts/data-loading-scripts -- --ftp_user={{ params.ftp_user }} --ftp_pass={{ params.ftp_pass }} --download_dir=./temp',
        params={
            "source": source,
            "ftp_user": Variable.get('FTP_USER'),
            "ftp_pass": Variable.get('FTP_PASS')
        },
        dag=facbdb_download)
    get.set_upstream(email_started)

    push = BashOperator(
        task_id='push_' + source,
        bash_command="npm run push {{ params.source }} --prefix=~/scripts/data-loading-scripts -- --db={{ params.db }} --db_user={{ params.db_user }} --download_dir=./temp",
        params={
            "source": source,
            "db": "af_facdb",
            "db_user": "airflow",
        },
        dag=facbdb_download)
    push.set_upstream(get)

    after = BashOperator(
        task_id='after_' + source,
        bash_command="npm run after {0} --prefix=~/scripts/data-loading-scripts".format(source),
        dag=facbdb_download)
    after.set_upstream(push)
