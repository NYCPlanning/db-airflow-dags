from airflow.operators.bash_operator import BashOperator
from airflow.models import DAG
from airflow.models import Variable
from airflow.utils.file import TemporaryDirectory

from datetime import datetime, timedelta

import data_sources

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime.today(),
    'email': ['jpichot@planning.nyc.gov'],
    'email_on_failure': True,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Data Loading Scripts
facbdb_download = DAG(
    'facdb_download',
    default_args=default_args
)

for source in data_sources.facdb:
    get = BashOperator(
        task_id='get_' + source,
        bash_command='npm run get {{ params.source }} --prefix=~/scripts/data-loading-scripts -- --ftp_user={{ params.ftp_user }} --ftp_pass={{ params.ftp_pass }} --download_dir=./temp',
        params={
            "source": source,
            "ftp_user": Variable.get('FTP_USER'),
            "ftp_pass": Variable.get('FTP_PASS')
        }
        dag=facbdb_download)

    preprocess = BashOperator(
        task_id='preprocess_' + source,
        bash_command="npm run preprocess {0} --prefix=~/scripts/data-loading-scripts".format(source),
        dag=facbdb_download)
    preprocess.set_upstream(get)

    push = BashOperator(
        task_id='push_' + source,
        bash_command="npm run push {0} --prefix=~/scripts/data-loading-scripts".format(source),
        dag=facbdb_download)
    push.set_upstream(preprocess)

    after = BashOperator(
        task_id='after_' + source,
        bash_command="npm run after {0} --prefix=~/scripts/data-loading-scripts".format(source),
        dag=facbdb_download)
    after.set_upstream(push)
