from airflow.models import DAG
from airflow.models import Variable
from airflow.operators.postgres_operator import PostgresOperator
from airflow.operators.bash_operator import BashOperator

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

facdb_geoprocessing = DAG(
    'facdb_geoprocessing',
    schedule_interval=None,
    default_args=default_args
)

## TASK GENERATION
def pg_task(task_id):
    return PostgresOperator(
        task_id=task_id,
        postgres_conn_id='facdb',
        sql="/geoprocessing/{0}.sql".format(task_id),
        dag=facdb_geoprocessing
    )

force2D = pg_task('force2D')
setSRID_4326 = pg_task('setSRID_4326')
join_boro_pregeoclient = pg_task('join_boro_pregeoclient')
join_boro = pg_task('join_boro')
clean_invalidBIN = pg_task('clean_invalidBIN')
copy_backup1 = pg_task('copy_backup1')
join_PLUTOtabular = pg_task('join_PLUTOtabular')
join_PLUTOspatial = pg_task('join_PLUTOspatial')
bbl2bin = pg_task('bbl2bin')
copy_backup2 = pg_task('copy_backup2')
bin2overwritegeom = pg_task('bin2overwritegeom')
bbl2overwritegeom = pg_task('bbl2overwritegeom')
calcxy = pg_task('calcxy')
join_commboard = pg_task('join_commboard')
join_nta = pg_task('join_nta')
join_zipcode = pg_task('join_zipcode')
clean_invalidZIP = pg_task('clean_invalidZIP')
clean_cityboro = pg_task('clean_cityboro')
join_council = pg_task('join_council')
join_censtract = pg_task('join_censtract')
join_proptype = pg_task('join_proptype')
proptype_plazas = pg_task('proptype_plazas')
copy_backup3 = pg_task('copy_backup3')

def vacuum_task(vacuum_number=""):
    return PostgresOperator(
        task_id="vaccum_" + vacuum_number,
        postgres_conn_id='facdb',
        sql="/geoprocessing/vacuum.sql",
        dag=facdb_geoprocessing
    )

vacuum0 = vacuum_task("0")
vacuum1 = vacuum_task("1")
vacuum2 = vacuum_task("2")

# Using sql from assembly process
standardize_address = PostgresOperator(
    task_id='standardize_address',
    postgres_conn_id='facdb',
    sql='/assembly/standardize/standardize_address.sql',
    dag=facdb_geoprocessing
)

## JS TASKS
connection_params = {
    "geoclient_id": Variable.get('GEOCLIENT_ID'),
    "geoclient_key": Variable.get('GEOCLIENT_KEY'),
    "db": "af_facdb",
    "db_user": "airflow",
}

geoclient_boro = BashOperator(
    task_id='geoclient_boro',
    bash_command='npm geoclient_boro --prefix=~/airflow/dags/geoprocessing/geoclient -- --db={{ params.db }} --db_user={{ params.db_user }} --geosupport_id={{ params.geosupport_id }} --geosupport_key={{ params.geosupport_key }}',
    params=connection_params,
    dag=facdb_geoprocessing
)

geoclient_zipcode = BashOperator(
    task_id='geoclient_zipcode',
    bash_command='npm geoclient_zipcode --prefix=~/airflow/dags/geoprocessing/geoclient -- --db={{ params.db }} --db_user={{ params.db_user }} --geosupport_id={{ params.geosupport_id }} --geosupport_key={{ params.geosupport_key }}',
    params=connection_params,
    dag=facdb_geoprocessing
)

# TASK ORDER

(
    facdb_geoprocessing

    ## PREPPING DATA

    # Forcing 2D...
    >> force2D

    # Setting SRID, indexing, and vacuuming facilities and dcp_mappluto...
    >> setSRID_4326 >> vacuum0

    # Spatial join with boroughs...
    >> join_boro_pregeoclient
    ## This joins borough onto records that do not have borough or zip code already assigned. This distinction is important because some records came with coordinates that were the result of incorrect geocoding. There are records that have addresses that exist in multiple boroughs, and there are cases where a record comes with boro=Manhattan but it's coordinates are at the location at the same address that's in Brooklyn instead. We want to be careful to not override the borough values that were provided and should be skeptical of coordinates provided on the open data portal that were likely generated automatically without any QA/QC. We only want to fill in borough for the cases where no other borough or zipcode value was provided so we enable potential for finding matches in GeoClient what wouldn't be possible otherwise.

    ## GEOCLIENT

    ## Run all records with addresses through GeoClient to get BBL, BIN, and lat/long if missing
    # Running through GeoClient using address and borough...
    >> geoclient_boro

    # Running through GeoClient using address and zip code...
    >> geoclient_zipcode

    ## Standardizing borough and assigning borough code again because
    ## Geoclient sometimes fills in Staten Is instead of Staten Island
    >> join_boro >> clean_invalidBIN >> copy_backup1

    ## TABULAR JOIN WITH PLUTO FILLING IN MISSING ADDRESS INFO USING BBL WHEN GEOM EXISTS

    # Joining missing address info onto records using BBL...
    >> join_PLUTOtabular

    ## SPATIAL JOINS WITH PLUTO TO GET BBL AND OTHER MISSING INFO

    # Spatially joining with dcp_mappluto...
    >> join_PLUTOspatial

    # Done spatially joining with dcp_mappluto
    >> vacuum1 >> standardize_address
    # ^ need to clean up addresses again after filling in with PLUTO address

    ## FILLING IN REMAINING MISSING BINS

    # Filling in missing BINS where there is a 1-1 relationship between BBL and BIN...
    >> bbl2bin

    # Creating a backup copy before overwriting any geometries...
    >> copy_backup2

    # TABULAR JOINS WITH BUILDINGFOOTPRINTS AND PLUTO TO OVERWRITE GEOMS WITH CENTROID

    # Overwriting geometry using BIN centroid...
    >> bin2overwritegeom

    # Overwriting geometry using BBL centroid...
    >> bbl2overwritegeom

    ## Calculating lat,long and x,y for all blank records
    # Calculating x,y for all blank records...
    >> calcxy

    # Spatially joining with neighborhood boundaries...
    >> join_commboard >> join_nta >> join_zipcode >> clean_invalidZIP
    >> clean_cityboro >> join_council >> join_censtract

    # Spatially joining with COLP bbls to get propertytype...
    >> join_proptype
    ## ^ In FacDB V1.5, will add conditional logic for type of facility

    # Setting propertytype for street plazas...
    >> proptype_plazas >> vacuum2

    # Create backup table before merging and dropping duplicates
    >> copy_backup3
)
