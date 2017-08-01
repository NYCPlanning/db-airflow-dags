from airflow.operators import BashOperator
from airflow.models import DAG
from datetime import datetime, timedelta

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

for db in ["facdb_datasources", "facdb_uid_key", "dcp_facilities_togeocode"]:
    task = BashOperator(
        task_id='facdB_data_loader_' + db,
        bash_command="npm run get {0} --prefix=~/scripts/data-loader-scripts".format(db),
        dag=dag)


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
