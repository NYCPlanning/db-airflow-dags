import os

from airflow.models import DAG
from airflow.models import Variable
from airflow.operators.bash_operator import BashOperator
from airflow.operators.postgres_operator import PostgresOperator

# Define DAG
import defaults
facdb_1_download = DAG(
    'facdb_1_download',
    schedule_interval=None,
    default_args=defaults.dag_args
)

# Scripts to Load
data_sources = [
    "facdb_datasources",
    "facdb_uid_key",
    "dcp_facilities_togeocode",

    # DCP Data Sources
    "dcp_mappluto",
    "dcp_boroboundaries_wi",
    "dcp_cdboundaries",
    "dcp_censustracts",
    "dcp_councildistricts",
    "dcp_ntaboundaries",
    "doitt_zipcodes",
    "doitt_buildingfootprints",

    # Outside Datasets
    "bic_facilities_tradewaste",
    "dca_facilities_operatingbusinesses",
    "dcla_facilities_culturalinstitutions",
    "dcp_facilities_sfpsd",
    "dcp_facilities_pops",
    "dfta_facilities_contracts",
    "doe_facilities_busroutesgarages",
    "doe_facilities_universalprek",
    "dohmh_facilities_daycare",
    "dpr_parksproperties",
    "hhc_facilities_hospitals",
    "nycha_facilities_policeservice",
    "nysdec_facilities_lands",
    "nysdec_facilities_solidwaste",
    "nysdoh_facilities_healthfacilities",
    "nysdoh_nursinghomebedcensus",
    "nysomh_facilities_mentalhealth",
    "nysopwdd_facilities_providers",
    "nysparks_facilities_historicplaces",
    "nysparks_facilities_parks",
    "usdot_facilities_airports",
    "usdot_facilities_ports",
    "usnps_facilities_parks",

    ## Other_datasets - PULLING FROM FTP SITE
    "acs_facilities_daycareheadstart",
    "dcas_facilities_colp",
    "dhs_facilities_shelters",
    "doe_facilities_schoolsbluebook",
    "dot_facilities_pedplazas",
    "dot_facilities_parkingfacilities",
    "dot_facilities_bridgehouses",
    "dot_facilities_ferryterminalslandings",
    "dot_facilities_mannedfacilities",
    "dsny_facilities_mtsgaragemaintenance",
    "foodbankny_facilities_foodbanks",
    "hhs_facilities_fmscontracts",
    "hhs_facilities_financialscontracts",
    "hhs_facilities_proposals",
    "nysoasas_facilities_programs", ## Being shared with us monthly by email in xlsx
    "nysed_facilities_activeinstitutions", ## Actually is open but need to figue out url
    "nysed_nonpublicenrollment", ## Actually is open but in xlsx that needs to be formatted
    "omb_facilities_libraryvisits",
    "dycd_facilities_compass",
    "dycd_facilities_otherprograms",
    "hra_facilities_centers",
    "sbs_facilities_workforce1",
]

# Loop over each download source, creating adding get, push, and after (if defined) tasks
for source in data_sources.facdb:
    params = {
        "source": source,
        "ftp_user": Variable.get('FTP_USER'),
        "ftp_pass": Variable.get('FTP_PASS'),
        "download_dir": Variable.get('DOWNLOAD_DIR'),
        "db": "af_facdb",
        "db_user": "airflow",
    }

    get = BashOperator(
        task_id='get_' + source,
        bash_command='npm run get {{ params.source }} --prefix=~/airflow/dags/facdb_1_download -- --ftp_user={{ params.ftp_user }} --ftp_pass={{ params.ftp_pass }} --download_dir={{ params.download_dir }}',
        params=params,
        dag=facdb_1_download)

    push = BashOperator(
        task_id='push_' + source,
        bash_command="npm run push {{ params.source }} --prefix=~/airflow/dags/facdb_1_download -- --db={{ params.db }} --db_user={{ params.db_user }} --download_dir={{ params.download_dir }}",
        params=params,
        dag=facdb_1_download)
    push.set_upstream(get)

    if os.path.isfile("/home/airflow/airflow/dags/facdb_1_download/datasets/{0}/after.sql".format(source)):
        after = PostgresOperator(
            task_id='after_' + source,
            postgres_conn_id='facdb',
            sql="/facdb_1_download/datasets/{0}/after.sql".format(source),
            dag=facdb_1_download
        )
        after.set_upstream(push)
