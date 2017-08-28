from airflow.models import DAG
from airflow.models import Variable
from airflow.operators.postgres_operator import PostgresOperator
from airflow.operators.dagrun_operator import TriggerDagRunOperator
from airflow.operators.bash_operator import BashOperator

# Define DAG
import defaults
facdb_3_geoprocessing = DAG(
    'facdb_3_geoprocessing',
    schedule_interval=None,
    default_args=defaults.dag_args
)

## TASK GENERATION
def pg_task(task_id):
    return PostgresOperator(
        task_id=task_id,
        postgres_conn_id='facdb',
        sql="/facdb_3_geoprocessing/{0}.sql".format(task_id),
        dag=facdb_3_geoprocessing
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
join_zipcode = pg_task('join_zipcode')
clean_invalidZIP = pg_task('clean_invalidZIP')
clean_cityboro = pg_task('clean_cityboro')
join_proptype = pg_task('join_proptype')
proptype_plazas = pg_task('proptype_plazas')
copy_backup3 = pg_task('copy_backup3')

# Generate the
def intersect_task(task_id):
    return PostgresOperator(
        task_id=task_id,
        postgres_conn_id='facdb',
        sql="/facdb_3_geoprocessing/intersects/{0}.sql".format(task_id),
        dag=facdb_3_geoprocessing
    )

join_cd = intersect_task('join_cd')
join_nta = intersect_task('join_nta')
join_council = intersect_task('join_council')
join_censtract = intersect_task('join_censtract')
join_congdist = intersect_task('join_congdist')
join_firecompanies = intersect_task('join_firecompanies')
join_municourt = intersect_task('join_municourt')
join_policeprecinct = intersect_task('join_policeprecinct')
join_stateassemblydistrict = intersect_task('join_stateassemblydistrict')
join_statesenatedistrict = intersect_task('join_statesenatedistrict')
join_taz = intersect_task('join_taz')
join_schooldistrict = intersect_task('join_schooldistrict')

intersect_tasks = [
    join_cd,
    join_nta,
    join_council,
    join_censtract,
    join_congdist,
    join_firecompanies,
    join_municourt,
    join_policeprecinct,
    join_stateassemblydistrict,
    join_statesenatedistrict,
    join_taz,
    join_schooldistrict
]

def intersect(start, finish):
    for intersect_task in intersect_tasks:
        start >> intersect_task >> finish

# Using sql from assembly process
standardize_address = PostgresOperator(
    task_id='standardize_address',
    postgres_conn_id='facdb',
    sql='/facdb_2_assembly/standardize/standardize_address.sql',
    dag=facdb_3_geoprocessing
)

def yes_trigger(_, dag):
    return dag

trigger_facdb_4_deduping = TriggerDagRunOperator(
    task_id='trigger_facdb_4_deduping',
    trigger_dag_id='facdb_4_deduping',
    python_callable=yes_trigger,
    dag=facdb_3_geoprocessing
)

## JS TASKS
connection_params = {
    "geoclient_id": Variable.get('GEOCLIENT_ID'),
    "geoclient_key": Variable.get('GEOCLIENT_KEY'),
    "db": "af_facdb",
    "db_user": "airflow",
    "db_pass": "airflow"
}

geoclient_boro = BashOperator(
    task_id='geoclient_boro',
    bash_command='npm run geoclient_boro --prefix=~/airflow/dags/facdb_3_geoprocessing/geoclient -- --db={{ params.db }} --db_user={{ params.db_user }} --db_pass={{ params.db_pass }} --geoclient_id={{ params.geoclient_id }} --geoclient_key={{ params.geoclient_key }}',
    params=connection_params,
    dag=facdb_3_geoprocessing
)

geoclient_zipcode = BashOperator(
    task_id='geoclient_zipcode',
    bash_command='npm run geoclient_zipcode --prefix=~/airflow/dags/facdb_3_geoprocessing/geoclient -- --db={{ params.db }} --db_user={{ params.db_user }} --db_pass={{ params.db_pass }} --geoclient_id={{ params.geoclient_id }} --geoclient_key={{ params.geoclient_key }}',
    params=connection_params,
    dag=facdb_3_geoprocessing
)

# TASK ORDER

(
    facdb_3_geoprocessing

    ## PREPPING DATA

    # Forcing 2D...
    >> force2D

    # Setting SRID, indexing, and vacuuming facilities and dcp_mappluto...
    >> setSRID_4326

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
    >> standardize_address
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
)

# Spatially joining with neighborhood boundaries...
intersect(start=calcxy, finish=join_zipcode)

(
    join_zipcode
    >> clean_invalidZIP
    >> clean_cityboro

    # Spatially joining with COLP bbls to get propertytype...
    >> join_proptype
    ## ^ In FacDB V1.5, will add conditional logic for type of facility

    # Setting propertytype for street plazas...
    >> proptype_plazas

    # Create backup table before merging and dropping duplicates
    >> copy_backup3

    # Signal complete
    >> trigger_facdb_4_deduping
)
