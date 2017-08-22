from airflow.models import DAG
from airflow.models import Variable

from airflow.operators.email_operator import EmailOperator
from airflow.operators.bash_operator import BashOperator
from airflow.operators.slack_operator import SlackAPIPostOperator

from datetime import datetime, timedelta

facdb_end = DAG(
    'facdb_end',
    schedule_interval=None,
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

bash_template = '''\
mkdir /var/www/html/facdb_{{ ds_nodash }}
cp /home/airflow/airflow/output/facdb/* /var/www/html/facdb_{{ ds_nodash }}
'''

move_and_rename = BashOperator(
    task_id='move_and_rename',
    dag=facdb_end,
    bash_command=bash_template
)

slack_msg = SlackAPIPostOperator(
    task_id='slack_msg',
    dag=facdb_end,
    channel='#capitalplanning-bots',
    username='Airflow',
    text='[FacDB] ⚡️ the datas have been engineered ⚡️',
    token=Variable.get('SLACK_TOKEN')
)

facdb_end >> move_and_rename >> slack_msg
