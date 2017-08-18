from airflow.models import DAG
from airflow.models import Variable
from airflow.operators.postgres_operator import PostgresOperator

# Define DAG
import default_dag_args
facdb_4_deduping = DAG(
    'facdb_4_deduping',
    schedule_interval=None,
    default_args=default_dag_args
)

## DEFINE TASKS
def pg_task(task_id):
    return PostgresOperator(
        task_id=task_id,
        postgres_conn_id='facdb',
        sql="/facdb_4_deduping/{0}.sql".format(task_id),
        dag=facdb_4_deduping
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

def removeFAKE(count):
    return PostgresOperator(
        task_id="removeFAKE_" + str(count),
        postgres_conn_id='facdb',
        sql="/facdb_4_deduping/duplicates_removeFAKE.sql",
        dag=facdb_4_deduping
    )

## DEDUPING

(
    facdb_4_deduping # The DAG kicks it off

    # Merge Child Care and Pre-K Duplicate records
    >> duplicates_ccprek_acs_hhs
    >> removeFAKE(0)
    >> duplicates_ccprek_doe_acs
    >> removeFAKE(1)
    >> duplicates_ccprek_doe_dohmh
    >> removeFAKE(2)
    >> duplicates_ccprek_acs_dohmh
    >> removeFAKE(3)
    >> duplicates_ccprek_dohmh
    >> removeFAKE(4)
    >> copy_backup4

    # Merging and dropping remaining duplicates, pre-COLP
    >> duplicates_remaining
    >> removeFAKE(6)

    # Merging and dropping remaining duplicates, pre-COLP
    >> duplicates_sfpsd_relatedlots
    >> removeFAKE(7)

    # Creating backup before merging and dropping COLP duplicates
    >> copy_backup5

    # Merging and dropping COLP duplicates by BIN
    >> duplicates_colp_bin
    # Cleaning up remaining dummy values used for array_agg
    >> removeFAKE(8)

    # Merging and dropping COLP duplicates by BBL
    >> duplicates_colp_bbl
    # Cleaning up remaining dummy values used for array_agg
    >> removeFAKE(9)

    # Merging related COLP duplicates on surrounding BBLs
    >> duplicates_colp_relatedlots_merged
    # Cleaning up remaining dummy values used for array_agg
    >> removeFAKE(10)

    # Merging remaining COLP duplicates on surrounding BBLs Part 1.
    >> duplicates_colp_relatedlots_colponly_p1
    # Cleaning up remaining dummy values used for array_agg
    >> removeFAKE(11)

    # Merging remaining COLP duplicates on surrounding BBLs Part 2
    >> duplicates_colp_relatedlots_colponly_p2
    # Cleaning up remaining dummy values used for array_agg
    >> removeFAKE(12)

    # Merge records that are exactly the same from the same data source
    >> duplicates_exactsame
    >> removeFAKE(13)

    # Cleaning up duplicates in BIN and BBl arrays
    >> removeArrayDuplicates

    >> copy_backup6
)
