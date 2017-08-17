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

## DEFINE TASKS
def pg_task(task_id):
    return PostgresOperator(
        task_id=task_id,
        postgres_conn_id='facdb',
        sql="/deduping/{0}.sql".format(task_id),
        dag=facdb_deduping
    )

copy_backup4 = pg_task('copy_backup4')
copy_backup5 = pg_task('copy_backup5')
copy_backup6 = pg_task('copy_backup6')

duplicates_ccprek_acs_hhs = pg_task('duplicates_ccprek_acs_hhs')
duplicates_ccprek_doe_acs = pg_task('duplicates_ccprek_doe_acs')
duplicates_ccprek_doe_dohmh = pg_task('duplicates_ccprek_doe_dohmh')
duplicates_ccprek_acs_dohmh = pg_task('duplicates_ccprek_acs_dohmh')
duplicates_ccprek_dohmh = pg_task('duplicates_ccprek_dohmh')
duplicates_remaining = pg_task('duplicates_remaining')
duplicates_sfpsd_relatedlots = pg_task('duplicates_sfpsd_relatedlots')
duplicates_colp_bin = pg_task('duplicates_colp_bin')
duplicates_colp_bbl = pg_task('duplicates_colp_bbl')
duplicates_colp_relatedlots_merged = pg_task('duplicates_colp_relatedlots_merged')
duplicates_colp_relatedlots_colponly_p1 = pg_task('duplicates_colp_relatedlots_colponly_p1')
duplicates_colp_relatedlots_colponly_p2 = pg_task('duplicates_colp_relatedlots_colponly_p2')
duplicates_exactsame = pg_task('duplicates_exactsame');

removeArrayDuplicates = pg_task('removeArrayDuplicates')

removeFAKE_count = 0
def removeFAKE():
    global removeFAKE_count
    return PostgresOperator(
        task_id="removeFAKE_" + str(removeFAKE_count),
        postgres_conn_id='facdb',
        sql="/deduping/removeFAKE.sql",
        dag=facdb_deduping
    )
    removeFAKE_count += 1

## DEDUPING

(
    facdb_deduping # The DAG kicks it off

    # Merge Child Care and Pre-K Duplicate records
    >> duplicates_ccprek_acs_hhs
    >> removeFAKE()
    >> duplicates_ccprek_doe_acs
    >> removeFAKE()
    >> duplicates_ccprek_doe_dohmh
    >> removeFAKE()
    >> duplicates_ccprek_acs_dohmh
    >> removeFAKE()
    >> duplicates_ccprek_dohmh
    >> removeFAKE()
    >> duplicates_removeFAKE
    >> removeFAKE()
    >> copy_backup4

    # Merging and dropping remaining duplicates, pre-COLP
    >> duplicates_remaining
    >> removeFAKE()

    # Merging and dropping remaining duplicates, pre-COLP
    >> duplicates_sfpsd_relatedlots
    >> removeFAKE()

    # Creating backup before merging and dropping COLP duplicates
    >> copy_backup5

    # Merging and dropping COLP duplicates by BIN
    >> duplicates_colp_bin
    # Cleaning up remaining dummy values used for array_agg
    >> removeFAKE()

    # Merging and dropping COLP duplicates by BBL
    >> duplicates_colp_bbl
    # Cleaning up remaining dummy values used for array_agg
    >> removeFAKE()

    # Merging related COLP duplicates on surrounding BBLs
    >> duplicates_colp_relatedlots_merged
    # Cleaning up remaining dummy values used for array_agg
    >> removeFAKE()

    # Merging remaining COLP duplicates on surrounding BBLs Part 1.
    >> duplicates_colp_relatedlots_colponly_p1
    # Cleaning up remaining dummy values used for array_agg
    >> removeFAKE()

    # Merging remaining COLP duplicates on surrounding BBLs Part 2
    >> duplicates_colp_relatedlots_colponly_p2
    # Cleaning up remaining dummy values used for array_agg
    >> removeFAKE()

    # Merge records that are exactly the same from the same data source
    >> duplicates_exactsame
    >> removeFAKE()

    # Cleaning up duplicates in BIN and BBl arrays
    >> removeArrayDuplicates

    >> copy_backup6
)
