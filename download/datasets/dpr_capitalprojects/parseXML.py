import xmltodict
import shapely.geometry
import pandas as pd
import geopandas as gp
import subprocess
import os

# make sure we are at the top of the repo
wd = subprocess.check_output('git rev-parse --show-toplevel', shell = True)
os.chdir(wd[:-1]) #-1 removes \n

# XML parse
with open('./temp/dpr_capitalprojects/dpr_capitalprojects.xml') as fd:
    doc = xmltodict.parse(fd.read())

num_proj = len(doc['root']['capitalproject'])

# loop through projects
caps = []
for proj in list(range(num_proj)):
    proj_id = doc['root']['capitalproject'][proj]['TrackerID']
    fmsid = doc['root']['capitalproject'][proj]['FMSID']
    desc =  doc['root']['capitalproject'][proj]['Title']
    total_funding =  doc['root']['capitalproject'][proj]['TotalFunding']
    lonlats = []
    park_ids = []
    if type(doc['root']['capitalproject'][proj]['Locations']['Location']) is list:
        for loc in range(len(doc['root']['capitalproject'][proj]['Locations']['Location'])):
            lat = doc['root']['capitalproject'][proj]['Locations']['Location'][loc]['Latitude']
            lon = doc['root']['capitalproject'][proj]['Locations']['Location'][loc]['Longitude']
            park_id = doc['root']['capitalproject'][proj]['Locations']['Location'][loc]['ParkID']
            lonlats.append((float(lon), float(lat)))
            park_ids.append(park_id)
    else:
        lat = doc['root']['capitalproject'][proj]['Locations']['Location']['Latitude']
        lon = doc['root']['capitalproject'][proj]['Locations']['Location']['Longitude']
        park_id = doc['root']['capitalproject'][proj]['Locations']['Location']['ParkID']
        lonlats.append((float(lon), float(lat)))
        if park_id is None:
            park_id = 'NA'
        park_ids.append(park_id)    
    # parsed data combinations
    lonlats = shapely.geometry.MultiPoint(lonlats)
    park_ids = ','.join(p for p in park_ids)
    caps.append([proj_id, fmsid, desc, total_funding, park_ids, lonlats])

caps_df = gp.GeoDataFrame(caps,
                          columns = ['proj_id',
                                     'fmsid',
                                     'desc',
                                     'total_funding',
                                     'park_id',
                                     'geom'],
                          crs = {'init':'epsg:4326'},
                          geometry = 'geom'
                          )

# drop null geometries
caps_df_geo = caps_df[ [i[0].x < -70 for i in caps_df['geom']]]

# write to shapefile
caps_df_geo.to_file('./temp/dpr_capitalprojects/dpr_capitalprojects_geo.shp', driver = 'ESRI Shapefile')
caps_df.to_file('./temp/dpr_capitalprojects/dpr_capitalprojects.shp', driver = 'ESRI Shapefile')
