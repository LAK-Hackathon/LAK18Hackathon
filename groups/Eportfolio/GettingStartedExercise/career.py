# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

#### Imports 

import pandas as pd
import numpy as np

#### Read in data from Monster and select a job title
#### Note, the sample data needs to be in the same working directory to load.

data = pd.read_csv('sample.csv')
job = 'Sales Executive'

career = data.loc[data.loc[:,'JobTitle'] == job,:]

#### Get the locations of the jobs from the pandas dataframe
#### and drop any null values, also reset the index of the series.
location = career.loc[:, 'City']
location.dropna(inplace = True)
location.reset_index(drop = True, inplace = True)

#### Convert the locations to latitude and longitude using geopy.

from geopy.geocoders import Nominatim
geolocator = Nominatim(scheme='http')
loc_log_lat = np.zeros((location.shape[0],2))

for i, loc in location.iteritems():
    destination = geolocator.geocode(loc)
    loc_log_lat[i, 0] = destination.latitude
    loc_log_lat[i, 1] = destination.longitude


#### Plot the longitude and latitude on google maps as a density plot.

import gmplot

gmap = gmplot.GoogleMapPlotter.from_geocode("UK")
gmap.heatmap(loc_log_lat[:,0], loc_log_lat[:,1], radius = 50)
gmap.draw("mymap.html")

